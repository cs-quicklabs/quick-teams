class JobCardsController < ApplicationController
  before_action :set_job_card, only: [:show, :update, :destroy]
  before_action :set_user, only: [:create]

  def create
    @job_card = JobCard.new(job_card_params)
    
    if @job_card.save
      render json: { 
        id: @job_card.id,
        title: @job_card.title,
        slot_length: @job_card.slot_length,
        message: 'Job card created successfully'
      }, status: :created
    else
      render json: { errors: @job_card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update

    if @job_card.update(job_card_params)
      render json: { 
        id: @job_card.id,
        message: 'Job card updated successfully' 
      }, status: :ok
    else
      render json: { errors: @job_card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show

    render json: @job_card
  end
  
  def destroy

    @job_card.destroy
    render json: { message: 'Job card deleted successfully' }, status: :ok
  end

  private

  def set_job_card
    @job_card = JobCard.find(params[:id])
  end

  def job_card_params
    params.require(:job_card).permit(:title, :description, :date, :session, :slot_start, :slot_length, :user_id)
  end

  def set_user 
    @user = User.find(params[:job_card][:user_id])
  end
end
