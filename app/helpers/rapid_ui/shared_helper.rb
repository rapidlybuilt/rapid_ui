module RapidUI
  module SharedHelper
    def assert_body_or_block(body, block)
      if body.any? && block_given?
        raise ArgumentError, "body and block cannot be used together"
      end
    end

    def safe_join_components(components)
      safe_join(components.map { |p| p.is_a?(ViewComponent::Base) ? render(p) : p.to_s })
    end

    def component_content(body, &block)
      assert_body_or_block(body, block)

      if block
        capture(&block)
      elsif body.any?
        safe_join_components(body)
      else
        raise ArgumentError, "body or block is required"
      end
    end
  end
end
