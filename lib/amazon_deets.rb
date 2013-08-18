require 'logbert'
require 'mechanize'

module AmazonDeets

  class Grabber
    RatingRegex  = /(.+)\s+out\sof/
    ReviewsRegex = /(\d+)/

    attr_accessor :agent

    def initialize(agent: Mechanize.new)
      @agent = agent
    end

    def title
      agent.page.search("//span[@id='btAsinTitle']").text
    end


    def list_price
      nodes = agent.page.search("//span[@id='listPriceValue']")
      if nodes.any?
        return nodes.text
      else
        return current_price
      end
    end

    def current_price
      agent.page.search("//span[@id='actualPriceValue']").text
    end


    def rating
      text = agent.page.search("//div[@id='acr']//span[@title]").text
      m = RatingRegex.match(text)
      m[1].to_f
    end

    def reviews
      text = agent.page.search("//div[@id='acr']//div[contains(@class, 'acrCount')]").text
      m = ReviewsRegex.match(text)
      m[1].to_i
    end


    def details_hash
      return {
        title:         title,
        list_price:    list_price,
        current_price: current_price,
        rating:        rating,
        reviews:       reviews
      }
    end


    def grab(url)
      agent.get(url)
      details_hash
    end

  end

end

