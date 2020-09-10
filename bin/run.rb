require_relative '../config/environment'
require_relative '../lib/models/movie_night_app.rb'
require_relative '../lib/models/tv_show_night_app.rb'

puts "Would you like to watch a movie or tv show (M/T)"
user_input = gets.chomp.upcase
if user_input == "M" || user_input == "MOVIE"
    MovieNightApp.new.run
elsif user_input == "T" || user_input == "TVSHOW"
    TvShowNightApp.new.run
end
