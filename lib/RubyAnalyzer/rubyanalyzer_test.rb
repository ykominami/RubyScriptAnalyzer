require 'RubyAnalyzer/raenv'

module RubyAnalyzer
  class App
    def test_for_script
      #  Env. inspect_env
      kind = :reflection
      keys = RAEnv.get_object_hash_keys( kind )
      keys.each do |x|
        obj = RAEnv.object_at(x, kind)
      end

      env_for_ast = RAEnv.get_env_for_ast
      
    end
    
    def show_item_list( hs )
      hs.each do |fpath,v|
        v.each do |x|
          if x.instance_of?( Array )
            x.each do |y|
              vgvar_name = y.inspect
            end
          else
            vgvar_name = x.inspect
          end
        end
      end
    end

    def testx
      Util.debug( "# RubyAnalyzer::Analyzer.show_tree" )
      #RubyAnalyzer::Analyzer.show_tree
      Item.show_tree

      #
      Util.debug( "==" )
      x = Object.const_get( "CStructType" )
      Util.debug( x.class )
      Util.debug( x.ancestors )
      Util.debug( CStructType )
      Util.debug( CStructType.ancestors )
      Util.debug( "==" )
      x = Object.const_get( "CompositeCelltype" )
      Util.debug( x.class )
      Util.debug( x.ancestors )
      Util.debug( CompositeCelltype )
      Util.debug( CompositeCelltype.ancestors )
      #
      Util.debug( "===" )
      RubyAnalyzer::Item.sort_by_ancestor
      Util.debug( "=== sort_by_ns_key" )
      RubyAnalyzer::Item.sort_by_ns_key
      Util.debug( "=== show_class_variables " )
      RubyAnalyzer::Item.show_class_variables
      Util.debug( "=== class_related_info" )
      RubyAnalyzer::Item.show_class_related_info( Object )
      Util.debug( "=== root class_related_info :SELF" )
      RubyAnalyzer::Item.show_class_related_info( RubyAnalyzer::Item.get_root.obj , :SELF)
      Util.debug( "=== root class_related_info :AVAILABLE" )
      RubyAnalyzer::Item.show_class_related_info( RubyAnalyzer::Item.get_root.obj , :AVAILABLE)
      Util.debug( "=== root class_related_info :OPEN_CLASS" )
      RubyAnalyzer::Item.show_class_related_info( RubyAnalyzer::Item.get_root.obj , :OPEN_CLASS)
      Util.debug( "=== root class_related_info :WITHOUT_OPEN_CLASS" )
      RubyAnalyzer::Item.show_class_related_info( RubyAnalyzer::Item.get_root.obj , :WITHOUT_OPEN_CLASS)
      Util.debug( "=== root " )
      Util.debug( RubyAnalyzer::Item.get_root)
      Util.debug( "=== Object " )
    end
  end
end
