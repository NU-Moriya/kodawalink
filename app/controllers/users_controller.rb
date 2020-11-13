class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    @commitments = @user.commitments
  end
  
  def index
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end
  
  #退会手続き用画面を表示
  def quit
    @user = current_user
  end
  
  #退会手続き
  def invalid
    @user = current_user
    @user.update(is_valid: false)
    reset_session
    redirect_to root_path
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :account_id, :avatar, :introduction, :classification, :admin, :is_valid)
  end
  
end
