require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # RELATIONSHIPS
   should belong_to(:employee)
   should belong_to(:store)

  # VALIDATIONS
  should allow_value(1).for(:pay_level)
  should allow_value(2).for(:pay_level)
  should allow_value(3).for(:pay_level)
  should allow_value(4).for(:pay_level)
  should allow_value(5).for(:pay_level)
  should allow_value(6).for(:pay_level)
  should_not allow_value("bad").for(:pay_level)
  should_not allow_value(0).for(:pay_level)
  should_not allow_value(7).for(:pay_level)
  should_not allow_value(2.5).for(:pay_level)
  should_not allow_value(-2).for(:pay_level)
  
  should allow_value(7.weeks.ago.to_date).for(:start_date)
  should allow_value(2.years.ago.to_date).for(:start_date)
  should_not allow_value(1.week.from_now.to_date).for(:start_date)
  should_not allow_value("bad").for(:start_date)
  should_not allow_value(nil).for(:start_date)

  
  context "Creating a context for assignments" do
    setup do
      create_stores
      create_employees
      create_assignments
    end

    teardown do
      remove_stores
      remove_employees
      remove_assignments
    end

    should "have a scope 'for_store' that works" do
      assert_equal 4, Assignment.for_store(@cmu.id).size
      assert_equal 1, Assignment.for_store(@oakland.id).size
    end

    should "have a scope 'for_employee' that works" do
      assert_equal 2, Assignment.for_employee(@ben.id).size
      assert_equal 1, Assignment.for_employee(@kathryn.id).size
    end

    should "have a scope 'for_pay_level' that works" do
      assert_equal 2, Assignment.for_pay_level(1).size
      assert_equal 0, Assignment.for_pay_level(2).size
      assert_equal 2, Assignment.for_pay_level(3).size
      assert_equal 1, Assignment.for_pay_level(4).size
    end

    should "have a scope 'for_role' that works" do
      assert_equal 2, Assignment.for_role("employee").size
      assert_equal 3, Assignment.for_role("manager").size
    end

    should "have all the assignments listed alphabetically by store name" do
      assert_equal ["CMU", "CMU", "CMU", "CMU", "Oakland"], Assignment.by_store.map{|a| a.store.name}
    end

    should "have all the assignments listed chronologically by start date" do
      assert_equal ["Ben", "Kathryn", "Ed", "Cindy", "Ben"], Assignment.chronological.map{|a| a.employee.first_name}
    end

    should "have all the assignments listed alphabetically by employee name" do
      assert_equal ["Crawford", "Gruberman", "Janeway", "Sisko", "Sisko"], Assignment.by_employee.map{|a| a.employee.last_name}
    end

    should "have a scope to find all current assignments for a store or employee" do
      assert_equal 2, Assignment.current.for_store(@cmu.id).size
      assert_equal 1, Assignment.current.for_store(@oakland.id).size
      assert_equal 1, Assignment.current.for_employee(@ben.id).size
      assert_equal 0, Assignment.current.for_employee(@ed.id).size
    end

    should "have a scope to find all past assignments for a store or employee" do
      assert_equal 2, Assignment.past.for_store(@cmu.id).size
      assert_equal 0, Assignment.past.for_store(@oakland.id).size
      assert_equal 1, Assignment.past.for_employee(@ben.id).size
      assert_equal 0, Assignment.past.for_employee(@cindy.id).size
    end

    should "allow for a end date in the past (or today) but after the start date" do
      @assign_alex = FactoryBot.build(:assignment, employee: @alex, store: @oakland, start_date: 3.months.ago.to_date, end_date: 2.month.ago.to_date)
      assert @assign_alex.valid?
      @second_assignment_for_alex = FactoryBot.build(:assignment, employee: @alex, store: @oakland, start_date: 3.weeks.ago.to_date, end_date: Date.current)
      assert @second_assignment_for_alex.valid?
    end

    should "not allow for a end date in the future or before the start date" do
      @second_assignment_for_ed = FactoryBot.build(:assignment, employee: @ed, store: @oakland, start_date: 3.weeks.ago.to_date, end_date: 3.weeks.ago.to_date)
      assert_not_equal true,@second_assignment_for_ed.valid?
      @third_assignment_for_ed = FactoryBot.build(:assignment, employee: @ed, store: @oakland, start_date: 3.weeks.ago.to_date, end_date: 3.weeks.from_now.to_date)
      assert_equal false, @third_assignment_for_ed.valid?
    end

    should "terminate an assignment instead of destroying it if shifts have been worked" do
      @assignment = FactoryBot.create(:assignment, employee: @mamir, store: @cmu, start_date: Date.current, end_date: nil, pay_level: 6)
      @shift = FactoryBot.create(:shift, assignment: @assignment, date: Date.yesterday - 10.days)
      @assignment.destroy
      assert !@assignment.destroyed?
      assert_equal 1, Assignment.past.for_employee(@mamir.id).size
      @shift.destroy
      @assignment.destroy
    end
    
    should "identify a non-active store as part of an invalid assignment" do
      inactive_store = FactoryBot.build(:assignment, store: @hazelwood, employee: @ed, start_date: 1.day.ago.to_date, end_date: nil)
      assert_equal false,inactive_store.valid?
    end

    should "identify a non-active employee as part of an invalid assignment" do
      @max = FactoryBot.build(:employee, first_name: "Max", active: false)
      inactive_employee = FactoryBot.build(:assignment, store: @oakland, employee: @max, start_date: 1.day.ago.to_date, end_date: nil)
      assert_equal false,inactive_employee.valid?
    end

    should "end the current assignment if it exists before adding a new assignment for an employee" do
      @promote_kathryn = FactoryBot.create(:assignment, employee: @kathryn, store: @oakland, start_date: 1.day.ago.to_date, end_date: nil, pay_level: 4)
      assert_equal 1.day.ago.to_date, @kathryn.assignments.first.end_date
      @promote_kathryn.destroy
    end
    
    should "end upcoming shifts when assignment is terminated" do
      @assignment = FactoryBot.create(:assignment, employee: @mamir, store: @cmu, start_date: Date.current, end_date: nil, pay_level: 6)
      @shift = FactoryBot.create(:shift, assignment: @assignment, date: Date.tomorrow)
      @assignment.destroy
      assert_equal false, Shift.exists?(@shift.id)
      @shift.destroy 
    end
    
    should "get the correct name for an assignment" do
      assert_equal "Ed Gruberman, CMU", @assign_ed.assignment_name
    end
  end
end
