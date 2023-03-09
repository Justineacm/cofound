class DashboardsController < ApplicationController
  before_action :set_users

  def matches

  end

  def messages

  end

  def project

  end

  def favprofils

  end

  private

  def set_users
    @users = User.all
  end
end
