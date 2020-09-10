require_relative './tv_show.rb'
require_relative './tv_show_night.rb'
require_relative './user.rb'
require 'pry'


class TvShowNightApp

    def initialize
        @seasons = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        @seasons_array = []
        @current_user_id = []
    end

    def welcome
        puts "Welcome to Tv Show Night!"
    end

    def user_name
        puts "Who is watching a tv show?"
        users = User.all.map {|user| user.name}.sort
        users << "*** I'm a new user ***"
        final_users = users.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_name_input = gets.chomp.to_i
        chosen_user = final_users[user_name_input -= 1]
        if chosen_user == "*** I'm a new user ***"
            create_user
        else
            user_instance = User.find_by(name: chosen_user)
            @current_user_id << user_instance.id
            puts "Welcome back, #{chosen_user}!"
        end
    end

    def create_user
        puts "Please enter a username"
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
            puts "That is not a valid response"
            create_user
        end
    end

    def seasons_query
        puts "How many seasons do you want the show to have?"
        @seasons.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
        user_season_input = gets.chomp.to_i
        if !(1..@seasons.count).include? (user_season_input)
            puts "That's not a valid option"
            seasons_query
        end
        user_season = @seasons[user_season_input -= 1]
        season_shows = TvShow.all.select {|show| show.seasons == user_season}
        @seasons_array += season_shows
    end

    # def runtime_query
    #     puts "How long do you have to watch a movie?"
    #     @runtime.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}    
    #     user_runtime_input = gets.chomp.to_i
    #     if !(1..@runtime.count).include? (user_runtime_input)
    #         puts "That's not a valid option"
    #         runtime_query
    #     end
    #     user_runtime = @runtime[user_runtime_input -= 1]
    #     runtime_movies = @genres_array.select {|movie| movie.runtime == user_runtime}
    #     @genres_and_runtimes_array += runtime_movies
    # end

    def make_a_choice
        options_array = @seasons_array.map {|show| show.title}.uniq
        options_array << "*** Pick for me! ***"
        if options_array.count == 1
            no_show_match
        else
            puts "Please select a show from the following:"
            final_options = options_array.each_with_index {|value, key| puts "(#{key+=1}) #{value}"}
            user_choice_input = gets.chomp.to_i
            user_choice = final_options[user_choice_input -= 1]
            if user_choice == "*** Pick for me! ***"  
                auto_pick    
            else 
                show_instance = TvShow.find_by(title: user_choice)
                tv_show_night = TvShowNight.create(tv_show_id: show_instance.id, user_id: @current_user_id[0], watchtime: Time.now)
                puts "Great choice! We hope you enjoy #{user_choice}!"
            end
        end
    end

    def auto_pick
        random_pick = @seasons_query.sample
        tv_show_night = TvShowNight.create(tv_show_id: random_pick.id, user_id: @current_user_id[0], watchtime: Time.now)
        puts "We've got you! Enjoy '#{random_pick.title}'!"

    end

    def no_show_match
        puts "Sorry, there are no show matches. Let's try that again!"
        seasons_query
        # runtime_query
        make_a_choice
    end

    def run
        welcome
        user_name
        seasons_query
        # runtime_query
        make_a_choice
    end

end