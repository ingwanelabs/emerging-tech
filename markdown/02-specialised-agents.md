# Module 7 - AI Agents for Data Engineering
# Session 2: Specialised Agents with System Prompts

## What We're Building Today

In Session 1, you built a general conversational agent. Today we're making it **specialised** for specific data engineering tasks.

**By the end of this session:**
- ✓ Understand system prompts and how they shape agent behaviour
- ✓ Create a specialised data engineering agent
- ✓ Use examples to improve response quality
- ✓ Build an agent useful for your actual work

---

## Quick Recap: Where We Left Off

In Session 1, we built this:

```python
model = genai.GenerativeModel(LLM_MODEL)
chat = model.start_chat(history=[])
response = chat.send_message("Your question here")
```

**Problem:** This agent is generic. It doesn't "know" it's supposed to help data engineers specifically.

**Solution:** System prompts!

---

## Part 1: Understanding System Prompts

A **system prompt** (also called system instruction) tells the LLM:
- Who it is
- What it's good at
- How it should respond
- What style to use

Think of it as the agent's "job description" or "persona".


```python
# First, let's set up our imports and API key
from google.colab import userdata
import google.generativeai as genai
from IPython.display import Markdown, display

genai.configure(api_key=userdata.get('GEMINI_API_KEY'))

# Gemini with Gemma 3 model as a backup
#LLM_MODEL = 'models/gemma-3-12b-it'
LLM_MODEL = 'gemini-2.5-flash-lite'

TEMPERATURE = 0.7
```

### Example: Generic vs Specialised

Let's see the difference between a generic agent and a specialised one.


```python
# Generic agent - no system prompt
generic_model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE)
)

response = generic_model.generate_content(
    "How do I check for duplicates in my data?"
)

print("GENERIC AGENT:")
print("="*80)
display(Markdown(response.text))
print("\n")
```


```python
# Specialised agent - with system prompt
specialised_system_prompt = """You are a Data Engineering Assistant specialising in SQL and Python.

Your expertise includes:
- SQL query writing and optimisation
- Data quality and validation
- ETL pipeline design
- Python data processing with pandas

When answering questions:
- Provide working code examples
- Explain the approach briefly
- Focus on practical, production-ready solutions
- Use clear variable names
"""

specialised_model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=specialised_system_prompt
)

response = specialised_model.generate_content(
    "How do I check for duplicates in my data?"
)

print("SPECIALISED AGENT:")
print("="*80)
display(Markdown(response.text))
```

### 🔍 Notice the Difference?

The specialised agent:
- Asks clarifying questions (SQL or Python?)
- Provides code examples
- Focuses on data engineering context
- Uses appropriate technical terminology

The generic agent gives a broader, less focused answer.

**This is the power of system prompts!**

---

## Part 2: Design Your Specialised Agent

Now it's your turn. You're going to create an agent specialised for a specific data engineering task.

### Choose Your Agent Type:

Pick ONE that would be most useful for your work:

**Option 1: SQL Query Helper**
- Explains SQL queries
- Suggests optimisations
- Helps write complex queries
- Identifies performance issues

**Option 2: Data Quality Checker**
- Suggests validation rules
- Generates data quality checks
- Identifies common quality issues
- Creates Python validation code

**Option 3: ETL Troubleshooting Assistant**
- Helps debug pipeline failures
- Suggests error handling approaches
- Identifies common ETL issues
- Recommends solutions

**Option 4: Database Design Advisor**
- Helps with schema design
- Suggests normalisation approaches
- Recommends indexes
- Advises on data types

**Option 5: Python Data Processing Helper**
- Assists with pandas operations
- Helps with data transformations
- Suggests efficient approaches
- Debugs data processing code

**Decision time:** Which one did you choose? Make a note!

---

## 🎯 Activity: Build Your System Prompt

Use this template to create your system prompt:


