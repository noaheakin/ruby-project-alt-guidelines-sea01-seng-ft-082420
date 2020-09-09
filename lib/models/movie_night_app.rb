require_relative './movie.rb'
require_relative './movie_night.rb'
require_relative './movie_pick.rb'
require 'pry'


class MovieNightApp

    def initialize
        @genres = ["Action/Adventure", "Comedy", "Drama", "Family", "Fantasy", "Horror", "Musical", "Romance", "Sci-Fi", "Sport", "Thriller", "War", "Western"]
        @runtime = ["1 - 1.5 hours", "1.5 - 2 hours", "2 - 2.5 hours", "over 2.5 hours"]
        @genres_array = []
        @genres_and_runtimes_array = []
    end

    def welcome
        puts "Welcome to Movie Night!"
    end

    def genre_query
        puts "What genre are you interested in?"
        @genres.each_with_index {|value, key| puts "#{key+=1}. #{value}"}
        user_genre_input = gets.chomp.to_i
        user_genre = @genres[user_genre_input -= 1]
        genre_movies = Movie.all.select {|movie| movie.genre == user_genre}
        @genres_array += genre_movies
    end

    def runtime_query
        puts "How long do you have to watch a movie?"
        @runtime.each_with_index {|value, key| puts "#{key+=1}. #{value}"}    
        user_runtime_input = gets.chomp.to_i
        user_runtime = @runtime[user_runtime_input -= 1]
        runtime_movies = @genres_array.select {|movie| movie.runtime == user_runtime}
        @genres_and_runtimes_array += runtime_movies
        puts @genres_and_runtimes_array.map {|movie| movie.title}
    end

    # def release_year_query
    #     puts "When would you like your movie to have been released?"
    #     user_release_year = gets.chomp
    # end

    def run
        welcome
        genre_query
        runtime_query
        # release_year_query
    end

end