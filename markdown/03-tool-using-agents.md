# Module 7 - AI Agents for Data Engineering
# Session 3: Tool-Using Agents

## What We're Building Today

In Sessions 1 and 2, you built conversational agents. Today we're making agents that **DO things** - they generate code, create files, produce actual deliverables.

**By the end of this session:**
- ✓ Understand the difference between chatting and tool use
- ✓ Build agents that generate SQL queries
- ✓ Create data validation code generators
- ✓ Produce production-ready outputs

---

## Quick Recap: Conversational vs Tool-Using Agents

**Conversational Agent (Sessions 1-2):**
- Answers questions
- Provides explanations
- Gives advice
- Remembers context

**Tool-Using Agent (Today):**
- Generates code
- Creates files
- Produces deliverables
- Executes specific tasks

**The shift:** From "tell me about X" to "build me X"

---

## Part 1: Your First Tool-Using Agent

Let's start simple - a function that wraps an LLM call to generate something specific.


```python
# Setup
from google.colab import userdata
import google.generativeai as genai
from IPython.display import Markdown, display

genai.configure(api_key=userdata.get('GEMINI_API_KEY'))

# Gemini with Gemma 3 model as a backup
#LLM_MODEL = 'models/gemma-3-12b-it'
LLM_MODEL = 'gemini-2.5-flash-lite'
TEMPERATURE = 0.7
```

### Example: SQL Query Generator

Instead of asking "how do I query this?", we'll create a tool that GENERATES the query for us.


```python
def generate_sql_query(table_name, requirements):
    """
    Generate a SQL query based on natural language requirements.
    
    Args:
        table_name: The table to query
        requirements: What you need in plain English
    
    Returns:
        SQL query as a string
    """
    
    system_prompt = f"""You are a SQL query generator.
    
    Generate ONLY the SQL query with no explanations or markdown.
    Use standard SQL that works across major databases.

    Table: {table_name}
    Requirements: {requirements}

    Output just the SQL query, properly formatted.
    """
    
    model = genai.GenerativeModel(
        LLM_MODEL,
        generation_config=genai.GenerationConfig(temperature=TEMPERATURE)
    )
    response = model.generate_content(system_prompt)
    
    # Clean up the response (remove markdown if present)
    sql = response.text.strip()
    sql = sql.replace('```sql', '').replace('```', '').strip()
    
    return sql

# Test it
query = generate_sql_query(
    table_name="customers",
    requirements="Get all customers from London who joined in 2024, show name and email"
)

print("Generated SQL:")
print("="*80)
print(query)
print("="*80)
print("\n✓ Ready to copy and paste into your database!")
```

### 🔍 What Just Happened?

We created a **function** that:
1. Takes structured input (table name, requirements)
2. Calls the LLM with specific instructions
3. Returns clean, usable output (SQL query)

**This is a tool-using agent!**

It's not chatting - it's producing a deliverable.

---

## 🎯 Activity: Test the SQL Generator

Try different scenarios:


```python
# Test 1: Simple query
query1 = generate_sql_query(
    table_name="orders",
    requirements="Count how many orders each customer made"
)
print("Test 1 - Aggregation:")
print(query1)
```


```python
# Test 2: JOIN query
query2 = generate_sql_query(
    table_name="orders JOIN customers",
    requirements="Get customer names and their total order value where value > 1000"
)
print("Test 2 - JOIN with filter:")
print(query2)
```


```python
# Test 3: Your own scenario
# TODO: Add a real scenario from your work
query3 = generate_sql_query(
    table_name="YOUR_TABLE",
    requirements="YOUR REQUIREMENTS"
)
print("Test 3 - Your scenario:")
print(query3)
```

---

## Part 2: Interactive Tool Interface

Let's make this easier to use with an interactive interface:


