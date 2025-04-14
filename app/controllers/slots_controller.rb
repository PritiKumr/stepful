class SlotsController < ApplicationController
  before_action :set_slot, only: [:show, :edit, :update, :destroy, :book, :confirm_booking]
  before_action :ensure_coach, only: [:new, :create, :edit, :update, :destroy]
  before_action :ensure_student, only: [:book, :confirm_booking]

  def index
    @slots = current_user.coach_slots.upcoming.order(:start_time)
  end

  def past_sessions
    if current_user.coach?
      @slots = current_user.coach_slots.past.order(start_time: :desc)
    else
      redirect_to root_path, alert: "Only coaches can view past sessions."
    end
  end

  def show
    # If the current user is neither the coach nor the student for this slot
    if !current_user.coach? && current_user != @slot.student
      redirect_to root_path, alert: "You don't have permission to view this slot."
    end
  end

  def new
    @slot = Slot.new
  end

  def create
    @slot = Slot.new(slot_params)
    @slot.coach = current_user

    if @slot.save
      redirect_to root_path, notice: "Slot was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if @slot.coach != current_user
      redirect_to root_path, alert: "You can only edit your own slots."
      return
    end
    
    if @slot.student.present?
      redirect_to root_path, alert: "You cannot edit a slot that has been booked."
      return
    end
  end

  def update
    if @slot.coach != current_user
      redirect_to root_path, alert: "You can only update your own slots."
      return
    end
    
    if @slot.student.present?
      redirect_to root_path, alert: "You cannot update a slot that has been booked."
      return
    end
    
    if @slot.update(slot_params)
      redirect_to root_path, notice: "Slot was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @slot.coach != current_user
      redirect_to root_path, alert: "You can only delete your own slots."
      return
    end
    
    @slot.destroy
    redirect_to root_path, notice: "Slot was successfully deleted."
  end

  def book
    if @slot.student.present?
      redirect_to root_path, alert: "This slot has already been booked."
    end
  end

  def confirm_booking
    if @slot.student.present?
      redirect_to root_path, alert: "This slot has already been booked."
      return
    end

    @slot.student = current_user
    
    if @slot.save
      redirect_to root_path, notice: "Slot was successfully booked."
    else
      render :book, status: :unprocessable_entity
    end
  end

  private

  def set_slot
    @slot = Slot.find(params[:id])
  end

  def slot_params
    params.require(:slot).permit(:start_time)
  end

  def ensure_coach
    unless current_user.coach?
      redirect_to root_path, alert: "Only coaches can manage slots."
    end
  end

  def ensure_student
    unless current_user.student?
      redirect_to root_path, alert: "Only students can book slots."
    end
  end
end
