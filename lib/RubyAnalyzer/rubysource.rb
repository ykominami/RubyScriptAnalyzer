require 'util'
require 'minitest'

module RubyAnalyzer
  class Rubysource
    attr_accessor :assertions

    include Minitest::Assertions

    def initialize( opts )
      self.assertions = 0

      if opts[:output_file]
        ofname = opts[:output_file]
        @output = File.open( ofname , 'w' )
      else
        @output = STDOUT
      end

      @data_hash = {}
      
      fpath = opts[:idlist_file]
      array = File.readlines( fpath ).map{ |x| x.chomp.split("\t") }
      idents = array.reduce({}){|s, x|
        ident = x[0]
        if x.size > 1
          klass_name = x[1] 
        else
          klass_name = x[0].capitalize
        end
        s[ident] = klass_name
        s
      }

      @ident_fpath = opts[:ident_file]
      @ident = File.basename( @ident_fpath , ".*" )

      make_ident_class_name_list( idents , @ident_fpath )
      
      keys = idents.keys
      id_list = keys.dup
      
      idents.each do |ident, klass_name|
        @data_hash[ident] = {}
        v = @data_hash[ident]
        v["class"] = klass_name
        v["child"] = {}
        c = v["child"]
        c["nil_val"] = "ignore"
        c["integer_val"] = {}
        c["integer_val"]["var"] = "integer_var"
        c["symbol_val"] = {}
        c["symbol_val"]["var"] = "symbol_var"
        c["string_val"] = {}
        c["string_val"]["var"] = "string_var"
        c["regexp_val"] = {}
        c["regexp_val"]["var"] = "regexp_var"
        c["float_val"] = {}
        c["float_val"]["var"] = "float_var"
        c["VARIABLE_Array"] = {}
        c["VARIABLE_Array"]["var"] = "variable_array"
        c["type_type"] = {}
        c["type_type"]["var"] = "type_array"
      end
      @klass_output_lines = {}
    end

    def make_ident_class_name_list( idents , outfname )
      lines = []
      module_name = get_module_name
      var_name = "IDENT_CLASS_NAME"
      ast_class_name = "Ast"
      line =<<EOL
module #{module_name}
  #{var_name} = {
EOL
      lines << line
      
      idents.each do |k,v|
        line = "    '#{k}' => '#{module_name}::#{ast_class_name}::#{v}',"
        lines << line
      end
      line = <<EOL
}
end
EOL
      lines << line
      
      File.open( outfname , 'w' ){|f|
        f.puts( lines.join("\n") )
      }
    end
    
    def make_source
      make_klassoutput_lines
      add_child_to_klassoutput_lines
    end

    def make_klassoutput_lines
      @data_hash.each do |k,v|
        accessors = []
        ident = k
        klass = v["class"]
        child_info = v["child"]
        #refute_nil( child_info )
        
        ko = Klassoutput.new( ident, klass , child_info)
        @klass_output_lines[ k ] = ko
      end
    end

    def add_child_to_klassoutput_lines
      keys = @klass_output_lines.keys
      keys.map{|k|
        ko = @klass_output_lines[ k ]
        ko.add_child( @klass_output_lines )
      }
    end

    def get_module_name
      name = self.class.to_s
      if name.include?('::')
        module_name = name.split('::')[0]
      else
        module_name = "RubyAnalyzer"
      end
      module_name
    end
    
    def output_source
      module_name = get_module_name
      @output.puts("require '#{@ident}'")
      @output.puts("")
      @output.puts("module #{module_name}")
      @output.puts("  class Ast")
      
      keys = @klass_output_lines.keys
      keys.map{|k|
        x = @klass_output_lines[k]
        @output.puts( x.get_output )
        @output.puts( "" )
      }
      @output.puts("  end # class Ast")
      @output.puts("end # #{module_name}")
    end
    
    def make_node_hash( fname )
      idlist = File.readlines(fname).map{|x| x.chomp }
      hs = {}
      idlist.each do |ident|
        hs[ ident ] = {}
      end
    end
  end
end # module RubyAnalyzer
