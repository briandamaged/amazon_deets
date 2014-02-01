
require 'logbert'
require 'mechanize'


module AmazonDeets

  # Basic interface for the scrapers.  Point it to
  # a URL, and it does the scrape.  BOOM!
  class AbstractScraper

    def scrape(url)
      raise NotImplementedError
    end

  end



  class MechanizedScraper < AbstractScraper

    attr_accessor :agent
    attr_accessor :fragments

    def initialize(agent: Mechanize.new, fragments: Array.new)
      @agent     = agent
      @fragments = fragments
    end

    def scrape(url)
      agent.get(url)
      fragments.each do |f|
        if f.applicable?(agent)
          return f.scrape(agent)
        end
      end
    end

  end


  # Amazon renders different HTML dependending upon
  # the type of product that you are viewing.  This
  # means that the scraper queries need to change
  # depending upon whether you want the data for a
  # Kindle book or some general merchandise.  Rather
  # than building one super-complicated scraper, we'll
  # break the code into multiple simple scrapers that
  # focus on solving specific problems.
  #
  class MechanizedFragment

    # Decides whether or not this MechanizedFragment
    # is applicable
    def applicable?(agent)
      raise NotImplementedError
    end

    def scrape(agent)
      raise NotImplementedError
    end

  end


  # A MechanizedContext is similar to a scraper, but it
  # assumes that the @agent has already navigated to
  # the URL that is going to be scraped.
  class MechanizedContext

    attr_accessor :agent

    def initialize(agent: Mechanized.new)
      @agent = agent
    end


    def scrape
      raise NotImplementedError
    end

  end

end

