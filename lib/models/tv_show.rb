class TvShow < ActiveRecord::Base
    has_many :tv_show_nights
    has_many :users, through: :tv_show_nights
end