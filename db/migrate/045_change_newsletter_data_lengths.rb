class ChangeNewsletterDataLengths < ActiveRecord::Migration
  def self.up
    change_column :newsletters, :tip_description, :text
    change_column :newsletters, :treat_ingredients, :text
    change_column :newsletters, :treat_instructions, :text
    change_column :newsletters, :email_question, :text
    change_column :newsletters, :email_response, :text
  end
end
