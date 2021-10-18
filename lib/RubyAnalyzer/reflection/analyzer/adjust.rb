module RubyAnalyzer
  class Analyzer
    def adjust_items(item)
      adjust_child_items(item)
    end

    def adjust_child_items(item)
#      Util.debug_pp "adjust_child_items respond item.nme=#{item.name_str}"
      case @data_op_flag
      when :one
        list = item.items[0..1].to_a
      when :two
        list = item.items[0..2].to_a
      else
        list = item.items
      end

      list.map{ |child_item| adjust_child_item(child_item)}
    end

    def adjust_child_item(child_item)
#      Util.debug "adjust_child_items child_item.name_str=#{child_item.name_str}"
      adjust_item(child_item, child_item.get_adjust_type)
=begin
      if @data_op_level == :all
				adjust_child_items(child_item)
			end
=end
    end

    def adjust_item(item, adjust_type)
#			Util.debug "adjust_item A item.name_str=#{item.name_str}"
			return unless item.target?
#			Util.debug "adjust_item B item.name_str=#{item.name_str}"
      adjust_hs = {:item => item, :error => 0}
#     Util.fatal "adjust_type=#{adjust_type} item.name_str=#{item.name_str} item.kind=#{item.kind}"

			Util.debug "item.kind=#{item.kind}"
			Util.debug "item.ancestors=#{item.ancestors}"
			Util.debug item.ruby_obj.ancestors
#			Util.debug item.ruby_obj.superclass
			Util.debug item.ruby_obj.included_modules
			if @item_adjust_result == nil
        Util.fatal "@item_adjust_result=nil"
      else
        Util.info "@item_adjust_result.class=#{@item_adjust_result.class}"
      end
      if @item_adjust_result[adjust_type] == nil
        Util.fatal "@item_adjust_result[#{adjust_type}]=nil"
      else
        Util.info "@item_adjust_result[#{adjust_type}]=#{@item_adjust_result[adjust_type]}"
      end
			unless item.ancestors
        Util.debug "unless 1 item.name_str=#{item.name_str}"
        if item.ancestors
          Util.debug "item.ancestors.size=#{item.ancestors.size}"
        else
          Util.debug "item.ancestors=nil}"
        end
        Util.debug ""
        adjust_hs[:error] = 1
				item.set_adjust_result(adjust_type, 1)
				raise
        return
      end
      Util.debug "item.name_str=#{item.name_str}"

      ancestor0 = item.ancestors[0]
      ancestor = item.ancestors[1]
      unless ancestor
        Util.debug "unless 2 ancestor=nil ancetor0=#{ancestor0} ancestors.size=#{item.ancestors.size}"
        Util.debug ""
        adjust_hs[:error] = 2
        item.set_adjust_result(adjust_type, 2)
				raise
        return
      end
#      Util.debug "ancestor0=#{ancestor0.to_s}"
#      Util.debug "ancestor=#{ancestor.to_s}"

      ancestor0_name_str = ancestor0.to_s
      ancestor_name_str = ancestor.to_s
      Util.debug "ancestor0_name_str=#{ancestor0_name_str}"
      Util.debug "ancestor_name_str=#{ancestor_name_str}"
			ancestor_item = Item.get_in_item_by_ruby_obj(ancestor)
#      ancestor_item = item_by_name[ancestor_name_str]
      unless ancestor_item
        Util.debug "unless 3 ancestor_item=nil ancestor_name_str=#{ancestor_name_str} ancestors.size=#{item.ancestors.size}"
        Util.debug ""
        adjust_hs[:error] = 3
        item.set_adjust_result(adjust_type, 3)
				raise
        return
      end
      Util.debug "ancestor_item=#{ancestor_item}"
      Util.debug "ancestor_item.name_str=#{ancestor_item.name_str}"
      Util.debug "ancestor_name_str=#{ancestor_name_str}"
      Util.debug "adjust_item check Pass! adjust_type=#{adjust_type}"
