class ChangeUserId < ActiveRecord::Migration[5.1]
  def change
    rename_column :pvoutputs, :UserID, :user_id
  end
end
