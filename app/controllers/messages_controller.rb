class MessagesController < ApplicationController
  before_action :logged_in
  before_action :member

  def create
    message = Message.new(message_params)
    message.user = current_user
    if message.save
      ActionCable.server.broadcast 'messages',
        message: message.content,
        user: message.user.name,
        image: message.user.image,
        last_message: "#last-message-#{message.chatroom_id}"
      head :ok
    else 
      redirect_to chatrooms_path
    end
  end

  private
    def message_params
      params.require(:message).permit(:content, :chatroom_id)
    end

    def member
      chatroom = Chatroom.find(params[:message][:chatroom_id])
      unless chatroom.participants.include?(current_user)
        flash[:danger] = "Access Denied!"
        redirect_to root_url
      end
    end
end