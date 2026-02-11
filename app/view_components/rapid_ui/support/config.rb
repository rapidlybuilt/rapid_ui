module RapidUI
  module Support
    module Config
      extend ActiveSupport::Concern

      included do
        include RegisterProcs
        include ExtendableClass

        def_registered_procs :initializer

        attr_accessor :config
        def_extendable_class :config

        # Register the initializer that applies class-level defaults to config.
        # This runs first (before any other initializers) to ensure defaults are
        # available for subsequent initialization logic.
        register_initializer :config_attribute_defaults
      end

      private

      def apply_initializers(options)
        self.config = self.class.build_config(options)

        self.class.initializer_procs.each do |initializer_proc|
          apply_proc(:initialize, initializer_proc, config)
        end
      end

      # Applies class-level defaults to any nil config attributes.
      #
      # @param config [Object] The configuration object
      # @return [void]
      def initialize_config_attribute_defaults(config)
        self.class.config_attribute_names.each do |name|
          config.send(:"#{name}=", self.class.send(name)) if config.send(name).nil?
        end
      end

      # Class methods for defining config attributes.
      module ClassMethods
        # Defines a configuration attribute with a class-level default that can be
        # overridden at the instance level.
        #
        # @param name [Symbol] The attribute name
        # @param default [Object] The default value (optional)
        # @param instance_reader [Boolean] Whether to create an instance reader method (default: true)
        # @param boolean [Boolean] Whether to create a predicate method (auto-detected from default)
        # @return [void]
        #
        # @example
        #   config_attribute :per_page, default: 25
        #   config_attribute :skip_search, default: false  # auto-creates skip_search?
        def config_attribute(name, default: nil, instance_reader: true, boolean: nil)
          # Auto-detect boolean if default is true/false
          boolean = [ true, false ].include?(default) if boolean.nil?

          # 1. Class-level default (no instance accessor - we handle that via config)
          class_attribute name, default: default, instance_accessor: false

          # 2. Track this attribute name for build_config
          config_attribute_names << name

          # 3. Extend config class with accessor
          config_class! do
            attr_accessor name

            alias_method :"#{name}?", name if boolean
          end

          # 4. Delegate to config for instance access
          return unless instance_reader

          delegate name, to: :config
          delegate :"#{name}?", to: :config if boolean
        end

        # Returns the list of config attribute names defined on this class and ancestors.
        #
        # @return [Array<Symbol>] The attribute names
        def config_attribute_names
          @config_attribute_names ||= begin
            inherited = if superclass.respond_to?(:config_attribute_names)
                          superclass.config_attribute_names.dup
            else
                          []
            end
            inherited
          end
        end
      end
    end
  end
end
