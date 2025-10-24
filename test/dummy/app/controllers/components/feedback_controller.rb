class Components::FeedbackController < Components::BaseController
  helper RapidUI::FeedbackHelper

  private

  def set_breadcrumbs
    build_breadcrumb("Components", components_root_path)
    build_breadcrumb("Feedback", components_feedback_path)
  end
end
