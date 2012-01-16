$(document).ready(function()
{
  var socket = new Pusher(PUSHER_KEY);
  // pusher#auth should be triggered at this point
  var presenceChannel = socket.subscribe(channel);
  
  presenceChannel.bind('pusher:subscription_succeeded', function(members) {
    updateMemberCount(members.count);
  });

  // member_added & member_removed
  presenceChannel.bind('pusher:member_added', function(member) {
    $('#msg-box-1 ul').append('<li class="notice"><span>' + member.info.nickname + '</span> joined the chat.</li>');
    $('#user-panel ul').append('<li id="' + member.id + '">' + member.info.nickname + '</li>');
    updateMemberCount(1); 
    scrollToTheTop();
  });
  presenceChannel.bind('pusher:member_removed', function(member) {
    $('#msg-box-1 ul').append('<li class="notice"><span>' + member.info.nickname +'</span> left the chat.</li>');
    $('li#' + member.id).remove();
    updateMemberCount(-1);
    scrollToTheTop();
  });

  // update nickname
  presenceChannel.bind('update_nickname', function(member) {
    if(member.user_id == my_id) {
			$('#msg-box-1 ul').append('<li class="notice">You changed your nickname to <span>' + member.nickname + '</span>.</li>');
		} else {
			$('#msg-box-1 ul').append('<li class="notice"><span>' + member.old_nickname + '</span> updated its nickname to <span>' + member.nickname + '</span>.</li>');
		}
    $('li#' + member.user_id).html(member.nickname);
		scrollToTheTop();
  });

  // Receiving incoming message
  presenceChannel.bind('send_message', function(message) {
    var style = '';
    if(message.user_id == my_id) {
      style = 'self';
      $('#msg-overlay').fadeOut(150);
    } else { 
      if(hasFocus == true) {
        document.title = "New Message! - Simple Chat";
      }
    }
    var new_content = '<li class="' + style + '" style="display:none;" id="' + message._id + '"><span>' + message.user.nickname + ' : </span>' + replaceURLWithHTMLLinks(message.content) + '</li>';
    $('#msg-box-1 ul').append(new_content);
    $('#msg-box-1 li#' + message._id).fadeIn();
    scrollToTheTop();
  });

  // Typing messages
  presenceChannel.bind('typing_status', function(notification) {
  });
  // pusher is all setup, show chat box
  $('#message').removeAttr('disabled');
  $('#button-2').click(function() { send_message(); });
  $('#message').keydown( function(e) {
    if (e.keyCode == 13) {
      send_message();
      return false;
    }
  });

  // update nickname
  $('#info-bar .right span').click( function () {
    $(this).hide();
    $('#name-update').fadeIn(200);
  });
  $('#button-3').click( function() {
    if ( $('#input-2').val() == '') {
      alert("Nothing is there...");
      return false;
    }
    if ( $('#input-2').val() != old_nickname ) {
      $.post('/chat_rooms/' + chatroom_id + '/update_nickname', { 'nickname': $('#input-2').val() }, function(response) {
        // assume a successful update
				$('#input-2').val('');
				$('#name-update').hide();
				$('#info-bar .right span:first').fadeIn(200);
			});  
    } else {
				$('#input-2').val('');
				$('#name-update').hide();
				$('#info-bar .right span:first').fadeIn(200);
    }
    return false;
  });
  
});
