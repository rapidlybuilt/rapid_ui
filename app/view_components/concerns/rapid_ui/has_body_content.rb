module RapidUI
  module HasBodyContent
    extend ActiveSupport::Concern

    included do
      attr_accessor :body
    end

    def body?
      body.present? && body.any?
    end

    private

    def with_body_content
      with_content(safe_join(body)) if body?
    end

    def before_render
      with_body_content
    end
  end
end
