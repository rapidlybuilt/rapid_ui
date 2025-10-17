class ApplicationController < ActionController::Base
  extend RapidUI::UsesLayout

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  uses_application_layout

  before_action :setup_layout

  private

  def setup_layout
    layout.head.tap do |head|
      head.site_name = "Dummy"

      head.favicons.build("rapid_ui/favicon-32x32.png", type: "image/png", size: 32)
      head.favicons.build("rapid_ui/favicon-16x16.png", type: "image/png", size: 16)
      head.favicons.build_apple_touch("rapid_ui/apple-touch-icon.png")

      head.stylesheet_link_sources = [ "application" ]
    end

    layout.header.tap do |header|
      header.left.tap do |left|
        # TODO: clean this up. #build_link with a single child (the icon)
        left.build_icon_link("logo", root_path, size: 32, class: "px-0 rounded-full") do |link|
          link.content.first.css_class = "hover:scale-110"
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

    main_sidebar = layout.sidebars.build(id: "main_sidebar", title: "Components").tap do |sidebar|
      sidebar.closed = sidebar.closed?(cookies)

      sidebar.build_navigation do |navigation|
        navigation.build_link("Dashboard", root_path)

        navigation.build_section("Content") do |section|
          pending__badge section.build_link("Accordion", "#")
          section.build_link("Badges", components_content_badges_path)
          pending__badge section.build_link("Card", "#")
          pending__badge section.build_link("Carousel", "#")
          section.build_link("Icons", components_content_icons_path)
          pending__badge section.build_link("List group", "#")
          section.build_link("Typography", components_content_typography_path)
        end

        navigation.build_section("Controls") do |section|
          section.build_link("Buttons", components_controls_buttons_path)
          pending__badge section.build_link("Button group", "#")
          section.build_link("Dropdowns", components_controls_dropdowns_path)
          pending__badge section.build_link("Modals", "#")
          pending__badge section.build_link("Tables", "#")
        end

        navigation.build_section("Feedback") do |section|
          pending__badge section.build_link("Alerts", "#")
          pending__badge section.build_link("Popovers", "#")
          pending__badge section.build_link("Progress", "#")
          pending__badge section.build_link("Spinners", "#")
          pending__badge section.build_link("Toasts", "#")
          pending__badge section.build_link("Tooltips", "#")
        end

        navigation.build_section("Navigation") do |section|
          pending__badge section.build_link("Dropdowns", "#")
          pending__badge section.build_link("Navbar", "#")
          pending__badge section.build_link("Pagination", "#")
          pending__badge section.build_link("Scrollspy", "#")
          pending__badge section.build_link("Tabs", "#")
        end

        navigation.build_section("Forms") do |section|
          pending__badge section.build_link("Select", "#")
          pending__badge section.build_link("Checks & radios", "#")
          pending__badge section.build_link("Range", "#")
          pending__badge section.build_link("Input group", "#")
          pending__badge section.build_link("Floating labels", "#")
          pending__badge section.build_link("Layout", "#")
          pending__badge section.build_link("Validation", "#")
          pending__badge section.build_link("Wizard", "#")
        end

        navigation.build_section("Charts") do |section|
          pending__badge section.build_link("Flot", "#")
          pending__badge section.build_link("Radial", "#")
          pending__badge section.build_link("ChartJS", "#")
        end

        navigation.build_section("StimulusJS") do |section|
          section.build_link("Expandable", expandable_stimulus_path)
        end
      end
    end

    # Example: Add a second sidebar on the right
    scrollspy_sidebar = layout.sidebars.build(id: "scrollspy", position: :right, title: "On this page") do |sidebar|
      sidebar.closed = sidebar.closed?(cookies)

      sidebar.build_navigation do |navigation|
        # TODO: page section anchor links
        navigation.build_link("Action 1", "#")
        navigation.build_link("Action 2", "#")
      end
    end

    layout.subheader.tap do |subheader|
      subheader.left.build_sidebar_toggle_button(title: "Toggle navigation", icon: "menu", target: main_sidebar, circular: true)
      subheader.left.build_breadcrumbs do |breadcrumbs|
        breadcrumbs.build("Home", root_path)
      end

      subheader.right.build_sidebar_toggle_button(title: "Toggle page index", icon: "info", target: scrollspy_sidebar)
    end

    layout.footer.tap do |footer|
      footer.left.build_text_link("Feedback", "#", class: "pl-0")

      footer.right.build_copyright(start_year: 2025, company_name: "ACME, Inc.")
      footer.right.build_text_link("Privacy", "#")
      footer.right.build_text_link("Terms", "#")
      footer.right.build_text_link("Cookie preferences", "#", class: "pr-0")
    end
  end

  def pending__badge(link)
    link.build_badge("TODO", variant: "warning", class: "text-xs")
  end

  def new_icon(*args, **kwargs)
    RapidUI::Icon.new(*args, **kwargs)
  end
end
