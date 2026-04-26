# Module 7 - AI Agents for Data Engineering
# Session 1: Building Your First AI Agent

## Welcome!

Today you're going to build AI agents from scratch using Google's Gemini API and Python.

By the end of this session, you'll have:
- ✓ Connected to a Large Language Model (LLM)
- ✓ Made your first API call
- ✓ Built a conversational AI agent
- ✓ Customised it for data engineering tasks

**Important:** Save this notebook to your Google Drive so you can continue experimenting later!

---

## Part 1: Setup Your API Key (Secure Method)

First, we need to configure access to Google's Gemini API.

**Steps:**
1. Open a new browser tab: https://aistudio.google.com
2. Sign in with your Google account
3. Click "Get API key" → "Create API key in new project"
4. Copy the key (it starts with "AIza...")
5. Come back to this notebook

**Now we'll store it securely in Colab:**

👈 Look at the left sidebar - click the **key icon** (🔑)

Then:
- Click "Add new secret"
- Name: `GEMINI_API_KEY`
- Value: Paste your API key (Don't press enter)
- Toggle "Notebook access" ON

The key is saved automatically!


```python
# Let's verify your API key is configured correctly
from google.colab import userdata

try:
    api_key = userdata.get('GEMINI_API_KEY')
    print("✓ API key found!")
    print(f"✓ Key starts with: {api_key[:10]}...")
except Exception as e:
    print("✗ API key not found. Please add it using the key icon on the left.")
```

**Note**: You may see one or two popup about authorising access. You can safely give authorisation.

---

## Part 2: Your First LLM Call

Let's make the simplest possible call to an LLM and see what happens.

**What we're doing:**
- Installing the Gemini Python library
- Creating a model connection
- Sending a prompt
- Getting a response

It's that simple!

First install the required libraries:


```python
# Install and import the Gemini library
!pip install -q google-generativeai

import google.generativeai as genai
from IPython.display import Markdown, display
```

Then set the model that we are using:


```python
# Use a model with decent rate limits (1,000 RPD vs 20 RPD for Gemini Pro)
#LLM_MODEL = 'models/gemma-3-12b-it'
LLM_MODEL = 'gemini-2.5-flash-lite'

# Temperature configuration
# 0.0 = deterministic (consistent outputs for debugging)
# 0.7 = balanced (some variety, still coherent)
# 1.0+ = creative (high variety, good for brainstorming)
TEMPERATURE = 0.7
```

Create a model instance:


```python
# Configure the API with your key
genai.configure(api_key=userdata.get('GEMINI_API_KEY'))

# Create a model instance
model = genai.GenerativeModel(
    LLM_MODEL,
    generation_config=genai.GenerationConfig(temperature=TEMPERATURE)
)
```

Generate a response:


```python
# Generate a response
response = model.generate_content("Explain what a data warehouse is in one sentence")

# Print the result
display(Markdown(response.text))
```

### 🎯 Your Turn: Experiment!

**Task:** Modify the prompt above to ask a data engineering question relevant to YOUR work.

Try asking about:
- SQL concepts
- ETL processes
- Data quality
- Database design
- Python data processing

Run the cell multiple times with different questions. See what you get!


```python
# Try your own questions here 
# Change the prompt, and run it!

# TODO: Change this to your question
response = model.generate_content("YOUR QUESTION HERE")

display(Markdown(response.text))
```

---

## Part 3: Build a Conversational Agent

That single question-answer is nice, but what if we want the agent to **remember** what we talked about?

That's called **conversation history** - and it's what makes an LLM feel like an agent.

**How it works:**
- We start a "chat" instead of single generation
- Each message remembers previous messages
- The LLM can reference earlier parts of the conversation


```python
# Start a new chat with conversation history
chat = model.start_chat(history=[])

# Send first message
response = chat.send_message("I'm learning about ETL processes")
display(Markdown(response.text))
print("\n" + "="*80 + "\n")

# Send follow-up - notice it remembers we're talking about ETL
response = chat.send_message("What's the difference between ETL and ELT?")
display(Markdown(response.text))
```

### Notice what happened?

The agent understood that "the difference" referred to ETL vs ELT **because it remembered the first message**.

Without conversation history, it wouldn't have known what we were comparing!

---

## Part 4: Interactive Conversational Agent

Let's make this more useful - an agent you can actually chat with!

**Run the cell below and have a conversation about data engineering topics.**

Test if it:
- Remembers what you said earlier
- Provides helpful code examples
- Answers follow-up questions correctly

Type `quit` to exit.


```python
# Create a fresh chat for our interactive session
chat = model.start_chat(history=[])

print("="*80)
print("🤖 DATA ENGINEERING ASSISTANT")
print("="*80)
print("Ask me anything about data engineering!")
print("Topics: SQL, ETL, Python, Data Quality, Pipelines, Warehousing...")
print("\nType 'quit' to exit")
print("="*80 + "\n")

while True:
    # Get user input
    user_input = input("You: ")
    
    # Exit condition
    if user_input.lower() in ['quit', 'exit', 'bye']:
        print("\n👋 Thanks for chatting! Your agent is saved in this notebook.")
        break
    
    # Send message and get response
    try:
        response = chat.send_message(user_input)
        print(f"\n🤖 Agent:\n")
        display(Markdown(response.text))
    except Exception as e:
        print(f"Error: {e}")
        print("Try rephrasing your question.\n")
```

---

## 🎯 Challenge: Test Your Agent's Memory

Try this conversation sequence to test if your agent remembers context:

1. "I have a table called customers with columns: id, name, email, created_at"
2. "How do I find duplicate emails?"
3. "What if I want to keep the oldest record?"

**Did the agent remember your table structure?**

Try other multi-turn conversations relevant to your work!

---

## Part 5: What We've Built

In this session you've created:

✓ **LLM Connection** - You can call Gemini API  
✓ **Single-turn Generation** - Ask questions, get answers  
✓ **Conversational Agent** - Remembers conversation history  
✓ **Interactive Interface** - Chat with your agent  

**This is the foundation for all AI agents!**

Everything else builds on these basics:
- System prompts (Session 2)
- Tool use (Session 3)
- Multi-agent systems (Session 4)

---

## 📝 Key Concepts

**LLM (Large Language Model):**
- Pre-trained AI model that understands and generates text
- Examples: Gemini, GPT, Claude

**Prompt:**
- The input you send to the LLM
- Can be a question, instruction, or context

**Conversation History:**
- Storing previous messages in the chat
- Allows the agent to reference earlier context

**Agent:**
- An LLM with specific behaviour/purpose
- Can be specialised through system prompts and tools

---

## 🚀 Next Steps

**Before Session 2:**
- Think about what data engineering tasks you'd like to automate
- What would be useful in your actual work?

**In Session 2 we'll:**
- Add system prompts to specialise your agent
- Create domain-specific agents (SQL helper, data quality checker, etc.)
- Make agents give better, more focused responses

---

## 💾 Save This Notebook!

**File → Save a copy in Drive**

Your API key is saved securely, and you can continue experimenting anytime!

---

## 🤔 Reflection Questions

Before we finish, think about:

1. **What surprised you** about how simple this is?
2. **Where in your work** could a conversational agent help?
3. **What questions** would you want to ask your ideal data engineering assistant?

Discuss with a colleague or make notes for yourself.

---

**Great work! See you in Session 2 where we'll make these agents much more powerful.** 🎉
