require 'test_helper'

class JobTest < ActiveSupport::TestCase
      # Test relationships
  should have_many(:shift_jobs)
  should have_many(:shifts).through(:shift_jobs)

  should validate_presence_of(:name)

  context "Creating a context for jobs" do
    # create the objects I want with factories
    setup do 
      create_jobs
    end
  
      # and provide a teardown method as well
    teardown do
      remove_jobs
    end
    
    should "Show that there is one active job" do
      assert_equal 1, Job.active.size
      assert_equal ["Security"], Job.active.map{|job| job.name}
    end
    
    should "Show that there is one inactive job" do
      assert_equal 1, Job.inactive.size
      assert_equal ["Chef"], Job.inactive.map{|job| job.name}
    end

    should "List the positions in alphabetical order" do
      assert_equal 2, Job.alphabetical.size
      assert_equal ["Chef", "Security"], Job.alphabetical.map{|job| job.name}
    end
    
    should "Show that job can only be deleted if the job has never been worked by an employee; otherwise it is made inactive" do
      @dummy_store = FactoryBot.create(:store)
      @mamir = FactoryBot.create(:employee, first_name: "Mariyam", last_name: "Amir", role: "manager", phone: "111-222-3333")
      @assignment_mamir = FactoryBot.create(:assignment, employee: @mamir, store: @dummy_store, start_date: 8.months.ago.to_date, end_date: nil)
      @shift_mamir = FactoryBot.create(:shift, assignment: @assignment_mamir)
      @shift_job_security = FactoryBot.create(:shift_job, job: @security, shift: @shift_mamir)

      @security.destroy
      assert_equal 2, Job.inactive.size
      assert_equal ["Security" , "Chef"], Job.inactive.map{|job| job.name}
      
      @shift_job_security.destroy
      @shift_mamir.destroy
      @assignment_mamir.destroy
      @mamir.destroy
      @dummy_store.destroy
    end
    
  end
end
