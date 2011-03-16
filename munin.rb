#!/usr/bin/env ruby
require 'rubygems'
require 'webpagetest_grabber'

test_url = File.dirname(__FILE__).split('_',2).last

def clean_name(name)
  name.gsub(/[ \(\)]/,'_').downcase
end

if ARGV[0].to_s == 'config'
  puts "graph_title #{test_url} Webpagetest\n";
  puts "graph_vlabel number\n";
  puts "graph_scale no\n";
  puts "graph_category other\n";

  WebpagetestGrabber::HEADERS.each do |header|
    puts "#{clean_name(header)}.label #{header}\n"
  end
else
  initial, repeated = WebpagetestGrabber.fetch(test_url)
  initial.each do |header, value|
    puts "#{clean_name(header)}.value #{value}"
  end
end

