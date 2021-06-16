class AddColumToNewsletterTable < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :tip_name, :string
    add_column :newsletters, :tip_description, :string
    add_column :newsletters, :treat_name, :string
    add_column :newsletters, :treat_ingreidents, :string
    add_column :newsletters, :treat_instructions, :string
    add_column :newsletters, :email_greeting, :string
    add_column :newsletters, :email_question, :string
    add_column :newsletters, :email_response, :string
    remove_column :newsletters, :content
  end

  def self.down
    remove_column :newsletters, :tip_name
    remove_column :newsletters, :tip_description
    remove_column :newsletters, :treat_name
    remove_column :newsletters, :treat_ingreidents
    remove_column :newsletters, :treat_instructions
    remove_column :newsletters, :email_greeting
    remove_column :newsletters, :email_question
    remove_column :newsletters, :email_response
  end
end
