class Users::SessionsController < Devise::SessionsController
  protected
  def sign_out
    # Check if the current_user own a chat room 
    # Maybe other dependency setting would do the trick
    if room = current_user.my_chat_room
      # promote an user to be the owner
      if room.users.any?
        candidate = room.users.first
        room.owner = candidate 
        room.users.delete(candidate)
        room.save
      else
        room.users = nil
        room.delete
      end
    end
    # remove all the existence of the user in other rooms
    if current_user.chat_rooms.any?
      current_user.chat_rooms = nil
    end
    super
  end
end
