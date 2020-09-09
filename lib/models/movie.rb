class Movie < ActiveRecord::Base
    
    belongs_to :movie_night_app
    
    has_many :movie_picks
    has_many :movie_nights, through: :movie_picks

end