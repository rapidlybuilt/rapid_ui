module RapidUI
  module Support
    module I18n
      extend ActiveSupport::Concern

      def t(key, **options)
        self.class.t(key, **options)
      end

      module ClassMethods
        def i18n_scope
          # unique for every class, not inheritable
          @i18n_scope ||= "#{name.underscore.gsub("/", ".")}"
        end

        def t(key, **options)
          result = ::I18n.t("#{i18n_scope}.#{key}", default: nil, **options)
          return result if result

          # go up the chain
          superclass.t(key) if superclass.respond_to?(:i18n_scope)
        end
      end
    end
  end
end
