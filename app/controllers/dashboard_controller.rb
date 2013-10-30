class DashboardController < ApplicationController
  before_filter :authenticate_user!, :admin_authorization
	
	def index
		@job_sites = JobSite.all
		@spendings_today = PurchaseOrder.where("created_at >= ?", DateTime.now.beginning_of_day).sum(:total_amount)
		@spendings_this_month = PurchaseOrder.where("created_at >= ?", Date.today.at_beginning_of_month).sum(:total_amount)
		@spendings_timeline = PurchaseOrder.where("created_at >= ?", Date.today.at_beginning_of_month).sum(:total_amount, :group => "strftime('%d', created_at)")
		@max_payment = PurchaseOrder.where("created_at >= ?", Date.today.at_beginning_of_month).maximum(:total_amount)
	end

	private

  def admin_authorization
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
  end
end