require 'logbert'
require 'mechanize'

module Amazon

  class Deets

    attr_accessor :agent

    def initialize(agent: nil)
      @agent = agent
    end

  end

end

