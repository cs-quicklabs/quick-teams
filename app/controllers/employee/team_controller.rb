class Employee::TeamController < Employee::BaseController
  def index
    authorize [@employee, Team]
@manager=Array.new
    @subordinates = @employee.subordinates.includes(:role, :discipline, :job).order(:first_name)
    if @employee.manager.present?
    @user=@employee
    loop do
        @manager.push(@user.manager) 
         @user = @user.manager 
         if !@user.manager.present?
          break
         end
     end
    end
    fresh_when @subordinates + [@employee]
  end
end
