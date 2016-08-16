class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :init_rsvps, only: [:show]

  # GET /events
  # GET /events.json
  def index
    @events = Event.where('start_time > ?', DateTime.now).all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def init_rsvps
      if current_user
        @rsvp_id_arr = @event.rsvps.map { |rsvp| rsvp.user.id }
        @current_user_already_rsvp = @rsvp_id_arr.include? current_user.id
        @current_user_rsvp_id = @current_user_already_rsvp ? current_user.rsvp_id_for_event(@event) : nil 
        @liked_user_id_arr = current_user.liked_user_id_arr_by_event(@event)
        #below is a hash of liked_users to the like_id in order to set unlike button
        @curr_user_liked_user_to_liked_id_hash = 
          current_user.likes.where(event_id: @event.id).inject({}) { |r,c| r.merge c.liked_user_id => c.id }
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:user_id, :title, :venue_name, :venue_address, :venue_zip, :description, :start_time, :end_time, :start_date_date, :start_date_time, :end_date_date, :end_date_time)
    end
end
