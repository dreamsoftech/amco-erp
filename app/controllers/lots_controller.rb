class LotsController < ApplicationController
  before_filter :authenticate_user!, :admin_authorization
  respond_to :json, only: [:create, :update, :destory]

  def index
  	@lots = Lot.paginate(page: params[:page], per_page: 10)
  end

  def show
    @lot = Lot.find(params[:id])
    @lot = Lot.new
  end

  def create
  	lot = Lot.new(params[:lot])
  	lot.phase_id = params[:phase_id]
  	if lot.save
      create_event("Lot(#{lot.name}) is created.")
			respond_with(lot, :status => 201, :default_template => :show)
		else
			render json: lot.errors, status: :unprocessable_entity
		end
  end

  def update
  	lot = Lot.find(params[:lot])
  	if lot.update_attributes(params[:lot])
      create_event("Lot(#{lot.name}) is updated.")
			respond_with(lot, :status => 200, :default_template => :show)
		else
			render json: lot.errors, status: :unprocessable_entity
		end
  end

  def destroy
		@lot = Lot.find(params[:id])

		if @lot.destroy
      create_event("Lot(#{@lot.name}) is deleted.")
      render json: @lot
    else
      respond_with(@lot.errors, status: :unprocessable_entity)
    end
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