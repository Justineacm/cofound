class SelectionsController < ApplicationController
  def show
    @selection = Selection.find(params[:id])
    #vérifier que le user est soit le receiver soit le sender
    @message = Message.new
  end

  def find_selection(user)
    @selection = current_user.selection_for(user)
  end

  def is_typing
    @selection = Selection.find(params[:id])
    SelectionChannel.broadcast_to @selection, { typing: true, content: "#{current_user.first_name} is typing", user_id: current_user.id }
  end
end
