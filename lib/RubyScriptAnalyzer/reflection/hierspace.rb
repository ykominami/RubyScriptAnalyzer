module RubyScriptAnalyzer
  class HierSpace
    def initialize
      @hs = {}
    end

    def add( key_array , value )
      key = ([""] + key_array).join('/')
      @hs[key] = value

      key
    end
  end
end

