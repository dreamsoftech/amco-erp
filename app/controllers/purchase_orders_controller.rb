class PurchaseOrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_authorization, only: [:index]

  def index
  	@purchase_orders = PurchaseOrder.paginate(page: params[:page], per_page: 10)
  end

  def create
  	purchase_order = PurchaseOrder.new(params[:purchase_order])
    product_ids = params[:product_ids]
    quantities  = params[:quantities]
    lot_ids     = params[:lot_ids]

    if purchase_order.save
      total_amount = 0
      product_ids.each_with_index do |p, i|
        begin
          line_item = purchase_order.line_items.build
          line_item.product_id = p
          line_item.quantity = quantities[i]
          line_item.lot_id = lot_ids[i]
          line_item.save
          total_amount += line_item.product.price * line_item.quantity
          
        rescue
        end
      end
      puts "---------------------"
      puts total_amount
      purchase_order.update_attributes(total_amount: total_amount) # update total amount

      create_event("Purchase Order(#{purchase_order.id}) is created.")

      InvoiceMailer.send_mail(purchase_order).deliver # send email

      js = purchase_order.phase.job_site
      developer_id = js.developer.id
  		redirect_to "/?job_site_id=#{js.id}&developer_id=#{developer_id}", notice: "New PurchaseOrder is successfully created."
  	else
  		redirect_to "/?job_site_id=#{js.id}&developer_id=#{developer_id}", notice: "Unable to create new purchase_order."
  	end
  end

  def show
    @purchase_order = PurchaseOrder.find(params[:id])
    @line_items = @purchase_order.line_items.paginate(page: params[:page], per_page: 10)
    @phase = @purchase_order.phase
    @job_site = @phase.job_site
    @supervisor = @job_site.user
  end

  def update
  	purchase_order = PurchaseOrder.find(params[:id])
  	if purchase_order.update_attributes params[:purchase_order]
      create_event("Purchase Order(#{purchase_order.id}) is updated.")
  		redirect_to purchase_orders_path, notice: "PurchaseOrder is successfully updated."
  	else
  		redirect_to purchase_orders_path, notice: "Unable to update purchase_order info."
  	end
  end

  def destroy
		purchase_order = PurchaseOrder.find(params[:id])
		purchase_order.destroy
    create_event("Purchase Order(#{purchase_order.id}) is deleted.")

  	redirect_to purchase_orders_path, notice: "PurchaseOrder is successfully removed."
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