require_relative './movie.rb'
require_relative './movie_night.rb'
require_relative './user.rb'
require 'pry'


class MovieNightApp

    def initialize
        @genres = ["Action/Adventure", "Comedy", "Drama", "Family", "Fantasy", "Horror", "Musical", "Romance", "Sci-Fi", "Thriller", "Western"]
        @runtime = ["1 - 1.5 hours", "1.5 - 2 hours", "2 - 2.5 hours", "over 2.5 hours"]
        @genres_array = []
        @genres_and_runtimes_array = []
        @current_user_id = []
        @user_to_change = []
    end

    def welcome
        puts "\n -------------------------\n| Welcome to Movie Night! |\n -------------------------\n\n"
    end

    def user_name
        puts "Who is watching a movie?\n\n"
        users = User.all.map {|user| user.name}.sort
        users << "*** I'm a new user ***"
        users << "**** Modify a user ****"
        final_users = users.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_name_input = gets.chomp.to_i
        chosen_user = final_users[user_name_input -= 1]
        if chosen_user == "*** I'm a new user ***"
            create_user
        elsif chosen_user == "**** Modify a user ****"
            modify_user 
        else
            user_instance = User.find_by(name: chosen_user)
            @current_user_id << user_instance.id
            puts "\nWelcome back, #{chosen_user}!\n\n"
        end
    end

    def create_user
        puts "\nPlease enter a username"
        user_name_input = gets.chomp
        new_user = User.new(name: user_name_input)
        puts "\n#{user_name_input} - is this correct? (Y/N)"
        user_input = gets.chomp.upcase
        if user_input == "Y" || user_input == "YES"
            new_user.save
            puts "\nHello, #{new_user.name}!\n\n"
            @current_user_id << new_user.id
        elsif user_input == "N" || user_input == "NO"
            create_user
        else
            puts "\nThat is not a valid response\n\n"
            create_user
        end
    end

    def modify_user
        puts "\nWhich user would you like to modify"
        users = User.all.map {|user| user.name}.sort
        final_users = users.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_modify_input = gets.chomp.to_i
        chosen_user = final_users[user_modify_input -= 1]
        target_user = User.find_by(name: chosen_user)
        @user_to_change << target_user.id
        puts "\n#{chosen_user}, what would you like to do?"
        modify_choices
    end

    def modify_choices
        puts "(1) Change username"
        puts "(2) Delete user"
        puts "(3) Return to user list"
        user_options_input = gets.chomp
        if user_options_input == "1"
            update_user
        elsif user_options_input == "2" 
            delete_user
        elsif user_options_input == "3"
            user_name
        else
            puts "That is not a valid response"
            modify_choices
        end
    end

    def update_user
        puts "\nPlease enter a new username"
        user_name_input = gets.chomp
        user = User.find_by(id: @user_to_change)
        user.update(name: user_name_input)
        puts "Succesfully changed username to #{user_name_input}."
        user_name
    end

    def delete_user
        puts "\nAre you sure you want to delete this user? (Y/N)"
        user_input = gets.chomp.upcase
        if user_input == "Y" || user_input == "YES"
            user = User.find_by(id: @user_to_change)
            name = user.name
            user.destroy
            puts "Succesfully deleted #{name}."
            user_name
        elsif user_input == "N" || user_input == "NO"
            modify_choices
        else
            puts "That is not a valid response"
            delete_user
        end
    end

    def genre_query
        puts "What genre are you interested in?\n\n"
        @genres.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_genre_input = gets.chomp.to_i
        if !(1..@genres.count).include? (user_genre_input)
            puts "\nThat's not a valid option\n\n"
            genre_query
        else
            user_genre = @genres[user_genre_input -= 1]
            genre_movies = Movie.all.select {|movie| movie.genre == user_genre}
            @genres_array += genre_movies
        end
    end

    def runtime_query
        puts "\nHow long do you have to watch a movie?\n\n"
        @runtime.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}    
        user_runtime_input = gets.chomp.to_i
        if !(1..@runtime.count).include? (user_runtime_input)
            puts "\nThat's not a valid option\n"
            runtime_query
        else
            user_runtime = @runtime[user_runtime_input -= 1]
            runtime_movies = @genres_array.select {|movie| movie.runtime == user_runtime}
            @genres_and_runtimes_array += runtime_movies
        end
    end

    def make_a_choice
        options_array = @genres_and_runtimes_array.map {|movie| movie.title}.uniq
        options_array << "*** Pick for me! ***"
        if options_array.count == 1
            no_movie_match
        else
            puts "\nPlease select a movie from the following:\n\n"
            final_options = options_array.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
            user_options_input = gets.chomp.to_i
            if !(1..options_array.count).include? (user_options_input)
                puts "\nThat's not a valid option\n"
                make_a_choice
            else
                user_choice = final_options[user_options_input -= 1]
                if user_choice == "*** Pick for me! ***"  
                    auto_pick    
                else 
                    movie_instance = Movie.find_by(title: user_choice)
                    movie_night = MovieNight.create(movie_id: movie_instance.id, user_id: @current_user_id[0], showtime: Time.now)
                    puts "\nGreat choice! We hope you enjoy '#{user_choice}'!\n\n"
                end
            end
        end
    end

    def auto_pick
        random_pick = @genres_and_runtimes_array.sample
        movie_night = MovieNight.create(movie_id: random_pick.id, user_id: @current_user_id[0], showtime: Time.now)
        puts "\nWe've got you! Enjoy '#{random_pick.title}'!\n\n"

    end

    def no_movie_match
        puts "\nSorry, there are no movie matches. Let's try that again!\n\n"
        genre_query
        runtime_query
        make_a_choice
    end

    def run
        welcome
        user_name
        genre_query
        runtime_query
        make_a_choice
    end

end