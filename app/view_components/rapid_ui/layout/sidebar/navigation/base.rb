module RapidUI
  module Layout
    module Sidebar
      module Navigation
        class Base < ApplicationComponent
          attr_accessor :contents

          with_options to: :contents do
            delegate :build_link
            delegate :build_section
          end

          def initialize(**kwargs, &block)
            @contents = Components.new

            super(tag_name: :nav, **kwargs, &block)
          end

          def call
            component_tag(class: "sidebar-nav") do
              render contents
            end
          end

          class Components < Components
            contains Link, :link
            contains Section, :section
          end
        end
      end
    end
  end
end
