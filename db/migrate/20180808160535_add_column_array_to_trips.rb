class AddColumnArrayToTrips < ActiveRecord::Migration[5.2]
  def change
    add_column :trips, :visit_prefectures, :text, array: true, default: []
  end
end
