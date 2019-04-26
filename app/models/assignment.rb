class Assignment < ApplicationRecord
# Callbacks
  before_create :end_previous_assignment
  after_rollback :assign_terminate, :delete_unworked_shifts
  before_destroy :destroy_status
  
  # Relationships
  belongs_to :employee
  belongs_to :store
  has_many :shifts
  
  # Validations
  validates_numericality_of :pay_level, only_integer: true, greater_than: 0, less_than: 7
  validates_date :start_date, on_or_before: lambda { Date.current }, on_or_before_message: "cannot be in the future"
  validates_date :end_date, after: :start_date, on_or_before: lambda { Date.current }, allow_blank: true
  validate :employee_is_active_in_system, on: :create
  validate :store_is_active_in_system, on: :create
  validates_presence_of :employee_id, on: :update
  validates_presence_of :store_id, on: :update
  
  # Scopes
  scope :current,       -> { where(end_date: nil) }
  scope :past,          -> { where.not(end_date: nil) }
  scope :by_store,      -> { joins(:store).order('name') }
  scope :by_employee,   -> { joins(:employee).order('last_name, first_name') }
  scope :chronological, -> { order('start_date DESC, end_date DESC') }
  scope :for_store,     ->(store_id) { where("store_id = ?", store_id) }
  scope :for_employee,  ->(employee_id) { where("employee_id = ?", employee_id) }
  scope :for_pay_level, ->(pay_level) { where("pay_level = ?", pay_level) }
  scope :for_role,      ->(role) { joins(:employee).where("role = ?", role) }



  def assignment_name
    self.employee.first_name + " " + self.employee.last_name + ", " + self.store.name
  end
  
  
  # Private methods for callbacks and custom validations
  private
  
  def end_previous_assignment
    current_assignment = Employee.find(self.employee_id).current_assignment
    if !current_assignment.nil?
      current_assignment.update_attribute(:end_date, self.start_date.to_date)
    end
  end
  
  def employee_is_active_in_system
    all_active_employees = Employee.active.all.map{|e| e.id}
    unless all_active_employees.include?(self.employee_id)
      errors.add(:employee_id, "Not Active Employee")
    end
  end
  
  def store_is_active_in_system
    all_active_stores = Store.active.all.map{|s| s.id}
    unless all_active_stores.include?(self.store_id)
      errors.add(:store_id, "Not Active Store")
    end
  end
  
  def destroy_status
    shifts = self.shifts.past
    if !shifts.nil?
      #cannot destroy 
      self.errors.add(:base, 'Cannot Destroy: Shift Worked')
      throw(:abort)
    end
  end
  
  def delete_unworked_shifts
    self.shifts.upcoming.each do |shift|
      shift.destroy
    end
  end
  
  def assign_terminate
    self.update_attribute(:end_date, Date.today)
  end
  
  
end


