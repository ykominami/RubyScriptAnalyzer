module RubyAnalyzer
  class Analyzer
    def yaml_dump(filepath)
      File.open(filepath, "w") do |file|
        YAML.dump(@output_yaml, file)
      end
    end

    def prepare_yaml_dump(item)
      prepare_yaml_child_items(item)
    end

    def prepare_yaml_child_items(item)
#      Util.debug "prepare_yaml_child_items item.nme=#{item.name_sym}"
#	 		Util.debug "@data_op_flag=#{@data_op_flag}"
			list = []
      case @data_op_flag
      when :one
				list = item.items[0..1].to_a
      when :two
				list = item.items[0..2].to_a
      else
        list = item.items
      end
			list.each do |child_item|
#				Util.debug "prepare_yaml_child_items 1 child_item.name_sym=#{child_item.name_sym}"
				prepare_yaml_item(child_item)
				if @data_op_level == :all
#					Util.debug "prepare_yaml_child_items 2 child_item.name_sym=#{child_item.name_sym} @data_op_level=#{@data_op_level}"
					prepare_yaml_child_items(child_item)
				end
			end
		end

    def prepare_yaml_item(item)
#			Util.debug "prepare_yaml_item A item.name_sym=#{item.name_sym} item.target?=#{item.target?}"
			return unless item.target?
#			Util.debug "prepare_yaml_item B item.name_sym=#{item.name_sym}"


			case item.kind
			when :class , :module
      	@output_yaml[item.kind][item.name_sym] = item.dump_in_hash
			else
				# do nothing
			end
    end
	end
end
