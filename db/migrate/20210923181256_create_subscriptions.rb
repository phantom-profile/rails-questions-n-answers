class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :subscriptable, null: false, polymorphic: true
      t.timestamps

      t.index %i[user_id subscriptable_id], unique: true
    end
  end
end
