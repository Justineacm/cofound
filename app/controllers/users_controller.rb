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
  end

  def project_match
    if current_user.has_a_project
      return @matches = User.where(has_a_project: false).where.not(id: current_user.id)
    else
      return @matches = User.where.not(id: current_user.id)
    end
  end

  # Match sur XX années d'xp cumulées au total
  def experience_match
    return @matches = @matches.select do |match|
      current_user.total_experience + match.total_experience > 3 # changer après push
    end
  end

  # Match complémentaire sur l'expertise ["Management", "Technical", "Marketing", "Computer"]
  def expertise_match
    if current_user.expertise_list.include?("Management") || current_user.expertise_list.include?("Marketing")
      return @matches = @matches.select do |match|
        match.expertise_list.include?("Technical") || match.expertise_list.include?("Computer")
      end
    else
      return @matches = @matches.select do |match|
        match.expertise_list.include?("Management") || match.expertise_list.include?("Marketing")
      end
    end
  end

  # Match sur 1 langue en commun au moins
  def language_match
    return @matches = @matches.select do |match|
      match.language_list.include?(current_user.language_list[0]) || match.language_list.include?(current_user.language_list[1])
    end
  end

  # analyst/diplomat #sentinel/explorer #analyst/explorer #sentinel/diplomat
  def mbti_match
    if current_user.mbti == "Analyst"
      return @matches = @matches.select do |match|
        match.mbti == "Diplomat" || match.mbti == "Explorer"
      end
    elsif current_user.mbti == "Diplomat"
      return @matches = @matches.select do |match|
        match.mbti == "Analyst" || match.mbti == "Sentinel"
      end
    elsif current_user.mbti == "Sentinel"
      return @matches = @matches.select do |match|
        match.mbti == "Explorer" || match.mbti == "Diplomat"
      end
    else
      return @matches = @matches.select do |match|
        match.mbti == "Sentinel" || match.mbti == "Analyst"
      end
    end
  end

  # Match on cities (current city)
  def city_match
    return @matches = @matches.select do |match|
      match.city == current_user.city
  end

  def matching_algo
    project_match
    experience_match
    expertise_match
    language_match
    mbti_match
    city_match
    return @matches
  end

  def find_selection
    @selections = Selection.all
    @senderselections = @selections.select do |selection| # Vérif sélections où current_user = sender et user = receiver
      selection.sender_id == current_user.id && selection.receiver_id == user.id
    end
    @receiverselections = @selections.select do |selection| # Vérif sélections où current_user = receiver et user = sender
      selection.sender_id == user.id && selection.receiver_id == current_user.id
    end
    @selection = @senderselections + receiverselections # Identifier la sélection (si existante)
  end

  def like
    find_selection # Déclenchement : bouton like d'une card user
    # Si la sélection est vide - création d'une sélection pending où current_user = sender
    if @selection.empty?
      Selection.new(sender_id: current_user, receiver_id: user) # status à 0 par défaut (pending)
    else
      @selection.accepted! # Si non, update de la sélection en status "Accepted"
    end
  end

  def reject
    find_selection # Déclenchement : bouton unlike ou reject d'une card user
    if @selection.empty?
      Selection.new(sender_id: current_user, receiver_id: user, status: 3)
    else
      @selection.rejected!
    end
  end

  private

  def user_params
    params.require(:user).permit(:fist_name, :last_name, :hobby_list, :personality_list, :value_list, :soft_skill_list,
      :expertise, :language_list)
  end
end
