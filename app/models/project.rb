class Project < ActiveRecord::Base
  attr_accessible :description, :link, :name, :picture_link
end
