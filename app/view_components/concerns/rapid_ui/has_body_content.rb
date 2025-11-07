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
      raise ArgumentError, "no body" unless body?
      raise ArgumentError, "body and content cannot both be given" if content?
      with_content(safe_join(body))
    end

    def before_render
      with_body_content if body?
    end
  end
end
