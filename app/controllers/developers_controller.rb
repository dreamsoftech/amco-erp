class DevelopersController < ApplicationController
  before_filter :authenticate_user!, :admin_authorization

  def index
  	@developers = Developer.paginate(page: params[:page], per_page: 10)

    if @developers.empty?
      flash[:error] = "There is no existing developers."
    end
  end

  def create
  	developer = Developer.new(params[:developer])
  	if developer.save
      create_event("Developer(#{developer.name}) is created.")
  		redirect_to developers_path, notice: "New Developer is successfully created."
  	else
  		redirect_to developers_path, notice: "Unable to create new developer."
  	end
  end

  def update
  	developer = Developer.find(params[:id])
  	if developer.update_attributes params[:developer]
      create_event("Developer(#{developer.name}) is updated.")

  		redirect_to developers_path, notice: "Developer is successfully updated."
  	else
  		redirect_to developers_path, notice: "Unable to update developer info."
  	end
  end

  def destroy
		developer = Developer.find(params[:id])
		developer.destroy
    create_event("Developer(#{developer.name}) is deleted.")

  	redirect_to developers_path, notice: "Developer is successfully removed."
	end

  private

  def admin_authorization
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
  end

  def create_event(summary)
    event = Event.new
    event.summary = summary
    event.user_id = current_user.id
    event.save
  end
end