class Job < ApplicationRecord
    
    has_many :shift_jobs
    has_many :shifts, through: :shift_jobs
    
    validates_presence_of :name
    
    scope :active,          -> { where(active: true) }
    scope :inactive,        -> { where(active: false) }
    scope :alphabetical,    -> { order('name') }
    
    before_destroy :destroy_status
    after_rollback :make_inactive
    
  def destroy_status
    if self.shift_jobs.size > 0
        self.errors.add(:base, 'CANNOT DELETE: Job has been worked')
        throw(:abort)
    end
  end
    
    def make_inactive
        self.update_attribute(:active, false)
    end
    
end

