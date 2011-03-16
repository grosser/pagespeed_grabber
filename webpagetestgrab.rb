#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'faster_csv'

URL = 'http://www.webpagetest.org'
TEST_URL = 'http://google.com'

# page takes ~ 20s to generate
MAX_TRIES = 10
TIME_BETWEEN_TRIES = 5
CSV_LINK = 'Raw page data'

def download_csv(test_url)
  agent = Mechanize.new
  page = agent.get(URL)
  form = page.forms.first
  form.field_with('url').value = test_url
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

  agent.get(URL + link.href).body
end

def csv_to_array(csv)
  data = []
  FasterCSV.parse(csv, :headers=>true) do |row|
    data << row.to_hash
  end
  data
end

csv = download_csv('http://google.com')
data = csv_to_array(csv)

puts data.inspect
