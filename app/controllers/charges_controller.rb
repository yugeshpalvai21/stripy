class ChargesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @product = Product.find(params[:product])
  end

  def create
    @product = Product.find(params[:product])
    @amount_in_cents = (@product.price * 100).to_i

    customer = Stripe::Customer.create(
                  :email => params[:stripeEmail],
                  :source => params[:stripeToken]
                )

    charge = Stripe::Charge.create(
                :customer => customer.id,
                :amount => @amount_in_cents,
                :description => "Buying Product - #{@product.title}(#{@product.id})",
                :currency => 'inr'
              )

  rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
  end
end