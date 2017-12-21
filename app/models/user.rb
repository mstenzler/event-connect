class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :rsvps

  has_many :likes
  has_many :liked_users, :through => :likes, source: :user

  has_many :liked_by, :foreign_key => 'liked_user_id', :class_name => 'Like'
  has_many :admirers, :through => :liked_by, :source => :user

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
 
  GENDERS = ['Male', 'Female', 'Other']

  def self.gender_options
    GENDERS.collect { |g| [ g, g ] }
  end 

  #returns the rsvp id for an event if user is RSVP'd to event
  def rsvp_id_for_event(event)
    rsvp = rsvps.where(event_id: event.id).first
    rsvp ? rsvp.id : nil
  end

  def mutual(event)
    User.where(id: likes_as_a.where(event_id: event.id).pluck(:liked_user_id) + likes_as_b.where(event_id: event.id).pluck(:user_id))
  end

  def by_event(event_id)
    where("liked_by.event_id = ?", event_id)
  end
       
  def mutually_likes?(user)
    self.liked_users.include?(user) && self.admirers.include(user)
#    self.friends.include?(user) && self.followers.include?(user)
  end

  def event_mutual_likes(event)
    User.find_by_sql(["SELECT DISTINCT u.* FROM users u join likes on likes.user_id = u.id join likes l on likes.user_id=l.liked_user_id and l.user_id=likes.liked_user_id and l.event_id = likes.event_id WHERE (l.user_id = ? and l.event_id = ?)", self.id, event.id])
  end

  def all_mutual_likes
    User.find_by_sql(["SELECT DISTINCT u.* FROM users u join likes on likes.user_id = u.id join likes l on likes.user_id=l.liked_user_id and l.user_id=likes.liked_user_id WHERE (l.user_id = ?)", self.id])
  end

  def liked_user_id_arr_by_event(event)
    Like.where(event_id: event.id, user_id: self.id).pluck(:liked_user_id)
  end
end
