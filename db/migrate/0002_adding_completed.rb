class AddingCompleted < ActiveRecord::Migration
  def change
    add_column :properties, :completed, :boolean

    add_index :properties, :completed
  end
end
