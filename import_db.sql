
CREATE TABLE users (
	id INTEGER PRIMARY KEY,
	fname VARCHAR(255) NOT NULL,
	lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
	id INTEGER PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	body TEXT NOT NULL,
	user_id INTEGER NOT NULL,

	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,

	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	parent_reply_id INTEGER,
	user_id INTEGER NOT NULL,
	body TEXT NOT NULL,

	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes(
	id INTEGER PRIMARY KEY,
	user_id INTEGER NOT NULL,
	question_id INTEGER NOT NULL,

	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
	users (fname, lname)
VALUES
	('Jesse', 'Fox'),
	('Teo', 'Dell'),
	('Buck', 'TA');

INSERT INTO
	questions (title, body, user_id)
VALUES
	('Name', 'What is your name? I am quite curious.',
	  (SELECT id FROM users WHERE fname = 'Jesse')),
	('Colors', 'Why is the sky blue?',
	  (SELECT id FROM users WHERE fname = 'Teo')),
	('Cooking', 'What is your favorite dish?',
	  (SELECT id FROM users WHERE fname = 'Jesse')),
	('Music', 'Do you like to play bass?',
	  (SELECT id FROM users WHERE fname = 'Buck'));

INSERT INTO
	replies (question_id, parent_reply_id, user_id, body)
VALUES
	((SELECT id FROM questions WHERE title = 'Name'),
	  NULL,
	 (SELECT user_id FROM questions WHERE title = 'Name'),
	 'this is the body of our reply');

INSERT INTO
	question_likes (user_id, question_id)
VALUES
	(1, 1);