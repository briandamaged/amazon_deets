
require 'logbert'
require 'mechanize'

require 'amazon_deets/core'

module AmazonDeets

  class KindleFragment < MechanizedFragment

    def applicable?(agent)
      agent.page.search("div.kindleBanner").any?
    end

    def scrape(agent)
      context = Context.new(agent: agent)
      return context.scrape
    end


    class Context < MechanizedContext

      def title
        result = agent.page.search("span#btAsinTitle").first
        if result
          return result.text.strip
        end
      end

      def url
        agent.page.uri.to_s
      end

      def list_price
        lp_element = agent.page.search("td.listPrice").first
        if lp_element
          return lp_element.text.gsub(/[^.\d]/, "")
        end
      end

      def current_price
        cp_element = agent.page.search("td b.priceLarge").first
        if cp_element
          return cp_element.text.gsub(/[^.\d]/, "")
        end
      end

      def rating
      end

      def reviews
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

