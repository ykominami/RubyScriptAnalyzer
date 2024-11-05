module RubyAnalyzer
  module Utilmod
    def sort_list!(sym)
      new_list = instance_variable_get(sym).sort
      instance_variable_set(sym , new_list)
    end

    def sort_lists(list)
      list.map{|sym| sort_list!(sym)}
    end

    def print_list(sym)
      p "#{sym}="
      p instance_variable_get(sym).size
      instance_variable_get(sym).map { |x| puts "  #{x.first} #{x[1].class}" }
    end

    def print_lists(list)
      list.map{|x| print_list(x)}
    end
  end
end
