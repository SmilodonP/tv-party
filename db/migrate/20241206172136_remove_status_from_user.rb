class RemoveStatusFromUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :status, :integer
  end
end
