class Report::SkillsController < Report::BaseController
    def index
      authorize :report
      @skills = Skill.all
      @ids = params[:ids]
      @skill_reports = ""
        @ids = params[:ids].kind_of?(Array) ? params[:ids].map(&:to_i) : [params[:ids].to_i]
        @employees = User.includes(:job, :role, :skills).joins(:skills_users).where('skills_users.skill_id IN (?)', @ids).uniq.reject(&:blank?)
      
        @employees = @employees.select { |employee|
        (employee.skill_ids & @ids).sort == @ids.sort
    }
   
  
        @pagy, @skill_reports =  pagy_nil_safe(@employees.reject(&:blank?)) 
  
      render_partial("report/skills/list", collection: @skill_reports, cached: false)

    end
    end

  
