module RapidUI
  class ApplicationLayout < RapidUI::Layout::Base
    renders_one :header, Layout::Header::Base
    renders_one :subheader, Layout::Subheader::Base
    renders_one :sidebars, "Sidebars"
    renders_one :footer, Layout::Footer::Base

    renders_one :main, Tag
    renders_one :main_container, Tag

    def initialize(**kwargs)
      super(tag_name: :body, **kwargs)

      with_header
      with_subheader
      with_sidebars
      with_footer
      with_main(tag_name: :main, class: "content")
      with_main_container(tag_name: :div, class: "main-container")

      yield self if block_given?
    end

    def with_sidebar(*args, **kwargs, &block)
      sidebars.with_sidebar(*args, **kwargs, &block)
    end

    class Sidebars < Components
      contains :sidebar, Layout::Sidebar::Base

      def find(id = nil, &block)
        block_given? ? super(&block) : find_by_id(id)
      end

      def find_by_id(id)
        find { |s| s.id == id.to_s }
      end
    end
  end
end
