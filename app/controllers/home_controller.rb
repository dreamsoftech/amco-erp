class HomeController < ApplicationController
  before_filter :authenticate_user!, :before_query
  before_filter :admin_authorization, only: ["dashboard"]
	
	def index
		if current_user.roles.first.name == "admin"
			redirect_to "/dashboard"
		end

		unless params[:job_site_id].nil?
			@job_site = JobSite.find(params[:job_site_id])
			@phases = @job_site.phases unless @job_site.nil?
		end
	end

	def new_purchase_order
		@job_site = JobSite.find_by_id(params[:job_site_id])
		@lot = Lot.find_by_id(params[:lot_id])
		@phase = @lot.phase
		@lots = @phase.lots
		@supplier = @job_site.supplier
		@purchase_order = PurchaseOrder.new
		@purchase_order.phase_id = @phase.id
	end

	private

	def before_query
		@developers = Developer.all
		@developer_id = params[:developer_id] 
	end

	def admin_authorization
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
  end
end