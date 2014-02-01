require 'logbert'
require 'mechanize'

module AmazonDeets

  class Grabber
    LOG = Logbert[self]

    RatingRegex  = /(.+)\s+out\sof/
    ReviewsRegex = /(\d+)/

    attr_accessor :agent

    def initialize(agent: Mechanize.new)
      @agent = agent
    end

    def title
      agent.page.search("//span[@id='btAsinTitle']").text
    end

    def url
      agent.page.uri.to_s
    end


    def list_price
      nodes = agent.page.search("//span[@id='listPriceValue']")
      if nodes.any?
        return nodes.text
      else
        LOG.debug "List price was not found.  Returning current price instead."
        return current_price
      end
    end

    def current_price
      agent.page.search("//span[@id='actualPriceValue']").text
    end


    def rating
      rating_elements = agent.page.search("//div[@id='averageCustomerReviews']//span[@title]")
      if rating_elements
        text = rating_elements.first[:title]
        if text
          m = RatingRegex.match(text)
          if m and m[1]
            return m[1].to_f
          end
        end
      end

      return nil
    end

    def reviews
      reviews_element = agent.page.search("//div[@id='summaryStars']/a")
      if reviews_element
        text = reviews_element.text.gsub(/[^\d]/, "")

        return text.to_i unless text.empty?
      end
      return nil
    end


    def details_hash
      return {
        title:         title,
        url:           url,
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

