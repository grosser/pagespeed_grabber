require File.expand_path('lib/pagespeed_grabber')

describe PagespeedGrabber do
  it "can fetch results for an url" do
    initial, repeated = PagespeedGrabber.fetch('google.com')
    initial['Load Time (ms)'].to_i.should > repeated['Load Time (ms)'].to_i
  end
end
