class TestController < ApplicationController
  class_attribute :test_layout

  def show
    # This allows us to test layout configurations driven by the test
    self.layout = self.class.test_layout
  end
end
