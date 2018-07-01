class CreatePrefectures < ActiveRecord::Migration[5.2]
  def change
    create_table :prefectures do |t|
      t.string :code
      t.string :name
      t.boolean :go_flag, default: false, null: false
      t.timestamps
    end
  end
end
