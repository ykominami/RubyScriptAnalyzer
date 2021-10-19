module RubyAnalyzer
  class Analyzer
    def yaml_dump(filepath)
      File.open(filepath, "w") do |file|
        YAML.dump(@output_yaml, file)
      end
    end

    def prepare_yaml_dump(item)
#			Util.debug "# prepare_yaml_dump"
      prepare_yaml_child_items(item)
    end

    def prepare_yaml_child_items(item)
#      Util.debug "prepare_yaml_child_items item.nme=#{item.name_sym}"
#	 		Util.debug "@data_op_flag=#{@data_op_flag}"
#			Util.debug "# prepare_yaml_dump"
				item.items.each do |child_item|
#				Util.debug "prepare_yaml_child_items 1 child_item.name_sym=#{child_item.name_sym}"
				prepare_yaml_item(child_item)
				prepare_yaml_child_items(child_item)
			end
		end

    def prepare_yaml_item(item)
#			Util.debug "prepare_yaml_item A item.name_sym=#{item.name_sym} item.target?=#{item.target?}"
			return unless item.target?
#			Util.debug "prepare_yaml_item B item.name_sym=#{item.name_sym}"


			case item.kind
			when :class , :module
#				Util.debug "prepare_yaml_item C item.kind=#{item.kind}"
      	@output_yaml[item.kind][item.name_sym] = item.dump_in_hash
#				Util.debug "prepare_yaml_item C output=#{@output_yaml[item.kind][item.name_sym]}"
			else
				# do nothing
			end
    end
	end
end
