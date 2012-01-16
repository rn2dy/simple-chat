class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, :type => String
  belongs_to :user
  embedded_in :chat_room

  validates_presence_of :content
end
