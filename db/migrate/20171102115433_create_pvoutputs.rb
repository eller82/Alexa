class CreatePvoutputs < ActiveRecord::Migration[5.1]
  def change
    create_table :pvoutputs do |t|
      t.integer :UserId, :limit => 8 
      t.text :sid
      t.text :key

      t.timestamps
    end
  end
end
