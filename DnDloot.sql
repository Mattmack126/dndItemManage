CREATE DATABASE DnDloot;

CREATE TABLE campaigns
(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(500),
  isActive BOOLEAN NOT NULL,
  gold INTEGER NOT NULL,
  silver INTEGER NOT NULL,
  copper INTEGER NOT NULL,
  owner_id INTEGER NOT NULL
  );

CREATE TABLE characters
(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  job VARCHAR(100) NOT NULL,
  level INTEGER NOT NULL,
  isAlive BOOLEAN NOT NULL,
  user_id INTEGER NOT NULL,
  campaign_id INTEGER NOT NULL,
  gold INTEGER NOT NULL,
  silver INTEGER NOT NULL,
  copper INTEGER NOT NULL
  );

CREATE TABLE items
(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(500),
  weight DECIMAL NOT NULL,
  gold INTEGER NOT NULL,
  silver INTEGER NOT NULL,
  copper INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  character_id INTEGER,
  campaign_id INTEGER NOT NULL

);
CREATE TABLE users
(
  id SERIAL4 PRIMARY KEY,
  username VARCHAR(100) NOT NULL,
  password_digest VARCHAR(200) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  admin BOOLEAN NOT NULL
  );

CREATE TABLE campaignUsers
(
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER NOT NULL,
  campaign_id INTEGER NOT NULL,
  isOwner BOOLEAN NOT NULL
 );

INSERT INTO characters (name,job,level,isAlive,user_id,campaign_id,gold,silver,copper) VALUES('Steve','Fighter','3','true','1','1','0','0','0');

INSERT INTO users (username,password_digest,full_name,admin) VALUES('ashton@ga.co','cake','Ashton Sobell','true')

INSERT INTO users (username,password_digest,full_name,admin) VALUES('jason@ga.co','password','Jason Sobell','true')

INSERT INTO campaigns (name,description,isActive,gold,silver,copper) VALUES('C1','A random description','true','10','10','10')

INSERT INTO campaignuser (user_id,campaign_id,isowner) VALUES('1','1',true)

INSERT INTO items (name,description,weight,gold,silver,copper,quantity,character_id,campaign_id) VALUES ('bow','a bow','1.5','1','20','0','1','2','2')

Dish.where(dish_type_id: params[:dish_type_id])

campaignuser.where(dish_type_id: params[:dish_type_id])

ALTER TABLE campaigns ADD COLUMN owner_id INTEGER NOT NULL;