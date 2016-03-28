class CreateTasks < ActiveRecord::Migration
	def up
		create_table :tasks do |t|
			t.string :item, null: false
			t.datetime :duedate
			t.boolean :completed
		end
	end

	def down
		drop_table :tasks
	end
end