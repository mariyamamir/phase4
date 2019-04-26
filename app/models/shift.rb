class Shift < ApplicationRecord
  before_create :current_assignment_only 
  after_create :end_time_change 
  before_destroy :check_destroy_status
    
  belongs_to :assignment
  has_one :employee, through: :assignment
  has_one :store, through: :assignment
  has_many :shift_jobs
  has_many :jobs, through: :shift_jobs
  
  validates_presence_of :date, :start_time, :assignment_id
  
  scope :completed,     -> { joins(:shift_jobs) }
  scope :incompleted,   -> { joins("LEFT JOIN shift_jobs ON shift_id")}
  scope :for_store,     -> (store_id) { joins(:assignment).where("store_id = ?", store_id) }
  scope :for_employee,  -> (employee_id) { joins(:assignment).where("employee_id = ?", employee_id) }
  scope :past,          -> { where("date < ?", Date.current) }
  scope :upcoming,      -> { where("date >= ?", Date.current) }
  scope :for_next_days, -> (next_days) { where("date between ? and ?", Date.current, Date.current + next_days) }
  scope :for_past_days, -> (past_days) { where("date between ? and ?", Date.current - past_days, Date.current - 1) }
  scope :by_store,      -> { joins(:store).order("stores.name") }
  scope :by_employee,   -> { joins(:employee).order("employees.last_name, employees.first_name") }
  scope :chronological, -> { order('date ASC') }
  
  
  
  def completed?
      !self.shift_jobs.nil?
  end
  
  def start_now
  	self.update_attribute(:start_time, Time.now)
  end
  
  def end_now
    self.update_attribute(:end_time, Time.now)
  end
  
  def current_assignment_only
    assignments = Assignment.current.map{|assignment| assignment.id}
    if !assignments.include?(self.assignment_id)
      self.errors.add(:base, 'CANNOT ADD:  assignment is in the past')
      throw(:abort)
    end
  end
  
  def check_destroy_status
    if !(self.date >= Date.current)
      self.errors.add(:base, 'cannot delete a past shift')
      throw(:abort)
    end
  end
  
  def end_time_change 
    self.update_attribute(:end_time, self.start_time + 3.hours)
  end
  
end
