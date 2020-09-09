class CreateMovieNights < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_nights do |t|
      t.string :user
      t.string :movie
      t.datetime :showtime
    end
  end
end
