--
-- PostgreSQL database dump
--

\restrict 9MbjFbULttyn0dkigaHigbQChsKwwIUepEzt4oPI3DbPmfaGqK31dNn4krLwBTO

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

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

ALTER TABLE IF EXISTS ONLY public.transactions DROP CONSTRAINT IF EXISTS transactions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.savings_goals DROP CONSTRAINT IF EXISTS savings_goals_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.recurring_transactions DROP CONSTRAINT IF EXISTS recurring_transactions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.debts DROP CONSTRAINT IF EXISTS debts_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.debt_payments DROP CONSTRAINT IF EXISTS debt_payments_debt_id_fkey;
ALTER TABLE IF EXISTS ONLY public.budgets DROP CONSTRAINT IF EXISTS budgets_user_id_fkey;
DROP INDEX IF EXISTS public.idx_users_oauth;
DROP INDEX IF EXISTS public.idx_users_email;
DROP INDEX IF EXISTS public.idx_transactions_user_id;
DROP INDEX IF EXISTS public.idx_transactions_type;
DROP INDEX IF EXISTS public.idx_transactions_date;
DROP INDEX IF EXISTS public.idx_transactions_category;
DROP INDEX IF EXISTS public.idx_savings_goals_user_id;
DROP INDEX IF EXISTS public.idx_recurring_user_id;
DROP INDEX IF EXISTS public.idx_recurring_next_occurrence;
DROP INDEX IF EXISTS public.idx_recurring_active;
DROP INDEX IF EXISTS public.idx_debts_user_id;
DROP INDEX IF EXISTS public.idx_debt_payments_debt_id;
DROP INDEX IF EXISTS public.idx_debt_payments_date;
DROP INDEX IF EXISTS public.idx_budgets_user_id;
DROP INDEX IF EXISTS public.flyway_schema_history_s_idx;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.transactions DROP CONSTRAINT IF EXISTS transactions_pkey;
ALTER TABLE IF EXISTS ONLY public.savings_goals DROP CONSTRAINT IF EXISTS savings_goals_pkey;
ALTER TABLE IF EXISTS ONLY public.recurring_transactions DROP CONSTRAINT IF EXISTS recurring_transactions_pkey;
ALTER TABLE IF EXISTS ONLY public.flyway_schema_history DROP CONSTRAINT IF EXISTS flyway_schema_history_pk;
ALTER TABLE IF EXISTS ONLY public.debts DROP CONSTRAINT IF EXISTS debts_pkey;
ALTER TABLE IF EXISTS ONLY public.debt_payments DROP CONSTRAINT IF EXISTS debt_payments_pkey;
ALTER TABLE IF EXISTS ONLY public.budgets DROP CONSTRAINT IF EXISTS budgets_pkey;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.transactions;
DROP TABLE IF EXISTS public.savings_goals;
DROP TABLE IF EXISTS public.recurring_transactions;
DROP TABLE IF EXISTS public.flyway_schema_history;
DROP TABLE IF EXISTS public.debts;
DROP TABLE IF EXISTS public.debt_payments;
DROP TABLE IF EXISTS public.budgets;
DROP TYPE IF EXISTS public.recurring_frequency;
--
-- Name: recurring_frequency; Type: TYPE; Schema: public; Owner: wealthpath
--

CREATE TYPE public.recurring_frequency AS ENUM (
    'daily',
    'weekly',
    'biweekly',
    'monthly',
    'yearly'
);


ALTER TYPE public.recurring_frequency OWNER TO wealthpath;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: budgets; Type: TABLE; Schema: public; Owner: wealthpath
--

CREATE TABLE public.budgets (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    category character varying(100) NOT NULL,
    amount numeric(15,2) NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying,
    period character varying(20) DEFAULT 'monthly'::character varying,
    start_date date NOT NULL,
    end_date date,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT budgets_period_check CHECK (((period)::text = ANY ((ARRAY['weekly'::character varying, 'monthly'::character varying, 'yearly'::character varying])::text[])))
);


