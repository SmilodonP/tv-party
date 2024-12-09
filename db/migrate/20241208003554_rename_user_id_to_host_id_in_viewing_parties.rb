class RenameUserIdToHostIdInViewingParties < ActiveRecord::Migration[7.1]
  def change
    rename_column :viewing_parties, :user_id, :host_id
  end
end
