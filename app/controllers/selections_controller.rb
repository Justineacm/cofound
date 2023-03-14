class SelectionsController < ApplicationController
  def show
    @selection = Selection.find(params[:id])
    #vérifier que le user est soit le receiver soit le sender
    @message = Message.new
  end

  def find_selection(user)
    @selection = current_user.selection_for(user)
  end
end
