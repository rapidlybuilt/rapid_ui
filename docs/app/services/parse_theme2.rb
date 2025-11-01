class ParseTheme2 < ApplicationService::Brief
  attr_accessor :id
  attr_accessor :title
  attr_accessor :description
  attr_accessor :typography_variants
  attr_accessor :button_variants

  class TypographyVariant
    attr_accessor :id
    attr_accessor :name
    attr_accessor :description
    attr_accessor :text
    attr_accessor :text_muted
    attr_accessor :bg
    attr_accessor :border
    attr_accessor :link
    attr_accessor :link_hover
    attr_accessor :code_text
    attr_accessor :code_bg

    def initialize(**kwargs)
      kwargs.each do |key, value|
        send("#{key}=", value)
      end

      self.id ||= "#{name}-typography"
    end
  end

  class ButtonVariant
    attr_accessor :id
    attr_accessor :name
    attr_accessor :text
    attr_accessor :bg
    attr_accessor :border
    attr_accessor :text_hover
    attr_accessor :bg_hover
    attr_accessor :border_hover

    def initialize(**kwargs)
      kwargs.each do |key, value|
        send("#{key}=", value)
      end

      self.id ||= "#{name}-button"
    end
  end

  def call(id)
    @id = id
    @typography_variants = []
    @button_variants = []
    parse_theme_file
    self
  end

  private

  def parse_theme_file
    css_path = Rails.root.join("../app/assets/stylesheets/rapid_ui/themes/#{@id}.css")
    raise "Theme CSS file not found: #{css_path}" unless File.exist?(css_path)

    content = File.read(css_path)

    # Parse title and description from the first two comment lines
    lines = content.lines
    @title = lines[0]&.gsub(/^\/\*\s*|\s*\*\/$/, '')&.strip || "Untitled Theme"
    @description = lines[1]&.gsub(/^\/\*\s*|\s*\*\/$/, '')&.strip || ""

    # Collect all variables for reference resolution
    all_vars = {}
    content.scan(/--([a-z0-9-]+):\s*([^;]+);/).each do |var_name, var_value|
      all_vars[var_name] = var_value.strip
    end

    # Parse typography variants
    parse_typography_variants(all_vars)

    # Parse button variants
    parse_button_variants(all_vars)
  end

  def parse_typography_variants(all_vars)
    # Look for patterns like --color-{variant}-text, --color-{variant}-bg, etc.
    typography_variant_names = Set.new

    all_vars.keys.each do |var_name|
      if var_name.match(/^color-(\w+)-(text|bg|border|link|code)/)
        variant_name = $1
        # Skip button variants
        next if variant_name.start_with?("btn")
        typography_variant_names.add(variant_name)
      end
    end

    typography_variant_names.each do |variant_name|
      text = resolve_var(all_vars, "color-#{variant_name}-text")
      next unless text

      variant = TypographyVariant.new(
        name: variant_name,
        description: typography_variant_description(variant_name),
        text: text,
        text_muted: resolve_var(all_vars, "color-#{variant_name}-text-muted"),
        bg: resolve_var(all_vars, "color-#{variant_name}-bg"),
        border: resolve_var(all_vars, "color-#{variant_name}-border"),
        link: resolve_var(all_vars, "color-#{variant_name}-link"),
        link_hover: resolve_var(all_vars, "color-#{variant_name}-link-hover"),
        code_text: resolve_var(all_vars, "color-#{variant_name}-code-text"),
        code_bg: resolve_var(all_vars, "color-#{variant_name}-code-bg")
      )

      @typography_variants << variant
    end
  end

  def parse_button_variants(all_vars)
    # Look for patterns like --color-btn-{variant}-text, --color-btn-{variant}-bg, etc.
    button_variant_names = Set.new

    all_vars.keys.each do |var_name|
      if var_name.match(/^color-btn-([a-z-]+)-(text|bg|border)$/)
        variant_name = $1
        button_variant_names.add(variant_name)
      end
    end

    button_variant_names.each do |variant_name|
      text = resolve_var(all_vars, "color-btn-#{variant_name}-text")
      next unless text

      variant = ButtonVariant.new(
        name: variant_name,
        text: text,
        bg: resolve_var(all_vars, "color-btn-#{variant_name}-bg"),
        border: resolve_var(all_vars, "color-btn-#{variant_name}-border"),
        text_hover: resolve_var(all_vars, "color-btn-#{variant_name}-text-hover"),
        bg_hover: resolve_var(all_vars, "color-btn-#{variant_name}-bg-hover"),
        border_hover: resolve_var(all_vars, "color-btn-#{variant_name}-border-hover")
      )

      @button_variants << variant
    end
  end

  def typography_variant_description(variant_name)
    descriptions = {
      "core" => "Main content body — the heart of the app",
      "shell" => "Surrounding context — subheader, sidebar, or supporting surfaces",
      "frame" => "Outermost structural layer — header/footer, page edges",
      "success" => "Positive feedback — success messages, confirmations, completions",
      "warning" => "Cautionary alerts — warnings, important notices, potential issues",
      "danger" => "Critical alerts — errors, destructive actions, urgent attention",
      "info" => "Informational content — tips, helpful guidance, neutral notifications",
    }

    descriptions[variant_name]
  end

  def resolve_var(all_vars, var_name)
    value = all_vars[var_name]
    return nil unless value

    # Skip rgba values
    return nil if value.start_with?("rgba(")

    # Resolve variable references recursively
    max_depth = 10 # Prevent infinite loops
    depth = 0

    while depth < max_depth
      depth += 1

      # Handle var() references: var(--color-name)
      if value&.match(/var\(--([a-z0-9-]+)\)/)
        referenced_var = $1
        resolved = all_vars[referenced_var]
        break if resolved.nil? || resolved.start_with?("rgba(")
        value = resolved
        next
      end

      # Handle direct references: --color-name
      if value&.match(/^--([a-z0-9-]+)$/)
        referenced_var = $1
        resolved = all_vars[referenced_var]
        break if resolved.nil? || resolved.start_with?("rgba(")
        value = resolved
        next
      end

      # No more references to resolve
      break
    end

    # Return nil if we ended up with an rgba value
    return nil if value&.start_with?("rgba(")

    value
  end
end
