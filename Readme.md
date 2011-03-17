Grab pagespeed results from external services to use them in e.g. munin.<br/>
Currently only support webpagetest.org, which is not very reliable and sometimes slow.

Not ready for production just a toy project.

    data = PagespeedGrabber.fetch('google.com', :from => 'webpagetest', :timeout => 200)

### Munin
`munin.rb` can be moved into munin/plugins and renamed to e.g. webpagetest_google.com to aggregate results.

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
