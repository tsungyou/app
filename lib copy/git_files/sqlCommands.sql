-- //  using postgresql
-- //  on macOS

brew install postgresql@15

-- postgresql@15 is keg-only, which means it was not symlinked into /usr/local,
-- because this is an alternate version of another formula.

-- If you need to have postgresql@15 first in your PATH, run:
--   echo 'export PATH="/usr/local/opt/postgresql@15/bin:$PATH"' >> ~/.zshrc

-- For compilers to find postgresql@15 you may need to set:
--   export LDFLAGS="-L/usr/local/opt/postgresql@15/lib"
--   export CPPFLAGS="-I/usr/local/opt/postgresql@15/include"

-- To start postgresql@15 now and restart at login:
--   brew services start postgresql@15
-- Or, if you don't want/need a background service you can just run:
--   LC_ALL="C" /usr/local/opt/postgresql@15/bin/postgres -D /usr/local/var/postgresql@15
-- ==> python@3.12
-- Python has been installed as
--   /usr/local/bin/python3

-- Unversioned symlinks `python`, `python-config`, `pip` etc. pointing to
-- `python3`, `python3-config`, `pip3` etc., respectively, have been installed into
--   /usr/local/opt/python@3.12/libexec/bin

-- See: https://docs.brew.sh/Homebrew-and-Python
-- ==> pipx
-- zsh completions have been installed to:
--   /usr/local/share/zsh/site-functions


'' add postgresql to path
echo 'export PATH="/usr/local/opt/postgresql@15/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

'' setenvironment variables
export LDFLAGS="-L/usr/local/opt/postgresql@15/lib"
export CPPFLAGS="-I/usr/local/opt/postgresql@15/include"

'' start postgresql services
brew services start postgresql@15

'' assess postgresql services
psql postgres


create database flutterdb;
-- for all database list
\l 

-- create a role
create role jimmy with createdb createrole login replication encrypted password 'Buddyrich134';
create role flutterdb_admin -- new role name: flutterdb_admin
with -- introduces the list of attributes/privileges that will be assigned to the role
createdb -- allows the role to create db
createrole -- allows the role to create another role
login -- allows the roles to login to the database
replication encrypted password '123456';
-- return CREATE ROLE

psql -d mydatabase // change database instead of start connecting to mydatabase: \c flutter_test1
psql -U myuser -d mydatabase
psql -h myhost -p 5432 -U myuser -d mydatabase
\l
\dt -- list all tables in the current database
\d -- list all tables and sequences
\d tablename -- describe a table
\du -- list all users
\q -- exit postgresql
=====================

CREATE DATABASE mydatabase;
CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

INSERT INTO test_table (id, name, age) VALUES (1, 'User1', 20);

INSERT INTO mytable (name, age) VALUES ('John Doe', 30);
SELECT * FROM mytable;
UPDATE mytable SET age = 31 WHERE name = 'John Doe';
DELETE FROM mytable WHERE name = 'John Doe';
DROP TABLE mytable;

=============
check db detailed information, inclujding host, username, password, database and more
psql postgres; SHOW config_file;
return => /usr/local/var/postgresql@15/postgresql.conf

-- cat /usr/local/var/postgresql@15/postgresql.conf | grep -E 'listen_addresses|port';
SHOW port =>  5432
SHOW listen_addresses => localhost

ALTER USER your_username WITH PASSWORD 'newpassword';
ALTER USER postgres WITH PASSWORD 'Buddyrich134';

GRANT ALL PRIVILEGES ON TABLE user_information TO jimmy;
ALTER USER jimmy WITH PASSWORD 'new_password';
