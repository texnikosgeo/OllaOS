#!/usr/bin/env ruby
# requirement geany editor app for linux
# this app runs Linux command: geany and returns the output
# this app is part of OllaOS System
command = "geany"
puts system(command)
puts "Press Enter to continue..."
continue = gets.chomp
