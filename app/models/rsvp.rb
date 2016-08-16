class Rsvp < ApplicationRecord
  belongs_to :event
  belongs_to :user

  default_scope { order('updated_at DESC') } 
end
