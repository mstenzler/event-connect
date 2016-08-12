class Like < ApplicationRecord
  belongs_to :event
  belongs_to :user
  belongs_to :liked_user, class_name: 'User', foreign_key: 'liked_user_id'
end
