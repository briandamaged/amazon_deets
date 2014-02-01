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
      result = agent.page.search("//h1[@id='title']").first
      if result
        return result.text.strip
      end

      return nil
    end


    def url
      agent.page.uri.to_s
    end


    def list_price
      lp_element = agent.page.search("//span[@id='priceblock_ourprice']").first
      if lp_element.nil?
        lp_element = agent.page.search("//td[text()='Price:']/following-sibling::td")
      end

      if lp_element
        return lp_element.text.gsub(/[^.\d]/, "")
      else
        return nil
      end
      
    end

    def current_price
      current_price_element = agent.page.search("//span[@id='priceblock_saleprice']").first
      if current_price_element
        return current_price_element.text
      else
        LOG.debug "Looks like no sale is going on.  Returning list price"
        return list_price
      end
    end


    def rating_text
      result = agent.page.search("//div[@id='averageCustomerReviews']//span[@title]").first
      if result
        return result[:title]
      end

      result = agent.page.search("div.acrRating").first
      if result
        return result.text
      end

      return nil
    end

    def rating
      text = rating_text
      if text
        m = RatingRegex.match(text)
        if m and m[1]
          return m[1].to_f
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

