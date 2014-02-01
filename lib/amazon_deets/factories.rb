
require 'amazon_deets/general_merchandise'
require 'amazon_deets/kindle'

module AmazonDeets

  def self.create_scraper(agent: Mechanize.new)
    MechanizedScraper.new(
      agent: agent,
      fragments: [
        KindleFragment.new,
        GeneralMerchandiseFragment.new
      ]
    )
  end

end

