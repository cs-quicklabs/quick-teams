class Employee::TeamController < Employee::BaseController
  def index
    authorize [@employee, Team]
    @manager = Array.new
    @subordinates = @employee.subordinates.includes(:role, :discipline, :job).order(:first_name)
    index = 0
    if @employee.manager.present?
      @user = @employee
      until index > 1
        @manager.push(@user.manager)
        @user = @user.manager
        index += 1
        if !@user.manager.present?
          break
        end
      end
    end
    fresh_when @subordinates + [@employee]
    render_partial("employee/team/manager", collection: @manager) if stale?(@manager)
  end
end