#			exit
      item.set_adjust_result(adjust_type, 0)
      Util.debug_pp item.name_str
      Util.debug_pp ancestor_item.name_str
			Item.get_varnames_for_dump.each do |tableitem|
				p "tableitem.src=#{tableitem.src}"
        item.instance_variable_set(tableitem.dest, item.instance_variable_get(tableitem.src) - ancestor_item.instance_variable_get(tableitem.src))
			end

			Util.debug "adjust_item END========="
      Util.debug ""
    end

    def adjust_item0(item, adjust_type)
#			Util.debug "adjust_item A item.name_str=#{item.name_str}"
			return unless item.target?
#			Util.debug "adjust_item B item.name_str=#{item.name_str}"
			adjust_hs = {:item => item, :error => 0}
#     Util.fatal "adjust_type=#{adjust_type} item.name_str=#{item.name_str} item.kind=#{item.kind}"

			Util.debug "item.kind=#{item.kind}"
			Util.debug "item.ancestors=#{item.ancestors}"
			Util.debug item.ruby_obj.ancestors
#			Util.debug item.ruby_obj.superclass
			Util.debug item.ruby_obj.included_modules
			if @item_adjust_result == nil
				Util.fatal "@item_adjust_result=nil"
			else
				Util.info "@item_adjust_result.class=#{@item_adjust_result.class}"
			end
			if @item_adjust_result[adjust_type] == nil
				Util.fatal "@item_adjust_result[#{adjust_type}]=nil"
			else
				Util.info "@item_adjust_result[#{adjust_type}]=#{@item_adjust_result[adjust_type]}"
			end
			unless item.ancestors
				Util.debug "unless 1 item.name_str=#{item.name_str}"
				if item.ancestors
					Util.debug "item.ancestors.size=#{item.ancestors.size}"
				else
					Util.debug "item.ancestors=nil}"
				end
				Util.debug ""
				adjust_hs[:error] = 1
				item.set_adjust_result(adjust_type, 1)
				raise
				return
			end
			Util.debug "item.name_str=#{item.name_str}"

			ancestor0 = item.ancestors[0]
			ancestor = item.ancestors[1]
			unless ancestor
				Util.debug "unless 2 ancestor=nil ancetor0=#{ancestor0} ancestors.size=#{item.ancestors.size}"
				Util.debug ""
				adjust_hs[:error] = 2
				item.set_adjust_result(adjust_type, 2)
				raise
				return
			end
#      Util.debug "ancestor0=#{ancestor0.to_s}"
#      Util.debug "ancestor=#{ancestor.to_s}"

			ancestor0_name_str = ancestor0.to_s
			ancestor_name_str = ancestor.to_s
			Util.debug "ancestor0_name_str=#{ancestor0_name_str}"
			Util.debug "ancestor_name_str=#{ancestor_name_str}"
			ancestor_item = Item.get_in_item_by_ruby_obj(ancestor)
#      ancestor_item = item_by_name[ancestor_name_str]
			unless ancestor_item
				Util.debug "unless 3 ancestor_item=nil ancestor_name_str=#{ancestor_name_str} ancestors.size=#{item.ancestors.size}"
				Util.debug ""
				adjust_hs[:error] = 3
				item.set_adjust_result(adjust_type, 3)
				raise
				return
			end
			Util.debug "ancestor_item=#{ancestor_item}"
			Util.debug "ancestor_item.name_str=#{ancestor_item.name_str}"
			Util.debug "ancestor_name_str=#{ancestor_name_str}"
			Util.debug "adjust_item check Pass! adjust_type=#{adjust_type}"
#			exit
			item.set_adjust_result(adjust_type, 0)
			Util.debug_pp item.name_str
			Util.debug_pp ancestor_item.name_str
			Item.get_varnames_for_dump.each do |tableitem|
				p "tableitem.src=#{tableitem.src}"
				item.instance_variable_set(tableitem.dest, item.instance_variable_get(tableitem.src) - ancestor_item.instance_variable_get(tableitem.src))
			end
			Util.debug "adjust_item END========="
			Util.debug ""
		end
	end
end
