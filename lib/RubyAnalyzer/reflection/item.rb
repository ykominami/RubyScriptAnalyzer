require 'forwardable'
# require 'RubyAnalyzer/reflection/inheritancespace'
require 'RubyAnalyzer/reflection/setx'
require 'RubyAnalyzer/reflection/hashx'
require 'RubyAnalyzer/reflection/analyzer/varnametable'
require 'RubyAnalyzer/reflection/iteminfo'
require 'RubyAnalyzer/util'

module RubyAnalyzer
  class Item
    attr_reader :name_sym, :name_str, :items, :ruby_obj, :level, :kind, :target, :adjust_type, :parent, :ns_key
    attr_accessor :iteminfo

    extend Forwardable
    def_delegator(:@ruby_obj, :respond_to?, :respond_to?)
    def_delegators(:@iteminfo, :src, :dest)

    @ns = Ns.new
    @adjust = {}
    #    @@varnames = Setx.new
    #    @@varnames_for_dump = Varnametable.new

    @item_by_str = Hashx.new
    @item_by_sym = Hashx.new
    @item_by_ruby = Hashx.new

    class << self
      def add_adjust(key, value)
        @adjust[key] = value
      end

      def get_adjust
        @adjust
      end

      def get_adjust_by_name(key)
        @adjust[key]
      end

      def add_ns(parent, child_name)
        @ns.add(parent, child_name)
      end

      def add_item_by_str(str, value)
        @item_by_str.add(str, value)
      end

      def get_in_item_by_str(str)
        @item_by_str[str]
      end

      def add_item_by_sym(sym, value)
        @item_by_sym.add(sym, value)
      end

      def get_in_item_by_sym(sym)
        @item_by_sym[sym]
      end

      def add_item_by_ruby_obj(ruby_obj, value)
        @item_by_ruby[ruby_obj] = value
      end

      def get_in_item_by_ruby_obj(ruby_obj)
        @item_by_ruby[ruby_obj]
      end
    end

    def to_s
      @name
    end

    def l
      @name
    end

    def add_item(child)
      @items << child
    end

    def initialize( name_sym, ruby_obj , parent , level )
      @name_sym = name_sym
      @name_str = Util.sym_to_name(name_sym)
      @ruby_obj = ruby_obj
      @level = level
      if @ruby_obj.instance_of?(Class)
        @kind = :class
      elsif @ruby_obj.instance_of?(Module)
        @kind = :module
      else
        @kind = :instance
      end
      @target = false
      @adjust_type = nil
      @items = []
      @parent = parent
      @parent&.add_item( self )
      # Nsクラスでは第二引数のns_keyを使用する。
      # ここでは返値を@ns_keyに設定しているので矛盾している。
      # 仮対応済み
      @ns_key = self.class.add_ns( parent , @name )
      @iteminfo = Iteminfo.new(@ruby_obj, @kind, @target, @name_str)
      case @kind
      when :class
        @iteminfo.setup_for_class_special
        @iteminfo.setup_for_class_only
        @iteminfo.setup_for_class_and_module
      when :module
        @iteminfo.setup_for_module_special
        @iteminfo.setup_for_module_only
        @iteminfo.setup_for_class_and_module
      else
        raise "unknown kind"
      end

      self.class.add_item_by_sym( @name_sym, self )
      self.class.add_item_by_str( @name_str, self )
      self.class.add_item_by_ruby_obj(@ruby_obj, self)
      # for debug
      self.class.add_adjust(@name_str, { :item => self, :adjust_type => nil , :error => nil })
    end

    def set_adjust_type(val)
      hs = self.class.get_adjust_by_name(@name_str)
      hs[:adjust_type] = val
      @adjust_type = val
    end

    def get_adjust_type
      hs = self.class.get_adjust_by_name(@name_str)
      hs[:adjust_type]
    end

    def target_on
      @target = true
    end

    def target?
      @target
    end

    def set_adjust_result(val, error)
      hs = self.class.get_adjust_by_name(@name_str)
      hs[:adjust] = val
      hs[:error] = error
    end

    def set_adjust_result_error(error)
      hs = self.class.get_adjust_by_name(@name_str)
      hs[:error] = error
    end

    def adjust_result_nil_or_0?
      hs = self.class.get_adjust_by_name(@name_str)
      hs[:error].nil? || hs[:error] == 0
    end

    def dump_in_hash
      @hs = @iteminfo.dest
    end

    def show_dump_in_hash
      @hs.map{|x| Util.debug("#{x[0]}=#{x[1]}")}
    end

    def <=>(other)
      @name <=> other.name
    end

    def adjust(&)
      @iteminfo.adjust(&)
    end
  end

  class Itemobj < Item
    #    attr_reader :name_sym, :name_str, :items, :ruby_obj, :level, :kind, :target, :adjust_type, :parent,:ns_key
    # 	 attr_accessor :iteminfo

    @ns = Ns.new
    @adjust = {}
    #    @@varnames = Setx.new
    #    @@varnames_for_dump = Varnametable.new

    @item_by_str = Hashx.new
    @item_by_sym = Hashx.new

    #    def initialize( name_sym, ruby_obj , parent , level )
    #      super( name_sym, ruby_obj , parent , level )
    #    end
  end

  class Itemdiff < Item
    attr_reader :name_sym, :name_str, :items, :ruby_obj, :level, :kind, :target, :adjust_type, :parent, :ns_key
    attr_accessor :iteminfo

    def initialize(init_item, now_item)
      @name_sym = init_item.name_sym
      @ruby_obj = init_item.ruby_obj
      @level = init_item.level
      @kind = init_item.kind

      now_item.iteminfo -= init_item.iteminfo
    end
  end
end
