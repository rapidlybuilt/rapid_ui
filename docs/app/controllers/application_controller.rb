class ApplicationController < ActionController::Base
  extend RapidUI::UsesLayout
  include UiFactories

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
      link.active = request.path == link.path if link.active.nil?
    end

    # pre-expand sections with active links
    ui.factory.register_polish! RapidUI::Layout::Sidebar::Navigation::Section, ->(section) do
      section.expanded = section.path == request.path || section.links.any?(&:active?) if section.expanded.nil?
    end

    # auto-set whether the sidebar is closed based on the cookie
    ui.factory.register_polish! RapidUI::Layout::Sidebar::Base, ->(sidebar) do
      sidebar.closed = cookies[sidebar.closed_cookie_name] == "1" if sidebar.closed.nil?
    end

    ui.layout.build_head do |head|
      head.site_name = "Docs"

      head.build_favicon("rapid_ui/favicon-32x32.png", type: "image/png", size: 32)
      head.build_favicon("rapid_ui/favicon-16x16.png", type: "image/png", size: 16)
      head.build_apple_touch_icon("rapid_ui/apple-touch-icon.png")

      head.stylesheet_link_sources = [ "application" ]
    end

    ui.layout.build_header do |header|
      header.build_left do |left|
        # TODO: clean this up. #build_link with a single child (the icon)
        left.build_icon_link("logo", root_path, size: 32, class: "px-0 size-[34px]") do |link|
          link.body.first.css_class = "hover:scale-110 rounded-full"
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

        left.build_search_bar(dynamic_path: search_path)
      end

      header.build_right do |right|
        right.build_text("username", class: "hidden lg:block")

        right.build_icon_link("hash", "#", class: "hidden lg:block")
        right.build_icon_link("info", "#", class: "hidden lg:block")
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

    main_sidebar = ui.layout.build_sidebar(id: "main_sidebar")

    ui.layout.build_subheader do |subheader|
      subheader.build_sidebar_toggle_button(target: main_sidebar)
      subheader.build_breadcrumbs
      subheader.build_button("settings", "#", title: "Settings", class: "hidden md:block")
    end

    ui.layout.build_footer do |footer|
      footer.build_left do |left|
        left.build_text_link("Feedback", "#", class: "pl-0 hidden md:block")
        left.build_dropdown(direction: "up", class: "block md:hidden") do |dropdown|
          dropdown.build_button("Legal")
          dropdown.build_menu do |menu|
            menu.build_item("Privacy", "#")
            menu.build_item("Terms", "#")
            menu.build_item("Cookie preferences", "#")
          end
        end
      end

      footer.build_right do |right|
        right.build_copyright(start_year: 2025, company_name: "ACME, Inc.")
        right.build_text_link("Privacy", "#", class: "hidden md:block")
        right.build_text_link("Terms", "#", class: "hidden md:block")
        right.build_text_link("Cookie preferences", "#", class: "pr-0 hidden md:block")
      end
    end

    ui.layout.with_main
    ui.layout.with_main_container
  end
end
