module RapidUI
  module Layout
    module Footer
      class Components < RapidUI::Components
        contains Copyright, :copyright
        contains Button, :text_link do |name, path, **kwargs|
          Button.new(name, path:, class: "footer-btn", **kwargs)
        end

        contains Button, :icon_link do |icon, path, **kwargs|
          Button.new(nil, path:, icon:, class: "footer-btn", **kwargs)
        end
      end
    end
  end
end
