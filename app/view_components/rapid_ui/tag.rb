module RapidUI
  class Tag < ApplicationComponent
    def call
      component_tag(content)
    end
  end
end
