# frozen_string_literal: true

class AddOwnerToQuestionAndAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :user_id, :integer,
               null: false,
               foreign_key: { to_table: :users }
    add_column :answers, :user_id, :integer,
               null: false,
               foreign_key: { to_table: :users }
  end
end