```python
print("="*80)
print("🛠️  SQL QUERY GENERATOR")
print("="*80)
print("Describe what you need and get SQL code!")
print("Type 'quit' to exit\n")
print("="*80 + "\n")

while True:
    # Get table name
    table = input("Table name (or table1 JOIN table2): ")
    if table.lower() == 'quit':
        print("\n👋 Thanks for using SQL Generator!")
        break
    
    # Get requirements
    requirements = input("What do you need? ")
    if requirements.lower() == 'quit':
        print("\n👋 Thanks for using SQL Generator!")
        break
    
    # Generate query
    print("\n🔄 Generating SQL...\n")
    try:
        sql = generate_sql_query(table, requirements)
        
        print("✓ Generated SQL:")
        print("-"*80)
        print(sql)
        print("-"*80)
        print("\n📋 Copy the query above and test it in your database!\n")
        print("="*80 + "\n")
    except Exception as e:
        print(f"❌ Error: {e}\n")
        print("Try rephrasing your requirements.\n")
```

---

## Part 3: Build Your Own Tool-Using Agent

Now it's your turn! Choose one of these tools to build:

### Option 1: Data Quality Validation Generator
**What it does:** Generates Python code to validate datasets

**Input:** Dataset description, validation requirements  
**Output:** Python code with validation checks

### Option 2: SQL Query Explainer
**What it does:** Takes a SQL query and explains it line by line

**Input:** SQL query  
**Output:** Detailed explanation of what the query does

### Option 3: ETL Pipeline Pseudocode Generator
**What it does:** Creates pipeline design from requirements

**Input:** Source/target description, transformation needs  
**Output:** Step-by-step pipeline pseudocode

### Option 4: Data Type Converter
**What it does:** Generates code to convert between data types

**Input:** Current format, target format, sample data  
**Output:** Python code to perform conversion

### Option 5: Test Data Generator
**What it does:** Creates sample datasets for testing

**Input:** Schema description, number of rows  
**Output:** Python code to generate realistic test data

---

## 🎯 Template: Build Your Tool

Use this template to build your chosen tool:


```python
def my_tool_function(param1, param2):
    """
    [DESCRIBE WHAT YOUR TOOL DOES]
    
    Args:
        param1: [DESCRIPTION]
        param2: [DESCRIPTION]
    
    Returns:
        [WHAT IT RETURNS]
    """
    
    system_prompt = f"""[YOUR SYSTEM PROMPT]
    
You are a [ROLE].

Generate ONLY [WHAT TO GENERATE] with no explanations.

Input 1: {param1}
Input 2: {param2}

Output [FORMAT REQUIREMENTS]."""
    
    model = genai.GenerativeModel(
        LLM_MODEL,
        generation_config=genai.GenerationConfig(temperature=TEMPERATURE)
    )
    response = model.generate_content(system_prompt)
    
    # Clean up response if needed
    output = response.text.strip()
    
    return output

# Test your tool
result = my_tool_function(
    param1="TEST_VALUE_1",
    param2="TEST_VALUE_2"
)

print("Tool Output:")
print("="*80)
print(result)
#display(Markdown(result))
print("="*80)
```

---

## Example 1: Data Quality Validation Generator

Here's a complete example if you chose this option:


```python
def generate_data_quality_checks(dataset_description, validation_requirements):
    """
    Generate Python code to validate a dataset.
    
    Args:
        dataset_description: Description of the dataset structure
        validation_requirements: What needs to be validated
    
    Returns:
        Python code as a string
    """
    
    system_prompt = f"""You are a Data Quality Engineer.

Generate Python code using pandas to validate data quality.

Dataset: {dataset_description}
Validation Requirements: {validation_requirements}

Output ONLY Python code with:
1. Import statements
2. Validation functions
3. Clear comments
4. Print statements showing results

No explanations, just working Python code."""
    
    model = genai.GenerativeModel(
        LLM_MODEL,
        generation_config=genai.GenerationConfig(temperature=TEMPERATURE)
    )
    response = model.generate_content(system_prompt)
    
    code = response.text.strip()
    code = code.replace('```python', '').replace('```', '').strip()
    
    return code

# Test it
validation_code = generate_data_quality_checks(
    dataset_description="Customer table with columns: customer_id (int), email (string), age (int), country (string)",
    validation_requirements="Check for: null values, duplicate customer_ids, invalid emails, ages outside 18-120 range"
)

print("Generated Validation Code:")
print("="*80)
print(validation_code)
print("="*80)
```

