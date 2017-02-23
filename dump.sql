--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: gsudan
--

CREATE SEQUENCE account_id_seq
    START WITH 100000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account_id_seq OWNER TO gsudan;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: gsudan
--

CREATE TABLE accounts (
    id integer NOT NULL,
    balance double precision,
    status integer,
    account_id bigint DEFAULT nextval('account_id_seq'::regclass),
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE accounts OWNER TO gsudan;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: gsudan
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE accounts_id_seq OWNER TO gsudan;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gsudan
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: gsudan
--

CREATE TABLE admins (
    id integer NOT NULL,
    predefined integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE admins OWNER TO gsudan;

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: gsudan
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admins_id_seq OWNER TO gsudan;

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gsudan
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: gsudan
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE ar_internal_metadata OWNER TO gsudan;

--
-- Name: friends; Type: TABLE; Schema: public; Owner: gsudan
--

CREATE TABLE friends (
    id integer NOT NULL,
    user_id integer,
    friend_id integer
);


ALTER TABLE friends OWNER TO gsudan;

--
-- Name: friends_id_seq; Type: SEQUENCE; Schema: public; Owner: gsudan
--

CREATE SEQUENCE friends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE friends_id_seq OWNER TO gsudan;

--
-- Name: friends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gsudan
--

ALTER SEQUENCE friends_id_seq OWNED BY friends.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: gsudan
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE schema_migrations OWNER TO gsudan;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: gsudan
--

CREATE TABLE transactions (
    id integer NOT NULL,
    status integer,
    start timestamp without time zone,
    finish timestamp without time zone,
    amount double precision,
    account_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    transaction_type integer
);


ALTER TABLE transactions OWNER TO gsudan;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: gsudan
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transactions_id_seq OWNER TO gsudan;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gsudan
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: gsudan
--

CREATE TABLE transfers (
    id integer NOT NULL,
    account_id integer,
    transaction_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE transfers OWNER TO gsudan;

--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: gsudan
--

CREATE SEQUENCE transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transfers_id_seq OWNER TO gsudan;

--
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gsudan
--

ALTER SEQUENCE transfers_id_seq OWNED BY transfers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: gsudan
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying,
    remember_digest character varying
);


ALTER TABLE users OWNER TO gsudan;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: gsudan
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO gsudan;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gsudan
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: friends id; Type: DEFAULT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY friends ALTER COLUMN id SET DEFAULT nextval('friends_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: transfers id; Type: DEFAULT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY transfers ALTER COLUMN id SET DEFAULT nextval('transfers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gsudan
--

SELECT pg_catalog.setval('account_id_seq', 100000000, true);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: gsudan
--

COPY accounts (id, balance, status, account_id, user_id, created_at, updated_at) FROM stdin;
1	10009	1	100000000	2	2017-02-22 01:49:56.477219	2017-02-22 03:47:10.399757
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gsudan
--

SELECT pg_catalog.setval('accounts_id_seq', 1, true);


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: gsudan
--

COPY admins (id, predefined, user_id, created_at, updated_at) FROM stdin;
1	1	1	2017-02-21 20:46:30.289122	2017-02-21 20:46:30.289122
\.


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gsudan
--

SELECT pg_catalog.setval('admins_id_seq', 1, true);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: gsudan
--

COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2017-02-22 01:39:52.29093	2017-02-22 01:39:52.29093
\.


--
-- Data for Name: friends; Type: TABLE DATA; Schema: public; Owner: gsudan
--

COPY friends (id, user_id, friend_id) FROM stdin;
\.


--
-- Name: friends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gsudan
--

SELECT pg_catalog.setval('friends_id_seq', 1, false);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: gsudan
--

COPY schema_migrations (version) FROM stdin;
20170215004650
20170215164310
20170215170438
20170218204744
20170218205509
20170218205539
20170218210049
20170218210439
20170219013653
20170222020315
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: gsudan
--

COPY transactions (id, status, start, finish, amount, account_id, created_at, updated_at, transaction_type) FROM stdin;
1	1	2017-02-22 02:53:01.008103	2017-02-22 02:53:01.008122	1	1	2017-02-22 02:53:01.013461	2017-02-22 02:53:01.013461	\N
2	1	2017-02-22 03:06:13.465438	2017-02-22 03:06:13.465458	1	1	2017-02-22 03:06:13.471734	2017-02-22 03:06:13.471734	\N
3	1	2017-02-22 03:16:05.024702	2017-02-22 03:16:05.024721	1	1	2017-02-22 03:16:05.029841	2017-02-22 03:16:05.029841	\N
4	1	2017-02-22 03:29:45.605144	2017-02-22 03:29:45.605163	1	1	2017-02-22 03:29:45.611294	2017-02-22 03:29:45.611294	\N
5	1	2017-02-22 03:38:21.611385	2017-02-22 03:38:21.611423	1	1	2017-02-22 03:38:21.627055	2017-02-22 03:38:21.627055	\N
6	1	2017-02-22 03:47:10.480524	2017-02-22 03:47:10.480569	1	1	2017-02-22 03:47:10.483288	2017-02-22 03:47:10.483288	\N
\.


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gsudan
--

SELECT pg_catalog.setval('transactions_id_seq', 6, true);


--
-- Data for Name: transfers; Type: TABLE DATA; Schema: public; Owner: gsudan
--

COPY transfers (id, account_id, transaction_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gsudan
--

SELECT pg_catalog.setval('transfers_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gsudan
--

COPY users (id, name, email, created_at, updated_at, password_digest, remember_digest) FROM stdin;
3	test2	test2@ncsu.edu	2017-02-22 01:48:38.201359	2017-02-22 01:48:38.201359	$2a$10$TJsX7YlRKNUjRD8LKdiEmO9Ups1JbOnmkOr3SzqQ19VSeVDIIueA2	\N
4	test3	test3@ncsu.edu	2017-02-22 01:48:59.025631	2017-02-22 01:48:59.025631	$2a$10$h5kQOr/tjKwuX6J4E6a/O.Rk9sY6ac.73tnnGGLV4z9tlO2FBQElq	\N
2	test1	test1@ncsu.edu	2017-02-22 01:47:38.131154	2017-02-22 01:49:50.594283	$2a$10$7LBIGo4.6/Kwsd60iSiUUeP3uNchnQMxcM6DG/V2bhK0pCqQVyGuS	$2a$10$ll.G1FbyFOZFGc7/vHUuB.9X.KGgn5XMU5zJDcrbfFcTjHhEOHf8q
1	admin	admin@ncsu.edu	2017-02-22 01:41:31.790718	2017-02-22 01:50:21.483716	$2a$10$8mhFCoKFBnOw/UTYe/alXe31UK9ah/ySR8ETrrY/jI3AEocJ42Kn.	$2a$10$jQE64yCpD/0qGLSJxFBazexqq6lOAhs.aipRLvF1vgFms7cNk1ctC
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gsudan
--

SELECT pg_catalog.setval('users_id_seq', 4, true);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: friends friends_pkey; Type: CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY friends
    ADD CONSTRAINT friends_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_user_id; Type: INDEX; Schema: public; Owner: gsudan
--

CREATE INDEX index_accounts_on_user_id ON accounts USING btree (user_id);


--
-- Name: index_admins_on_user_id; Type: INDEX; Schema: public; Owner: gsudan
--

CREATE INDEX index_admins_on_user_id ON admins USING btree (user_id);


--
-- Name: index_friends_on_friend_id_and_user_id; Type: INDEX; Schema: public; Owner: gsudan
--

CREATE UNIQUE INDEX index_friends_on_friend_id_and_user_id ON friends USING btree (friend_id, user_id);


--
-- Name: index_friends_on_user_id_and_friend_id; Type: INDEX; Schema: public; Owner: gsudan
--

CREATE UNIQUE INDEX index_friends_on_user_id_and_friend_id ON friends USING btree (user_id, friend_id);


--
-- Name: index_transactions_on_account_id; Type: INDEX; Schema: public; Owner: gsudan
--

CREATE INDEX index_transactions_on_account_id ON transactions USING btree (account_id);


--
-- Name: index_transfers_on_account_id; Type: INDEX; Schema: public; Owner: gsudan
--

CREATE INDEX index_transfers_on_account_id ON transfers USING btree (account_id);


--
-- Name: index_transfers_on_transaction_id; Type: INDEX; Schema: public; Owner: gsudan
--

CREATE INDEX index_transfers_on_transaction_id ON transfers USING btree (transaction_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: gsudan
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: transactions fk_rails_01f020e267; Type: FK CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT fk_rails_01f020e267 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: transfers fk_rails_3729299052; Type: FK CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY transfers
    ADD CONSTRAINT fk_rails_3729299052 FOREIGN KEY (transaction_id) REFERENCES transactions(id);


--
-- Name: admins fk_rails_378b9734e4; Type: FK CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT fk_rails_378b9734e4 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: accounts fk_rails_b1e30bebc8; Type: FK CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_rails_b1e30bebc8 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: transfers fk_rails_e33bbc3d7d; Type: FK CONSTRAINT; Schema: public; Owner: gsudan
--

ALTER TABLE ONLY transfers
    ADD CONSTRAINT fk_rails_e33bbc3d7d FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- PostgreSQL database dump complete
--

