require 'RubyAnalyzer/raenv'

module RubyAnalyzer
  class Ast
    class Astitem
      attr_accessor :self_inst_index, :first_column, :first_lineno, :inspect, :last_column, :last_lineno, :type

      def initialize( node , fpath_index , parent_index )
        @parent_index = parent_index
        @klass_index = RAEnv.ast_klass_add( self.class )
        @node = node
#        @node_index = Env.inst_add( node )
        @first_column = node.first_column
        @first_lineno = node.first_lineno
        @inspect = node.inspect
        @last_column = node.last_column
        @last_lineno = node.last_lineno
        @type = node.type
#        @global_ra_id = Ast.get_global_count
#        @ra_id = Ast.get_count
        @fpath_index = fpath_index
        #        @name = [node.class.to_s , self.class.get_count].join("-")
        @self_inst_index = RAEnv.ast_inst_add( self )
        Ast.register( @klass_index , @self_inst_index )
        @children = {}
      end

      def post_process
        @node = nil
      end
      
      def node_method( )
        @level = Ast.get_level
        Ast.hier_push( self )

        #Util.debug( "#{Util.indent( @level )}#{@node.type}" )

        child_process

        post_process
        
        Ast.hier_pop
      end

      def child_process
        @node.children.each do |x|
          if x == nil
            #Util.debug( "#{Util.indent( @level + 1 )}Nil" )
          elsif x.instance_of?( Integer )
            @integer_var = x.inspect
          elsif x.instance_of?( Symbol )
            @symbol_var = x.inspect
          elsif x.instance_of?( String )
            @string_var = x.inspect
          elsif x.instance_of?( Regexp )
            @regexp_var = x.inspect
          elsif x.instance_of?( Float )
            @float_var = x.inspect
          elsif x.instance_of?( Array )
            if x.size > 0
              @variable_array ||= []
              x.each do |y|
                @variable_array << y
              end
            end
          elsif x.type != nil
            klass = Object.const_get(IDENT_CLASS_NAME[x.type.to_s])
            klass_id = RAEnv.klass_add( klass )
            inst = klass.new(x , @fpath_id, @self_inst_index)
            inst.node_method
            @children[klass_id] ||= Listex.new
            @children[klass_id].add( inst.self_inst_index )
          else
            raise
          end
        end
      end
    end # Astitem
  end # Ast
end # module RubyAnalyzer

require 'RubyAnalyzer/ast_inner'
