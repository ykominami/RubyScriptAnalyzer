require "RubyAnalyzer/reflection/tuple"
require "RubyAnalyzer/reflection/setx"
require "RubyAnalyzer/utilmod2"

module RubyAnalyzer
  class Analyzer
    class AnalyzerResult
      attr_accessor :class_list, :module_list, :instance_list, :exclude_class_list, 
                    :exclude_module_list, :exclude_instance_list, :exclude_const_list,
                    :unknown_class_list, :unknown_module_list, :unknown_instance_list,
                    :not_respond_to_list
      include Utilmod2

      def initialize
        @hs = {}
        @names = %W!
          class_list
          module_list
          instance_list
          exclude_class_list
          exclude_module_list
          exclude_instance_list
          exclude_const_list
          unknown_class_list
          unknown_module_list
          unknown_instance_list
          not_r@espond_to_list
        !
        @names.map{ |name| @hs[name] = Setx.new}
      end

      def class_list
        @hs["class_list"]
      end

      def module_list
        @hs["module_list"]
      end

      def instance_list
        @hs["instance_list"]
      end

      def exclude_class_list
        @hs["exclude_class_list"]
      end

      def exclude_module_list
        @hs["exclude_module_list"]
      end

      def exclude_instance_list
        @hs["exclude_instance_list"]
      end

      def exclude_const_list
        @hs["exclude_const_list"]
      end

      def unknown_class_list
        @hs["unknown_class_list"]
      end

      def unknown_module_list
        @hs["unknown_module_list"]
      end

      def unknown_instance_list
        @hs["unknown_instance_list"]
      end

      def not_respond_to_list
        @hs["not_respond_to_list"]
      end

      def sort_lists_x!
        sort_lists!(@hs)
      end

      def print_lists_x
        print_lists(@hs)
      end
    end
	end
end
