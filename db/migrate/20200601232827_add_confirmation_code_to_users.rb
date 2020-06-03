class AddConfirmationCodeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :confirmation_code, :string, limit: 16, index: {unique: true}
    add_column :users, :email_confirmed, :boolean, default: false
  end
end