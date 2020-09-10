class Movie < ActiveRecord::Base
    
    has_many :movie_nights
    has_many :users, through: :movie_nights

end