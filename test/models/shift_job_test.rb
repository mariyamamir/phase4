require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:shift)
  should belong_to(:job)
  
  # test validations 
  should validate_presence_of :shift_id 
  should validate_presence_of :job_id
end
