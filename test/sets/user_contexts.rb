module Contexts
  module UserContexts
    def create_users
   	  @edg = FactoryBot.create(:user, employee: @ed)
    end

    def remove_users
      @edg.destroy
    end

  end
end