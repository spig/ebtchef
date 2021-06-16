class CreateNewsletterSubscribers < ActiveRecord::Migration
  def self.up
    create_table :newsletter_subscribers do |t|
      t.column :email, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :newsletter_subscribers
  end
end
