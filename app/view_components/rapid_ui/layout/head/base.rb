module RapidUI
  module Layout
    module Head
      class Base < ApplicationComponent
        # TODO: common meta tags + OpenGraph

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

        renders_one :favicons, Favicon::Components

        with_options to: :view_context do
          delegate :csrf_meta_tags
          delegate :csp_meta_tag
          delegate :stylesheet_link_tag
          delegate :image_path
          delegate :javascript_importmap_tags
        end

        with_options to: :favicons do
          delegate :with_favicon
          delegate :with_apple_touch_icon
        end

        def initialize(importmap: RapidUI.importmap, importmap_entry_point: "application", stylesheet_link_sources: [ "rapid_ui/application" ], title_separator: " - ", **kwargs)
          super(**kwargs)

          with_favicons

          @importmap_entry_point = importmap_entry_point
          @importmap = importmap

          @stylesheet_link_sources = stylesheet_link_sources
          @title_separator = title_separator

          yield self if block_given?
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
