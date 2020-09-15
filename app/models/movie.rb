class Movie < ActiveRecord::Base
    def self.all_ratings
  	    self.all.pluck(:rating).uniq.sort
    end
end
