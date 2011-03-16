task :default do
  sh "rspec spec/"
end

task :headers do
  require File.expand_path('lib/webpagetest_grabber')
  csv = `curl http://www.webpagetest.org/result/110316_DA_5TFD/110316_DA_5TFD_google.com_page_data.csv`
  data = WebpagetestGrabber.csv_to_array(csv).first.keys
  puts data.inspect
end