---

## Example 2: SQL Query Explainer

Another complete example:


```python
def explain_sql_query(sql_query):
    """
    Explain a SQL query in plain English, line by line.
    
    Args:
        sql_query: The SQL query to explain
    
    Returns:
        Detailed explanation as a string
    """
    
    system_prompt = f"""You are a SQL Expert Teacher.

    Explain this SQL query in clear, simple terms.

    Format your explanation as:
    1. Overall purpose (one sentence)
    2. Line-by-line breakdown
    3. Key points to understand
    4. Potential performance considerations

    Query to explain:
    {sql_query}

    Make it clear for someone learning SQL."""
    
    model = genai.GenerativeModel(
        LLM_MODEL,
        generation_config=genai.GenerationConfig(temperature=TEMPERATURE)
    )
    response = model.generate_content(system_prompt)
    
    return response.text

# Test it with a complex query
complex_query = """
SELECT c.customer_name, COUNT(o.order_id) as order_count, SUM(o.total_amount) as total_spent
FROM customers c
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
WHERE c.country = 'UK'
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_spent DESC
LIMIT 10
"""

explanation = explain_sql_query(complex_query)

print("SQL Explanation:")
print("="*80)
#print(explanation)
display(Markdown(explanation))
print("="*80)
```

---

## 🎯 Activity: Build and Test Your Tool

**Time: 30 minutes**

**Steps:**
1. Choose which tool you're building (or create your own)
2. Write the function using the template
3. Test with 3-5 different scenarios
4. Refine the system prompt based on results
5. Add an interactive interface if time allows

**Success criteria:**
- ✓ Function runs without errors
- ✓ Output is clean and usable
- ✓ Produces production-ready code/content
- ✓ Handles different scenarios appropriately

Use the cell below to build your tool:


```python
# BUILD YOUR TOOL HERE
# Copy the template from above and customize it

# Your function


# Your tests


# Your interactive interface (optional)

```

---

## Part 4: Enhance Your Tool

Now let's make your tool more robust and useful.

### Enhancement 1: Error Handling

Add proper error handling:


```python
def generate_sql_query_enhanced(table_name, requirements):
    """
    Enhanced SQL generator with error handling.
    """
    
    # Validation
    if not table_name or not requirements:
        return "Error: Both table name and requirements are needed."
    
    try:
        system_prompt = f"""You are a SQL query generator.
        
        Generate ONLY the SQL query with no explanations.

        Table: {table_name}
        Requirements: {requirements}

        If the requirements are unclear or impossible, return 'ERROR: [reason]'."""
        
        model = genai.GenerativeModel(
            LLM_MODEL,
            generation_config=genai.GenerationConfig(temperature=TEMPERATURE)
        )
        response = model.generate_content(system_prompt)
        
        sql = response.text.strip()
        sql = sql.replace('```sql', '').replace('```', '').strip()
        
        # Check if it's an error
        if sql.startswith('ERROR:'):
            return sql
        
        return sql
        
    except Exception as e:
        return f"Error generating query: {str(e)}"

# Test error handling
print("Test 1 - Valid input:")
print(generate_sql_query_enhanced("users", "get all active users"))
print("\n")

print("Test 2 - Invalid input:")
print(generate_sql_query_enhanced("", ""))
print("\n")

print("Test 3 - Unclear requirements:")
print(generate_sql_query_enhanced("things", "do stuff"))
```

### Enhancement 2: Multi-Step Processing

Sometimes you need multiple LLM calls to build something complex:


