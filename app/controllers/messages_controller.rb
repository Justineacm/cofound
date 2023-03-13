class MessagesController < ApplicationController
  def create
    @selection = Selection.find(params[:selection_id])
    @message = Message.new(message_params)
    @message.selection = @selection
    @message.user = current_user
    if @message.save
      SelectionChannel.broadcast_to(
        @selection,
        render_to_string(partial: "message", locals: { message: @message })
      )
      head :ok
    else
      render "selections/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
