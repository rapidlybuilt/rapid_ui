module RapidUI
  module FormHelper
    include Form::GroupsHelper

    # Make the Form module accessible
    Form = RapidUI::Form
  end
end
