class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.string :status
      t.datetime :deadline
      t.integer :priority
      t.integer :user_id
      t.integer :label_id

      t.timestamps
    end
  end
end
