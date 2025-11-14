class TestController < ApplicationController
  extend RapidUI::UsesLayout
  uses_application_layout

  class_attribute :test_layout

  def show
    # This allows us to test layout configurations driven by the test
    ui.layout = self.class.test_layout
  end
end
