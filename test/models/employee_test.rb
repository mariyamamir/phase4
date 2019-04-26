require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  # RELATIONSHIPS
  should have_many(:assignments)
  should have_many(:stores).through(:assignments)
  
  #VALIDATIONS
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:ssn)
  should validate_presence_of(:role)
  should validate_presence_of(:date_of_birth)
  
 
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should allow_value(nil).for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  # tests for ssn
  should allow_value("123456789").for(:ssn)
  should_not allow_value("12345678").for(:ssn)
  should_not allow_value("1234567890").for(:ssn)
  should_not allow_value("bad").for(:ssn)
  should_not allow_value(nil).for(:ssn)
   # test date_of_birth
  should allow_value(17.years.ago.to_date).for(:date_of_birth)
  should allow_value(15.years.ago.to_date).for(:date_of_birth)
  should allow_value(14.years.ago.to_date).for(:date_of_birth)
  should_not allow_value(13.years.ago).for(:date_of_birth)
  should_not allow_value("bad").for(:date_of_birth)
  should_not allow_value(nil).for(:date_of_birth)
   # tests for role
  should allow_value("admin").for(:role)
  should allow_value("manager").for(:role)
  should allow_value("employee").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("vp").for(:role)
  should_not allow_value(nil).for(:role)

  context "Creating a context for employees" do
    # create the objects I want with factories
    setup do 
      create_employees
    end
    
    # and provide a teardown method as well
    teardown do
      remove_employees
    end
    
    # Scope: younger_than_18
    should "show there are two employees under 18" do
      assert_equal 2, Employee.younger_than_18.size
      assert_equal ["Crawford", "Wilson"], Employee.younger_than_18.map{|e| e.last_name}.sort
    end
    
    # Scope: younger_than_18
    should "show there are five employees over 18" do
      assert_equal 11, Employee.is_18_or_older.size
      assert_equal ["Amir", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Heimann", "Janeway", "Sisko"], Employee.is_18_or_older.map{|e| e.last_name}.sort
    end
    
    # Scope: active
    should "shows that there are six active employees" do
      assert_equal 12, Employee.active.size
      assert_equal ["Amir", "Crawford", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Heimann", "Janeway", "Sisko"], Employee.active.map{|e| e.last_name}.sort
    end
    
    # Scope: inactive
    should "shows that there is one inactive employee" do
      assert_equal 1, Employee.inactive.size
      assert_equal ["Wilson"], Employee.inactive.map{|e| e.last_name}.sort
    end
    
    # Employees have unique ssn
    should "force employees to have unique ssn" do
      ssn_dup = FactoryBot.build(:employee, first_name: "James", last_name: "Harvey", ssn: "084-35-9822")
      assert_equal false , ssn_dup.valid? 
    end
    
    # Scope: regulars
    should "shows that there are 3 regular employees: Ed, Cindy and Ralph" do
      assert_equal 9, Employee.regulars.size
      assert_equal ["Crawford", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Gruberman", "Wilson"], Employee.regulars.map{|e| e.last_name}.sort
    end
    
    # Scope: managers
    should "shows that there are 3 managers: Ben and Kathryn" do
      assert_equal 3, Employee.managers.size
      assert_equal ["Amir", "Janeway", "Sisko"], Employee.managers.map{|e| e.last_name}.sort
    end
    
    # Scope: admins
    should "shows that there is one admin: Alex" do
      assert_equal 1, Employee.admins.size
      assert_equal ["Heimann"], Employee.admins.map{|e| e.last_name}.sort
    end
    
    # Method: name
    should "shows name as last, first name" do
      assert_equal "Amir, Mariyam", @mamir.name
    end   
    
    # Method: proper_name
    should "shows proper name as first and last name" do
      assert_equal "Mariyam Amir", @mamir.proper_name
    end 
    
    # Method: current_assignment
    should "shows return employee's current assignment if it exists" do
      create_stores
      create_assignments
      assert_equal @assign_cindy, @cindy.current_assignment
      assert_equal @promote_ben, @ben.current_assignment 
      assert_nil @ed.current_assignment
      @assign_cindy.update_attribute(:end_date, Date.current)
      @cindy.reload
      assert_nil @cindy.current_assignment
      assert_nil @alex.current_assignment
      remove_assignments
      remove_stores
    end
    
    # Method: over_18?
    should "check if  over_18? boolean method works" do
      assert @ed.over_18?
      assert_not_equal @cindy.over_18?, true
    end
    
    # Method: age
    should "check if age method returns the correct value" do
      assert_equal 19, @ed.age
      assert_equal 17, @cindy.age
      assert_equal 30, @kathryn.age
    end
    
    # Callback: reformat_ssn
    should "shows that Cindy's ssn is stripped of non-digits" do
      assert_equal "084359822", @cindy.ssn
    end
    
    # Callback: reformat_phone
    should "shows that Ben's phone is stripped of non-digits" do
      assert_equal "4122682323", @ben.phone
    end
    
    should "check if an employee is only deleted if he has worked no shifts" do
      @dummy_store = FactoryBot.create(:store)
      @mamir2 = FactoryBot.create(:employee, first_name: "Mar", last_name: "Amir", ssn: "134-35-9822", date_of_birth: 20.years.ago.to_date)
      @assignment_mamir = FactoryBot.create(:assignment, employee: @mamir2, store: @dummy_store, start_date: 6.months.ago.to_date, end_date: nil, pay_level: 6)
      @mamir2.destroy
      assert @mamir2.destroyed?
      @dummy_store.destroy
    end
    
    should "check if an employee is not deleted if he has worked shifts" do
      @dummy_store = FactoryBot.create(:store)
      @assignment_mamir = FactoryBot.create(:assignment, employee: @mamir, store: @dummy_store, start_date: 6.months.ago.to_date, end_date: nil, pay_level: 6)
      @shift = FactoryBot.create(:shift, assignment: @assignment_mamir, date: Date.today - 1.days)
      @future_shift = FactoryBot.create(:shift, assignment: @assignment_mamir, date: Date.today + 1.days)
      assert @mamir.worked_shift?
      @mamir.destroy
      assert !@mamir.destroyed?
      @dummy_store.destroy
    end 
  end
end
