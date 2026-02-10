module RapidUI
  module ExtensionSupport
    def assert_registers_control(type, klass)
      registry = klass.controls_class.send(:polymorphic_slot_registry)
      assert_includes registry[:items][:type_methods].keys, type
    end

    def refute_registers_control(type, klass)
      registry = klass.controls_class.send(:polymorphic_slot_registry)
      refute_includes registry[:items][:type_methods].keys, type
    end
  end
end

