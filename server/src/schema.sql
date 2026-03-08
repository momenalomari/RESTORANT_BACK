-- table users
-- id, name, email, national id, address, birthdate, gender, nationality, has_passport, created at, role(traveler, captin, manager)

-- table airplans
-- id, type, number, seat number, owner comp,  trip category(FK), captain

-- trip
-- id, name, category(FK),  departure date, return date,source,  distenation. 

-- category
-- id, name, description, number of seats



create table users(
	name varchar(255) not null , 
	email varchar(100) unique not null, 
	national_id int primary key, 
	phone_number int, 
	address text, 
	birth_date Date not null, 
	gender boolean, --true=> female, false=> male 
	nationality varchar(50) not null, 
	has_passport boolean default false,
	passportId int, 
	created_at timestamp default current_timestamp, 
	role TEXT[] NOT NULL DEFAULT ARRAY['user'] CHECK (role <@ ARRAY['user', 'captain', 'manager'])
)
create table categories( --economy vip, 
	id serial primary key, 
	name varchar(200), 
	description text, 
	created_at timestamp default current_timestamp, 
	category_seatnumber int 
)
create table airplanes(
	number int primary key, 
	type varchar(255), 
	aiplane_seat_number int, 
	ownercomp varchar(200), 
	captainId int, 
	foreign key (captainId) references users(national_id),
	catId int, 
	created_at timestamp default current_timestamp, 
	foreign key (catId) references categories(id)
)

create table trip(
	id serial primary key, 
	source text ,
	distenation text, 
	start_date Date, 
	price money, 
	duration Date, 
	created_at timestamp default current_timestamp
)

--users table fix
alter table airplanes drop constraint if exists airplanes_captainid_fkey

alter table users drop constraint if exists users_pkey

alter table users alter column phone_number type varchar(20)

alter table users add column id serial

alter table users add constraint national_id_unique unique(national_id)

alter table users alter column gender type varchar(10) using case when gender= true then 'female'
when gender = false then 'male' end;


alter table users add constraint gender_check check (gender in ('male', 'female'))

alter table users alter column role type text using role[1]

alter table users add constraint role_check check (role in ('user', 'captain', 'manager'))


alter table users add constraint passport_check check (
(has_passport = false and passportId is null )
or
(has_passport = true and passportId is not null )
)
ALTER TABLE users
ALTER COLUMN gender SET NOT NULL;
alter table users rename column password to hashed_password


ALTER TABLE users
DROP COLUMN IF EXISTS role;

ALTER TABLE users
ADD COLUMN role TEXT NOT NULL DEFAULT 'user';

ALTER TABLE users
ADD CONSTRAINT role_check
CHECK (role IN ('user','captain','manager'));



--airplanes fix
select * from airplanes
alter table airplanes add column id serial

alter table airplanes drop constraint if exists airplanes_pkey

alter table airplanes add constraint airplanes_pkey primary key (id)

alter table airplanes alter column number type varchar(50)


--categories fix
alter table categories alter column name set not null

alter table categories add constraint categories_name_unique unique (name)



ALTER TABLE categories
ADD CONSTRAINT seat_positive_check
CHECK (category_seatnumber > 0);

ALTER TABLE airplanes
ADD CONSTRAINT airplane_seat_positive
CHECK (aiplane_seat_number > 0);



ALTER TABLE airplanes
ADD COLUMN captain_id INT;

UPDATE airplanes a
SET captain_id = u.id
FROM users u
WHERE a.captainId = u.national_id;

ALTER TABLE airplanes
DROP COLUMN captainId;




ALTER TABLE airplanes
ADD CONSTRAINT airplanes_captain_fk
FOREIGN KEY (captain_id) REFERENCES users(id)
ON DELETE SET NULL;



ALTER TABLE airplanes
ADD CONSTRAINT airplanes_category_fk
FOREIGN KEY (catId) REFERENCES categories(id)
ON DELETE RESTRICT;

ALTER TABLE trip
ALTER COLUMN price TYPE NUMERIC(10,2)
USING price::numeric;


ALTER TABLE trip
ADD COLUMN category_id INT;

ALTER TABLE trip
ADD CONSTRAINT trip_category_fk
FOREIGN KEY (category_id) REFERENCES categories(id)
ON DELETE RESTRICT;