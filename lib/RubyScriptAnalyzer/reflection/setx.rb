require 'forwardable'
require 'set'

module RubyScriptAnalyzer
  class Setx
    extend Forwardable
    include Enumerable

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

    def sort(&block)
      #      @hs.keys.sort(&block)
      @hs.to_a.sort(&block)
    end

    def map(&block)
      @hs.to_a.map(&block)
    end
  end
end