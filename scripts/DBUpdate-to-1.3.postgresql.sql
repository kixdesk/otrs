-- --
-- Update an existing OTRS database from 1.2 to 1.3
-- Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-1.3.postgresql.sql,v 1.6 2004-08-02 23:58:30 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-1.1.postgresql.sql | psql otrs
--
-- --

--
-- drop not used ticket log types
--
DELETE FROM ticket_history_type WHERE name = 'WatingForClose+';
DELETE FROM ticket_history_type WHERE name = 'WatingForClose-';
DELETE FROM ticket_history_type WHERE name = 'WatingForReminder';
DELETE FROM ticket_history_type WHERE name = 'Open';
DELETE FROM ticket_history_type WHERE name = 'Reopen';
DELETE FROM ticket_history_type WHERE name = 'Close unsuccessful';
DELETE FROM ticket_history_type WHERE name = 'Close successful';
DELETE FROM ticket_history_type WHERE name = 'SetPending';
--
-- new ticket history stuff
--
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TicketLinkAdd', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TicketLinkDelete', 1, 1, current_timestamp, 1, current_timestamp);

--
-- add more attachment info
--
ALTER TABLE article_attachment ADD content_size VARCHAR (30);

--
-- change max customer user login size
--
ALTER TABLE group_customer_user ADD COLUMN user_id_new varchar(1000);
UPDATE group_customer_user SET user_id_new = user_id;
ALTER TABLE group_customer_user DROP COLUMN user_id;
ALTER TABLE group_customer_user RENAME COLUMN user_id_new TO user_id;


--
-- postmaster_filter
--
CREATE TABLE postmaster_filter
(
    f_name varchar (200) NOT NULL,
    f_type varchar (20) NOT NULL,
    f_key varchar (200) NOT NULL,
    f_value varchar (200) NOT NULL
);

--
-- generic_agent_jobs
--
CREATE TABLE generic_agent_jobs
(
    job_name varchar (200) NOT NULL,
    job_key varchar (200) NOT NULL,
    job_value varchar (200) NOT NULL
);

--
-- change size for message id
--
ALTER TABLE article ADD COLUMN a_message_id_new varchar(1000);
UPDATE article SET a_message_id_new = a_message_id;
ALTER TABLE article DROP COLUMN a_message_id;
ALTER TABLE article RENAME COLUMN a_message_id_new TO a_message_id;

--
-- index for message id
--
CREATE INDEX article_message_id ON article (a_message_id);

