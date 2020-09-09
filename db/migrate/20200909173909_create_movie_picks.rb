class CreateMoviePicks < ActiveRecord::Migration[5.2]
  def change 
    create_table :movie_picks do |t|
      t.string :movie
      t.string :movie_night
    end
  end
end
