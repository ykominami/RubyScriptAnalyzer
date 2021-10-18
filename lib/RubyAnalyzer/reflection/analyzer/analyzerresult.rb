require "RubyAnalyzer/utilmod2"
require "RubyAnalyzer/reflection/tuple"
require "RubyAnalyzer/reflection/setx"

module RubyAnalyzer
  class Analyzer
    class AnalyzerResult
      attr_accessor :class_list, :module_list, :instance_list,
                    :exclude_class_list, :exclude_module_list, :exclude_instance_list,
                    :exclude_const_list,
                    :unknown_class_list, :unknown_module_list, :unknown_instance_list,
                    :not_respond_to_list
      include Utilmod2

      def initialize
        @sym_varnames = []
        #
        @class_list = Setx.new
        @sym_varnames << :@class_list
        @module_list = Setx.new
        @sym_varnames << :@module_list
        @instance_list = Setx.new
        @sym_varnames << :@instance_list
        #
        @exclude_class_list = Setx.new
        @sym_varnames << :@exclude_class_list
        @exclude_module_list = Setx.new
        @sym_varnames << :@exclude_module_list
        @exclude_instance_list = Setx.new
        @sym_varnames << :@exclude_instance_list
        @exclude_const_list = Setx.new
        @sym_varnames << :@exclude_const_list
        #
        @unknown_class_list = Setx.new
        @sym_varnames << :@unknown_class_list
        @unknown_module_list = Setx.new
        @sym_varnames << :@unknown_module_list
        @unknown_instance_list = Setx.new
        @sym_varnames << :@unknown_instance_list
        @not_respond_to_list = Setx.new
        @sym_varnames << :@not_respond_to_list
      end

      def sort_lists_x!
        sort_lists!(@sym_varnames)
      end

      def print_lists_x
        print_lists(@sym_varnames)
      end
    end
	end
end
