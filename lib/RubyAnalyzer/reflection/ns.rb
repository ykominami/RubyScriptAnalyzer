require 'RubyAnalyzer/reflection/hierspace'

module RubyAnalyzer
  class Ns < HierSpace
    def add( parent ,  child )
      if parent
        key = [parent.ns_key , child.ns_key].join('/')
      else
        key = ["" , child.ns_key].join('/')
      end
      @hs[key] = child
    end
  end
end