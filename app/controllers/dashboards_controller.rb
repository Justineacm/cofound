class DashboardsController < ApplicationController
  before_action :set_users

  def matches
    @matches = matching_algo
  end

  def messages
    @selections = current_user.selections
  end

  def project
  end

  def favprofils
    @favorite_profiles = User.where(id: current_user.liked_users.map(&:id))
  end

  def like
    @user = User.find(params[:user_id])
    # find_selection # Déclenchement : bouton like d'une card user
    @selection = current_user.selection_for(@user)
    # Si la sélection est vide - création d'une sélection pending où current_user = sender
    if @selection.nil?
      @selection = Selection.create(sender: current_user, receiver: @user) # status à 0 par défaut (pending)
    else
      @selection.accepted! if @selection.receiver == current_user # Si non, update de la sélection en status "Accepted"
      flash.now[:alert] = "It's a match!"
    end
    # if request.renderrer
    redirect_to user_path(@user)
  end

  def reject
    @user = User.find(params[:user_id])
    @selection = current_user.selection_for(@user) # Déclenchement : bouton unlike ou reject d'une card user
    if @selection.nil?
      @selection = Selection.create(sender: current_user, receiver: @user, status: :rejected)
    else
      @selection.rejected!
    end
    redirect_to matches_dashboards_path
  end

  def project_match
    if current_user.has_a_project
      @matches = User.where(has_a_project: false).where.not(id: current_user.id)
    else
      @matches = User.where.not(id: current_user.id)
    end
  end

  # Match sur XX années d'xp cumulées au total
  def experience_match
    @matches = @matches.select do |match|
      current_user.total_experience + match.total_experience > 3 # changer après push
    end
  end

  # Match complémentaire sur l'expertise ["Management", "Technical", "Marketing", "Computer"]
  def expertise_match
    if current_user.expertise_list.include?("Management") || current_user.expertise_list.include?("Marketing")
      @matches = @matches.select do |match|
        match.expertise_list.include?("Technical") || match.expertise_list.include?("Computer")
      end
    else
      @matches = @matches.select do |match|
        match.expertise_list.include?("Management") || match.expertise_list.include?("Marketing")
      end
    end
  end

  # Match sur 1 langue en commun au moins
  def language_match
    @matches = @matches.select do |match|
      match.language_list.include?(current_user.language_list[0]) || match.language_list.include?(current_user.language_list[1])
    end
  end

  # analyst/diplomat #sentinel/explorer #analyst/explorer #sentinel/diplomat
  def mbti_match
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

    User.where(id: @matches.map(&:id)).remaining
  end

  # Match on cities (current city)
  def city_match
    @matches = @matches.select do |match|
      match.city == current_user.city
    end
  end

  def remaining_matches
    @matches = @matches.select do |match|
      current_user.selection_for(match).nil?
    end

    @matches = (User.where(id: @matches.map(&:id)) + current_user.users_who_liked_me).uniq
  end

  def matching_algo
    project_match
    experience_match
    expertise_match
    language_match
    mbti_match
    city_match
    remaining_matches
    return @matches
  end

  private

  def find_selection
    cofounder_ids = [current_user.id, @user.id]
    @selection = Selection.find_by(sender_id: cofounder_ids, receiver_id: cofounder_ids)
    # @receiver_selections = Selection.where(sender: @user, receiver: current_user)

    # @senderselections = @selections.select do |selection| # Vérif sélections où current_user = sender et user = receiver
    #   selection.sender_id == current_user.id && selection.receiver_id == user.id
    # end
    # @receiverselections = @selections.select do |selection| # Vérif sélections où current_user = receiver et user = sender
    #   selection.sender_id == user.id && selection.receiver_id == current_user.id
    # end
    # @selection = @senderselections + @receiverselections # Identifier la sélection (si existante)
  end

  def set_users
    @users = User.all
  end
end
