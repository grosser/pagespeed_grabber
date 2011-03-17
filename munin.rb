#!/usr/bin/env ruby
require 'rubygems'
require 'pagespeed_grabber'

test_url = File.basename(__FILE__).split('_',2).last

def clean_name(name)
  name.gsub(/[ \(\)]/,'_').downcase
end

headers = (PagespeedGrabber::HEADERS).sort

if ARGV[0].to_s == 'config'
  puts "graph_title #{test_url} Webpagetest\n";
  puts "graph_vlabel number\n";
  puts "graph_scale no\n";
  puts "graph_category other\n";

  headers.each do |header|
    puts "#{clean_name(header)}.label #{header}\n"
  end
else
  initial, repeated = PagespeedGrabber.fetch(test_url)
  initial.sort.each do |header, value|
    next unless headers.include?(header)
    puts "#{clean_name(header)}.value #{value}" if value.to_s =~ /^-?[\d]+(\.\d+)?$/
  end
end
