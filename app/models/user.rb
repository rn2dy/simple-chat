class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :rememberable, :trackable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable
  field :nickname, type: String

  before_create :create_nickname
  has_and_belongs_to_many :chat_rooms, dependent: :nullify

  has_one :my_chat_room, class_name: 'ChatRoom', inverse_of: :owner
  
  protected
  def create_nickname
    self.nickname = email.match(/(.+)@/i)[1].to_s 
  end
end
