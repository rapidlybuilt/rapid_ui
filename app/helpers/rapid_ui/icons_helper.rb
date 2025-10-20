module RapidUI
  module IconsHelper
    def new_icon(name, size: nil, spin: false, **kwargs)
      rapid_ui.build(Icon, name, size:, spin:, **kwargs)
    end

    def icon(name, size: nil, spin: false, **kwargs)
      render new_icon(name, size:, spin:, **kwargs)
    end
  end
end
