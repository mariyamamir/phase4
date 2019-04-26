module Contexts
  module EmployeeContexts
    # Context for employees 
    def create_employees
      @ed = FactoryBot.create(:employee, first_name: "Ed")
      @cindy = FactoryBot.create(:employee, first_name: "Cindy", last_name: "Crawford", ssn: "084-35-9822", date_of_birth: 17.years.ago.to_date)
      @ralph = FactoryBot.create(:employee, first_name: "Ralph", last_name: "Wilson", active: false, date_of_birth: 16.years.ago.to_date)
      @ben = FactoryBot.create(:employee, first_name: "Ben", last_name: "Sisko", role: "manager", phone: "412-268-2323")
      @kathryn = FactoryBot.create(:employee, first_name: "Kathryn", last_name: "Janeway", role: "manager", date_of_birth: 30.years.ago.to_date)
      @alex = FactoryBot.create(:employee, first_name: "Alex", last_name: "Heimann", role: "admin")
      @mamir = FactoryBot.create(:employee, first_name: "Mariyam", last_name: "Amir", role: "manager")
    end
    
    def remove_employees
      @ed.destroy
      @cindy.destroy
      @ralph.destroy
      @ben.destroy
      @kathryn.destroy
      @alex.destroy
      @mamir.destroy
    end

    # def create_additional_employees
    #   @liu = FactoryBot.create(:employee, first_name: "Angela", last_name: "Liu", date_of_birth: 245.months.ago.to_date, role: "manager")
    #   @wilson = FactoryBot.create(:employee, first_name: "Allie", last_name: "Wilson", date_of_birth: 234.months.ago.to_date, role: "manager")
    #   @correa = FactoryBot.create(:employee, first_name: "Jake", last_name: "Correa", date_of_birth: 240.months.ago.to_date, role: "manager")
    #   @hersh = FactoryBot.create(:employee, first_name: "Jon", last_name: "Hersh", ssn: "234567890", phone: "4122683259", date_of_birth: 27.years.ago.to_date)
    #   @rubinstein = FactoryBot.create(:employee, first_name: "Ari", last_name: "Rubinstein", ssn: "234567891", phone: "4122683258", date_of_birth: 25.years.ago.to_date)
    #   @brunk = FactoryBot.create(:employee, first_name: "Stafford", last_name: "Brunk", ssn: "234567892", phone: "4122683257", date_of_birth: 23.years.ago.to_date)
    #   @porter = FactoryBot.create(:employee, first_name: "David", last_name: "Porter", ssn: "345678901", phone: "7243694550", date_of_birth: 209.months.ago.to_date)
    #   @holt = FactoryBot.create(:employee, first_name: "Peter", last_name: "Holt", ssn: "456789012", phone: "4122683692", date_of_birth: 219.months.ago.to_date)
    #   @schell = FactoryBot.create(:employee, first_name: "Evan", last_name: "Schell", ssn: "567890123", phone: "4122684209", date_of_birth: "1992-03-15")
    #   @miller = FactoryBot.create(:employee, first_name: "Stephen", last_name: "Miller", ssn: "678901234", phone: "4122685502", date_of_birth: 22.years.ago.to_date)
    #   @davis = FactoryBot.create(:employee, first_name: "Jeremy", last_name: "Davis", ssn: "789012345", phone: "7243649946", date_of_birth: 200.months.ago.to_date)
    #   @daigle = FactoryBot.create(:employee, first_name: "Johnny", last_name: "Daigle", ssn: "890123456", phone: "7242372621", date_of_birth: 217.months.ago.to_date)
    #   @olbeter = FactoryBot.create(:employee, first_name: "Amanda", last_name: "Olbeter", ssn: "901234567", phone: "7244234388", date_of_birth: 218.months.ago.to_date)
    #   @wakeley = FactoryBot.create(:employee, first_name: "Heather", last_name: "Wakeley", ssn: "012345678", phone: "7243692531", date_of_birth: 197.months.ago.to_date)
    #   @taylor = FactoryBot.create(:employee, first_name: "Taylor", last_name: "Olbeter", ssn: "098765432", phone: "7244234388", date_of_birth: 196.months.ago.to_date)
    #   @mark = FactoryBot.create(:employee, first_name: "Mark", last_name: "Heimann", ssn: "084-21-3091", date_of_birth: "1993-01-25", phone: "724-713-3333", role: "admin")
    # end

    # def remove_additional_employees
    #   @liu.destroy
    #   @wilson.destroy
    #   @correa.destroy
    #   @hersh.destroy
    #   @rubinstein.destroy
    #   @brunk.destroy
    #   @porter.destroy
    #   @holt.destroy
    #   @schell.destroy
    #   @miller.destroy
    #   @davis.destroy
    #   @daigle.destroy
    #   @olbeter.destroy
    #   @wakeley.destroy 
    #   @taylor.destroy
    #   @mark.destroy
    # end

  end
end