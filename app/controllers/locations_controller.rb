class LocationsController < ApplicationController
  before_filter :authenticate_user!, :admin_authorization
  respond_to :json, only: [:create, :update, :destory]

  def index
  	@locations = Location.paginate(page: params[:page], per_page: 10)
  end

  def show
    @location = Location.find(params[:id])
    @location = Location.new
  end

  def create
  	location = Location.new(params[:location])
  	location.supplier = params[:supplier_id]
  	if location.save
      create_event("Location(#{location.name}) is created.")
			respond_with(location, :status => 201, :default_template => :show)
		else
			render json: location.errors, status: :unprocessable_entity
		end
  end

  def update
  	location = Location.find(params[:location])
  	if location.update_attributes(params[:location])
      create_event("Location(#{location.name}) is updated.")
			respond_with(location, :status => 200, :default_template => :show)
		else
			render json: location.errors, status: :unprocessable_entity
		end
  end

  def destroy
		@location = Location.find(params[:id])

		if @location.destroy
      create_event("Location(#{@location.name}) is deleted.")
      render json: @location
    else
      respond_with(@location.errors, status: :unprocessable_entity)
    end
	end

  private

  def admin_authorization
    authorize! :index, @user, :message => 'Nocation authorized as an administrator.'
  end

  def create_event(summary)
    event = Event.new
    event.summary = summary
    event.user_id = current_user.id
    event.save
  end
end