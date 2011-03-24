Grab pagespeed results from external services to use them in e.g. munin.<br/>
Currently only support webpagetest.org, which is not very reliable and sometimes slow.

Not ready for production just a toy project.

    data = PagespeedGrabber.fetch('google.com', :from => 'webpagetest', :timeout => 200)

# Munin

### Download
    sudo su

    gem install pagespeed_grabber
    curl https://github.com/grosser/pagespeed_grabber/raw/master/munin.rb > /usr/share/munin/plugins/pagespeed_grabber
    chmod +x /usr/share/munin/plugins/pagespeed_grabber

### Add data cron and run it once
    */5 * * * * /usr/share/munin/plugins/pagespeed_grabber cache webpagetest google.com

### Add plugins for time, data, score, connections graphs
    ruby -e "%w[time data score connections].each{|s| %w[initial repeated].each{|t| %x{ln -s /usr/share/munin/plugins/pagespeed_grabber /etc/munin/plugins/webpagetest_#{s}_#{t}_google.com}  } }"


### Check plugins work
    ./etc/munin/plugins/webpagetest_time_google.com config    # config works
    ./etc/munin/plugins/webpagetest_time_google.com           # values are returned

### Restart
    /etc/init.d/munin-node.restart


TODO
====
 - add other services
 - make less hacky/use official apis
 - generate initial AND repeated graph
 - find a reliable service
 - parse .har file from e.g. loads.in

Authors
=======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...
