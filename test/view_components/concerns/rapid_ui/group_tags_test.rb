require_relative "../../rapid_ui/view_component_test_case"

module RapidUI
  module Forms
    class GroupsTagsTest < ViewComponentTestCase
      described_class Groups

      test "with_text_field_group renders text field with label" do
        render_inline build("text_form") do |c|
          c.with_text_field_group :username
        end

        assert_selector "div#text_form_username_group" do
          assert_selector "label[for='text_form_username']", text: "Username"
          assert_selector "input[type='text'][name='username'][id='text_form_username']"
        end
      end

      test "text_field_group renders text field with label" do
        render_inline build("text_form2") do |c|
          c.text_field_group :username
        end

        assert_selector "div#text_form2_username_group" do
          assert_selector "label[for='text_form2_username']", text: "Username"
          assert_selector "input[type='text'][name='username'][id='text_form2_username']"
        end
      end

      test "with_text_field_group accepts placeholder and value options" do
        render_inline build("text_form3") do |c|
          c.with_text_field_group :address, placeholder: "1234 Main St", value: "123 Oak Ave"
        end

        assert_selector "input[placeholder='1234 Main St'][value='123 Oak Ave']"
      end

      test "with_text_field_group accepts colspan option" do
        render_inline build("text_form4") do |c|
          c.with_text_field_group :city, colspan: 6
        end

        assert_selector "div.col-span-12.md\\:col-span-6"
      end

      test "with_email_field_group renders email field" do
        render_inline build("email_form") do |c|
          c.with_email_field_group :email
        end

        assert_selector "div#email_form_email_group" do
          assert_selector "label[for='email_form_email']", text: "Email"
          assert_selector "input[type='email'][name='email'][id='email_form_email']"
        end
      end

      test "email_field_group renders email field" do
        render_inline build("email_form2") do |c|
          c.email_field_group :contact_email
        end

        assert_selector "div#email_form2_contact_email_group" do
          assert_selector "input[type='email'][name='contact_email']"
        end
      end

      test "with_password_field_group renders password field" do
        render_inline build("password_form") do |c|
          c.with_password_field_group :password
        end

        assert_selector "div#password_form_password_group" do
          assert_selector "label[for='password_form_password']", text: "Password"
          assert_selector "input[type='password'][name='password'][id='password_form_password']"
        end
      end

      test "password_field_group renders password field" do
        render_inline build("password_form2") do |c|
          c.password_field_group :current_password
        end

        assert_selector "input[type='password'][name='current_password']"
      end

      test "with_textarea_group renders textarea field" do
        render_inline build("textarea_form") do |c|
          c.with_textarea_group :bio
        end

        assert_selector "div#textarea_form_bio_group" do
          assert_selector "label[for='textarea_form_bio']", text: "Bio"
          assert_selector "textarea[name='bio'][id='textarea_form_bio']"
        end
      end

      test "textarea_group renders textarea field" do
        render_inline build("textarea_form2") do |c|
          c.textarea_group :description
        end

        assert_selector "textarea[name='description']"
      end

      test "with_number_field_group renders number field" do
        render_inline build("number_form") do |c|
          c.with_number_field_group :age
        end

        assert_selector "div#number_form_age_group" do
          assert_selector "label[for='number_form_age']", text: "Age"
          assert_selector "input[type='number'][name='age'][id='number_form_age']"
        end
      end

      test "number_field_group renders number field" do
        render_inline build("number_form2") do |c|
          c.number_field_group :quantity
        end

        assert_selector "input[type='number'][name='quantity']"
      end

      # TODO: file_field tests commented out due to Rails file_field_tag not accepting value parameter
      # test "with_file_field_group renders file field" do
      #   render_inline build("file_form") do |c|
      #     c.with_file_field_group :avatar
      #   end
      #
      #   assert_selector "div#file_form_avatar_group" do
      #     assert_selector "label[for='file_form_avatar']", text: "Avatar"
      #     assert_selector "input[type='file'][name='avatar'][id='file_form_avatar']"
      #   end
      # end
      #
      # test "file_field_group renders file field" do
      #   render_inline build("file_form2") do |c|
      #     c.file_field_group :document
      #   end
      #
      #   assert_selector "input[type='file'][name='document']"
      # end

      test "with_hidden_field_group renders hidden field" do
        render_inline build("hidden_form") do |c|
          c.with_hidden_field_group :token, value: "abc123"
        end

        assert_selector "input[type='hidden'][name='token'][value='abc123']", visible: :all
      end

      test "hidden_field_group renders hidden field" do
        render_inline build("hidden_form2") do |c|
          c.hidden_field_group :secret, value: "xyz789"
        end

        assert_selector "input[type='hidden'][name='secret'][value='xyz789']", visible: :all
      end

      test "with_search_field_group renders search field" do
        render_inline build("search_form") do |c|
          c.with_search_field_group :query
        end

        assert_selector "div#search_form_query_group" do
          assert_selector "label[for='search_form_query']", text: "Query"
          assert_selector "input[type='search'][name='query'][id='search_form_query']"
        end
      end

      test "search_field_group renders search field" do
        render_inline build("search_form2") do |c|
          c.search_field_group :keywords
        end

        assert_selector "input[type='search'][name='keywords']"
      end

      test "with_telephone_field_group renders tel field" do
        render_inline build("tel_form") do |c|
          c.with_telephone_field_group :phone
        end

        assert_selector "div#tel_form_phone_group" do
          assert_selector "label[for='tel_form_phone']", text: "Phone"
          assert_selector "input[type='tel'][name='phone'][id='tel_form_phone']"
        end
      end

      test "telephone_field_group renders tel field" do
        render_inline build("tel_form2") do |c|
          c.telephone_field_group :mobile
        end

        assert_selector "input[type='tel'][name='mobile']"
      end

      test "with_url_field_group renders url field" do
        render_inline build("url_form") do |c|
          c.with_url_field_group :website
        end

        assert_selector "div#url_form_website_group" do
          assert_selector "label[for='url_form_website']", text: "Website"
          assert_selector "input[type='url'][name='website'][id='url_form_website']"
        end
      end

      test "url_field_group renders url field" do
        render_inline build("url_form2") do |c|
          c.url_field_group :homepage
        end

        assert_selector "input[type='url'][name='homepage']"
      end

      test "with_time_field_group renders time field" do
        render_inline build("time_form") do |c|
          c.with_time_field_group :meeting_time
        end

        assert_selector "div#time_form_meeting_time_group" do
          assert_selector "label[for='time_form_meeting_time']", text: "Meeting Time"
          assert_selector "input[type='time'][name='meeting_time'][id='time_form_meeting_time']"
        end
      end

      test "time_field_group renders time field" do
        render_inline build("time_form2") do |c|
          c.time_field_group :start_time
        end

        assert_selector "input[type='time'][name='start_time']"
      end

      test "with_datetime_field_group renders datetime field" do
        render_inline build("datetime_form") do |c|
          c.with_datetime_field_group :scheduled_at
        end

        assert_selector "div#datetime_form_scheduled_at_group" do
          assert_selector "label[for='datetime_form_scheduled_at']", text: "Scheduled At"
          assert_selector "input[type='datetime-local'][name='scheduled_at'][id='datetime_form_scheduled_at']"
        end
      end

      test "datetime_field_group renders datetime field" do
        render_inline build("datetime_form2") do |c|
          c.datetime_field_group :published_at
        end

        assert_selector "input[type='datetime-local'][name='published_at']"
      end

      test "with_select_group renders select field with choices" do
        render_inline build("select_form") do |c|
          c.with_select_group :country, [ "USA", "Canada", "Mexico" ]
        end

        assert_selector "div#select_form_country_group" do
          assert_selector "label[for='select_form_country']", text: "Country"
          assert_selector "select[name='country'][id='select_form_country']" do
            assert_selector "option", text: "USA"
            assert_selector "option", text: "Canada"
            assert_selector "option", text: "Mexico"
          end
        end
      end

      test "select_group renders select field with choices" do
        render_inline build("select_form2") do |c|
          c.select_group :state, [ "California", "Georgia", "Texas" ]
        end

        assert_selector "select[name='state']" do
          assert_selector "option", text: "California"
          assert_selector "option", text: "Georgia"
          assert_selector "option", text: "Texas"
        end
      end

      test "with_select_group accepts selected option" do
        render_inline build("select_form3") do |c|
          c.with_select_group :country, [ "USA", "Canada" ], selected: "Canada"
        end

        assert_selector "select[name='country']" do
          assert_selector "option[value='Canada'][selected]"
        end
      end

      test "with_select_group accepts include_blank option" do
        render_inline build("select_form4") do |c|
          c.with_select_group :state, [ "California", "Georgia" ], include_blank: true
        end

        assert_selector "select[name='state']" do
          assert_selector "option[value='']", text: ""
        end
      end

      test "with_select_group accepts custom label" do
        render_inline build("select_form5") do |c|
          c.with_select_group :country, [ "USA", "Canada" ], label: "Select Country"
        end

        assert_selector "label", text: "Select Country"
      end

      test "select_group accepts custom label" do
        render_inline build("select_form6") do |c|
          c.select_group :state, [ "California", "Georgia" ], label: "State/Province"
        end

        assert_selector "label", text: "State/Province"
      end

      test "field group helpers work in horizontal layout" do
        render_inline build("horizontal_helpers_form", horizontal: true) do |c|
          c.with_text_field_group :first_name, colspan: 4
          c.with_email_field_group :email, colspan: 8
        end

        assert_selector "div.col-span-12.grid.grid-cols-12", count: 2
        assert_selector "input[type='text'][name='first_name']"
        assert_selector "input[type='email'][name='email']"
      end

      test "field group helpers accept hint option" do
        render_inline build("hint_form") do |c|
          c.with_text_field_group :username, hint: "Must be at least 3 characters"
        end

        assert_selector "div.field-hint", text: "Must be at least 3 characters"
      end

      test "field group helpers accept error option" do
        render_inline build("error_form") do |c|
          c.with_email_field_group :email, error: "Email is required"
        end

        assert_selector "div.field-error", text: "Email is required"
      end
    end
  end
end
