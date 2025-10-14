module RapidUI
  module Layout
    module Head
      class Base < ViewComponent::Base
        attr_accessor :title
        attr_accessor :site_name
        attr_accessor :title_separator
        attr_writer :full_title

        attr_accessor :skip_csrf_meta_tags
        alias_method :skip_csrf_meta_tags?, :skip_csrf_meta_tags

        attr_accessor :skip_csp_meta_tag
        alias_method :skip_csp_meta_tag?, :skip_csp_meta_tag

        attr_accessor :stylesheet_link_sources

        attr_accessor :importmap
        attr_accessor :importmap_entry_point

        attr_accessor :favicons

        with_options to: :view_context do
          delegate :csrf_meta_tags
          delegate :csp_meta_tag
          delegate :stylesheet_link_tag
          delegate :image_path
          delegate :javascript_importmap_tags
        end

        def initialize
          @stylesheet_link_sources = [ "rapid_ui/application" ]
          @title_separator = " - "

          @importmap_entry_point = "application"
          @importmap = RapidUI.importmap

          @favicons = Favicon::Components.new
        end

        def full_title
          @full_title || construct_full_title
        end

      private

        def construct_full_title
          [ title, site_name ].compact.join(title_separator)
        end
      end
    end
  end
end
