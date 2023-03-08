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
    @hobbies = @user.hobby_list
    @values = @user.value_list
    @personalities = @user.personality_list
    @soft_skills = @user.soft_skill_list
    @hard_skills = @user.hard_skill_list
    @languages = @user.language_list
  end

  def toggle_favorite
    @user = User.find(params[:id])
    current_user.favorited?(@user, scopes: [:favorite]) ? current_user.unfavorite(@user, scopes: [:favorite]) : current_user.favorite(@user, scopes: [:favorite])
    # It checks if a user has liked it. If it’s been favourited before, it is now unfavorited and vice versa.
  end

  private

  def user_params
    params.require(:user).permit(:fist_name, :last_name, :hobby_list, :personality_list, :value_list, :soft_skill_list, :hard_skill_list, :language_list)
  end
end
