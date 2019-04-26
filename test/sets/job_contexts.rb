module Contexts
  module JobContexts
      
    def create_jobs
      @security = FactoryBot.create(:job)
  	  @chef = FactoryBot.create(:job, name: "Chef", description: "Makes the icecream", active: false)
    end

  	def remove_jobs
  	  @security.destroy
  	  @chef.destroy
  	end
  
  end
end