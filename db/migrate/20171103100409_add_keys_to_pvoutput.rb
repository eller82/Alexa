class AddKeysToPvoutput < ActiveRecord::Migration[5.1]
  def change
    add_column :pvoutputs, :encrypted_key, :string
  end
end
