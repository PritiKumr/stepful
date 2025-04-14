# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🌱 Seeding database..."

User.destroy_all
Slot.destroy_all

coach_1 = User.create!(name: "Coach Carter", phone_number: "555-1111", role: :coach)
coach_2 = User.create!(name: "Coach Taylor", phone_number: "555-2222", role: :coach)

student_1 = User.create!(name: "Student Asha", phone_number: "555-3333", role: :student)
student_2 = User.create!(name: "Student Ben", phone_number: "555-4444", role: :student)
student_3 = User.create!(name: "Student Clara", phone_number: "555-5555", role: :student)

start_time = Time.current.beginning_of_hour + 1.hour

3.times do |i|
  Slot.create!(
    coach: coach_1,
    start_time: start_time + i.days
  )

  Slot.create!(
    coach: coach_2,
    start_time: start_time + i.days + 3.hours
  )
end

[
  [coach_1, student_1, 2.days.ago],
  [coach_2, student_2, 1.day.ago],
  [coach_1, student_3, 5.days.ago]
].each_with_index do |(coach, student, time), i|
  Slot.create!(
    coach: coach,
    student: student,
    start_time: time,
    satisfaction_score: rand(3..5),
    notes: "Call ##{i + 1} went well!"
  )
end

puts "✅ Done seeding!"