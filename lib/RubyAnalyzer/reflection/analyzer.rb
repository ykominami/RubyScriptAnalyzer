require 'RubyAnalyzer/reflection/item'
require 'RubyAnalyzer/util'

module RubyAnalyzer
  class Analyzer
    def initialize( target_classname_fname, exclude_classname_fname, exclude_constname_fname, fname , fname2=nil )
      @current = nil
			fnames = [target_classname_fname, exclude_classname_fname, exclude_constname_fname]
      @target_class_list , @exclude_class_list ,  @exclude_const_list = fnames.map{ |fname|
				list = File.readlines( fname )
				list2 = list.map{ |l| l.split('#').first }
				Util.remove_empty_line( list2 ).map{ |x| x.to_sym }
			}

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

			@defined_class_list = []
			@defined_exclude_class_list = []
			@defined_exclude_const_list = []
			@defined_unknown_list = []
			@defined_not_respond_to_list = []
#      item = Item.new( Object , nil , 0 )
#      show0( 0, item , @diff_const )
    end

		def analyze0
			level = 0
      item = Item.new( Object , nil , 0 )
      @diff_const.each do |x|
				if item.respond_to?(:const_get)
					obj = item.obj.const_get( x )
					# analyze_sub(obj , x, item, level)
					case obj.class
					when Class
						if @target_class_list.include?( x )
							unless @exclude_class_list.include?( x )
								item = Item.new( obj , item , level )
								@defined_class_list << x
							else
								# p "show0 found but excluded #{obj.to_s} in @target_class_list "
								@defined_exclude_class_list << x
							end
						else
							unless @exclude_class_list.include?( x )
								unless @exclude_const_list.include?( x )
									puts "unknow x=#{x}"
									@defined_unknown_list << x
								else
									@defined_exclude_const_list << x
								end
							else
								@defined_exclude_class_list << x
							end
						end
					else
						p "0 ELSE"
						#
					end

				else
					@defined_not_respond_to_list << x
				end
			end
			print_lists
		end

		def print_lists
			#				obj = Object.const_get( x )
			p "@defined_class_list="
			p @defined_class_list.size
			@defined_class_list.map{|x| puts "  #{x}" }
			p "@defined_exclude_class_list ="
			p @defined_exclude_class_list.size
			@defined_exclude_class_list.map{|x| puts "  #{x}" }
			p "@defined_exclude_const_list="
			p @defined_exclude_const_list.size
			@defined_exclude_const_list.map{|x| puts "  #{x}" }
			p "@defined_unknown_list="
			p @defined_unknown_list.size
			@defined_unknown_list.map{|x| puts "  #{x}" }
			p "@defined_not_respond_to_list="
			p @defined_not_respond_to_list.size
			@defined_not_respond_to_list.map{|x| puts "  #{x}" }
			puts ""
			p "@target_class_list="
			p @target_class_list.size
			@target_class_list.map{|x| puts "  #{x}"}
			p "@exclude_class_list="
			p @exclude_class_list.size
			@exclude_class_list.map{|x| puts "  #{x}"}
			p "@exclude_const_list="
			p @exclude_const_list.size
			@exclude_const_list.map{|x| puts "  #{x}"
		end

		def analyze
			level = 0
      item = Item.new( Object , nil , 0 )
      @diff_const.each do |x|
				if item.respond_to?(:const_get)
					obj = item.obj.const_get( x )
					analyze_sub(obj , x, item, level)
				else
					@defined_not_respond_to_list << x
				end
			end
			print_lists
		end

		def analyze_sub(obj , x, item, level)
			case obj.class
			when Class
				if @target_class_list.include?( x )
					puts "target_class_list.include x=#{x}"
					unless @exclude_class_list.include?( x )
						@defined_class_list << x
						level += 1
						item2 = Item.new( obj , item , level )
					else
						puts "  exclude_class_list.include x=#{x}"
						@defined_exclude_class_list << x
					end
				else
					puts "+ not target_class_list x=#{x} x.class=#{x.class}"
					unless @exclude_class_list.include?( x )
						puts " - not exclude_class_list x=#{x} x.class=#{x.class}"
						unless @exclude_const_list.include?( x )
							puts "unknow x=#{x}"
							@defined_unknown_list << x
						else
							puts " * defined_exclude_const_list x=#{x} x.class=#{x.class}"
							@defined_exclude_const_list << x
						end
					else
						puts " / defined_exclude_class_list x=#{x} x.class=#{x.class}"
						@defined_exclude_class_list << x
					end
				end
			else
				p "0 ELSE"
				#
			end
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
						puts "x=#{x} | obj=#{obj}|"
						puts "x=#{x} | obj.to_s=#{obj.to_s}|"
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
