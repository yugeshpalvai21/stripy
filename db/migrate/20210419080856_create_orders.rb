class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :stripe_session_id
      t.boolean :paid, default: false
      t.string :stripe_payment_id
      t.decimal :total, precision: 7, scale: 2

      t.timestamps
    end
  end
end
