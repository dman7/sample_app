class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
		add_index(:users, :email, {:unique => true}) # Add index to table :users on :email
  end

  def self.down
		remove_index(:users, :email) 
  end
end
