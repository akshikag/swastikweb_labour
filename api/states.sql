--
-- PostgreSQL database dump
--

\restrict eCikQ97PS96qz5OBRYNIYpWzej8VBMMVN3hhkJnvu4ObzUakb80mRU1uZ0zy35h

-- Dumped from database version 16.10
-- Dumped by pg_dump version 17.6

-- Started on 2025-11-28 14:07:49

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 242 (class 1259 OID 31507)
-- Name: states; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.states (
    id integer NOT NULL,
    lgd_code integer,
    state_name character varying(100),
    created timestamp without time zone,
    modified timestamp without time zone
);


ALTER TABLE public.states OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 31510)
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.states_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.states_id_seq OWNER TO postgres;

--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 243
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.states_id_seq OWNED BY public.states.id;


--
-- TOC entry 4813 (class 2604 OID 31511)
-- Name: states id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.states ALTER COLUMN id SET DEFAULT nextval('public.states_id_seq'::regclass);


--
-- TOC entry 4959 (class 0 OID 31507)
-- Dependencies: 242
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.states VALUES (1, 35, 'Andaman and Nicobar Islands', NULL, NULL);
INSERT INTO public.states VALUES (2, 28, 'Andhra Pradesh', NULL, NULL);
INSERT INTO public.states VALUES (3, 12, 'Arunachal Pradesh', NULL, NULL);
INSERT INTO public.states VALUES (4, 18, 'Assam', NULL, NULL);
INSERT INTO public.states VALUES (5, 10, 'Bihar', NULL, NULL);
INSERT INTO public.states VALUES (6, 4, 'Chandigarh', NULL, NULL);
INSERT INTO public.states VALUES (7, 22, 'Chhattisgarh', NULL, NULL);
INSERT INTO public.states VALUES (8, 7, 'Delhi', NULL, NULL);
INSERT INTO public.states VALUES (9, 30, 'Goa', NULL, NULL);
INSERT INTO public.states VALUES (10, 24, 'Gujarat', NULL, NULL);
INSERT INTO public.states VALUES (11, 6, 'Haryana', NULL, NULL);
INSERT INTO public.states VALUES (12, 2, 'Himachal Pradesh', NULL, NULL);
INSERT INTO public.states VALUES (13, 1, 'Jammu and Kashmir', NULL, NULL);
INSERT INTO public.states VALUES (14, 20, 'Jharkhand', NULL, NULL);
INSERT INTO public.states VALUES (15, 29, 'Karnataka', NULL, NULL);
INSERT INTO public.states VALUES (16, 32, 'Kerala', NULL, NULL);
INSERT INTO public.states VALUES (17, 37, 'Ladakh', NULL, NULL);
INSERT INTO public.states VALUES (18, 31, 'Lakshadweep', NULL, NULL);
INSERT INTO public.states VALUES (19, 23, 'Madhya Pradesh', NULL, NULL);
INSERT INTO public.states VALUES (20, 27, 'Maharashtra', NULL, NULL);
INSERT INTO public.states VALUES (21, 14, 'Manipur', NULL, NULL);
INSERT INTO public.states VALUES (22, 17, 'Meghalaya', NULL, NULL);
INSERT INTO public.states VALUES (23, 15, 'Mizoram', NULL, NULL);
INSERT INTO public.states VALUES (24, 13, 'Nagaland', NULL, NULL);
INSERT INTO public.states VALUES (25, 21, 'Odisha', NULL, NULL);
INSERT INTO public.states VALUES (26, 34, 'Puducherry', NULL, NULL);
INSERT INTO public.states VALUES (27, 3, 'Punjab', NULL, NULL);
INSERT INTO public.states VALUES (28, 8, 'Rajasthan', NULL, NULL);
INSERT INTO public.states VALUES (29, 11, 'Sikkim', NULL, NULL);
INSERT INTO public.states VALUES (30, 33, 'Tamil Nadu', NULL, NULL);
INSERT INTO public.states VALUES (31, 36, 'Telangana', NULL, NULL);
INSERT INTO public.states VALUES (32, 38, 'Dadra and Nagar Haveli and Daman and Diu', NULL, NULL);
INSERT INTO public.states VALUES (33, 16, 'Tripura', NULL, NULL);
INSERT INTO public.states VALUES (34, 5, 'Uttarakhand', NULL, NULL);
INSERT INTO public.states VALUES (35, 9, 'Uttar Pradesh', NULL, NULL);
INSERT INTO public.states VALUES (36, 19, 'West Bengal', NULL, NULL);


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 243
-- Name: states_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.states_id_seq', 36, true);


--
-- TOC entry 4815 (class 2606 OID 31513)
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


-- Completed on 2025-11-28 14:07:49

--
-- PostgreSQL database dump complete
--

\unrestrict eCikQ97PS96qz5OBRYNIYpWzej8VBMMVN3hhkJnvu4ObzUakb80mRU1uZ0zy35h

