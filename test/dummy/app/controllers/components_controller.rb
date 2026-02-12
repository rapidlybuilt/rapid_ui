class ComponentsController < ApplicationController
  include RapidUI::RendersComponents

  class_attribute :test_component

  def show
    component = self.class.test_component
    add_renderable_component(component)

    respond_with_component || render(template: "test/show")
  end
end
