--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE articles (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.articles OWNER TO postgres;

--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.articles_id_seq OWNER TO postgres;

--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY articles (id, created_at, updated_at) FROM stdin;
\.


--
-- Name: articles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('articles_id_seq', 1, false);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_migrations (version) FROM stdin;
20141002202138
\.


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