ALTER TABLE public.budgets OWNER TO wealthpath;

--
-- Name: debt_payments; Type: TABLE; Schema: public; Owner: wealthpath
--

CREATE TABLE public.debt_payments (
    id uuid NOT NULL,
    debt_id uuid NOT NULL,
    amount numeric(15,2) NOT NULL,
    principal numeric(15,2) NOT NULL,
    interest numeric(15,2) NOT NULL,
    date date NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.debt_payments OWNER TO wealthpath;

--
-- Name: debts; Type: TABLE; Schema: public; Owner: wealthpath
--

CREATE TABLE public.debts (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    original_amount numeric(15,2) NOT NULL,
    current_balance numeric(15,2) NOT NULL,
    interest_rate numeric(5,2) NOT NULL,
    minimum_payment numeric(15,2) NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying,
    due_day integer,
    start_date date NOT NULL,
    expected_payoff date,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT debts_due_day_check CHECK (((due_day >= 1) AND (due_day <= 31))),
    CONSTRAINT debts_type_check CHECK (((type)::text = ANY ((ARRAY['mortgage'::character varying, 'auto_loan'::character varying, 'student_loan'::character varying, 'credit_card'::character varying, 'personal_loan'::character varying, 'other'::character varying])::text[])))
);


ALTER TABLE public.debts OWNER TO wealthpath;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: wealthpath
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO wealthpath;

--
-- Name: recurring_transactions; Type: TABLE; Schema: public; Owner: wealthpath
--

CREATE TABLE public.recurring_transactions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(15,2) NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying,
    category character varying(100) NOT NULL,
    description text,
    frequency public.recurring_frequency NOT NULL,
    start_date date NOT NULL,
    end_date date,
    next_occurrence date NOT NULL,
    last_generated date,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT recurring_transactions_type_check CHECK (((type)::text = ANY ((ARRAY['income'::character varying, 'expense'::character varying])::text[])))
);


ALTER TABLE public.recurring_transactions OWNER TO wealthpath;

--
-- Name: savings_goals; Type: TABLE; Schema: public; Owner: wealthpath
--

CREATE TABLE public.savings_goals (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    target_amount numeric(15,2) NOT NULL,
    current_amount numeric(15,2) DEFAULT 0,
    currency character varying(3) DEFAULT 'USD'::character varying,
    target_date date,
    color character varying(7) DEFAULT '#3B82F6'::character varying,
    icon character varying(50) DEFAULT 'piggy-bank'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.savings_goals OWNER TO wealthpath;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: wealthpath
--

CREATE TABLE public.transactions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(15,2) NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying,
    category character varying(100) NOT NULL,
    description text,
    date date NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['income'::character varying, 'expense'::character varying])::text[])))
);


ALTER TABLE public.transactions OWNER TO wealthpath;

--
-- Name: users; Type: TABLE; Schema: public; Owner: wealthpath
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255),
    name character varying(255) NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    oauth_provider character varying(50),
    oauth_id character varying(255),
    avatar_url text
);


ALTER TABLE public.users OWNER TO wealthpath;

--
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: wealthpath
--

