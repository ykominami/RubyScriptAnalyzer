require 'RubyAnalyzer/util'
require 'RubyAnalyzer/raenv'

module RubyAnalyzer
  class Ns
    RAEnv.register_reflection( self )
    St = Struct.new( :stack , :root, :current )

    class << self
      def init( env , kind )
        case kind
        when :reflection
          @@env = env
        else
          #
        end
      end

      def add_env( obj )
        inst_index = RAEnv.inst_add( obj )
        @@env[ inst_index ] = {}
        @@env[ inst_index ]['iv'] = St.new
      end
    end

    def initialize
      @iv = Ns.add_env( self )
      @iv.stack = []
      @iv.root = nil
      @iv.current = nil
    end

    def push( item )
      ns_name = item.name.split('::').pop
      if @iv.stack.size > 0
        item.ns_key = [@iv.stack.last.ns_key , ns_name].join('::')
      else
        item.ns_key = ns_name
      end
      Util.debug( "=*=* #{@iv.stack.size} Ns item.ns_key=#{item.ns_key}" )
      @iv.stack << item
      @iv.root = item unless @root
      @iv.current = item unless @current
    end

    def pop
      @iv.stack.pop
    end

    def show
      Util.debug_pp( @iv.stack.map{|x| x.ns_key } )
    end

    def show_tree
    end

    def get_ns_key
      @iv.stack.map{|x| x.name }.join('/')
    end
  end
end
