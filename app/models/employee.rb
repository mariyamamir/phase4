    class Employee < ApplicationRecord
     # Callbacks
      before_save :reformat_phone
      before_validation :reformat_ssn
      
      # Relationships
      has_many :assignments
      has_many :stores, through: :assignments
      has_many :shifts, through: :assignments
      has_one :user, dependent: :destroy
      accepts_nested_attributes_for :user
      
      # Validations
      validates_presence_of :first_name, :last_name, :date_of_birth, :ssn, :role
      validates_date :date_of_birth, on_or_before: lambda { 14.years.ago }, on_or_before_message: "must be at least 14 years old"
      
      #TAKEN FROM STACKOVERFLOW
      validates_format_of :phone, with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes only", allow_blank: true
      
      #TAKEN FROM STACKOVERFLOW
      validates_format_of :ssn, with: /\A\d{3}[- ]?\d{2}[- ]?\d{4}\z/, message: "should be 9 digits and delimited with dashes only"
      validates_inclusion_of :role, in: %w[admin manager employee], message: "is not an option"
      validates_uniqueness_of :ssn
      
      # Scopes
      scope :younger_than_18, -> { where('date_of_birth > ?', 18.years.ago.to_date) }
      scope :is_18_or_older,  -> { where('date_of_birth <= ?', 18.years.ago.to_date) }
      scope :active,          -> { where(active: true) }
      scope :inactive,        -> { where(active: false) }
      scope :regulars,        -> { where(role: 'employee') }
      scope :managers,        -> { where(role: 'manager') }
      scope :admins,          -> { where(role: 'admin') }
      scope :alphabetical,    -> { order('last_name, first_name') }
      
      
      def name
        "#{last_name}, #{first_name}"
      end
      
      def proper_name
        "#{first_name} #{last_name}"
      end
      
      def current_assignment
        curr_assignment = self.assignments.select{|a| a.end_date.nil?}
        return nil if curr_assignment.empty?
        curr_assignment.first   
      end
      
      def over_18?
        date_of_birth < 18.years.ago.to_date
      end
      
      def age
        (Time.now.to_s(:number).to_i - date_of_birth.to_time.to_s(:number).to_i)/10e9.to_i
      end
      
      
      ROLES_LIST = [['Employee', 'employee'],['Manager', 'manager'],['Administrator', 'admin']]
      
      before_destroy :destroy_status
      after_rollback :make_inactive, :assign_terminate, :delete_unworked_shifts
      
      def destroy_status
        if worked_shift?
          self.errors.add(:base, 'Cannot Delete')
          throw(:abort)
        else
          self.assign_delete
        end
      end 
      
      def worked_shift?
        shifts = Shift.for_employee(self.id)
        shifts.to_a.size > 0
      end
      
       def reformat_phone
         phone = self.phone.to_s  
         phone.gsub!(/[^0-9]/,"") 
         self.phone = phone       
       end
       
       def reformat_ssn
         ssn = self.ssn.to_s      
         ssn.gsub!(/[^0-9]/,"")  
         self.ssn = ssn          
       end
       
       def make_inactive 
        self.update_attribute(:active, false)
       end
       
       def assign_terminate
        assignment = self.assignments.current.first
        if !assignment.nil?
          assignment.update_attribute(:end_date, Date.today)
        end
       end
       
       def assign_delete
        assignment = self.assignments.current.first
        if !assignment.nil?
          self.assignments.current.first.delete
        end
       end
       
       def delete_unworked_shifts
        Shift.for_employee(self.id).upcoming.each do |shift|
            shift.delete
        end
       end
    end
       
    
    