class AddConstraintsToRelationships < ActiveRecord::Migration[7.2]
  def change
    # 外部キー制約を追加
    add_foreign_key :relationships, :users, column: :follower_id
    add_foreign_key :relationships, :users, column: :followed_id

    # NOT NULL制約を追加
    change_column_null :relationships, :follower_id, false
    change_column_null :relationships, :followed_id, false

    # 一意性制約を追加（同じペアの重複を防ぐ）
    add_index :relationships, [ :follower_id, :followed_id ], unique: true
  end
end
