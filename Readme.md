Grab raw csv results from webpagetest.org

    # if the queue is full this will take forever, so be careful !!
    data = WebpagetestGrabber.fetch('google.com', :timeout => 200)
