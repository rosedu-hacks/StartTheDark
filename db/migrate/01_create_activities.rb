class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :author_ipaddress
      t.text   :description
    end
  end

  def self.down
    drop_table :activities
  end
end



