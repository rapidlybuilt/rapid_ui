module RapidUI
  class ApplicationLayout < RapidUI::Layout::Base
    renders_one :header, Layout::Header::Base
    renders_one :subheader, Layout::Subheader::Base
    renders_one :sidebars, "Sidebars"
    renders_one :footer, Layout::Footer::Base

    def initialize(**kwargs, &block)
      with_header
      with_subheader
      with_sidebars
      with_footer

      super(**kwargs, &block)
    end

    class Sidebars < Components
      contains Layout::Sidebar::Base, nil

      def find(id = nil, &block)
        block_given? ? super(&block) : find_by_id(id)
      end

      def find_by_id(id)
        find { |s| s.id == id.to_s }
      end
    end
  end
end
