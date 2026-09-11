--
-- PostgreSQL database dump
--

\restrict 6Evev1g3ywUR6CdeCW9IooEoxmX6Ecp5wRQUMoRk8JCHCgofghaIHq26s74SdUN

-- Dumped from database version 16.14 (Ubuntu 16.14-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.14 (Ubuntu 16.14-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS labourchowk;
--
-- Name: labourchowk; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE labourchowk WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_IN';


\unrestrict 6Evev1g3ywUR6CdeCW9IooEoxmX6Ecp5wRQUMoRk8JCHCgofghaIHq26s74SdUN
\connect labourchowk
\restrict 6Evev1g3ywUR6CdeCW9IooEoxmX6Ecp5wRQUMoRk8JCHCgofghaIHq26s74SdUN

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: testing; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA testing;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chat_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_conversations (
    id bigint NOT NULL,
    sender_type character varying(255) NOT NULL,
    sender_id bigint NOT NULL,
    receiver_type character varying(255) NOT NULL,
    receiver_id bigint NOT NULL,
    last_message text,
    last_message_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: chat_conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_conversations_id_seq OWNED BY public.chat_conversations.id;


--
-- Name: chat_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_messages (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    sender_type character varying(255) NOT NULL,
    sender_id bigint NOT NULL,
    message text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: chat_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_messages_id_seq OWNED BY public.chat_messages.id;


--
-- Name: configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.configs (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: configs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: configs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.configs_id_seq OWNED BY public.configs.id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.districts (
    id bigint NOT NULL,
    state_id bigint NOT NULL,
    lgd_code bigint NOT NULL,
    district_name character varying(100) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;


--
-- Name: employer_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employer_profiles (
    id bigint NOT NULL,
    employer_id bigint,
    emp_type character varying(255),
    name character varying(100),
    avg_worker character varying(255),
    work_type character varying(255),
    location character varying(255),
    availability character varying(255),
    eshram character varying(255),
    aadhar character varying(255),
    "docType" character varying(255),
    "docNumber" character varying(255),
    pdf character varying(255),
    bocw character varying(255),
    language character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    plot_no character varying(255),
    street_area_village character varying(255),
    post_office character varying(255),
    district character varying(255),
    state character varying(255),
    pin_code character varying(255),
    profile_image character varying(255),
    gender character varying(255),
    CONSTRAINT employer_profiles_gender_check CHECK (((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying, 'other'::character varying])::text[])))
);


--
-- Name: employer_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employer_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employer_profiles_id_seq OWNED BY public.employer_profiles.id;


--
-- Name: employer_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employer_skills (
    id bigint NOT NULL,
    employer_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: employer_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employer_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employer_skills_id_seq OWNED BY public.employer_skills.id;


--
-- Name: employers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employers (
    id bigint NOT NULL,
    email character varying(255),
    phone character varying(10) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255),
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    otp character varying(255),
    otp_expires_at timestamp(0) without time zone
);


--
-- Name: employers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employers_id_seq OWNED BY public.employers.id;


--
-- Name: facilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: facilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facilities_id_seq OWNED BY public.facilities.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: job_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_applications (
    id bigint NOT NULL,
    worker_id bigint NOT NULL,
    job_post_id bigint NOT NULL,
    employer_id bigint NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    note text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT job_applications_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'accepted'::character varying, 'rejected'::character varying])::text[])))
);


--
-- Name: job_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_applications_id_seq OWNED BY public.job_applications.id;


--
-- Name: job_post_facilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_post_facilities (
    id bigint NOT NULL,
    job_post_id bigint NOT NULL,
    facility_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: job_post_facilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_post_facilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_post_facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_post_facilities_id_seq OWNED BY public.job_post_facilities.id;


--
-- Name: job_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_posts (
    id bigint NOT NULL,
    employer_id bigint NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(255),
    skills_id json,
    qualification character varying(255),
    rate character varying(255),
    job_type character varying(255),
    work_location character varying(255),
    start_date date,
    end_date date,
    work_duration character varying(255),
    address character varying(255),
    state character varying(255),
    district character varying(255),
    pincode character varying(255),
    lat character varying(255),
    long character varying(255),
    tools_required character varying(255),
    required_people integer,
    work_time character varying(255),
    status boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: job_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_posts_id_seq OWNED BY public.job_posts.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: schemes_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schemes_pages (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    url character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: schemes_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schemes_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schemes_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schemes_pages_id_seq OWNED BY public.schemes_pages.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skills (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.states (
    id bigint NOT NULL,
    lgd_code bigint NOT NULL,
    state_name character varying(100) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.states_id_seq OWNED BY public.states.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    phone character varying(20),
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255),
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: worker_educations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.worker_educations (
    id bigint NOT NULL,
    worker_id bigint NOT NULL,
    education_level character varying(100) NOT NULL,
    institution character varying(150),
    passing_year character varying(4),
    certificate_path character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: worker_educations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.worker_educations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: worker_educations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.worker_educations_id_seq OWNED BY public.worker_educations.id;


--
-- Name: worker_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.worker_histories (
    id bigint NOT NULL,
    worker_id bigint NOT NULL,
    employer_id bigint,
    employer_name character varying(255),
    project_name character varying(255),
    work_place character varying(255),
    work_type character varying(255),
    skill_id json,
    task_description text,
    start_date date,
    end_date date,
    days_worked integer,
    daily_wage numeric(10,2),
    total_amount numeric(10,2),
    payment_status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    remarks text,
    rating integer,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT worker_histories_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['pending'::character varying, 'paid'::character varying, 'partial'::character varying])::text[])))
);


--
-- Name: worker_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.worker_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: worker_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.worker_histories_id_seq OWNED BY public.worker_histories.id;


--
-- Name: worker_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.worker_profiles (
    id bigint NOT NULL,
    worker_id bigint,
    name character varying(100),
    rate character varying(20),
    age integer,
    skill_id json,
    experience character varying(255),
    work_type character varying(255),
    location character varying(255),
    availability character varying(255),
    eshram character varying(255),
    "docType" character varying(255),
    "docNumber" character varying(255),
    pdf character varying(255),
    language character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    plot_no character varying(255),
    street_area_village character varying(255),
    post_office character varying(255),
    district character varying(255),
    state character varying(255),
    pin_code character varying(255),
    profile_image character varying(255),
    gender character varying(255),
    lat character varying(255),
    long character varying(255),
    CONSTRAINT worker_profiles_gender_check CHECK (((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying, 'other'::character varying])::text[])))
);


--
-- Name: worker_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.worker_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: worker_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.worker_profiles_id_seq OWNED BY public.worker_profiles.id;


--
-- Name: workers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workers (
    id bigint NOT NULL,
    email character varying(100),
    phone character varying(10) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    otp character varying(255),
    otp_expires_at timestamp(0) without time zone
);


--
-- Name: workers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workers_id_seq OWNED BY public.workers.id;


--
-- Name: chat_conversations; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.chat_conversations (
    id bigint NOT NULL,
    sender_type character varying(255) NOT NULL,
    sender_id bigint NOT NULL,
    receiver_type character varying(255) NOT NULL,
    receiver_id bigint NOT NULL,
    last_message text,
    last_message_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: chat_conversations_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.chat_conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.chat_conversations_id_seq OWNED BY testing.chat_conversations.id;


--
-- Name: chat_messages; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.chat_messages (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    sender_type character varying(255) NOT NULL,
    sender_id bigint NOT NULL,
    message text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: chat_messages_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.chat_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.chat_messages_id_seq OWNED BY testing.chat_messages.id;


--
-- Name: configs; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.configs (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: configs_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: configs_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.configs_id_seq OWNED BY testing.configs.id;


--
-- Name: districts; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.districts (
    id bigint NOT NULL,
    state_id bigint NOT NULL,
    lgd_code bigint NOT NULL,
    district_name character varying(100) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.districts_id_seq OWNED BY testing.districts.id;


--
-- Name: employer_profiles; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.employer_profiles (
    id bigint NOT NULL,
    employer_id bigint,
    emp_type character varying(255),
    name character varying(100),
    avg_worker character varying(255),
    work_type character varying(255),
    location character varying(255),
    availability character varying(255),
    eshram character varying(255),
    aadhar character varying(255),
    "docType" character varying(255),
    "docNumber" character varying(255),
    pdf character varying(255),
    bocw character varying(255),
    language character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    plot_no character varying(255),
    street_area_village character varying(255),
    post_office character varying(255),
    district character varying(255),
    state character varying(255),
    pin_code character varying(255),
    profile_image character varying(255),
    gender character varying(255),
    CONSTRAINT employer_profiles_gender_check CHECK (((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying, 'other'::character varying])::text[])))
);


--
-- Name: employer_profiles_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.employer_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.employer_profiles_id_seq OWNED BY testing.employer_profiles.id;


--
-- Name: employer_skills; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.employer_skills (
    id bigint NOT NULL,
    employer_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: employer_skills_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.employer_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.employer_skills_id_seq OWNED BY testing.employer_skills.id;


--
-- Name: employers; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.employers (
    id bigint NOT NULL,
    email character varying(255),
    phone character varying(10) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255),
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    otp character varying(255),
    otp_expires_at timestamp(0) without time zone
);


--
-- Name: employers_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.employers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employers_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.employers_id_seq OWNED BY testing.employers.id;


--
-- Name: facilities; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.facilities (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: facilities_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.facilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.facilities_id_seq OWNED BY testing.facilities.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.failed_jobs_id_seq OWNED BY testing.failed_jobs.id;


--
-- Name: job_applications; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.job_applications (
    id bigint NOT NULL,
    worker_id bigint NOT NULL,
    job_post_id bigint NOT NULL,
    employer_id bigint NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    note text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT job_applications_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'accepted'::character varying, 'rejected'::character varying])::text[])))
);


--
-- Name: job_applications_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.job_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.job_applications_id_seq OWNED BY testing.job_applications.id;


