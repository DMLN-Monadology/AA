require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question
  attr_accessor :title, :body, :author
  attr_reader :id

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @author = options["author"]
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.get_first_row(<<-SQL,id)
      SELECT *
      FROM questions
      WHERE
        id = ?
    SQL
    Question.new(question)
  end

  def self.find_by_author_id(author)
    question = QuestionsDatabase.instance.get_first_row(<<-SQL,author)
      SELECT *
      FROM questions
      WHERE
        author = ?
    SQL
    Question.new(question)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def save
    if @id
      self.update
    else
      self.insert
    end
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL,@title,@body,@author,@id)
    UPDATE questions
    SET
      title = ?,
      body = ?,
      author = ?
    WHERE id = ?
    SQL
  end

  def insert
    QuestionsDatabase.instance.execute(<<-SQL,@title,@body,@author)
    INSERT INTO questions (title,body,author)
    VALUES (?,?,?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

end










class User
  attr_accessor :fname, :lname
  attr_reader :id

  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.get_first_row(<<-SQL,id)
      SELECT *
      FROM users
      WHERE
        id = ?
    SQL
    User.new(user)
  end

  def self.find_by_name(fname,lname)
    name = QuestionsDatabase.instance.get_first_row(<<-SQL,fname,lname)
    SELECT *
    FROM users
    WHERE
      fname = ?
      AND
      lname = ?
    SQL
    User.new(name)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    avg = QuestionsDatabase.instance.get_first_row(<<-SQL, @id)
    SELECT
      CAST(COUNT(question_likes.user_id) AS FLOAT) / COUNT(DISTINCT(questions.id))
    FROM
      question_likes
    LEFT JOIN
      questions
      ON question_likes.question_id = questions.id
    WHERE
      questions.author= ?
    SQL
    avg.values.first
  end

  def save
    if @id
      self.update
    else
      self.insert
    end
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
    UPDATE users
    SET
      fname = ?,
      lname = ?
    WHERE id = ?
    SQL
  end

  def insert
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
    INSERT INTO users (fname, lname)
    VALUES (?,?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

end




class QuestionFollow
  attr_reader :question_id, :user_id

  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL,id)
      SELECT *
      FROM question_follows
      WHERE
        id = ?
    SQL
    question_follow.map {|question| QuestionFollow.new(question)}
  end

  def self.followers_for_question_id(question_id)
    user_objects = QuestionsDatabase.instance.execute(<<-SQL,question_id)
      SELECT users.*
      FROM question_follows
      JOIN users
        ON users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL
    user_objects.map{|user| User.new(user)}
  end

  def self.followed_questions_for_user_id(user_id)
    question_objects = QuestionsDatabase.instance.execute(<<-SQL,user_id)
      SELECT questions.*
      FROM question_follows
      JOIN questions
        ON questions.id = question_follows.question_id
      WHERE
        user_id = ?
    SQL
    question_objects.map{|question| Question.new(question)}
  end

  def self.most_followed_questions(n)
    most_questions = QuestionsDatabase.instance.execute(<<-SQL,n)
    SELECT questions.*
    FROM questions
    JOIN question_follows
      ON questions.id = question_follows.question_id
    GROUP BY
      question_follows.question_id
    ORDER BY COUNT(*)
    LIMIT ?
    SQL
    most_questions.map {|q|Question.new(q)}
  end
end







class Reply
  attr_accessor :body
  attr_reader :id, :parent_id, :question_id, :user_id

  def initialize(options)
    @id = options['id']
    @parent_id = options['parent_id']
    @author = options['author']
    @question_id  = options['question_id']
    @body = options['body']
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.get_first_row(<<-SQL,id)
      SELECT *
      FROM replies
      WHERE
        id = ?
    SQL
    Reply.new(reply)
  end

  def self.find_by_user_id(author)
    user = QuestionsDatabase.instance.get_first_row(<<-SQL,author)
      SELECT *
      FROM replies
      WHERE
        author = ?
    SQL
    Reply.new(user)
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL,question_id: question_id)
      SELECT *
      FROM replies
      WHERE
        question_id = :question_id
        OR
        parent_id = :question_id
    SQL
    replies.map {|reply| Reply.new(reply)}
  end

  def author
    @author
  end

  def question
    @question_id
  end

  def parent_reply
    @parent_id
  end

  def child_replies
    children = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT *
      FROM replies
      WHERE
        parent_id = ?
    SQL
    children.map { |child| Reply.new(child)}
  end

  def save
    if @id
      self.update
    else
      self.insert
    end
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL, @parent_id, @author, @question_id, @body, @id)
    UPDATE replies
    SET
      parent_id = ?
      author = ?
      question_id = ?
      body = ?
    WHERE id = ?
    SQL
  end

  def insert
    QuestionsDatabase.instance.execute(<<-SQL, @parent_id, @author, @question_id, @body)
    INSERT INTO replies (parent_id, author, question_id, body)
    VALUES (?,?,?,?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

end








class QuestionLike
  attr_reader :id, :user_id, :question_id

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.find_by_id(id)
    like = QuestionsDatabase.instance.get_first_row(<<-SQL,id)
      SELECT *
      FROM question_likes
      WHERE
        id = ?
    SQL
    QuestionLike.new(like)
  end

  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL,question_id)
    SELECT users.*
    FROM users
    JOIN question_likes
      ON question_likes.user_id = users.id
    WHERE question_likes.question_id = ?
    SQL
    likers.map { |liker| User.new(liker)}
  end


  def self.num_likes_for_question_id(question_id)
    num = QuestionsDatabase.instance.get_first_row(<<-SQL,question_id)
      SELECT COUNT(*)
      FROM users
      JOIN question_likes
        ON question_likes.user_id = users.id
      WHERE question_likes.question_id = ?
      SQL
    num.values.first
  end

  def self.liked_questions_for_user_id(user_id)
    liked = QuestionsDatabase.instance.execute(<<-SQL,user_id)
    SELECT questions.*
    FROM questions
    JOIN question_likes
      ON question_likes.question_id = questions.id
    WHERE question_likes.user_id = ?
    SQL
    liked.map { |like| Question.new(like)}
  end

  def self.most_liked_questions(n)
    most_liked = QuestionsDatabase.instance.execute(<<-SQL,n)
    SELECT questions.*
    FROM questions
    JOIN question_likes
      ON questions.id = question_likes.question_id
    GROUP BY
      question_likes.question_id
    ORDER BY COUNT(*)
    LIMIT ?
    SQL
    most_liked.map {|q|Question.new(q)}
  end


end
