require 'itembase'
require 'util'

module RubyAnalyzer
  class Item < Itembase
    class << self
      def init
        @@root = nil
      end
      
      def set_root( item )
        @@root = item
      end

      def get_root
        @@root
      end

      def is_root?( item )
        @@root == item
      end

      def show_tree
        raise
        get_root.show_tree
      end
    end
    
    def initialize( obj , ns_parent_item , level , top = false )
      @level = level
      @parent = ns_parent_item

      super( obj )

      @ns_key = Analyzer.get_ns_key

      Item.register(self)
      if top
        Item.set_root( self )
        set_open_class_info( Item.get_root )
      end
    end

    def init_env_2( obj, ns_parent_item )
      Util.debug( "=== obj=#{obj}" )
      itempartx_ns_parent = nil
      itempartx_ns_parent = Itembase.get_itempartx_from_arg_in_block( ns_parent_item.obj ) if ns_parent_item
      itempartx = Itembase.get_itempartx_from_arg_in_block( obj )
      INFO_STRUCT_SYMBOLS.map{ |sym|
        @iv_ancestor[sym] = itempartx_ns_parent.iv[sym] if itempartx_ns_parent
        @iv[sym] = itempartx.iv[sym]
      }
    end
    
    def show_tree
      p @name
    end
  end
end
