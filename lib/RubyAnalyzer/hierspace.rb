require 'RubyAnalyzer/util'
require 'RubyAnalyzer/raenv'

module RubyAnalyzer
  class HierSpace
    RAEnv.register_reflection( self )

    class << self
      def init( env , kind )
        case kind
        when :reflection
          @@env = env
        end
      end

      def add_env( inst )
        inst_index = RAEnv.inst_add( inst )
        @@env[inst_index] = {}
      end
    end

    def initialize
      @hs = HierSpace.add_env( self )
    end

    def add( key_array , value )
      key = ([""] + key_array).join('/')
      @hs[key] ||= []
      @hs[key] << value
      key
    end

    def show
      Util.debug_pp( @hs.keys.size )
      Util.debug_pp( @hs.keys )
    end
  end
end
