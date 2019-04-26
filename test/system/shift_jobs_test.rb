require "application_system_test_case"

class ShiftJobsTest < ApplicationSystemTestCase
  setup do
    @shift_job = shift_jobs(:one)
  end

  test "visiting the index" do
    visit shift_jobs_url
    assert_selector "h1", text: "Shift Jobs"
  end

  test "creating a Shift job" do
    visit shift_jobs_url
    click_on "New Shift Job"

    fill_in "Job", with: @shift_job.job_id
    fill_in "Shift", with: @shift_job.shift_id
    click_on "Create Shift job"

    assert_text "Shift job was successfully created"
    click_on "Back"
  end

  test "updating a Shift job" do
    visit shift_jobs_url
    click_on "Edit", match: :first

    fill_in "Job", with: @shift_job.job_id
    fill_in "Shift", with: @shift_job.shift_id
    click_on "Update Shift job"

    assert_text "Shift job was successfully updated"
    click_on "Back"
  end

  test "destroying a Shift job" do
    visit shift_jobs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shift job was successfully destroyed"
  end
end
