module RapidUI
  class Tag < ApplicationComponent
    def initialize(tag_name: nil, **kwargs)
      super(tag_name:, **kwargs)
    end

    def call
      # if it doesn't have a tag name, then it's not just a Text Node
      dynamic_tag_name ? component_tag(content) : h(content)
    end
  end
end
