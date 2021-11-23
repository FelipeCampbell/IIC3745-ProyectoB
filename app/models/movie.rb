class Movie < ApplicationRecord
    has_many :screenings
    has_many :planners

    accepts_nested_attributes_for :planners
    accepts_nested_attributes_for :screenings

end
