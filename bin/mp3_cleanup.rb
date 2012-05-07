#!/usr/bin/env ruby

require 'rubygems'
require 'trollop'

opts = Trollop::options do
  opt :musicdir,            "Directory with the mp3s",            :default => '.'
  opt :capitalise,          "Use a capital letter for each word", :default => true
  opt :replace_underscores, "Replace underscores with spaces",    :default => true
  opt :preview,             "Preview what will be done",          :default => true
  opt :replace,             "Replace these words",                :default => nil
end

musicdir = "#{opts[:musicdir]}/*.mp3"

Dir[musicdir].each do |file|
  tmp_file = file

  if opts[:replace_underscores]
    tmp_file = file.gsub('_', ' ')
  end

  if opts[:capitalise]
    puts tmp_file
    tmp_file = tmp_file.gsub(/\s(.)/, $1.upcase)
  end

  puts tmp_file
end