# Module 7 - AI Agents for Data Engineering
# Session 4: Advanced Patterns & Showcase

## What We're Building Today

You've built conversational agents, specialised agents, and tool-using agents. Now we're taking it further with advanced patterns.

**By the end of this session:**
- ✓ Understand multi-agent systems (agents working together)
- ✓ Implement RAG patterns (agents with context/documentation)
- ✓ Polish your agents for production use
- ✓ Showcase your work to peers

---

## Quick Recap: Your Journey So Far

**Session 1:** First LLM call → Conversational agent  
**Session 2:** System prompts → Specialised agents  
**Session 3:** Tool-using agents → Code generators  

**Today:** Advanced patterns → Production-ready systems

---

## Part 1: Choose Your Path

You have three options for today. Pick the one that interests you most or would be most useful for your work.

### Option A: Multi-Agent Systems
**What:** Two or more agents working together on a task  
**Example:** One agent generates SQL, another reviews and optimises it  
**Use case:** Complex workflows requiring different expertise  

### Option B: RAG Pattern (Retrieval-Augmented Generation)
**What:** Agents with access to specific documentation/context  
**Example:** Agent that follows your company's coding standards  
**Use case:** Consistent outputs based on your rules/documentation  

### Option C: Production Polish
**What:** Make your existing agents production-ready  
**Example:** Add error handling, logging, save conversations  
**Use case:** Deploy agents for actual team use  

**Make your choice and continue to the relevant section below!**

---


```python
# Setup - run this first regardless of which path you choose
from google.colab import userdata
import google.generativeai as genai
from IPython.display import Markdown, display

genai.configure(api_key=userdata.get('GEMINI_API_KEY'))

# Gemini with Gemma 3 model as a backup
#LLM_MODEL = 'models/gemma-3-12b-it'
LLM_MODEL = 'gemini-2.5-flash-lite'
TEMPERATURE = 0.7

print("✓ Setup complete! Choose your path below.")
```

---

# OPTION A: Multi-Agent Systems

## Concept: Agents Working Together

Instead of one agent doing everything, we create specialised agents that collaborate:
- **Agent 1:** Generates initial solution
- **Agent 2:** Reviews and improves it
- **Agent 3:** Validates or tests it (optional)

This mirrors real team workflows!

---

## Example: SQL Generator + Reviewer

Let's build a two-agent system for SQL query generation.


```python
# Agent 1: SQL Generator
generator_prompt = """You are a SQL Query Generator.

Your job:
- Generate SQL queries from natural language requirements
- Use standard SQL syntax
- Keep queries simple and readable
- Output ONLY the SQL query, no explanations
"""

generator = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=generator_prompt
)

# Agent 2: SQL Reviewer/Optimiser
reviewer_prompt = """You are a SQL Query Optimisation Expert.

Your job:
- Review SQL queries for performance issues
- Suggest specific improvements
- Identify missing indexes
- Recommend better approaches

Output format:
1. Issues found (if any)
2. Optimised query (if improvements needed)
3. Explanation of changes

If the query is already optimal, say "Query looks good!"
"""

reviewer = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=reviewer_prompt
)

print("✓ Two-agent system created!")
```


```python
# The multi-agent workflow
def generate_and_review_sql(requirements):
    """
    Two-step process: Generate → Review
    """
    print("🔄 Step 1: Generating SQL...\n")
    
    # Agent 1: Generate
    generated_sql = generator.generate_content(requirements).text
    generated_sql = generated_sql.replace('```sql', '').replace('```', '').strip()
    
    print("📝 Generated SQL:")
    print("-"*80)
    print(generated_sql)
    print("-"*80)
    print("\n🔄 Step 2: Reviewing and optimising...\n")
    
    # Agent 2: Review
    review = reviewer.generate_content(
        f"Review this SQL query:\n\n{generated_sql}"
    ).text
    
    print("🔍 Review Results:")
    print("="*80)
    #print(review)
    display(Markdown(review))
    print("="*80)
    
    return generated_sql, review

# Test it
requirements = """
Get all orders from the last 30 days where the total is greater than £1000,
showing customer name, order date, and total amount.
Tables: orders (order_id, customer_id, order_date, total_amount)
        customers (customer_id, customer_name)
"""

sql, review = generate_and_review_sql(requirements)
```

