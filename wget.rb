#!/usr/bin/env ruby
# requirement wget app for linux and internet connection active is needed.
# this app runs Linux command: wget + user input and returns the output
# this app is part of OllaOS System
puts "Download Link :"
search_term = gets.chomp
command = `wget "#{search_term}" `
puts command
puts "Press Enter to continue..."
continue = gets.chomp
