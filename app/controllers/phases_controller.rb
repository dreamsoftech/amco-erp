class PhasesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_authorization, except: [:index]
  respond_to :json, only: [:create, :update, :destory]

  def index
  	@phases = Phase.paginate(page: params[:page], per_page: 10)
  end

  def show
    @phase = Phase.find(params[:id])
    @lot = Lot.new
    @lots = @phase.lots
  end

  def create
  	phase = Phase.new(params[:phase])
  	phase.job_site_id = params[:job_site_id]
  	if phase.save
      create_event("Phase(#{phase.name}) is created.")
			respond_with(phase, :status => 201, :default_template => :show)
		else
			render json: phase.errors, status: :unprocessable_entity
		end
  end

  def update
  	phase = Phase.find(params[:phase])
  	if phase.update_attributes(params[:phase])
      create_event("Phase(#{phase.name}) is updated.")
			respond_with(phase, :status => 200, :default_template => :show)
		else
			render json: phase.errors, status: :unprocessable_entity
		end
  end

  def destroy
		@phase = Phase.find(params[:id])

		if @phase.destroy
      create_event("Phase(#{@phase.name}) is deleted.")
      render json: @phase
    else
      respond_with(@phase.errors, status: :unprocessable_entity)
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