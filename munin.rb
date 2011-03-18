#!/usr/local/bin/ruby
require 'rubygems'
require 'pagespeed_grabber'

test_url = File.basename(__FILE__).split('_',2).last

def clean_name(name)
  name.gsub(/[ \(\)]/,'_').downcase
end

not_reportable = [
  'Date', 'Descriptor', 'Connection Type', 'Event GUID', 'Event Name', 'Event URL', 'Experimental', 'Host', 'IP Address', 'Lab ID',
  'Includes Object Data', 'Max Simultaneous Flagged Connections', 'Pagetest Build', 'Time', 'URL', 'unused', 'Keep-Alive Score'
]
headers = (PagespeedGrabber::HEADERS - not_reportable).sort

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
