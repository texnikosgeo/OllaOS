#!/usr/bin/env ruby
# requirement fastfetch app for linux
# this app runs Linux command: fastfetch and returns the output
# this app is part of OllaOS System
command = `fastfetch`
puts command
puts "Press Enter to continue..."
continue = gets.chomp
