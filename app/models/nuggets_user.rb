class NuggetsUser < ApplicationRecord
    belongs_to :user
    belongs_to :nugget
    get_primary_key :id

end