# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

# BONUS PROBLEM: requires sub-queries or joins. Attempt this after completing
# sections 04 and 07.

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
    SELECT
      physics_given.yr
    FROM
      (SELECT DISTINCT yr FROM nobels WHERE subject IN('Physics')) AS physics_given
      LEFT JOIN (SELECT DISTINCT yr FROM nobels WHERE subject IN('Chemistry')) AS chemistry_given
      ON physics_given.yr = chemistry_given.yr
      WHERE chemistry_given.yr IS null 
  SQL
end
