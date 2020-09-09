class User < ActiveRecord::Base

    belongs_to :movie_night_app
    belongs_to :movie 
    belongs_to :movie_night

end