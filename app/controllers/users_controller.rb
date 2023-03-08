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
    @expertise = @user.expertise_list
    @languages = @user.language_list
    @matches = matching_algo
  end

  def matching_algo
    # S'assurer que user1 et user2 n'ont pas tous les deux un projet & que les matches ne comprennent pas son propre profil
    if current_user.has_a_project
      @matches = User.where(has_a_project: false).where.not(id: current_user.id)
    else
      @matches = User.where.not(id: current_user.id)
    end

    # Years of experience cumulées sur tous les jobs >= 10
    @matches.select do |match|
      current_user.total_experience + match.total_experience > 3 # changer après push
    end

    # Match complémentaire sur l'expertise ["Management", "Technical", "Marketing", "Computer"]
    if current_user.expertise_list.include?("Management") || current_user.expertise_list.include?("Marketing")
      @matches.select do |match|
        match.expertise_list.include?("Technical" || "Computer")
      end
    else
      @matches.select do |match|
        match.expertise_list.include?("Management" || "Marketing")
      end
    end
    raise
    return @matches

    # Expertises complémentaires

  end

  def toggle_favorite
    @user = User.find(params[:id])
    current_user.favorited?(@user, scopes: [:favorite]) ? current_user.unfavorite(@user, scopes: [:favorite]) : current_user.favorite(@user, scopes: [:favorite])
    # It checks if a user has liked it. If it’s been favourited before, it is now unfavorited and vice versa.
  end

  private

  def user_params
    params.require(:user).permit(:hobby_list, :personality_list, :value_list, :soft_skill_list, :hard_skill_list, :language_list)
  end

end
