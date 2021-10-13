require 'pry'
require 'RubyAnalyzer/raenv'

module RubyAnalyzer
  class RAEnv
    class << self
      def get_env_ast_by_index( index )
        @@env[:ast][index]
      end

      def get_ast_class_index( klass )
        @@env[:ast_class].index(klass)
      end

      def get_env_ast_keys
        @@env[:ast].keys
      end

      def get_env_keys
        @@env.keys
      end

      def inspect_env
        @@env.each do |k,v|
          if v.class.respond_to?( :ancestors )
            puts "v.class.ancestors=#{v.class.ancestors}"
          else
            puts "v.class not respond_to? :ancestors"
          end
          puts "v.class.superclass=#{v.class.superclass}"

          case v.class
          when Hash
            puts "11 v.class=#{v.class}"
            v.each do |k2,v2|
              puts "k2=#{k2} #{k2.class}"
              puts "v2=#{v2} #{v2.class}"
            end
          when ::Hash
            puts "12 v.class=#{v.class}"
            v.each do |k2,v2|
              puts "k2=#{k2} #{k2.class}"
              puts "v2=#{v2} #{v2.class}"
            end
          else
            puts "2 v.class=#{v.class}"
          end
          puts ""
        end
      end

      def check_all( kind )
        case @@env[ kind ].class
        when Hash
          @@env[ kind ].each do |k,v|
            puts "(check_all) #{kind} #{k} #{v.class}"
            case v.class
            when Hash
              pp "Hash=#{v}.size"
            when Array
              pp "Array=#{v.size}"
            when Class
              pp "Class=#{v.class}"
              raise
            else
              pp "ELSE"
              #
            end
          end
        when Array
          @@env[ kind ].each do |x|
            puts "(check_all) #{kind} #{x.class}"
            case x.class
            when Hash
              pp "Hash=#{x}.size"
            when Array
              pp "Array=#{x.size}"
            when Class
              pp "Class=#{x.class}"
              raise
            else
              pp "ELSE"
              #
            end
          end
        else
          pp "ELSE"
        end
      end

      def check_all_class
        @@env[ :class ].each do |x|
          puts "#{x}|#{x.to_s}"
          raise if x.to_s =~ /Class:/
        end
      end

      def check_all_inst
        @@env[ :inst ].each do |x|
          puts "#{x}|#{x.to_s}|#{x.class}"
          raise if x.class.to_s =~ /Class:/
        end
      end
    end
  end # RAEnv
end # module RubyAnalyzer
