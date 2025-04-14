class Slot < ApplicationRecord
  belongs_to :coach, class_name: "User"
  belongs_to :student, class_name: "User", optional: true

  validates :start_time, presence: true
  validates :satisfaction_score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
  validate :no_overlapping_slots

  scope :upcoming, -> { where("start_time > ?", Time.current).order(:start_time) }
  scope :past, -> { where("start_time < ?", Time.current).order(start_time: :desc) }
  scope :available, -> { where(student_id: nil).where("start_time > ?", Time.current).order(:start_time) }

  def end_time
    start_time + 2.hours
  end

  private

  def no_overlapping_slots
    return unless coach && start_time

    overlapping_slots = coach.coach_slots
                             .where.not(id: id) # Exclude self when updating
                             .where("start_time < ? AND start_time + INTERVAL '2 hours' > ?", 
                                   end_time, start_time)
    
    if overlapping_slots.exists?
      errors.add(:start_time, "overlaps with another slot you have scheduled")
    end
  end
end
