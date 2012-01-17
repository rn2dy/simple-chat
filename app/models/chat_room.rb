class ChatRoom
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :channel_name, :type => String

  embeds_many :messages 
  has_and_belongs_to_many :users, dependent: :nullify
  belongs_to :owner, class_name: 'User', inverse_of: :my_chat_room
  
  before_create :create_channel_name
  validates_presence_of :name

  protected
  def create_channel_name
    self.channel_name = "presence-channel-#{SecureRandom.hex(10)}"
  end
end
