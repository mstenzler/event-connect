class RsvpsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_event

  def index
    @rsvps = @event.rsvps.order('created_at DESC').all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rsvps}
    end
  end

  def create
    if (@current_user_already_rsvp)
      @rsvp = Rsvp.where(event_id: @event.id, user_id: current_user.id).first
      Rails.logger.debug("Already got rsvp #{@rsvp.inspect}")
    else
      rand_code = random_code(5)
      @rsvp = @event.rsvps.new({ user_id: current_user.id, code: rand_code } )
      @rsvp.save
      load_rsvp_info
    end

    respond_to do |format|
      if @rsvp
        format.html { redirect_to [@event], status: 303, notice: 'Rsvp was successfully created.' }
        format.json { render json: @rsvp }
        format.js
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @rsvp = Rsvp.find(params[:id])
    Rails.logger.debug("params[format] = #{params[:format]}, request.headers = #{request.headers['Accept']}")
    #@rsvp.destroy
    @event.rsvps.destroy(@rsvp)
    load_rsvp_info
    respond_to do |format|
      format.html { redirect_to event_url(@event), status: 303, notice: 'Rsvp was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private

    def load_event
      @event = Event.find(params[:event_id])
      Rails.logger.debug("event = #{@event.inspect}")
    end

    def load_rsvp_info
      #create an array of the user id's for every RSVP'd user
      @rsvp_id_arr = @event.rsvps.map { |rsvp| rsvp.user.id }
      @current_user_already_rsvp = already_rsvp?
      if (current_user)
        @current_user_rsvp_id = @current_user_already_rsvp ? current_user.rsvp_id_for_event(@event) : nil 
        @liked_user_id_arr = current_user.liked_user_id_arr_by_event(@event)
        #below is a hash of liked_users to the like_id in order to set unlike button
        @curr_user_liked_user_to_liked_id_hash = 
          current_user.likes.where(event_id: @event.id).inject({}) { |r,c| r.merge c.liked_user_id => c.id }
      end

      Rails.logger.debug("in load_event. @current_user_already_rsvp = #{@current_user_already_rsvp}")
      Rails.logger.debug("@rsvp_id_arr = #{@rsvp_id_arr}")
    end

    def random_code(len)
      (0...len).map { (65 + rand(26)).chr }.join
    end

    def already_rsvp?
      @rsvp_id_arr.include? current_user.id
    end
end
