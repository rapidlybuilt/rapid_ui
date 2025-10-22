class ApplicationController < ActionController::Base
  extend RapidUI::UsesLayout
  helper RapidUI::LayoutHelper
  helper RapidUI::IconsHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  uses_application_layout

  before_action :setup_layout

  private

  def setup_layout
    # set nav links as active based on the current path
    ui.register! RapidUI::Layout::Sidebar::Navigation::Link, ->(klass, name, path, **kwargs, &block) do
      klass.new(name, path, active: request.path == path, **kwargs, &block)
    end

    # pre-expand sections with active links
    ui.register! RapidUI::Layout::Sidebar::Navigation::Section, ->(klass, name, **kwargs, &block) do
      klass.new(name, **kwargs) do |section|
        block.call(section) if block
        section.expanded = section.path == request.path || section.components.any?(&:active?) if section.expanded.nil?
      end
    end

    # auto-set whether the sidebar is closed based on the cookie
    ui.register! RapidUI::Layout::Sidebar::Base, ->(klass, **kwargs, &block) do
      klass.new(**kwargs) do |sidebar|
        block.call(sidebar) if block
        sidebar.closed = cookies[sidebar.closed_cookie_name] == "1" if sidebar.closed.nil?
      end
    end

    layout.head.tap do |head|
      head.site_name = "Dummy"

      head.build_favicon("rapid_ui/favicon-32x32.png", type: "image/png", size: 32)
      head.build_favicon("rapid_ui/favicon-16x16.png", type: "image/png", size: 16)
      head.build_apple_touch_icon("rapid_ui/apple-touch-icon.png")

      head.stylesheet_link_sources = [ "application" ]
    end

    layout.header.tap do |header|
      header.left.tap do |left|
        # TODO: clean this up. #build_link with a single child (the icon)
        left.build_icon_link("logo", root_path, size: 32, class: "px-0 rounded-full") do |link|
          link.content.css_class = "hover:scale-110"
        end

        left.build_dropdown(new_icon("layout-grid"), skip_caret: true) do |dropdown|
          dropdown.menu.build_item("Builds & Deploys", "#")
          dropdown.menu.build_item("Code Coverage", "#")
          dropdown.menu.build_item("Errors", "#")
          dropdown.menu.build_divider
          dropdown.menu.build_item("Content Management", "#")
          dropdown.menu.build_item("Users", "#")
        end

        left.build_search(path: search_path)
      end

      header.right.tap do |right|
        right.build_text("username")

        right.build_icon_link("hash", "#")
        right.build_icon_link("info", "#")
        right.build_icon_link("circle-question-mark", "#")
        right.build_icon_link("settings", "#")

        right.build_dropdown("username", align: "right") do |dropdown|
          dropdown.menu.build_item("Profile Settings", "#")
          dropdown.menu.build_item("Account Preferences", "#")
          dropdown.menu.build_item("Billing & Plans", "#")
          dropdown.menu.build_divider
          dropdown.menu.build_item("Help & Support", "#")
          dropdown.menu.build_item("Sign Out", "#")
        end
      end
    end

    main_sidebar = layout.build_sidebar(id: "main_sidebar")

    layout.subheader.tap do |subheader|
      subheader.left.build_sidebar_toggle_button(title: "Toggle navigation", icon: "menu", target: main_sidebar, circular: true)
      subheader.left.build_breadcrumbs

      subheader.build_breadcrumb("Home", root_path)
    end

    layout.footer.tap do |footer|
      footer.left.build_text_link("Feedback", "#", class: "pl-0")

      footer.right.build_copyright(start_year: 2025, company_name: "ACME, Inc.")
      footer.right.build_text_link("Privacy", "#")
      footer.right.build_text_link("Terms", "#")
      footer.right.build_text_link("Cookie preferences", "#", class: "pr-0")
    end
  end

  def pending_badge(link, variant: "warning")
    link.with_badge(variant:, class: "text-xs").with_content("TODO")
  end

  with_options to: :view_context do
    delegate :new_icon
  end
end
