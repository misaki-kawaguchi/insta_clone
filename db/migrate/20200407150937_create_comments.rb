class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      # null: false → 空の状態で保存しないようにする
      t.text :content, null: false

      t.timestamps
    end
  end
end
