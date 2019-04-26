require "application_system_test_case"

class StoreFlavorsTest < ApplicationSystemTestCase
  setup do
    @store_flavor = store_flavors(:one)
  end

  test "visiting the index" do
    visit store_flavors_url
    assert_selector "h1", text: "Store Flavors"
  end

  test "creating a Store flavor" do
    visit store_flavors_url
    click_on "New Store Flavor"

    fill_in "Flavor", with: @store_flavor.flavor_id
    fill_in "Store", with: @store_flavor.store_id
    click_on "Create Store flavor"

    assert_text "Store flavor was successfully created"
    click_on "Back"
  end

  test "updating a Store flavor" do
    visit store_flavors_url
    click_on "Edit", match: :first

    fill_in "Flavor", with: @store_flavor.flavor_id
    fill_in "Store", with: @store_flavor.store_id
    click_on "Update Store flavor"

    assert_text "Store flavor was successfully updated"
    click_on "Back"
  end

  test "destroying a Store flavor" do
    visit store_flavors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Store flavor was successfully destroyed"
  end
end