```python
# Template for your specialised agent
# TODO: Fill in the sections below based on your chosen agent type

my_system_prompt = """You are a [YOUR AGENT TYPE HERE].

Your expertise includes:
- [SKILL 1]
- [SKILL 2]
- [SKILL 3]
- [SKILL 4]

When answering questions:
- [GUIDELINE 1]
- [GUIDELINE 2]
- [GUIDELINE 3]
- [GUIDELINE 4]

Your responses should be:
- [CHARACTERISTIC 1]
- [CHARACTERISTIC 2]
- [CHARACTERISTIC 3]
"""

# Create your model
my_model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=my_system_prompt
)

print("✓ Your specialised agent is created!")
print("\nYour system prompt:")
print("="*80)
print(my_system_prompt)
```

### Example: SQL Query Helper

Here's a complete example if you chose SQL Query Helper:


```python
my_system_prompt = """You are a SQL Query Optimisation Expert for data engineers.

Your expertise includes:
- Writing efficient SQL queries for large datasets
- Identifying performance bottlenecks
- Suggesting appropriate indexes
- Optimising JOIN operations and subqueries

When answering questions:
- Always provide the SQL code
- Explain WHY the approach is better
- Point out common mistakes to avoid
- Consider both readability and performance

Your responses should be:
- Practical and ready to use
- Focused on real-world data engineering scenarios
- Include performance considerations
- Use standard SQL that works across major databases
"""

my_model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=my_system_prompt
)

# Test it
response = my_model.generate_content(
    "I need to find customers who made purchases in both 2023 and 2024. "
    "I have a purchases table with customer_id and purchase_date."
)

display(Markdown(response.text))
```

---

## 🎯 Activity: Test Your Agent

Now test your specialised agent with 3-5 questions relevant to its purpose.

**Testing strategy:**
1. Start with a simple question
2. Ask a follow-up that requires context
3. Try an edge case or tricky scenario
4. Ask for code examples
5. Test with a real problem from your work

Document what works well and what doesn't!


```python
# Create a chat with your specialised agent
my_chat = my_model.start_chat(history=[])

print("="*80)
print(f"🤖 YOUR SPECIALISED AGENT")
print("="*80)
print("Ask questions related to your agent's expertise")
print("Type 'quit' to exit and see your conversation summary")
print("="*80 + "\n")

# Keep track of the conversation for review
conversation_log = []

while True:
    user_input = input("You: ")
    
    if user_input.lower() in ['quit', 'exit', 'done']:
        print("\n" + "="*80)
        print("📊 CONVERSATION SUMMARY")
        print("="*80)
        print(f"Total questions asked: {len(conversation_log)}")
        print("\nYour questions were:")
        for i, q in enumerate(conversation_log, 1):
            print(f"{i}. {q}")
        print("\n✓ Great testing! Review the responses above.")
        break
    
    conversation_log.append(user_input)
    
    try:
        response = my_chat.send_message(user_input)
        print(f"\n🤖 Agent:\n")
        display(Markdown(response.text))
        print("-"*80 + "\n")
    except Exception as e:
        print(f"Error: {e}\n")
```

---

## Part 3: Enhance with Examples

System prompts are powerful, but we can make them even better by including **examples** of the kind of responses we want.

This technique is called **few-shot prompting** - we "show" the agent what good responses look like.

### Why Use Examples?

- Demonstrates the exact format you want
- Shows the level of detail expected
- Guides the tone and style
- Reduces need for trial and error

### Example: Before and After

**Without Examples:**


```python
basic_prompt = """You are a Data Quality Assistant.
Help users validate their data."""

basic_model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=basic_prompt
)

response = basic_model.generate_content(
    "How do I check if email addresses are valid in my customer table?"
)

print("WITHOUT EXAMPLES:")
print("="*80)
display(Markdown(response.text))
print("\n")
```


```python
# With Examples - shows exactly what we want
enhanced_prompt = """You are a Data Quality Assistant for data engineers.
Help users create validation checks for their data.

When asked about data validation, provide:
1. The validation rule in plain English
2. SQL code to implement it
3. Python code as an alternative
4. Expected output or what to look for

Example:
User: "How do I check for duplicate customer IDs?"
You: 
**Validation Rule:** Find rows where customer_id appears more than once

**SQL Approach:**
```sql
SELECT customer_id, COUNT(*) as duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

