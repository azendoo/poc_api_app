# encoding: UTF-8
# XXX :
# Quick script to generate tasks
# Should be improved.
user1 = User.first
user2 = User.last

task  = user1.tasks.new(label: "This is a task")

task.save!
puts "New task created : #{task.label}"

task  = user1.tasks.new(label: "Another task")
task.save!
puts "New task created : #{task.label}"

task  = user2.tasks.new(label: "Awesome task")
task.save!
puts "New task created : #{task.label}"

