
require 'logbert'
require 'mechanize'

require 'amazon_deets/core'

module AmazonDeets

  class GeneralMerchandiseFragment < MechanizedFragment

    def applicable?(agent)
      raise NotImplementedError
    end

    def scrape(agent)
      context = Context.new(agent: agent)
      return context.scrape
    end


    class Context < MechanizedContext

      def scrape
        raise NotImplementedError
      end

    end

  end

end

