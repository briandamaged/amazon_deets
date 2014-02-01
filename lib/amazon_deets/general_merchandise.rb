
require 'logbert'
require 'mechanize'

require 'amazon_deets/core'

module AmazonDeets

  class GeneralMerchandiseFragment < MechanizedFragment

    def applicable?(agent)
      agent.page.search("h1#title").any?
    end

    def scrape(agent)
      context = Context.new(agent: agent)
      return context.scrape
    end


    class Context < MechanizedContext
      LOG = Logbert[self]

      RatingRegex  = /(.+)\s+out\sof/

      def title
        result = agent.page.search("//h1[@id='title']").first
        if result
          return result.text.strip
        end
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
        end
      end

      def current_price
        cp_element = agent.page.search("//span[@id='priceblock_saleprice']").first
        if cp_element
          return cp_element.text
        else
          LOG.debug "Looks like no sale is going on.  Returning list price"
          return list_price
        end
      end

      def rating
        result = agent.page.search("//div[@id='averageCustomerReviews']//span[@title]").first
        if result
          m = RatingRegex.match result[:title]
          if m and m[1]
            return m[1]
          end
        end
      end

      def reviews
        reviews_element = agent.page.search("//div[@id='averageCustomerReviews']//a[contains(text(), 'reviews')]")
        if reviews_element
          text = reviews_element.text.gsub(/[^\d]/, "")
          return text.to_i unless text.empty?
        else
          LOG.warning "Reviews element could not be found"
        end
      end


      def scrape
        return {
          title:         title,
          url:           url,
          list_price:    list_price,
          current_price: current_price,
          rating:        rating,
          reviews:       reviews
        }
      end

    end

  end

end

