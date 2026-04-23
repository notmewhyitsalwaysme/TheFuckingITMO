-- UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ENUMs
CREATE TYPE mood_type AS ENUM ('neutral', 'positive', 'negative');
CREATE TYPE status_type AS ENUM ('normal', 'inoagent');

-- DOMAIN
CREATE DOMAIN cur_time as TIMESTAMP NOT NULL DEFAULT now();
CREATE DOMAIN auto_uuid as UUID DEFAULT gen_random_uuid();


-- main tables
CREATE TABLE people (
    id auto_uuid PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT,
    b_day cur_time
);

CREATE TABLE IF NOT EXISTS gov (
    id auto_uuid PRIMARY KEY,
    rank INTEGER
);

CREATE TABLE IF NOT EXISTS conversation (
    id auto_uuid PRIMARY KEY,
    description TEXT
);


CREATE TABLE IF NOT EXISTS conversation_report (
	id auto_uuid PRIMARY KEY,
	chat_id UUID references conversation(id),
	author UUID references gov(id),
	approved_by UUID references gov(id),
	attention_level INT,
	notes TEXT,
	time cur_time
);

CREATE TABLE IF NOT EXISTS history_of_control (
    id auto_uuid PRIMARY KEY,
    citizen_id UUID references people(id),
    observation_by UUID references gov(id),
    time cur_time
);

-- people

CREATE TABLE IF NOT EXISTS status (
    id auto_uuid PRIMARY KEY,
    citizen_id UUID references people(id),
    set_by_gov UUID references gov(id),
    set_by_report UUID references conversation_report(id),
    status status_type,
    time cur_time
);

-- chats
CREATE TABLE IF NOT EXISTS participating (
    id auto_uuid PRIMARY KEY,
    people_id UUID references people(id),
    chat_id UUID references conversation(id),
    UNIQUE(people_id, chat_id)
);

-- messages
CREATE TABLE IF NOT EXISTS messages (
    id auto_uuid PRIMARY KEY,
    sender_id UUID references people(id),
    chat_id UUID references conversation(id),
    mood mood_type,
    time cur_time
);

CREATE TABLE IF NOT EXISTS mentioned (
	id auto_uuid PRIMARY KEY,
	people_id UUID references people(id),
    msg_id UUID references messages(id),
	UNIQUE(people_id, msg_id)
);

-- trigger 
CREATE OR REPLACE FUNCTION fn_validate_bday()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.b_day > now() THEN
        RAISE EXCEPTION 'Дата рождения не может быть в будущем: %', NEW.b_day;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_bday
BEFORE INSERT OR UPDATE ON people
FOR EACH ROW EXECUTE FUNCTION fn_validate_bday();

-- test (throws error)
INSERT INTO people (first_name, last_name, b_day)
VALUES ('Иван', 'Петров', '2000-05-15');