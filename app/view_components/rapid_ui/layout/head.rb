module RapidUI
  module Layout
    class Head < ViewComponent::Base
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
        @stylesheet_link_sources = ["rapid_ui/application"]
        @title_separator = " - "

        @importmap_entry_point = "application"
        @importmap = RapidUI.importmap

        @favicons = Favicons.new
      end

      def full_title
        @full_title || construct_full_title
      end

    private

      def construct_full_title
        [title, site_name].compact.join(title_separator)
      end

      class Favicon < ApplicationComponent
        attr_accessor :path
        attr_accessor :size
        attr_accessor :type

        def initialize(path, type:, size:)
          @path = path
          @size = size
          @type = type
        end

        def call
          tag.link rel: "icon", type:, sizes: "#{size}x#{size}", href: image_path(path)
        end
      end

      class AppleTouchIcon < ApplicationComponent
        attr_accessor :path

        def initialize(path)
          @path = path
        end

        def call
          tag.link rel: "apple-touch-icon", href: image_path(path)
        end
      end

      class Favicons < Components::Typed
        def initialize
          super(Favicon)
        end

        def new_apple_touch(path)
          AppleTouchIcon.new(path)
        end

        def build_apple_touch(path)
          self << new_apple_touch(path)
        end
      end
    end
  end
end
