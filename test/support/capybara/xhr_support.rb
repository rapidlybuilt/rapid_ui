module CapybaraXHRHelper
  def xhr_get(path, params: {}, headers: {})
    ensure_rack_test!

    xhr_headers = {
      "HTTP_X_REQUESTED_WITH" => "XMLHttpRequest"
    }.merge(headers)

    page.driver.get(path, params, xhr_headers)
  end

  private

  def ensure_rack_test!
    unless Capybara.current_driver == :rack_test
      raise <<~MSG
        xhr_get only works with the :rack_test driver.
        Current driver: #{Capybara.current_driver}

        Use a JS driver and trigger the request via browser interaction instead.
      MSG
    end
  end
end
