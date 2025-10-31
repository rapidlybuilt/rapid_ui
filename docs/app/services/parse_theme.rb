class ParseTheme < ApplicationService::Brief
  attr_accessor :id
  attr_accessor :title
  attr_accessor :description
  attr_accessor :variables

  def call(id)
    @id = id
    @title = t(".title")
    @description = t(".description")
    @variables = parse_variables
    self
  end

  private

  def t(key)
    key = "#{i18n_scope}#{key}" if key[0] == "."
    I18n.t(key)
  end

  def i18n_scope
    "themes.#{@id}"
  end

  def parse_variables
    css_path = Rails.root.join("../app/assets/stylesheets/rapid_ui/themes/#{@id}.css")
    raise "Theme CSS file not found: #{css_path}" unless File.exist?(css_path)

    content = File.read(css_path)

    # First pass: collect all variables
    all_vars = {}
    variables = {}
    current_section = "Other"

    content.scan(/\/\*\s*(.+?)\s*\*\/|--([a-z0-9-]+):\s*([^;]+);/m).each do |match|
      if match[0] # It's a comment
        comment = match[0].strip
        # Skip the main theme comment
        next if comment.match?(/Theme$/i)
        current_section = comment
        variables[current_section] ||= []
      elsif match[1] # It's a variable
        var_name = match[1]
        var_value = match[2].strip

        # Store all variables for reference resolution
        all_vars[var_name] = var_value

        # Skip rgba values as they're not displayable as solid colors
        next if var_value.start_with?("rgba(")

        variables[current_section] ||= []
        variables[current_section] << { name: var_name, value: var_value }
      end
    end

    # Second pass: resolve var() references
    variables.each do |section, vars|
      vars.each do |var|
        if var[:value].start_with?("var(")
          # Extract the referenced variable name from var(--variable-name)
          if var[:value] =~ /var\(--([a-z0-9-]+)\)/
            referenced_var = $1
            var[:value] = all_vars[referenced_var] if all_vars[referenced_var]
          end
        end
      end

      # Remove any variables that resolved to rgba or other non-displayable values
      vars.reject! { |var| var[:value].start_with?("rgba(") }
    end

    # Remove empty sections
    variables.reject! { |_section, vars| vars.empty? }

    variables
  end
end
