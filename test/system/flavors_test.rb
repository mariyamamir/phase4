require "application_system_test_case"

class FlavorsTest < ApplicationSystemTestCase
  setup do
    @flavor = flavors(:one)
  end

  test "visiting the index" do
    visit flavors_url
    assert_selector "h1", text: "Flavors"
  end

  test "creating a Flavor" do
    visit flavors_url
    click_on "New Flavor"

    check "Active" if @flavor.active
    fill_in "Name", with: @flavor.name
    click_on "Create Flavor"

    assert_text "Flavor was successfully created"
    click_on "Back"
  end

  test "updating a Flavor" do
    visit flavors_url
    click_on "Edit", match: :first

    check "Active" if @flavor.active
    fill_in "Name", with: @flavor.name
    click_on "Update Flavor"

    assert_text "Flavor was successfully updated"
    click_on "Back"
  end

  test "destroying a Flavor" do
    visit flavors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Flavor was successfully destroyed"
  end
end
