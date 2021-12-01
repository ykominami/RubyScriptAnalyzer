require 'RubyScriptAnalyzer/reflection/hierspace'

module RubyScriptAnalyzer
  class Ns < HierSpace
    def add( parent , child_name )
      if parent
        key = [parent.ns_key , child_name].join('/')
      else
        key = "/"
      end
      @hs[key] = child_name

      key
    end
  end
end