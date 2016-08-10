class Event < ApplicationRecord
  belongs_to :user
  has_many :rsvps, -> { includes(:user) }

  attr_accessor :start_date_date, :start_date_time, :end_date_date, :end_date_time
 
  after_initialize :get_datetimes
  before_validation :set_datetimes

  DATE_FORMAT = "%d %B, %Y"
  TIME_FORMAT = "%I:%M%p"
  DATE_AND_TIME_FORMAT = DATE_FORMAT + " " + TIME_FORMAT

  def start_time_display
    format_display_date(self.start_time)
  end

  def end_time_display
    format_display_date(self.end_time)
  end

  private

    def format_display_date(date)
      date.strftime(DATE_AND_TIME_FORMAT)
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
