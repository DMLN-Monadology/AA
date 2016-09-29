# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  question_text :string           not null
#  poll_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Question < ActiveRecord::Base

  validates :question_text, :poll_id, presence: true

  has_many :answer_choices,
    primary_key: :id,
    foreign_key: :question_id,
    class_name: :AnswerChoice

  belongs_to :poll,
    primary_key: :id,
    foreign_key: :poll_id,
    class_name: :Poll

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def results_n_plus_one
    answer_choices = self.answer_choices
    results = Hash.new(0)

    answer_choices.each do |answer_choice|
      answer_choice.responses.each do |response|
        results[response.answer_choice.answer_text] += 1
      end
    end

    results
  end

  def results
    answer_choices = self.answer_choices.includes(:responses)
    results = Hash.new(0)

    answer_choices.each do |answer_choice|
      results[answer_choice.answer_text] += answer_choice.responses.length
    end

    results
  end

end
