json.extract! event, :id, :user_id, :title, :venue_name, :venue_address, :venue_zip, :description, :start_time, :end_time, :created_at, :updated_at
json.url event_url(event, format: :json)