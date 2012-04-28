class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string  :ipaddress
      t.string  :nickname
      t.integer :activity_id
    end
    add_index :participants, :ipaddress, :unique => true
  end

  def self.down
    drop_table :participants
  end
end