### 🎯 Activity: Build Your Multi-Agent System

**Options:**
1. **Data Quality:** Generator creates validation rules → Reviewer suggests improvements
2. **ETL Pipeline:** Designer creates pipeline → Validator checks for issues
3. **Code Review:** Generator writes code → Reviewer finds bugs/improvements
4. **Documentation:** Generator writes docs → Editor improves clarity

Build your system below:


```python
# YOUR MULTI-AGENT SYSTEM
# Agent 1: [YOUR FIRST AGENT]

agent1_prompt = """[YOUR AGENT 1 SYSTEM PROMPT]
"""

agent1 = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=agent1_prompt
)

# Agent 2: [YOUR SECOND AGENT]

agent2_prompt = """[YOUR AGENT 2 SYSTEM PROMPT]
"""

agent2 = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=agent2_prompt
)

# Your workflow function
def my_multi_agent_workflow(input_data):
    """
    [DESCRIBE YOUR WORKFLOW]
    """
    # Step 1: Agent 1
    result1 = agent1.generate_content(input_data).text
    print("Agent 1 Output:")
    print(result1)
    print("\n")
    
    # Step 2: Agent 2
    result2 = agent2.generate_content(f"Process this: {result1}").text
    print("Agent 2 Output:")
    print(result2)
    
    return result1, result2

# Test it
# my_multi_agent_workflow("YOUR TEST INPUT")
```

---

# OPTION B: RAG Pattern (Context-Aware Agents)

## Concept: Agents with Documentation

RAG = Retrieval-Augmented Generation

Instead of the agent using only its training, we give it:
- Your company's coding standards
- Your database schema documentation
- Your team's best practices
- Specific examples from your work

**Result:** Consistent, context-aware responses

---

## Example: SQL Generator with Company Standards


```python
# Define your company/team standards
company_standards = """
## Database Coding Standards

### Naming Conventions:
- Table names: plural, lowercase with underscores (e.g., customer_orders)
- Primary keys: table_name_id (e.g., customer_id)
- Foreign keys: referenced_table_id (e.g., customer_id)
- Indexes: idx_table_column (e.g., idx_orders_date)

### Query Standards:
- Always use explicit column names (never SELECT *)
- Use table aliases for JOINs (short, meaningful)
- Include WHERE clause comments for complex logic
- All timestamps in UTC
- Use ANSI SQL standard syntax

### Performance:
- Avoid leading wildcards in LIKE (e.g., '%text')
- Use EXISTS instead of IN for subqueries
- Always include LIMIT for development queries

### Data Types:
- Strings: VARCHAR(255) for names, TEXT for long content
- Timestamps: TIMESTAMP WITH TIME ZONE
- Money: DECIMAL(10,2)
"""

print("✓ Company standards loaded")
```


```python
# Create agent with context
rag_system_prompt = f"""You are a SQL Query Generator that follows strict company standards.

ALWAYS follow these standards:
{company_standards}

When generating queries:
1. Apply naming conventions
2. Follow query standards
3. Implement performance best practices
4. Use correct data types

If requirements conflict with standards, explain the issue and suggest alternatives.
"""

rag_model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=rag_system_prompt
)

# Test it
requirements = "Get all customers who placed orders in the last week"

response = rag_model.generate_content(requirements)
print("Query Following Company Standards:")
print("="*80)
display(Markdown(response.text))
print("="*80)
```

### Notice the Difference?

The agent now:
- Uses your naming conventions
- Follows your query standards
- Applies your performance rules
- Generates consistent, compliant code

---

## 🎯 Activity: Build Your RAG Agent

**Create context documentation for:**
1. Your team's Python coding standards
2. Your database schema (table names, relationships)
3. Your ETL pipeline patterns
4. Your data quality rules

Then build an agent that uses it:


