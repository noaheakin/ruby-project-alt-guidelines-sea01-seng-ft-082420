class CreateMovieNights < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_nights do |t|
      t.string :genre
      t.string :runtime
    end
  end
end
