require_relative './tv_show.rb'
require_relative './tv_show_night.rb'
require_relative './user.rb'
require 'pry'


class TvShowNightApp

    def initialize
        @seasons = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        @seasons_array = []
        @current_user_id = []
        @user_to_change = []
    end

    def welcome
        puts "\n -------------------------\n| Welcome to Tv Show Night! |\n -------------------------\n\n"
    end

    def user_name
        puts "Who is watching a tv show?\n"
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
            puts "Welcome back, #{chosen_user}!\n"
        end
    end

    def create_user
        puts "Please enter a username\n"
        user_name_input = gets.chomp
        new_user = User.new(name: user_name_input)
        puts "#{user_name_input} - is this correct? (Y/N)"
        confirm = gets.chomp.upcase
        if confirm == "Y" || confirm == "YES"
            new_user.save
            puts "Hello, #{new_user.name}!"
            @current_user_id << new_user.id
        elsif confirm == "N" || confirm == "NO"
            create_user
        else
            puts "That is not a valid response\n"
            create_user
        end
    end

    def modify_user
        puts "\nWhich user would you like to modify\n"
        users = User.all.map {|user| user.name}.sort
        final_users = users.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_modify_input = gets.chomp.to_i
        chosen_user = final_users[user_modify_input -= 1]
        target_user = User.find_by(name: chosen_user)
        @user_to_change << target_user.id
        puts "\n#{chosen_user}, what would you like to do?\n"
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
            puts "That is not a valid response\n"
            modify_choices
        end
    end

    def update_user
        puts "\nPlease enter a new username\n"
        user_name_input = gets.chomp
        user = User.find_by(id: @user_to_change)
        user.update(name: user_name_input)
        puts "Succesfully changed username to #{user_name_input}.\n"
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
            puts "That is not a valid response\n"
            delete_user
        end
    end

    def seasons_query
        puts "How many seasons do you want the show to have?\n"
        @seasons.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_season_input = gets.chomp.to_i
        if !(1..@seasons.count).include? (user_season_input)
            puts "That's not a valid option"
            seasons_query
        else
            user_season = @seasons[user_season_input -= 1]
            season_shows = TvShow.all.select {|show| show.seasons == user_season}
            @seasons_array += season_shows
        end
    end

    def make_a_choice
        options_array = @seasons_array.map {|show| show.title}.uniq
        options_array << "*** Pick for me! ***"
        if options_array.count == 1
            no_show_match
        else
            puts "Please select a show from the following:\n"
            final_options = options_array.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
            user_choice_input = gets.chomp.to_i
            if !(1..options_array.count).include? (user_options_input)
                puts "That's not a valid option\n"
                make_a_choice
            else
                user_choice = final_options[user_choice_input -= 1]
                if user_choice == "*** Pick for me! ***"  
                    auto_pick    
                else 
                    show_instance = TvShow.find_by(title: user_choice)
                    tv_show_night = TvShowNight.create(tv_show_id: show_instance.id, user_id: @current_user_id[0], watchtime: Time.now)
                    puts "Great choice! We hope you enjoy #{user_choice}!\n"
                end
            end
        end
    end

    def auto_pick
        random_pick = @seasons_query.sample
        tv_show_night = TvShowNight.create(tv_show_id: random_pick.id, user_id: @current_user_id[0], watchtime: Time.now)
        puts "We've got you! Enjoy '#{random_pick.title}'!\n"

    end

    def no_show_match
        puts "Sorry, there are no show matches. Let's try that again!\n"
        seasons_query
        make_a_choice
    end

    def run
        welcome
        user_name
        seasons_query
        make_a_choice
    end

end