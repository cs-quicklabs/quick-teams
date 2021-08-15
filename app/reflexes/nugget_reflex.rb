class NuggetReflex < ApplicationReflex
    def publish
      nugget = Nugget.find(element.dataset["nugget-id"])
      nugget.update(published: true)
      nugget.save!
    end
  
    def unpublish
      nugget = Nugget.find(element.dataset["nugget-id"])
      nugget.update(published: false)
      nugget.save!
    end 
    
  def read
    nugget = NuggetsUser.where(nugget_id: element.dataset["nugget-id"]).where(user_id: element.dataset["employee-id"])
    nugget.update(read: true)
  end
end
