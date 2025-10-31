# TODO: move this somewhere inside of rapid*
class ApplicationService
  class << self
    def call(*args, **kargs)
      Rails.logger.tagged(name) do
        new(*args, **kargs).call
      end
    end
  end

  class Brief
    class << self
      def call(*args, **kargs)
        Rails.logger.tagged(name) do
          new.call(*args, **kargs)
        end
      end
    end
  end
end
