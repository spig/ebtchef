class UnifiedEmailStatsTracker < ActiveRecord::Migration
  def self.up
    rename_table( 'member_email_stats', 'email_open_stats' )
    rename_column 'email_open_stats', 'user_id', 'sent_to_id'
    rename_column 'newsletter_email_stats', 'subscriber_id', 'sent_to_id'
    #NewsletterEmailStat.find(:all).each do |nes|
      #EmailOpenStat.create(nes.attributes)
    #end
    drop_table 'newsletter_email_stats'
  end

  def self.down
    raise IrreversibleMigration
  end
end
