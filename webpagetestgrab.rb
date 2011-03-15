#!/usr/bin/env ruby
# gem install mechanize

require 'rubygems'
require 'mechanize'

URL = 'http://www.webpagetest.org'
TEST_URL = 'http://google.com'

# page takes ~ 20s to generate
MAX_TRIES = 10
TIME_BETWEEN_TRIES = 5
CSV_LINK = 'Raw page data'

agent = Mechanize.new
page = agent.get(URL)
form = page.forms.first
form.field_with('url').value = TEST_URL
page = form.submit

url = page.uri.to_s
link = nil

tries = 0
loop do
  tries += 1
  raise "Failed to load results in time for #{url}" if tries > MAX_TRIES
  sleep TIME_BETWEEN_TRIES

  page = agent.get(url)
  break if link = page.link_with(:text => CSV_LINK)
end

results = URL + link.href
csv_data = agent.get(results).body

puts csv_data
