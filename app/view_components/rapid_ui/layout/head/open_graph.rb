module RapidUI
  module Layout
    module Head
      class OpenGraph < ApplicationComponent
        attr_accessor :locale
        attr_accessor :type
        attr_accessor :url
        attr_accessor :title
        attr_accessor :description
        attr_accessor :image_url
        attr_accessor :domain

        def call
          a = ActiveSupport::SafeBuffer.new

          description = self.description if self.description.present?
          description = description.strip.gsub(/\s+/, " ") if description.present?
          description = description.truncate(100, separator: " ", omission: "...") if description.present?

          a << tag.meta(property: "og:locale",       content: locale) if locale.present?
          a << tag.meta(property: "og:type",         content: "article")
          a << tag.meta(property: "og:url",          content: url) if url.present?
          a << tag.meta(property: "og:title",        content: title) if title.present?
          a << tag.meta(property: "og:description",  content: description) if description.present?
          a << tag.meta(property: "og:image",        content: image_url) if image_url.present?

          a << tag.meta(name: "twitter:title",       content: title) if title.present?
          a << tag.meta(name: "twitter:description", content: description) if description.present?
          a << tag.meta(name: "twitter:card",        content: "summary_large_image") if image_url.present?
          a << tag.meta(name: "twitter:image",       content: image_url) if image_url.present?
          a << tag.meta(name: "twitter:domain",      content: domain) if domain.present?
          a << tag.meta(name: "twitter:url",         content: url) if url.present?

          a
        end
      end
    end
  end
end
