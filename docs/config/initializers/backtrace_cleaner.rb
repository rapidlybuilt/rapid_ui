Rails.backtrace_cleaner.tap do |cleaner|
  # Show RapidUI gem paths relative to gem root
  cleaner.add_filter do |line|
    if line.include?(RapidUI.root.to_s)
      line.sub(RapidUI.root.to_s, "rapid_ui")
    else
      line
    end
  end
end
