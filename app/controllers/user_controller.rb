class UserController < ApplicationController
  def show
    uuid = params[:id]
    @user = user = User.where(uuid: uuid).first
    if user
      @page_title = @user.first_name+"'s Profile"      
    end
    @profile_tab = "logout"
  end

  def edit
  end

  def likes
  end

  def friends
  end

end
