require "test_helper"

class SearchTest < ActionDispatch::SystemTestCase
  driven_by :cuprite_desktop

  setup do
    visit "/"
  end

  test "search results are shown after typing in a query" do
    fill_in "Search", with: "Dropdown"
    within_search_dropdown do
      assert_text "Dropdown menus and selects"
    end
  end

  test "empty search results are shown when no results are found" do
    fill_in "Search", with: "No results"
    assert_text "No results found"
  end

  test "closing search results with escape key" do
    focus_on_search_input # escape only works when the search input is focused

    fill_in "Search", with: "Dropdown"
    within_search_dropdown do
      assert_text "Dropdown"
      send_keys [ :escape ]
      assert_no_text "Dropdown menus and selects"
    end
  end

  test "closing search results by clicking outside" do
    fill_in "Search", with: "Dropdown"
    within_search_dropdown do
      assert_text "Dropdown menus and selects"
      click_outside
      assert_no_text "Dropdown menus and selects"
    end
  end

  test "closing search results by clicking the close button" do
    fill_in "Search", with: "Dropdown"
    within_search_dropdown do
      assert_text "Dropdown menus and selects"
    end

    click_on "Close search results"
    assert_no_text "Dropdown menus and selects"
  end

  test "search input is focused when pressing Option+S" do
    focus_selector = "input[placeholder='Search']:focus"

    assert_no_selector focus_selector
    send_keys [ :alt, "s" ]
    assert_selector focus_selector
  end

  test "typing enter on a search result navigates to it" do
    fill_in "Search", with: "Dropdown"
    within_search_dropdown do
      assert_text "Dropdown menus and selects"
      assert_selector search_result("/components/controls/dropdowns", highlighted: true)
      send_keys [ :enter ]
      assert_current_path "/components/controls/dropdowns"
    end
  end

  test "up/down arrow keys for navigating through search results" do
    # Stub search results to return exactly two items
    SearchController.stub :static_results, [
      { title: "First Result", url: "/first", description: "Test first" },
      { title: "Second Result", url: "/second", description: "Test second" },
    ] do
      fill_in "Search", with: "test"
      within_search_dropdown do
        assert_text "First Result"
        assert_text "Second Result"

        # first result is highlighted by default
        assert_selector search_result("/first", highlighted: true)
        assert_no_selector search_result("/second", highlighted: true)

        # down selects the second result
        send_keys [ :down ]
        assert_no_selector search_result("/first", highlighted: true)
        assert_selector search_result("/second", highlighted: true)

        # up selects the first result again
        send_keys [ :up ]
        assert_selector search_result("/first", highlighted: true)
        assert_no_selector search_result("/second", highlighted: true)

        # up again loops around to the last result
        send_keys [ :up ]
        assert_no_selector search_result("/first", highlighted: true)
        assert_selector search_result("/second", highlighted: true)

        # down again loops around to the first result
        send_keys [ :down ]
        assert_selector search_result("/first", highlighted: true)
        assert_no_selector search_result("/second", highlighted: true)
      end
    end
  end

  test "shortcut hint is shown until a search query is entered" do
    assert_selector ".search-shortcut-hint"
    fill_in "Search", with: "Dropdown"
    assert_no_selector ".search-shortcut-hint"
  end

  private

  def focus_on_search_input
    send_keys [ :alt, "s" ]
  end

  def click_outside
    page.execute_script("document.body.click()")
  end

  def search_result(path, highlighted: false)
    selector = "a[href='#{path}']"
    selector += ".search-result-highlighted" if highlighted
    selector
  end

  def within_search_dropdown
    within ".search-dropdown" do
      yield
    end
  end

  class MobileTest < ActionDispatch::SystemTestCase
    driven_by :cuprite_mobile

    setup do
      visit "/"
    end

    test "search and clear" do
      assert_no_field "Search"
      click_on "Search"
      fill_in "Search", with: "Dropdown"
      within_search_dropdown do
        assert_text "Dropdown menus and selects"
      end

      click_on "Clear search results"

      within_search_dropdown do
        assert_no_text "Dropdown menus and selects"
      end
      assert_field "Search", with: ""
    end

    test "closing search results" do
      assert_no_field "Search"
      click_on "Search"
      assert_field "Search"
      click_on "Cancel"
      assert_no_field "Search"
    end

    def within_search_dropdown
      within ".search-dropdown" do
        yield
      end
    end
  end
end
