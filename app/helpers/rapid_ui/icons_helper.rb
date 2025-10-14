module RapidUI
  module IconsHelper
    def icon(name, size: nil, spin: false, **options)
      render Icon.new(name, size:, spin:, **options)
    end
  end
end
