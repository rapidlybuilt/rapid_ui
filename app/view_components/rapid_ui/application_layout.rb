module RapidUI
  class ApplicationLayout < RapidUI::Layout::Base
    renders_one :header, Layout::Header::Base
    renders_one :subheader, Layout::Subheader::Base
    renders_one :footer, Layout::Footer::Base

    renders_one :main, ->(**kwargs, &block) do
      build(Tag, tag_name: :main, **kwargs, class: merge_classes("content", kwargs[:class]), &block)
    end

    renders_one :main_container, ->(**kwargs, &block) do
      build(Tag, tag_name: :div, **kwargs, class: merge_classes("main-container", kwargs[:class]), &block)
    end

    renders_many :sidebars, Layout::Sidebar::Base

    def initialize(**kwargs)
      super(tag_name: :body, **kwargs)

      yield self if block_given?
    end

    def before_render
      with_main unless main?
      with_main_container unless main_container?
    end
  end
end
