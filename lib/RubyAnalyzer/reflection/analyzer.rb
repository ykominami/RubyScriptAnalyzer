require 'yaml'
require "RubyAnalyzer/util"
require "RubyAnalyzer/reflection/item"
require "RubyAnalyzer/reflection/analyzer/analyzerfiles"
require "RubyAnalyzer/reflection/analyzer/analyzerresult"
require "RubyAnalyzer/reflection/analyzer/varnametable"
require "RubyAnalyzer/reflection/tuple"
require "RubyAnalyzer/reflection/analyzer/adjust"
require "RubyAnalyzer/reflection/analyzer/yaml"
require "RubyAnalyzer/reflection/analyzer/debug"

module RubyAnalyzer
  class Analyzer
    attr_reader :init_consts, :init_items

    def initialize(output_filepath, analyzerfiles, fname , fname2 = nil)
      Util.level = Logger::WARN
      #Util.level = Logger::DEBUG
      #Util.level = Logger::FATAL
      @output_filepath = output_filepath
      @files = analyzerfiles
      @init_consts = Module.constants
      @init_gv = global_variables
      @init_lv = local_variables
      @init_items = {}
      @init_items[:Object] = Itemobj.new(:Object, Object, nil, 0)

      require fname
      require fname2 if fname2

      @now_consts = Object.constants
      @now_gv = global_variables
      @now_lv = local_variables
      @now_items = {}
      @now_items[:Object] = Itemobj.new(:Object, Object, nil, 0)

      @diff_const = @now_consts - @init_consts
      @diff_gv = @now_gv - @init_gv
      @diff_gvname = @diff_gv.map{|x| x.to_s.gsub(/^:/, "")}
      @diff_lv = @now_lv - @init_lv
      @diff_object = Itemdiff.new(@init_items[:Object], @now_items[:Object])

      @output_yaml = [:class, :module, :instance,
                      :unknown_class, :unknown_module, :unknown_instance,
                      :not_respond_to,
                    ].reduce({}) {|h, k| h[k] = {}; h}
      @item_adjust_result = [:class, :module, :instance,
                             :unknown_class, :unknown_module, :unknown_instance,
                             :not_respond_to,
                             :exclude_class, :exclude_module, :exclude_instance, :exclude_const,
                            ].reduce({}) {|h, k| h[k] = {}; h}
      @not_item_adjust_result = [:exclude_class, :exclude_const, :exclude_module, :exclude_instance,
                            ].reduce({}) {|h, k| h[k] = {}; h}
      #      @result = AnalyzerResult.new
      @result = self.class.create_AnalyzerResult
    end

    def analyze
      #      Util.debug "called analyze"
      level = 0
      object_item, standarderror_item = [
        [Object, :Object], 
        [StandardError, :StandardError]
      ].map{ |klass, name|
        item = Item.new(name, klass, nil, level)
        item.set_adjust_type(name)
        item.set_adjust_result(name, 0)
        item
      }
      #
      analyze_child_items(object_item, @diff_const)
      #
      #dump_analyze_result
      #
      adjust_items(object_item)
      #
      #dump_adjust_items_result
      #
      prepare_yaml_dump(object_item)
      #
      yaml_dump(@output_filepath)
    end

    def analyze_child_items(item, list, recursive = false)
      if item.respond_to?(:const_get)
        #        Util.debug_pp "analyze_child_items respond item.nme=#{item.name_sym} recursive=#{recursive}"
        list.each do |const_name|
          obj2 = item.ruby_obj.const_get(const_name)
          level2 = item.level + 1
          item2 = Item.new(const_name, obj2, item, level2)
          #
          const_name_str = Util.sym_to_name(const_name)
          analyze_sub(item2, true)
        end
      else
        #        Util.debug_pp "analyze_child_items not_respond item.nme=#{item.name_sym}"
        @result.not_respond_to_list.add(item)
        @output_yaml[:not_respond_to][item.name_sym] = item.dump_in_hash
      end
    end

    def analyze_sub(item, recursive = false)
      #      Util.debug("analyze_sub A item.kind=#{item.kind} item.target?=#{item.target}")
      case item.kind
      when :class
        if @files.target_class_list.include?(item.name_sym)
          item.target_on
          #          Util.debug("analyze_sub item.kind=#{item.kind} item.target?=#{item.target}")
          @result.class_list.add(item)
          item.set_adjust_type(:class)
          # @output_yaml[:class][item.name_sym] = item.dump_in_hash
          #          Util.debug "analyze_sub item.name_sym=#{item.name_sym} recursive=#{recursive}"
          analyze_child_items(item, item.ruby_obj.constants, recursive) if item.adjust_result_nil_or_0?
        else
          if @files.exclude_class_list.include?(item.name_sym)
            @result.exclude_class_list.add(item)
            @not_item_adjust_result[:exclude_class][item.name_sym] = {:item => item}
            item.set_adjust_type(:exclude_class)
          elsif @files.exclude_const_list.include?(item.name_sym)
            @result.exclude_const_list.add(item)
            @not_item_adjust_result[:exclude_const][item.name_sym] = {:item => item}
            item.set_adjust_type(:exclude_const)
          else
            @result.unknown_class_list.add(item)
            item.set_adjust_type(:unknown_class)
          end
        end
      when :module
        if @files.target_module_list.include?(item.name_sym)
          item.target_on
          @result.module_list.add(item)
          item.set_adjust_type(:module)
          analyze_child_items(item, item.ruby_obj.constants, recursive)  if item.adjust_result_nil_or_0?
        else
          if @files.exclude_module_list.include?(item.name_sym)
            @result.exclude_module_list.add(item)
            @not_item_adjust_result[:exclude_module][item.name_sym] = {:item => item}
            item.set_adjust_type(:exclude_module)
          else
            @result.unknown_module_list.add(item)
            item.set_adjust_type(:unknown_module)
          end
        end
      else
        if @files.exclude_instance_list.include?(item.name_sym)
          @result.exclude_instance_list.add(item)
          @not_item_adjust_result[:exclude_instance][item.name_sym] = {:item => item}
          item.set_adjust_type(:exclude_instance)
        else
          item.target_on
          @result.instance_list.add(item)
          item.set_adjust_type(:instance)
        end
      end
    end
  end
end
