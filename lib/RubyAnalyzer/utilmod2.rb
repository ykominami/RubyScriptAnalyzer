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

		def sort_list!(hs, key)
   #			p "sort_list objx=#{objx}"
			hs[key] = hs[key].sort{|a,b| a <=> b}
		end

		def sort_lists!(hs)
			hs.keys.map{|key| sort_list!(hs, key)}
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

		def print_list(list)
			list.map { |x| puts "  #{x}" }
		end

		def print_lists(hs)
			hs.map{|x|
				# puts "## #{x}"
				print_list(x[1])
			}
		end
	end
end