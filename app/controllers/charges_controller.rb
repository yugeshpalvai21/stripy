class ChargesController < ApplicationController
  before_action :authenticate_user!
  
  def new
  end

  def create
    @amount = 500

    customer = Stripe::Customer.create(
                  :email => params[:stripeEmail],
                  :source => params[:stripeToken]
                )

    charge = Stripe::Charge.create(
                :customer => customer.id,
                :amount => @amount,
                :description => 'Buying New Product',
                :currency => 'inr'
              )

  rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
  end
end