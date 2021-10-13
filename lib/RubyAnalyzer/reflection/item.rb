require 'forwardable'
require 'RubyAnalyzer/reflection/inheritancespace'

module RubyAnalyzer
  class Item
    attr_accessor :ns_key , :obj, :name, :ancestors, :level, :inheritace_key,
    :instance_methods,:public_instance_methods,:private_instance_methods,
    :protected_instance_methods, :instance_methods_in_user_defined_class,
      :public_instance_methods_in_user_defined_class,
      :private_instance_methods_in_user_defined_class,
      :protected_instance_methods_in_user_defined_class,
      :class_methods,
      :class_methods_in_user_defined_class,
      :instance_variables

    extend Forwardable
    def_delegator(:@obj, :respond_to?, :respond_to?)

    @@ns = Ns.new
    @@inheritance = InheritanceSpace.new

    def initialize( obj , parent , level )
      @obj = obj
      @name = obj.to_s
      @level = level
      @ancestors = @obj.respond_to?(:ancestors) ? @obj.ancestors : []
      @inheritace_key = @@inheritance.add( @ancestors , self )
      @ns_key = @@ns.add( parent ,  self )

      @instance_methods = @obj.respond_to?(:instance_methods) ? @obj.instance_methods : []
      @public_instance_methods = @obj.respond_to?(:public_instance_methods) ? @obj.public_instance_methods : []
      @private_instance_methods = @obj.respond_to?(:private_instance_methods) ? @obj.private_instance_methods : []
      @protected_instance_methods = @obj.respond_to?(:protected_instance_methods) ? @obj.protected_instance_methods : []
      @instance_methods_in_user_defined_class = @obj.respond_to?(:public_instance_methods) ? @obj.public_instance_methods(false) : [] 
      @public_instance_methods_in_user_defined_class = @obj.respond_to?(:public_instance_methods) ? @obj.public_instance_methods(false) : [] 
      @private_instance_methods_in_user_defined_class = @obj.respond_to?(:private_instance_methods) ? @obj.private_instance_methods(false) : [] 
      @protected_instance_methods_in_user_defined_class = @obj.respond_to?(:protected_instance_methods) ? @obj.protected_instance_methods(false) : []
      @class_methods = @obj.respond_to?(:singleton_methods) ? @obj.singleton_methods : []
      @class_methods_in_user_defined_class = @obj.respond_to?(:singleton_methods) ? @obj.singleton_methods(false) : []
      @instance_variables = @obj.respond_to?(:instance_variables) ? @obj.instance_variables : []
    end
=begin
    def respond_to?( method )

      @obj.respond_to?( method )
    end
=end
  end
end
