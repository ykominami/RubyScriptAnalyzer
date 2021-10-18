require 'forwardable'
require 'RubyAnalyzer/reflection/inheritancespace'
require 'RubyAnalyzer/reflection/setx'
require 'RubyAnalyzer/reflection/hashx'
require 'RubyAnalyzer/reflection/analyzer/varnametable'
require 'RubyAnalyzer/util'

module RubyAnalyzer
  class Item
    attr_reader :name_sym, :name_str, :items, :ruby_obj, :level, :kind, :target, :parent,:ns_key,
                :ancestors, :inheritace_key,
                :instance_methods,:public_instance_methods,
                :private_instance_methods, :protected_instance_methods,
                :instance_methods_in_user_defined_class,
                :public_instance_methods_in_user_defined_class,
                :private_instance_methods_in_user_defined_class,
                :protected_instance_methods_in_user_defined_class,
                :class_methods,
                :class_methods_in_user_defined_class,
                :instance_variables, :class_variables,
                :constants_in_user_defined_class

    extend Forwardable
    def_delegator(:@ruby_obj, :respond_to?, :respond_to?)

    @ns = Ns.new
    @inheritance = InheritanceSpace.new
    @adjust = {}
    @@varnames = Setx.new
    @@varnames_for_dump = Varnametable.new

    @item_by_str = Hashx.new
    @item_by_sym = Hashx.new
    @@item_by_ruby = Hashx.new

    def self.add_adjust(key, value)
      @adjust[key] = value
    end

    def self.get_adjust
      @adjust
    end

    def self.get_adjust_by_name(key)
      @adjust[key]
    end

    def self.add_inheritance(ancestors, inst)
      @inheritance.add( ancestors , inst )
    end

    def self.add_ns(parent, child_name)
      @ns.add(parent, child_name)
    end

    def self.add_varname(varname)
      @@varnames.add(varname)
    end

    def self.varnames_enable?
      @@varnames.enable?
    end

    def self.varnames_disable
      @@varnames.disable
    end

    def self.get_varnames
      @@varnames
    end

    def self.get_varnames_for_dump
      @@varnames_for_dump
    end

    def self.add_varname_for_dump(varname)
      @@varnames_for_dump.add(varname)
    end

    def self.varnames_for_dump_enable?
      @@varnames_for_dump.enable?
    end

    def self.varnames_for_dump_disable
      @@varnames_for_dump.disable
    end

    def self.get_varnames_for_dump
      @@varnames_for_dump
    end

    def self.add_item_by_str(str, value)
      @item_by_str.add(str, value)
    end

    def self.get_in_item_by_str(str)
      @item_by_str[str]
    end

    def self.add_item_by_sym(sym, value)
      @item_by_sym.add(sym, value)
    end

    def self.get_in_item_by_sym(sym)
      @item_by_sym[sym]
    end

    class << self
      def add_item_by_ruby_obj(ruby_obj, value)
        @@item_by_ruby[ruby_obj] = value
      end

      def get_in_item_by_ruby_obj(ruby_obj)
        @@item_by_ruby[ruby_obj]
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
      if @ruby_obj.class == Class
        @kind = :class
      elsif @ruby_obj.class == Module
        @kind = :module
      else
        @kind = :instance
      end
      @target = false
      @items = []
      @parent = parent
      @parent.add_item( self ) if @parent
      # Nsクラスでは第二引数のns_keyを使用する。
      # ここでは返値を@ns_keyに設定しているので矛盾している。
      # 仮対応済み
      @ns_key = self.class.add_ns( parent , @name )
      #
      case @kind
      when :class, :module
        setup_for_class_and_module
      else
        # do nothing
      end
      self.class.add_item_by_sym( @name_sym, self )
      self.class.add_item_by_str( @name_str, self )
      self.class.add_item_by_ruby_obj(@ruby_obj, self)
      # for debug
      self.class.add_adjust(@name_str, { :item => self, :adjust_type => nil , :error => nil})
    end

    def set_adjust_type(val)
      hs = self.class.get_adjust_by_name(@name_str)
      hs[:adjust_type] = val
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
      hs[:error] == nil || hs[:error] == 0
    end

    def setup_for_class_and_module
      @ancestors = @ruby_obj.ancestors
      self.class.add_varname(:@ancestors)
      self.class.add_varname_for_dump(:@ancestors)
      @adjusted_ancestors = []
      # superclass
      @superclass = @ruby_obj.superclass
      self.class.add_varname(:@superclass)
      self.class.add_varname_for_dump(:@superclass)
      @adjusted_superclass = nil
#      self.class.add_varname_for_dump(:@adjusted_ancestors)

      @inheritace_key = self.class.add_inheritance( @ancestors , self )
      # self.class.add_varname(:@inheritace_key)

      @instance_methods = @ruby_obj.instance_methods
      self.class.add_varname(:@instance_methods)
      @public_instance_methods = @ruby_obj.public_instance_methods
      self.class.add_varname(:@public_instance_methods)
      self.class.add_varname_for_dump(:@public_instance_methods)
      @adjusted_public_instance_methods = []
 #     self.class.add_varname_for_dump(:@adjust_public_instance_methods)
      #
      @private_instance_methods = @ruby_obj.private_instance_methods
      self.class.add_varname(:@private_instance_methods)
      self.class.add_varname_for_dump(:@private_instance_methods)
      @adjusted_private_instance_methods = []
