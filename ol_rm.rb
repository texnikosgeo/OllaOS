#!/usr/bin/env ruby
# requirement ollama app for linux
# this app runs Linux command: ollama rm and returns the output
# this app is part of OllaOS System
puts "type model name to remove :"
user_answer = gets.chomp
command = `ollama rm #{user_answer}`
puts command
puts "Press Enter to continue..."
continue = gets.chomp
