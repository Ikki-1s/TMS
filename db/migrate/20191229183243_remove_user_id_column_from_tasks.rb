class RemoveUserIdColumnFromTasks < ActiveRecord::Migration[5.2]
  def up
    remove_column :tasks, :user_id
  end

  def down
    add_column :tasks, :user_id
  end

end
