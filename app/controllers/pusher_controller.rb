class PusherController < ApplicationController
  protect_from_forgery :except => :auth
  def auth
    raise "Unknown channel" unless params[:channel_name] =~ /presence-channel-\w+/
    channel = Pusher["#{params[:channel_name]}"]
    if user_signed_in? 
      response = channel.authenticate(params[:socket_id], {
        :user_id => current_user.id,
        :user_info => { :nickname => current_user.nickname }
      })
      render :json => response
    else
      redirect_to :root, :notice => 'You have to sign in/sign up first'
    end
  end
end
