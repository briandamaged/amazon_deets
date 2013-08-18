amazon_deets
=======================

Scrape product details from an Amazon product page.

Usage
-----------------------

    url = "http://www.amazon.com/AmazonBasics-NiMH-Precharged-Rechargeable-Batteries/dp/B007B9NV8Q"

    require 'amazon_deets'
    grabber = AmazonDeets::Grabber.new
    deets = grabber.grab(url)
    puts deets
