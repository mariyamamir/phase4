require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  should have_many(:shift_jobs)
  should have_many(:jobs).through(:shift_jobs)
  should belong_to(:assignment)
  should have_one(:store).through(:assignment)
  should have_one(:employee).through(:assignment)

  should validate_presence_of(:date)
  should validate_presence_of(:start_time)
  should validate_presence_of(:assignment_id)
  
  context "Creating context for shift" do
  	setup do
  	  create_employees
  	  create_stores
  	  create_assignments
      create_shifts
    end
    
    teardown do
      remove_shifts
      remove_assignments
      remove_stores
      remove_employees
    end
    
    should "end_time cannot be less than start_time" do
      @wrong_shift = FactoryBot.build(:shift)
      @wrong_shift.end_time = @wrong_shift.start_time - 5.hours
      assert !@wrong_shift.valid?
    end

    should "date is not in the past" do
      @wrong_shift = FactoryBot.build(:shift, date: Date.today - 5.days)
      assert !@wrong_shift.valid?
    end

    should "shift cannot be added to an inactive assignment" do
      @assignment_inactive = FactoryBot.build(:assignment, employee: @mamir, store: @cmu, end_date: Date.today - 5.days)
      @wrong_shift = FactoryBot.build(:shift, assignment: @assignment_inactive)
      assert !@wrong_shift.valid?
    end
    
    should "past shift cannot be deleted but future shifts can" do
      @past_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Time.now - 30.hours)
      @future_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Time.now + 30.hours)
      @past_shift.destroy
      assert !@past_shift.destroyed?
      @future_shift.destroy
      assert @future_shift.destroyed?
    end
    
    should "Check if End Time automatically set" do
      @test_shift = FactoryBot.create(:shift, assignment: @promote_ben, start_time: Time.now)
      assert_in_delta 1, @test_shift.end_time.to_i, Time.now.to_i + 3.hours.to_i
      @test_shift.destroy
    end
    
    should "check if Completed checker works" do
      @past_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.today - 30.days)
      assert @past_shift.completed?
      @past_shift.destroy
    end

  
    
    should "check if Start Now Method works" do
      @test_shift = FactoryBot.create(:shift, assignment: @promote_ben, start_time: Time.now)
      @test_shift.start_now
      assert_in_delta 1, (Time.now.to_i / 2), @test_shift.start_time.to_i
      @test_shift.destroy
    end

    should "Check if End Now Method works" do
      @test_shift = FactoryBot.create(:shift, assignment: @promote_ben, start_time: Date.current + 2.hours)
      @test_shift.end_now
      assert_in_delta 1, (Time.now.to_i / 2), @test_shift.end_time.to_i
      @test_shift.destroy
    end
    
    should "have a correct scope completed" do
      @past_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.today - 10.days)
      @test_security = FactoryBot.create(:job)
      @shift_past_security = FactoryBot.create(:shift_job, shift: @past_shift, job: @test_security)

      assert_equal [3], Shift.completed.map{|shift| shift.id}
      
      @past_shift.destroy
      @test_security.destroy
      @shift_past_security.destroy
    end
    
    should "have a correct scope incompleted" do
      @past_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.today - 10.days)
      @test_security = FactoryBot.create(:job)
      @shift_past_security = FactoryBot.create(:shift_job, shift: @past_shift, job: @test_security)
      assert_equal [1, 2, 3], Shift.incompleted.map{|shift| shift.id}.sort
    end

    should "have a correct scope for_store" do
      @past_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.today - 10.days)
      @test_security = FactoryBot.create(:job)
      @shift_past_security = FactoryBot.create(:shift_job, shift: @past_shift, job: @test_security)
      assert_equal [1, 2, 3], Shift.for_store(3).map{|shift| shift.id}.sort
    end

    should "have a correct scope for_employee" do
      @past_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.today - 10.days)
      @test_security = FactoryBot.create(:job)
      @shift_past_security = FactoryBot.create(:shift_job, shift: @past_shift, job: @test_security)
      assert_equal [], Shift.for_employee(1).map{|shift| shift.id}.sort
    end
    
    should "have a correct scope for past" do
      @past_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.today - 10.days)
      assert_equal [3], Shift.past.map{|shift| shift.id}.sort
      @past_shift.destroy
    end
    
    should "have a correct scope upcoming" do
      assert_equal [1,2], Shift.upcoming.map{|shift| shift.id}.sort
    end
    
    should "have a correct scope for_next_days" do
      assert_equal [], Shift.for_next_days(3).map{|shift| shift.id}.sort
      assert_equal [2], Shift.for_next_days(6).map{|shift| shift.id}.sort
    end
    
    should "have a correct scope for_past_days" do
      @past_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.today - 10.days)
      assert_equal [], Shift.for_past_days(6).map{|shift| shift.id}.sort
      @past_shift.destroy
    end
    
    should "have a correct scope chronological " do
      @past_shift = FactoryBot.create(:shift, assignment: @promote_ben, date: Date.today - 10.days)
      assert_equal [3, 2, 1], Shift.chronological.map{|shift| shift.id}
      @past_shift.destroy
    end
    
    should "have a correct scope by_store" do
      @store = FactoryBot.create(:store, name: "store", phone: "111-222-3333")
      @mamir = FactoryBot.create(:employee, first_name: "mamir", last_name: "amir", ssn: "111-11-1111", date_of_birth: 20.years.ago.to_date)
      @assignment = FactoryBot.create(:assignment, store: @store, employee: @mamir, start_date: 5.months.ago.to_date, end_date: nil)
      @past_shift = FactoryBot.create(:shift, assignment: @assignment, date: Date.today - 10.days)
      assert_equal [1, 2, 3], Shift.by_store.map{|shift| shift.id}
      @past_shift.destroy      
      @assignment.destroy
      @store.destroy
      @mamir.destroy
    end
    
    should "have a correct scope by_employee" do
      @store = FactoryBot.create(:store, name: "store", phone: "111-222-3333")
      @mamir = FactoryBot.create(:employee, first_name: "mamir", last_name: "amir", ssn: "111-11-1111", date_of_birth: 20.years.ago.to_date)
      @assignment = FactoryBot.create(:assignment, store: @store, employee: @mamir, start_date: 4.months.ago.to_date, end_date: nil)
      @past_shift = FactoryBot.create(:shift, assignment: @assignment, date: Date.today - 100.days)
      assert_equal [1, 2, 3], Shift.by_employee.map{|shift| shift.id}
      @past_shift.destroy      
      @assignment.destroy
      @store.destroy
      @mamir.destroy
    end
    
    should "not allow past assignments to have shifts added to them" do
      @store = FactoryBot.create(:store, name: "store", phone: "111-222-3333")
      @mamir = FactoryBot.create(:employee, first_name: "mamir", last_name: "amir", ssn: "111-11-1111", date_of_birth: 20.years.ago.to_date)
      @assignment = FactoryBot.create(:assignment, store: @store, employee: @mamir, start_date: 4.months.ago.to_date, end_date: 2.months.ago.to_date)
      assert_raise(Exception) {FactoryBot.create(:shift, assignment: @assignment, date: Date.today - 100.days)}
      @assignment.destroy
      @store.destroy
      @mamir.destroy
    end
  end
end
  