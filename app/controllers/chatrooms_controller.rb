class ChatroomsController < ApplicationController
  before_action :logged_in
  before_action :member, only: [:show]
  def show
    @message = Message.new
    @chatrooms = current_user.chatrooms
  end

  def index
    @chatrooms = current_user.chatrooms
  end

  private
    def member
      @chatroom = Chatroom.find(params[:id])
      unless @chatroom.participants.include?(current_user)
        flash[:danger] = "Access Denied!"
        redirect_to root_url
      end
    end
end
