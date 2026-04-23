CREATE TABLE people (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    mood TEXT
);

CREATE TABLE "location" (
    id INTEGER PRIMARY KEY,
    people_id INTEGER REFERENCES people(id),
    description TEXT
);

CREATE TABLE "action" (
    id INTEGER PRIMARY KEY,
    people_id INTEGER REFERENCES people(id),
    description TEXT
);

CREATE TABLE objects (
    id INTEGER PRIMARY KEY,
    owner_id INTEGER REFERENCES people(id),
    name TEXT
);
