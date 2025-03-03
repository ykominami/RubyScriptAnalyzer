require 'forwardable'
require 'set'

module RubyAnalyzer
  class Setx
    extend Forwardable
    include Enumerable

    #    def_delegator(:@hs, :respond_to?, :respond_to?)
    def_delegators(:@hs, :size, :include?, :each)

    def initialize
      @hs = Set.new
      enable
    end

    def clear
      @hs.clear
    end

    def disable
      @able = false
    end

    def enable
      @able = true
    end

    def enable?
      @able
    end

    def add(item)
      @hs.add(item) if enable?
    end

    def sort(&)
      #			@hs.keys.sort(&block)
      @hs.to_a.sort(&)
    end

    def map(&)
      @hs.to_a.map(&)
    end
  end
end
