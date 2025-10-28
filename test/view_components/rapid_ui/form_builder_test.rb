require_relative "../../helpers/rapid_ui/helper_test_case"

module RapidUI
  class FormBuilderTest < HelperTestCase
    include RapidUI::FormsHelper

    setup do
      @user = User.new(id: 1, email: "user@example.com", first_name: "John")
    end

    test "renders field groups using the ViewComponent with_* API" do
      html = form_for(@user, url: "/users/1", builder: RapidUI::FormBuilder) do |f|
        f.with_field_groups do |g|
          g.with_group :email do |h|
            h.text_field
          end

          # View Component API requires additional HTML be specified this way
          g.with_tag(tag_name: :hr, id: "separator")

          g.with_group :first_name do |h|
            h.text_field
          end
        end
      end

      render_inline(html)

      # field groups container
      assert_selector "form[action='/users/1'] > div.grid-cols-12.gap-3"

      # user field
      assert_selector "div#user_email_group.col-span-12"
      assert_selector "label[for='user_email']", text: "Email"
      assert_selector "input#user_email[name='user[email]'][value='user@example.com']"

      # separator
      assert_selector "hr#separator"

      # first name field
      assert_selector "label[for='user_first_name']", text: "First Name"
      assert_selector "input#user_first_name[name='user[first_name]'][value='John']"
    end

    test "renders field groups using the FormBuilder DSL" do
      html = form_for(@user, url: "/users/1", builder: RapidUI::FormBuilder) do |f|
        f.field_groups do |g|
          # mock using <%= %> in ERB
          safe_join([
            g.field_group(:email) { |h| h.text_field },
            tag.hr(id: "separator"),
            g.field_group(:first_name) { |h| h.text_field },
          ])
        end
      end

      render_inline(html)

      # field groups container
      assert_selector "form[action='/users/1'] > div.grid-cols-12.gap-3"

      # user field
      assert_selector "div#user_email_group.col-span-12"
      assert_selector "label[for='user_email']", text: "Email"
      assert_selector "input#user_email[name='user[email]'][value='user@example.com']"

      # separator
      assert_selector "hr#separator"

      # first name field
      assert_selector "label[for='user_first_name']", text: "First Name"
      assert_selector "input#user_first_name[name='user[first_name]'][value='John']"
    end
  end
end
