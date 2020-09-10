class User < ActiveRecord::Base

    has_many :movie_nights
    has_many :movies, through: :movie_nights
    
    has_many :tv_show_nights
    has_many :tv_shows, through: :tv_show_nights

end