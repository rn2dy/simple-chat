module ApplicationHelper
  def url2html(msg)
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i
    if obj = msg.match(exp)
      url = "<a href='#{obj[1]}' target='_blank'>#{obj[1]}</a>"
      msg.gsub(exp, url) 
    else 
      msg
    end
  end
end
