#!/usr/bin/env ruby
# this app runs Linux command: pwd and returns the output
# this app is part of OllaOS System
command = `pwd`
puts command
puts "Press Enter to continue..."
continue = gets.chomp