```python
# YOUR CONTEXT/DOCUMENTATION
my_context = """
[ADD YOUR TEAM'S STANDARDS, SCHEMAS, OR BEST PRACTICES HERE]

Examples:
- Database schema
- Coding conventions
- Common patterns
- Examples of good code
"""

# YOUR RAG AGENT
my_rag_prompt = f"""You are a [YOUR AGENT TYPE].

You MUST follow these standards:
{my_context}

[YOUR ADDITIONAL INSTRUCTIONS]
"""

my_rag_agent = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
    system_instruction=my_rag_prompt
)

# Test it
test_input = "[YOUR TEST REQUEST]"
response = my_rag_agent.generate_content(test_input)
display(Markdown(response.text))
```

---

# OPTION C: Production Polish

## Making Agents Production-Ready

Your agents work, but are they ready for real use? Let's add:
1. Error handling
2. Input validation
3. Conversation logging
4. Help menus
5. Save/load functionality

---

## Example: Production-Ready SQL Generator


```python
import json
from datetime import datetime

class ProductionSQLGenerator:
    """
    Production-ready SQL generator with error handling and logging.
    """
    
    def __init__(self):
        system_prompt = """You are a SQL Query Generator.
        Generate ONLY SQL queries with no explanations.
        Use standard SQL syntax."""
        
        self.model = genai.GenerativeModel(
            LLM_MODEL,
            generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
            system_instruction=system_prompt
        )
        self.history = []
    
    def generate(self, requirements):
        """
        Generate SQL with error handling and logging.
        """
        # Validate input
        if not requirements or len(requirements.strip()) < 5:
            return {"error": "Requirements too short. Please provide more details."}
        
        try:
            # Generate query
            response = self.model.generate_content(requirements)
            sql = response.text.strip()
            sql = sql.replace('```sql', '').replace('```', '').strip()
            
            # Log to history
            self.history.append({
                "timestamp": datetime.now().isoformat(),
                "requirements": requirements,
                "sql": sql
            })
            
            return {"success": True, "sql": sql}
            
        except Exception as e:
            error_msg = f"Generation failed: {str(e)}"
            self.history.append({
                "timestamp": datetime.now().isoformat(),
                "requirements": requirements,
                "error": error_msg
            })
            return {"error": error_msg}
    
    def show_history(self, n=5):
        """
        Show last n queries.
        """
        recent = self.history[-n:]
        for i, entry in enumerate(recent, 1):
            print(f"\n{i}. {entry['timestamp']}")
            print(f"Requirements: {entry['requirements'][:50]}...")
            if 'sql' in entry:
                print(f"SQL: {entry['sql'][:80]}...")
            else:
                print(f"Error: {entry['error']}")
    
    def save_history(self, filename="sql_history.json"):
        """
        Save conversation history to file.
        """
        with open(filename, 'w') as f:
            json.dump(self.history, f, indent=2)
        print(f"✓ History saved to {filename}")

# Create and test
generator = ProductionSQLGenerator()

# Test 1: Valid request
result = generator.generate("Get all active customers from London")
if result.get('success'):
    print("✓ Generated SQL:")
    print(result['sql'])
else:
    print("✗ Error:", result['error'])

print("\n" + "="*80 + "\n")

# Test 2: Invalid request
result = generator.generate("sql")
if result.get('success'):
    print("✓ Generated SQL:")
    print(result['sql'])
else:
    print("✗ Error:", result['error'])

print("\n" + "="*80 + "\n")

# Show history
generator.show_history()
```

### Production Features Added:

✓ Input validation  
✓ Error handling with try/except  
✓ Conversation history logging  
✓ History viewing  
✓ Save to file capability  

---

## 🎯 Activity: Polish Your Agent

Take one of your agents from Sessions 1-3 and add production features:


```python
# YOUR PRODUCTION-READY AGENT CLASS

class MyProductionAgent:
    """
    [DESCRIBE YOUR AGENT]
    """
    
    def __init__(self):
        # Your system prompt
        system_prompt = """[YOUR PROMPT]"""
        
        self.model = genai.GenerativeModel(
            LLM_MODEL,
            generation_config=genai.GenerationConfig(temperature=TEMPERATURE),
            system_instruction=system_prompt
        )
        self.history = []
    
    def process(self, input_data):
        """
        Main processing function with error handling.
        """
        # TODO: Add input validation
        
        try:
            # TODO: Call your model
            # TODO: Log to history
            # TODO: Return result
            pass
        except Exception as e:
            # TODO: Handle errors
            pass
    
    def show_history(self, n=5):
        """Show recent history"""
        # TODO: Implement
        pass
    
    def save_history(self, filename):
        """Save to file"""
        # TODO: Implement
        pass

# Test your production agent
# agent = MyProductionAgent()
# result = agent.process("test input")
```

