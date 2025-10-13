module RapidUI
  class ApplicationLayout < RapidUI::Layout::Base
    attr_accessor :header
    attr_accessor :subheader
    attr_accessor :sidebar
    attr_accessor :footer

    def initialize
      super

      @header = Layout::Header::Base.new
      @subheader = Layout::Subheader::Base.new
      @sidebar = Layout::Sidebar::Base.new
      @footer = Layout::Footer::Base.new
    end

    class << self
      def layout_template
        "rapid_ui/application"
      end
    end
  end
end
