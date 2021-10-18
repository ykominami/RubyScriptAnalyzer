module RubyAnalyzer
	module Utilmod2
		def sort_list_t!(objx)
#			p "sort_list_ex objx=#{objx}"
			new_x = self.instance_variable_get(objx.l).sort{|a,b| a.l <=> b.l}
			self.instance_variable_set(objx.l , new_x)
		end

		def sort_lists_t!(list)
			list.map{|objx| sort_list_t!(objx)}
		end

		def sort_list!(objx)
#			p "sort_list objx=#{objx}"
			new_x = self.instance_variable_get(objx).sort{|a,b| a <=> b}
			self.instance_variable_set(objx , new_x)
		end

		def sort_lists!(list)
			list.map{|objx| sort_list!(objx)}
		end

		def print_list_t(objx)
			self.instance_variable_get(objx.l).map { |x| puts "  #{x.l}" }
		end

		def print_lists_t(list)
			list.map{|x|
				# puts "## #{x}"
				print_list_t(x)
			}
		end

		def print_list(objx)
			self.instance_variable_get(objx).map { |x| puts "  #{x}" }
		end

		def print_lists(list)
			list.map{|x|
				# puts "## #{x}"
				print_list(x)
			}
		end
	end
end