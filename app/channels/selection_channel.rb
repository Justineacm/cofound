class SelectionChannel < ApplicationCable::Channel
  def subscribed
    selection = Selection.find(params[:id])
    stream_for selection
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
