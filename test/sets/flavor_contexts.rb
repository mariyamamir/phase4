module Contexts
  module FlavorContexts
      
    def create_flavors
      @oreo = FactoryBot.create(:flavor)
  	  @mango = FactoryBot.create(:flavor, name: "Mango", active: false)
    end

  	def remove_flavors
  	  @oreo.destroy
  	  @mango.destroy
  	end
  
  end
end