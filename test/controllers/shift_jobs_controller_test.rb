require 'test_helper'

class ShiftJobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shift_job = shift_jobs(:one)
  end

  test "should get index" do
    get shift_jobs_url
    assert_response :success
  end

  test "should get new" do
    get new_shift_job_url
    assert_response :success
  end

  test "should create shift_job" do
    assert_difference('ShiftJob.count') do
      post shift_jobs_url, params: { shift_job: { job_id: @shift_job.job_id, shift_id: @shift_job.shift_id } }
    end

    assert_redirected_to shift_job_url(ShiftJob.last)
  end

  test "should show shift_job" do
    get shift_job_url(@shift_job)
    assert_response :success
  end

  test "should get edit" do
    get edit_shift_job_url(@shift_job)
    assert_response :success
  end

  test "should update shift_job" do
    patch shift_job_url(@shift_job), params: { shift_job: { job_id: @shift_job.job_id, shift_id: @shift_job.shift_id } }
    assert_redirected_to shift_job_url(@shift_job)
  end

  test "should destroy shift_job" do
    assert_difference('ShiftJob.count', -1) do
      delete shift_job_url(@shift_job)
    end

    assert_redirected_to shift_jobs_url
  end
end
