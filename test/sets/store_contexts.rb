module Contexts
  module StoreContexts
    # Context for stores 
    def create_stores
      @oakland = FactoryBot.create(:store, name: "Oakland", phone: "412-268-8211")
      @hazelwood = FactoryBot.create(:store, name: "Hazelwood", active: false)
      @cmu = FactoryBot.create(:store)
    end
    
    def remove_stores
      @cmu.destroy
      @hazelwood.destroy
      @oakland.destroy
    end

    def create_additional_stores
      @convention = FactoryBot.create(:store, name: "Convention Center", street: "1000 Fort Duquesne Blvd", zip: "15222", phone: "4122683665")
      @acac = FactoryBot.create(:store, name: "ACAC", street: "250 East Ohio", zip: "15212", phone: "4122683259")
      @bistro = FactoryBot.create(:store, name: "Bistro", street: "325 East Ohio", zip: "15212", phone: "4122683265", active: true)     
    end

    def remove_additional_stores
      @convention.destroy
      @acac.destroy
      @bistro.destroy
    end
  end
end