```python
def generate_complete_data_pipeline(requirements):
    """
    Generate a complete data pipeline with multiple steps.
    Uses multiple LLM calls for different parts.
    """
    
    model = genai.GenerativeModel(
        LLM_MODEL,
        generation_config=genai.GenerationConfig(temperature=TEMPERATURE)
    )
    
    # Step 1: Generate extraction SQL
    print("🔄 Step 1: Generating extraction query...")
    extraction_prompt = f"""Generate a SQL query to extract data based on:
    {requirements}
    
    Output ONLY the SQL query."""
    
    extraction_sql = model.generate_content(extraction_prompt).text.strip()
    extraction_sql = extraction_sql.replace('```sql', '').replace('```', '').strip()
    
    # Step 2: Generate transformation Python code
    print("🔄 Step 2: Generating transformation code...")
    transform_prompt = f"""Based on this extracted data:
    {extraction_sql}
    
    Generate Python code using pandas to:
    1. Clean the data
    2. Handle missing values
    3. Create calculated columns if needed
    
    Output ONLY Python code."""
    
    transform_code = model.generate_content(transform_prompt).text.strip()
    transform_code = transform_code.replace('```python', '').replace('```', '').strip()
    
    # Step 3: Generate load SQL
    print("🔄 Step 3: Generating load statement...")
    load_prompt = """Generate a SQL INSERT statement to load transformed data 
    into a target table. Output ONLY the SQL."""
    
    load_sql = model.generate_content(load_prompt).text.strip()
    load_sql = load_sql.replace('```sql', '').replace('```', '').strip()
    
    # Combine everything
    pipeline = f"""# Complete ETL Pipeline

## 1. EXTRACT
{extraction_sql}

## 2. TRANSFORM
{transform_code}

## 3. LOAD
{load_sql}
"""
    
    print("✓ Pipeline generated!\n")
    return pipeline

# Test it
pipeline = generate_complete_data_pipeline(
    "Extract sales data from last month, calculate totals by region, load into summary table"
)

print(pipeline)
```

---

## 🎯 Final Challenge: Production-Ready Tool

Take your tool and make it production-ready:

**Requirements:**
1. ✓ Error handling for invalid inputs
2. ✓ Clear user interface
3. ✓ Multiple test cases passing
4. ✓ Documentation (docstrings)
5. ✓ Clean, usable output

**Bonus features:**
- Save output to file
- Validate generated code
- Multiple output formats
- Logging of generations

Use the cell below:


```python
# YOUR PRODUCTION-READY TOOL
# Include all enhancements

def my_production_tool():
    """
    [YOUR TOOL DESCRIPTION]
    """
    pass

# Interactive interface with error handling


# Tests demonstrating it works

```

---

## 📊 Session 3 Summary

**What you've learned:**

✓ **Tool-Using Agents** - Functions that wrap LLM calls for specific tasks  
✓ **Code Generation** - Producing SQL, Python, and other code  
✓ **Interactive Interfaces** - Making tools easy to use  
✓ **Error Handling** - Building robust, production-ready tools  
✓ **Multi-Step Processing** - Combining multiple LLM calls  

**What you've built:**

1. SQL query generator
2. Your chosen specialized tool
3. Production-ready tool with enhancements

---

## 🔗 Real-World Applications

**These tools are immediately useful in your work:**

**Development:**
- Generate boilerplate code
- Create test data
- Build validation scripts

**Documentation:**
- Explain existing queries
- Generate technical specs
- Create pipeline documentation

**Quality Assurance:**
- Generate test cases
- Create validation rules
- Build monitoring checks

**Training:**
- Generate examples for junior team members
- Create learning materials
- Build interactive tutorials

---

## 🚀 Next Session Preview

**Session 4: Advanced Patterns**

We'll explore:
- Multi-agent systems (agents working together)
- RAG patterns (connecting agents to documentation)
- Conversation persistence (saving and loading chats)
- Custom workflows

**Preparation:**
Think about how two agents could work together to solve a complex data engineering problem.

---

## 💾 Save Your Tools!

**File → Save a copy in Drive**

These are tools you can actually use in your work!

---

## 🤔 Reflection Questions

Before finishing:

1. **What's the most useful tool you built today?**

2. **How would you integrate this into your daily workflow?**

3. **What other code-generation tasks could benefit from this approach?**

4. **How does this change your view of AI as a productivity tool?**

5. **What would you build if you had unlimited time?**

Discuss with a colleague or prepare to share in Session 4!

---

**Excellent work! You've built tools that generate actual, usable code.** 🎉

**See you in Session 4 where we'll combine agents to build even more powerful systems!**
