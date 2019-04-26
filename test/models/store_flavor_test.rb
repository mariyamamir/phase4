require 'test_helper'

class StoreFlavorTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:flavor)
  should belong_to(:store)
  
  # test validations 
  should validate_presence_of :store_id 
  should validate_presence_of :flavor_id
  
end
