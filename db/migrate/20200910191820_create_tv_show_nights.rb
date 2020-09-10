class CreateTvShowNights < ActiveRecord::Migration[5.2]
  def change
    create_table :tv_show_nights do |t|
      t.integer :user_id
      t.integer :tv_show_id
      t.datetime :watchtime
    end
  end
end
