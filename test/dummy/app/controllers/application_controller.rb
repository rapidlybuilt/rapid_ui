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
    rapid_ui.register! RapidUI::Layout::Sidebar::Navigation::Link, ->(klass, name, path, **kwargs, &block) do
      klass.new(name, path, active: request.path == path, **kwargs, &block)
    end

    # pre-expand sections with active links
    rapid_ui.register! RapidUI::Layout::Sidebar::Navigation::Section, ->(klass, name, **kwargs, &block) do
      klass.new(name, **kwargs) do |section|
        block.call(section) if block
        section.expanded = section.components.any?(&:active?) if section.expanded.nil?
      end
    end

    # auto-set whether the sidebar is closed based on the cookie
    rapid_ui.register! RapidUI::Layout::Sidebar::Base, ->(klass, **kwargs, &block) do
      klass.new(**kwargs) do |sidebar|
        block.call(sidebar) if block
        sidebar.closed = cookies[sidebar.closed_cookie_name] == "1" if sidebar.closed.nil?
      end
    end

    layout.head.tap do |head|
      head.site_name = "Dummy"

      head.with_favicon("rapid_ui/favicon-32x32.png", type: "image/png", size: 32)
      head.with_favicon("rapid_ui/favicon-16x16.png", type: "image/png", size: 16)
      head.with_apple_touch_icon("rapid_ui/apple-touch-icon.png")

      head.stylesheet_link_sources = [ "application" ]
    end

    layout.header.tap do |header|
      header.left.tap do |left|
        # TODO: clean this up. #with_link with a single child (the icon)
        left.with_icon_link("logo", root_path, size: 32, class: "px-0 rounded-full") do |link|
          link.content.css_class = "hover:scale-110"
        end

        left.with_dropdown(new_icon("layout-grid"), skip_caret: true) do |dropdown|
          dropdown.menu.with_item("Builds & Deploys", "#")
          dropdown.menu.with_item("Code Coverage", "#")
          dropdown.menu.with_item("Errors", "#")
          dropdown.menu.with_divider
          dropdown.menu.with_item("Content Management", "#")
          dropdown.menu.with_item("Users", "#")
        end

        left.with_search(path: search_path)
      end

      header.right.tap do |right|
        right.with_text("username")

        right.with_icon_link("hash", "#")
        right.with_icon_link("info", "#")
        right.with_icon_link("circle-question-mark", "#")
        right.with_icon_link("settings", "#")

        right.with_dropdown("username", align: "right") do |dropdown|
          dropdown.menu.with_item("Profile Settings", "#")
          dropdown.menu.with_item("Account Preferences", "#")
          dropdown.menu.with_item("Billing & Plans", "#")
          dropdown.menu.with_divider
          dropdown.menu.with_item("Help & Support", "#")
          dropdown.menu.with_item("Sign Out", "#")
        end
      end
    end

    main_sidebar = layout.with_sidebar(id: "main_sidebar", title: "Components").tap do |sidebar|
      sidebar.with_navigation do |navigation|
        navigation.with_link("Dashboard", root_path)

        navigation.with_section("Content") do |section|
          pending__badge section.with_link("Accordion", "#")
          section.with_link("Badges", components_content_badges_path)
          pending__badge section.with_link("Card", "#")
          pending__badge section.with_link("Carousel", "#")
          section.with_link("Icons", components_content_icons_path)
          pending__badge section.with_link("List group", "#")
          section.with_link("Tables", components_content_tables_path)
          section.with_link("Typography", components_content_typography_path)
        end

        navigation.with_section("Controls") do |section|
          section.with_link("Buttons", components_controls_buttons_path)
          pending__badge section.with_link("Button group", "#")
          section.with_link("Dropdowns", components_controls_dropdowns_path)
          pending__badge section.with_link("Modals", "#")
          pending__badge section.with_link("Tables", "#")
        end

        navigation.with_section("Feedback") do |section|
          pending__badge section.with_link("Alerts", "#")
          pending__badge section.with_link("Popovers", "#")
          pending__badge section.with_link("Progress", "#")
          pending__badge section.with_link("Spinners", "#")
          pending__badge section.with_link("Toasts", "#")
          pending__badge section.with_link("Tooltips", "#")
        end

        navigation.with_section("Navigation") do |section|
          pending__badge section.with_link("Dropdowns", "#")
          pending__badge section.with_link("Navbar", "#")
          pending__badge section.with_link("Pagination", "#")
          pending__badge section.with_link("Scrollspy", "#")
          pending__badge section.with_link("Tabs", "#")
        end

        navigation.with_section("Forms") do |section|
          pending__badge section.with_link("Select", "#")
          pending__badge section.with_link("Checks & radios", "#")
          pending__badge section.with_link("Range", "#")
          pending__badge section.with_link("Input group", "#")
          pending__badge section.with_link("Floating labels", "#")
          pending__badge section.with_link("Layout", "#")
          pending__badge section.with_link("Validation", "#")
          pending__badge section.with_link("Wizard", "#")
        end

        navigation.with_section("Charts") do |section|
          pending__badge section.with_link("Flot", "#")
          pending__badge section.with_link("Radial", "#")
          pending__badge section.with_link("ChartJS", "#")
        end

        navigation.with_section("StimulusJS") do |section|
          section.with_link("Expandable", expandable_stimulus_path)
        end
      end
    end

    layout.subheader.tap do |subheader|
      subheader.left.with_sidebar_toggle_button(title: "Toggle navigation", icon: "menu", target: main_sidebar, circular: true)
      subheader.left.with_breadcrumbs

      subheader.with_breadcrumb("Home", root_path)
    end

    layout.footer.tap do |footer|
      footer.left.with_text_link("Feedback", "#", class: "pl-0")

      footer.right.with_copyright(start_year: 2025, company_name: "ACME, Inc.")
      footer.right.with_text_link("Privacy", "#")
      footer.right.with_text_link("Terms", "#")
      footer.right.with_text_link("Cookie preferences", "#", class: "pr-0")
    end
  end

  def pending__badge(link)
    link.with_badge("TODO", variant: "warning", class: "text-xs")
  end

  with_options to: :view_context do
    delegate :new_icon
  end
end