**Python Approach:**
```python
duplicates = df[df.duplicated(subset=['customer_id'], keep=False)]
print(f"Found {len(duplicates)} duplicate records")
```

**Expected Output:** Any customer_id with count > 1 is a duplicate that needs investigation.
"""

enhanced_model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=enhanced_prompt
)

response = enhanced_model.generate_content(
    "How do I check if email addresses are valid in my customer table?"
)

print("WITH EXAMPLES:")
print("="*80)
display(Markdown(response.text))
```

### 🔍 See the Difference?

The enhanced version with examples:
- Follows a clear structure
- Provides both SQL and Python
- Explains what to expect
- Uses consistent formatting

**The example "taught" the agent how to respond!**

---

## 🎯 Activity: Add Examples to Your Agent

Now enhance YOUR system prompt with 1-2 examples.

**Steps:**
1. Think about your agent's purpose
2. Create an example question
3. Write the IDEAL response to that question
4. Add it to your system prompt
5. Test if responses improve


```python
# Enhanced version of your agent with examples
# TODO: Enhance your system prompt by adding examples

my_enhanced_prompt = my_system_prompt + """
Example 1:
User: "[EXAMPLE QUESTION 1]"
You: "[YOUR IDEAL RESPONSE - show the exact format/style you want]"

Example 2:
User: "[EXAMPLE QUESTION 2]"  
You: "[YOUR IDEAL RESPONSE]"
"""

# Create the enhanced model
my_enhanced_model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=my_enhanced_prompt
)

print("✓ Enhanced agent created!")
```

#### Example: SQL Query Helper

Here's a complete example if you chose SQL Query Helper:


```python
# Enhanced prompt for: SQL Query Helper

my_enhanced_prompt = my_system_prompt + """
Example:
User: "How do I find duplicate email addresses in my users table?"
You: 
```sql
-- Find duplicates with counts
SELECT email, COUNT(*) as duplicate_count
FROM users
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
```

**Why this approach:**
- Simple GROUP BY with HAVING is most efficient for finding duplicates
- Shows which emails appear most frequently
- Read-only query - safe to run on production

