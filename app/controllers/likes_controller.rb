class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_event

  def index
    @users = current_user.event_mutual_likes(@event)
  end

  def create
    liked_user_id = params[:liked_user_id]
    unless(liked_user_id && liked_user_id = liked_user_id.to_i) 
      throw 'liked_user_id not passed into likes#create'
    end

    Rails.logger.debug("@liked_user_id_arr = #{@liked_user_id_arr.inspect}")
    if (current_user_already_likes_user(liked_user_id))
      @like = Like.where(event_id: @event.id, user_id: current_user.id, liked_user_id: liked_user_id).first
      Rails.logger.debug("Already got like #{@like.inspect}")
    else
      Rails.logger.debug("Creating new like!")
      @like = @event.likes.new({ user_id: current_user.id, liked_user_id: liked_user_id } )
      @like.save
    end

    respond_to do |format|
      if @like
        format.html { redirect_to [@event], status: 303, notice: 'user was successfully liked.' }
        format.json { render json: @like }
        format.js
      end
    end
  end

  #Delete like
  def destroy
    like = Like.find(params[:id])
    if like
      like.destroy
      render :json => {:deleted => true} if like
    else
      render :json => {:deleted => false}
    end
  end

  private

    def load_event
      @event = Event.find(params[:event_id])
      @liked_user_id_arr = current_user.liked_user_id_arr_by_event(@event)
    end

    def current_user_already_likes_user(user_id)
      Rails.logger.debug("Checking to see if arr #{@liked_user_id_arr} includes #{user_id}")
      @liked_user_id_arr.include?(user_id)
    end
end
