require_relative './movie.rb'
require_relative './movie_night.rb'
require_relative './movie_pick.rb'

class MovieNightApp 


    def initialize
        @genres = ["Action", "Adventure", "Animation", "Biography", "Comedy", "Crime", "Drama", "Family", "Fantasy", "Film-Noir", "History", "Horror", "Music", "Musical", "Mystery", "Romance", "Sci-Fi", "Sport", "Thriller", "War", "Western"]
        @runtime = []
        @release_year = []
    end

    def welcome
        puts "Welcome to Movie Night!"
    end

    def genre_query
        # puts @genres
        puts "What genre are you interested in?"
        user_genre = gets.chomp
    end

    def runtime_query
        puts "How long do you have to watch a movie?"
        user_runtime = gets.chomp
    end

    def release_year_query
        puts "When would you like your movie to have been released?"
        user_release_year = gets.chomp
    end

    def run
        welcome
        genre_query
        runtime_query
        release_year_query
    end

end