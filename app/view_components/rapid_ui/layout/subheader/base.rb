module RapidUI
  module Layout
    module Subheader
      class Base < ApplicationComponent
        attr_accessor :sidebar_toggle
        attr_accessor :breadcrumbs
        attr_accessor :buttons

        def initialize
          super
          @sidebar_toggle = SidebarToggle.new
          @breadcrumbs = Components::Typed.new(Breadcrumb, separator: " &raquo; ".html_safe)
          @buttons = Components::Typed.new(Button)
        end
      end
    end
  end
end
