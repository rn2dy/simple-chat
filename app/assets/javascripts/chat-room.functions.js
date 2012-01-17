var hasFocus = true;
window.onblur = function() { hasFocus = false; }
window.onfocus = function() { hasFocus = true; }

function updateMemberCount(num) {
  count = parseInt($('#member_count').text());
  $('#member_count').text(count + num);
}

function send_message() {
  if($('#message').val() == '') {
		alert('Please enter a message...');
		$('#message').focus();
		return false;
	}
  
  // if pass validation
  var content = $('#message').val();
  $('#msg-overlay').fadeIn(200);
  $('#msg-box-1 ul').blur();

  $.post( '/chat_rooms/' + chatroom_id + '/send_message', { "content": content }, function (response) {
    $('#message').val("");
    $('#msg-overlay').fadeOut(150);
    $('#message').focus();
  });
}
function scrollToTheTop() {
	$("#msg-box-1").scrollTop(20000000); 
}
function replaceURLWithHTMLLinks(text) {
     var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
     return text.replace(exp,"<a href='$1' target='_blank'>$1</a>"); 
}
