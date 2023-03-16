class UsersController < ApplicationController
  before_action :authenticate_user!, only: :toggle_favorite

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save
  end

  def show
    @user = User.find(params[:id])
    @selection = current_user.selection_for(@user)
    @message = Message.new
  end


  private

  def user_params
    params.require(:user).permit(:fist_name, :last_name, :hobby_list, :personality_list, :value_list, :soft_skill_list,
      :expertise, :language_list, :photo, :has_a_project, :logo)
  end
end
