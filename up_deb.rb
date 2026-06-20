#!/usr/bin/env ruby
# this app runs Linux command: sudo apt update && sudo apt upgrade -y and returns the output
# this app is part of OllaOS System
command = `sudo apt update && sudo apt upgrade -y`
puts command
puts "Press Enter to continue..."
continue = gets.chomp
