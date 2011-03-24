#!/usr/local/bin/ruby
require 'rubygems'
require 'yaml'
require 'pagespeed_grabber'

def clean_name(name)
  name.gsub(/[ \(\)]/,'_').downcase
end

def temp_file(source, url)
  "/tmp/munin-cache-#{source}-#{url}"
end

def select_headers(headers, type)
  useless = [
    'Bytes In', 'Bytes Out', 'Connections', 'DNS Lookups', 'Flagged Connections', 'Flagged Requests',
    'Max Simultaneous Flagged Connections', 'OK Responses', 'Other Responses', 'Other Responses (Doc)', 'Requests', 'Time'
  ]

  selector = {
    'time' => /Time/,
    'data' => /Bytes|Savings/,
    'connections' => /DNS|Responses|Requests|Segments|Connections|Packet Loss/,
    'score' => /Score/
  }[type] || raise('Unknown type')

  (headers - useless).grep(selector).sort
end

def is_numeric?(value)
  value.to_s =~ /^-?[\d]+(\.\d+)?$/
end

if ARGV[0] == 'cache'
  source = ARGV[1] || raise('source needed')
  url = ARGV[2] || raise('url needed')

  data = PagespeedGrabber.fetch(url, :from => source)
  File.open(temp_file(source, url), 'w'){|f| f.write(data.to_yaml) }
else
  source, scope, type, url = File.basename(__FILE__).split('_',4)
  data = YAML.load_file(temp_file(source, url))
  headers = select_headers(data.first.keys, scope)

  if ARGV[0] == 'config'
    label = {
      'data' => 'Bytes',
      'time' => 'ms',
      'score' => '%',
      'connections' => 'number'
    }[scope]

    puts "graph_title #{url} #{scope} #{type} by #{source}"
    puts "graph_vlabel #{label}"
    puts "graph_scale no"
    puts "graph_category pagespeed"

    headers.each do |header|
      puts "#{clean_name(header)}.label #{header}"
    end
  else
    initial, repeated = data
    data = (type == 'repeated' ? repeated : initial)
    data.sort.each do |header, value|
      next unless headers.include?(header) and is_numeric?(value)
      puts "#{clean_name(header)}.value #{value}"
    end
  end
end
