require "RubyAnalyzer/reflection/tuple"
require "RubyAnalyzer/reflection/setx"
require "RubyAnalyzer/utilmod2"

module RubyAnalyzer
  class Analyzer
    @names = [
      [:class_list, Setx.new],
      [:module_list, Setx.new],
      [:instance_list, Setx.new],
      [:exclude_class_list, Setx.new],
      [:exclude_module_list, Setx.new],
      [:exclude_instance_list, Setx.new],
      [:exclude_const_list, Setx.new],
      [:unknown_class_list, Setx.new],
      [:unknown_module_list, Setx.new],
      [:unknown_instance_list, Setx.new],
      [:not_respond_to_list, Setx.new]
    ]
    AnalyzerResult = Struct.new(*@names.map{|n| n[0]})

    class AnalyzerResult
      include Utilmod2
    end

    def self.create_AnalyzerResult
      AnalyzerResult.new(*@names.map{|n| n[1]}) 
    end
	end
end
