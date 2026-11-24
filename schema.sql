--
-- PostgreSQL database dump
--

\restrict rIMvoGZgRrSISwTHmaznjKa2MCORVjZdthZu6Qmfd9DagpEEE3xHDfLVG1Idzod

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.6 (Debian 18.6-1.pgdg13+2)

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: assignment_resource_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.assignment_resource_type AS ENUM (
    'FILE',
    'LINK'
);


--
-- Name: assignment_share_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.assignment_share_status AS ENUM (
    'PENDING',
    'ACCEPTED',
    'DECLINED'
);


--
-- Name: membership_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.membership_status AS ENUM (
    'PENDING',
    'APPROVED',
    'DENIED',
    'REMOVED'
);


--
-- Name: student_assignment_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.student_assignment_status AS ENUM (
    'NOT_SUBMITTED',
    'AWAITING_REVIEW',
    'NEEDS_RESUBMISSION',
    'APPROVED_FOR_PROD',
    'IN_PROD',
    'COMPLETED'
);


--
-- Name: submission_review_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.submission_review_status AS ENUM (
    'AWAITING_REVIEW',
    'RESUBMISSION_REQUESTED',
    'APPROVED'
);


--
-- Name: teacher_permission; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.teacher_permission AS ENUM (
    'VIEW_STUDENTS',
    'MANAGE_ASSIGNMENTS',
    'REVIEW_SUBMISSIONS',
    'MANAGE_TEACHERS'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'STUDENT',
    'TEACHER'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: assignment_classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignment_classes (
    id integer NOT NULL,
    assignment_id integer NOT NULL,
    class_id integer NOT NULL
);


--
-- Name: assignment_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assignment_classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assignment_classes_id_seq OWNED BY public.assignment_classes.id;


--
-- Name: assignment_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignment_resources (
    id integer NOT NULL,
    assignment_id integer NOT NULL,
    type public.assignment_resource_type NOT NULL,
    name character varying(255) NOT NULL,
    storage_reference text,
    url text,
    file_size integer,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: assignment_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assignment_resources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assignment_resources_id_seq OWNED BY public.assignment_resources.id;


--
-- Name: assignment_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignment_shares (
    id integer NOT NULL,
    assignment_id integer NOT NULL,
    sender_id integer NOT NULL,
    recipient_id integer NOT NULL,
    status public.assignment_share_status DEFAULT 'PENDING'::public.assignment_share_status NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: assignment_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assignment_shares_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assignment_shares_id_seq OWNED BY public.assignment_shares.id;


--
-- Name: assignment_students; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignment_students (
    id integer NOT NULL,
    assignment_id integer NOT NULL,
    student_id integer NOT NULL
);


--
-- Name: assignment_students_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assignment_students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assignment_students_id_seq OWNED BY public.assignment_students.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignments (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    due_date timestamp without time zone,
    points integer,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assignments_id_seq OWNED BY public.assignments.id;


--
-- Name: class_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_memberships (
    id integer NOT NULL,
    class_id integer NOT NULL,
    user_id integer NOT NULL,
    status public.membership_status DEFAULT 'PENDING'::public.membership_status NOT NULL,
    joined_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    approved_at timestamp without time zone
);


--
-- Name: class_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.class_memberships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: class_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.class_memberships_id_seq OWNED BY public.class_memberships.id;


--
-- Name: class_teachers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_teachers (
    id integer NOT NULL,
    class_id integer NOT NULL,
    teacher_id integer NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: class_teachers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.class_teachers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: class_teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.class_teachers_id_seq OWNED BY public.class_teachers.id;


--
-- Name: classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classes (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    period integer,
    year character varying(20),
    level character varying(50),
    join_code character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    related_student_assignment_id integer,
    related_submission_attempt_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    read_at timestamp without time zone
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: student_assignment_status_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_assignment_status_history (
    id integer NOT NULL,
    student_assignment_id integer CONSTRAINT student_assignment_status_histor_student_assignment_id_not_null NOT NULL,
    status public.student_assignment_status NOT NULL,
    changed_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: student_assignment_status_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_assignment_status_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_assignment_status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.student_assignment_status_history_id_seq OWNED BY public.student_assignment_status_history.id;


--
-- Name: student_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_assignments (
    id integer NOT NULL,
    assignment_id integer NOT NULL,
    student_id integer NOT NULL,
    current_status public.student_assignment_status DEFAULT 'NOT_SUBMITTED'::public.student_assignment_status NOT NULL,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: student_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.student_assignments_id_seq OWNED BY public.student_assignments.id;


--
-- Name: submission_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submission_attempts (
    id integer NOT NULL,
    student_assignment_id integer NOT NULL,
    attempt_number integer NOT NULL,
    text_response text,
    review_status public.submission_review_status DEFAULT 'AWAITING_REVIEW'::public.submission_review_status NOT NULL,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: submission_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submission_attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submission_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submission_attempts_id_seq OWNED BY public.submission_attempts.id;


--
-- Name: submission_feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submission_feedback (
    id integer NOT NULL,
    submission_attempt_id integer NOT NULL,
    teacher_id integer NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: submission_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submission_feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submission_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submission_feedback_id_seq OWNED BY public.submission_feedback.id;


--
-- Name: submission_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submission_files (
    id integer NOT NULL,
    submission_attempt_id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    storage_reference text NOT NULL,
    file_size integer,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: submission_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submission_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submission_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submission_files_id_seq OWNED BY public.submission_files.id;


--
-- Name: submission_grades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submission_grades (
    id integer NOT NULL,
    submission_attempt_id integer NOT NULL,
    teacher_id integer NOT NULL,
    points_earned integer NOT NULL,
    graded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: submission_grades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submission_grades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submission_grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submission_grades_id_seq OWNED BY public.submission_grades.id;


--
-- Name: teacher_class_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teacher_class_permissions (
    id integer NOT NULL,
    class_teacher_id integer NOT NULL,
    permission public.teacher_permission NOT NULL
);


--
-- Name: teacher_class_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teacher_class_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teacher_class_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teacher_class_permissions_id_seq OWNED BY public.teacher_class_permissions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    role public.user_role NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
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
-- Name: assignment_classes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_classes ALTER COLUMN id SET DEFAULT nextval('public.assignment_classes_id_seq'::regclass);


--
-- Name: assignment_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_resources ALTER COLUMN id SET DEFAULT nextval('public.assignment_resources_id_seq'::regclass);


--
-- Name: assignment_shares id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_shares ALTER COLUMN id SET DEFAULT nextval('public.assignment_shares_id_seq'::regclass);


--
-- Name: assignment_students id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_students ALTER COLUMN id SET DEFAULT nextval('public.assignment_students_id_seq'::regclass);


--
-- Name: assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments ALTER COLUMN id SET DEFAULT nextval('public.assignments_id_seq'::regclass);


--
-- Name: class_memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_memberships ALTER COLUMN id SET DEFAULT nextval('public.class_memberships_id_seq'::regclass);


--
-- Name: class_teachers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_teachers ALTER COLUMN id SET DEFAULT nextval('public.class_teachers_id_seq'::regclass);


--
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: student_assignment_status_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_assignment_status_history ALTER COLUMN id SET DEFAULT nextval('public.student_assignment_status_history_id_seq'::regclass);


--
-- Name: student_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_assignments ALTER COLUMN id SET DEFAULT nextval('public.student_assignments_id_seq'::regclass);


--
-- Name: submission_attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_attempts ALTER COLUMN id SET DEFAULT nextval('public.submission_attempts_id_seq'::regclass);


--
-- Name: submission_feedback id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_feedback ALTER COLUMN id SET DEFAULT nextval('public.submission_feedback_id_seq'::regclass);


--
-- Name: submission_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_files ALTER COLUMN id SET DEFAULT nextval('public.submission_files_id_seq'::regclass);


--
-- Name: submission_grades id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_grades ALTER COLUMN id SET DEFAULT nextval('public.submission_grades_id_seq'::regclass);


--
-- Name: teacher_class_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teacher_class_permissions ALTER COLUMN id SET DEFAULT nextval('public.teacher_class_permissions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: assignment_classes assignment_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_classes
    ADD CONSTRAINT assignment_classes_pkey PRIMARY KEY (id);


--
-- Name: assignment_resources assignment_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_resources
    ADD CONSTRAINT assignment_resources_pkey PRIMARY KEY (id);


--
-- Name: assignment_shares assignment_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_shares
    ADD CONSTRAINT assignment_shares_pkey PRIMARY KEY (id);


--
-- Name: assignment_students assignment_students_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_students
    ADD CONSTRAINT assignment_students_pkey PRIMARY KEY (id);


--
-- Name: assignments assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: class_memberships class_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_memberships
    ADD CONSTRAINT class_memberships_pkey PRIMARY KEY (id);


--
-- Name: class_teachers class_teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_teachers
    ADD CONSTRAINT class_teachers_pkey PRIMARY KEY (id);


--
-- Name: classes classes_join_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_join_code_key UNIQUE (join_code);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: student_assignment_status_history student_assignment_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_assignment_status_history
    ADD CONSTRAINT student_assignment_status_history_pkey PRIMARY KEY (id);


--
-- Name: student_assignments student_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_assignments
    ADD CONSTRAINT student_assignments_pkey PRIMARY KEY (id);


--
-- Name: submission_attempts submission_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_attempts
    ADD CONSTRAINT submission_attempts_pkey PRIMARY KEY (id);


--
-- Name: submission_feedback submission_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_feedback
    ADD CONSTRAINT submission_feedback_pkey PRIMARY KEY (id);


--
-- Name: submission_files submission_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_files
    ADD CONSTRAINT submission_files_pkey PRIMARY KEY (id);


--
-- Name: submission_grades submission_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_grades
    ADD CONSTRAINT submission_grades_pkey PRIMARY KEY (id);


--
-- Name: teacher_class_permissions teacher_class_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teacher_class_permissions
    ADD CONSTRAINT teacher_class_permissions_pkey PRIMARY KEY (id);


--
-- Name: assignment_classes unique_assignment_class; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_classes
    ADD CONSTRAINT unique_assignment_class UNIQUE (assignment_id, class_id);


--
-- Name: assignment_students unique_assignment_student; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_students
    ADD CONSTRAINT unique_assignment_student UNIQUE (assignment_id, student_id);


--
-- Name: class_memberships unique_class_membership; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_memberships
    ADD CONSTRAINT unique_class_membership UNIQUE (class_id, user_id);


--
-- Name: class_teachers unique_class_teacher; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_teachers
    ADD CONSTRAINT unique_class_teacher UNIQUE (class_id, teacher_id);


--
-- Name: student_assignments unique_student_assignment; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_assignments
    ADD CONSTRAINT unique_student_assignment UNIQUE (assignment_id, student_id);


--
-- Name: submission_attempts unique_submission_attempt_number; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_attempts
    ADD CONSTRAINT unique_submission_attempt_number UNIQUE (student_assignment_id, attempt_number);


--
-- Name: submission_grades unique_submission_grade; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_grades
    ADD CONSTRAINT unique_submission_grade UNIQUE (submission_attempt_id);


--
-- Name: teacher_class_permissions unique_teacher_class_permission; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teacher_class_permissions
    ADD CONSTRAINT unique_teacher_class_permission UNIQUE (class_teacher_id, permission);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: unique_primary_teacher_per_class; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_primary_teacher_per_class ON public.class_teachers USING btree (class_id) WHERE (is_primary = true);


--
-- Name: assignment_classes fk_assignment_class_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_classes
    ADD CONSTRAINT fk_assignment_class_assignment FOREIGN KEY (assignment_id) REFERENCES public.assignments(id) ON DELETE CASCADE;


--
-- Name: assignment_classes fk_assignment_class_class; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_classes
    ADD CONSTRAINT fk_assignment_class_class FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: assignments fk_assignment_creator; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT fk_assignment_creator FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: assignment_resources fk_assignment_resource_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_resources
    ADD CONSTRAINT fk_assignment_resource_assignment FOREIGN KEY (assignment_id) REFERENCES public.assignments(id) ON DELETE CASCADE;


--
-- Name: assignment_shares fk_assignment_share_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_shares
    ADD CONSTRAINT fk_assignment_share_assignment FOREIGN KEY (assignment_id) REFERENCES public.assignments(id) ON DELETE CASCADE;


--
-- Name: assignment_shares fk_assignment_share_recipient; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_shares
    ADD CONSTRAINT fk_assignment_share_recipient FOREIGN KEY (recipient_id) REFERENCES public.users(id);


--
-- Name: assignment_shares fk_assignment_share_sender; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_shares
    ADD CONSTRAINT fk_assignment_share_sender FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: assignment_students fk_assignment_student_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_students
    ADD CONSTRAINT fk_assignment_student_assignment FOREIGN KEY (assignment_id) REFERENCES public.assignments(id) ON DELETE CASCADE;


--
-- Name: assignment_students fk_assignment_student_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_students
    ADD CONSTRAINT fk_assignment_student_user FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: class_memberships fk_class_membership_class; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_memberships
    ADD CONSTRAINT fk_class_membership_class FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: class_memberships fk_class_membership_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_memberships
    ADD CONSTRAINT fk_class_membership_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: class_teachers fk_class_teacher_class; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_teachers
    ADD CONSTRAINT fk_class_teacher_class FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: class_teachers fk_class_teacher_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_teachers
    ADD CONSTRAINT fk_class_teacher_user FOREIGN KEY (teacher_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: notifications fk_notification_student_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notification_student_assignment FOREIGN KEY (related_student_assignment_id) REFERENCES public.student_assignments(id) ON DELETE CASCADE;


--
-- Name: notifications fk_notification_submission_attempt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notification_submission_attempt FOREIGN KEY (related_submission_attempt_id) REFERENCES public.submission_attempts(id) ON DELETE CASCADE;


--
-- Name: notifications fk_notification_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: student_assignment_status_history fk_status_history_student_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_assignment_status_history
    ADD CONSTRAINT fk_status_history_student_assignment FOREIGN KEY (student_assignment_id) REFERENCES public.student_assignments(id) ON DELETE CASCADE;


--
-- Name: student_assignment_status_history fk_status_history_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_assignment_status_history
    ADD CONSTRAINT fk_status_history_user FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: student_assignments fk_student_assignment_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_assignments
    ADD CONSTRAINT fk_student_assignment_assignment FOREIGN KEY (assignment_id) REFERENCES public.assignments(id) ON DELETE CASCADE;


--
-- Name: student_assignments fk_student_assignment_student; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_assignments
    ADD CONSTRAINT fk_student_assignment_student FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: submission_attempts fk_submission_attempt_student_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_attempts
    ADD CONSTRAINT fk_submission_attempt_student_assignment FOREIGN KEY (student_assignment_id) REFERENCES public.student_assignments(id) ON DELETE CASCADE;


--
-- Name: submission_feedback fk_submission_feedback_attempt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_feedback
    ADD CONSTRAINT fk_submission_feedback_attempt FOREIGN KEY (submission_attempt_id) REFERENCES public.submission_attempts(id) ON DELETE CASCADE;


--
-- Name: submission_feedback fk_submission_feedback_teacher; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_feedback
    ADD CONSTRAINT fk_submission_feedback_teacher FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: submission_files fk_submission_file_attempt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_files
    ADD CONSTRAINT fk_submission_file_attempt FOREIGN KEY (submission_attempt_id) REFERENCES public.submission_attempts(id) ON DELETE CASCADE;


--
-- Name: submission_grades fk_submission_grade_attempt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_grades
    ADD CONSTRAINT fk_submission_grade_attempt FOREIGN KEY (submission_attempt_id) REFERENCES public.submission_attempts(id) ON DELETE CASCADE;


--
-- Name: submission_grades fk_submission_grade_teacher; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_grades
    ADD CONSTRAINT fk_submission_grade_teacher FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: teacher_class_permissions fk_teacher_permission_class_teacher; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teacher_class_permissions
    ADD CONSTRAINT fk_teacher_permission_class_teacher FOREIGN KEY (class_teacher_id) REFERENCES public.class_teachers(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict rIMvoGZgRrSISwTHmaznjKa2MCORVjZdthZu6Qmfd9DagpEEE3xHDfLVG1Idzod

