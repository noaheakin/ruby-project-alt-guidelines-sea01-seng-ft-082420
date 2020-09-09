class MovieNight < ActiveRecord::Base

    belongs_to :movie_night_app

    has_many :movie_picks
    has_many :movies, through: :movie_picks

end