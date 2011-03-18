Grab pagespeed results from external services to use them in e.g. munin.<br/>
Currently only support webpagetest.org, which is not very reliable and sometimes slow.

Not ready for production just a toy project.

    data = PagespeedGrabber.fetch('google.com', :from => 'webpagetest', :timeout => 200)

### Munin
move [munin.rb](https://github.com/grosser/pagespeed_grabber/raw/master/munin.rb) into munin/plugins and renamed to e.g. webpagetest_google.com to aggregate results.

    sudo su

    gem install pagespeed_grabber
    curl https://github.com/grosser/pagespeed_grabber/raw/master/munin.rb > /usr/shared/munin/plugins/pagespeed_grabber
    chmod +x /usr/shared/munin/plugins/pagespeed_grabber

    ls -s /usr/shared/munin/plugins/pagespeed_grabber /etc/munin/plugins/webpagetest_google.com

    ./etc/munin/plugins/webpagetest_google.com config    # check config works
    ./etc/munin/plugins/webpagetest_google.com           # check values are returned

    # insert into /etc/munin/plugin-conf.d/munin-node
    [webpagetest_google.com]
    timeout 100

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
