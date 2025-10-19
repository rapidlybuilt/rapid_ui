module RapidUI
  class ApplicationLayout < RapidUI::Layout::Base
    renders_one :header, Layout::Header::Base
    renders_one :subheader, Layout::Subheader::Base
    renders_one :sidebars, "Sidebars"
    renders_one :footer, Layout::Footer::Base

    renders_one :main, Tag
    renders_one :main_container, Tag

    def initialize(**kwargs, &block)
      with_header
      with_subheader
      with_sidebars
      with_footer
      with_main(tag_name: :main, additional_class: "content")
      with_main_container(tag_name: :div, additional_class: "main")

      super(tag_name: :body, **kwargs, &block)
    end

    def with_sidebar(*args, **kwargs, &block)
      sidebars.build(*args, **kwargs, &block)
    end

    class Sidebars < Components
      contains nil, Layout::Sidebar::Base

      def find(id = nil, &block)
        block_given? ? super(&block) : find_by_id(id)
      end

      def find_by_id(id)
        find { |s| s.id == id.to_s }
      end
    end
  end
end
