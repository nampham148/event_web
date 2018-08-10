class EventsController < ApplicationController
  before_action :logged_in
  load_and_authorize_resource

  def index
    @events = Event.available_registration?
  end

  def show
    # @event = Event.find(params[:id])
  end

  def new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      redirect_to @event
    else
      render 'new'
    end
  end

  def destroy
  end

  def edit
  end

  def update
  end

  def view_user
    @users = @event.participants
  end

  private
    def event_params
      params.require(:event).permit(:name, :location, :registration_start, :registration_end, :event_start, :event_end, :short_desc, :long_desc)
    end
end
