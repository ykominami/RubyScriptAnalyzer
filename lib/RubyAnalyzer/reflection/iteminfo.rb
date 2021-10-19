module RubyAnalyzer
  class Iteminfo
		attr_accessor :src, :dest, :processd

		def initialize(ruby_obj, kind, target, name)
			@ruby_obj = ruby_obj
			@kind = kind
			@target = target
			@name = name

			@src = {}
			@dest = {}
			@processd = false

			@adjust_type = nil

			@item_names_for_class_only = []
			@item_names_for_module_only = []
			@special_item_names_for_class_only = [:included_modules, :ancestors, :superclass]
			@special_item_names_for_module_only = [:included_modules, :ancestors, ]

			@item_names = [
				:superclass,
				# instance methods defined in Module class
				:class_variables,
				[:class_methods, :class_methods_in_user_defined_class],
				[:constants, :constants_in_user_defined_class],
				[:instance_methods, :instance_methods_in_user_defined_class],
				:instance_variables,
				[:private_instance_methods, :private_instance_methods_in_user_defined_class],
				[:protected_instance_methods, :protected_instance_methods_in_user_defined_class],
				[:public_instance_methods,	:public_instance_methods_in_user_defined_class],
				# instance methods defined in Object class
				[:methods, :methods_in_user_defined_class],
				[:private_methods, :private_methods_in_user_defined_class],
				[:protected_methods, :protected_methods_in_user_defined_class],
				[:public_methods, :public_methods_in_user_defined_class],
	#			:singleton_methods, :singleton_methods_in_user_defined_class,
			]
			@vars = {}
