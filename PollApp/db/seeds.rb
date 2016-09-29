# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user1 = User.create!(user_name: "Robert E. Lee")
user2 = User.create!(user_name: "Ulysses S. Grant")
user3 = User.create!(user_name: "Abraham Lincoln")

poll = Poll.create!(title: "History", author_id: 2)

question= Question.create!(question_text: "Who won the civil war?", poll_id: 1)

answer_choice1= AnswerChoice.create!(answer_text: "The South", question_id: 1)
answer_choice2= AnswerChoice.create!(answer_text: "The North", question_id: 1)

response = Response.create!(user_id: 2, answer_id: 1)
resopnse = Response.create!(user_id: 3, answer_id: 2)

response5 = Response.create!(user_id: 2, answer_id: 2)

response7 = Response.create!(user_id: 2, answer_id: 1)
