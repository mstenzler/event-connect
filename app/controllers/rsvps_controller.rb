class RsvpsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_event

  def index
    @rsvps = @event.rsvps.all
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
      rand_code = random_code(8)
      @rsvp = @event.rsvps.new({ user_id: current_user.id, code: rand_code } )
      @rsvp.save
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
    @rsvp.destroy
    respond_to do |format|
      format.html { redirect_to event_url(@event), status: 303, notice: 'Rsvp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def load_event
      @event = Event.find(params[:event_id])
      #create an array of the user id's for every RSVP'd user
      @rsvp_id_arr = @event.rsvps.map { |rsvp| rsvp.user.id }
      @current_user_already_rsvp = already_rsvp?
    end


    def random_code(len)
      (0...len).map { (65 + rand(26)).chr }.join
    end

    def already_rsvp?
      @rsvp_id_arr.include? current_user.id
    end
end
