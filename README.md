
Tools in Ruby to control Debian systems and Ollama .
---

# OllaOS 
**A Minimal Debian-Based Operating System for AI/ML Experiments**  
Built on [MiniOS](https://minios.dev/) with native support for **Ollama** 
and Ruby scripting.

---

## Overview

This is a lightweight, customizable OS designed for testing, experimentation 
and prototyping with artificial intelligence and machine learning technologies. 
It leverages MiniOS as its core base while integrating Ollama 
for local LLM inference and provides extensive tooling via Ruby scripts.

**Ideal For:**  
- AI/ML research & development  
- Local LLM deployment (via Ollama)  
- Experimentation with deep learning frameworks  
- Custom scripting and automation  

---

## Installation

clone the repo.
cd in.
start testing.

---

# Requirements  
Debian System, ruby, fastfetch, geany, ollama, ddgr, wget and adding !

## Scripts

| Script | Description |
|--------|-------------|
| df.rb | Show disk usage |
| fastfetch.rb | Show system info |
| geany.rb | Launch Geany editor |
| ls.rb | List directory contents |
| ol_list.rb | List Ollama models |
| ol_pull.rb | Pull an Ollama model |
| ol_rm.rb | Remove an Ollama model |
| ol_run.rb | Run an Ollama model |
| pwd.rb | Show current directory |
| top.rb | Show system processes |
| up_deb.rb | Update Debian system |
| web_search.rb | Web search via ddgr |
| wget.rb | Download a file |
| ol_sin.rb | Sinatra web interface for all tools |
