class User < ActiveRecord::Base

    has_many :movie_nights
    has_many :movies, through: :movie_nights

end