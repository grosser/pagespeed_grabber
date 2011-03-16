require 'rubygems'
require 'mechanize'
require 'faster_csv'
require 'timeout'

module PagespeedGrabber
  URL = 'http://www.webpagetest.org'
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
  DEFAULT_TIMEOUT = 100
  TIME_BETWEEN_TRIES = 10
  CSV_LINK = 'Raw page data'
  HEADERS = ["Load Time (ms)", "Other Responses (Doc)", "Connections", "Minify Savings", "Experimental", "IP Address", "ETag Score", "GZIP Score", "DNS Lookups", "Event Name", "Not Found", "Segments Transmitted", "Keep-Alive Score", "Time", "Not Modified", "Cookie Score", "Measurement Type", "Gzip Savings", "Time to Base Page Complete (ms)", "One CDN Score", "OK Responses", "Error Code", "unused", "Requests", "Other Responses", "Includes Object Data", "Minify Total Bytes", "Flagged Requests", "AFT (ms)", "Packet Loss (out)", "Compression Score", "URL", "OK Responses (Doc)", "Combine Score", "Base Page Result", "Doc Complete Time (ms)", "Redirects (Doc)", "Pagetest Build", "Minify Score", "Time to Start Render (ms)", "Cache Score", "Base Page Redirects", "Bytes Out (Doc)", "Descriptor", "Dialer ID", "Connection Type", "Activity Time(ms)", "Time to First Byte (ms)", "Date", "Not Found (Doc)", "Redirects", "Not Modified (Doc)", "Event GUID", "Event URL", "Requests (Doc)", "Bytes In (Doc)", "Time to DOM Element (ms)", "Static CDN Score", "Optimization Checked", "Image Savings", "Connections (Doc)", "Flagged Connections", "Max Simultaneous Flagged Connections", "Cached", "Gzip Total Bytes", "Bytes Out", "Bytes In", "DNS Lookups (Doc)", "Segments Retransmitted", "DOCTYPE Score", "Image Total Bytes", "Host", "Lab ID"]

  def self.fetch(test_url, options={})
    Timeout.timeout(options[:timeout]||DEFAULT_TIMEOUT) do
      csv_to_array(download_csv(test_url))
    end
  end

  def self.download_csv(test_url)
    agent = Mechanize.new
    page = agent.get(URL)
    form = page.forms.first
    form.field_with('url').value = test_url
    page = form.submit

    url = page.uri.to_s
    link = nil

    loop do
      sleep TIME_BETWEEN_TRIES
      page = agent.get(url)
      break if link = page.link_with(:text => CSV_LINK)
    end

    agent.get(URL + link.href).body
  end

  def self.csv_to_array(csv)
    data = []
    FasterCSV.parse(csv, :headers=>true) do |row|
      data << row.to_hash
    end
    data
  end
end
