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
    matching_algo
  end

  def matching_algo
    # S'assurer que user1 et user2 n'ont pas tous les deux un projet & que les matches ne comprennent pas son propre profil
    if current_user.has_a_project
      @matches = User.where(has_a_project: false).where.not(id: current_user.id)
    else
      @matches = User.where.not(id: current_user.id)
    end

    # Years of experience cumulées sur tous les jobs >= 10
    @matches = @matches.select do |match|
      current_user.total_experience + match.total_experience > 3 # changer après push
    end

    # # Match complémentaire sur l'expertise ["Management", "Technical", "Marketing", "Computer"]
    if current_user.expertise_list.include?("Management") || current_user.expertise_list.include?("Marketing")
      @matches = @matches.select do |match|
        match.expertise_list.include?("Technical") || match.expertise_list.include?("Computer")
      end
    else
      @matches = @matches.select do |match|
        match.expertise_list.include?("Management") || match.expertise_list.include?("Marketing")
      end
    end

    # # Match sur 1 langue en commun
    @matches = @matches.select do |match|
      match.language_list.include?(current_user.language_list[0]) || match.language_list.include?(current_user.language_list[1])
    end

    # # @mbti_profiles = ["Analyst", "Diplomat", "Sentinel", "Explorer"]
    # # analyst/diplomat #sentinel/explorer #analyst/explorer #sentinel/diplomat

    if current_user.mbti == "Analyst"
      @matches = @matches.select do |match|
        match.mbti == "Diplomat" || match.mbti == "Explorer"
      end
    elsif current_user.mbti == "Diplomat"
      @matches = @matches.select do |match|
        match.mbti == "Analyst" || match.mbti == "Sentinel"
      end
    elsif current_user.mbti == "Sentinel"
      @matches = @matches.select do |match|
        match.mbti == "Explorer" || match.mbti == "Diplomat"
      end
    else
      @matches = @matches.select do |match|
        match.mbti == "Sentinel" || match.mbti == "Analyst"
      end
    end

    # Match on cities (current city)
    @matches = @matches.select do |match|
      match.city == current_user.city
    end

    # Match on Mission
    return @matches
  end

  # User clique sur le coeur de la card du cofounder (non likée)
  def favorite
    current_user.favorite(@user)
    set_selection
  end

  # User clique sur le coeur de la card du cofounder (précédemment likée)
  def unfavorite
    current_user.unfavorite(@user)
    set_selection
  end

  # Créé une sélection entre un sender et un receiver dont le status change en fonction de la réciprocité
  def set_selection
    current_user.all_favorites.each do |favorite|
      @selection = Selection.new(sender_id: current_user, receiver_id: favorite)
      if favorite.all_favorites.include?(current_user)
        @selection.status = "Accepted"
      else
        @selection.status = "Pending"
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:fist_name, :last_name, :hobby_list, :personality_list, :value_list, :soft_skill_list,
      :expertise, :language_list)
  end
end