#			@vars[:class] = @item_names_for_class_only + @item_names
#			@vars[:module] = @item_names_for_module_only + @item_names
			@vars[:class] = @item_names
			@vars[:module] = @item_names
		end

		def adjust(&block)
			@vars[@kind].map{|key|
				if key.class == Array
					block.call(key[0], @src, @dest, @ruby_obj, @kind, @target, @adjust_type, true)
					block.call(key[1], @src, @dest, @ruby_obj, @kind, @target, @adjust_type, false)
				else
					block.call(key, @src, @dest, @ruby_obj, @kind, @target, @adjust_type, true)
				end
			}
		end

		def set_adjust_type(adjust_type)
			@adjust_type = adjust_type
		end

		def setup_for_class_only
			@item_names_for_class_only.flatten.map{ |key| setup_item(key) }
			@processd = true
		end

		def setup_for_module_only
			@item_names_for_module_only.flatten.map{|key| setup_item(key) }
			@processd = true
		end

		def setup_for_class_and_module
			@item_names.flatten.map{ |key| setup_item(key) }
			@processd = true
		end

		def setup_for_class_special
			@special_item_names_for_class_only.map{ |x| setup_special_item(x) }
		end

		def setup_for_module_special
			@special_item_names_for_module_only.map{ |x| setup_special_item(x) }
		end

		def setup_special_item(key)
			case key
			when :included_modules
				@src[key] = get_included_modules
				@dest[key] = @src[key].map(&:to_s)
			when :ancestors
				@src[key] = get_ancestors
				@dest[key] = @src[key].map(&:to_s)
			when :superclass
				@src[key] = get_superclass
				Util.debug %Q!>>>>>>>>>> A #{@src[key].class} Iteminfo setup_special_item item.name=#{@name} @src[#{key}]=#{@src[key]}!
				if @src[key].class != Class
					list = @src[:ancestors] - @src[:included_modules]
					@src[key] = list[1]
					Util.debug %Q!>>>>>>>>>> B Iteminfo setup_special_item item.name=#{@name} @src[#{key}]=#{@src[key]}!
				end
			end
		end

		def setup_item(key)
			#if @name == "CDLString"
			#	puts %Q!name=#{@name} key=#{key}!
			#end

			case key
      when :class_variables
				@src[key] = get_class_variables
			when :class_methods
				@src[key] = get_class_methods
				Util.debug "get_class_methods=nil @name=#{@name}" if src[key] == nil
      when :class_methods_in_user_defined_class
				@src[key] = get_class_methods_in_user_defined_class
			when :constants
				@src[key] = get_constants
			when :constants_in_user_defined_class
				@src[key] = get_constants_in_user_defined_class
      when :instance_methods
				@src[key] = get_instance_methods
      when :instance_methods_in_user_defined_class
				@src[key] = get_instance_methods_in_user_defined_class
      when :instance_variables
				@src[key] = get_instance_variables
			when :private_instance_methods
				@src[key] = get_private_instance_methods
			when :private_instance_methods_in_user_defined_class
				@src[key] = get_private_instance_methods_in_user_defined_class
      when :protected_instance_methods
				@src[key] = get_protected_instance_methods
      when :protected_instance_methods_in_user_defined_class
				@src[key] = get_protected_instance_methods_in_user_defined_class
			when :public_instance_methods
				@src[key] = get_public_instance_methods
			when :public_instance_methods_in_user_defined_class
				@src[key] = get_public_instance_methods_in_user_defined_class
			# instance methods defined in Object class
			when :methods
				@src[key] = get_methods
			when :methods_in_user_defined_class
				@src[key] = get_methods_in_user_defined_class
			when :private_methods
				@src[key] = get_private_methods
			when :private_methods_in_user_defined_class
				@src[key] = get_private_methods_in_user_defined_class
			when :protected_methods
				@src[key] = get_protected_methods
			when :protected_methods_in_user_defined_class
				@src[key] = get_protected_methods_in_user_defined_class
			when :public_methods
				@src[key] = get_public_methods
			when :public_methods_in_user_defined_class
				@src[key] = get_public_methods_in_user_defined_class

			else
				#
			end
			Util.debug "Iteminfo#setup_item key=#{key} @name=#{@name} kind=#{@kind} target=#{@target} @src[#{key}]=nil" unless @src[key]
    end
		###################
		def get_ancestors
			@ruby_obj.ancestors
		end

		def get_class_variables
			Module.class_variables
		end

		def get_class_methods
			@ruby_obj.singleton_methods
		end

		def get_class_methods_in_user_defined_class
			@ruby_obj.singleton_methods(false)
		end

		def get_constants
			@ruby_obj.constants
		end

		def get_constants_in_user_defined_class
			@ruby_obj.constants(false)
		end

		def get_included_modules
			@ruby_obj.included_modules
		end

		def get_instance_methods
			@ruby_obj.instance_methods
		end

		def get_instance_methods_in_user_defined_class
			@ruby_obj.instance_methods(false)
		end

		def get_instance_variables
			@ruby_obj.instance_variables
		end

		def get_private_instance_methods
			@ruby_obj.private_instance_methods
		end

		def get_private_instance_methods_in_user_defined_class
			@ruby_obj.private_instance_methods(false)
		end

		def get_protected_instance_methods
			@ruby_obj.protected_instance_methods
    end

		def get_protected_instance_methods_in_user_defined_class
			@ruby_obj.protected_instance_methods(false)
    end

		def get_public_instance_methods
			@ruby_obj.public_instance_methods
		end

		def get_public_instance_methods_in_user_defined_class
			@ruby_obj.public_instance_methods(false)
		end

		def get_methods
			@ruby_obj.methods
		end

		def get_methods_in_user_defined_class
			@ruby_obj.methods(false)
		end

		def get_private_methods
			@ruby_obj.private_methods
		end

		def get_private_methods_in_user_defined_class
			@ruby_obj.private_methods(false)
		end

		def get_protected_methods
			@ruby_obj.protected_methods
		end

		def get_protected_methods_in_user_defined_class
			@ruby_obj.protected_methods(false)
		end

		def get_public_methods
			@ruby_obj.public_methods
		end

		def get_public_methods_in_user_defined_class
			@ruby_obj.public_methods(false)
		end

		####
		# for class
		def get_superclass
      @ruby_obj.superclass
		end
	end
end
