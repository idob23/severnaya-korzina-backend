--
-- PostgreSQL database dump
--

\restrict aV0GrKTzC7IXcaYuZ4oZOtvfRXyAhSOJ1XS3SnfyjnmMIFmLV3ln9n1ybwMvZxX

-- Dumped from database version 15.13 (Ubuntu 15.13-201-yandex.55410.c7a09e61b0)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: superadmin
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO superadmin;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: superadmin
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO superadmin;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.addresses (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    title text NOT NULL,
    address text NOT NULL,
    "isDefault" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.addresses OWNER TO superadmin;

--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.addresses_id_seq OWNER TO superadmin;

--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: app_settings; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.app_settings (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    description text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.app_settings OWNER TO superadmin;

--
-- Name: batch_items; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.batch_items (
    id integer NOT NULL,
    "batchId" integer NOT NULL,
    "productId" integer NOT NULL,
    price numeric(10,2) NOT NULL,
    discount numeric(5,2) DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL
);


ALTER TABLE public.batch_items OWNER TO superadmin;

--
-- Name: batch_items_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.batch_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.batch_items_id_seq OWNER TO superadmin;

--
-- Name: batch_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.batch_items_id_seq OWNED BY public.batch_items.id;


--
-- Name: batches; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.batches (
    id integer NOT NULL,
    title text NOT NULL,
    description text,
    "startDate" timestamp(3) without time zone NOT NULL,
    "endDate" timestamp(3) without time zone NOT NULL,
    "deliveryDate" timestamp(3) without time zone,
    "minParticipants" integer DEFAULT 5 NOT NULL,
    "maxParticipants" integer,
    status text DEFAULT 'active'::text NOT NULL,
    "pickupAddress" text,
    "targetAmount" numeric(10,2) DEFAULT 3000000 NOT NULL,
    "currentAmount" numeric(10,2) DEFAULT 0 NOT NULL,
    "participantsCount" integer DEFAULT 0 NOT NULL,
    "progressPercent" integer DEFAULT 0 NOT NULL,
    "lastCalculated" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "autoLaunch" boolean DEFAULT true NOT NULL,
    "marginPercent" numeric(5,2) DEFAULT 20 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "collectionStartDate" timestamp(3) without time zone
);


ALTER TABLE public.batches OWNER TO superadmin;

--
-- Name: batches_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.batches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.batches_id_seq OWNER TO superadmin;

--
-- Name: batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.batches_id_seq OWNED BY public.batches.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    "imageUrl" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.categories OWNER TO superadmin;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO superadmin;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    "orderId" integer NOT NULL,
    "productId" integer NOT NULL,
    quantity integer NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.order_items OWNER TO superadmin;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO superadmin;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "batchId" integer,
    "addressId" integer NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    "totalAmount" numeric(10,2) NOT NULL,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.orders OWNER TO superadmin;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO superadmin;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.products (
    id integer NOT NULL,
    "categoryId" integer NOT NULL,
    name text NOT NULL,
    description text,
    "imageUrl" text,
    price numeric(10,2) NOT NULL,
    unit text NOT NULL,
    "minQuantity" integer DEFAULT 1 NOT NULL,
    "maxQuantity" integer,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.products OWNER TO superadmin;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO superadmin;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    description text,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.system_settings OWNER TO superadmin;

--
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.system_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_settings_id_seq OWNER TO superadmin;

--
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.users (
    id integer NOT NULL,
    phone text NOT NULL,
    "firstName" text NOT NULL,
    "lastName" text,
    email text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "acceptedTerms" boolean DEFAULT false,
    "acceptedTermsAt" timestamp(3) without time zone,
    "acceptedTermsIp" text
);


ALTER TABLE public.users OWNER TO superadmin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO superadmin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: batch_items id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.batch_items ALTER COLUMN id SET DEFAULT nextval('public.batch_items_id_seq'::regclass);


--
-- Name: batches id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.batches ALTER COLUMN id SET DEFAULT nextval('public.batches_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
db6791d0-62ba-4534-a773-2a7ac32a5b1f	6a53e2645707da1a91338739c4ee1303792c9e5322da3c5ec4cb33bf606b73c2	2025-08-24 03:17:09.430172+03	20250726100336_init		\N	2025-08-24 03:17:09.430172+03	0
\.


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.addresses (id, "userId", title, address, "isDefault", "createdAt") FROM stdin;
1	85	Основной адрес	пос. Усть-Нера	t	2025-08-26 00:50:43.327
2	88	Основной адрес	пос. Усть-Нера	t	2025-08-28 15:41:51.793
3	88	Основной адрес	пос. Усть-Нера	t	2025-08-31 08:14:53.174
\.


--
-- Data for Name: app_settings; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.app_settings (key, value, description, updated_at) FROM stdin;
checkout_enabled	true	Разрешено ли оформление заказов в приложении	2025-09-05 18:05:53.925834
\.


--
-- Data for Name: batch_items; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.batch_items (id, "batchId", "productId", price, discount, "isActive") FROM stdin;
\.


--
-- Data for Name: batches; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.batches (id, title, description, "startDate", "endDate", "deliveryDate", "minParticipants", "maxParticipants", status, "pickupAddress", "targetAmount", "currentAmount", "participantsCount", "progressPercent", "lastCalculated", "autoLaunch", "marginPercent", "createdAt", "updatedAt", "collectionStartDate") FROM stdin;
77	qweqwe	Автоматически созданная партия для сбора заказов	2025-09-06 02:20:32.735	2025-09-13 02:20:32.735	\N	5	\N	completed	\N	3000000.00	7293.00	1	0	2025-09-06 03:32:22.884	t	20.00	2025-09-06 02:20:32.736	2025-09-06 03:36:52.002	2025-09-06 02:20:32.735
82	ыфшгаитщшфгцуыа	Автоматически созданная партия для сбора заказов	2025-09-08 23:30:10.844	2025-09-15 23:30:10.844	\N	5	\N	completed	\N	100000.00	144643.00	2	100	2025-09-09 01:16:02.607	t	20.00	2025-09-08 23:30:10.846	2025-09-09 01:17:01.061	2025-09-08 23:30:10.844
78	Якутск - продукты	Автоматически созданная партия для сбора заказов	2025-09-06 03:44:29.199	2025-09-13 03:44:29.199	\N	5	\N	completed	\N	100000.00	19757.00	1	20	2025-09-06 03:45:48.201	t	20.00	2025-09-06 03:44:29.2	2025-09-06 03:47:24.398	2025-09-06 03:44:29.199
79	Коллективная закупка 6.9	Автоматически созданная партия для сбора заказов	2025-09-06 06:39:25.615	2025-09-13 06:39:25.614	\N	5	\N	completed	\N	100000.00	0.00	0	0	2025-09-06 06:39:25.616	t	20.00	2025-09-06 06:39:25.616	2025-09-06 13:11:12.719	2025-09-06 06:39:25.615
80	0	Автоматически созданная партия для сбора заказов	2025-09-06 13:11:23.812	2025-09-13 13:11:23.812	\N	5	\N	completed	\N	100000.00	53372.00	2	53	2025-09-08 04:16:04.936	t	20.00	2025-09-06 13:11:23.813	2025-09-08 11:50:16.392	2025-09-06 13:11:23.812
81	Якутск	Автоматически созданная партия для сбора заказов	2025-09-08 11:50:32.348	2025-09-15 11:50:32.348	\N	5	\N	completed	\N	200000.00	216135.00	2	100	2025-09-08 22:48:39.862	t	20.00	2025-09-08 11:50:32.349	2025-09-08 23:14:07.868	2025-09-08 11:50:32.348
83	№68	Автоматически созданная партия для сбора заказов	2025-09-09 04:34:12.356	2025-09-16 04:34:12.356	\N	5	\N	ready	\N	400000.00	400760.00	3	100	2025-09-24 09:13:40.702	t	20.00	2025-09-09 04:34:12.358	2025-09-24 09:13:40.703	2025-09-09 04:34:12.356
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.categories (id, name, description, "imageUrl", "isActive", "createdAt") FROM stdin;
1	Хлебобулочные изделия	Хлеб, батоны, булочки	\N	t	2025-08-04 03:19:22.89
2	Мясо и птица	Говядина, свинина, курица	\N	t	2025-08-04 03:19:22.89
3	Молочные продукты	Молоко, творог, сыр, кефир	\N	t	2025-08-04 03:19:22.89
34	Фрукты	\N	\N	t	2025-08-10 06:17:38.808
68	Консервы	\N	\N	t	2025-09-09 05:31:48.3
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.order_items (id, "orderId", "productId", quantity, price) FROM stdin;
104	93	2	1	85.00
105	94	2	1	85.00
106	95	35	1	45.00
107	95	3	1	320.00
108	96	2	3	85.00
109	97	2	13	85.00
110	97	3	10	320.00
111	98	1	10	95.00
112	98	35	5	45.00
113	99	36	12	120.00
114	100	2	12	85.00
115	101	2	1	85.00
116	102	3	6	320.00
117	103	2	1	85.00
118	103	35	1	45.00
119	103	3	4	320.00
120	104	70	25	859.00
121	105	70	25	859.00
122	106	70	14	859.00
123	107	3	5	320.00
124	107	70	6	859.00
125	108	2	7	85.00
126	108	70	6	859.00
127	109	3	9	320.00
128	110	70	40	859.00
129	111	70	6	859.00
130	112	3	5	320.00
131	113	70	5	859.00
132	114	70	6	859.00
133	115	70	5	859.00
134	116	70	3	859.00
135	116	2	3	85.00
136	117	3	4	320.00
137	118	70	4	859.00
138	119	70	3	859.00
139	120	3	4	320.00
140	121	70	23	859.00
141	122	2	5	85.00
142	123	71	8	4500.00
143	124	70	3	859.00
144	125	2	3	85.00
145	125	70	5	859.00
146	126	71	8	4500.00
147	127	71	8	4500.00
148	128	70	4	859.00
149	129	72	2	12000.00
150	130	70	3	859.00
151	131	70	4	859.00
152	132	3	4	320.00
153	133	70	13	859.00
154	133	71	9	4500.00
155	134	72	6	12000.00
156	135	35	3	45.00
157	135	72	12	12000.00
158	136	35	3	45.00
159	136	72	12	12000.00
160	137	35	3	45.00
161	137	72	12	12000.00
162	138	70	2	859.00
163	138	2	5	85.00
164	139	71	5	4500.00
165	140	72	10	12000.00
166	141	72	26	12000.00
167	142	70	15	859.00
168	143	71	2	4500.00
169	144	72	4	12000.00
170	145	70	4	859.00
171	145	2	3	85.00
172	146	70	4	859.00
173	146	2	3	85.00
174	146	3	4	320.00
175	147	2	4	85.00
176	148	3	1	320.00
177	149	2	4	85.00
178	149	3	7	320.00
179	150	3	3	320.00
180	151	70	4	859.00
181	152	70	3	859.00
182	153	73	5	200.00
183	154	73	5	200.00
184	155	73	5	200.00
185	156	73	3	200.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.orders (id, "userId", "batchId", "addressId", status, "totalAmount", notes, "createdAt", "updatedAt") FROM stdin;
103	85	\N	1	paid	1410.00	Заказ оплачен и создан автоматически	2025-09-05 15:06:22.604	2025-09-05 18:23:14.257
105	85	\N	1	pending	21475.00	Заказ оплачен и создан автоматически	2025-09-05 22:33:49.071	2025-09-05 22:33:49.071
106	85	\N	1	pending	12026.00	Заказ оплачен и создан автоматически	2025-09-05 22:46:50.877	2025-09-05 22:46:50.877
107	85	\N	1	pending	6754.00	Заказ оплачен и создан автоматически	2025-09-05 22:55:37.748	2025-09-05 22:55:37.748
94	85	\N	1	delivered	85.00	Заказ оплачен и создан автоматически	2025-08-26 01:01:03.615	2025-08-26 01:08:24.034
93	85	\N	1	delivered	85.00	Заказ оплачен и создан автоматически	2025-08-26 00:50:43.375	2025-08-26 01:08:24.034
95	85	\N	1	pending	365.00	Заказ оплачен и создан автоматически	2025-08-26 23:25:40.556	2025-08-26 23:25:40.556
96	85	\N	1	pending	255.00	Заказ оплачен и создан автоматически	2025-08-27 00:05:46.43	2025-08-27 00:05:46.43
108	85	\N	1	pending	5749.00	Заказ оплачен и создан автоматически	2025-09-05 23:00:26.356	2025-09-05 23:00:26.356
109	85	\N	1	pending	2880.00	Заказ оплачен и создан автоматически	2025-09-05 23:05:06.125	2025-09-05 23:05:06.125
110	85	\N	1	pending	34360.00	Заказ оплачен и создан автоматически	2025-09-05 23:09:16.569	2025-09-05 23:09:16.569
111	85	\N	1	pending	5154.00	Заказ оплачен и создан автоматически	2025-09-05 23:13:15.75	2025-09-05 23:13:15.75
112	85	\N	1	pending	1600.00	Заказ оплачен и создан автоматически	2025-09-05 23:15:45.713	2025-09-05 23:15:45.713
113	85	\N	1	pending	4295.00	Заказ оплачен и создан автоматически	2025-09-05 23:56:49.667	2025-09-05 23:56:49.667
142	85	83	1	paid	12885.00	\N	2025-09-09 04:36:22.179	2025-09-09 04:37:18.287
114	85	\N	1	pending	5154.00	Заказ оплачен и создан автоматически	2025-09-06 00:04:25.459	2025-09-06 00:04:25.459
101	85	\N	1	pending	85.00	Заказ оплачен и создан автоматически	2025-08-31 07:34:41.415	2025-08-31 07:34:41.415
102	88	\N	3	pending	1920.00	Заказ оплачен и создан автоматически	2025-08-31 08:14:53.224	2025-08-31 08:14:53.224
97	85	\N	1	pending	4305.00	Заказ оплачен и создан автоматически	2025-08-28 03:23:38.741	2025-08-28 03:23:38.741
98	85	\N	1	pending	1175.00	Заказ оплачен и создан автоматически	2025-08-28 03:26:27.744	2025-08-28 03:26:27.744
99	88	\N	2	pending	1440.00	Заказ оплачен и создан автоматически	2025-08-28 15:41:51.85	2025-08-28 15:41:51.85
100	85	\N	1	pending	1020.00	Заказ оплачен и создан автоматически	2025-08-28 15:43:58.791	2025-08-28 15:43:58.791
115	85	\N	1	pending	4295.00	Заказ оплачен и создан автоматически	2025-09-06 00:39:58.782	2025-09-06 00:39:58.782
116	85	\N	1	pending	2832.00	Заказ оплачен и создан автоматически	2025-09-06 02:27:38.977	2025-09-06 02:27:38.977
117	85	\N	1	pending	1280.00	Заказ оплачен и создан автоматически	2025-09-06 02:45:01.747	2025-09-06 02:45:01.747
118	85	77	1	pending	3436.00	Заказ оплачен и создан автоматически	2025-09-06 03:20:37.513	2025-09-06 03:20:37.513
119	85	77	1	pending	2577.00	Заказ оплачен и создан автоматически	2025-09-06 03:31:08.762	2025-09-06 03:31:08.762
120	85	77	1	pending	1280.00	Заказ оплачен и создан автоматически	2025-09-06 03:32:22.783	2025-09-06 03:32:22.783
121	85	78	1	delivered	19757.00	Заказ оплачен и создан автоматически	2025-09-06 03:45:48.083	2025-09-06 04:06:40.278
104	85	\N	1	paid	21475.00	Заказ оплачен и создан автоматически	2025-09-05 22:27:48.948	2025-09-06 23:03:07.788
122	85	80	1	pending	425.00	Заказ оплачен и создан автоматически	2025-09-07 07:52:56.869	2025-09-07 07:52:56.869
123	88	\N	1	paid	36000.00	\N	2025-09-07 13:07:42.406	2025-09-07 13:08:41.333
124	85	\N	1	paid	2577.00	\N	2025-09-07 13:14:13.904	2025-09-07 13:14:25.806
125	88	\N	1	paid	4550.00	\N	2025-09-07 13:22:26.246	2025-09-07 13:22:45.208
126	88	\N	1	paid	36000.00	\N	2025-09-07 13:23:47.762	2025-09-07 13:24:03.438
127	88	\N	1	paid	36000.00	\N	2025-09-07 13:29:27.312	2025-09-07 13:29:42.537
128	85	\N	1	paid	3436.00	\N	2025-09-08 03:05:59.314	2025-09-08 03:06:12.696
129	88	\N	1	paid	24000.00	\N	2025-09-08 03:10:51.109	2025-09-08 03:11:09.576
130	88	\N	1	paid	2577.00	\N	2025-09-08 03:20:08.454	2025-09-08 03:20:21.97
131	85	\N	1	paid	3436.00	\N	2025-09-08 03:36:29.818	2025-09-08 03:36:42.916
135	85	81	1	pending	144135.00	\N	2025-09-08 22:48:39.796	2025-09-08 22:48:39.796
136	85	\N	1	pending	144135.00	\N	2025-09-08 22:49:09.921	2025-09-08 22:49:09.921
143	88	83	1	paid	9000.00	\N	2025-09-09 04:39:48.963	2025-09-09 04:40:09.578
132	85	80	1	delivered	1280.00	\N	2025-09-08 03:50:13.34	2025-09-08 11:50:09.3
133	88	80	1	delivered	51667.00	\N	2025-09-08 04:15:50.852	2025-09-08 11:50:09.3
137	85	\N	1	paid	144135.00	\N	2025-09-08 22:49:51.718	2025-09-08 22:50:44.136
134	124	81	1	delivered	72000.00	\N	2025-09-08 22:47:16.047	2025-09-08 22:53:10.049
144	85	83	1	paid	48000.00	\N	2025-09-09 04:43:08.511	2025-09-09 04:43:52.831
145	85	83	1	pending	3691.00	\N	2025-09-09 05:25:28.93	2025-09-09 05:25:28.93
138	85	82	1	shipped	2143.00	\N	2025-09-09 01:10:30.208	2025-09-09 01:17:27.526
139	88	82	1	shipped	22500.00	\N	2025-09-09 01:11:48.009	2025-09-09 01:17:27.526
140	85	82	1	shipped	120000.00	\N	2025-09-09 01:14:59.46	2025-09-09 01:17:27.526
141	88	83	1	paid	312000.00	\N	2025-09-09 04:35:04.654	2025-09-09 04:35:27.866
146	85	83	1	paid	4971.00	\N	2025-09-09 05:25:55.867	2025-09-09 05:26:19.044
147	125	83	1	paid	340.00	\N	2025-09-09 08:12:57.627	2025-09-09 08:13:46.179
148	85	83	1	paid	320.00	\N	2025-09-09 08:16:48.593	2025-09-09 08:17:31.593
149	85	83	1	pending	2580.00	\N	2025-09-22 13:28:16.527	2025-09-22 13:28:16.527
150	85	83	1	pending	960.00	asdasdasd	2025-09-24 08:54:00.95	2025-09-24 08:54:00.95
151	85	83	1	pending	3436.00	gtrgfvc	2025-09-24 08:59:18.292	2025-09-24 08:59:18.292
152	85	83	1	pending	2577.00	\N	2025-09-24 09:13:40.57	2025-09-24 09:13:40.57
153	85	\N	1	pending	1000.00	l;ll	2025-09-24 09:18:34.98	2025-09-24 09:18:34.98
154	85	\N	1	pending	1000.00	l;ll	2025-09-24 09:18:42.429	2025-09-24 09:18:42.429
155	85	\N	1	pending	1000.00	l;ll	2025-09-24 09:20:53.325	2025-09-24 09:20:53.325
156	85	\N	1	pending	600.00	fyh	2025-09-24 09:21:09.647	2025-09-24 09:21:09.647
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.products (id, "categoryId", name, description, "imageUrl", price, unit, "minQuantity", "maxQuantity", "isActive", "createdAt", "updatedAt") FROM stdin;
35	1	Хлеб белый	\N	\N	45.00	шт	1	\N	t	2025-08-10 06:16:53.912	2025-08-10 06:16:53.912
36	34	Яблоки красные	\N	\N	120.00	кг	1	\N	t	2025-08-10 06:24:21.011	2025-08-10 06:30:18.612
71	1	Хлеб белый черный	\N	\N	4500.00	шт	1	\N	t	2025-09-05 13:39:18.988	2025-09-05 13:39:18.988
1	1	Хлеб ржаной	Традиционный ржаной хлеб	\N	95.00	шт	1	60	t	2025-08-04 03:19:24.986	2025-09-05 15:03:48.63
72	34	Яблоки красно-чёрные	\N	\N	12000.00	кг	1	120	t	2025-09-05 13:39:19.239	2025-09-09 05:27:41.117
73	68	Тушёнка говяжья	\N	\N	200.00	шт	1	\N	t	2025-09-09 05:31:52.918	2025-09-09 05:31:52.918
2	3	Молоко 3.2%	Натуральное цельное молоко	\N	85.00	л	1	100	t	2025-08-04 03:19:24.986	2025-09-22 13:28:16.475
3	3	Творог 9%	Домашний творог	\N	320.00	кг	1	94	t	2025-08-04 03:19:24.986	2025-09-24 08:54:00.91
70	3	Молоко 332%	\N	\N	859.00	л	1	22	t	2025-09-05 13:39:18.712	2025-09-24 09:13:40.532
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.system_settings (id, key, value, description, "updatedAt") FROM stdin;
3	payment_mode	test	Режим платежей: test или production	2025-09-06 13:10:15.944
1	default_margin_percent	50	Маржа по умолчанию для новых партий (%)	2025-09-06 13:10:27.54
2	vat_code	6	Код НДС: 1=20%, 2=10%, 3=20/120, 4=10/110, 5=0%, 6=без НДС	2025-09-06 13:10:35.502
4	enable_test_cards	false	Разрешить тестовые карты в боевом режиме	2025-09-07 03:33:21.658
24	maintenance_mode	false	Режим технического обслуживания	2025-09-20 12:44:33.112
25	maintenance_message	Проводятся технические работы	Сообщение при техническом обслуживании	2025-09-20 12:44:33.139
26	maintenance_end_time		Планируемое время окончания обслуживания	2025-09-20 12:44:33.155
23	allowed_phones	["+79142347019"]	Телефоны с доступом во время обслуживания	2025-09-20 12:44:33.171
11	checkout_enabled	false	Разрешить пользователям оформлять заказы	2025-09-25 08:29:52.829
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.users (id, phone, "firstName", "lastName", email, "isActive", "createdAt", "updatedAt", "acceptedTerms", "acceptedTermsAt", "acceptedTermsIp") FROM stdin;
88	79141030067	Мила	\N	\N	t	2025-08-23 22:55:31.933	2025-08-23 22:55:31.933	t	2025-08-23 22:55:31.933	\N
85	79142667582	asdas	\N	\N	t	2025-08-20 11:54:32.934	2025-08-26 00:17:33.075	t	2025-08-20 11:54:32.934	\N
124	79142347019	Алиса	\N	\N	t	2025-09-08 22:46:30.795	2025-09-08 22:46:30.795	f	\N	\N
125	79148291630	Тамя	Карлина	\N	t	2025-09-09 08:12:01.417	2025-09-09 08:12:01.417	f	\N	\N
126	79841037050	Александр	Шпак	proics2009_94@mail.ru	t	2025-09-11 05:42:52.01	2025-09-11 05:42:52.01	f	\N	\N
\.


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.addresses_id_seq', 35, true);


--
-- Name: batch_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.batch_items_id_seq', 33, true);


--
-- Name: batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.batches_id_seq', 115, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.categories_id_seq', 100, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.order_items_id_seq', 216, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.orders_id_seq', 187, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.products_id_seq', 105, true);


--
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 109, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.users_id_seq', 158, true);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: app_settings app_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.app_settings
    ADD CONSTRAINT app_settings_pkey PRIMARY KEY (key);


--
-- Name: batch_items batch_items_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.batch_items
    ADD CONSTRAINT batch_items_pkey PRIMARY KEY (id);


--
-- Name: batches batches_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT batches_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_key_key; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_key_key UNIQUE (key);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: batch_items_batchId_productId_key; Type: INDEX; Schema: public; Owner: superadmin
--

CREATE UNIQUE INDEX "batch_items_batchId_productId_key" ON public.batch_items USING btree ("batchId", "productId");


--
-- Name: users_phone_key; Type: INDEX; Schema: public; Owner: superadmin
--

CREATE UNIQUE INDEX users_phone_key ON public.users USING btree (phone);


--
-- Name: addresses addresses_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "addresses_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: batch_items batch_items_batchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.batch_items
    ADD CONSTRAINT "batch_items_batchId_fkey" FOREIGN KEY ("batchId") REFERENCES public.batches(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: batch_items batch_items_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.batch_items
    ADD CONSTRAINT "batch_items_productId_fkey" FOREIGN KEY ("productId") REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: order_items order_items_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "order_items_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public.orders(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_items order_items_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "order_items_productId_fkey" FOREIGN KEY ("productId") REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orders orders_addressId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "orders_addressId_fkey" FOREIGN KEY ("addressId") REFERENCES public.addresses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orders orders_batchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "orders_batchId_fkey" FOREIGN KEY ("batchId") REFERENCES public.batches(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: orders orders_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "orders_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: products products_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "products_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: superadmin
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- Name: FUNCTION pg_replication_origin_advance(text, pg_lsn); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_advance(text, pg_lsn) TO mdb_replication;


--
-- Name: FUNCTION pg_replication_origin_create(text); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_create(text) TO mdb_replication;


--
-- Name: FUNCTION pg_replication_origin_drop(text); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_drop(text) TO mdb_replication;


--
-- Name: FUNCTION pg_replication_origin_oid(text); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_oid(text) TO mdb_replication;


--
-- Name: FUNCTION pg_replication_origin_progress(text, boolean); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_progress(text, boolean) TO mdb_replication;


--
-- Name: FUNCTION pg_replication_origin_session_reset(); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_reset() TO mdb_replication;


--
-- Name: FUNCTION pg_replication_origin_session_setup(text); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_setup(text) TO mdb_replication;


--
-- Name: FUNCTION pg_replication_origin_xact_reset(); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_xact_reset() TO mdb_replication;


--
-- Name: FUNCTION pg_replication_origin_xact_setup(pg_lsn, timestamp with time zone); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_xact_setup(pg_lsn, timestamp with time zone) TO mdb_replication;


--
-- Name: FUNCTION pg_stat_reset(); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset() TO mdb_admin;


--
-- Name: FUNCTION pg_stat_reset_shared(text); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset_shared(text) TO mdb_admin;


--
-- Name: FUNCTION pg_stat_reset_single_function_counters(oid); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset_single_function_counters(oid) TO mdb_admin;


--
-- Name: FUNCTION pg_stat_reset_single_table_counters(oid); Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT ALL ON FUNCTION pg_catalog.pg_stat_reset_single_table_counters(oid) TO mdb_admin;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO "Idob23" WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

\unrestrict aV0GrKTzC7IXcaYuZ4oZOtvfRXyAhSOJ1XS3SnfyjnmMIFmLV3ln9n1ybwMvZxX

