require File.expand_path('lib/webpagetest_grabber')

describe WebpagetestGrabber do
  it "can fetch results for an url" do
    initial, repeated = WebpagetestGrabber.fetch('google.com')
    initial['Load Time (ms)'].to_i.should > repeated['Load Time (ms)'].to_i
  end
end
