psql -U username -d database_name -W
PGPASSWORD='Buddyrich134' psql -U jimmy -d user_validation -- not commanded for security purpose

-- (
--     DATABASE
--     - TABLE
--         - columns
-- )

** currently not existed
# todo
1. auto login in 7 days since last login
2. 

- user_validation
    - user_information
        - id SERIAL PRIMARY KEY
        - username
        - user_email
        - user_password
        - user_phone_number
        
    - purchase
        - user_email
        - strategy_1
        - purchase_date_strategy_1
        - invalid_date_strategy_1
        - PRIMARY KEY (user_email)
        ...

- flutter_test1
    - daily
        - da
        - codename
        - symbol
        - industry
        - op
        - hi
        - lo
        - cl
        ** daily_pct_change
        
    - ...
    - ...



final dbServiceUserValidation = DatabaseService(
    host: 'localhost',
    port: 5432,
    databaseName: 'user_validation',
    username: 'jimmy',
    password: 'Buddyrich134',
);
CREATE DATABASE user_validation;
=================================
CREATE TABLE user_information (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    user_email VARCHAR(100) NOT NULL,
    user_password VARCHAR(100) NOT NULL,
    user_phone_number VARCHAR(100) NOT NULL
);
-- RegExp
-- ALTER TABLE user_information
-- ADD CONSTRAINT valid_email CHECK (user_email ~* '^[^@]+@[^@]+$');

-- ALTER TABLE user_information
-- ADD CONSTRAINT valid_password CHECK (
--     user_password ~* '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$'
-- );

-- test
INSERT INTO user_information (username, user_email, user_password, user_phone_number) VALUES ('test', 'test', 'test', 'test');
select * from user_information limit 110;
=================================
CREATE TABLE daily (
    da DATE,
    codename VARCHAR(100),
    symbol VARCHAR(100),
    industry VARCHAR(100),
    op FLOAT,
    hi FLOAT,
    lo FLOAT,
    cl FLOAT
);



CREATE TABLE purchase (
    user_email VARCHAR(100) NOT NULL,
    strategy_1 BOOLEAN DEFAULT FALSE,
    purchase_date_strategy_1 DATE,
    invalid_date_strategy_1 DATE DEFAULT (NOW() + INTERVAL '1 month'),
    PRIMARY KEY (user_email)
);


