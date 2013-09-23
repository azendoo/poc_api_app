Rake::Task["db:drop"].invoke

user1 = User.create(email: "tbishop@total.com", password: "please")
puts "User #{user1.email} account created."

user2 = User.create(email: "robin@azendoo.com", password: "please")
puts "User #{user2.email} account created."

task  = user1.tasks.new(label: "This is a task")
task.save!
puts "New task created : #{task.label}"

task  = user1.tasks.new(label: "Another task")
task.save!
puts "New task created : #{task.label}"

task  = user2.tasks.new(label: "Awesome task")
task.save!
puts "New task created : #{task.label}"

