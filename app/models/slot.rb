class Slot < ApplicationRecord
  belongs_to :coach, class_name: "User"
  belongs_to :student, class_name: "User", optional: true

  validates :start_time, presence: true

  def end_time
    start_time + 2.hours
  end
end