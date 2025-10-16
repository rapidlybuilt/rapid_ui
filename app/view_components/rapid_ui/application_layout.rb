module RapidUI
  class ApplicationLayout < RapidUI::Layout::Base
    renders_one :header, Layout::Header::Base
    renders_one :subheader, Layout::Subheader::Base
    renders_one :sidebar, Layout::Sidebar::Base
    renders_one :footer, Layout::Footer::Base

    def initialize(**kwargs, &block)
      self.header = Layout::Header::Base.new
      self.subheader = Layout::Subheader::Base.new
      self.sidebar = Layout::Sidebar::Base.new
      self.footer = Layout::Footer::Base.new

      super(**kwargs, &block)
    end
  end
end
