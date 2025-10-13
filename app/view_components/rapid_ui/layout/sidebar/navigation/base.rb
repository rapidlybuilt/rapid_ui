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

          def initialize
            @contents = Components.new
          end

          def call
            tag.nav(class: "sidebar-nav") do
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
