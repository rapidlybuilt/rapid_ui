module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        attr_accessor :sidebar_toggle_button
        attr_accessor :breadcrumbs
        attr_accessor :buttons

        def initialize
          super
          @sidebar_toggle_button = SidebarToggleButton.new
          @breadcrumbs = Breadcrumbs.new(separator: " &raquo; ".html_safe)
          @buttons = Buttons.new
        end

        class Breadcrumbs < Components
          contains Breadcrumb, nil
        end

        class Buttons < Components
          contains Button, nil do |icon, path, **kwargs|
            Button.new(nil, path:, icon:, **kwargs)
          end
        end
      end
    end
  end
end
