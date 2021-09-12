class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :votable, null: false, polymorphic: true
      t.boolean :voted_for, null: false
      t.timestamps
      t.index [:user_id, :votable_id], unique: true
    end
  end
end
