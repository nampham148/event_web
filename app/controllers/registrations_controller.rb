class RegistrationsController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    registration = current_user.registrations.build(event_id: @event.id)
    if registration.save
      flash.now[:success] = "Sign up successfully!"
    else
      flash.now[:danger] = "There are #{registration.errors.count} error(s): #{registration.errors.full_messages.join(", ")}"
    end
    respond_to do |format|
      format.html
      format.js { render 'update.js.erb' }
    end
  end

  def destroy
    @event = Registration.find(params[:id]).event
    current_user.unregister(@event)
    respond_to do |format|
      format.html
      format.js { render 'update.js.erb' }
    end
  end
end
