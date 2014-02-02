amazon_deets
=======================

Scrape product details from an Amazon product page.

Usage
-----------------------

    require 'amazon_deets'
    s = AmazonDeets.create_scraper

    # Grab the details for the product
    deets = s.scrape("http://www.amazon.com/dp/B00DVFLJDS/ref=wl_it_dp_o_pC_nS_ttl?_encoding=UTF8&colid=1IHHAKWP57B7Y&coliid=I3TSLQKP96LJ3C")

    puts deets
