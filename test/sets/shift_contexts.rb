module Contexts
  module ShiftContexts
      
    def create_shifts
      @shift1 = FactoryBot.create(:shift, assignment: @assign_cindy)
  	  @shift2 = FactoryBot.create(:shift, assignment: @assign_cindy, date: Date.current + 5, start_time: Date.current + 3.hours)
    end

  	def remove_shifts
  	  @shift1.destroy
  	  @shift2.destroy
  	end
  
  end
end