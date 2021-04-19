class ChargesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @order = Order.find(params[:order_id])
    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'inr',
            product_data: {
              name: @order.product.title 
            },
            unit_amount: (@order.total * 100).to_i,
          },
          quantity: 1
        }
      ],
      mode: 'payment',
      # These placeholder URLs will be replaced in a following step.
      success_url: "http://localhost:3000/charges/success/?order=#{@order.id}&session_id={CHECKOUT_SESSION_ID}",
      cancel_url: 'http://localhost:3000/charges/cancel',
      customer_email: current_user.email
    })
    @order.update(stripe_session_id: @session.id)
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
    @order = Order.find_by(stripe_session_id: params[:session_id])
    @payment_details = Stripe::Checkout::Session.retrieve(params[:session_id])
    @order.paid = true
    @order.stripe_payment_id = @payment_details.payment_intent
    @order.save
  end

  def cancel
  end
end