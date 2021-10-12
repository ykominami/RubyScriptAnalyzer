# coding: utf-8
require 'inheritancespace'
require 'env'
require 'util'
require 'listex'

module RubyAnalyzer
  class Itembase
    attr_accessor :obj, :iv, :name, :ns_children, :ns_key, :inheritance_key, :ancestor, :ancestor_list, :iv_oc, :iv_without_oc, :ancestors

    #    extend Forwardable

    Env.register_reflection( self )
    @@module_name = Util.get_top_module_name( self )

    #    INFO_VAR_STRUCT = Struct.new("Info" , *INFO_STRUCT_SYMBOLS)
    #    @@info_var_struct = INFO_VAR_STRUCT
    INFO_STRUCT_DUMMY = %i!dummy_x!
    INFO_STURCT_WITH_FALSE_SYMBOLS = %i!instance_methods public_instance_methods private_instance_methods protected_instance_methods singleton_methods !
    INFO_STURCT_WITHOUT_FALSE_SYMBOLS = %i!instance_variables_ex class_variables included_modules!
    INFO_STRUCT_SYMBOLS = INFO_STRUCT_DUMMY + INFO_STURCT_WITH_FALSE_SYMBOLS + INFO_STURCT_WITHOUT_FALSE_SYMBOLS
    INFO_STRUCT_VAR = Struct.new( *INFO_STRUCT_SYMBOLS )
    array = INFO_STRUCT_SYMBOLS + %i!inheritance target_inst target_class root open_class!
    InfoStruct = Struct.new( *array )

    class << self
      def init( env , kind )

        case kind
        when :reflection
          @@env = env
          @@env[:INFO] = {}
          @@env[:INFO][:SELF] = InfoStruct.new
          @@cv = @@env[:INFO][:SELF]
          @@env[:INFO][:AVAILABLE] = InfoStruct.new
          @@cv_available = @@env[:INFO][:AVAILABLE]
          @@env[:INFO][:OPEN_CLASS] = InfoStruct.new
          @@cv_oc = @@env[:INFO][:OPEN_CLASS]
          @@env[:INFO][:WITHOUT_OPEN_CLASS] = InfoStruct.new
          @@cv_without_oc = @@env[:INFO][:WITHOUT_OPEN_CLASS]
          
          @@cv.inheritance = InheritanceSpace.new
          @@cv.target_inst = Listex.new
          @@cv.target_class = {}
          @@cv.root = nil
          @@cv.open_class = []

          Item.init
        else
          #
        end
      end

      def set_module_name( name )
        @@module_name = name
      end
      
      def register_all_ancestor_of_all_item
        @@cv.target_inst.each do |k|
          obj = Env.inst_at(k)
          register_all_ancestor( obj )
        end
      end
      
      def register_all_ancestor( obj )
        unless obj.kind_of?( Item )
                           Itembase.new( obj )
        end
      end
      
      def register_as_root( item )
        inst_index = Env.inst_index( item )
        @@cv.root = inst_index
      end

      def register( item )
        if item.class == Class || item.class == Module
          # a instance of any class
          raise
        end

        if Util.get_top_module_name( item.class ) != @@module_name && item.class != Object
          raise
        end

        klass_index = Env.klass_add( item.obj.class )
        inst_index = Env.inst_add( item )
        
        @@cv.target_inst.add( inst_index )
        @@cv.target_class[klass_index] ||= []
        @@cv.target_class[klass_index] << inst_index
      end

      def is_root?( item )
        get_root.obj == item.obj
      end

      def get_root
        @@cv.root
      end

      def register_as_open_class( item )
        @@cv.open_class << item
      end

      def get_open_class( item )
        @@cv.open_class[ item ]
      end

      def set_for_user_defined_class
        Util.debug( "==== set_for_user_defined_class" )
        size = @@cv.target_inst.size
        0.upto(size-1).each do |index|
          item = Env.inst_at( @@cv.target_inst.at(index) )
          ancestor_list = item.ancestor_list
          if item.respond_to?( :name )
            Util.debug( "item.name=#{item.name}" )
          end
          Util.debug( "ancestor_list=#{ancestor_list}" )
          ancestor_list.each do | ancestor_klass_index |
            ancestor_item = Env.klass_at( ancestor_klass_index )
            Util.debug( "ancestor_item.name=#{ancestor_item.name}" )
            INFO_STURCT_WITHOUT_FALSE_SYMBOLS.each do |kind|
              Util.debug( "kind=#{kind}" )
              if ancestor_item.respond_to?(:iv)
                Util.debug( "ancestor_item.iv[ kind ]=#{ancestor_item.iv[ kind ]}")
                
                item.iv[ kind ] -= ancestor_item.iv[ kind ]
                
                Util.debug( "item.iv[ kind ]=#{item.iv[ kind ]}" )
                Util.debug( "" )
              end
            end
          end
        end
      end

      def add_to_inheritance_in_cv( klass, array)
        @@cv.inheritance.add( array, klass )
      end

      def sort_by_ancestor
        xhs = {}
        @@cv.target_inst.each do |index|
          v = Env.inst_at(index)
          xhs[ v.ancestor ] ||= []
          xhs[ v.ancestor ] << index
        end
        @@cv.target_inst.each do |index|
          v = Env.inst_at(index)
          xhs[ v.ancestor ] ||= []
          xhs[ v.ancestor ] << index
        end
        xhs.each do |klass_index , v|
          "klass_index=#{klass_index}"
          array = v.map{|i| Env.inst_at(i)}
          Util.debug( "# #{klass_index}" )
          Util.debug_pp( array.map{|x| x.name } )
        end
      end

      def sort_by_target_inst
        Util.debug( "@@cv.target_inst.size=#{@@cv.target_inst.size}" )
        @@cv.target_inst.each do |k|
          Util.debug( k )
        end
      end

      def sort_by_ns_key
        xhs = {}
        @@cv.target_inst.each do |index|
          v = Env.inst_at( index )
          xhs[ v.ns_key ] ||= []
          xhs[ v.ns_key ] << v
        end
        xhs2 = xhs.select{ |k,v| k != nil }
        xhs3 = xhs2.sort_by{|k2,v2| k2}
        Util.debug_pp( "xhs3.size=#{xhs3.size}" )
        xhs3.each do |k3,v3|
          array = k3.split('::')
          len = array.size
          Util.debug( "#{Util.indent(len)}#{array.last}" )
        end
      end

      def show_class_variables
        @@cv.target_inst.each do |index|
          v = Env.inst_at(index)
          Util.debug_pp( "# show_class_variables index=#{index}" )
          #          exclude = :EXCLUDE_OPEN_CLASS
          exclude = nil
          Util.debug( v.get_class_variables( exclude ) )
        end
      end

      def show_class_related_info( klass , target = :SELF )
        klass_index = Env.klass_index( klass )
        raise unless klass_index
        array = @@cv.target_class[ klass_index ]
        unless array
