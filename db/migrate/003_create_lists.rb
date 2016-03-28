class CreateLists < ActiveRecord::Migration
	def up
		create_table :lists do |t|
			t.string :title
			t.integer :user_id, null:false
		end
	end

	def down
		drop_table :lists
	end
end
