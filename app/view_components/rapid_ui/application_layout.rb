module RapidUI
  class ApplicationLayout < RapidUI::Layout::Base
    attr_accessor :header
    attr_accessor :subheader
    attr_accessor :footer

    attr_accessor :sidebar_closed_cookie_name

    def initialize
      super
      @header = Layout::Header::Base.new
      @subheader = Layout::Subheader::Base.new
      @footer = Layout::Footer::Base.new

      @sidebar_closed_cookie_name = "sidebar_closed"
    end

    # TODO: fix the way this data flows to hide the complexity from the application
    # while not passing cookies around unnecessarily
    def sidebar_closed?(cookies)
      cookies[sidebar_closed_cookie_name] == "1"
    end

    class << self
      def layout_template
        "rapid_ui/application"
      end
    end
  end
end
