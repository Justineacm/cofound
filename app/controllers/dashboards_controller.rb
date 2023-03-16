class DashboardsController < ApplicationController
  before_action :set_users

  def matches
    if session[:suggestions]
      @suggestions = matching_algo.select do |user|
        current_user.keep_suggestion?(user)
      end
      @suggestions = @suggestions.select(&:has_a_project?) if params[:has_project] == "true"
    else
      @suggestions = []
    end

    @matched_profiles = User.where(id: current_user.matched_users.map(&:id)) + User.where(id: current_user.liked_users.map(&:id))
  end

  def suggestions
    @suggestions = @suggestions = matching_algo.select do |user|
      current_user.keep_suggestion?(user)
    end
    @suggestions.each do |user|
      Selection.create(sender_id: current_user.id, receiver_id: user.id) if current_user.selection_for(user).blank?
    end
    session[:suggestions] = true
    redirect_to matches_dashboards_path
  end

  def filtered_suggestions
    @suggestions = matching_algo.select do |user|
      current_user.keep_suggestion?(user)
    end
    @suggestions = @suggestions.select(&:has_a_project?) if params[:has_project] == "true"
    render partial: "selections/suggestions", locals: { session: session, suggestions: @suggestions, has_project: params[:has_project] == "true" }, formats: :html
  end

  def messages
    @selections = current_user.selections
  end

  def like
    @user = User.find(params[:user_id])
    @selection = current_user.selection_for(@user)
    @selection.accepted! if @selection.pending?
    @selection.pending! if @selection.suggestion?
    redirect_to matches_dashboards_path(has_project: params[:has_project])
  end

  def reject
    @user = User.find(params[:user_id])
    @selection = current_user.selection_for(@user)
    @selection.rejected!
    redirect_to matches_dashboards_path(has_project: params[:has_project])
  end

  private

  def find_selection
    cofounder_ids = [current_user.id, @user.id]
    @selection = Selection.find_by(sender_id: cofounder_ids, receiver_id: cofounder_ids)
  end

  def matching_algo
    excluding_self
    experience_match
    expertise_match
    language_match
    mbti_match
    city_match
    return @matches
  end

  def excluding_self
    @matches = User.where.not(id: current_user.id)
  end

  def project_match
    @matches = @matches.select do |match|
      match.has_a_project?
    end
  end

  def experience_match
    @matches = @matches.select do |match|
      current_user.total_experience + match.total_experience > 3 # changer après push
    end
  end

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

  def language_match
    @matches = @matches.select do |match|
      match.language_list.include?(current_user.language_list[0]) || match.language_list.include?(current_user.language_list[1])
    end
  end

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
  end

  def city_match
    @matches = @matches.select do |match|
      match.city == current_user.city
    end
  end

  def set_users
    @users = User.all
    @user = current_user
  end
end