--
-- Name: job_post_facilities; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.job_post_facilities (
    id bigint NOT NULL,
    job_post_id bigint NOT NULL,
    facility_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: job_post_facilities_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.job_post_facilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_post_facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.job_post_facilities_id_seq OWNED BY testing.job_post_facilities.id;


--
-- Name: job_posts; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.job_posts (
    id bigint NOT NULL,
    employer_id bigint NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(255),
    skills_id json,
    qualification character varying(255),
    rate character varying(255),
    job_type character varying(255),
    work_location character varying(255),
    start_date date,
    end_date date,
    work_duration character varying(255),
    address character varying(255),
    state character varying(255),
    district character varying(255),
    pincode character varying(255),
    lat character varying(255),
    long character varying(255),
    tools_required character varying(255),
    required_people integer,
    work_time character varying(255),
    status boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: job_posts_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.job_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.job_posts_id_seq OWNED BY testing.job_posts.id;


--
-- Name: migrations; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.migrations_id_seq OWNED BY testing.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


--
-- Name: personal_access_tokens; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.personal_access_tokens_id_seq OWNED BY testing.personal_access_tokens.id;


--
-- Name: schemes_pages; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.schemes_pages (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    url character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: schemes_pages_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.schemes_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schemes_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.schemes_pages_id_seq OWNED BY testing.schemes_pages.id;


--
-- Name: skills; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.skills (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.skills_id_seq OWNED BY testing.skills.id;


--
-- Name: states; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.states (
    id bigint NOT NULL,
    lgd_code bigint NOT NULL,
    state_name character varying(100) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.states_id_seq OWNED BY testing.states.id;


--
-- Name: users; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    phone character varying(20),
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255),
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.users_id_seq OWNED BY testing.users.id;


--
-- Name: worker_educations; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.worker_educations (
    id bigint NOT NULL,
    worker_id bigint NOT NULL,
    education_level character varying(100) NOT NULL,
    institution character varying(150),
    passing_year character varying(4),
    certificate_path character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: worker_educations_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.worker_educations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: worker_educations_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.worker_educations_id_seq OWNED BY testing.worker_educations.id;


--
-- Name: worker_histories; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.worker_histories (
    id bigint NOT NULL,
    worker_id bigint NOT NULL,
    employer_id bigint,
    employer_name character varying(255),
    project_name character varying(255),
    work_place character varying(255),
    work_type character varying(255),
    skill_id json,
    task_description text,
    start_date date,
    end_date date,
    days_worked integer,
    daily_wage numeric(10,2),
    total_amount numeric(10,2),
    payment_status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    remarks text,
    rating integer,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT worker_histories_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['pending'::character varying, 'paid'::character varying, 'partial'::character varying])::text[])))
);


--
-- Name: worker_histories_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.worker_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: worker_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.worker_histories_id_seq OWNED BY testing.worker_histories.id;


--
-- Name: worker_profiles; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.worker_profiles (
    id bigint NOT NULL,
    worker_id bigint,
    name character varying(100),
    rate character varying(20),
    age integer,
    skill_id json,
    experience character varying(255),
    work_type character varying(255),
    location character varying(255),
    availability character varying(255),
    eshram character varying(255),
    "docType" character varying(255),
    "docNumber" character varying(255),
    pdf character varying(255),
    language character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    plot_no character varying(255),
    street_area_village character varying(255),
    post_office character varying(255),
    district character varying(255),
    state character varying(255),
    pin_code character varying(255),
    profile_image character varying(255),
    gender character varying(255),
    lat character varying(255),
    long character varying(255),
    CONSTRAINT worker_profiles_gender_check CHECK (((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying, 'other'::character varying])::text[])))
);


--
-- Name: worker_profiles_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.worker_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: worker_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.worker_profiles_id_seq OWNED BY testing.worker_profiles.id;


--
-- Name: workers; Type: TABLE; Schema: testing; Owner: -
--

CREATE TABLE testing.workers (
    id bigint NOT NULL,
    email character varying(100),
    phone character varying(10) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    otp character varying(255),
    otp_expires_at timestamp(0) without time zone
);


--
-- Name: workers_id_seq; Type: SEQUENCE; Schema: testing; Owner: -
--

CREATE SEQUENCE testing.workers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workers_id_seq; Type: SEQUENCE OWNED BY; Schema: testing; Owner: -
--

ALTER SEQUENCE testing.workers_id_seq OWNED BY testing.workers.id;


--
-- Name: chat_conversations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_conversations ALTER COLUMN id SET DEFAULT nextval('public.chat_conversations_id_seq'::regclass);


--
-- Name: chat_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages ALTER COLUMN id SET DEFAULT nextval('public.chat_messages_id_seq'::regclass);


