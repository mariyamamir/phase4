require 'test_helper'

class UserTest < ActiveSupport::TestCase
      # Test relationships
  should belong_to(:employee)
  
  #validations
  should allow_value("mariyam@gmail.com").for(:email)
  should allow_value("mamir@andrew.cmu.edu").for(:email)
  should allow_value("tester@hotmail.com").for(:email)
  should_not allow_value("bad").for(:email)
  should_not allow_value(nil).for(:email)
  should_not allow_value("12345").for(:email)
  should_not allow_value("sadawww").for(:email)
  should_not allow_value("com.mamir.@.c").for(:email)
  
  
  #create contexts
  context "user contexts" do
  
    #create factories
    setup do 
      @test = FactoryBot.create(:employee)
      @test_user = FactoryBot.create(:user, email: "asds@gmail.com", employee: @test)
    end
    
    teardown do
      # @test.destroy
    end
    
    should "Show that user is automatically deleted when employee is deleted" do
      @mamir = FactoryBot.create(:employee, first_name: "Mariyam", last_name: "Amir", role: "manager")
      @mamir_user = FactoryBot.create(:user, email: "mariyam@gmail.com", employee: @mamir)
      puts @mamir.id
      @mamir.destroy
      assert @mamir_user.destroyed?
    end

    should "Assure that user can only be added to an active employee" do
      @employee = FactoryBot.build(:employee)
      @user = FactoryBot.build(:user, email:"dummyuserr@qatr.cmu.edu", employee: @employee)
      assert @user.employee_is_active_in_system
      assert @test_user.valid?
      @bad = FactoryBot.build(:user, email:"bad@gmail.com", employee: @inactive)
      assert !@bad.valid?
      @bad.destroy
    end
    

    
    should "make sure user_role function works" do
      @employee = FactoryBot.build(:employee, first_name: "dummy", last_name: "user", ssn: "111-22-3333", phone: "111-222-3333", role: "manager")
      @user = FactoryBot.build(:user, email:"dummy@gmail.com", employee: @employee) 
      assert_equal "manager", @user.user_role
      @user.destroy
      @employee.destroy
    end
  end
end
