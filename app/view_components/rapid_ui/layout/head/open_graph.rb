module RapidUI
  module Layout
    module Head
      class OpenGraph < ApplicationComponent
        attr_accessor :locale
        attr_accessor :type
        attr_accessor :site_name
        attr_accessor :url
        attr_accessor :title
        attr_accessor :description
        attr_accessor :image_url
        attr_accessor :image_alt
        attr_accessor :domain

        def call
          a = ActiveSupport::SafeBuffer.new
          desc = truncated_description

          # Open Graph tags
          a << tag.meta(property: "og:locale",      content: locale) if locale.present?
          a << tag.meta(property: "og:type",        content: type.presence || "website")
          a << tag.meta(property: "og:site_name",   content: site_name) if site_name.present?
          a << tag.meta(property: "og:url",         content: url) if url.present?
          a << tag.meta(property: "og:title",       content: title) if title.present?
          a << tag.meta(property: "og:description", content: desc) if desc.present?
          a << tag.meta(property: "og:image",       content: image_url) if image_url.present?
          a << tag.meta(property: "og:image:alt",   content: image_alt) if image_alt.present?

          # Twitter Card tags (twitter:title, twitter:description, twitter:image fall back to OG equivalents)
          a << tag.meta(name: "twitter:card",   content: image_url.present? ? "summary_large_image" : "summary")
          a << tag.meta(name: "twitter:domain", content: domain) if domain.present?

          a
        end

        private

        def truncated_description
          return unless description.present?

          description.strip.gsub(/\s+/, " ").truncate(160, separator: " ", omission: "...")
        end
      end
    end
  end
end
