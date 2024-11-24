class ProfilesController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: t('.success')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end
