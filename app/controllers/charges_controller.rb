class ChargesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @product = Product.find(params[:product])
    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'inr',
            product_data: {
              name: @product.title 
            },
            unit_amount: (@product.price * 100).to_i,
          },
          quantity: 1
        }
      ],
      mode: 'payment',
      # These placeholder URLs will be replaced in a following step.
      success_url: "http://localhost:3000/charges/success/?product=#{@product.id}&session_id={CHECKOUT_SESSION_ID}",
      cancel_url: 'http://localhost:3000/charges/cancel',
      customer_email: current_user.email
    })
  end

  def create
    #this code is for Stripe Legacy Checkout
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

  def success
    @payment_details = Stripe::Checkout::Session.retrieve(params[:session_id])
  end

  def cancel
  end
end