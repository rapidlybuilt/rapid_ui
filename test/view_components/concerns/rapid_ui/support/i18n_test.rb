require "test_helper"

module RapidUI
  module Support
    class I18nTest < ActiveSupport::TestCase
      include I18nSupport

      class GrandparentTable
        include I18n
      end

      class ParentTable < GrandparentTable
      end

      class ChildTable < ParentTable
      end

      test "t on subclass" do
        mock_translation("rapid_ui.support.i18n_test.grandparent_table.asdf", "Level 1")
        mock_translation("rapid_ui.support.i18n_test.parent_table.asdf", "Level 2")
        mock_translation("rapid_ui.support.i18n_test.child_table.asdf", "Level 3")

        assert_equal "Level 1", GrandparentTable.t("asdf")
        assert_equal "Level 2", ParentTable.t("asdf")
        assert_equal "Level 3", ChildTable.t("asdf")

        assert_equal "Level 1", GrandparentTable.new.t("asdf")
        assert_equal "Level 2", ParentTable.new.t("asdf")
        assert_equal "Level 3", ChildTable.new.t("asdf")
      end

      test "t from superclass" do
        mock_translation("rapid_ui.support.i18n_test.grandparent_table.asdf", "Level 1")
        mock_translation("rapid_ui.support.i18n_test.parent_table.asdf", "Level 2")

        assert_equal "Level 1", GrandparentTable.t("asdf")
        assert_equal "Level 2", ParentTable.t("asdf")
        assert_equal "Level 2", ChildTable.t("asdf")
      end

      test "t from base class" do
        mock_translation("rapid_ui.support.i18n_test.grandparent_table.asdf", "Level 1")

        assert_equal "Level 1", GrandparentTable.t("asdf")
        assert_equal "Level 1", ParentTable.t("asdf")
        assert_equal "Level 1", ChildTable.t("asdf")

        assert_equal "Level 1", GrandparentTable.new.t("asdf")
        assert_equal "Level 1", ParentTable.new.t("asdf")
        assert_equal "Level 1", ChildTable.new.t("asdf")
      end

      test "non-existent translation" do
        assert_nil GrandparentTable.t("non_existent")
        assert_nil ParentTable.t("non_existent")
        assert_nil ChildTable.t("non_existent")

        assert_nil GrandparentTable.new.t("non_existent")
        assert_nil ParentTable.new.t("non_existent")
        assert_nil ChildTable.new.t("non_existent")
      end
    end
  end
end