COPY public.budgets (id, user_id, category, amount, currency, period, start_date, end_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: debt_payments; Type: TABLE DATA; Schema: public; Owner: wealthpath
--

COPY public.debt_payments (id, debt_id, amount, principal, interest, date, created_at) FROM stdin;
\.


--
-- Data for Name: debts; Type: TABLE DATA; Schema: public; Owner: wealthpath
--

COPY public.debts (id, user_id, name, type, original_amount, current_balance, interest_rate, minimum_payment, currency, due_day, start_date, expected_payoff, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: wealthpath
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	initial schema	SQL	V1__initial_schema.sql	1627787610	wealthpath	2025-12-03 11:49:18.536894	130	t
2	2	oauth support	SQL	V2__oauth_support.sql	210731936	wealthpath	2025-12-03 11:49:18.785834	13	t
3	3	recurring transactions	SQL	V3__recurring_transactions.sql	1625609290	wealthpath	2025-12-03 11:49:18.820032	36	t
\.


--
-- Data for Name: recurring_transactions; Type: TABLE DATA; Schema: public; Owner: wealthpath
--

COPY public.recurring_transactions (id, user_id, type, amount, currency, category, description, frequency, start_date, end_date, next_occurrence, last_generated, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: savings_goals; Type: TABLE DATA; Schema: public; Owner: wealthpath
--

COPY public.savings_goals (id, user_id, name, target_amount, current_amount, currency, target_date, color, icon, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: wealthpath
--

COPY public.transactions (id, user_id, type, amount, currency, category, description, date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: wealthpath
--

COPY public.users (id, email, password_hash, name, currency, created_at, updated_at, oauth_provider, oauth_id, avatar_url) FROM stdin;
d107f1ad-ee55-4689-85a3-6a6a831445dd	hungnt0597@gmail.com	\N	Hùng Nguyễn Thanh	USD	2025-12-03 12:19:26.166688+00	2025-12-03 12:19:26.166688+00	google	117810219881353029279	https://lh3.googleusercontent.com/a/ACg8ocLBwOyP7J3UWExoz0pojZTPFEsFzNrL8Ral8DB9PErmD81iXSiB=s96-c
\.


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- Name: debt_payments debt_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.debt_payments
    ADD CONSTRAINT debt_payments_pkey PRIMARY KEY (id);


--
-- Name: debts debts_pkey; Type: CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.debts
    ADD CONSTRAINT debts_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: recurring_transactions recurring_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.recurring_transactions
    ADD CONSTRAINT recurring_transactions_pkey PRIMARY KEY (id);


--
-- Name: savings_goals savings_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.savings_goals
    ADD CONSTRAINT savings_goals_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_budgets_user_id; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_budgets_user_id ON public.budgets USING btree (user_id);


--
-- Name: idx_debt_payments_date; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_debt_payments_date ON public.debt_payments USING btree (date);


--
-- Name: idx_debt_payments_debt_id; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_debt_payments_debt_id ON public.debt_payments USING btree (debt_id);


--
-- Name: idx_debts_user_id; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_debts_user_id ON public.debts USING btree (user_id);


--
-- Name: idx_recurring_active; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_recurring_active ON public.recurring_transactions USING btree (is_active);


--
-- Name: idx_recurring_next_occurrence; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_recurring_next_occurrence ON public.recurring_transactions USING btree (next_occurrence);


--
-- Name: idx_recurring_user_id; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_recurring_user_id ON public.recurring_transactions USING btree (user_id);


--
-- Name: idx_savings_goals_user_id; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_savings_goals_user_id ON public.savings_goals USING btree (user_id);


--
-- Name: idx_transactions_category; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_transactions_category ON public.transactions USING btree (category);


--
-- Name: idx_transactions_date; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_transactions_date ON public.transactions USING btree (date);


--
-- Name: idx_transactions_type; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_transactions_type ON public.transactions USING btree (type);


--
-- Name: idx_transactions_user_id; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_transactions_user_id ON public.transactions USING btree (user_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_oauth; Type: INDEX; Schema: public; Owner: wealthpath
--

CREATE INDEX idx_users_oauth ON public.users USING btree (oauth_provider, oauth_id);


--
-- Name: budgets budgets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: debt_payments debt_payments_debt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.debt_payments
    ADD CONSTRAINT debt_payments_debt_id_fkey FOREIGN KEY (debt_id) REFERENCES public.debts(id) ON DELETE CASCADE;


--
-- Name: debts debts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.debts
    ADD CONSTRAINT debts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: recurring_transactions recurring_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.recurring_transactions
    ADD CONSTRAINT recurring_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: savings_goals savings_goals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.savings_goals
    ADD CONSTRAINT savings_goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wealthpath
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 9MbjFbULttyn0dkigaHigbQChsKwwIUepEzt4oPI3DbPmfaGqK31dNn4krLwBTO

