class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :set_age
  before_validation :show_birthday

  has_many :rsvps

  has_many :likes
  has_many :liked_users, :through => :likes, source: :user

  has_many :liked_by, :foreign_key => 'liked_user_id', :class_name => 'Like'
  has_many :admirers, :through => :liked_by, :source => :user

  has_attached_file :avatar, styles: {
    small: '30x30',
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  #validates_date :birthdate, :timeliness => { :before => lambda {Date.current}, :type => :date}
  validates_date :birthdate, :before => lambda { 18.years.ago },
                            :before_message => 'must be at least 18 years old',
                            :type => :date,
                            :type_message => 'must be a valid date'

 
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

  private
    def show_birthday
      puts "****** Birthday = #{self.birthdate}"
    end

    def calculate_age_from_date(curr_date)
      now = Time.now.utc.to_date
      now.year - curr_date.year - ((now.month > curr_date.month || (now.month == curr_date.month && now.day >= curr_date.day)) ? 0 : 1)
    end

    def get_age_range(age)
      case age
      when 0..21
        "under 22"
      when 22..35
        "22 to 35"
      when 36..50
        "36 to 50"
      when 51..65
        "51 to 65"
      when 66..200
        "over 65"
      else
        ""
      end
    end

    def set_age
      self.age = calculate_age_from_date(birthdate)
      self.age_range = get_age_range(self.age)
    end
end
