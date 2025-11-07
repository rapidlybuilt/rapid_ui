class ApplicationController < ActionController::Base
  extend RapidUI::UsesLayout
  helper RapidUI::LayoutHelper
  helper RapidUI::IconsHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern unless Rails.env.development?

  uses_application_layout

  before_action :setup_layout

  private

  def setup_layout
    # set nav links as active based on the current path
    ui.factory.register_polish! RapidUI::Layout::Sidebar::Navigation::Link, ->(link) do
      link.active = request.path == link.path
    end

    # pre-expand sections with active links
    ui.factory.register_polish! RapidUI::Layout::Sidebar::Navigation::Section, ->(section) do
      section.expanded = section.path == request.path || section.links.any?(&:active?) if section.expanded.nil?
    end

    # auto-set whether the sidebar is closed based on the cookie
    ui.factory.register_polish! RapidUI::Layout::Sidebar::Base, ->(sidebar) do
      sidebar.closed = cookies[sidebar.closed_cookie_name] == "1" if sidebar.closed.nil?
    end

    layout.build_head do |head|
      head.site_name = "Docs"

      head.build_favicon("rapid_ui/favicon-32x32.png", type: "image/png", size: 32)
      head.build_favicon("rapid_ui/favicon-16x16.png", type: "image/png", size: 16)
      head.build_apple_touch_icon("rapid_ui/apple-touch-icon.png")

      head.stylesheet_link_sources = [ "application" ]
    end

    layout.build_header do |header|
      header.build_left do |left|
        # TODO: clean this up. #build_link with a single child (the icon)
        left.build_icon_link("logo", root_path, size: 32, class: "px-0 rounded-full") do |link|
          link.body.first.css_class = "hover:scale-110"
        end

        left.build_dropdown(skip_caret: true) do |dropdown|
          dropdown.build_button(new_icon("layout-grid"))

          dropdown.build_menu do |menu|
            menu.build_item("Builds & Deploys", "#")
            menu.build_item("Code Coverage", "#")
            menu.build_item("Errors", "#")
            menu.build_divider
            menu.build_item("Content Management", "#")
            menu.build_item("Users", "#")
          end
        end

        left.build_search(path: search_path)
      end

      header.build_right do |right|
        right.build_text("username", class: "hidden md:block")

        right.build_icon_link("hash", "#", class: "hidden md:block")
        right.build_icon_link("info", "#", class: "hidden md:block")
        right.build_icon_link("circle-question-mark", "#", class: "hidden md:block")
        right.build_icon_link("settings", "#")

        right.build_dropdown(align: "right") do |dropdown|
          dropdown.build_button(view_context.tag.span("username", class: "hidden md:block"))

          dropdown.build_menu do |menu|
            menu.build_item("Profile Settings", "#")
            menu.build_item("Account Preferences", "#")
            menu.build_item("Billing & Plans", "#")
            menu.build_divider
            menu.build_item("Help & Support", "#")
            menu.build_item("Sign Out", "#")
          end
        end
      end
    end

    main_sidebar = layout.build_sidebar(id: "main_sidebar")

    layout.build_subheader do |subheader|
      subheader.build_left do |left|
        left.build_sidebar_toggle_button(title: "Toggle navigation", icon: "menu", target: main_sidebar, circular: true)
        # HACK: clean up how this works
        @breadcrumbs = left.build_breadcrumbs
      end

      subheader.build_right do |right|
      end
    end

    layout.build_footer do |footer|
      footer.build_left do |left|
        left.build_text_link("Feedback", "#", class: "pl-0")
      end

      footer.build_right do |right|
        right.build_copyright(start_year: 2025, company_name: "ACME, Inc.")
        right.build_text_link("Privacy", "#")
        right.build_text_link("Terms", "#")
        right.build_text_link("Cookie preferences", "#", class: "pr-0")
      end
    end

    layout.with_main
    layout.with_main_container

    build_breadcrumb("Home", root_path)
  end

  def pending_badge(link, variant: "warning")
    link.with_badge(variant:, class: "text-xs").with_content("TODO")
  end

  with_options to: :view_context do
    delegate :new_icon
  end

  with_options to: :@breadcrumbs do
    delegate :build_breadcrumb
    delegate :with_breadcrumb
  end
  helper_method :build_breadcrumb, :with_breadcrumb

  def with_navigation_sidebar(&block)
    layout.sidebars.first.tap(&block)
  end
end
