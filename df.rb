#!/usr/bin/env ruby
# requirement df app for linux
# this app runs Linux command: df -h and returns the output
# this app is part of OllaOS System
command = "df -h"
puts system(command)
puts "Press Ender to continue..."
continue = gets.chomp