#!/usr/bin/env ruby
# requirement ddgr app for linux and internet connection active is needed.
# this app runs Linux command: ddgr + user input and returns the output
# this app is part of OllaOS System
puts "Search for :"
search_term = gets.chomp
command = `ddgr --np "#{search_term}" `
puts command
puts "Press Ender to continue..."
continue = gets.chomp