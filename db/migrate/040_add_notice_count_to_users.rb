class AddNoticeCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :failed_notice_count, :integer
    add_column :users, :on_hold, :boolean
    User.reset_column_information
    User.find(:all).each do |u|
      u.update_attribute :on_hold, false
    end
  end

  def self.down
    remove_column :users, :failed_notice_count
    remove_column :users, :on_hold
  end
end
