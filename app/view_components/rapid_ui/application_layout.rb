module RapidUI
  class ApplicationLayout < RapidUI::Layout::Base
    attr_accessor :header
    attr_accessor :subheader

    def initialize
      super
      @header = Layout::Header::Base.new
      @subheader = Layout::Subheader::Base.new
    end

    class << self
      def layout_template
        "rapid_ui/application"
      end
    end
  end
end
