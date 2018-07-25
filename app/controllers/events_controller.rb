class EventsController < ApplicationController
  def index
    @events = Event.available_registration?
  end

  def show
    @event = Event.find(params[:id])
  end
end
