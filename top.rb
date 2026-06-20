#!/usr/bin/env ruby
# requirement top app for linux
# this app runs Linux command: top and returns the output
# this app is part of OllaOS System
command = "top"
puts system(command)
puts "Press Enter to continue..."
continue = gets.chomp
