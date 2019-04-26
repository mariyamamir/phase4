class DemosController < ApplicationController
    def new
    end
    
    def create
       user = User.find_by(email: params[:demo][:email].downcase) 
       if user && user.authenticate(params[:demo][:password_digest])
           login(user)
           redirect_to user
       else
           flash.now[:danger] = "Invalid email or password"
           render 'new'
       end
    end
    
    def destroy
        logout
        redirect_to root_url
    end
end