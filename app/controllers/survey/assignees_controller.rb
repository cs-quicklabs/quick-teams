class Survey::AssigneesController < Survey::BaseController
    before_action :set_survey, only: [:index, :create, :destroy]
    def index
            authorize [:survey,:assignee]
     if @survey.project?
      @pagy, @assignees = pagy_nil_safe(params, Project.where(kpi_id:@survey), items:LIMIT)
      @assigns= Project.where.not(kpi_id:@survey).or(Project.where(kpi_id:nil))
     else
     @pagy, @assignees=pagy_nil_safe(params,User.where(kpi_id:@survey.id), items:LIMIT)
      @assigns= User.where.not(kpi_id:@survey).or(User.where(kpi_id:nil))
     end
    end

    def create
         authorize [:survey,:assignee]
        if @survey.project?
            Project.where(id:params[:assign_id]).update(kpi_id:@survey.id)
        else
            User.where(id:params[:assign_id]).update(kpi_id:@survey.id)
        end
        redirect_to survey_assignees_path(@survey)
    end

    def destroy
         authorize [:survey,:assignee]
        if @survey.project?
            Project.where(id:params[:id]).update(kpi_id:nil)
        else
            User.where(id:params[:id]).update(kpi_id:nil)
        end
        redirect_to survey_assignees_path(@survey)
    end
    private

     def set_survey
        @survey = Survey::Survey.find(params[:survey_id])
    end
     def assignee_params
    params.permit(:assign_id)
  end

end