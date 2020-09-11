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
        puts "\n -------------------------\n| Welcome to Movie Night! |\n -------------------------\n"
    end

    def user_name
        puts "\n---Who is watching a movie?---\n\n"
        users_array = User.all.map {|user| user.name}.sort
        users_array << "*** Create new user ***"
        users_array << "**** View user options ****"
        final_users = users_array.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_name_input = gets.chomp.to_i
        if !(1..users_array.count).include? (user_name_input)
            puts "\n*That is not a valid option*\n"
            user_name
        else
            chosen_user = final_users[user_name_input -= 1]
            if chosen_user == "*** Create new user ***"
                create_user
            elsif chosen_user == "**** View user options ****"
                user_options 
            else
                user_instance = User.find_by(name: chosen_user)
                @current_user_id << user_instance.id
                puts "\n*Welcome back, #{chosen_user}!*\n"
            end
        end
    end

    def create_user
        puts "\n---Please enter a username---"
        user_name_input = gets.chomp
        new_user = User.new(name: user_name_input)
        puts "\n---#{user_name_input} - is this correct? (Y/N)---"
        user_input = gets.chomp.upcase
        if user_input == "Y" || user_input == "YES"
            new_user.save
            puts "\n*New user '#{new_user.name}' successfully created!*\n"
            user_name
        elsif user_input == "N" || user_input == "NO"
            create_user
        else
            puts "\n*That is not a valid response*\n"
            create_user
        end
    end

    def user_options
        puts "\n---Which user would you like to look at?---\n\n"
        users = User.all.map {|user| user.name}.sort
        final_users = users.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_modify_input = gets.chomp.to_i
        if !(1..users.count).include? (user_modify_input)
            puts "\n*That is not a valid option*\n"
            user_options
        else
            chosen_user = final_users[user_modify_input -= 1]
            target_user = User.find_by(name: chosen_user)
            @user_to_change << target_user.id
            modify_choices
        end
    end

    def modify_choices
        user = User.find_by(id: @user_to_change.last)
        puts "\n---#{user.name}, what would you like to do?---\n\n"
        puts "(1) View movie history"
        puts "(2) Change username"
        puts "(3) Delete user"
        puts "(4) Return to user list"
        user_options_input = gets.chomp
        if user_options_input == "1"
            user_history
        elsif user_options_input == "2"
            update_user
        elsif user_options_input == "3" 
            delete_user
        elsif user_options_input == "4"
            user_name
        else
            puts "\n*That is not a valid option*\n"
            modify_choices
        end
    end

    def user_history
        user = User.find_by(id: @user_to_change.last)
        if user.movies.count == 0
            puts "\n*No movies yet, time to start watching!*"
            user_options
        else
            puts "\n---Here are all of the movies #{user.name} has watched:---\n\n"
            user.movies.each_with_index {|movie, key| puts "(#{key+=1}) #{movie.title}"}
            puts "\n*Wow, look at that!*"
            user_options
        end
    end

    def update_user
        puts "\n---Please enter a new username---"
        user_name_input = gets.chomp
        user = User.find_by(id: @user_to_change.last)
        user.update(name: user_name_input)
        puts "\n*Succesfully changed username to #{user_name_input}!*\n"
        user_name
    end

    def delete_user
        puts "\n---Are you sure you want to delete this user? (Y/N)---"
        user_input = gets.chomp.upcase
        if user_input == "Y" || user_input == "YES"
            user = User.find_by(id: @user_to_change.last)
            name = user.name
            user.destroy
            puts "\n*Succesfully deleted #{name}*\n\n"
            user_name
        elsif user_input == "N" || user_input == "NO"
            modify_choices
        else
            puts "\n*That is not a valid response*\n"
            delete_user
        end
    end

    def genre_query
        puts "\n---What genre are you interested in?---\n\n"
        @genres.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_genre_input = gets.chomp.to_i
        if !(1..@genres.count).include? (user_genre_input)
            puts "\n*That is not a valid option*\n"
            genre_query
        else
            user_genre = @genres[user_genre_input -= 1]
            genre_movies = Movie.all.select {|movie| movie.genre == user_genre}
            @genres_array += genre_movies
        end
    end

    def runtime_query
        puts "\n---How long do you have to watch a movie?---\n\n"
        @runtime.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}    
        user_runtime_input = gets.chomp.to_i
        if !(1..@runtime.count).include? (user_runtime_input)
            puts "\n*That is not a valid option*\n"
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
            puts "\n---Please select a movie from the following:---\n\n"
            final_options = options_array.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
            user_options_input = gets.chomp.to_i
            if !(1..options_array.count).include? (user_options_input)
                puts "\n*That is not a valid option*\n"
                make_a_choice
            else
                user_choice = final_options[user_options_input -= 1]
                if user_choice == "*** Pick for me! ***"  
                    auto_pick    
                else 
                    movie_instance = Movie.find_by(title: user_choice)
                    movie_night = MovieNight.create(movie_id: movie_instance.id, user_id: @current_user_id[0], showtime: Time.now)
                    puts "\n-*-*-* Great choice! We hope you enjoy '#{user_choice}'! *-*-*-\n\n"
                end
            end
        end
    end

    def auto_pick
        random_pick = @genres_and_runtimes_array.sample
        movie_night = MovieNight.create(movie_id: random_pick.id, user_id: @current_user_id[0], showtime: Time.now)
        puts "\n-*-*-* We've got you! Enjoy '#{random_pick.title}'! *-*-*-\n\n"

    end

    def no_movie_match
        puts "\n*Sorry, there are no movie matches. Let's try that again!*\n\n"
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