**Common mistakes to avoid:**
- Using DISTINCT (only removes duplicates, doesn't show them)
- Self-joining the table (much slower on large datasets)

**Performance considerations:**
- Add index on email column for faster grouping
- For millions of rows, consider adding LIMIT to see top duplicates first
"""

# Create the enhanced model
my_enhanced_model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=my_enhanced_prompt
)

print("✓ Enhanced agent created!")
```

### Compare Original vs Enhanced

Test the same question with both versions and compare:


```python
# Test question - change this to match your agent's domain
# SQL Helper example: "I need to find customers who made purchases in both 2023 and 2024. I have a purchases table with customer_id and purchase_date."
test_question = "YOUR TEST QUESTION HERE"

print("ORIGINAL AGENT RESPONSE:")
print("="*80)
original_response = my_model.generate_content(test_question)
display(Markdown(original_response.text))
print("\n\n")

print("ENHANCED AGENT RESPONSE:")
print("="*80)
enhanced_response = my_enhanced_model.generate_content(test_question)
display(Markdown(enhanced_response.text))
```

### 🤔 Reflection

Which response is better? Why?

Does the enhanced version:
- Follow the format from your examples?
- Provide more structured output?
- Give more actionable advice?
- Better match what you actually need?

---

## Real-World Example: Complete SQL Helper

Here's a production-ready SQL helper agent with examples:


```python
production_sql_helper = """You are an expert SQL Query Optimiser for data engineers working with large datasets.

Your expertise:
- Query performance analysis
- Index recommendations
- JOIN optimisation
- Best practices for data warehouses

Response format:
1. Analyse the current approach
2. Identify issues
3. Provide optimised solution
4. Explain the improvement

Example:
User: "My query is slow: SELECT * FROM orders WHERE customer_name LIKE '%Smith%' ORDER BY order_date"

You:
**Current Issues:**
1. SELECT * retrieves unnecessary columns (network overhead)
2. Leading wildcard '%Smith%' prevents index usage
3. No index hint for ORDER BY

**Optimised Query:**
```sql
-- Create index first (if not exists)
CREATE INDEX idx_customer_name ON orders(customer_name);
CREATE INDEX idx_order_date ON orders(order_date);

-- Optimised query
SELECT order_id, customer_name, order_date, total_amount
FROM orders
WHERE customer_name LIKE 'Smith%'  -- Remove leading wildcard
ORDER BY order_date;
```

**Performance Impact:**
- Specific columns: 60% less data transfer
- Trailing wildcard: Can use index (10-100x faster)
- Composite index: Speeds up both WHERE and ORDER BY

**When This Won't Help:**
If you truly need to search within names (middle/end), consider full-text search or a separate searchable column.
"""

sql_expert = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=production_sql_helper
)

# Test it with a realistic scenario
test_query = """
I have this query that takes 30 seconds on a 10M row table:

SELECT u.username, COUNT(o.order_id) as order_count
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE u.registration_date > '2023-01-01'
GROUP BY u.username

How can I make it faster?
"""

response = sql_expert.generate_content(test_query)
display(Markdown(response.text))
```

---

## 🎯 Final Challenge: Build Your Production Agent

Take everything you've learned and create your BEST agent.

**Requirements:**
1. Clear system prompt defining expertise
2. At least 2 good examples
3. Specific guidelines for response format
4. Tested with 5+ real questions

**Bonus points:**
- Handle edge cases
- Provide warnings or caveats when appropriate
- Give both quick answers and detailed explanations
- Include code that's actually runnable


```python
# Your final production-ready agent
# This is what you'd actually use in your work!

final_agent_prompt = """
[YOUR COMPLETE SYSTEM PROMPT WITH EXAMPLES]
"""

final_agent = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=final_agent_prompt
)

# Interactive session with your production agent
chat = final_agent.start_chat(history=[])

print("="*80)
print("🚀 YOUR PRODUCTION DATA ENGINEERING AGENT")
print("="*80)
print("This is your specialised, production-ready assistant.")
print("Test it with real problems from your work!")
print("\nType 'quit' when done")
print("="*80 + "\n")

while True:
    user_input = input("You: ")
    
    if user_input.lower() in ['quit', 'exit']:
        print("\n✓ Agent session complete!")
        print("💾 Save this notebook to keep your agent!")
        break
    
    try:
        response = chat.send_message(user_input)
        print(f"\n🤖 Agent:\n")
        display(Markdown(response.text))
        print("-"*80 + "\n")
    except Exception as e:
        print(f"Error: {e}\n")
```

---

## 📊 Session 2 Summary

**What you've learned:**

✓ **System Prompts** - Define agent behaviour and expertise  
✓ **Specialisation** - Create domain-specific agents  
✓ **Few-Shot Examples** - Guide response format and quality  
✓ **Production Agents** - Build tools for real work  

**What you've built:**

1. A specialised data engineering agent
2. Enhanced version with examples
3. Production-ready assistant for your work

---

## 🔗 Connection to Data Engineering

These agents aren't just toys - they're practical tools:

**Use cases in your work:**
- SQL query generation and optimisation
- Data quality validation code
- ETL troubleshooting guides
- Documentation generation
- Code review assistance
- Training new team members

**The key insight:**
You're not replacing your expertise - you're creating assistants that know YOUR context, YOUR standards, YOUR patterns.

---

## 🚀 Next Session Preview

**Session 3: Tool-Using Agents**

We'll move beyond conversation to agents that can:
- Generate actual code files
- Validate data
- Create documentation
- Execute specific tasks
- Produce deliverables

**Preparation:**
Think about a specific task you do repeatedly that could be automated with code generation.

---

## 💾 Save Your Work!

**File → Save a copy in Drive**

You now have a working agent you can use anytime!

---

## 🤔 Reflection Questions

Before finishing:

1. **How does your specialised agent compare to ChatGPT or generic assistants?**

2. **What would make your agent even more useful?**

3. **Where in your current work would this agent save you time?**

4. **What other specialised agents would be valuable for your team?**

Discuss with a colleague or make notes for Session 3!

---

**Excellent work! You've built something genuinely useful today.** 🎉

**See you in Session 3 where we'll make these agents DO things!**
