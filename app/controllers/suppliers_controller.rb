class SuppliersController < ApplicationController
  before_filter :authenticate_user!, :admin_authorization

  def index
  	@suppliers = Supplier.paginate(page: params[:page], per_page: 10)
    if @suppliers.empty?
      flash[:error] = "There is no existing suppliers."
    end
  end

  def create
  	supplier = Supplier.new(params[:supplier])
    if supplier.save
      unless params[:products].nil?
        product_ids = params[:products].keys

        product_ids.each do |product_id|
          supplier_product = SupplierProduct.new
          supplier_product.product_id = product_id
          supplier_product.supplier_id = supplier.id

          supplier_product.save
        end
      end
      create_event("Supplier(#{supplier.name}) is created.")

  		redirect_to suppliers_path, notice: "New Supplier is successfully created."
  	else
  		redirect_to suppliers_path, notice: "Unable to create new supplier."
  	end
  end

  def show
    @supplier = Supplier.find(params[:id])
    @products = @supplier.products
  end

  def new
    @supplier = Supplier.new
    @supplier.locations.build
    @products = Product.all
  end

  def edit
    @supplier = Supplier.find(params[:id])
    @products = Product.all
    @supplier_products = @supplier.supplier_products
    @supplier_product_ids = Array.new

    @supplier_products.each do |sp|
      @supplier_product_ids.push sp.product_id
    end
  end

  def update
  	supplier = Supplier.find(params[:id])
  	if supplier.update_attributes params[:supplier]
      
      # update location info
      unless params[:locations].nil?
        params[:locations].each do |loc|
          next if loc == ""
          location = supplier.locations.build
          location.name = loc

          location.save
        end
      end

      # refresh product list
      supplier.products.destroy_all
      unless params[:products].nil?
        product_ids = params[:products].keys

        product_ids.each do |product_id|
          supplier_product = SupplierProduct.new
          supplier_product.product_id = product_id
          supplier_product.supplier_id = supplier.id

          supplier_product.save
        end
      end

      create_event("Supplier(#{supplier.name}) is updated.")
  		redirect_to suppliers_path, notice: "Supplier is successfully updated."
  	else
  		redirect_to suppliers_path, notice: "Unable to update supplier info."
  	end
  end

  def destroy
		supplier = Supplier.find(params[:id])
		supplier.destroy
    create_event("Supplier(#{supplier.name}) is deleted.")

  	redirect_to suppliers_path, notice: "Supplier is successfully removed."
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