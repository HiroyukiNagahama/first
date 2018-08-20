class AddAreaToPrefecture < ActiveRecord::Migration[5.2]
  def change
    add_column :prefectures, :area_cd, :string, after: :name
  end
end
