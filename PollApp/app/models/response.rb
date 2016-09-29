# == Schema Information
#
# Table name: responses
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  answer_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Response < ActiveRecord::Base

  validates :user_id, :answer_id, presence: true
  validate :valid_responses, :valid_respondent

  belongs_to :respondent,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :answer_choice,
    primary_key: :id,
    foreign_key: :answer_id,
    class_name: :AnswerChoice

  has_one :question,
    through: :answer_choice,
    source: :question


  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    self.sibling_responses.exists?(user_id: self.user_id)
  end

  def valid_responses
    if self.respondent_already_answered?
      self.errors[:user_id] << "has already responded"
    end
  end

  def valid_respondent
    if self.question.poll.author_id == self.user_id
      self.errors[:user_id] << "nice try, Donald!"
    end
  end




end

# We will write a custom validation method, not_duplicate_response,
# to check that the respondent has not previously answered this question.
# This is a deceptively hard thing to do and will require several steps:
