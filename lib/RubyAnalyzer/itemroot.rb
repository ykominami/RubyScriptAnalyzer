require 'itembase'
require 'util'

module RubyAnalyzer
  class Itemroot < Itembase
    def initialize( klass )
      inst = klass.new
      super( inst )
      init_env_for_root( inst )

      Itemroot.register_as_root( self )
    end

    def init_env_for_root( inst )
      Util.debug( "===init_env_for_root inst=#{inst}" )
      INFO_STURCT_WITH_FALSE_SYMBOLS.map{|x|
        if inst.respond_to?( x )
          @iv[x] = inst.__send__( x, false )
        else
          @iv[x] = []
        end
        @iv_ancestor[x] = []
        @iv_oc[x] = []
        @iv_without_oc[x] = []
      }
      INFO_STURCT_WITHOUT_FALSE_SYMBOLS.map{|x|
        x2 = x.to_s.sub(/_ex$/, '').to_sym
        if inst.respond_to?( x )
          @iv[x] = inst.__send__( x2 )
        else
          @iv[x] = []
        end
        @iv_ancestor[x] = []
        @iv_oc[x] = []
        @iv_without_oc[x] = []
      }
      Util.debug( "===init_env_for_root inst=#{inst} End" )
    end
    
  end
end
