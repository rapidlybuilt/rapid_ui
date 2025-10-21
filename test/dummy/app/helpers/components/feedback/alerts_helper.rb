module Components::Feedback::AlertsHelper
  def component_feedback_alert_variants
    demo_components do |c|
      c << new_info_alert("This is an informational alert.")
      c << new_success_alert("Your action was successful!")
      c << new_warning_alert("Please be careful with this action.")
      c << new_danger_alert("Something went wrong.")
      c << new_light_primary_alert("This is a light primary alert.")
      c << new_light_secondary_alert("This is a light secondary alert.")
      c << new_dark_primary_alert("This is a dark primary alert.")
      c << new_dark_secondary_alert("This is a dark secondary alert.")
    end
  end

  def component_feedback_alert_with_icons
    demo_components do |c|
      c << new_info_alert("This alert includes an icon for better visual communication.", icon: "info")
      c << new_success_alert("Your changes have been saved successfully!", icon: "circle-check")
      c << new_warning_alert("This action cannot be undone.", icon: "triangle-alert")
      c << new_danger_alert("Failed to process your request.", icon: "circle-question-mark")
    end
  end

  def component_feedback_alert_dismissible
    demo_components do |c|
      c << new_info_alert("This alert can be dismissed.", dismissible: true)
      c << new_success_alert("This alert can be dismissed.", dismissible: true)
    end
  end

  def component_feedback_alert_html_content
    demo_components do |c|
      c << new_info_alert(icon: "info", dismissible: true).with_content(
        tag.strong("Did you know?"),
        tag.p(class: "mt-1 mb-0") do
          safe_join([
            "You can include ",
            tag.a("links", href: "#", class: "underline"),
            ", ",
            tag.strong("bold text"),
            ", ",
            tag.em("italic text"),
            ", and other HTML elements in alerts.",
          ])
        end
      )

      c << new_warning_alert(icon: "triangle-alert").with_content(
        tag.strong("Important Notice"),
        tag.p("Before proceeding, please ensure:", class: "mt-1 mb-1"),
        tag.ul(class: "list-disc ml-5 mb-0") do
          safe_join([
            tag.li("All required fields are completed"),
            tag.li("You have reviewed the terms and conditions"),
            tag.li("Your changes have been saved"),
          ])
        end
      )

      c << new_success_alert(dismissible: true).with_content(
        tag.div do
          safe_join([
            tag.strong("Account Created Successfully!"),
            tag.p(class: "mt-1 mb-0") do
              safe_join([
                "Your account has been created. Check your email for a verification link. ",
                tag.a("Resend email", href: "#", class: "underline font-semibold"),
              ])
            end,
          ])
        end
      )


      c << new_danger_alert.with_content(
        tag.strong("Critical System Error"),
        tag.p("The following issues were detected:", class: "mt-1 mb-1"),
        tag.ul(class: "list-disc ml-5 mb-0") do
          safe_join([
            tag.li("Database connection timeout"),
            tag.li("Background job queue is not processing"),
            tag.li("Cache server is unresponsive"),
          ])
        end
      )
    end
  end
end
