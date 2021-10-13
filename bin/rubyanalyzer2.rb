require 'forwardable'

module RubyAnalyzer
  class HierSpace
    def initialize
      @hs = {}
    end
    
    def add( key_array , value )
      key_array
      key = ([""] + key_array).join('/')
      @hs[key] = value
      
      key
    end
  end
  
  class InherianceSpace < HierSpace
  end
  
  class Ns < HierSpace
    def add( parent ,  child )
      if parent
        key = [parent.ns_key , child.ns_key].join('/')
      else
        key = ["" , child.ns_key].join('/')
      end
      @hs[key] = child
    end
  end
  
  class Item
    attr_accessor :ns_key , :obj, :name, :ancestors, :level, :inheritace_key,
    :instance_methods,:public_instance_methods,:private_instance_methods,
    :protected_instance_methods, :instance_methods_in_user_defined_class,
      :public_instance_methods_in_user_defined_class,
      :private_instance_methods_in_user_defined_class,
      :protected_instance_methods_in_user_defined_class,
      :class_methods,
      :class_methods_in_user_defined_class,
      :instance_variables

    extend Forwardable
    def_delegator(:@obj, :respond_to?, :respond_to?)
    
    @@ns = Ns.new
    @@inheritance = InherianceSpace.new
    
    def initialize( obj , parent , level )
      @obj = obj
      @name = obj.to_s
      @level = level
      @ancestors = @obj.ancestors
      @inheritace_key = @@inheritance.add( @ancestors , self )
      @ns_key = @@ns.add( parent ,  self )

      @instance_methods = obj.instance_methods
      @public_instance_methods = obj.public_instance_methods
      @private_instance_methods = obj.private_instance_methods
      @protected_instance_methods = obj.protected_instance_methods
      @instance_methods_in_user_defined_class = obj.public_instance_methods false
      @public_instance_methods_in_user_defined_class = obj.public_instance_methods false
      @private_instance_methods_in_user_defined_class = obj.private_instance_methods false
      @protected_instance_methods_in_user_defined_class = obj.protected_instance_methods false
      @class_methods = obj.singleton_methods
      @class_methods_in_user_defined_class = obj.singleton_methods false
      @instance_variables = obj.instance_variables
    end
=begin
    def respond_to?( method )
      
      @obj.respond_to?( method )
    end
=end
  end
  
  class Analyzer
    def initialize( fname , fname2, target_classname_fname, exclude_classname_fname )
      @current = nil
      
      @target_class_list = File.readlines( target_classname_fname ).map{|x| x.chomp}.select{ |y| y !~ /^\s*$/ }
      @exclude_class_list = File.readlines( exclude_classname_fname ).map{|x| x.chomp}.select{ |y| y !~ /^\s*$/ }

      @init_consts = Module.constants
      @init_gv = global_variables
      @init_lv = local_variables

      require fname
      require fname2
      
      @now_consts = Object.constants
      @now_gv = global_variables
      @now_lv = local_variables

      @diff_const = @now_consts - @init_consts
      @diff_gv = @now_gv - @init_gv
      @diff_lv = @now_lv - @init_lv

      item = Item.new( Object , nil , 0 )
      show0( 0, item , @diff_const )
    end

    def get_class_related_info( level , obj )
      if obj.respond_to?(:ancestors)
        @current = Item.new( obj )
        puts "#{indent( level )}Class #{obj.to_s} #{obj.ancestors}"
        puts "#{indent( level )} == instance_methods =="
        print_instance_methods( level, obj )
        puts "#{indent( level )} == public_instance_method =="
        print_public_instance_methods_in_user_defined_class( level, obj )
        puts "#{indent( level )} == private_instance_method =="
        print_private_instance_methods_in_user_defined_class( level, obj )
        puts "#{indent( level )} == protected_instance_method =="
        print_protected_instance_methods_in_user_defined_class( level, obj )
        puts "#{indent( level )} == class_variables =="
        print_class_variables( level, obj )
        puts "#{indent( level )} == instance_variables =="
        print_instance_variables( level, obj )
        #
        show2( level + 1 , obj )
        
      end      
    end
    
    def show_class_related_info( level , item )
      if item.respond_to?(:ancestors)
        puts "#{indent( level )}Class #{item.name} #{item.ancestors}"
        puts "#{indent( level )} == instance_methods =="
        print_instance_methods( level, item )
        puts "#{indent( level )} == public_instance_method =="
        print_public_instance_methods_in_user_defined_class( level, obj )
        puts "#{indent( level )} == private_instance_method =="
        print_private_instance_methods_in_user_defined_class( level, obj )
        puts "#{indent( level )} == protected_instance_method =="
        print_protected_instance_methods_in_user_defined_class( level, obj )
        puts "#{indent( level )} == class_variables =="
        print_class_variables( level, obj )
        puts "#{indent( level )} == instance_variables =="
        print_instance_variables( level, obj )
        #
        show2( level + 1 , obj )
      else
        p "show_class_related_info not respond_to? :ancestors #{obj.class}"
      end
    end
    
    def show0( level , parent_item , list )
      list.each do |x|
        obj = parent_item.obj.const_get( x )
        case obj.class
        when Class
          if @target_class_list.include?( obj.to_s )
            unless @exclude_class_list.include?( obj.to_s )
              item = Item.new( obj , parent_item , level )
#              show_class_related_info( level , obj )
            end
          else
            p "show0 not found #{obj.to_s} in @target_class_list "
          end
        else
          p "0 ELSE"
          #
        end
      end
    end

    def indent( level )
        "#{' ' * level}"
    end

    def show1( level , klass , list )
      list.each do |x|
        obj = klass.const_get( x )
        case obj.class
        when Class
          unless @exclude_class_list.include?( obj.to_s )
            if obj.respond_to?(:ancestors)
              show_class_related_info( level , obj )
              show2( level + 1 , obj )
            else
              p "show1 not respond_to? :ancestors #{obj.class}"
            end
          end
        else
          p "1 ELSE"
          #
        end
      end
    end

    def show2( level , item )
      if item.respond_to?( :constants )
        show1(level , item, item.constants)
      else
        p "show2 not responde_to?(:constants) #{klass.class}"
      end
    end

    def print_instance_methods( level, item )
      if item.instance_methods.size > 0
        item.instance_methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_public_instance_methods( level, item )
      
      if item.public_instance_methods.size > 0
        item.public_instance_methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_private_instance_methods( level, item )
      if item.private_instance_methods.size > 0
        item.private_instance_methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
          puts "#{indent(level)} []"
      end
    end

    def print_protected_instance_methods( level, item )
      if item.protected_instance_methods.size > 0
        item.protected_instance_methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_public_instance_methods_in_user_defined_class( level, item )
      if item.public_instance_methods.size > 0
        item.public_instance_methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
          puts "#{indent(level)} []"
      end
    end

    def print_private_instance_methods_in_user_defined_class( level, item )
      if item.private_instance_methods.size > 0
        item.private_instance_methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_protected_instance_methods_in_user_defined_class( level, item )
      if item.protected_instance_methods.size > 0
        item.protected_instance_methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_class_methods( level, item )
      if item.singleton_methods.size > 0
        item.singleton_methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_class_methods_in_user_defined_class( level, item )
      if item.singleton_methods.size > 0
        item.singleton_methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_class_variables( level, item )
      if item.class_variables.size > 0
        item.class_variables.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_instance_variables( level, item )
      if item.instance_variables.size > 0
        item.instance_variables.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end
  end
end

