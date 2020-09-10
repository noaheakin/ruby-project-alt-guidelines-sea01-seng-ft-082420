class CreateMovieNights < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_nights do |t|
      t.integer :user_id
      t.integer :movie_id
      t.datetime :showtime
    end
  end
end
