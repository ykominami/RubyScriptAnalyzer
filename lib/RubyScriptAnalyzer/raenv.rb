require 'set'
require 'pstore'
require 'yaml/store'
require 'pry'
require 'RubyScriptAnalyzer/listex'
#require 'RubyScriptAnalyzer/raenv_test'

module RubyScriptAnalyzer
  class RAEnv
    @@env = {}
    @@env[:global] = {:fpath => Listex.new }
    #
    @@env[:reflection] = {}
    #
    @@env[:ast] = {}
    #
    @@env[:class] = Listex.new
    #
    @@env[:inst] = Listex.new
    #
    @@env[:ast_class] = Listex.new
    #
    @@env[:ast_inst] = Listex.new
    #
    @@env[:new_env] = {}
    #
    @@env[:new_env_obj] = Listex.new
    #
    @@count = {}
    @@count[:global] = 0
    @@count[:reflection] = 0
    @@count[:ast] = 0

    @@klass_list = {}
    @@klass_list[:global] = Listex.new
    @@klass_list[:reflection] = Listex.new
    @@klass_list[:ast] = Listex.new

    @@store = {}

    class << self
      def reset_env
        @@env = {}
      end

      def register_fpath( fpath )
        @@env[ :global ][ :fpath ].add( fpath )
      end

      def fpath_at( index )
        @@env[ :global ][ :fpath ].at( index )
      end

      # object
      def check_object( obj , kind = :class )
        result = true
        case kind
        when :class, :ast_class
          if obj.class != Class && obj.class != Module
            result = false
          end
        when :inst , :ast_inst
          if obj.class == Class || obj.class == Module
            result = false
          end
        end
        result
      end
      
      def object_index( obj , kind )
        raise unless check_object( obj , kind )
        @@env[kind].index( obj )
      end

      def object_add( obj , kind )
        raise unless check_object( obj , kind )
        @@env[kind].add( obj )
      end
      
      def object_at( index , kind )
        obj = @@env[kind]

        if obj.kind_of?( Hash )
          obj[index]
        elsif obj.kind_of?( Array )
          obj[index]
        elsif obj.kind_of?( Listex )
          obj.at(index)
        elsif obj.kind_of?( RubyScriptAnalyzer::Listex )
          obj.at(index)
        else
          obj.at(index)
        end
      end

      def get_object_hash_size( kind )
        @@env[kind].size
      end
      
      def get_object_hash_keys( kind )
        @@env[kind].keys
      end

      def show_object_hash( kind )
        pp @@env[kind]
      end

      # class
      def klass_index( klass )
        object_index( klass , :class )
      end

      def klass_add( klass )
        object_add( klass , :class )
      end
      
      def klass_at( index )
        object_at( index , :class )
      end

      def get_klass_hash_size
        get_object_hash_size( :class )
      end
      
      def show_klass_hash
        show_object_hash( :class )
      end
      
      # inst
      def inst_index( inst )
        object_index( inst , :inst )
      end

      def inst_add( inst )
        raise if inst.to_s =~ /Class:/
        object_add( inst , :inst )
      end
      
      def inst_at( index )
        object_at( index , :inst )
      end

      def get_inst_hash_size
        get_object_hash_size( :inst )
      end

      def show_inst_hash
        show_object_hash( :inst )
      end

      # ast_class
      def ast_klass_index( klass )
        object_index( klass , :ast_class )
      end

      def ast_klass_add( klass )
        object_add( klass , :ast_class )
      end

      def ast_klass_at( index )
        object_at( index , :ast_class )
      end

      def ast_get_klass_hash_size
        get_object_hash_size( :ast_class )
      end

      def ast_show_klass_hash
        show_object_hash( :ast_class )
      end

      # ast_inst
      def ast_inst_index( inst )
        object_index( inst , :ast_inst )
      end

      def ast_inst_add( inst )
        raise if inst.to_s =~ /Class:|RubyVM::/
        object_add( inst , :ast_inst )
      end

      def ast_inst_at( index )
        object_at( index , :ast_inst )
      end

      def get_ast_inst_hash_size
        get_object_hash_size( :ast_inst )
      end

      def show_ast_inst_hash
        show_object_hash( :ast_inst )
      end

      # new_env_obj
      def new_env_obj_index( obj )
        @@env[:new_env_obj].index( obj )
      end

      def new_env_obj_add( obj )
        @@env[:new_env_obj].add( obj )
      end

      def new_env_obj_at( index )
        @@env[:new_env_obj].at( index )
      end

      # for global
      def register_global( klass )
        register_base( klass , :global )
      end

      def new_env_global
        new_env_base( obj , :global )
      end

      def get_count_global
        get_count(:global)
      end
      
      # for reflection
      def register_reflection( klass )
        register_base( klass , :reflection )
      end

      # base
      def register_base( klass , kind )
        klass_index = RAEnv.klass_add(klass)
        @@klass_list[kind].add( klass_index )
      end

      def get_count( kind = :reflection )
        count = @@count[kind]
        @@count[kind] += 1
        count
      end

      def new_env_reflection( obj )
        new_env_base( obj , :reflection )
      end

      def new_env_base( obj , kind )
        @@klass_list[kind].each{|k_index|
          case kind
          when :ast
            obj_index = obj
          else
            obj_index = inst_add( obj )
            unless obj_index
              pp "obj=#{obj}"
              raise
            end
            #
          end

          unless obj_index
            p "k=#{k}"
            p "obj_index=#{obj_index}"
            p "kind=#{kind}"
            raise
          end
          @@env[kind][k_index] ||= {}
          @@env[kind][k_index][obj_index] ||= {}
          klass = klass_at(k_index)
          klass.init( @@env[kind][k_index][obj_index] , kind )
        }
      end

      def save( fname , kind = :root )
        @@db = PStore.new( fname )
        @@db.transaction do
          if kind == :root
            @@db[ :root ] = @@env
          else
            @@db[kind] = @@env[kind]
          end
          @@db.commit
        end
      end

      def save_as_yaml( fname , kind = :root )
        @@db = YAML::Store.new( fname )
        @@db.transaction do
          if kind == :root
            @@db[:root] = @@env
          else
            @@db[kind] = @@env[kind]
          end
          @@db.commit
        end
      end

      def merge_with_env( hash )
        @@env.merge!( hash )
      end

      def set_env( obj )
        @@env = obj
      end
      
      def load( fname , root = nil )
        obj = {}
        if FileTest.exist?( fname )
          @@db = PStore.new( fname )
          @@db.transaction( true ) do |pstore|
            if root
              obj = pstore[:root]
            else
              pstore.roots.each do |root|
                pstore[root].each do |k,v|
                  obj[k] = v
                end
              end
            end
          end
        end
        obj
      end

      def load_from_yaml( fname , root = nil )
        obj = {}
        if FileTest.exist?( fname )
          @@db = YAML::Store.new( fname )
          @@db.transaction( true ) do |pstore|
            if root
              obj = pstore[root]
            else
              pstore.roots.each do |root|
                obj[root] = pstore[root]
              end
            end
          end
        end
        obj
      end
      #
      # for_ast
      #
      def new_env_for_ast( fpath )
        fpath_index = register_fpath( fpath )
        unless fpath_index
          p "fpath=#{fpath}"
          raise
        end
        new_env_base( fpath_index , :ast )
      end

      def register_for_ast( klass )
        register_base( klass , :ast )
      end

      def show_for_ast
        @@env[:ast].each do |k,v|
          p "# #{k}"
          v[Contents].each do |k2,v2|
            v2.each do |k3,v3|
              p "### #{k3} #{v3.size}"
              v3.each do |k4,v4|
                #                p "#### #{k4} #{v4.size}"
                v4.each do |k5,v5|
                  p "##### #{k5} #{v5.class}"
                end
              end
            end
          end
        end
      end

      def get_env_for_ast
        @@env[:ast]
      end
      
      def save_for_ast( fname )
        save( fname, :ast )
      end

      def save_for_ast_as_yaml( fname )
        save_as_yaml( fname , :ast )
      end

      def load_for_ast( fname )
        yml = load( fname )
        if yml.size > 0
          @@env[:ast].merge( yml )
        end
      end

      def load_for_ast_from_yaml( fname )
        if FileTest.exist?( fname )
          yml = load_from_yaml( fname )
          if yml.size > 0
            @@env.merge!( yml )
          end
        end
      end
    end
  end
end
