class KbController < BaseController
  include Pagy::Backend
    before_action :set_kb, only: %i[show destroy edit update]
  
    def index
      authorize :kb
  
      @kb = Kb.new
      @pagy, @kbs = pagy(current_user.kbs.includes(:discipline, :user, :job).order(created_at: :desc), items: 10)
  
      render_partial("kb/kb", collection: @kbs) 
    end

  def new
    authorize :kb
    @kb = Kb.new
  end
  
    def create
      authorize :kb
  
      @knowledge = AddKb.call(kb_params, current_user).result
      respond_to do |format|
        if @knowledge.errors.empty?
          format.html { redirect_to kb_index_path, notice: "Knowledge Base was successfully Added." }
        else
          format.html { redirect_to new_kb_path, alert: "Failed to add knowledge base. Please try again." }
        end
      end
    end
  
    def edit
      authorize @kb
    end
  
    def update
      authorize @kb
  
      respond_to do |format|
        if @kb.update(kb_params)
          format.html { redirect_to kb_index_path, notice: "Knowledge Base was successfully updated." }
        else
          format.html { redirect_to edit_kb_path(@kb), alert: "Failed to update. Please try again." }
        end
      end
    end
  
    def destroy
      authorize @kb
  
      @kb.destroy
      Event.where(trackable: @kb).touch_all #fixes cache issues in activity
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@kb) }
      end
    end
  
    private
  
    def set_kb
      @kb ||= Kb.find(params["id"])
    end
  
    def kb_params
      params.require(:kb).permit(:document, :link, :job_id, :discipline_id, :tag, :user_id )
    end
  end
  