#      self.class.add_varname_for_dump(:@adjust_private_instance_methods)
      #
      @protected_instance_methods = @ruby_obj.protected_instance_methods
      self.class.add_varname(:@protected_instance_methods)
      self.class.add_varname_for_dump(:@protected_instance_methods)
      @adjusted_protected_instance_methods = []
#      self.class.add_varname_for_dump(:@adjust_protected_instance_methods)
      #
      @instance_methods_in_user_defined_class = @ruby_obj.public_instance_methods(false)
      self.class.add_varname(:@instance_methods_in_user_defined_class)
      self.class.add_varname_for_dump(:@instance_methods_in_user_defined_class)
      @adjusted_instance_methods_in_user_defined_class = []
#      self.class.add_varname_for_dump(:@adjust_instance_methods_in_user_defined_class)
      #
      @public_instance_methods_in_user_defined_class = @ruby_obj.public_instance_methods(false)
      self.class.add_varname(:@public_instance_methods_in_user_defined_class)
      self.class.add_varname_for_dump(:@public_instance_methods_in_user_defined_class)
      @adjusted_public_instance_methods_in_user_defined_class = []
#      self.class.add_varname_for_dump(:@adjust_public_instance_methods_in_user_defined_class)
      #
      @private_instance_methods_in_user_defined_class = @ruby_obj.private_instance_methods(false)
      self.class.add_varname(:@private_instance_methods_in_user_defined_class)
      self.class.add_varname_for_dump(:@private_instance_methods_in_user_defined_class)
      @adjusted_private_instance_methods_in_user_defined_class = []
#      self.class.add_varname_for_dump(:@adjust_private_instance_methods_in_user_defined_class)
      #
      @protected_instance_methods_in_user_defined_class = @ruby_obj.protected_instance_methods(false)
      self.class.add_varname(:@protected_instance_methods_in_user_defined_class)
      self.class.add_varname_for_dump(:@protected_instance_methods_in_user_defined_class)
      @adjusted_protected_instance_methods_in_user_defined_class = []
#      self.class.add_varname_for_dump(:@adjust_protected_instance_methods_in_user_defined_class)
      #
      @class_methods = @ruby_obj.singleton_methods
      self.class.add_varname(:@class_methods)
      #self.class.add_varname_for_dump(:@class_methods)
      @class_methods_in_user_defined_class = @ruby_obj.singleton_methods(false)
      self.class.add_varname(:@class_methods_in_user_defined_class)
      self.class.add_varname_for_dump(:@class_methods_in_user_defined_class)
      @adjusted_class_methods_in_user_defined_class = []
#      self.class.add_varname_for_dump(:@adjust_class_methods_in_user_defined_class)
      #
      @instance_variables = @ruby_obj.instance_variables
      self.class.add_varname(:@instance_variables)
      self.class.add_varname_for_dump(:@instance_variables)
      @adjusted_instance_variables = []
#      self.class.add_varname_for_dump(:@adjust_instance_variables)
      #
      @class_variables = Module.class_variables
      self.class.add_varname(:@class_variables)
      self.class.add_varname_for_dump(:@class_variables)
      @adjusted_class_variables = []
#      self.class.add_varname_for_dump(:@adjust_class_variables)
      #
      #      @constants_in_user_defined_class = Module.constants
      @constants_in_user_defined_class = self.class.constants
      self.class.add_varname(:@constants_in_user_defined_class)
      self.class.add_varname_for_dump(:@constants_in_user_defined_class)
      @adjusted_constants_in_user_defined_class = []
#      self.class.add_varname_for_dump(:@adjust_constants_in_user_defined_class)
      #

      self.class.varnames_disable
      self.class.varnames_for_dump_disable
    end

    def dump_in_hash
      @hs = self.class.get_varnames_for_dump.reduce({}){ |hs, tableitem|
        hs[tableitem.src] = instance_variable_get(tableitem.dest)
        hs
      }
    end

    def show_dump_in_hash
      @hs.map{|x| Util.debug "#{x[0]}=#{x[1]}"}
    end

    def <=>(other)
      @name <=> other.name
    end
  end

  class Itemobj < Item
    @ns = Ns.new
    @inheritance = InheritanceSpace.new
    @adjust = {}
#    @@varnames = Setx.new
#    @@varnames_for_dump = Varnametable.new

    @item_by_str = Hashx.new
    @item_by_sym = Hashx.new
  end

  class Itemdiff < Item
    def self.get_varnames
      @@varnames
    end

    def initialize(init_item, now_item)
      @name_sym = init_item.name_sym
      @ruby_obj = init_item.ruby_obj
      @level = init_item.level
      @kind = init_item.kind

      self.class.get_varnames.map{ |sym|
        #Util.debug "sym=#{sym} | #{sym.class}"
        instance_variable_set(sym, now_item.instance_variable_get(sym) - init_item.instance_variable_get(sym))
      }
    end
  end
end
