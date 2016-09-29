# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base

  validates :user_name, presence: true, uniqueness: true  

  has_many :responses,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Response

  has_many :polls,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :Poll
end
