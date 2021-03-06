class Event < ApplicationRecord
  belongs_to :user
  has_many :rsvps, -> { includes(:user) }
  has_many :likes, -> { includes(:user) }

  default_scope { order('start_time') } 

  attr_accessor :start_date_date, :start_date_time, :end_date_date, :end_date_time
 
  after_initialize :get_datetimes
  before_validation :set_datetimes

  DATE_FORMAT = "%d %B, %Y"
  TIME_FORMAT = "%I:%M%p"
  DATE_AND_TIME_FORMAT = DATE_FORMAT + " " + TIME_FORMAT
  DATE_AND_TIME_FORMAT_SHORT = "%a, %b %d at %I:%M%p"

  def start_time_display
    format_display_date(self.start_time)
  end

  def end_time_display
    format_display_date(self.end_time)
  end

  def start_time_display_short
    format_display_date_short(self.start_time)
  end

  def end_time_display_short
    format_display_date_short(self.end_time)
  end

  def can_modify(user)
    (user && ( (user.id == self.user_id) || user.is_admin) )
  end

  def num_rsvps
    rsvps.length
  end

  private

    def format_display_date(date)
      date.strftime(DATE_AND_TIME_FORMAT)
    end

    def format_display_date_short(date)
      date.strftime(DATE_AND_TIME_FORMAT_SHORT)
    end

    def get_datetimes
      if (self.start_time)
        self.start_date_date = self.start_time.strftime(DATE_FORMAT)
        self.start_date_time = self.start_time.strftime(TIME_FORMAT)
      end
      if (self.end_time)
        self.end_date_date   = self.end_time.strftime(DATE_FORMAT)
        self.end_date_time   = self.end_time.strftime(TIME_FORMAT)
      end
    end

    def set_datetimes
      if (self.start_date_date && self.start_date_time)
        date_str = self.start_date_date + self.start_date_time
        Rails.logger.debug("date_str = #{date_str}")
        new_date = DateTime.parse(date_str)
        Rails.logger.debug("new date = #{new_date}")
        self.start_time = new_date
      end

      if (self.end_date_date && self.end_date_time)
        date_str = self.end_date_date + self.end_date_time
        Rails.logger.debug("date_str = #{date_str}")
        new_date = DateTime.parse(date_str)
        Rails.logger.debug("new date = #{new_date}")
        self.end_time = new_date
      end
    end

end
