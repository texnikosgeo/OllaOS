#!/usr/bin/env ruby
# requirement ollama app for linux
# this app runs Linux command: ollama pull and returns the output
# this app is part of OllaOS System
puts "type model name :"
user_answer = gets.chomp
command = "ollama pull"
puts system(command + " #{user_answer}")
puts "Press Enter to continue..."
continue = gets.chomp
