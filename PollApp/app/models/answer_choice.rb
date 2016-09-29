# == Schema Information
#
# Table name: answer_choices
#
#  id          :integer          not null, primary key
#  answer_text :string           not null
#  question_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AnswerChoice < ActiveRecord::Base

  validates :answer_text, :question_id, presence: true

  has_many :responses,
    primary_key: :id,
    foreign_key: :answer_id,
    class_name: :Response

  belongs_to :question,
    primary_key: :id,
    foreign_key: :question_id,
    class_name: :Question
end
