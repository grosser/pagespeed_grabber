task :default do
  sh "rspec spec/"
end

task :headers do
  require File.expand_path('lib/webpagetest_grabber')
  csv = `curl http://www.webpagetest.org/result/110316_DA_5TFD/110316_DA_5TFD_google.com_page_data.csv`
  data = PagespeedGrabber.csv_to_array(csv).first.keys
  puts data.inspect
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'pagespeed_grabber'
    gem.summary = "Grab pagespeed results from external services to use them in e.g. munin."
    gem.email = "michael@grosser.it"
    gem.homepage = "http://github.com/grosser/#{gem.name}"
    gem.authors = ["Michael Grosser"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end
