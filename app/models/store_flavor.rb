class StoreFlavor < ApplicationRecord
  belongs_to :store
  belongs_to :flavor
  
  validates_presence_of :store_id, :flavor_id
  
end
