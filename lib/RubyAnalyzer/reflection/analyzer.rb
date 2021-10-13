require 'RubyAnalyzer/reflection/item'
require 'RubyAnalyzer/util'

module RubyAnalyzer  
  class Analyzer
    def initialize( target_classname_fname, exclude_classname_fname, exclude_constname_fname, fname , fname2=nil )
      @current = nil
      @target_class_list = Util.remove_empty_line( File.readlines( target_classname_fname ) )
      @exclude_class_list = Util.remove_empty_line( File.readlines( exclude_classname_fname ) ).map{ |x| x.to_sym }
      @exclude_const_list = Util.remove_empty_line( File.readlines( exclude_constname_fname ) ).map{ |x| x.to_sym }

			@init_consts = Module.constants
      @init_gv = global_variables
      @init_lv = local_variables

      require fname
      require fname2 if fname2
      
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
						else
							# p "show0 found but excluded #{obj.to_s} in @target_class_list "
            end
          else
						#puts "x=#{x} | obj=#{obj}|"
						#puts "x=#{x} | obj.to_s=#{obj.to_s}|"
            unless @exclude_class_list.include?( obj.to_s )
							#puts "@exclude_const_list=#{@exclude_const_list}"
							unless @exclude_const_list.include?( x )
								#puts @exclude_const_list.include?( x )
								#puts x
								#puts x.class
#								puts @exclude_const_list
#								@exclude_const_list.map{|x| puts x.class }
								item = Item.new( obj , parent_item , level )
#              show_class_related_info( level , obj )
							else
								#p "show0 A not found and not excluded and not excluded const| #{obj.to_s} in @target_class_list "
							end
						else
							#p "show0 B not found and not excluded| #{obj.to_s} in @target_class_list "
            end
          end
        else
          #p "0 ELSE"
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