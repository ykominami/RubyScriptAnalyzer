require 'RubyAnalyzer/raenv'
require 'RubyAnalyzer/astitem'

module RubyAnalyzer
  class Ast
    RAEnv.register_for_ast( self )
    St = Struct.new(:hier , :cur, :level , :countx)

    @@global_count = 0

    class << self
      def init( env , kind )
        case kind
        when :ast
          @@env = env
          @@cv = St.new
          @@cv.hier = []
          @@cv.cur = nil
          @@cv.level = 1
          @@cv.countx = 1
        end
      end

      def register( klass_index, inst_index )
        @@env[klass_index] ||= []
        @@env[klass_index] << inst_index
      end

      def get_count
        countx = @@cv.countx
        @@cv.countx += 1
        countx
      end

      def hier_push( value )
        @@cv.hier.push( value )
        @@cv.level += 1
        @@cv.cur = @@cv.hier.last
      end

      def hier_pop
        @@cv.hier.pop
        @@cv.level -= 1
        @@cv.cur = @@cv.hier.last
      end

      def get_level
        @@cv.level
      end
    end

    def initialize( fname )
      @fpath_index = RAEnv.register_fpath( fname )
      @node_top = RubyVM::AbstractSyntaxTree.parse_file(fname)
      #      Astarisk.draw(node2)
    end

    def parse0
      case @node_top.type
      when :SCOPE
        inst = Ast::Scope.new( @node_top , @fpath_index , -1 )
        inst.node_method
      else
        raise
      end
    end
  end
end
