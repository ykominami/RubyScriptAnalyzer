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
    attr_accessor :ns_key
    
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

      show0( 0, Object , @diff_const )
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
    
    def show_class_related_info( level , obj )
      if obj.respond_to?(:ancestors)
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
      else
        p "show_class_related_info not respond_to? :ancestors #{obj.class}"
      end
    end
    
    def show0( level , klass , list )
      list.each do |x|
        obj = klass.const_get( x )
        case obj.class
        when Class
          if @target_class_list.include?( obj.to_s )
            unless @exclude_class_list.include?( obj.to_s )
              show_class_related_info( level , obj )
            end
          else
            p "show0 not found #{obj.to_s} in @target_class_list "
            name = obj.to_s
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

    def show2( level , klass )
      if klass.respond_to?( :constants )
        show1(level , klass, klass.constants)
      else
        p "show2 not responde_to?(:constants) #{klass.class}"
      end
    end

    def print_instance_methods( level, klass )
      methods = klass.instance_methods
      if methods.size > 0
        methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_public_instance_methods( level, klass )
      methods = klass.public_instance_methods
      if methods.size > 0
        methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_private_instance_methods( level, klass )
      methods = klass.private_instance_methods
      if methods.size > 0
        methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
          puts "#{indent(level)} []"
      end
    end

    def print_protected_instance_methods( level, klass )
      methods = klass.protected_instance_methods
      if methods.size > 0
        methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_public_instance_methods_in_user_defined_class( level, klass )
      methods = klass.public_instance_methods false
      if methods.size > 0
        methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
          puts "#{indent(level)} []"
      end
    end

    def print_private_instance_methods_in_user_defined_class( level, klass )
      methods = klass.private_instance_methods false
      if methods.size > 0
        methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_protected_instance_methods_in_user_defined_class( level, klass )
      methods = klass.protected_instance_methods false
      if methods.size > 0
        methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_class_methods( level, klass )
      methods = klass.singleton_methods
      if methods.size > 0
        methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_class_methods_in_user_defined_class( level, klass )
      methods = klass.singleton_methods false
      if methods.size > 0
        methods.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_class_variables( level, klass )
      vars = klass.class_variables
      if vars.size > 0
        vars.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end

    def print_instance_variables( level, klass )
      vars = klass.instance_variables
      if vars.size > 0
        vars.each do |x|
          puts "#{indent(level)} #{x.to_s}"
        end
      else
        puts "#{indent(level)} []"
      end
    end
  end
end

#fname = '/mnt/v/ext2/gem/tecsgen/y51.rb'
#fname = '/mnt/v/ext2/gem/tecsgen/y52.rb'
fname = '/mnt/e/v/ext2/svn-tecs/tecsgen/trunk2/tecsgen/tecsgen.rb'
#fname2 = '/mnt/v/ext2/gem/tecsgen/spec/test_data/r.rb'
fname2 = '/mnt/e/v/ext2/gem/tecsgen/spec/test_data/r-a.rb'

#target_classname_fname = '/mnt/c/Users/ykomi/binr/ra_target_classname.txt'
#target_classname_fname = '/mnt/c/Users/ykomi/binr/target_class-list.txt'
#target_classname_fname = '/mnt/c/Users/ykomi/binr/target_class-list-2.txt'
target_classname_fname = '/mnt/c/Users/ykomi/binr/target_class-list-3.txt'
exclude_classname_fname = '/mnt/c/Users/ykomi/binr/ra_exclude_classname.txt'
RubyAnalyzer::Analyzer.new( fname , fname2,  target_classname_fname, exclude_classname_fname )
