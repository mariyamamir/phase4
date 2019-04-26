# require needed files

require './test/sets/store_contexts'
require './test/sets/employee_contexts'
require './test/sets/assignment_contexts'
require './test/sets/flavor_contexts'
require './test/sets/job_contexts'
require './test/sets/shift_contexts'
require './test/sets/user_contexts'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::StoreContexts
  include Contexts::EmployeeContexts
  include Contexts::AssignmentContexts
  include Contexts::FlavorContexts
  include Contexts::JobContexts
  include Contexts::ShiftContexts
  include Contexts::UserContexts
  
 def create_contexts
    create_employees
    create_stores
    create_assignments
    
 end
  
  def destroy_contexts
    destroy_employees
    destroy_stores
    destroy_assignments
    
  end
  

end