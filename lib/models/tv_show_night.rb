class TvShowNight < ActiveRecord::Base
    belongs_to :tv_show
    belongs_to :user
end