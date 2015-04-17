class InitialSchema < ActiveRecord::Migration
  def change
    create_table :properties, force: true do |t|
      t.string :code, null: false, unique: true
      t.string :title
      t.string :kind
      t.string :address
      t.decimal :nightly_rate, precision: 10, scale: 2
      t.integer :max_guests
      t.string :email
      t.string :phone
    end

    add_index :properties, :code, unique: true
  end
end
