class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
	    t.string :city
	    t.string :neighborhood
	    t.string :state
	    t.string :street
      t.string :postal_code, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false

      t.timestamps
    end

    add_index :addresses, :postal_code
  end
end
