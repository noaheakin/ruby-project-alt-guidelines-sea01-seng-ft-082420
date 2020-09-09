require_relative './movie.rb'
require_relative './movie_night.rb'
require_relative './user.rb'
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

    def user_name
        puts "Who is watching a movie?"
        users = User.all.map {|user| user.name}.sort
        users << "*** I'm a new user ***"
        final_users = users.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_name_input = gets.chomp.to_i
        chosen_user = final_users[user_name_input -= 1]
        if chosen_user == "*** I'm a new user ***"
            create_user
        else
            puts "Welcome back, #{chosen_user}!"
        end
    end

    def create_user
        puts "Please enter a username"
        user_name_input = gets.chomp
        new_user = User.new(name: user_name_input)
        puts "#{user_name_input} - is this correct? (Y/N)"
        confirm = gets.chomp
        if confirm == "Y"
            new_user.save
        elsif confirm == "N"
            create_user
        else
            puts "That is not a valid response"
            create_user
        end
    end


    def genre_query
        puts "What genre are you interested in?"
        @genres.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_genre_input = gets.chomp.to_i
        user_genre = @genres[user_genre_input -= 1]
        genre_movies = Movie.all.select {|movie| movie.genre == user_genre}
        @genres_array += genre_movies
    end

    def runtime_query
        puts "How long do you have to watch a movie?"
        @runtime.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}    
        user_runtime_input = gets.chomp.to_i
        user_runtime = @runtime[user_runtime_input -= 1]
        runtime_movies = @genres_array.select {|movie| movie.runtime == user_runtime}
        @genres_and_runtimes_array += runtime_movies
    end

    def make_a_choice
        puts "Please select a movie from the following:"
        options_array = @genres_and_runtimes_array.map {|movie| movie.title}
        options_array << "*** Pick for me! ***"
        final_options = options_array.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_choice_input = gets.chomp.to_i
        user_choice = final_options[user_choice_input -= 1]
        if user_choice == "*** Pick for me! ***"
            puts "We've got you! Enjoy #{@genres_and_runtimes_array.sample.title}!"  
        else 
            puts "Great choice! We hope you enjoy #{user_choice}!"
        end
    end
    
    # def release_year_query
    #     puts "When would you like your movie to have been released?"
    #     user_release_year = gets.chomp
    # end

    def run
        welcome
        user_name
        genre_query
        runtime_query
        make_a_choice
        # release_year_query
    end

end