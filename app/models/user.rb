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
  has_many :event_liked_by, ->  (event) { 
           where("event_id = ?", event.id)
         }, :foreign_key => 'liked_user_id', :class_name => 'Like'
  has_many :event_admirers, -> (event) {
          where("event_id = ?", event.id)
          }, :through => :liked_by, :source => :user

  has_many :likes_as_a, class_name: "Like", foreign_key: :user_id
  has_many :likes_as_b, class_name: "Like", foreign_key: :liked_user_id

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

  def event_mutual_likes_old(event)
    Like.select('l.*').joins('join likes l on likes.user_id=l.liked_user_id and l.user_id=likes.liked_user_id').where('l.user_id = ?', self.id)
  end

  def event_mutual_likes2(event)
    Like.joins('join likes l on likes.user_id=l.liked_user_id and l.user_id=likes.liked_user_id  join users u on l.liked_user_id = u.id').where('l.user_id = ?', self.id).select('u.*')
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
