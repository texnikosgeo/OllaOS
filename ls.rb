#!/usr/bin/env ruby
# this app runs Linux command: ls -la and returns the output
# this app is part of OllaOS System
command = `ls -la`
puts command
puts "Press Enter to continue..."
continue = gets.chomp
