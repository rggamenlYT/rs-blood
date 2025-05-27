CREATE TABLE IF NOT EXISTS player_bloodtypes (
    citizenid VARCHAR(50) PRIMARY KEY,
    steamname VARCHAR(100),
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    bloodtype VARCHAR(5),
    created_at DATETIME
);