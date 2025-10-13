module RapidUI
  class ApplicationLayout < RapidUI::Layout::Base
    class << self
      def layout_template
        "rapid_ui/application"
      end
    end
  end
end
