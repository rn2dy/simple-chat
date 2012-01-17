class ChatRoomsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @chat_rooms = ChatRoom.all
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    if @chat_room.nil? 
      redirect_to chat_rooms_path
    end
  end

  def create
    if my_room = current_user.my_chat_room
      redirect_to chat_room_path(my_room), 
                  :notice => "You are already in this room"
    else 
      @chat_room = current_user.build_my_chat_room(name: params[:name])
      if @chat_room.save
        redirect_to chat_room_path(@chat_room), 
                    :notice => "New chat room -#{@chat_room.name}- created!"
      else
        redirect_to chat_rooms_path 
      end
    end
  end
  
  def join
    @chat_room = ChatRoom.find(params[:id])
    if current_user == @chat_room.owner || current_user.chat_rooms.include?(@chat_room)
      redirect_to chat_room_path(@chat_room), notice: "Your are already in this room" 
    else 
      @chat_room.users << current_user
      @chat_room.save! # causes problem here
      redirect_to chat_room_path(@chat_room)
    end
  end
  
  # Ajax calls 

  def send_message
    @chat_room = ChatRoom.find(params[:id])  
    @msg = @chat_room.messages.build({content: params[:content]})
    @msg.user = current_user
    if @msg.save
      payload = @msg.attributes
      payload[:user] = { nickname: current_user.nickname }
      Pusher[@chat_room.channel_name].trigger( 'send_message', payload ) 
      head :ok
    else
      head :bad_request
    end
  end

  def update_nickname
    @chat_room = ChatRoom.find(params[:id])  
    old_nickname = current_user.nickname
    if current_user.update_attributes(nickname: params[:nickname])
      payload = { old_nickname: old_nickname, nickname: params[:nickname], user_id: current_user.id }
      Pusher[@chat_room.channel_name].trigger('update_nickname',  payload)
      head :ok
    else
      head 500 
    end
  end 

end
