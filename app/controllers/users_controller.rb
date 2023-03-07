class UsersController < ApplicationController
  @hobbies = @user.hobby_list
  @values = @user.value_list
  @personalities = @user.personality_list
  @soft_skills = @user.soft_skill_list
  @hard_skills = @user.hard_skill_list
  @languages = @user.language_list

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:hobby_list, :personality_list, :value_list, :soft_skill_list, :hard_skill_list, :language_list)
  end
end
