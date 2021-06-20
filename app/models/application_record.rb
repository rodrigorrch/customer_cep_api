class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  per_page = 20
end
