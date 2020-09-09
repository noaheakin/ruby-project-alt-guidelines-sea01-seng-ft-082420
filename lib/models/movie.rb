class Movie < ActiveMigration::Base

    attr_accessor :title, :genre, :runtime, :release_year

    def initialize (title:, genre:, runtime:, release_year:)
        @genre = genre
        @runtime = runtime
        @release_year = release_year
    end
end