class CreateAmazons < ActiveRecord::Migration[5.1]
  def change
    create_table :amazons do |t|
      t.string :UniqueID
      t.text :AlexaID
      t.integer :UserID, :limit => 8 

      t.timestamps
    end
  end
end
