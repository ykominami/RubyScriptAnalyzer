require 'RubyAnalyzer/util'

module RubyAnalyzer
  class Analyzer
    def adjust_items(item)
      adjust_child_items(item)
    end

    def adjust_child_items(item)
      #      Util.debug_pp "adjust_child_items respond item.nme=#{item.name_str}"
      item.items.map { |child_item| adjust_child_item(child_item) }
    end

    def adjust_child_item(child_item)
      #      Util.debug "adjust_child_items child_item.name_str=#{child_item.name_str}"
      adjust_item(child_item, child_item.get_adjust_type)
      return unless @data_op_level == :all
      adjust_child_items(child_item)
    end

    def adjust_item_for_class(item, adjust_type)
      superclass = item.src[:superclass]
      Util.debug(%Q(superclass=#{superclass}))
      Util.debug(%Q(superclass.superclass=#{superclass.superclass}))

      ancestor_item = Item.get_in_item_by_ruby_obj(superclass)
      unless ancestor_item
        parent_item = Item.get_in_item_by_ruby_obj(superclass.superclass)
        ancestor_item = Item.new(superclass.to_s.to_sym, superclass, parent_item, 0)
      end
      unless ancestor_item
        Util.debug("unless 3 ancestor_item=nil")
        Util.debug("")
        item.set_adjust_result_error(3)
        item.set_adjust_result(adjust_type, 3)
        raise
        # return
      end
      item.set_adjust_result(adjust_type, 0)

      item.adjust do |key, src, dest, _ruby_obj, kind, _target, _adjust_type_x, inherit|
        case kind
        when :class
          # Util.debug %Q!#{item.name_str} kind=#{kind} key=#{key}!
          list = ancestor_item.iteminfo.src[key]
          unless list
            Util.debug("============== #{item.name_str} key=#{key} kind=#{kind} list=nil processd=#{item.iteminfo.processd}")
            list = []
          end
          # Util.debug %Q!list=#{list}!
          unless src[key]
            Util.debug("############## src[#{key}]==nil #{item.name_str} key=#{key} kind=#{kind} list=nil processd=#{item.iteminfo.processd}")
            src[key] = [] unless src[key]
          end
          if [:ancestors, :included_modules].include?(key)
            dest[key] = src[key].map(&:to_s)
          # elsif key == :included_modules
          #   dest[key] = src[key].map{ |x| x.to_s}
          elsif key == :superclass
            dest[key] = src[key].to_s
          elsif inherit
            dest[key] = src[key] - list
          else
            dest[key] = src[key]
          end
        # Util.debug %Q!dest[#{key}]=#{dest[key]}!
        when :module
          list = ancestor_item.iteminfo.src[key]
          list ||= []
          if key == :ancestors
            dest[key] = src[key].map(&:to_s)
          else
            dest[key] = src[key] - list
          end
        end
      end
    end

    def adjust_item(item, adjust_type)
      return unless item.target?

      return unless item.kind == :class
      # Util.debug item.src[:superclass]
      adjust_item_for_class(item, adjust_type)
    end
  end
end