--
-- Name: configs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configs ALTER COLUMN id SET DEFAULT nextval('public.configs_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);


--
-- Name: employer_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_profiles ALTER COLUMN id SET DEFAULT nextval('public.employer_profiles_id_seq'::regclass);


--
-- Name: employer_skills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_skills ALTER COLUMN id SET DEFAULT nextval('public.employer_skills_id_seq'::regclass);


--
-- Name: employers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employers ALTER COLUMN id SET DEFAULT nextval('public.employers_id_seq'::regclass);


--
-- Name: facilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities ALTER COLUMN id SET DEFAULT nextval('public.facilities_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: job_applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_applications ALTER COLUMN id SET DEFAULT nextval('public.job_applications_id_seq'::regclass);


--
-- Name: job_post_facilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_post_facilities ALTER COLUMN id SET DEFAULT nextval('public.job_post_facilities_id_seq'::regclass);


--
-- Name: job_posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_posts ALTER COLUMN id SET DEFAULT nextval('public.job_posts_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: schemes_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schemes_pages ALTER COLUMN id SET DEFAULT nextval('public.schemes_pages_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- Name: states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states ALTER COLUMN id SET DEFAULT nextval('public.states_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: worker_educations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_educations ALTER COLUMN id SET DEFAULT nextval('public.worker_educations_id_seq'::regclass);


--
-- Name: worker_histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_histories ALTER COLUMN id SET DEFAULT nextval('public.worker_histories_id_seq'::regclass);


--
-- Name: worker_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_profiles ALTER COLUMN id SET DEFAULT nextval('public.worker_profiles_id_seq'::regclass);


--
-- Name: workers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workers ALTER COLUMN id SET DEFAULT nextval('public.workers_id_seq'::regclass);


--
-- Name: chat_conversations id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.chat_conversations ALTER COLUMN id SET DEFAULT nextval('testing.chat_conversations_id_seq'::regclass);


--
-- Name: chat_messages id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.chat_messages ALTER COLUMN id SET DEFAULT nextval('testing.chat_messages_id_seq'::regclass);


--
-- Name: configs id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.configs ALTER COLUMN id SET DEFAULT nextval('testing.configs_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.districts ALTER COLUMN id SET DEFAULT nextval('testing.districts_id_seq'::regclass);


--
-- Name: employer_profiles id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employer_profiles ALTER COLUMN id SET DEFAULT nextval('testing.employer_profiles_id_seq'::regclass);


--
-- Name: employer_skills id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employer_skills ALTER COLUMN id SET DEFAULT nextval('testing.employer_skills_id_seq'::regclass);


--
-- Name: employers id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employers ALTER COLUMN id SET DEFAULT nextval('testing.employers_id_seq'::regclass);


--
-- Name: facilities id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.facilities ALTER COLUMN id SET DEFAULT nextval('testing.facilities_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.failed_jobs ALTER COLUMN id SET DEFAULT nextval('testing.failed_jobs_id_seq'::regclass);


--
-- Name: job_applications id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_applications ALTER COLUMN id SET DEFAULT nextval('testing.job_applications_id_seq'::regclass);


--
-- Name: job_post_facilities id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_post_facilities ALTER COLUMN id SET DEFAULT nextval('testing.job_post_facilities_id_seq'::regclass);


--
-- Name: job_posts id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_posts ALTER COLUMN id SET DEFAULT nextval('testing.job_posts_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.migrations ALTER COLUMN id SET DEFAULT nextval('testing.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('testing.personal_access_tokens_id_seq'::regclass);


--
-- Name: schemes_pages id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.schemes_pages ALTER COLUMN id SET DEFAULT nextval('testing.schemes_pages_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.skills ALTER COLUMN id SET DEFAULT nextval('testing.skills_id_seq'::regclass);


--
-- Name: states id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.states ALTER COLUMN id SET DEFAULT nextval('testing.states_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.users ALTER COLUMN id SET DEFAULT nextval('testing.users_id_seq'::regclass);


--
-- Name: worker_educations id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_educations ALTER COLUMN id SET DEFAULT nextval('testing.worker_educations_id_seq'::regclass);


--
-- Name: worker_histories id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_histories ALTER COLUMN id SET DEFAULT nextval('testing.worker_histories_id_seq'::regclass);


--
-- Name: worker_profiles id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_profiles ALTER COLUMN id SET DEFAULT nextval('testing.worker_profiles_id_seq'::regclass);


--
-- Name: workers id; Type: DEFAULT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.workers ALTER COLUMN id SET DEFAULT nextval('testing.workers_id_seq'::regclass);


--
-- Data for Name: chat_conversations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chat_conversations (id, sender_type, sender_id, receiver_type, receiver_id, last_message, last_message_at, created_at, updated_at) FROM stdin;
2	worker	3	employer	2	hgghk	2026-09-01 10:42:37	2026-08-24 11:36:58	2026-09-01 10:42:37
3	employer	2	worker	4	\N	\N	2026-09-01 10:42:56	2026-09-01 10:42:56
\.


--
-- Data for Name: chat_messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chat_messages (id, conversation_id, sender_type, sender_id, message, created_at, updated_at) FROM stdin;
2	2	worker	3	gtgtg	2026-08-24 11:37:03	2026-08-24 11:37:03
3	2	worker	3	gtrg	2026-08-24 11:37:06	2026-08-24 11:37:06
4	2	employer	2	hgghk	2026-09-01 10:42:37	2026-09-01 10:42:37
\.


--
-- Data for Name: configs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.configs (id, key, value, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.districts (id, state_id, lgd_code, district_name, created_at, updated_at) FROM stdin;
1	35	603	Nicobars	\N	\N
2	35	632	North And Middle Andaman	\N	\N
3	35	602	South Andamans	\N	\N
4	28	745	Alluri Sitharama Raju	\N	\N
5	28	744	Anakapalli	\N	\N
6	28	502	Ananthapuramu	\N	\N
7	28	753	Annamayya	\N	\N
8	28	750	Bapatla	\N	\N
9	28	503	Chittoor	\N	\N
10	28	747	Dr. B.R. Ambedkar Konaseema	\N	\N
11	28	505	East Godavari	\N	\N
12	28	748	Eluru	\N	\N
13	28	506	Guntur	\N	\N
14	28	746	Kakinada	\N	\N
15	28	510	Krishna	\N	\N
16	28	511	Kurnool	\N	\N
17	28	755	Nandyal	\N	\N
18	28	749	Ntr	\N	\N
19	28	751	Palnadu	\N	\N
20	28	743	Parvathipuram Manyam	\N	\N
21	28	517	Prakasam	\N	\N
22	28	519	Srikakulam	\N	\N
23	28	515	Sri Potti Sriramulu Nellore	\N	\N
24	28	754	Sri Sathya Sai	\N	\N
25	28	752	Tirupati	\N	\N
26	28	520	Visakhapatnam	\N	\N
27	28	521	Vizianagaram	\N	\N
28	28	523	West Godavari	\N	\N
29	28	504	Y.S.R.	\N	\N
30	12	628	Anjaw	\N	\N
31	12	229	Changlang	\N	\N
32	12	230	Dibang Valley	\N	\N
33	12	231	East Kameng	\N	\N
34	12	232	East Siang	\N	\N
35	12	718	Kamle	\N	\N
36	12	677	Kra Daadi	\N	\N
37	12	233	Kurung Kumey	\N	\N
38	12	724	Leparada	\N	\N
39	12	234	Lohit	\N	\N
40	12	666	Longding	\N	\N
41	12	235	Lower Dibang Valley	\N	\N
42	12	719	Lower Siang	\N	\N
43	12	236	Lower Subansiri	\N	\N
44	12	678	Namsai	\N	\N
45	12	723	Pakke Kessang	\N	\N
46	12	237	Papum Pare	\N	\N
47	12	725	Shi Yomi	\N	\N
48	12	679	Siang	\N	\N
49	12	238	Tawang	\N	\N
50	12	239	Tirap	\N	\N
51	12	240	Upper Siang	\N	\N
52	12	241	Upper Subansiri	\N	\N
53	12	242	West Kameng	\N	\N
54	12	243	West Siang	\N	\N
55	18	739	Bajali	\N	\N
56	18	616	Baksa	\N	\N
57	18	280	Barpeta	\N	\N
58	18	705	Biswanath	\N	\N
59	18	281	Bongaigaon	\N	\N
60	18	282	Cachar	\N	\N
61	18	708	Charaideo	\N	\N
62	18	612	Chirang	\N	\N
63	18	283	Darrang	\N	\N
64	18	284	Dhemaji	\N	\N
65	18	285	Dhubri	\N	\N
66	18	286	Dibrugarh	\N	\N
67	18	299	Dima Hasao	\N	\N
68	18	287	Goalpara	\N	\N
69	18	288	Golaghat	\N	\N
70	18	289	Hailakandi	\N	\N
71	18	709	Hojai	\N	\N
72	18	290	Jorhat	\N	\N
73	18	291	Kamrup	\N	\N
74	18	618	Kamrup Metro	\N	\N
75	18	292	Karbi Anglong	\N	\N
76	18	293	Karimganj	\N	\N
77	18	294	Kokrajhar	\N	\N
78	18	295	Lakhimpur	\N	\N
79	18	706	Majuli	\N	\N
80	18	296	Marigaon	\N	\N
81	18	297	Nagaon	\N	\N
82	18	298	Nalbari	\N	\N
83	18	300	Sivasagar	\N	\N
84	18	301	Sonitpur	\N	\N
85	18	707	South Salmara Mancachar	\N	\N
86	18	756	Tamulpur	\N	\N
87	18	302	Tinsukia	\N	\N
88	18	617	Udalguri	\N	\N
89	18	710	West Karbi Anglong	\N	\N
90	10	188	Araria	\N	\N
91	10	611	Arwal	\N	\N
92	10	189	Aurangabad	\N	\N
93	10	190	Banka	\N	\N
94	10	191	Begusarai	\N	\N
95	10	192	Bhagalpur	\N	\N
96	10	193	Bhojpur	\N	\N
97	10	194	Buxar	\N	\N
98	10	195	Darbhanga	\N	\N
99	10	196	Gaya	\N	\N
100	10	197	Gopalganj	\N	\N
101	10	198	Jamui	\N	\N
102	10	199	Jehanabad	\N	\N
103	10	200	Kaimur (Bhabua)	\N	\N
104	10	201	Katihar	\N	\N
105	10	202	Khagaria	\N	\N
106	10	203	Kishanganj	\N	\N
107	10	204	Lakhisarai	\N	\N
108	10	205	Madhepura	\N	\N
109	10	206	Madhubani	\N	\N
110	10	207	Munger	\N	\N
111	10	208	Muzaffarpur	\N	\N
112	10	209	Nalanda	\N	\N
113	10	210	Nawada	\N	\N
114	10	211	Pashchim Champaran	\N	\N
115	10	212	Patna	\N	\N
116	10	213	Purbi Champaran	\N	\N
117	10	214	Purnia	\N	\N
118	10	215	Rohtas	\N	\N
119	10	216	Saharsa	\N	\N
120	10	217	Samastipur	\N	\N
121	10	218	Saran	\N	\N
122	10	219	Sheikhpura	\N	\N
123	10	220	Sheohar	\N	\N
124	10	221	Sitamarhi	\N	\N
125	10	222	Siwan	\N	\N
126	10	223	Supaul	\N	\N
127	10	224	Vaishali	\N	\N
128	4	44	Chandigarh	\N	\N
129	22	646	Balod	\N	\N
130	22	644	Balodabazar-Bhatapara	\N	\N
131	22	649	Balrampur-Ramanujganj	\N	\N
132	22	374	Bastar	\N	\N
133	22	650	Bemetara	\N	\N
134	22	636	Bijapur	\N	\N
135	22	375	Bilaspur	\N	\N
136	22	376	Dakshin Bastar Dantewada	\N	\N
137	22	377	Dhamtari	\N	\N
138	22	378	Durg	\N	\N
139	22	645	Gariyaband	\N	\N
140	22	734	Gaurela-Pendra-Marwahi	\N	\N
141	22	379	Janjgir-Champa	\N	\N
142	22	380	Jashpur	\N	\N
143	22	382	Kabeerdham	\N	\N
144	22	759	Khairagarh-Chhuikhadan-Gandai	\N	\N
145	22	643	Kondagaon	\N	\N
146	22	383	Korba	\N	\N
147	22	384	Korea	\N	\N
148	22	385	Mahasamund	\N	\N
149	22	760	Manendragarh-Chirmiri-Bharatpur(M C B)	\N	\N
150	22	761	Mohla-Manpur-Ambagarh Chouki	\N	\N
151	22	647	Mungeli	\N	\N
152	22	637	Narayanpur	\N	\N
153	22	386	Raigarh	\N	\N
154	22	387	Raipur	\N	\N
155	22	388	Rajnandgaon	\N	\N
156	22	762	Sakti	\N	\N
157	22	763	Sarangarh-Bilaigarh	\N	\N
158	22	642	Sukma	\N	\N
159	22	648	Surajpur	\N	\N
160	22	389	Surguja	\N	\N
161	22	381	Uttar Bastar Kanker	\N	\N
162	7	77	Central	\N	\N
163	7	78	East	\N	\N
164	7	79	New Delhi	\N	\N
165	7	80	North	\N	\N
166	7	81	North East	\N	\N
167	7	82	North West	\N	\N
168	7	671	Shahdara	\N	\N
169	7	83	South	\N	\N
170	7	670	South East	\N	\N
171	7	84	South West	\N	\N
172	7	85	West	\N	\N
173	30	551	North Goa	\N	\N
174	30	552	South Goa	\N	\N
175	24	438	Ahmedabad	\N	\N
176	24	439	Amreli	\N	\N
177	24	440	Anand	\N	\N
178	24	672	Arvalli	\N	\N
179	24	441	Banas Kantha	\N	\N
180	24	442	Bharuch	\N	\N
181	24	443	Bhavnagar	\N	\N
182	24	676	Botad	\N	\N
183	24	668	Chhotaudepur	\N	\N
184	24	445	Dahod	\N	\N
185	24	444	Dangs	\N	\N
186	24	674	Devbhumi Dwarka	\N	\N
187	24	446	Gandhinagar	\N	\N
188	24	675	Gir Somnath	\N	\N
189	24	447	Jamnagar	\N	\N
190	24	448	Junagadh	\N	\N
191	24	449	Kachchh	\N	\N
192	24	450	Kheda	\N	\N
193	24	451	Mahesana	\N	\N
194	24	669	Mahisagar	\N	\N
195	24	673	Morbi	\N	\N
196	24	452	Narmada	\N	\N
197	24	453	Navsari	\N	\N
198	24	454	Panch Mahals	\N	\N
199	24	455	Patan	\N	\N
200	24	456	Porbandar	\N	\N
201	24	457	Rajkot	\N	\N
202	24	458	Sabar Kantha	\N	\N
203	24	459	Surat	\N	\N
204	24	460	Surendranagar	\N	\N
205	24	641	Tapi	\N	\N
206	24	461	Vadodara	\N	\N
207	24	462	Valsad	\N	\N
208	6	58	Ambala	\N	\N
209	6	59	Bhiwani	\N	\N
210	6	701	Charki Dadri	\N	\N
211	6	60	Faridabad	\N	\N
212	6	61	Fatehabad	\N	\N
213	6	62	Gurugram	\N	\N
214	6	63	Hisar	\N	\N
215	6	64	Jhajjar	\N	\N
216	6	65	Jind	\N	\N
217	6	66	Kaithal	\N	\N
218	6	67	Karnal	\N	\N
219	6	68	Kurukshetra	\N	\N
220	6	69	Mahendragarh	\N	\N
221	6	604	Nuh	\N	\N
222	6	619	Palwal	\N	\N
223	6	70	Panchkula	\N	\N
224	6	71	Panipat	\N	\N
225	6	72	Rewari	\N	\N
226	6	73	Rohtak	\N	\N
227	6	74	Sirsa	\N	\N
228	6	75	Sonipat	\N	\N
229	6	76	Yamunanagar	\N	\N
230	2	15	Bilaspur	\N	\N
231	2	16	Chamba	\N	\N
232	2	17	Hamirpur	\N	\N
233	2	18	Kangra	\N	\N
234	2	19	Kinnaur	\N	\N
235	2	20	Kullu	\N	\N
236	2	21	Lahaul And Spiti	\N	\N
237	2	22	Mandi	\N	\N
238	2	23	Shimla	\N	\N
239	2	24	Sirmaur	\N	\N
240	2	25	Solan	\N	\N
241	2	26	Una	\N	\N
242	1	1	Anantnag	\N	\N
243	1	623	Bandipora	\N	\N
244	1	3	Baramulla	\N	\N
245	1	2	Budgam	\N	\N
246	1	4	Doda	\N	\N
247	1	626	Ganderbal	\N	\N
248	1	5	Jammu	\N	\N
249	1	7	Kathua	\N	\N
250	1	620	Kishtwar	\N	\N
251	1	622	Kulgam	\N	\N
252	1	8	Kupwara	\N	\N
253	1	10	Poonch	\N	\N
254	1	11	Pulwama	\N	\N
255	1	12	Rajouri	\N	\N
256	1	621	Ramban	\N	\N
257	1	627	Reasi	\N	\N
258	1	624	Samba	\N	\N
259	1	625	Shopian	\N	\N
260	1	13	Srinagar	\N	\N
261	1	14	Udhampur	\N	\N
262	20	322	Bokaro	\N	\N
263	20	323	Chatra	\N	\N
264	20	324	Deoghar	\N	\N
265	20	325	Dhanbad	\N	\N
266	20	326	Dumka	\N	\N
267	20	327	East Singhbum	\N	\N
268	20	328	Garhwa	\N	\N
269	20	329	Giridih	\N	\N
270	20	330	Godda	\N	\N
271	20	331	Gumla	\N	\N
272	20	332	Hazaribagh	\N	\N
273	20	333	Jamtara	\N	\N
274	20	606	Khunti	\N	\N
275	20	334	Koderma	\N	\N
276	20	335	Latehar	\N	\N
277	20	336	Lohardaga	\N	\N
278	20	337	Pakur	\N	\N
279	20	338	Palamu	\N	\N
280	20	607	Ramgarh	\N	\N
281	20	339	Ranchi	\N	\N
282	20	340	Sahebganj	\N	\N
283	20	341	Saraikela Kharsawan	\N	\N
284	20	342	Simdega	\N	\N
285	20	343	West Singhbhum	\N	\N
286	29	524	Bagalkote	\N	\N
287	29	528	Ballari	\N	\N
288	29	527	Belagavi	\N	\N
289	29	526	Bengaluru Rural	\N	\N
290	29	525	Bengaluru Urban	\N	\N
291	29	529	Bidar	\N	\N
292	29	531	Chamarajanagara	\N	\N
293	29	630	Chikkaballapura	\N	\N
294	29	532	Chikkamagaluru	\N	\N
295	29	533	Chitradurga	\N	\N
296	29	534	Dakshina Kannada	\N	\N
297	29	535	Davangere	\N	\N
298	29	536	Dharwad	\N	\N
299	29	537	Gadag	\N	\N
300	29	539	Hassan	\N	\N
301	29	540	Haveri	\N	\N
302	29	538	Kalaburagi	\N	\N
303	29	541	Kodagu	\N	\N
304	29	542	Kolar	\N	\N
305	29	543	Koppal	\N	\N
306	29	544	Mandya	\N	\N
307	29	545	Mysuru	\N	\N
308	29	546	Raichur	\N	\N
309	29	631	Ramanagara	\N	\N
310	29	547	Shivamogga	\N	\N
311	29	548	Tumakuru	\N	\N
312	29	549	Udupi	\N	\N
313	29	550	Uttara Kannada	\N	\N
314	29	738	Vijayanagar	\N	\N
315	29	530	Vijayapura	\N	\N
316	29	635	Yadgir	\N	\N
317	32	554	Alappuzha	\N	\N
318	32	555	Ernakulam	\N	\N
319	32	556	Idukki	\N	\N
320	32	557	Kannur	\N	\N
321	32	558	Kasaragod	\N	\N
322	32	559	Kollam	\N	\N
323	32	560	Kottayam	\N	\N
324	32	561	Kozhikode	\N	\N
325	32	562	Malappuram	\N	\N
326	32	563	Palakkad	\N	\N
327	32	564	Pathanamthitta	\N	\N
328	32	565	Thiruvananthapuram	\N	\N
329	32	566	Thrissur	\N	\N
330	32	567	Wayanad	\N	\N
331	37	6	Kargil	\N	\N
332	37	9	Leh Ladakh	\N	\N
333	31	553	Lakshadweep District	\N	\N
334	23	667	Agar-Malwa	\N	\N
335	23	639	Alirajpur	\N	\N
336	23	390	Anuppur	\N	\N
337	23	391	Ashoknagar	\N	\N
338	23	392	Balaghat	\N	\N
339	23	393	Barwani	\N	\N
340	23	394	Betul	\N	\N
341	23	395	Bhind	\N	\N
342	23	396	Bhopal	\N	\N
343	23	397	Burhanpur	\N	\N
344	23	398	Chhatarpur	\N	\N
345	23	399	Chhindwara	\N	\N
346	23	400	Damoh	\N	\N
347	23	401	Datia	\N	\N
348	23	402	Dewas	\N	\N
349	23	403	Dhar	\N	\N
350	23	404	Dindori	\N	\N
351	23	406	Guna	\N	\N
352	23	407	Gwalior	\N	\N
353	23	408	Harda	\N	\N
354	23	410	Indore	\N	\N
355	23	411	Jabalpur	\N	\N
356	23	412	Jhabua	\N	\N
357	23	413	Katni	\N	\N
358	23	405	Khandwa (East Nimar)	\N	\N
359	23	414	Khargone (West Nimar)	\N	\N
360	23	784	Maihar	\N	\N
361	23	415	Mandla	\N	\N
362	23	416	Mandsaur	\N	\N
363	23	766	MAUGANJ	\N	\N
364	23	417	Morena	\N	\N
365	23	409	Narmadapuram	\N	\N
366	23	418	Narsimhapur	\N	\N
367	23	419	Neemuch	\N	\N
368	23	722	Niwari	\N	\N
369	23	785	Pandhurna	\N	\N
370	23	420	Panna	\N	\N
371	23	421	Raisen	\N	\N
372	23	422	Rajgarh	\N	\N
373	23	423	Ratlam	\N	\N
374	23	424	Rewa	\N	\N
375	23	425	Sagar	\N	\N
376	23	426	Satna	\N	\N
377	23	427	Sehore	\N	\N
378	23	428	Seoni	\N	\N
379	23	429	Shahdol	\N	\N
380	23	430	Shajapur	\N	\N
381	23	431	Sheopur	\N	\N
382	23	432	Shivpuri	\N	\N
383	23	433	Sidhi	\N	\N
384	23	638	Singrauli	\N	\N
385	23	434	Tikamgarh	\N	\N
386	23	435	Ujjain	\N	\N
387	23	436	Umaria	\N	\N
388	23	437	Vidisha	\N	\N
389	27	466	Ahmednagar	\N	\N
390	27	467	Akola	\N	\N
391	27	468	Amravati	\N	\N
392	27	470	Beed	\N	\N
393	27	471	Bhandara	\N	\N
394	27	472	Buldhana	\N	\N
395	27	473	Chandrapur	\N	\N
396	21	368	Nuapada	\N	\N
397	27	469	Chhatrapati Sambhajinagar	\N	\N
398	27	488	Dharashiv	\N	\N
399	27	474	Dhule	\N	\N
400	27	475	Gadchiroli	\N	\N
401	27	476	Gondia	\N	\N
402	27	477	Hingoli	\N	\N
403	27	478	Jalgaon	\N	\N
404	27	479	Jalna	\N	\N
405	27	480	Kolhapur	\N	\N
406	27	481	Latur	\N	\N
407	27	482	Mumbai	\N	\N
408	27	483	Mumbai Suburban	\N	\N
409	27	484	Nagpur	\N	\N
410	27	485	Nanded	\N	\N
411	27	486	Nandurbar	\N	\N
412	27	487	Nashik	\N	\N
413	27	665	Palghar	\N	\N
414	27	489	Parbhani	\N	\N
415	27	490	Pune	\N	\N
416	27	491	Raigad	\N	\N
417	27	492	Ratnagiri	\N	\N
418	27	493	Sangli	\N	\N
419	27	494	Satara	\N	\N
420	27	495	Sindhudurg	\N	\N
421	27	496	Solapur	\N	\N
422	27	497	Thane	\N	\N
423	27	498	Wardha	\N	\N
424	27	499	Washim	\N	\N
425	27	500	Yavatmal	\N	\N
426	14	252	Bishnupur	\N	\N
427	14	253	Chandel	\N	\N
428	14	254	Churachandpur	\N	\N
429	14	255	Imphal East	\N	\N
430	14	256	Imphal West	\N	\N
431	14	713	Jiribam	\N	\N
432	14	711	Kakching	\N	\N
433	14	717	Kamjong	\N	\N
434	14	712	Kangpokpi	\N	\N
435	14	714	Noney	\N	\N
436	14	715	Pherzawl	\N	\N
437	14	257	Senapati	\N	\N
438	14	258	Tamenglong	\N	\N
439	14	716	Tengnoupal	\N	\N
440	14	259	Thoubal	\N	\N
441	14	260	Ukhrul	\N	\N
442	17	740	Eastern West Khasi Hills	\N	\N
443	17	273	East Garo Hills	\N	\N
444	17	657	East Jaintia Hills	\N	\N
445	17	274	East Khasi Hills	\N	\N
446	17	656	North Garo Hills	\N	\N
447	17	276	Ri Bhoi	\N	\N
448	17	277	South Garo Hills	\N	\N
449	17	663	South West Garo Hills	\N	\N
450	17	658	South West Khasi Hills	\N	\N
451	17	278	West Garo Hills	\N	\N
452	17	275	West Jaintia Hills	\N	\N
453	17	279	West Khasi Hills	\N	\N
454	15	261	Aizawl	\N	\N
455	15	262	Champhai	\N	\N
456	15	726	Hnahthial	\N	\N
457	15	728	Khawzawl	\N	\N
458	15	263	Kolasib	\N	\N
459	15	264	Lawngtlai	\N	\N
460	15	265	Lunglei	\N	\N
461	15	266	Mamit	\N	\N
462	15	727	Saitual	\N	\N
463	15	268	Serchhip	\N	\N
464	15	267	Siaha	\N	\N
465	13	758	Chumoukedima	\N	\N
466	13	244	Dimapur	\N	\N
467	13	614	Kiphire	\N	\N
468	13	245	Kohima	\N	\N
469	13	615	Longleng	\N	\N
470	13	246	Mokokchung	\N	\N
471	13	247	Mon	\N	\N
472	13	764	Niuland	\N	\N
473	13	736	Noklak	\N	\N
474	13	613	Peren	\N	\N
475	13	248	Phek	\N	\N
476	13	765	Shamator	\N	\N
477	13	757	Tseminyu	\N	\N
478	13	249	Tuensang	\N	\N
479	13	250	Wokha	\N	\N
480	13	251	Zunheboto	\N	\N
481	21	344	Anugul	\N	\N
482	21	345	Balangir	\N	\N
483	21	346	Baleshwar	\N	\N
484	21	347	Bargarh	\N	\N
485	21	348	Bhadrak	\N	\N
486	21	349	Boudh	\N	\N
487	21	350	Cuttack	\N	\N
488	21	351	Deogarh	\N	\N
489	21	352	Dhenkanal	\N	\N
490	21	353	Gajapati	\N	\N
491	21	354	Ganjam	\N	\N
492	21	355	Jagatsinghapur	\N	\N
493	21	356	Jajapur	\N	\N
494	21	357	Jharsuguda	\N	\N
495	21	358	Kalahandi	\N	\N
496	21	359	Kandhamal	\N	\N
497	21	360	Kendrapara	\N	\N
498	21	361	Kendujhar	\N	\N
499	21	362	Khordha	\N	\N
500	21	363	Koraput	\N	\N
501	21	364	Malkangiri	\N	\N
502	21	365	Mayurbhanj	\N	\N
503	21	366	Nabarangpur	\N	\N
504	21	367	Nayagarh	\N	\N
505	21	369	Puri	\N	\N
506	21	370	Rayagada	\N	\N
507	21	371	Sambalpur	\N	\N
508	21	372	Sonepur	\N	\N
509	21	373	Sundargarh	\N	\N
510	34	598	Karaikal	\N	\N
511	34	599	Mahe	\N	\N
512	34	600	Pondicherry	\N	\N
513	34	601	Yanam	\N	\N
514	3	27	Amritsar	\N	\N
515	3	605	Barnala	\N	\N
516	3	28	Bathinda	\N	\N
517	3	29	Faridkot	\N	\N
518	3	30	Fatehgarh Sahib	\N	\N
519	3	651	Fazilka	\N	\N
520	3	31	Ferozepur	\N	\N
521	3	32	Gurdaspur	\N	\N
522	3	33	Hoshiarpur	\N	\N
523	3	34	Jalandhar	\N	\N
524	3	35	Kapurthala	\N	\N
525	3	36	Ludhiana	\N	\N
526	3	737	Malerkotla	\N	\N
527	3	37	Mansa	\N	\N
528	3	38	Moga	\N	\N
529	3	662	Pathankot	\N	\N
530	3	41	Patiala	\N	\N
531	3	42	Rupnagar	\N	\N
532	3	43	Sangrur	\N	\N
533	3	608	S.A.S Nagar	\N	\N
534	3	40	Shahid Bhagat Singh Nagar	\N	\N
535	3	39	Sri Muktsar Sahib	\N	\N
536	3	609	Tarn Taran	\N	\N
537	8	86	Ajmer	\N	\N
538	8	87	Alwar	\N	\N
539	8	776	Anupgarh	\N	\N
540	8	775	Balotra	\N	\N
541	8	88	Banswara	\N	\N
542	8	89	Baran	\N	\N
543	8	90	Barmer	\N	\N
544	8	774	Beawar	\N	\N
545	8	91	Bharatpur	\N	\N
546	8	92	Bhilwara	\N	\N
547	8	93	Bikaner	\N	\N
548	8	94	Bundi	\N	\N
549	8	95	Chittorgarh	\N	\N
550	8	96	Churu	\N	\N
551	8	97	Dausa	\N	\N
552	8	767	Deeg	\N	\N
553	8	98	Dholpur	\N	\N
554	8	768	Didwana-Kuchaman	\N	\N
555	8	769	Dudu	\N	\N
556	8	99	Dungarpur	\N	\N
557	8	100	Ganganagar	\N	\N
558	8	771	Gangapurcity	\N	\N
559	8	101	Hanumangarh	\N	\N
560	8	102	Jaipur	\N	\N
561	8	783	Jaipur (Gramin)	\N	\N
562	8	103	Jaisalmer	\N	\N
563	8	104	Jalore	\N	\N
564	8	105	Jhalawar	\N	\N
565	8	106	Jhunjhunu	\N	\N
566	8	107	Jodhpur	\N	\N
567	8	778	Jodhpur (Gramin)	\N	\N
568	8	108	Karauli	\N	\N
569	8	781	Kekri	\N	\N
570	8	770	Khairthal-Tijara	\N	\N
571	8	109	Kota	\N	\N
572	8	782	Kotputli-Behror	\N	\N
573	8	110	Nagaur	\N	\N
574	8	773	Neem Ka Thana	\N	\N
575	8	111	Pali	\N	\N
576	8	772	Phalodi	\N	\N
577	8	629	Pratapgarh	\N	\N
578	8	112	Rajsamand	\N	\N
579	8	777	Salumbar	\N	\N
580	8	779	Sanchore	\N	\N
581	8	113	Sawai Madhopur	\N	\N
582	8	780	Shahpura	\N	\N
583	8	114	Sikar	\N	\N
584	8	115	Sirohi	\N	\N
585	8	116	Tonk	\N	\N
586	8	117	Udaipur	\N	\N
587	11	225	Gangtok	\N	\N
588	11	228	Gyalshing	\N	\N
589	11	226	Mangan	\N	\N
590	11	227	Namchi	\N	\N
591	11	741	Pakyong	\N	\N
592	11	742	Soreng	\N	\N
593	33	610	Ariyalur	\N	\N
594	33	730	Chengalpattu	\N	\N
595	33	568	Chennai	\N	\N
596	33	569	Coimbatore	\N	\N
597	33	570	Cuddalore	\N	\N
598	33	571	Dharmapuri	\N	\N
599	33	572	Dindigul	\N	\N
600	33	573	Erode	\N	\N
601	33	729	Kallakurichi	\N	\N
602	33	574	Kancheepuram	\N	\N
603	33	575	Kanniyakumari	\N	\N
604	33	576	Karur	\N	\N
605	33	577	Krishnagiri	\N	\N
606	33	578	Madurai	\N	\N
607	33	735	Mayiladuthurai	\N	\N
608	33	579	Nagapattinam	\N	\N
609	33	580	Namakkal	\N	\N
610	33	581	Perambalur	\N	\N
611	33	582	Pudukkottai	\N	\N
612	33	583	Ramanathapuram	\N	\N
613	33	731	Ranipet	\N	\N
614	33	584	Salem	\N	\N
615	33	585	Sivaganga	\N	\N
616	33	733	Tenkasi	\N	\N
617	33	586	Thanjavur	\N	\N
618	33	588	Theni	\N	\N
619	33	587	The Nilgiris	\N	\N
620	33	589	Thiruvallur	\N	\N
621	33	590	Thiruvarur	\N	\N
622	33	594	Thoothukkudi	\N	\N
623	33	591	Tiruchirappalli	\N	\N
624	33	592	Tirunelveli	\N	\N
625	33	732	Tirupathur	\N	\N
626	33	634	Tiruppur	\N	\N
627	33	593	Tiruvannamalai	\N	\N
628	33	595	Vellore	\N	\N
629	33	596	Viluppuram	\N	\N
630	33	597	Virudhunagar	\N	\N
631	36	501	Adilabad	\N	\N
632	36	690	Bhadradri Kothagudem	\N	\N
633	36	686	Hanumakonda	\N	\N
634	36	507	Hyderabad	\N	\N
635	36	681	Jagitial	\N	\N
636	36	689	Jangoan	\N	\N
637	36	687	Jayashankar Bhupalapally	\N	\N
638	36	695	Jogulamba Gadwal	\N	\N
639	36	685	Kamareddy	\N	\N
640	36	508	Karimnagar	\N	\N
641	36	509	Khammam	\N	\N
642	36	699	Kumuram Bheem Asifabad	\N	\N
643	36	688	Mahabubabad	\N	\N
644	36	512	Mahabubnagar	\N	\N
645	36	684	Mancherial	\N	\N
646	36	513	Medak	\N	\N
647	36	700	Medchal Malkajgiri	\N	\N
648	36	720	Mulugu	\N	\N
649	36	694	Nagarkurnool	\N	\N
650	36	514	Nalgonda	\N	\N
651	36	721	Narayanpet	\N	\N
652	36	680	Nirmal	\N	\N
653	36	516	Nizamabad	\N	\N
654	36	682	Peddapalli	\N	\N
655	36	683	Rajanna Sircilla	\N	\N
656	36	518	Ranga Reddy	\N	\N
657	36	691	Sangareddy	\N	\N
658	36	692	Siddipet	\N	\N
659	36	696	Suryapet	\N	\N
660	36	698	Vikarabad	\N	\N
661	36	693	Wanaparthy	\N	\N
662	36	522	Warangal	\N	\N
663	36	697	Yadadri Bhuvanagiri	\N	\N
664	38	465	Dadra And Nagar Haveli	\N	\N
665	38	463	Daman	\N	\N
666	38	464	Diu	\N	\N
667	16	269	Dhalai	\N	\N
668	16	654	Gomati	\N	\N
669	16	652	Khowai	\N	\N
670	16	270	North Tripura	\N	\N
671	16	653	Sepahijala	\N	\N
672	16	271	South Tripura	\N	\N
673	16	655	Unakoti	\N	\N
674	16	272	West Tripura	\N	\N
675	5	45	Almora	\N	\N
676	5	46	Bageshwar	\N	\N
677	5	47	Chamoli	\N	\N
678	5	48	Champawat	\N	\N
679	5	49	Dehradun	\N	\N
680	5	50	Haridwar	\N	\N
681	5	51	Nainital	\N	\N
682	5	52	Pauri Garhwal	\N	\N
683	5	53	Pithoragarh	\N	\N
684	5	54	Rudra Prayag	\N	\N
685	5	55	Tehri Garhwal	\N	\N
686	5	56	Udam Singh Nagar	\N	\N
687	5	57	Uttar Kashi	\N	\N
688	9	118	Agra	\N	\N
689	9	119	Aligarh	\N	\N
690	9	121	Ambedkar Nagar	\N	\N
691	9	640	Amethi	\N	\N
692	9	154	Amroha	\N	\N
693	9	122	Auraiya	\N	\N
694	9	140	Ayodhya	\N	\N
695	9	123	Azamgarh	\N	\N
696	9	124	Baghpat	\N	\N
697	9	125	Bahraich	\N	\N
698	9	126	Ballia	\N	\N
699	9	127	Balrampur	\N	\N
700	9	128	Banda	\N	\N
701	9	129	Bara Banki	\N	\N
702	9	130	Bareilly	\N	\N
703	9	131	Basti	\N	\N
704	9	179	Bhadohi	\N	\N
705	9	132	Bijnor	\N	\N
706	9	133	Budaun	\N	\N
707	9	134	Bulandshahr	\N	\N
708	9	135	Chandauli	\N	\N
709	9	136	Chitrakoot	\N	\N
710	9	137	Deoria	\N	\N
711	9	138	Etah	\N	\N
712	9	139	Etawah	\N	\N
713	9	141	Farrukhabad	\N	\N
714	9	142	Fatehpur	\N	\N
715	9	143	Firozabad	\N	\N
716	9	144	Gautam Buddha Nagar	\N	\N
717	9	145	Ghaziabad	\N	\N
718	9	146	Ghazipur	\N	\N
719	9	147	Gonda	\N	\N
720	9	148	Gorakhpur	\N	\N
721	9	149	Hamirpur	\N	\N
722	9	661	Hapur	\N	\N
723	9	150	Hardoi	\N	\N
724	9	163	Hathras	\N	\N
725	9	151	Jalaun	\N	\N
726	9	152	Jaunpur	\N	\N
727	9	153	Jhansi	\N	\N
728	9	155	Kannauj	\N	\N
729	9	156	Kanpur Dehat	\N	\N
730	9	157	Kanpur Nagar	\N	\N
731	9	633	Kasganj	\N	\N
732	9	158	Kaushambi	\N	\N
733	9	159	Kheri	\N	\N
734	9	160	Kushinagar	\N	\N
735	9	161	Lalitpur	\N	\N
736	9	162	Lucknow	\N	\N
737	9	165	Mahoba	\N	\N
738	9	164	Mahrajganj	\N	\N
739	9	166	Mainpuri	\N	\N
740	9	167	Mathura	\N	\N
741	9	168	Mau	\N	\N
742	9	169	Meerut	\N	\N
743	9	170	Mirzapur	\N	\N
744	9	171	Moradabad	\N	\N
745	9	172	Muzaffarnagar	\N	\N
746	9	173	Pilibhit	\N	\N
747	9	174	Pratapgarh	\N	\N
748	9	120	Prayagraj	\N	\N
749	9	175	Rae Bareli	\N	\N
750	9	176	Rampur	\N	\N
751	9	177	Saharanpur	\N	\N
752	9	659	Sambhal	\N	\N
753	9	178	Sant Kabir Nagar	\N	\N
754	9	180	Shahjahanpur	\N	\N
755	9	660	Shamli	\N	\N
756	9	181	Shrawasti	\N	\N
757	9	182	Siddharthnagar	\N	\N
758	9	183	Sitapur	\N	\N
759	9	184	Sonbhadra	\N	\N
760	9	185	Sultanpur	\N	\N
761	9	186	Unnao	\N	\N
762	9	187	Varanasi	\N	\N
763	19	664	Alipurduar	\N	\N
764	19	305	Bankura	\N	\N
765	19	307	Birbhum	\N	\N
766	19	308	Cooch Behar	\N	\N
767	19	310	Dakshin Dinajpur	\N	\N
768	19	309	Darjeeling	\N	\N
769	19	312	Hooghly	\N	\N
770	19	313	Howrah	\N	\N
771	19	314	Jalpaiguri	\N	\N
772	19	703	Jhargram	\N	\N
773	19	702	Kalimpong	\N	\N
774	19	315	Kolkata	\N	\N
775	19	316	Malda	\N	\N
776	19	319	Murshidabad	\N	\N
777	19	320	Nadia	\N	\N
778	19	303	North 24 Parganas	\N	\N
779	19	704	Paschim Bardhaman	\N	\N
780	19	318	Paschim Medinipur	\N	\N
781	19	306	Purba Bardhaman	\N	\N
782	19	317	Purba Medinipur	\N	\N
783	19	321	Purulia	\N	\N
784	19	304	South 24 Parganas	\N	\N
785	19	311	Uttar Dinajpur	\N	\N
\.


--
-- Data for Name: employer_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employer_profiles (id, employer_id, emp_type, name, avg_worker, work_type, location, availability, eshram, aadhar, "docType", "docNumber", pdf, bocw, language, created_at, updated_at, plot_no, street_area_village, post_office, district, state, pin_code, profile_image, gender) FROM stdin;
1	2	\N	ds	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-08-18 12:55:37	2026-08-18 12:55:37	\N	\N	\N	\N	\N	\N	\N	\N
2	3	\N	akshika	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-09-05 06:13:34	2026-09-05 06:13:34	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: employer_skills; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employer_skills (id, employer_id, skill_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: employers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employers (id, email, phone, email_verified_at, password, remember_token, created_at, updated_at, otp, otp_expires_at) FROM stdin;
2	\N	8427398668	\N	$2y$12$vp/r8JEWe5n7OkAGd6OH3OiH9r6GqPssk/YnsdZaFtHoUuypu1ScO	\N	2026-08-18 12:55:37	2026-08-18 12:55:37	\N	\N
3	\N	9015165662	\N	$2y$12$Q7yHQFjwM1W7ONdauD1TZ.a8ehQZWsqHJA0VULRARuGLawtjeRczG	\N	2026-09-05 06:13:34	2026-09-05 06:13:34	\N	\N
\.


--
-- Data for Name: facilities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.facilities (id, name, description, is_active, created_at, updated_at) FROM stdin;
1	Health Insurance	Provides access to basic health coverage and medical benefits.	t	2026-08-21 06:18:07	2026-08-21 06:18:07
2	Pension Scheme	Monthly pension for retired or unorganised sector workers.	t	2026-08-21 06:18:07	2026-08-21 06:18:07
3	Skill Development	Training programs to enhance skills for employment opportunities.	t	2026-08-21 06:18:07	2026-08-21 06:18:07
4	Housing Assistance	Support for affordable housing under government schemes.	t	2026-08-21 06:18:07	2026-08-21 06:18:07
5	Financial Aid	Direct financial support for workers in need.	t	2026-08-21 06:18:08	2026-08-21 06:18:08
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: job_applications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.job_applications (id, worker_id, job_post_id, employer_id, status, note, created_at, updated_at) FROM stdin;
1	3	1	2	pending	\N	2026-08-24 11:36:47	2026-08-24 11:36:47
\.


--
-- Data for Name: job_post_facilities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.job_post_facilities (id, job_post_id, facility_id, created_at, updated_at) FROM stdin;
1	1	4	\N	\N
2	1	2	\N	\N
3	1	1	\N	\N
\.


--
-- Data for Name: job_posts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.job_posts (id, employer_id, title, description, skills_id, qualification, rate, job_type, work_location, start_date, end_date, work_duration, address, state, district, pincode, lat, long, tools_required, required_people, work_time, status, created_at, updated_at) FROM stdin;
1	2	software engineer	works at the data analytics	[19,3,4,1]	\N	56	Contract	\N	2026-08-01	2026-08-31	\N	near water tank majra	2	24	173021	30.4890991	77.5275351	\N	6	\N	t	2026-08-21 06:18:36	2026-08-21 06:18:36
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	2014_10_12_000000_create_users_table	1
2	2014_10_12_100000_create_password_reset_tokens_table	1
3	2019_08_19_000000_create_failed_jobs_table	1
4	2019_12_14_000001_create_personal_access_tokens_table	1
5	2025_10_24_085533_create_worker_table	1
6	2025_10_24_090225_create_employer_table	1
7	2025_10_24_090353_create_employer_profile_table	1
8	2025_10_24_100836_create_worker_profile_table	1
9	2025_10_27_120438_create_job_posts_table	1
10	2025_10_28_055703_add_address_fields_to_employers_table	1
11	2025_10_28_055822_add_address_fields_to_workers_table	1
12	2025_10_28_110413_create_worker_histories_table	1
13	2025_10_29_054250_create_skills_table	1
14	2025_10_29_092519_add_profile_image_and_gender_to_workers_table	1
15	2025_10_29_092520_add_profile_image_and_gender_to_employers_table	1
16	2025_11_17_105416_create_worker_educations_table	1
17	2025_11_18_061205_create_configs_table	1
18	2025_11_18_122429_create_employer_skills	1
19	2025_11_20_050407_create_facilities_table	1
20	2025_11_20_100005_create_job_post_facilities_table	1
21	2025_11_21_101504_create_job_applications_table	1
22	2025_11_24_084749_add_lat_long_to_worker_profiles_table	1
23	2025_11_26_064617_create_schemes_pages_table	1
24	2026_07_14_000000_add_otp_fields_to_users_table	1
25	2026_07_21_000001_create_chat_tables	1
26	2026_08_03_080401_create_states_and_districts_tables	2
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schemes_pages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schemes_pages (id, name, description, url, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.skills (id, name, created_at, updated_at) FROM stdin;
1	Building Construction Labourers, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
2	Helper Mason	2026-08-21 05:02:00	2026-08-21 05:02:00
3	Bricklayerer, Construction	2026-08-21 05:02:00	2026-08-21 05:02:00
4	Builders, Traditional Materials, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
5	Carpenters and Joiners Operatives, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
6	Concrete Placers, Concrete Finishers and Related Workers, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
7	Painters and Related Workers, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
8	Stone Splitters, Cutters and Carvers, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
9	Plumbers and Pipe Fitters, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
10	Helper Electrician	2026-08-21 05:02:00	2026-08-21 05:02:00
11	Lineman, Light and Power/Distribution Lineman	2026-08-21 05:02:00	2026-08-21 05:02:00
12	Tractor Driver, Construction	2026-08-21 05:02:00	2026-08-21 05:02:00
13	Helper Bar Bender and Fixer	2026-08-21 05:02:00	2026-08-21 05:02:00
14	Fitter, Construction/Reinforcement Fitter	2026-08-21 05:02:00	2026-08-21 05:02:00
15	Floor Layers and Tile Setters, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
16	Plasterers, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
17	Maintenance Assistant/Helper	2026-08-21 05:02:00	2026-08-21 05:02:00
18	Roofers, Other	2026-08-21 05:02:00	2026-08-21 05:02:00
19	Assistant Shuttering Carpenter	2026-08-21 05:02:00	2026-08-21 05:02:00
20	Furniture Maker, Wood	2026-08-21 05:02:00	2026-08-21 05:02:00
21	Mechanic, Refrigeration and Air Conditioning	2026-08-21 05:02:00	2026-08-21 05:02:00
22	Concrete Mixer Operator	2026-08-21 05:02:01	2026-08-21 05:02:01
23	Picture Framer/Glaziers, Other	2026-08-21 05:02:01	2026-08-21 05:02:01
24	White Washer	2026-08-21 05:02:01	2026-08-21 05:02:01
25	Insulation Workers, Other	2026-08-21 05:02:01	2026-08-21 05:02:01
26	Scrapper Loader Operator/Loader Operator	2026-08-21 05:02:01	2026-08-21 05:02:01
27	Acoustical Insulator	2026-08-21 05:02:01	2026-08-21 05:02:01
28	Wood Polisher	2026-08-21 05:02:01	2026-08-21 05:02:01
29	Bulldozer Operator	2026-08-21 05:02:01	2026-08-21 05:02:01
30	Power Shovel Operator/Excavator Operator	2026-08-21 05:02:01	2026-08-21 05:02:01
\.


--
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.states (id, lgd_code, state_name, created_at, updated_at) FROM stdin;
1	35	Andaman and Nicobar Islands	2026-08-03 13:36:31	2026-08-03 13:36:31
2	28	Andhra Pradesh	2026-08-03 13:36:31	2026-08-03 13:36:31
3	12	Arunachal Pradesh	2026-08-03 13:36:31	2026-08-03 13:36:31
4	18	Assam	2026-08-03 13:36:31	2026-08-03 13:36:31
5	10	Bihar	2026-08-03 13:36:31	2026-08-03 13:36:31
6	4	Chandigarh	2026-08-03 13:36:31	2026-08-03 13:36:31
7	22	Chhattisgarh	2026-08-03 13:36:31	2026-08-03 13:36:31
8	38	Dadra and Nagar Haveli and Daman and Diu	2026-08-03 13:36:31	2026-08-03 13:36:31
9	7	Delhi	2026-08-03 13:36:31	2026-08-03 13:36:31
10	30	Goa	2026-08-03 13:36:31	2026-08-03 13:36:31
11	24	Gujarat	2026-08-03 13:36:31	2026-08-03 13:36:31
12	6	Haryana	2026-08-03 13:36:31	2026-08-03 13:36:31
13	2	Himachal Pradesh	2026-08-03 13:36:31	2026-08-03 13:36:31
14	1	Jammu and Kashmir	2026-08-03 13:36:31	2026-08-03 13:36:31
15	20	Jharkhand	2026-08-03 13:36:31	2026-08-03 13:36:31
16	29	Karnataka	2026-08-03 13:36:31	2026-08-03 13:36:31
17	32	Kerala	2026-08-03 13:36:31	2026-08-03 13:36:31
18	37	Ladakh	2026-08-03 13:36:31	2026-08-03 13:36:31
19	31	Lakshadweep	2026-08-03 13:36:31	2026-08-03 13:36:31
20	23	Madhya Pradesh	2026-08-03 13:36:31	2026-08-03 13:36:31
21	27	Maharashtra	2026-08-03 13:36:31	2026-08-03 13:36:31
22	14	Manipur	2026-08-03 13:36:31	2026-08-03 13:36:31
23	17	Meghalaya	2026-08-03 13:36:31	2026-08-03 13:36:31
24	15	Mizoram	2026-08-03 13:36:31	2026-08-03 13:36:31
25	13	Nagaland	2026-08-03 13:36:31	2026-08-03 13:36:31
26	21	Odisha	2026-08-03 13:36:31	2026-08-03 13:36:31
27	34	Puducherry	2026-08-03 13:36:31	2026-08-03 13:36:31
28	3	Punjab	2026-08-03 13:36:31	2026-08-03 13:36:31
29	8	Rajasthan	2026-08-03 13:36:31	2026-08-03 13:36:31
30	11	Sikkim	2026-08-03 13:36:31	2026-08-03 13:36:31
31	33	Tamil Nadu	2026-08-03 13:36:31	2026-08-03 13:36:31
32	36	Telangana	2026-08-03 13:36:31	2026-08-03 13:36:31
33	16	Tripura	2026-08-03 13:36:31	2026-08-03 13:36:31
34	9	Uttar Pradesh	2026-08-03 13:36:31	2026-08-03 13:36:31
35	5	Uttarakhand	2026-08-03 13:36:31	2026-08-03 13:36:31
36	19	West Bengal	2026-08-03 13:36:31	2026-08-03 13:36:31
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, phone, email, email_verified_at, password, remember_token, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: worker_educations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.worker_educations (id, worker_id, education_level, institution, passing_year, certificate_path, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: worker_histories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.worker_histories (id, worker_id, employer_id, employer_name, project_name, work_place, work_type, skill_id, task_description, start_date, end_date, days_worked, daily_wage, total_amount, payment_status, remarks, rating, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: worker_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.worker_profiles (id, worker_id, name, rate, age, skill_id, experience, work_type, location, availability, eshram, "docType", "docNumber", pdf, language, created_at, updated_at, plot_no, street_area_village, post_office, district, state, pin_code, profile_image, gender, lat, long) FROM stdin;
3	4	akhika	\N	26	[]	\N	\N	\N	Yes	\N	pancard	EIBJH6886J	1785744021.pdf	\N	2026-08-03 07:48:55	2026-08-11 09:13:57	\N	\N	\N	\N	\N	\N	1785743405.png	female	\N	\N
2	3	AKSHIKA GUPTA	87776	21	[19,27,3,4]	4	Daily Wage	\N	Yes	\N	\N	\N	\N	\N	2026-07-31 13:17:25	2026-08-21 05:25:56	12	Kotrikalan	\N	24	2	173021	1787287191.jpeg	female	30.4890991	77.5275351
\.


--
-- Data for Name: workers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workers (id, email, phone, email_verified_at, password, remember_token, created_at, updated_at, otp, otp_expires_at) FROM stdin;
3	\N	8427398668	\N	$2y$12$w2CRqNFmVfCCchyArhBIIuxfShv/FplO5PFWLc8otsLigp36WpOv2	\N	2026-07-31 13:17:25	2026-07-31 13:17:25	\N	\N
4	\N	6280762865	\N	$2y$12$4MioLZFW385xKQ7ShddJ9ubjUgVRZVIfqOyOjryWmfb/8t/KivAsO	\N	2026-08-03 07:48:55	2026-08-03 07:48:55	\N	\N
5	\N	9015165662	\N	$2y$12$B1/Grl9EACliLvK0.R5Xa.5YwrVJCH4Y8p0H3.eQcJFqEA8eRW0X6	\N	2026-09-03 05:36:08	2026-09-03 05:36:08	\N	\N
\.


--
-- Data for Name: chat_conversations; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.chat_conversations (id, sender_type, sender_id, receiver_type, receiver_id, last_message, last_message_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: chat_messages; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.chat_messages (id, conversation_id, sender_type, sender_id, message, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: configs; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.configs (id, key, value, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: districts; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.districts (id, state_id, lgd_code, district_name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: employer_profiles; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.employer_profiles (id, employer_id, emp_type, name, avg_worker, work_type, location, availability, eshram, aadhar, "docType", "docNumber", pdf, bocw, language, created_at, updated_at, plot_no, street_area_village, post_office, district, state, pin_code, profile_image, gender) FROM stdin;
\.


--
-- Data for Name: employer_skills; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.employer_skills (id, employer_id, skill_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: employers; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.employers (id, email, phone, email_verified_at, password, remember_token, created_at, updated_at, otp, otp_expires_at) FROM stdin;
\.


--
-- Data for Name: facilities; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.facilities (id, name, description, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: job_applications; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.job_applications (id, worker_id, job_post_id, employer_id, status, note, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: job_post_facilities; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.job_post_facilities (id, job_post_id, facility_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: job_posts; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.job_posts (id, employer_id, title, description, skills_id, qualification, rate, job_type, work_location, start_date, end_date, work_duration, address, state, district, pincode, lat, long, tools_required, required_people, work_time, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.migrations (id, migration, batch) FROM stdin;
1	2014_10_12_000000_create_users_table	1
2	2014_10_12_100000_create_password_reset_tokens_table	1
3	2019_08_19_000000_create_failed_jobs_table	1
4	2019_12_14_000001_create_personal_access_tokens_table	1
5	2025_10_24_085533_create_worker_table	1
6	2025_10_24_090225_create_employer_table	1
7	2025_10_24_090353_create_employer_profile_table	1
8	2025_10_24_100836_create_worker_profile_table	1
9	2025_10_27_120438_create_job_posts_table	1
10	2025_10_28_055703_add_address_fields_to_employers_table	1
11	2025_10_28_055822_add_address_fields_to_workers_table	1
12	2025_10_28_110413_create_worker_histories_table	1
13	2025_10_29_054250_create_skills_table	1
14	2025_10_29_092519_add_profile_image_and_gender_to_workers_table	1
15	2025_10_29_092520_add_profile_image_and_gender_to_employers_table	1
16	2025_11_17_105416_create_worker_educations_table	1
17	2025_11_18_061205_create_configs_table	1
18	2025_11_18_122429_create_employer_skills	1
19	2025_11_20_050407_create_facilities_table	1
20	2025_11_20_100005_create_job_post_facilities_table	1
21	2025_11_21_101504_create_job_applications_table	1
22	2025_11_24_084749_add_lat_long_to_worker_profiles_table	1
23	2025_11_26_064617_create_schemes_pages_table	1
24	2026_07_14_000000_add_otp_fields_to_users_table	1
25	2026_07_21_000001_create_chat_tables	1
26	2026_08_03_080401_create_states_and_districts_tables	1
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schemes_pages; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.schemes_pages (id, name, description, url, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: skills; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.skills (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: states; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.states (id, lgd_code, state_name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.users (id, name, phone, email, email_verified_at, password, remember_token, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: worker_educations; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.worker_educations (id, worker_id, education_level, institution, passing_year, certificate_path, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: worker_histories; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.worker_histories (id, worker_id, employer_id, employer_name, project_name, work_place, work_type, skill_id, task_description, start_date, end_date, days_worked, daily_wage, total_amount, payment_status, remarks, rating, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: worker_profiles; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.worker_profiles (id, worker_id, name, rate, age, skill_id, experience, work_type, location, availability, eshram, "docType", "docNumber", pdf, language, created_at, updated_at, plot_no, street_area_village, post_office, district, state, pin_code, profile_image, gender, lat, long) FROM stdin;
\.


--
-- Data for Name: workers; Type: TABLE DATA; Schema: testing; Owner: -
--

COPY testing.workers (id, email, phone, email_verified_at, password, remember_token, created_at, updated_at, otp, otp_expires_at) FROM stdin;
\.


--
-- Name: chat_conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chat_conversations_id_seq', 3, true);


--
-- Name: chat_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chat_messages_id_seq', 4, true);


--
-- Name: configs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.configs_id_seq', 1, false);


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.districts_id_seq', 1, false);


--
-- Name: employer_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employer_profiles_id_seq', 2, true);


--
-- Name: employer_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employer_skills_id_seq', 1, false);


--
-- Name: employers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employers_id_seq', 3, true);


--
-- Name: facilities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.facilities_id_seq', 5, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: job_applications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.job_applications_id_seq', 1, true);


--
-- Name: job_post_facilities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.job_post_facilities_id_seq', 3, true);


--
-- Name: job_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.job_posts_id_seq', 1, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 26, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- Name: schemes_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schemes_pages_id_seq', 1, false);


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.skills_id_seq', 30, true);


--
-- Name: states_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.states_id_seq', 36, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: worker_educations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.worker_educations_id_seq', 1, false);


--
-- Name: worker_histories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.worker_histories_id_seq', 1, false);


--
-- Name: worker_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.worker_profiles_id_seq', 3, true);


--
-- Name: workers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.workers_id_seq', 5, true);


--
-- Name: chat_conversations_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.chat_conversations_id_seq', 1, true);


--
-- Name: chat_messages_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.chat_messages_id_seq', 1, true);


--
-- Name: configs_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.configs_id_seq', 1, false);


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.districts_id_seq', 1, false);


--
-- Name: employer_profiles_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.employer_profiles_id_seq', 1, false);


--
-- Name: employer_skills_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.employer_skills_id_seq', 1, false);


--
-- Name: employers_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.employers_id_seq', 1, true);


--
-- Name: facilities_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.facilities_id_seq', 1, false);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.failed_jobs_id_seq', 1, false);


--
-- Name: job_applications_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.job_applications_id_seq', 1, false);


--
-- Name: job_post_facilities_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.job_post_facilities_id_seq', 1, false);


--
-- Name: job_posts_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.job_posts_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.migrations_id_seq', 26, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.personal_access_tokens_id_seq', 1, false);


--
-- Name: schemes_pages_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.schemes_pages_id_seq', 1, false);


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.skills_id_seq', 1, false);


--
-- Name: states_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.states_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.users_id_seq', 1, false);


--
-- Name: worker_educations_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.worker_educations_id_seq', 1, false);


--
-- Name: worker_histories_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.worker_histories_id_seq', 1, false);


--
-- Name: worker_profiles_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.worker_profiles_id_seq', 1, false);


--
-- Name: workers_id_seq; Type: SEQUENCE SET; Schema: testing; Owner: -
--

SELECT pg_catalog.setval('testing.workers_id_seq', 1, true);


--
-- Name: chat_conversations chat_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_conversations
    ADD CONSTRAINT chat_conversations_pkey PRIMARY KEY (id);


--
-- Name: chat_messages chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (id);


--
-- Name: configs configs_key_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configs
    ADD CONSTRAINT configs_key_unique UNIQUE (key);


--
-- Name: configs configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configs
    ADD CONSTRAINT configs_pkey PRIMARY KEY (id);


--
-- Name: districts districts_lgd_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_lgd_code_unique UNIQUE (lgd_code);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: employer_profiles employer_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_profiles
    ADD CONSTRAINT employer_profiles_pkey PRIMARY KEY (id);


--
-- Name: employer_skills employer_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_skills
    ADD CONSTRAINT employer_skills_pkey PRIMARY KEY (id);


--
-- Name: employers employers_phone_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employers
    ADD CONSTRAINT employers_phone_unique UNIQUE (phone);


--
-- Name: employers employers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employers
    ADD CONSTRAINT employers_pkey PRIMARY KEY (id);


--
-- Name: facilities facilities_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities
    ADD CONSTRAINT facilities_name_unique UNIQUE (name);


--
-- Name: facilities facilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities
    ADD CONSTRAINT facilities_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: job_applications job_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_pkey PRIMARY KEY (id);


--
-- Name: job_applications job_applications_worker_id_job_post_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_worker_id_job_post_id_unique UNIQUE (worker_id, job_post_id);


--
-- Name: job_post_facilities job_post_facilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_post_facilities
    ADD CONSTRAINT job_post_facilities_pkey PRIMARY KEY (id);


--
-- Name: job_posts job_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_posts
    ADD CONSTRAINT job_posts_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: schemes_pages schemes_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schemes_pages
    ADD CONSTRAINT schemes_pages_pkey PRIMARY KEY (id);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: states states_lgd_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_lgd_code_unique UNIQUE (lgd_code);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: worker_educations worker_educations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_educations
    ADD CONSTRAINT worker_educations_pkey PRIMARY KEY (id);


--
-- Name: worker_histories worker_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_histories
    ADD CONSTRAINT worker_histories_pkey PRIMARY KEY (id);


--
-- Name: worker_profiles worker_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_profiles
    ADD CONSTRAINT worker_profiles_pkey PRIMARY KEY (id);


--
-- Name: workers workers_phone_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_phone_unique UNIQUE (phone);


--
-- Name: workers workers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (id);


--
-- Name: chat_conversations chat_conversations_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.chat_conversations
    ADD CONSTRAINT chat_conversations_pkey PRIMARY KEY (id);


--
-- Name: chat_messages chat_messages_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.chat_messages
    ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (id);


--
-- Name: configs configs_key_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.configs
    ADD CONSTRAINT configs_key_unique UNIQUE (key);


--
-- Name: configs configs_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.configs
    ADD CONSTRAINT configs_pkey PRIMARY KEY (id);


--
-- Name: districts districts_lgd_code_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.districts
    ADD CONSTRAINT districts_lgd_code_unique UNIQUE (lgd_code);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: employer_profiles employer_profiles_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employer_profiles
    ADD CONSTRAINT employer_profiles_pkey PRIMARY KEY (id);


--
-- Name: employer_skills employer_skills_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employer_skills
    ADD CONSTRAINT employer_skills_pkey PRIMARY KEY (id);


--
-- Name: employers employers_phone_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employers
    ADD CONSTRAINT employers_phone_unique UNIQUE (phone);


--
-- Name: employers employers_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employers
    ADD CONSTRAINT employers_pkey PRIMARY KEY (id);


--
-- Name: facilities facilities_name_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.facilities
    ADD CONSTRAINT facilities_name_unique UNIQUE (name);


--
-- Name: facilities facilities_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.facilities
    ADD CONSTRAINT facilities_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: job_applications job_applications_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_applications
    ADD CONSTRAINT job_applications_pkey PRIMARY KEY (id);


--
-- Name: job_applications job_applications_worker_id_job_post_id_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_applications
    ADD CONSTRAINT job_applications_worker_id_job_post_id_unique UNIQUE (worker_id, job_post_id);


--
-- Name: job_post_facilities job_post_facilities_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_post_facilities
    ADD CONSTRAINT job_post_facilities_pkey PRIMARY KEY (id);


--
-- Name: job_posts job_posts_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_posts
    ADD CONSTRAINT job_posts_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: schemes_pages schemes_pages_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.schemes_pages
    ADD CONSTRAINT schemes_pages_pkey PRIMARY KEY (id);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: states states_lgd_code_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.states
    ADD CONSTRAINT states_lgd_code_unique UNIQUE (lgd_code);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: worker_educations worker_educations_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_educations
    ADD CONSTRAINT worker_educations_pkey PRIMARY KEY (id);


--
-- Name: worker_histories worker_histories_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_histories
    ADD CONSTRAINT worker_histories_pkey PRIMARY KEY (id);


--
-- Name: worker_profiles worker_profiles_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_profiles
    ADD CONSTRAINT worker_profiles_pkey PRIMARY KEY (id);


--
-- Name: workers workers_phone_unique; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.workers
    ADD CONSTRAINT workers_phone_unique UNIQUE (phone);


--
-- Name: workers workers_pkey; Type: CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (id);


--
-- Name: districts_state_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX districts_state_id_index ON public.districts USING btree (state_id);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: worker_histories_worker_id_employer_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX worker_histories_worker_id_employer_id_index ON public.worker_histories USING btree (worker_id, employer_id);


--
-- Name: districts_state_id_index; Type: INDEX; Schema: testing; Owner: -
--

CREATE INDEX districts_state_id_index ON testing.districts USING btree (state_id);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: testing; Owner: -
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON testing.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: worker_histories_worker_id_employer_id_index; Type: INDEX; Schema: testing; Owner: -
--

CREATE INDEX worker_histories_worker_id_employer_id_index ON testing.worker_histories USING btree (worker_id, employer_id);


--
-- Name: chat_messages chat_messages_conversation_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_conversation_id_foreign FOREIGN KEY (conversation_id) REFERENCES public.chat_conversations(id) ON DELETE CASCADE;


--
-- Name: employer_profiles employer_profiles_employer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_profiles
    ADD CONSTRAINT employer_profiles_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES public.employers(id) ON DELETE CASCADE;


--
-- Name: employer_skills employer_skills_employer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_skills
    ADD CONSTRAINT employer_skills_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES public.employers(id) ON DELETE CASCADE;


--
-- Name: employer_skills employer_skills_skill_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_skills
    ADD CONSTRAINT employer_skills_skill_id_foreign FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: job_applications job_applications_employer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES public.employers(id) ON DELETE CASCADE;


--
-- Name: job_applications job_applications_job_post_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_job_post_id_foreign FOREIGN KEY (job_post_id) REFERENCES public.job_posts(id) ON DELETE CASCADE;


--
-- Name: job_applications job_applications_worker_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_worker_id_foreign FOREIGN KEY (worker_id) REFERENCES public.workers(id) ON DELETE CASCADE;


--
-- Name: job_post_facilities job_post_facilities_facility_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_post_facilities
    ADD CONSTRAINT job_post_facilities_facility_id_foreign FOREIGN KEY (facility_id) REFERENCES public.facilities(id) ON DELETE CASCADE;


--
-- Name: job_post_facilities job_post_facilities_job_post_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_post_facilities
    ADD CONSTRAINT job_post_facilities_job_post_id_foreign FOREIGN KEY (job_post_id) REFERENCES public.job_posts(id) ON DELETE CASCADE;


--
-- Name: job_posts job_posts_employer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_posts
    ADD CONSTRAINT job_posts_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES public.employers(id) ON DELETE CASCADE;


--
-- Name: worker_educations worker_educations_worker_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_educations
    ADD CONSTRAINT worker_educations_worker_id_foreign FOREIGN KEY (worker_id) REFERENCES public.workers(id) ON DELETE CASCADE;


--
-- Name: worker_histories worker_histories_employer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_histories
    ADD CONSTRAINT worker_histories_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES public.employers(id) ON DELETE SET NULL;


--
-- Name: worker_histories worker_histories_worker_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_histories
    ADD CONSTRAINT worker_histories_worker_id_foreign FOREIGN KEY (worker_id) REFERENCES public.workers(id) ON DELETE CASCADE;


--
-- Name: worker_profiles worker_profiles_worker_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worker_profiles
    ADD CONSTRAINT worker_profiles_worker_id_foreign FOREIGN KEY (worker_id) REFERENCES public.workers(id) ON DELETE CASCADE;


--
-- Name: chat_messages chat_messages_conversation_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.chat_messages
    ADD CONSTRAINT chat_messages_conversation_id_foreign FOREIGN KEY (conversation_id) REFERENCES testing.chat_conversations(id) ON DELETE CASCADE;


--
-- Name: employer_profiles employer_profiles_employer_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employer_profiles
    ADD CONSTRAINT employer_profiles_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES testing.employers(id) ON DELETE CASCADE;


--
-- Name: employer_skills employer_skills_employer_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employer_skills
    ADD CONSTRAINT employer_skills_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES testing.employers(id) ON DELETE CASCADE;


--
-- Name: employer_skills employer_skills_skill_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.employer_skills
    ADD CONSTRAINT employer_skills_skill_id_foreign FOREIGN KEY (skill_id) REFERENCES testing.skills(id) ON DELETE CASCADE;


--
-- Name: job_applications job_applications_employer_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_applications
    ADD CONSTRAINT job_applications_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES testing.employers(id) ON DELETE CASCADE;


--
-- Name: job_applications job_applications_job_post_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_applications
    ADD CONSTRAINT job_applications_job_post_id_foreign FOREIGN KEY (job_post_id) REFERENCES testing.job_posts(id) ON DELETE CASCADE;


--
-- Name: job_applications job_applications_worker_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_applications
    ADD CONSTRAINT job_applications_worker_id_foreign FOREIGN KEY (worker_id) REFERENCES testing.workers(id) ON DELETE CASCADE;


--
-- Name: job_post_facilities job_post_facilities_facility_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_post_facilities
    ADD CONSTRAINT job_post_facilities_facility_id_foreign FOREIGN KEY (facility_id) REFERENCES testing.facilities(id) ON DELETE CASCADE;


--
-- Name: job_post_facilities job_post_facilities_job_post_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_post_facilities
    ADD CONSTRAINT job_post_facilities_job_post_id_foreign FOREIGN KEY (job_post_id) REFERENCES testing.job_posts(id) ON DELETE CASCADE;


--
-- Name: job_posts job_posts_employer_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.job_posts
    ADD CONSTRAINT job_posts_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES testing.employers(id) ON DELETE CASCADE;


--
-- Name: worker_educations worker_educations_worker_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_educations
    ADD CONSTRAINT worker_educations_worker_id_foreign FOREIGN KEY (worker_id) REFERENCES testing.workers(id) ON DELETE CASCADE;


--
-- Name: worker_histories worker_histories_employer_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_histories
    ADD CONSTRAINT worker_histories_employer_id_foreign FOREIGN KEY (employer_id) REFERENCES testing.employers(id) ON DELETE SET NULL;


--
-- Name: worker_histories worker_histories_worker_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_histories
    ADD CONSTRAINT worker_histories_worker_id_foreign FOREIGN KEY (worker_id) REFERENCES testing.workers(id) ON DELETE CASCADE;


--
-- Name: worker_profiles worker_profiles_worker_id_foreign; Type: FK CONSTRAINT; Schema: testing; Owner: -
--

ALTER TABLE ONLY testing.worker_profiles
    ADD CONSTRAINT worker_profiles_worker_id_foreign FOREIGN KEY (worker_id) REFERENCES testing.workers(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 6Evev1g3ywUR6CdeCW9IooEoxmX6Ecp5wRQUMoRk8JCHCgofghaIHq26s74SdUN

