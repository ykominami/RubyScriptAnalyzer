module RubyScriptAnalyzer
  class Analyzer
    def adjust_child_item_one_level(child_item)
      Util.debug "adjust_child_items child_item.name=#{child_item.name}"
      adjust_item(child_item, child_item.get_adjust_type)
      #adjust_child_items(child_item)
    end


		def get_all_class_related_info
      @result.class_list.map{ |t|
      Util.debug "#[class] #{t.name}"
        get_class_related_info(t)
      }
    end

    def get_all_module_related_info
      @result.module_list.map{ |t|
      Util.debug "#[module] #{t.name}"
        get_module_related_info(t)
      }
    end

    def dump_analyze_result
      #      @result.sort_lists_x!
      #      @result.print_lists_x
#=begin
      Util.debug_pp "==== class"
      print_all_class_related_info
#=end
      Util.debug_pp "==== module"
      print_all_module_related_info
=begin
      Util.debug_pp "==== global variable"
      Util.debug "size=#{@diff_gv.size}"
      @diff_gv.map{|x| Util.debug_pp x}
      Util.debug_pp "==== global variable name"
      Util.debug_pp "size=#{@diff_gvname.size}"
      @diff_gvname.map{|x| Util.debug_pp x}
      Util.debug_pp "==== local variable"
      Util.debug "size=#{@diff_lv.size}"
      @diff_lv.map{|x| Util.debug_pp x}
=end
    end

    def dump_adjust_items_result
      Util.debug %!@item_by_name.size=#{@item_by_name.size}!
      Util.debug %!@name_by_item.size=#{@name_by_item.size}!
      Util.debug %!@item_by_sym.size=#{@item_by_sym.size}!
      Util.debug ""
      Util.debug %!@item_adjust_result.size=#{@item_adjust_result.size}!
      Util.debug %!@not_item_adjust_result.size=#{@not_item_adjust_result.size}!
      adjust = Item.get_adjust
      Util.debug %!adjust.size=#{adjust.size}!
      Util.debug %!@objs.size=#{@objs.size}!
#      Util.debug %!adjust.keys=#{adjust.keys}!
=begin
      hs = {}
      adjust.each do |key, value|
        hs[value[:adjust]] ||= []
        hs[value[:adjust]] << key
      end
      hs.each do |key,value|
        Util.debug "# #{key} #{value.size}"
        value.map{ |x| Util.debug %! #{x}! }
      end
=end
    end

    def print_all_class_related_info
      Util.debug_pp "size=#{@result.class_list.size}"
      @result.class_list.map{ |t|
        Util.debug "#[class] #{t.name}"
        get_class_related_info(t)
      }
    end

    def print_all_module_related_info
      Util.debug_pp "size=#{@result.module_list.size}"
      @result.module_list.map{ |t|
        Util.debug "#[module] #{t.name}"
        get_class_related_info(t)
      }
    end

    def get_class_related_info(item)
      level = 2
      Util.debug "#{indent(level)} Class #{item.name} #{item.ancestors}"
      Util.debug "#{indent(level)} == public_instance_method =="
      Util.debug "#{indent(level)} #{item.instance_methods_in_user_defined_class}"
      Util.debug "#{indent(level)} == private_instance_method =="
      Util.debug "#{indent(level)} #{item.private_instance_methods_in_user_defined_class}"
      Util.debug "#{indent(level)} == protected_instance_method =="
      Util.debug "#{indent(level)} #{item.protected_instance_methods_in_user_defined_class}"
      Util.debug "#{indent(level)} == class_variables =="
      Util.debug "#{indent(level)} #{item.class_variables}"
      Util.debug "#{indent(level)} == instance_variables =="
      Util.debug "#{indent(level)} #{item.instance_variables}"
      Util.debug "#{indent(level)} == constants =="
      Util.debug "#{indent(level)} #{item.constants_in_user_defined_class}"
      Util.debug "#{indent(level)}  == in hash"
#      Util.debug "#{indent(level)} #{item.dump_in_hash}
      item.dump_in_hash
    end

    def get_module_related_info(item)
      level = 2
      Util.debug "#{indent(level)} Module #{item.name} #{item.ancestors}"
      Util.debug "#{indent(level)} == public_instance_method =="
      Util.debug "#{indent(level)} #{item.instance_methods_in_user_defined_class}"
      Util.debug "#{indent(level)} == private_instance_method =="
      Util.debug "#{indent(level)} #{item.private_instance_methods_in_user_defined_class}"
      Util.debug "#{indent(level)} == protected_instance_method =="
      Util.debug "#{indent(level)} #{item.protected_instance_methods_in_user_defined_class}"
      Util.debug "#{indent(level)} == class_variables =="
      Util.debug "#{indent(level)} #{item.class_variables}"
      Util.debug "#{indent(level)} == instance_variables =="
      Util.debug "#{indent(level)} #{item.instance_variables}"
      Util.debug "#{indent(level)} == constants =="
      Util.debug "#{indent(level)} #{item.constants_in_user_defined_class}"
    end

    def show_class_related_info(level, item)
      if item.respond_to?(:ancestors)
        Util.debug "#{indent(level)}Class #{item.name} #{item.ancestors}"
        Util.debug "#{indent(level)} == instance_methods =="
        print_instance_methods(level, item)
        Util.debug "#{indent(level)} == public_instance_method =="
        print_public_instance_methods_in_user_class(level, item)
        Util.debug "#{indent(level)} == private_instance_method =="
        print_private_instance_methods_in_user_class(level, item)
        Util.debug "#{indent(level)} == protected_instance_method =="
        print_protected_instance_methods_in_user_class(level, item)
        Util.debug "#{indent(level)} == class_variables =="
        print_class_variables(level, item)
        Util.debug "#{indent(level)} == instance_variables =="
        print_instance_variables(level, item)
        #
#        show2(level + 1, obj)
      else
        Util.debug_pp "show_class_related_info not respond_to? :ancestors #{obj.class}"
      end
    end

    def indent(level)
      "#{" " * level}"
    end

    def print_instance_methods(level, item)
      if item.instance_methods.size > 0
        item.instance_methods.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_public_instance_methods(level, item)
      if item.public_instance_methods.size > 0
        item.public_instance_methods.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_private_instance_methods(level, item)
      if item.private_instance_methods.size > 0
        item.private_instance_methods.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_protected_instance_methods(level, item)
      if item.protected_instance_methods.size > 0
        item.protected_instance_methods.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_public_instance_methods_in_user_class(level, item)
      if item.public_instance_methods.size > 0
        item.public_instance_methods.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_private_instance_methods_in_user_class(level, item)
      if item.private_instance_methods.size > 0
        item.private_instance_methods.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_protected_instance_methods_in_user_class(level, item)
      if item.protected_instance_methods.size > 0
        item.protected_instance_methods.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_class_methods(level, item)
      if item.singleton_methods.size > 0
        item.singleton_methods.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_class_methods_in_user_class(level, item)
      if item.singleton_methods.size > 0
        item.singleton_methods.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_class_variables(level, item)
      if item.class_variables.size > 0
        item.class_variables.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end

    def print_instance_variables(level, item)
      if item.instance_variables.size > 0
        item.instance_variables.each do |x|
          Util.debug "#{indent(level)} #{x.to_s}"
        end
      else
        Util.debug "#{indent(level)} []"
      end
    end
	end
end
