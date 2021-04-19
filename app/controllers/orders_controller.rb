class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    if current_user.admin
      redirect_to root_path, notice: 'As a admin youre not allowed to buy product'
    else
      @product = Product.find(params[:product_id])
      @order = Order.new
      @order.user = current_user
      @order.product = @product
      @order.total = @product.price
      @order.save
    end
  end
end