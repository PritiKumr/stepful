class User < ApplicationRecord
  enum role: { coach: 0, student: 1 }

  has_many :coach_slots, class_name: "Slot", foreign_key: :coach_id
  has_many :student_slots, class_name: "Slot", foreign_key: :student_id
end