#          raise
        else
          if array.size == 1
            inst = array[0]
          else
            raise
          end
          inst.print_class_related_info( target )
        end
      end

      def show_all_class_related_info( target = :SELF )
        @@cv.target_inst.each do |index|
          v = Env.inst_at(index)
          if v.respond_to?( :print_class_related_info )
            v.print_class_related_info( target )
          end
        end
      end

      def get_item_of_object
        klass_index = Env.klass_index( Object )
        @@cv.target_class.at[ klass_index ]
      end
    end
    
    def initialize( obj )
      init_basic( obj )
      init_env( obj )
    end

    def init_basic(obj)
      inst_index = Env.inst_add(obj)
      @obj = inst_index
      @name = obj.to_s
      ancestor_list = []
      if obj.respond_to?(:ancestors)
        ancestor_list = obj.ancestors.reverse
        ancestor_list.pop
        @ancestor_list = ancestor_list.map{|x| Env.klass_add(x)}
        @ancestor_list.each do |klass_index|
          o = Env.klass_at( klass_index )
          if o == nil
            raise
          end
        end
        @ancestor_list.shift
        if @ancestor_list
          @ancestor = @ancestor_list[0]
        else
          @ancestor = nil
        end
      else
        @ancestor_list = []
        @ancestor = nil
      end
      key_array = ancestor_list.map{ |x| x.to_s }
      Util.debug( "key_array=#{key_array}" )
      @inheritance_key = Itembase.add_to_inheritance_in_cv( inst_index, key_array )
      @ns_children = Listex.new
    end

    def init_env( obj )      
      @env = {}
      @env[:INFO] = {}
      @iv = @env[:INFO][:SELF] = INFO_STRUCT_VAR.new
      @iv_available = @env[:INFO][:AVAILABLE] = INFO_STRUCT_VAR.new
      @iv_ancestor = @env[:INFO][:ANCESTOR] = INFO_STRUCT_VAR.new
      @iv_oc = @env[:INFO][:OPEN_CLASS] = INFO_STRUCT_VAR.new
      @iv_without_oc = @env[:INFO][:WITHOUT_OPEN_CLASS] = INFO_STRUCT_VAR.new
      INFO_STURCT_WITH_FALSE_SYMBOLS.map{|x|
        if obj.respond_to?( x )
           @iv[x] = obj.__send__( x, false )
        else
           @iv[x] = []
        end
        @iv_available[x] = @iv[x].dup
        @iv_ancestor[x] = []
        @iv_oc[x] = []
        @iv_without_oc[x] = []
      }
      INFO_STURCT_WITHOUT_FALSE_SYMBOLS.map{|x|
        x2 = x.to_s.sub(/_ex$/, '').to_sym
        if obj.respond_to?( x2 )
           @iv[x] = obj.__send__( x2 )
        else
           @iv[x] = []
        end
        @iv_available[x] = @iv[x].dup
        @iv_ancestor[x] = []
        @iv_oc[x] = []
        @iv_without_oc[x] = []
      }
      @noname_defined_constants = []
      @not_defined_constants = []
      @not_respond_to_ancestors_constants = []
      @exclude_class_constants = []
    end

    def add_ns_child( item )
      index = Env.inst_add(item)
      @ns_children.add( index )
    end

    # TODO おーぷんくらすをみつける手段を用意していないため、このままでは未完
    def set_open_class_info( from )
      return if from

      INFO_STRUCT_SYMBOLS.map{ |sym|
        tmp = from.iv[sym]
        unless tmp
          tmp = []
          from.iv[sym] = tmp
        end
        @iv_oc[sym] = tmp
        
        unless @iv[sym]
          @iv[sym] = []
        end
        @iv_oc[sym] = @iv[sym] - from.iv[sym]
        
        @iv_without_oc[sym] = @iv[sym] - @iv_oc[sym]
      }
    end

    def get_class_variables( exclude = :EXCLUDE_OPEN_CLASS )
      if exclude == :EXCLUDE_OPEN_CLASS
        unless @iv.class_variables
          Util.debug( "----Error get_class_variables name=#{@name} @iv" )
          @iv.class_variables = []
        end
        unless @iv_oavailable.class_variables
          Util.debug( "----Error get_class_variables name=#{@name} @iv_available" )
          @iv_available.class_variables = []
        end
        unless @iv_oc.class_variables
          Util.debug( "----Error get_class_variables name=#{@name} @iv_oc" )
          @iv_oc.class_variables = []
        end
        Util.debug( "@iv_without_oc.class_variables=#{@iv_without_oc.class_variables}" )
        @iv_without_oc.class_variables
      else
        Util.debug( "get_class_variables 2" )
        @iv.class_variables
      end
    end

    def add_noname_defined_constant( x )
      if x.instance_of?( String )
        @noname_defined_constants << x
      else
        raise
      end
    end

    def add_not_defined_constant( x )
      if x.instance_of?( String )
        @not_defined_constants << x
      else
        raise
      end
    end

    def add_not_respond_to_ancesstors_constant( x )
      if x.instance_of?( String )
        @not_respond_to_ancestors_constants << x
      else
        raise
      end
    end

    def add_exclude_class_constant( x )
      if x.instance_of?( String )
        @exclude_class_constants << x
      else
        raise
      end
    end

    def get_info_instance_methods
      get_info_list(@iv_available.instance_methods)
    end

    def get_info_instance_methods_in_user_defined_class
      get_info_list(@iv.instance_methods_in_user_defined_class)
    end

    def get_info_public_instance_methods
      get_info_list(@iv_available.public_instance_methods)
    end

    def get_info_public_instance_methods_in_user_defined_class
      get_info_list(@iv.public_instance_methods)
    end

    def get_info_private_instance_methods
      get_info_list(@iv_available.private_instance_methods)
    end

    def get_info_private_instance_methods_in_user_defined_class
      get_info_list(@iv.private_instance_methods)
    end

    def get_info_protected_instance_methods
      get_info_list(@iv_available.protected_instance_methods)
    end

    def get_info_protected_instance_methods_in_user_defined_class
      get_info_list(@iv.protected_instance_methods)
    end

    def get_info_class_methods
      get_info_list(@iv_available.singleton_methods)
    end

    def get_info_class_methods_in_user_defined_class
      get_info_list(@iv.class_methods)
    end

    def get_info_class_variables
      get_info_list(@iv_available.class_variables)
    end

    def get_info_class_variables_in_user_defined_class
      get_info_list(@iv.class_variables)
    end

    def get_info_instance_variables
      #      get_info_list(@iv_available.instance_variables)
      get_info_list(@iv_available.instance_variables_ex)
    end

    def get_info_instance_variables_in_user_defined_class
      get_info_list(@iv.instance_variables)
    end

    def get_info_not_defined_constants
      get_info_list(@not_defined_constants)
    end

    def get_info_exclude_class_constants
      get_info_list(@exclude_class_constants)
    end

    def get_info_included_modules
      get_info_list(@iv.included_modules)
    end

    def get_info_list(list)
      lines = []
      level = @level
      level = 0 unless level
      if list.size > 0
        list.each do |x|
          lines << "#{Util.indent(level)} #{x.to_s}"
        end
      else
        lines << "#{Util.indent(level)} []"
      end
      lines
    end

    def get_class_related_info( target = :SELF )
      lines = []
      level = @level
      level = 0 unless level
      lines << "#{Util.indent( level )}Class #{@name} ancestor_list=#{@ancestor_list}"
      lines << "#{Util.indent( level )} == public_instance_method in user defined class =="
      lines << get_info_public_instance_methods_in_user_defined_class
      lines << "#{Util.indent( level )} == private_instance_method in user defined class =="
      lines << get_info_private_instance_methods_in_user_defined_class
      lines << "#{Util.indent( level )} == protected_instance_method in user defined class =="
      lines << get_info_protected_instance_methods_in_user_defined_class
      lines << "#{Util.indent( level )} == class_variables =="
      lines << get_info_class_variables
      lines << "#{Util.indent( level )} == instance_variables =="
      lines << get_info_instance_variables
      lines << "#{Util.indent( level )} == not_defined_constants =="
      lines << get_info_not_defined_constants
      lines << "#{Util.indent( level )} == exclude_class_constants =="
      lines << get_info_exclude_class_constants
      lines << "#{Util.indent( level )} == included_modules =="
      lines << get_info_included_modules
      lines
    end

    def print_class_related_info( target = :SELF )
      Util.debug( get_class_related_info( target ) )
    end

    def print_included_modules
      Util.debug(  get_info_included_modules )
    end

  end
end
