class NotesController < ApplicationController
  before_action :set_slot
  before_action :ensure_coach
  before_action :ensure_completed_slot
  before_action :ensure_coach_owns_slot

  def new
  end

  def create
    if @slot.update(note_params)
      redirect_to root_path, notice: "Notes were successfully recorded."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_slot
    @slot = Slot.find(params[:slot_id])
  end

  def note_params
    params.require(:slot).permit(:satisfaction_score, :notes)
  end

  def ensure_coach
    unless current_user.coach?
      redirect_to root_path, alert: "Only coaches can record notes."
    end
  end

  def ensure_completed_slot
    unless @slot.start_time < Time.current
      redirect_to root_path, alert: "You can only record notes for completed sessions."
    end
  end

  def ensure_coach_owns_slot
    unless @slot.coach == current_user
      redirect_to root_path, alert: "You can only record notes for your own sessions."
    end
  end
end
