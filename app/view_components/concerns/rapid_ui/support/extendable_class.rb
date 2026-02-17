# frozen_string_literal: true

module RapidUI
  module Support
    # The ExtendableClass module provides a framework for creating and managing extendable
    # classes in RapidUI. It allows modules to define classes that can be extended
    # with additional attributes and methods, and provides utilities for building instances
    # from various data types.
    #
    # This module is used internally by other RapidUI modules to create configurable
    # classes like Column, BulkAction, etc.
    #
    # @example Defining an extendable class
    #   class UsersTable < RapidUI::Datatable::Base
    #     def_extendable_class :my_object do
    #       attr_accessor :id
    #       attr_accessor :name
    #     end
    #   end
    #
    # @example Extending an existing class
    #   class AdminTable < UsersTable
    #     my_object_class! do
    #       attr_accessor :role
    #     end
    #   end
    #
    # @example Building instances
    #   # From a hash
    #   obj = UsersTable.build_my_object(id: 1, name: "John Doe")
    #
    #   # From an array of hashes
    #   objects = UsersTable.build_my_objects([{id: 1}, {id: 2}])
    #
    #   # Build the subclass that includes the role attribute
    #   obj = AdminTable.build_my_object(id: 1, name: "John Doe", role: "marketing")
    module ExtendableClass
      extend ActiveSupport::Concern

      class Base
        # Initializes a new extendable object with the given options.
        #
        # @param options [Hash] The options to set on the object
        def initialize(**options)
          options.each do |key, value|
            send("#{key}=", value)
          end
        end
      end

      # Class methods for defining and managing extendable classes.
      module ClassMethods
        # Defines a new extendable class with the given ID and optional configuration.
        #
        # @param id [Symbol] The unique identifier for the extendable class
        # @param name [String, nil] The name for the class constant (optional)
        # @param superclass [Class, nil] The superclass for the new class (optional)
        # @yield [void] Optional block to configure the class
        # @return [Class] The newly created extendable class
        def def_extendable_class(id, name: nil, superclass: nil, &block)
          extendable_classes_by_id[id] ||= new_extendable_class(id, name:, superclass:, &block)
        end

        # Finds an extendable class by ID, searching up the inheritance chain.
        #
        # @param id [Symbol] The ID of the extendable class to find
        # @return [Class, nil] The found class or nil if not found
        def find_extendable_class(id)
          extendable_classes_by_id[id] ||
            (superclass.find_extendable_class(id) if superclass.respond_to?(:find_extendable_class))
        end

        # Finds an extendable class by ID, raising an error if not found.
        #
        # @param id [Symbol] The ID of the extendable class to find
        # @return [Class] The found class
        # @raise [ArgumentError] If the class is not found
        def find_extendable_class!(id)
          find_extendable_class(id) || raise(ArgumentError, "extendable class #{id.inspect} not found")
        end

      private

        # Creates a new extendable class with the given configuration.
        #
        # @param id [Symbol] The unique identifier for the extendable class
        # @param name [String, nil] The name for the class constant (optional)
        # @param superclass [Class, nil] The superclass for the new class (optional)
        # @yield [void] Optional block to configure the class
        # @return [Class] The newly created extendable class
        def new_extendable_class(id, name: nil, superclass: nil, &block)
          klass = Class.new(superclass || Base)

          # give it a name underneath the current class
          const_set(name || id.to_s.camelize, klass) if name || self.name

          # define some syntactic sugar
          define_singleton_method(:"#{id}_class!") do |&block|
            extend_class(id, &block)
          end

          define_singleton_method(:"#{id}_class") do
            find_extendable_class(id)
          end

          define_singleton_method(:"build_#{id}") do |*args, **kwargs|
            build_extendable_instance(id, *args, **kwargs)
          end

          klass.class_eval(&block) if block_given?
          klass
        end

        # Extends an existing extendable class with additional configuration.
        #
        # @param id [Symbol] The ID of the extendable class to extend
        # @yield [void] Block containing the additional configuration
        # @return [Class] The extended class
        def extend_class(id, &)
          # ensures the ID is valid
          existing = find_extendable_class!(id)

          klass = extendable_classes_by_id[id] || def_extendable_class(id, superclass: existing)
          klass.class_eval(&) if block_given?
          klass
        end

        # Builds a single extendable instance from various data types.
        #
        # @param id [Symbol] The ID of the extendable class to build
        # @param attrs [Hash, Object] The attributes or object to build from
        # @return [Object] The built instance
        # @raise [ArgumentError] If the attributes are not in a supported format
        def build_extendable_instance(id, *args, **kwargs)
          klass = find_extendable_class!(id)
          klass.new(*args, **kwargs)
        end

        # Returns the registry of extendable classes by ID.
        #
        # @return [Hash<Symbol, Class>] The registry of extendable classes
        def extendable_classes_by_id
          @extendable_classes_by_id ||= {}
        end
      end
    end
  end
end
