class Report::KbsController < Report::BaseController
    def index
      authorize :report
  
      kbs = Kb.includes(:user, :discipline, :job).query(kbs_filter_params, nil, created_at: :desc )
    
      @pagy, @kbs = pagy_nil_safe(kbs , items: LIMIT)
      render_partial("report/kbs/kb", collection: @kbs, cached: false)
    end
    private
  
    def kbs_filter_params
      params.permit(*KbFilter::KEYS)
    end
  end
  