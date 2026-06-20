#!/usr/bin/env ruby
# requirement ollama app for linux
# this app runs Linux command: ollama list and returns the output
# this app is part of OllaOS System
command = "ollama list"
puts system(command)
puts "Press Enter to continue..."
continue = gets.chomp
