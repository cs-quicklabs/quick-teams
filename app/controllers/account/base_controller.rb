class Account::BaseController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  rescue_from ActiveRecord::InvalidForeignKey, with: :show_referenced_alert

  def show_referenced_alert(exception)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("modal", partial: "shared/modal", locals: { title: "Unable to Delete Record", message: "This record has been associated with other records in system therefore deleting this might result in unexpected behavior. If you want to delete this please make sure all assosications have been removed first.", main_button_visible: false })
      }
    end
  end
end
