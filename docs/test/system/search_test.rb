require "test_helper"

class SearchTest < ActionDispatch::SystemTestCase
  driven_by :cuprite

  setup do
    visit "/"
  end

  test "search results are shown after typing in a query" do
    fill_in "Search", with: "Dashboard"
    assert_text "Dashboard Overview"
  end

  test "empty search results are shown when no results are found" do
    fill_in "Search", with: "No results"
    assert_text "No results found"
  end

  test "closing search results with escape key" do
    focus_on_search_input # escape only works when the search input is focused

    fill_in "Search", with: "Dashboard"
    assert_text "Dashboard Overview"
    send_keys [ :escape ]
    assert_no_text "Dashboard Overview"
  end

  test "closing search results by clicking outside" do
    fill_in "Search", with: "Dashboard"
    assert_text "Dashboard Overview"
    click_outside
    assert_no_text "Dashboard Overview"
  end

  test "closing search results by clicking the close button" do
    fill_in "Search", with: "Dashboard"
    assert_text "Dashboard Overview"
    click_on "Close search results"
    assert_no_text "Dashboard Overview"
  end

  test "search input is focused when pressing Option+S" do
    focus_selector = "input[placeholder='Search']:focus"

    assert_no_selector focus_selector
    send_keys [ :alt, "s" ]
    assert_selector focus_selector
  end

  test "typing enter on a search result navigates to it" do
    fill_in "Search", with: "log"
    assert_text "Error Logs"
    assert_selector search_result("logs", highlighted: true)
    send_keys [ :enter ]
    assert_current_path "/search?section=logs"
  end

  test "up/down arrow keys for navigating through search results" do
    fill_in "Search", with: "log"
    assert_text "Error Logs"

    # first result is highlighted by default
    assert_selector search_result("logs", highlighted: true)
    assert_no_selector search_result("audit", highlighted: true)

    # down selects the second result
    send_keys [ :down ]
    assert_no_selector search_result("logs", highlighted: true)
    assert_selector search_result("audit", highlighted: true)

    # up selects the first result again
    send_keys [ :up ]
    assert_selector search_result("logs", highlighted: true)
    assert_no_selector search_result("audit", highlighted: true)

    # up again loops around to the last result
    send_keys [ :up ]
    assert_no_selector search_result("logs", highlighted: true)
    assert_selector search_result("audit", highlighted: true)

    # down again loops around to the first result
    send_keys [ :down ]
    assert_selector search_result("logs", highlighted: true)
    assert_no_selector search_result("audit", highlighted: true)
  end

  test "shortcut hint is shown until a search query is entered" do
    assert_selector ".search-shortcut-hint"
    fill_in "Search", with: "Dashboard"
    assert_no_selector ".search-shortcut-hint"
  end

  private

  def focus_on_search_input
    send_keys [ :alt, "s" ]
  end

  def click_outside
    page.execute_script("document.body.click()")
  end

  def search_result(section, highlighted: false)
    selector = ".search-result-item[data-section='#{section}']"
    selector += ".search-result-highlighted" if highlighted
    selector
  end
end