---

# Part 2: Showcase (25 minutes)

## Preparation (5 minutes)

**Prepare to demonstrate:**
1. What you built today
2. One specific use case
3. A live demo

**Structure your demo:**
- Name your agent (30 seconds)
- Explain what it does (1 minute)
- Show it working (2 minutes)
- Explain workplace application (1 minute)
- Questions from peers (30 seconds)

**Total: 5 minutes per person**

---

## Demo Template

Use this structure:

### 1. Introduction (30 seconds)
"I built a [NAME] that [WHAT IT DOES]"

### 2. The Problem (1 minute)
"In my work, I often need to [TASK], which takes [TIME] and involves [CHALLENGES]"

### 3. The Solution (2 minutes)
"My agent solves this by [HOW]. Let me show you..."
[Run live demo]

### 4. Impact (1 minute)
"This will save me [TIME/EFFORT] and improve [QUALITY/CONSISTENCY] because [REASON]"

### 5. Questions (30 seconds)

---

## Demo Checklist

Before presenting:
- [ ] Test your agent one more time
- [ ] Have a backup example ready
- [ ] Clear any error messages from screen
- [ ] Know your talking points
- [ ] Be ready to explain the code if asked

---

# Part 3: Reflection & Next Steps (5 minutes)

## Today's Achievements

Over the course of today, you've:

✓ **Session 1:** Made first LLM API call → Built conversational agent  
✓ **Session 2:** Created specialised agent with system prompts  
✓ **Session 3:** Built tool-using agent that generates code  
✓ **Session 4:** Implemented advanced patterns  

**You've gone from zero to building production-ready AI agents in one day!**

---

## Reflection Questions

### Individual Reflection (2 minutes)

Think about:

1. **What surprised you most** about building AI agents?

2. **Which agent will you use first** in your actual work?

3. **What would you build next** if you had more time?

4. **How does this compare** to yesterday's AI Foundry experience?

### Group Discussion (3 minutes)

Share with the group:
- One thing you'll implement at work this week
- One thing you want to learn more about

---

## Next Steps & Resources

### Continue Learning:

**Your Free Resources:**
- All your notebooks are saved in Google Drive
- Gemini API free tier continues to work
- Experiment anytime!

**Explore Further:**
- Google AI documentation: ai.google.dev
- Prompt engineering guides: promptingguide.ai
- LangChain for complex workflows: langchain.com

### Professional Development:

**Skills Gained Today:**
- ✓ LLM API integration (S14: Identify new tools)
- ✓ Prompt engineering (S28: Assess new technology)
- ✓ Production deployment (S29: Keep up to date)
- ✓ System design patterns

**Career Applications:**
- Automation of repetitive tasks
- Code generation and review
- Documentation creation
- Team productivity tools

---

## Final Thoughts

### Remember:

**AI agents are tools, not replacements:**
- They augment your expertise
- They handle repetitive tasks
- They ensure consistency
- You provide the judgement and context

**The best agents:**
- Solve real problems
- Save actual time
- Improve quality
- Are easy to use

**You now have the skills to build these!**

---

## 💾 Don't Forget!

**Save your work:**
- File → Save a copy in Drive
- Keep all four session notebooks together

**Share your success:**
- Show your team what you built
- Share your notebooks with colleagues
- Document your agents for future reference

---

## 🎉 Congratulations!

You've completed Module 7: AI Agents for Data Engineering!

**You can now:**
- ✓ Build conversational AI agents
- ✓ Create specialised domain agents
- ✓ Generate code with AI tools
- ✓ Implement advanced patterns
- ✓ Deploy production-ready systems

**Most importantly:**
You've moved from passive AI consumption (using ChatGPT) to active AI creation (building your own agents).

**This is the future of data engineering - and you're ready for it!**

---

**Thank you for your engagement and excellent work today!** 🚀
