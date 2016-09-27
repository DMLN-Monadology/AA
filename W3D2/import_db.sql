
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author INTEGER NOT NULL,
  FOREIGN KEY (author) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows (
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  parent_id INTEGER,
  author INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (author) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);



INSERT INTO
  users (fname, lname)
VALUES
  ('Amanda', 'Fielding'),
  ('Duc', 'Nguyen'),
  ('Robert','TA'),
  ('generic', 'student');

INSERT INTO
  questions (title, body, author)
VALUES
  ('Join?', 'How do I join two tables?', 1),
  ('indent?', 'How does one indent?', 2);


INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (1, 2),
  (1, 4);



INSERT INTO
  replies (parent_id, author, question_id, body)
VALUES
  (null, 3, 1, 'read the book') ,
  (1, 2, 1, 'I''m actually illiterate');



INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 2),
  (4, 2);
