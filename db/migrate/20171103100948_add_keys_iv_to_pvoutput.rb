class AddKeysIvToPvoutput < ActiveRecord::Migration[5.1]
  def change
    add_column :pvoutputs, :encrypted_key_iv, :string
  end
end
