require_relative './movie.rb'
require_relative './movie_night.rb'
require_relative './movie_pick.rb'


class MovieNightApp 


    def initialize
        @genres = ["Action/Adventure", "Comedy", "Drama", "Family", "Fantasy", "Horror", "Musical", "Romance", "Sci-Fi", "Sport", "Thriller", "War", "Western"]
        @runtime = ["1 - 1.5 hours", "1.5 - 2 hours", "2 - 2.5 hours", "over 2.5 hours"]
    end

    def welcome
        puts "Welcome to Movie Night!"
    end

    def genre_query
        puts "What genre are you interested in?"
        @genres.each_with_index {|value, key| puts "#{key+=1}. #{value}"}
<<<<<<< HEAD
        user_genre = gets.chomp
=======
        user_genre_input = gets.chomp
        user_genre = @genres[user_genre_input -= 1]
        genre_array = Movie.all.select {|movie| movie.genre == user_genre}
>>>>>>> 0e7da873ba63d8c5186f3cc71a69228f0f7a870e
    end

    def runtime_query
        puts "How long do you have to watch a movie?"
        @runtime.each_with_index {|value, key| puts "#{key+=1}. #{value}"}
        user_runtime = gets.chomp
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