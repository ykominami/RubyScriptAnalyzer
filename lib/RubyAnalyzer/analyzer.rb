require 'RubyAnalyzer/item'
require 'RubyAnalyzer/itemroot'
require 'RubyAnalyzer/raenv'
require 'RubyAnalyzer/ns'
require 'RubyAnalyzer/util'

module RubyAnalyzer
  class Analyzer
    RAEnv.register_reflection( self )
    St = Struct.new( "Analyzer" , :ns )

    class << self
      def init( env , kind )
        case kind
        when :reflection
          env['cv'] = St.new
          @@cv = env['cv']
          @@cv.ns = Ns.new
        end
      end

      def push_to_ns( item )
        @@cv.ns.push( item )
        Util.debug( "++++ item.ns_key=#{item.ns_key} #{item.ns_key.class}" )
      end

      def get_ns_key
        @@cv.ns.get_ns_key
      end

      def pop_from_ns
        @@cv.ns.pop
      end
    end

    def initialize( yaml )
      @input_fnames = yaml["input_file"]
      @exclude_class_list = []
      yaml["exclude_class_file"].each do |fname|
        File.readlines( fname ).map(&:chomp).grep_v(/^\s*$/).each do |x|
          @exclude_class_list << x
        end
      end
    end

    def analyze
      @init_consts = Module.constants
      @init_gv = global_variables
      @init_lv = local_variables

      root = Itemroot.new( Object )
      #     check_exclude_klass

      @input_fnames.each do |fname|
        require fname
      end

      @now_consts = Object.constants
      @now_gv = global_variables
      @now_lv = local_variables

      @diff_const = @now_consts - @init_consts
      @diff_gv = @now_gv - @init_gv
      @diff_lv = @now_lv - @init_lv

      @ns_root = Item.new( root.obj , nil, 0 , true)

      analyze0( 1, @ns_root , @diff_const )

      # 各クラスの先祖を登録す る
      Item.register_all_ancestor_of_all_item
      # ユーザ定義クラスで定義されたメソッド、変数を差分として抽出し、設定
      Item.set_for_user_defined_class

      Item.sort_by_target_inst
      Item.show_all_class_related_info( :SELF )
    end

    def analyze0( level , parent_item , list )
      list.each do |x|
        next unless parent_item.obj.respond_to?( :const_get )
        const = parent_item.obj.const_get( x )
        analyze_sub( level , parent_item, const )
        # else
        #  # p "parent_item.obj=#{parent_item.obj}"
      end
    end

    def analyze_sub( level , parent_item, obj )
      case obj.class
      when Class
        class_name = obj.class.to_s
        if @exclude_class_list.include?( class_name )
          parent_item.add_exclude_class_constant( obj.to_s )
        elsif class_name =~ /^#<Class:/
          parent_item.add_not_respond_to_ancesstors_constant( obj.to_s )
        elsif obj.respond_to?(:ancestors)
          Util.debug( "analyze1_sub == a" )
          item = Item.new( obj , parent_item , level )
          parent_item.add_ns_child( item )
          Analyzer.push_to_ns( item )
          analyze2( level + 1 , item )
          Analyzer.pop_from_ns
        else
          Util.debug( "@not_respond_to_ancestors_constants=#{@not_respond_to_ancestors_constants}" )
          parent_item.add_not_respond_to_ancesstors_constant( obj.to_s )
        end
      end
    end

    def analyze1( level , item , list )
      parent_item = item

      list.each do |x|
        skip = false
        begin
          const = item.const_get( x )
        rescue StandardError
          item.add_not_defined_constant( x.to_s )
          skip = true
        end
        analyze_sub( level , parent_item, const ) unless skip
      end
    end

    def analyze2( level , item )
      return unless item.respond_to?( :constants )
      analyze1(level , item, item.constants )
    end
  end
end
