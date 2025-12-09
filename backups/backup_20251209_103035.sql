--
-- PostgreSQL database dump
--

\restrict 7tIGHStsGpSdgRybUdGlZnP0bvxLjNxqx1Ito7dOunwgbPz0ESvcjA4WQUnJxqu

-- Dumped from database version 15.14 (Ubuntu 15.14-201-yandex.55518.14158a575f)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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
-- Name: payments; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    "paymentId" text NOT NULL,
    "orderId" integer NOT NULL,
    provider text DEFAULT 'tochka'::text NOT NULL,
    status text NOT NULL,
    amount numeric(10,2) NOT NULL,
    metadata text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "paidAt" timestamp(3) without time zone
);


ALTER TABLE public.payments OWNER TO superadmin;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO superadmin;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: product_snapshots; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.product_snapshots (
    id integer NOT NULL,
    product_id integer NOT NULL,
    name text NOT NULL,
    unit text NOT NULL,
    price numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.product_snapshots OWNER TO superadmin;

--
-- Name: product_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.product_snapshots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_snapshots_id_seq OWNER TO superadmin;

--
-- Name: product_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.product_snapshots_id_seq OWNED BY public.product_snapshots.id;


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
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "basePrice" numeric(10,2),
    "baseUnit" text,
    "inPackage" integer,
    "saleType" character varying(20)
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
-- Name: supplier_category_mappings; Type: TABLE; Schema: public; Owner: superadmin
--

CREATE TABLE public.supplier_category_mappings (
    id integer NOT NULL,
    "supplierCategory" text NOT NULL,
    "targetCategoryId" integer NOT NULL,
    confidence text DEFAULT 'manual'::text NOT NULL,
    "timesUsed" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "saleType" character varying(20) DEFAULT 'поштучно'::character varying
);


ALTER TABLE public.supplier_category_mappings OWNER TO superadmin;

--
-- Name: supplier_category_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: superadmin
--

CREATE SEQUENCE public.supplier_category_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supplier_category_mappings_id_seq OWNER TO superadmin;

--
-- Name: supplier_category_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superadmin
--

ALTER SEQUENCE public.supplier_category_mappings_id_seq OWNED BY public.supplier_category_mappings.id;


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
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: product_snapshots id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.product_snapshots ALTER COLUMN id SET DEFAULT nextval('public.product_snapshots_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: supplier_category_mappings id; Type: DEFAULT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.supplier_category_mappings ALTER COLUMN id SET DEFAULT nextval('public.supplier_category_mappings_id_seq'::regclass);


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
c9f8cace-1f3a-4a5e-a740-a0f60cf77c73	4bf2d0fe7fc2ff8e4109a0dacb0a528dec54894bd56016adf01c47921a7f08ad	2025-11-05 12:22:37.675324+03	20251105091913_add_supplier_category_mapping		\N	2025-11-05 12:22:37.675324+03	0
\.


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.addresses (id, "userId", title, address, "isDefault", "createdAt") FROM stdin;
41	88	Дом	Коммунистическая 7 кв 11	t	2025-10-17 10:00:27.821
42	285	Дом	пгт. Усть-Нера, ул. Мацкепладзе, д. 15	t	2025-10-17 12:54:08.797
43	295	дом	п. Усть-Нера, ул. Цареградского, д. 12, кв. 7	t	2025-10-18 00:31:53.019
44	293	дом	п. Усть-Нера,ул. Мацкепладзе 16 квартира 11	f	2025-10-18 00:46:18.174
45	293	дом	п. Усть-Нера, улица Мацкепладзе 16 кв 11	t	2025-10-18 00:47:05.648
46	297	Дом	Усть-нера  Гагарина 20а кв 1	f	2025-10-20 02:37:46.296
47	317	дом	пооаоаволлвлвлвдыдяьчьшччд	f	2025-10-21 11:36:13.016
48	309	дом	Ленина 1пллплп	f	2025-10-21 23:20:01.389
50	317	щошыува	ыщвшопы	f	2025-10-22 11:31:06.428
52	323	дом	коммунистическая 7,11	f	2025-10-26 23:35:07.685
53	282	дом	усть-нера молодежная 4 кв12	t	2025-11-03 00:50:51.894
54	342	дом	п. Усть-Нера ул. Кривошапкина д19.	t	2025-11-04 05:51:25.835
55	347	дом	усть-нера, трудовая 4, кв. 35	t	2025-11-04 07:28:58.392
56	358	Дом	пгт. Усть-Нера, ул. Мацкепладзе 18-10	f	2025-11-11 11:18:48.529
57	358	Дом	пгт. Усть-Нера, ул. Мацкепладзе 18-10	f	2025-11-11 11:20:24.149
58	361	дом	Усть-Нера, ул. Кривошапкина, дом 11, кв. 16	t	2025-11-11 11:30:12.973
59	356	Дом	п. Усть-Нера, ул. Раковского 7, 1 подъезд	t	2025-11-11 11:30:40.83
61	360	Работа	пгт. Усть-Нера, ул. Кривошапкина, д. 42, кв. 2. (Контора лесничества)	f	2025-11-12 04:46:59.74
62	371	Дом	Саха (Якутия), Оймяконский р-н, п. Усть-Нера, ул. Мацкепладзе 20, кв. 17	f	2025-11-12 09:38:58.733
63	391	Дом	п. Усть-Нера, ул. Ленина, д. 23, кв. 2	f	2025-11-13 06:32:40.569
64	391	Работа	п. Усть-Нера, Энергетический проезд, д. 3 (Пожарная часть)	f	2025-11-14 04:04:20.035
65	391	дом	п. Усть-Нера, ул. Ленина, д. 23, кв. 2	t	2025-11-15 06:58:59.599
66	401	Усть Нера	Октябрьский 8/1 КВ 20	f	2025-11-17 06:06:41.368
67	399	п.Усть-Нера ул. Коммунистическая 23 кв 5	п.Усть-Нера ул. Коммунистическая 23 кв 5	t	2025-11-17 09:03:30.633
68	391	дом	Усть-Нера, ул. Ленина, д. 23, кв. 2	f	2025-11-18 02:50:49.956
69	402	дом	пгт Усть-Нера ул. Мацкепладзе 12 кв22	f	2025-11-18 03:15:42.826
70	374	Дом	пгт. Усть-Нера, ул.Молодёжная, д.2, кв.3	f	2025-11-21 07:23:09.263
60	374	Дом	Усть-Нера, улица Молодёжная, дом 2, квартира 3	f	2025-11-11 21:35:55.788
72	296	дом	Усть-Нера, Мацкепладзе, 7, кв 19	f	2025-11-24 00:32:10.148
71	374	Дом	пгт.Усть-Нера, ул.Молодёжная, д.2, кв.3	f	2025-11-21 07:23:49.121
73	374	Дом	пгт.Усть-Нера, ул.Молодёжная, д.2, кв.3	t	2025-11-24 03:13:07.195
75	391	Дом	п. Усть-Нера, ул. Ленина, д. 23, кв. 2	f	2025-11-24 10:21:37.094
76	413	1-й Октябрьский переулок 7/1 кв.20	1-й Октябрьский переулок 7/1кв.20	f	2025-11-24 11:35:29.611
77	282	дом	молодежная 4кв12	f	2025-11-25 08:59:34.476
78	391	дом	п. Усть-Нера, ул. Ленина, д. 23, кв. 2	f	2025-11-25 09:50:42.216
79	418	Многоквартирный дом	п. Усть-Нера, улица Андрианова 2, квартира 7	t	2025-11-25 10:16:38.796
80	407	дом	п.Усть-Нера, ул. Мацкепладзе 16 кв. 24	t	2025-11-25 10:45:42.596
81	416	дом	п. Усть-Нера,  мкр. Нерский, д 59, кв 5	f	2025-11-25 11:11:52.027
82	416	дом	п. Усть-Нера,  мкр. Нерский,  дом.59, кв.5	f	2025-11-25 11:12:36.646
83	412	дом	п. Усть-Нера, ул. Раковского 4,6	f	2025-11-25 23:44:32.672
84	359	п.Усть-нера.ул Заводская 19 кв 2	п.Усть-нера,ул.Заводская 19 кв 2	f	2025-11-26 01:05:22.97
85	359	Заводская 19 кв 2 Усть-нера	п.Усть-нера.ул Заводская 19 кв 2	t	2025-11-26 01:12:19.308
86	421	дом	п.Усть-Нера улица Индигирская дом 46 квартира 1	f	2025-11-26 01:31:01.48
87	372	Усть-Нера	пгт.Усть-Нера ул.Кривошапкина дом 9а КВ.21	f	2025-12-01 04:24:59.904
120	426	дом	п.Усть-Нера, Ленина 29 подъезд 1	t	2025-12-01 23:19:17.233
121	406	дом	республика Саха Якутия Оймяконский район п Усть-Нера ко. Андрианова 9а КВ 19	f	2025-12-02 02:25:16.944
74	411	Дом	пгт Усть-Нера пер октябрьский 7/3 кв 13	f	2025-11-24 07:33:12.652
122	411	дом	Усть-Нера Октябрьский 1-й 7/2 кв 13	t	2025-12-02 23:25:35.432
123	292	дом	пгт. Усть-Нера, ул. Мацкепладзе д.12, кв.34	t	2025-12-02 23:28:28.281
124	372	дом	пгт. Усть-Нера Ул. Кривошапкина дом. 9а кв. 21	f	2025-12-03 06:23:56.583
125	463	дом	Усть-Нера , ул Ленина д 27 кв 40	f	2025-12-04 09:12:34.939
126	415	дом	п. Усть-Нера,  ул. Ленина д.23,кв. 25	f	2025-12-07 23:16:02.534
127	415	дом	п. Усть-нера, ул. Ленина ,д.23,кв.25	f	2025-12-07 23:17:57.706
128	415	дом	п. Усть-Нера, ул. Ленина, д. 23, кв. 25	f	2025-12-07 23:18:46.475
129	415	Дом	п. Усть-Нера, ул. Ленина 23,3й подъезд,кв. 25	t	2025-12-07 23:32:39.599
130	466	Мацкепладзе 16а,кв14	мацкепладзе 16а кв14	t	2025-12-08 01:41:23.193
131	465	дом.	Мацкепладзе 11/35	f	2025-12-08 22:57:32.659
132	384	Дом	п. Усть-Нера,  ул. Мацкепладзе, д.20, кв. 48.	t	2025-12-09 08:46:27.69
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
193	03.11.25	Автоматически созданная партия для сбора заказов	2025-11-03 00:17:02.374	2025-11-10 00:17:02.374	\N	5	\N	completed	\N	700000.00	23228.75	3	3	2025-11-04 06:33:00.749	t	25.00	2025-11-03 00:17:02.375	2025-11-05 11:31:21.784	2025-11-03 00:17:02.374
207	24.11.25	Автоматически созданная партия для сбора заказов	2025-11-23 11:37:11.497	2025-11-30 11:37:11.497	\N	5	\N	completed	\N	200000.00	107814.80	10	54	2025-11-26 04:18:00.618	t	15.00	2025-11-23 11:37:11.498	2025-11-26 11:21:35.85	2025-11-23 11:37:11.497
191	27.10.25	Автоматически созданная партия для сбора заказов	2025-10-26 20:12:36.257	2025-11-02 20:12:36.257	\N	5	\N	completed	\N	700000.00	22673.75	2	3	2025-10-29 02:00:00.601	t	25.00	2025-10-26 20:12:36.258	2025-10-29 02:02:45.769	2025-10-26 20:12:36.257
199	10.11.25	Автоматически созданная партия для сбора заказов	2025-11-10 01:57:25.595	2025-11-17 01:57:25.595	\N	5	\N	completed	\N	700000.00	110902.50	6	16	2025-11-12 09:42:00.828	t	25.00	2025-11-10 01:57:25.596	2025-11-13 12:13:55.041	2025-11-10 01:57:25.595
246	7.12.25	Автоматически созданная партия для сбора заказов	2025-12-07 13:20:08.565	2025-12-14 13:20:08.565	\N	5	\N	collecting	\N	200000.00	63339.84	6	32	2025-12-09 10:12:00.937	t	15.00	2025-12-07 13:20:08.566	2025-12-09 10:12:00.938	2025-12-07 13:20:08.565
210	1.12.25	Автоматически созданная партия для сбора заказов	2025-11-30 10:56:19.418	2025-12-07 10:56:19.418	\N	5	\N	completed	\N	150000.00	78885.40	5	53	2025-12-03 08:48:00.334	t	15.00	2025-11-30 10:56:19.419	2025-12-03 11:49:08.822	2025-11-30 10:56:19.418
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.categories (id, name, description, "imageUrl", "isActive", "createdAt") FROM stdin;
3367	Рыба и морепродукты	Автоматически из прайса	\N	t	2025-11-22 11:50:47.914
3303	Кондитерские изделия	Автоматически из прайса	\N	t	2025-11-22 11:50:03.136
3327	Консервы	Автоматически из прайса	\N	t	2025-11-22 11:50:22.234
3317	Крупы и макароны	Автоматически из прайса	\N	t	2025-11-22 11:50:11.53
3314	Сыры	Автоматически из прайса	\N	t	2025-11-22 11:50:10.12
3391	Полуфабрикаты готовые	\N	\N	t	2025-11-22 11:51:47.546
3356	Пельмени и вареники	Автоматически из прайса	\N	t	2025-11-22 11:50:42.498
3323	Напитки	Автоматически из прайса	\N	t	2025-11-22 11:50:16.452
3305	Молочная продукция	Автоматически из прайса	\N	t	2025-11-22 11:50:06.417
3310	Мясо и птица	Автоматически из прайса	\N	t	2025-11-22 11:50:08.541
2755	Архив	Удалённые товары (для истории заказов)	\N	f	2025-11-09 07:32:27.275
3397	Выпечка и тесто	\N	\N	t	2025-11-22 11:51:47.712
3398	Для суши	\N	\N	t	2025-11-22 11:51:47.734
3396	Колбаса, сосиски, сардельки	\N	\N	t	2025-11-22 11:51:47.69
3394	Варенье, джем, повидло	\N	\N	t	2025-11-22 11:51:47.631
3399	К пиву	\N	\N	t	2025-11-22 11:51:47.758
3401	Масла	\N	\N	t	2025-11-22 11:51:47.815
3405	Сухофрукты и орехи	\N	\N	t	2025-11-22 11:51:47.912
3400	Соусы	\N	\N	t	2025-11-22 11:51:47.78
3404	Соль, сахар, мука	\N	\N	t	2025-11-22 11:51:47.89
3403	Приправы	\N	\N	t	2025-11-22 11:51:47.867
3395	Овощи, фрукты, грибы замороженные	\N	\N	t	2025-11-22 11:51:47.669
3402	Мёд	\N	\N	t	2025-11-22 11:51:47.837
3392	Мороженое	\N	\N	t	2025-11-22 11:51:47.574
3393	Хоз. товары	\N	\N	t	2025-11-22 11:51:47.6
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.order_items (id, "orderId", "productId", quantity, price) FROM stdin;
682	557	54107	1	416.53
683	557	54106	1	420.13
684	558	54106	1	420.13
685	559	54106	1	420.13
686	560	54106	1	420.13
422	442	22088	1	32.50
427	445	24982	1	3187.50
428	446	25827	1	1612.50
429	446	25193	1	825.00
430	447	24518	1	3300.00
431	447	24513	1	1400.00
432	447	26099	1	1320.00
433	448	24689	1	2485.00
434	448	24690	1	2485.00
435	448	26059	1	15125.00
436	448	25618	1	1035.00
437	448	25617	1	1035.00
438	448	25336	1	1402.50
439	448	25315	1	1590.00
440	449	24562	1	3750.00
441	449	25178	1	4995.00
442	449	25679	1	3312.50
443	449	25703	1	2805.00
444	449	25712	1	2880.00
445	449	25747	1	1700.00
446	449	25748	1	1787.50
447	449	25781	1	2640.00
448	449	25795	2	3420.00
449	449	25856	2	6062.50
450	449	26008	1	1586.25
451	449	26347	1	3500.00
452	450	26063	1	10800.00
453	450	24974	1	2485.00
454	450	24988	1	5418.75
455	450	25395	1	1455.00
456	450	25403	1	1530.00
457	450	25383	1	1740.00
458	450	26356	1	2750.00
463	455	38929	1	3471.85
464	455	38204	1	2475.95
465	455	38203	1	2475.95
466	455	38200	1	2507.00
467	455	38376	1	4297.55
468	455	38947	1	2592.10
469	455	39445	1	1269.60
470	455	39444	1	1269.60
471	455	39449	1	1269.60
472	455	39617	1	1094.80
473	455	39618	1	1094.80
474	455	39620	1	1094.80
475	455	39621	1	1094.80
476	456	39533	1	1936.60
477	456	39984	1	2976.20
478	456	40224	3	610.65
480	458	38587	1	2559.90
481	458	38616	2	254.15
482	458	39134	1	872.85
483	458	39613	1	1094.80
484	458	39614	1	1094.80
485	458	39620	1	1094.80
486	458	39815	1	3481.05
487	458	39954	1	6174.35
488	458	40006	1	4046.85
489	458	40067	1	8014.35
490	458	40371	1	2447.20
491	459	39782	1	5051.95
492	460	39526	1	243.80
493	461	39614	1	1094.80
494	461	38962	1	2221.80
495	461	40370	1	2313.80
496	461	39619	1	1094.80
499	463	39627	1	2976.20
500	463	38662	1	1064.90
501	464	39339	1	1619.20
502	464	39331	1	1539.85
503	464	38346	1	2624.30
505	466	39533	2	1936.60
506	467	39958	1	7342.75
507	467	39533	1	1936.60
509	469	39936	1	8674.45
547	507	42046	1	5336.00
548	507	40897	1	6882.75
549	507	42115	1	11168.80
550	507	41629	2	936.10
551	507	42175	2	2354.05
552	508	42047	1	4332.05
553	508	40938	1	1064.90
554	509	41739	1	1936.60
555	509	41193	1	2221.80
556	509	41741	1	1825.05
557	510	42162	2	15711.30
558	511	40769	1	1269.60
559	511	40870	1	2285.05
560	511	40866	1	2559.90
580	522	54119	1	5092.20
581	522	53758	2	1888.30
582	522	52857	1	2128.65
583	522	53823	1	836.05
591	527	54125	1	4332.05
596	529	54239	1	10124.60
597	529	53830	1	1094.80
598	529	53829	1	1094.80
599	529	53840	1	2849.70
600	530	52438	1	4020.40
601	530	52517	1	3805.35
602	530	52676	2	2047.00
603	530	52686	1	1338.60
604	530	52688	1	1338.60
605	530	54206	1	11168.80
637	536	53086	1	2916.40
671	550	54176	1	1184.50
672	550	54133	1	437.69
673	550	54661	1	1044.80
674	550	54151	2	330.62
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.orders (id, "userId", "batchId", "addressId", status, "totalAmount", notes, "createdAt", "updatedAt") FROM stdin;
419	323	191	52	delivered	10123.75	\N	2025-10-26 23:35:17.367	2025-11-05 11:31:58.367
420	309	191	48	delivered	4287.50	\N	2025-10-26 23:55:00.414	2025-11-05 11:31:58.367
445	323	199	52	delivered	3187.50	\N	2025-11-10 02:26:53.044	2025-11-17 10:09:46.24
446	356	199	59	delivered	2437.50	\N	2025-11-11 11:30:59.279	2025-11-17 10:09:46.24
447	361	199	58	delivered	6020.00	позвонить за час до доставки	2025-11-11 11:52:35.96	2025-11-17 10:09:46.24
448	374	199	60	delivered	25157.50	\N	2025-11-12 01:36:54.294	2025-11-17 10:09:46.24
449	360	199	61	delivered	47921.25	Позвонить за час до доставки.	2025-11-12 07:11:34.015	2025-11-17 10:09:46.24
450	371	199	62	delivered	26178.75	\N	2025-11-12 09:39:28.589	2025-11-17 10:09:46.24
507	406	210	121	delivered	29967.85	\N	2025-12-02 02:33:58.182	2025-12-09 08:09:23.863
508	292	210	123	delivered	5396.95	\N	2025-12-02 23:29:01.81	2025-12-09 08:09:23.863
509	399	210	67	delivered	5983.45	\N	2025-12-03 03:31:05.09	2025-12-09 08:09:23.863
510	372	210	87	delivered	31422.60	позвонить за час до доставки 	2025-12-03 06:17:30.203	2025-12-09 08:09:23.863
511	282	210	53	delivered	6114.55	\N	2025-12-03 08:42:58.146	2025-12-09 08:09:23.863
424	323	191	52	delivered	8262.50	\N	2025-10-29 01:56:10.431	2025-11-05 11:31:58.367
536	384	246	132	paid	2916.40	\N	2025-12-09 08:49:40.165	2025-12-09 08:54:01.085
427	282	193	53	delivered	5490.00	\N	2025-11-03 00:51:07.834	2025-11-11 09:35:33.779
428	323	193	52	delivered	10115.00	\N	2025-11-03 01:07:54.545	2025-11-11 09:35:33.779
430	342	193	54	delivered	7623.75	\N	2025-11-04 06:29:44.358	2025-11-11 09:35:33.779
455	374	207	73	delivered	26008.40	\N	2025-11-24 03:25:16.934	2025-12-02 05:53:00.604
456	399	207	67	delivered	6744.75	\N	2025-11-24 06:17:28.942	2025-12-02 05:53:00.604
550	465	246	131	paid	3328.24	Перезвонить о доставке. 	2025-12-09 10:08:37.759	2025-12-09 10:12:00.876
557	465	246	131	pending	836.66	\N	2025-12-09 10:23:17.593	2025-12-09 10:23:17.593
558	465	246	131	pending	420.13	\N	2025-12-09 10:24:54.663	2025-12-09 10:24:54.663
559	465	246	131	pending	420.13	\N	2025-12-09 10:27:07.517	2025-12-09 10:27:07.517
560	465	246	131	pending	420.13	\N	2025-12-09 10:29:21.373	2025-12-09 10:29:21.373
458	282	207	53	delivered	31389.25	\N	2025-11-25 09:00:05.771	2025-12-02 05:53:00.604
459	323	207	52	delivered	5051.95	\N	2025-11-25 09:25:44.477	2025-12-02 05:53:00.604
460	391	207	65	delivered	243.80	\N	2025-11-25 10:04:15.472	2025-12-02 05:53:00.604
461	407	207	80	delivered	6725.20	позвонить за час до доставки 	2025-11-25 11:09:07.147	2025-12-02 05:53:00.604
463	416	207	81	delivered	4041.10	\N	2025-11-25 11:19:11.166	2025-12-02 05:53:00.604
464	399	207	67	delivered	5783.35	привет как дела?)	2025-11-25 23:32:11.949	2025-12-02 05:53:00.604
466	359	207	85	delivered	3873.20	\N	2025-11-26 01:17:15.885	2025-12-02 05:53:00.604
467	412	207	83	delivered	9279.35	позвонить за час	2025-11-26 03:12:45.357	2025-12-02 05:53:00.604
469	411	207	74	delivered	8674.45	Позвонить за час до доставки 	2025-11-26 04:13:55.751	2025-12-02 05:53:00.604
442	323	\N	52	delivered	32.50	\N	2025-11-09 06:36:46.61	2025-11-09 06:44:34.018
522	415	246	129	paid	11833.50	\N	2025-12-07 23:40:20.736	2025-12-07 23:42:00.664
527	466	246	130	paid	4332.05	да,пожайлуста, позвоните за 1 час.	2025-12-08 02:04:55.167	2025-12-08 02:09:00.539
529	407	246	80	paid	15163.90	предупредить заранее о доставке	2025-12-08 10:37:02.935	2025-12-08 10:39:00.611
530	374	246	73	paid	25765.75	\N	2025-12-08 14:51:52.108	2025-12-08 14:54:00.382
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.payments (id, "paymentId", "orderId", provider, status, amount, metadata, "createdAt", "paidAt") FROM stdin;
155	cab92e02-f790-4b37-b7ee-8719ba833daf	442	tochka	APPROVED	32.50	{"breakdown":{"goods":26,"service":6.5,"total":32.5,"marginPercent":25,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=cab92e02-f790-4b37-b7ee-8719ba833daf","userId":323,"batchId":198,"customerPhone":"79142667582","cronUpdatedAt":"2025-11-09T06:39:00.684Z","previousStatus":"CREATED"}	2025-11-09 06:36:47.319	2025-11-09 06:39:00.684
163	77e5b39d-c435-443a-8199-df9b8f1aaf0a	450	tochka	APPROVED	26178.75	{"breakdown":{"goods":20943,"service":5235.75,"total":26178.75,"marginPercent":25,"itemsCount":7},"confirmationUrl":"https://merch.tochka.com/order/?uuid=77e5b39d-c435-443a-8199-df9b8f1aaf0a","userId":371,"batchId":199,"customerPhone":"79142237424","cronUpdatedAt":"2025-11-12T09:42:00.650Z","previousStatus":"CREATED"}	2025-11-12 09:39:29.191	2025-11-12 09:42:00.65
169	9c143911-4506-4495-9293-0fdc9e52afd1	458	tochka	APPROVED	31389.25	{"breakdown":{"goods":27295,"service":4094.25,"total":31389.249999999996,"marginPercent":15,"itemsCount":11},"confirmationUrl":"https://merch.tochka.com/order/?uuid=9c143911-4506-4495-9293-0fdc9e52afd1","userId":282,"batchId":207,"customerPhone":"79142654503","cronUpdatedAt":"2025-11-25T09:03:00.429Z","previousStatus":"CREATED"}	2025-11-25 09:00:06.607	2025-11-25 09:03:00.429
170	2a33a456-be83-4a3a-bc2b-57fe6e628448	459	tochka	APPROVED	5051.95	{"breakdown":{"goods":4393,"service":658.95,"total":5051.95,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=2a33a456-be83-4a3a-bc2b-57fe6e628448","userId":323,"batchId":207,"customerPhone":"79142667582","cronUpdatedAt":"2025-11-25T09:27:00.510Z","previousStatus":"CREATED"}	2025-11-25 09:25:45.098	2025-11-25 09:27:00.51
171	a7a9213b-2a67-41d0-b3fb-98e08849b04d	460	tochka	APPROVED	243.80	{"breakdown":{"goods":212,"service":31.8,"total":243.79999999999998,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=a7a9213b-2a67-41d0-b3fb-98e08849b04d","userId":391,"batchId":207,"customerPhone":"79240171919","cronUpdatedAt":"2025-11-25T10:12:00.505Z","previousStatus":"CREATED"}	2025-11-25 10:04:16.494	2025-11-25 10:12:00.505
172	b2326fb0-0c56-456d-ba66-5a6c97539f49	461	tochka	APPROVED	6725.20	{"breakdown":{"goods":5848,"service":877.2,"total":6725.2,"marginPercent":15,"itemsCount":4},"confirmationUrl":"https://merch.tochka.com/order/?uuid=b2326fb0-0c56-456d-ba66-5a6c97539f49","userId":407,"batchId":207,"customerPhone":"79888692936","cronUpdatedAt":"2025-11-25T11:12:00.408Z","previousStatus":"CREATED"}	2025-11-25 11:09:07.697	2025-11-25 11:12:00.408
174	5e74b1fa-bd36-403c-bd2a-a2bc54970dcf	463	tochka	APPROVED	4041.10	{"breakdown":{"goods":3514,"service":527.1,"total":4041.0999999999995,"marginPercent":15,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=5e74b1fa-bd36-403c-bd2a-a2bc54970dcf","userId":416,"batchId":207,"customerPhone":"79142653784","cronUpdatedAt":"2025-11-25T11:21:00.566Z","previousStatus":"CREATED"}	2025-11-25 11:19:11.671	2025-11-25 11:21:00.566
175	7457d0da-875d-4f25-b8a2-fc6a4305cbb1	464	tochka	APPROVED	5783.35	{"breakdown":{"goods":5029,"service":754.35,"total":5783.349999999999,"marginPercent":15,"itemsCount":3},"confirmationUrl":"https://merch.tochka.com/order/?uuid=7457d0da-875d-4f25-b8a2-fc6a4305cbb1","userId":399,"batchId":207,"customerPhone":"79142247789","cronUpdatedAt":"2025-11-25T23:36:00.308Z","previousStatus":"CREATED"}	2025-11-25 23:32:12.5	2025-11-25 23:36:00.308
253	707326c5-64ce-432e-9a9d-102a4694a332	558	tochka	CREATED	420.13	{"breakdown":{"goods":365.3333333333333,"service":54.8,"total":420.13333333333327,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=707326c5-64ce-432e-9a9d-102a4694a332","userId":465,"batchId":246,"customerPhone":"79142805341"}	2025-12-09 10:24:55.131	\N
254	568e3d2f-d4c1-4369-9a10-26de8e427a10	559	tochka	CREATED	420.13	{"breakdown":{"goods":365.3333333333333,"service":54.8,"total":420.13333333333327,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=568e3d2f-d4c1-4369-9a10-26de8e427a10","userId":465,"batchId":246,"customerPhone":"79142805341"}	2025-12-09 10:27:07.976	\N
255	ee19336b-b2e8-427c-981b-62b5fb623caa	560	tochka	CREATED	420.13	{"breakdown":{"goods":365.3333333333333,"service":54.8,"total":420.13333333333327,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=ee19336b-b2e8-427c-981b-62b5fb623caa","userId":465,"batchId":246,"customerPhone":"79142805341"}	2025-12-09 10:29:21.803	\N
176	de83f460-0126-4bc7-9dfb-e4c964b0a4fb	466	tochka	APPROVED	3873.20	{"breakdown":{"goods":3368,"service":505.2,"total":3873.2,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=de83f460-0126-4bc7-9dfb-e4c964b0a4fb","userId":359,"batchId":207,"customerPhone":"79142675504","cronUpdatedAt":"2025-11-26T01:21:00.384Z","previousStatus":"CREATED"}	2025-11-26 01:17:16.423	2025-11-26 01:21:00.384
177	4616470c-13d2-45da-8147-c9c1dac5d777	467	tochka	APPROVED	9279.35	{"breakdown":{"goods":8069,"service":1210.35,"total":9279.349999999999,"marginPercent":15,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=4616470c-13d2-45da-8147-c9c1dac5d777","userId":412,"batchId":207,"customerPhone":"79142987606","cronUpdatedAt":"2025-11-26T03:18:00.207Z","previousStatus":"CREATED"}	2025-11-26 03:12:45.873	2025-11-26 03:18:00.207
179	1a39893d-3e77-4e81-81bb-8920392f08c4	469	tochka	APPROVED	8674.45	{"breakdown":{"goods":7543,"service":1131.45,"total":8674.449999999999,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=1a39893d-3e77-4e81-81bb-8920392f08c4","userId":411,"batchId":207,"customerPhone":"79148290329","cronUpdatedAt":"2025-11-26T04:18:00.528Z","previousStatus":"CREATED"}	2025-11-26 04:13:56.135	2025-11-26 04:18:00.528
217	cbb50426-df25-412b-9f94-ae63e1f04285	507	tochka	APPROVED	29967.85	{"breakdown":{"goods":26059,"service":3908.85,"total":29967.85,"marginPercent":15,"itemsCount":5},"confirmationUrl":"https://merch.tochka.com/order/?uuid=cbb50426-df25-412b-9f94-ae63e1f04285","userId":406,"batchId":210,"customerPhone":"79245637130","cronUpdatedAt":"2025-12-02T02:36:00.187Z","previousStatus":"CREATED"}	2025-12-02 02:33:58.629	2025-12-02 02:36:00.187
218	abce4c7a-9364-4a83-90ea-9ba2195b4fbd	508	tochka	APPROVED	5396.95	{"breakdown":{"goods":4693,"service":703.95,"total":5396.949999999999,"marginPercent":15,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=abce4c7a-9364-4a83-90ea-9ba2195b4fbd","userId":292,"batchId":210,"customerPhone":"79841180754","cronUpdatedAt":"2025-12-02T23:33:00.561Z","previousStatus":"CREATED"}	2025-12-02 23:29:02.374	2025-12-02 23:33:00.561
219	19a21263-5492-4db9-8da5-a6c3e2183de4	509	tochka	APPROVED	5983.45	{"breakdown":{"goods":5203,"service":780.45,"total":5983.45,"marginPercent":15,"itemsCount":3},"confirmationUrl":"https://merch.tochka.com/order/?uuid=19a21263-5492-4db9-8da5-a6c3e2183de4","userId":399,"batchId":210,"customerPhone":"79142247789","cronUpdatedAt":"2025-12-03T03:33:00.503Z","previousStatus":"CREATED"}	2025-12-03 03:31:05.551	2025-12-03 03:33:00.503
220	8544bcfb-1350-4e1d-bd09-6ca432c16b37	510	tochka	APPROVED	31422.60	{"breakdown":{"goods":27324,"service":4098.6,"total":31422.6,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=8544bcfb-1350-4e1d-bd09-6ca432c16b37","userId":372,"batchId":210,"customerPhone":"79142394702","cronUpdatedAt":"2025-12-03T06:21:00.288Z","previousStatus":"CREATED"}	2025-12-03 06:17:30.65	2025-12-03 06:21:00.288
221	0349f8ee-a1d4-4223-b400-5e0d31c0bcb8	511	tochka	APPROVED	6114.55	{"breakdown":{"goods":5317,"service":797.55,"total":6114.549999999999,"marginPercent":15,"itemsCount":3},"confirmationUrl":"https://merch.tochka.com/order/?uuid=0349f8ee-a1d4-4223-b400-5e0d31c0bcb8","userId":282,"batchId":210,"customerPhone":"79142654503","cronUpdatedAt":"2025-12-03T08:48:00.293Z","previousStatus":"CREATED"}	2025-12-03 08:42:58.6	2025-12-03 08:48:00.293
228	a4667f5a-e2df-40ff-930f-b052701ceace	522	tochka	APPROVED	11833.50	{"breakdown":{"goods":10290,"service":1543.5,"total":11833.499999999998,"marginPercent":15,"itemsCount":4},"confirmationUrl":"https://merch.tochka.com/order/?uuid=a4667f5a-e2df-40ff-930f-b052701ceace","userId":415,"batchId":246,"customerPhone":"79142808155","cronUpdatedAt":"2025-12-07T23:42:00.647Z","previousStatus":"CREATED"}	2025-12-07 23:40:21.175	2025-12-07 23:42:00.647
233	ae8710ee-a0b5-4b60-b063-937ce8b44b89	527	tochka	APPROVED	4332.05	{"breakdown":{"goods":3766.9999999999995,"service":565.05,"total":4332.049999999999,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=ae8710ee-a0b5-4b60-b063-937ce8b44b89","userId":466,"batchId":246,"customerPhone":"79142269276","cronUpdatedAt":"2025-12-08T02:09:00.500Z","previousStatus":"CREATED"}	2025-12-08 02:04:55.558	2025-12-08 02:09:00.5
235	296885a9-df40-4c83-86bd-35b7fee8fb17	529	tochka	APPROVED	15163.90	{"breakdown":{"goods":13186,"service":1977.9,"total":15163.899999999998,"marginPercent":15,"itemsCount":4},"confirmationUrl":"https://merch.tochka.com/order/?uuid=296885a9-df40-4c83-86bd-35b7fee8fb17","userId":407,"batchId":246,"customerPhone":"79888692936","cronUpdatedAt":"2025-12-08T10:39:00.537Z","previousStatus":"CREATED"}	2025-12-08 10:37:03.628	2025-12-08 10:39:00.537
236	8fc9a651-eda4-47e0-966b-08d7e2a8c9a9	530	tochka	APPROVED	25765.75	{"breakdown":{"goods":22405,"service":3360.75,"total":25765.75,"marginPercent":15,"itemsCount":6},"confirmationUrl":"https://merch.tochka.com/order/?uuid=8fc9a651-eda4-47e0-966b-08d7e2a8c9a9","userId":374,"batchId":246,"customerPhone":"79142324164","cronUpdatedAt":"2025-12-08T14:54:00.356Z","previousStatus":"CREATED"}	2025-12-08 14:51:52.565	2025-12-08 14:54:00.356
246	de410f32-6e19-4c38-8c0c-aadfba79eb2c	550	tochka	APPROVED	3328.24	{"breakdown":{"goods":2894.1238095238095,"service":434.12,"total":3328.2423809523807,"marginPercent":15,"itemsCount":4},"confirmationUrl":"https://merch.tochka.com/order/?uuid=de410f32-6e19-4c38-8c0c-aadfba79eb2c","userId":465,"batchId":246,"customerPhone":"79142805341","cronUpdatedAt":"2025-12-09T10:12:00.865Z","previousStatus":"CREATED"}	2025-12-09 10:08:38.619	2025-12-09 10:12:00.865
158	60282782-4987-497d-9359-cab2049f59d5	445	tochka	APPROVED	3187.50	{"breakdown":{"goods":2550,"service":637.5,"total":3187.5,"marginPercent":25,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=60282782-4987-497d-9359-cab2049f59d5","userId":323,"batchId":199,"customerPhone":"79142667582","cronUpdatedAt":"2025-11-10T02:30:00.424Z","previousStatus":"CREATED"}	2025-11-10 02:26:53.551	2025-11-10 02:30:00.424
159	a0af753a-7819-4385-901b-a34aca2306d7	446	tochka	APPROVED	2437.50	{"breakdown":{"goods":1950,"service":487.5,"total":2437.5,"marginPercent":25,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=a0af753a-7819-4385-901b-a34aca2306d7","userId":356,"batchId":199,"customerPhone":"79142330838","cronUpdatedAt":"2025-11-11T11:33:00.289Z","previousStatus":"CREATED"}	2025-11-11 11:30:59.891	2025-11-11 11:33:00.289
160	e85419e1-6226-4454-9d6c-c01500815355	447	tochka	APPROVED	6020.00	{"breakdown":{"goods":4816,"service":1204,"total":6020,"marginPercent":25,"itemsCount":3},"confirmationUrl":"https://merch.tochka.com/order/?uuid=e85419e1-6226-4454-9d6c-c01500815355","userId":361,"batchId":199,"customerPhone":"79141029766","cronUpdatedAt":"2025-11-11T11:57:00.231Z","previousStatus":"CREATED"}	2025-11-11 11:52:36.609	2025-11-11 11:57:00.231
161	bb049aaf-9b84-4741-8efd-bcfc33981aab	448	tochka	APPROVED	25157.50	{"breakdown":{"goods":20126,"service":5031.5,"total":25157.5,"marginPercent":25,"itemsCount":7},"confirmationUrl":"https://merch.tochka.com/order/?uuid=bb049aaf-9b84-4741-8efd-bcfc33981aab","userId":374,"batchId":199,"customerPhone":"79142324164","cronUpdatedAt":"2025-11-12T01:42:00.350Z","previousStatus":"CREATED"}	2025-11-12 01:36:54.853	2025-11-12 01:42:00.35
162	ab2d9f49-544c-4b09-bcfd-3843040fb457	449	tochka	APPROVED	47921.25	{"breakdown":{"goods":38337,"service":9584.25,"total":47921.25,"marginPercent":25,"itemsCount":12},"confirmationUrl":"https://merch.tochka.com/order/?uuid=ab2d9f49-544c-4b09-bcfd-3843040fb457","userId":360,"batchId":199,"customerPhone":"79141012494","cronUpdatedAt":"2025-11-12T07:15:00.411Z","previousStatus":"CREATED"}	2025-11-12 07:11:34.686	2025-11-12 07:15:00.411
167	7161168a-d64a-47c6-aa2a-92f2af42b7c9	455	tochka	APPROVED	26008.40	{"breakdown":{"goods":22616,"service":3392.4,"total":26008.39999999999,"marginPercent":15,"itemsCount":13},"confirmationUrl":"https://merch.tochka.com/order/?uuid=7161168a-d64a-47c6-aa2a-92f2af42b7c9","userId":374,"batchId":207,"customerPhone":"79142324164","cronUpdatedAt":"2025-11-24T03:27:00.254Z","previousStatus":"CREATED"}	2025-11-24 03:25:17.586	2025-11-24 03:27:00.254
168	0ec573a6-1491-47bd-9451-6c7854cf6809	456	tochka	APPROVED	6744.75	{"breakdown":{"goods":5865,"service":879.75,"total":6744.749999999999,"marginPercent":15,"itemsCount":3},"confirmationUrl":"https://merch.tochka.com/order/?uuid=0ec573a6-1491-47bd-9451-6c7854cf6809","userId":399,"batchId":207,"customerPhone":"79142247789","cronUpdatedAt":"2025-11-24T06:21:00.414Z","previousStatus":"CREATED"}	2025-11-24 06:17:29.5	2025-11-24 06:21:00.414
135	e9c4a9d6-2170-4775-889b-4c3aa8aa086e	419	tochka	APPROVED	10123.75	{"breakdown":{"goods":8099,"service":2024.75,"total":10123.75,"marginPercent":25,"itemsCount":6},"confirmationUrl":"https://merch.tochka.com/order/?uuid=e9c4a9d6-2170-4775-889b-4c3aa8aa086e","userId":323,"batchId":191,"customerPhone":"79142667582","cronUpdatedAt":"2025-10-26T23:39:00.375Z","previousStatus":"CREATED"}	2025-10-26 23:35:18.008	2025-10-26 23:39:00.375
136	5327a5b5-4ed1-4544-8f9e-b1dc8b1cd9da	420	tochka	APPROVED	4287.50	{"breakdown":{"goods":3430,"service":857.5,"total":4287.5,"marginPercent":25,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=5327a5b5-4ed1-4544-8f9e-b1dc8b1cd9da","userId":309,"batchId":191,"customerPhone":"79142347019","cronUpdatedAt":"2025-10-26T23:57:00.390Z","previousStatus":"CREATED"}	2025-10-26 23:55:00.98	2025-10-26 23:57:00.39
137	4d8d24ad-a923-457e-a046-b531eccc64b6	424	tochka	APPROVED	8262.50	{"breakdown":{"goods":6610,"service":1652.5,"total":8262.5,"marginPercent":25,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=4d8d24ad-a923-457e-a046-b531eccc64b6","userId":323,"batchId":191,"customerPhone":"79142667582","cronUpdatedAt":"2025-10-29T02:00:00.371Z","previousStatus":"CREATED"}	2025-10-29 01:56:11.005	2025-10-29 02:00:00.371
238	4cd54db7-8050-4e98-8ba3-83d2adb9a04a	536	tochka	APPROVED	2916.40	{"breakdown":{"goods":2536,"service":380.4,"total":2916.3999999999996,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=4cd54db7-8050-4e98-8ba3-83d2adb9a04a","userId":384,"batchId":246,"customerPhone":"79142960993","cronUpdatedAt":"2025-12-09T08:54:01.070Z","previousStatus":"CREATED"}	2025-12-09 08:49:40.633	2025-12-09 08:54:01.07
140	8e24a989-27a7-46f4-bee8-7ab0b10e451e	427	tochka	APPROVED	5490.00	{"breakdown":{"goods":4392,"service":1098,"total":5490,"marginPercent":25,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=8e24a989-27a7-46f4-bee8-7ab0b10e451e","userId":282,"batchId":193,"customerPhone":"79142654503","cronUpdatedAt":"2025-11-03T00:57:00.321Z","previousStatus":"CREATED"}	2025-11-03 00:51:08.356	2025-11-03 00:57:00.321
141	bcf9a55b-59d6-4ea6-83dd-c40b2692b0dd	428	tochka	APPROVED	10115.00	{"breakdown":{"goods":8092,"service":2023,"total":10115,"marginPercent":25,"itemsCount":4},"confirmationUrl":"https://merch.tochka.com/order/?uuid=bcf9a55b-59d6-4ea6-83dd-c40b2692b0dd","userId":323,"batchId":193,"customerPhone":"79142667582","cronUpdatedAt":"2025-11-03T01:09:00.296Z","previousStatus":"CREATED"}	2025-11-03 01:07:55.187	2025-11-03 01:09:00.296
143	a21d2e26-da9e-490a-ad4c-48a0ba9c8363	430	tochka	APPROVED	7623.75	{"breakdown":{"goods":6099,"service":1524.75,"total":7623.75,"marginPercent":25,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=a21d2e26-da9e-490a-ad4c-48a0ba9c8363","userId":342,"batchId":193,"customerPhone":"79841151201","cronUpdatedAt":"2025-11-04T06:33:00.576Z","previousStatus":"CREATED"}	2025-11-04 06:29:44.857	2025-11-04 06:33:00.576
252	f0eb95e0-e226-46e1-b284-ab5f2cfde912	557	tochka	CREATED	836.66	{"breakdown":{"goods":727.5333333333333,"service":109.13,"total":836.6633333333332,"marginPercent":15,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=f0eb95e0-e226-46e1-b284-ab5f2cfde912","userId":465,"batchId":246,"customerPhone":"79142805341"}	2025-12-09 10:23:18.147	\N
\.


--
-- Data for Name: product_snapshots; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.product_snapshots (id, product_id, name, unit, price, created_at) FROM stdin;
14135	22086	T	л	27.00	2025-11-09 08:13:47.904784
14136	22087	T	л	15.00	2025-11-09 08:27:53.439818
14137	22088	Тест	л	26.00	2025-11-09 09:40:02.568129
14139	99001	МАНТЫ Южные 800гр ТМ 4 сочных порции	шт	463.00	2025-11-09 09:52:38.636156
14140	99002	КОФЕ Монарх Ориджинал м/уп 200гр	шт	793.00	2025-11-09 09:52:38.636156
14141	24513	ПЛ/КОНТ Радуга Пломбир четырехслойный 1000г ТМ Чистая Линия	уп (1 шт)	1120.00	2025-11-17 06:54:27.208839
14142	24518	СЭНДВИЧ Максидуо соленая карамель 94гр ТМ Нестле  Старая цена 131р	уп (24 шт)	2640.00	2025-11-17 06:54:27.227613
14143	24562	НАРЕЗКА БЕКОН 180гр 1/10шт с/к в/у ТМ Черкизово	уп (10 шт)	3000.00	2025-11-17 06:54:27.24182
14144	24689	ПЕЧЕНЬЕ СЭНДВИЧ Bang bang вкус клубники 4кг	уп (4 шт)	1988.00	2025-11-17 06:54:27.255994
14145	24690	ПЕЧЕНЬЕ СЭНДВИЧ Сладонеж какао молоко 4кг	уп (4 шт)	1988.00	2025-11-17 06:54:27.27508
14146	24974	МАСЛО "Алтай" 0,9л подсолнечное рафинированное Высший сорт *	уп (15 шт)	1988.00	2025-11-17 06:54:27.290782
14147	24982	МАСЛО "Я Люблю готовить" 1л подсолнечное рафинированное	уп (15 шт)	2550.00	2025-11-17 06:54:27.304898
14148	24988	Сахар весовой 50кг	уп (50 шт)	4335.00	2025-11-17 06:54:27.319136
14149	25178	ЧАЙ Ява Зелёный традиционный 100пак	уп (18 шт)	3996.00	2025-11-17 06:54:27.339582
14150	25193	КАША овсяная клубника 35гр ТМ Мастер Дак	уп (30 шт)	660.00	2025-11-17 06:54:27.353337
14151	25315	ЛЕЧО по-болгарски 680гр ст/б Сыта-Загора	уп (8 шт)	1272.00	2025-11-17 06:54:27.367373
14152	25336	ЗАКУСКА Венгерская 470гр ст/б ТМ Пиканта	уп (6 шт)	1122.00	2025-11-17 06:54:27.383496
14153	25383	ФАСОЛЬ Отборная красная 425мл ж/б  ТМ Скатерть-Самобранка	уп (12 шт)	1392.00	2025-11-17 06:54:27.398904
14154	25395	ГОРОШЕК консервир 400гр ж/б  ТМ Знаток	уп (12 шт)	1164.00	2025-11-17 06:54:27.414524
14155	25403	КУКУРУЗА консервир 425мл ж/б  ТМ Знаток	уп (12 шт)	1224.00	2025-11-17 06:54:27.429996
14156	25617	СЫРОК Савушкин Творобушки малина глазированный 40гр	уп (18 шт)	828.00	2025-11-17 06:54:27.449302
14157	25618	СЫРОК Савушкин Творобушки шоколад глазированный 40гр	уп (18 шт)	828.00	2025-11-17 06:54:27.463963
14158	25679	Азу из курицы с картоф пюре 350гр ТМ Сытоедов	уп (10 шт)	2650.00	2025-11-17 06:54:27.480455
14159	25703	Лапша WOK Удон с говядиной и овощами 300гр ТМ Главобед	уп (6 шт)	2244.00	2025-11-17 06:54:27.495031
14160	25712	Паста Палермо с курицей и грибами 300гр ТМ Сытоедов	уп (8 шт)	2304.00	2025-11-17 06:54:27.513248
14161	25747	ВАРЕНИКИ Бабушка Аня 430гр картофель и лук 1/10шт ТМ Санта Бремор	уп (10 шт)	1360.00	2025-11-17 06:54:27.528154
14162	25748	ВАРЕНИКИ Бабушка Аня 430гр картофель и шкварки 1/10шт ТМ Санта Бремор	уп (10 шт)	1430.00	2025-11-17 06:54:27.545075
14163	25781	ПЕЛЬМЕНИ БУЛЬМЕНИ 400гр с говядиной и свининой  ТМ Горячая Штучка	уп (16 шт)	2112.00	2025-11-17 06:54:27.558548
14164	25795	ПЕЛЬМЕНИ Цезарь 450гр Мясо бычков	уп (12 шт)	2736.00	2025-11-17 06:54:27.57194
14165	25827	СУПОВОЙ НАБОР ИНДЕЙКА подложка (1шт~700гр) ТМ Индилайт	уп (6 шт)	1290.00	2025-11-17 06:54:27.590713
14166	25856	ФИЛЕ ОКОРОЧКА КУР без кожи без кости лоток ТМ ДОМОСЕДКА	уп (10 шт)	4850.00	2025-11-17 06:54:27.609929
14167	26008	СЕЛЬДЬ ТИХООКЕАНСКАЯ мороженая 27+ 1/13кг Тихрыбком*	уп (13 шт)	1269.00	2025-11-17 06:54:27.628067
14168	26059	КРЕВЕТКА Тигровая 1кг с/м 16/20 очищенная с хвостиком Бангладеш	уп (10 шт)	12100.00	2025-11-17 06:54:27.649719
14169	26063	КРЕВЕТКА Северная 800гр в/м 70/90 неразделанная Китай	уп (12 шт)	8640.00	2025-11-17 06:54:27.664552
14170	26099	ИКРА МОЙВЫ 165гр деликатесная с лососем ТМ Русское Море	уп (6 шт)	1056.00	2025-11-17 06:54:27.684652
14171	26347	КЛУБНИКА вес  Египет	уп (10 шт)	2800.00	2025-11-17 06:54:27.708184
14172	26356	СМЕСЬ КОМПОТНАЯ ((абрикос,яблоко,слива) вес	уп (10 шт)	2200.00	2025-11-17 06:54:27.726918
14301	38200	ВАФ СТАКАНЧИК ЮККИ Пломбир на сливках шоколадный 70гр 1/24шт ТМ Санта Бремор	уп (24 шт)	2180.00	2025-11-30 13:26:56.782578
14302	38203	РОЖОК Soletto Classico Сладкая Малина сливочное фруктовое 75гр 1/24шт ТМ Санта Бремор	уп (24 шт)	2153.00	2025-11-30 13:26:56.799748
14303	38204	РОЖОК Soletto Апельсин Юдзу молочное 75гр 1/24шт ТМ Санта Бремор	уп (24 шт)	2153.00	2025-11-30 13:26:56.815364
14304	38346	КОЛБАСА вар Папа может 400гр Докторская Премиум	уп (8 шт)	2282.00	2025-11-30 13:26:56.830188
14305	38376	НАРЕЗКА БЕКОН 180гр 1/10шт с/к в/у ТМ Черкизово	уп (10 шт)	3737.00	2025-11-30 13:26:56.84383
14306	38587	КОНФЕТЫ 1кг молочные Тоффи Мягкая карамель в шоколаде с мармеладом из клюквы ТМ Победа	уп (2 шт)	2226.00	2025-11-30 13:26:56.858474
14307	38616	КОНФЕТЫ Шантарель 500гр	уп (1 шт)	221.00	2025-11-30 13:26:56.872392
14308	38662	СЫР вес Голландский люкс 45% (1шт~1,7кг) шар ТМ Молодея Беларусь	кг	926.00	2025-11-30 13:26:56.886544
14309	38929	МУКА в/с ГОСТ вес 50кг Союзмука	уп (50 шт)	3019.00	2025-11-30 13:26:56.904009
14310	38947	МАКАРОНЫ "Мальтальяти" 450гр Рожок витой №069	уп (20 шт)	2254.00	2025-11-30 13:26:56.917714
14311	38962	МАКАРОНЫ "Шебекинские" 450гр Витой рожок №388	уп (20 шт)	1932.00	2025-11-30 13:26:56.932449
14312	39134	КАША овсяная малина 35гр ТМ Мастер Дак	уп (30 шт)	759.00	2025-11-30 13:26:56.945744
14313	39526	ЧИСТЯЩЕЕ СРЕДСТВО 600мл Грасс Азелит Спрей Антижир	уп (1 шт)	212.00	2025-11-30 13:26:56.962085
14314	39533	МОЛОКО Минская марка 3,2% 1л стеризованное тетрапак	уп (12 шт)	1684.00	2025-11-30 13:26:56.97926
14315	39331	ГОРОШЕК консервир 400гр ж/б  ТМ Знаток	уп (12 шт)	1339.00	2025-11-30 13:26:56.993163
14316	39339	КУКУРУЗА консервир 425мл ж/б  ТМ Знаток	уп (12 шт)	1408.00	2025-11-30 13:26:57.008036
14317	39444	НАПИТОК БОЧКАРИ Капибара Кислый микс 0.5л газированный пэт	уп (12 шт)	1104.00	2025-11-30 13:26:57.021501
14318	39445	НАПИТОК БОЧКАРИ Капибара Кола 0.5л газированный пэт	уп (12 шт)	1104.00	2025-11-30 13:26:57.035625
14319	39449	НАПИТОК БОЧКАРИ Капибара Персик юзу 0.5л газированный пэт	уп (12 шт)	1104.00	2025-11-30 13:26:57.05208
14320	39613	СЫРОК Савушкин ваниль глазированный 40гр	уп (18 шт)	952.00	2025-11-30 13:26:57.066468
14321	39614	СЫРОК Савушкин вареная сгущенка глазированный 40гр	уп (18 шт)	952.00	2025-11-30 13:26:57.082571
14322	39617	СЫРОК Савушкин Творобушки вареная сгущенка глазированный 40гр	уп (18 шт)	952.00	2025-11-30 13:26:57.095975
14323	39618	СЫРОК Савушкин Творобушки клубника глазированный 40гр	уп (18 шт)	952.00	2025-11-30 13:26:57.109772
14324	39619	СЫРОК Савушкин Творобушки малина глазированный 40гр	уп (18 шт)	952.00	2025-11-30 13:26:57.124428
14325	39620	СЫРОК Савушкин Творобушки манго глазированный 40гр	уп (18 шт)	952.00	2025-11-30 13:26:57.147072
14326	39621	СЫРОК Савушкин Творобушки шоколад глазированный 40гр	уп (18 шт)	952.00	2025-11-30 13:26:57.162873
14327	39627	ТВОРОГ вес 5кг 9% ТМ Заснеженная Русь	уп (5 шт)	2588.00	2025-11-30 13:26:57.177267
14328	39782	ПЕЛЬМЕНИ Большая кастрюля 750гр Классические Фирменные с говядиной и свининой	уп (10 шт)	4393.00	2025-11-30 13:26:57.19184
14329	39815	ТЕСТО 1кг слоеное бездрожжевое (пласт) ТМ Морозко	уп (8 шт)	3027.00	2025-11-30 13:26:57.206311
14330	39936	СВИНИНА ЛОПАТКА без кости без голяшки вес с/м ТМ Полянское	уп (16 шт)	7543.00	2025-11-30 13:26:57.222187
14331	39954	СВИНИНА РУЛЬКА (голяшка) передняя на кости с/м ТМ Коралл	уп (20 шт)	5369.00	2025-11-30 13:26:57.249262
14332	39958	СВИНИНА ШЕЯ вес ТМ СибАгро	уп (16 шт)	6385.00	2025-11-30 13:26:57.270256
14333	39984	САРДЕЛЬКИ Вес 10кг Мусульманские ХАЛЯЛЬ полиамид замороженные Обнинский МПК	уп (10 шт)	2588.00	2025-11-30 13:26:57.284937
14334	40006	ЯЙЦО пищевое С1  ПФ Уссурийская  ТОЛЬКО МЕСТАМИ *	уп (360 шт)	3519.00	2025-11-30 13:26:57.31575
14335	40067	КАЛЬМАР КОЛЬЦА 500гр с/м Китай	уп (20 шт)	6969.00	2025-11-30 13:26:57.357547
14336	40224	ГОРБУША тушка п/к ВЕС (в/уп)  РПЗ ТАНДЕМ	кг	531.00	2025-11-30 13:26:57.3725
14337	40370	СМЕСЬ ЛЕЧО ( перец,помидор,лку,морковь,кабачок) вес Россия	уп (10 шт)	2012.00	2025-11-30 13:26:57.38779
14338	40371	СМЕСЬ МЕКСИКАНСКАЯ (перец, морковь, фасоль, горошек, кукуруза, сельдерей, лук) вес Россия	уп (10 шт)	2128.00	2025-11-30 13:26:57.402066
14367	40769	ПРЯНИКИ Хлебный дом Классические 300гр	уп (12 шт)	1104.00	2025-12-05 04:36:01.32532
14368	40866	КОНФЕТЫ 1кг молочные Тоффи Мягкая карамель в шоколаде с мармеладом из клюквы ТМ Победа	уп (2 шт)	2226.00	2025-12-05 04:36:01.670691
14369	40870	ПЕЧЕНЬЕ 360гр Чоко Пай	уп (8 шт)	1987.00	2025-12-05 04:36:01.701439
14370	40897	РЕБРЫШКИ свиные Пикантные в/к с/м 1/6-8кг ТМ Алтайский купец	уп (7 шт)	5985.00	2025-12-05 04:36:01.716526
14371	40938	СЫР вес Ламберт голд 45% (1шт~1,7кг) шар ТМ Молодея Беларусь	кг	926.00	2025-12-05 04:36:01.73634
14372	41193	МАКАРОНЫ "Шебекинские" 450гр Перья брикет (новая упаквока) №343	уп (20 шт)	1932.00	2025-12-05 04:36:01.774738
14373	41629	ВОДА МОНАСТЫРСКАЯ 0,5л газированная пэт	уп (12 шт)	814.00	2025-12-05 04:36:01.81183
14374	41739	МОЛОКО Минская марка 3,2% 1л стеризованное тетрапак	уп (12 шт)	1684.00	2025-12-05 04:36:01.885339
14375	41741	МОЛОКО Северная долина 2,5% 950мл ультрапастеризованное 1/12шт	уп (12 шт)	1587.00	2025-12-05 04:36:01.92027
14376	42046	ОКОРОЧОК КУР Вес 15кг БРАЗИЛИЯ	уп (15 шт)	4640.00	2025-12-05 04:36:01.931624
14377	42047	ОКОРОЧОК КУР вес для жарки Халяль ТМ Благояр	уп (13 шт)	3767.00	2025-12-05 04:36:01.946378
14378	42115	СВИНИНА ШЕЯ с/м б/к вес (1кусок~1-2,5кг) ТМ Полянское	уп (15 шт)	9712.00	2025-12-05 04:36:01.983734
14379	42162	КЕТА потрошенная без головы с/м 1/22кг Вылов 2025 - *	уп (22 шт)	13662.00	2025-12-05 04:36:02.012412
14380	42175	СЕЛЬДЬ ТИХООКЕАНСКАЯ мороженая 1/20кг с/м*	уп (20 шт)	2047.00	2025-12-05 04:36:02.026016
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.products (id, "categoryId", name, description, "imageUrl", price, unit, "minQuantity", "maxQuantity", "isActive", "createdAt", "updatedAt", "basePrice", "baseUnit", "inPackage", "saleType") FROM stdin;
22088	2755	Тест	\N	\N	26.00	л	1	\N	f	2025-11-09 05:30:09.946	2025-11-09 07:32:28.015	\N	\N	\N	\N
40371	2755	СМЕСЬ МЕКСИКАНСКАЯ (перец, морковь, фасоль, горошек, кукуруза, сельдерей, лук) вес Россия	\N	\N	2128.00	уп (10 шт)	1	500	f	2025-11-23 22:32:58.394	2025-12-06 02:48:51.249	185.00	кг	10	\N
52335	3303	ДОНАТ в глазури Банан с начинкой банан 67гр в шоу боксе ТМ Bakerton,Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-07 13:19:10.752	2025-12-07 13:19:10.752	74.00	шт	36	только уп
28717	2755	ДОНАТ в глазури Банан с начинкой банан 67гр в шоу боксе ТМ Bakerton,Mirel	\N	\N	2322.00	уп (36 шт)	1	\N	f	2025-11-17 04:47:06.122	2025-11-22 01:30:48.533	\N	\N	\N	\N
28718	2755	КРЕВЕТКА Северная 800гр в/м 70/90 неразделанная Китай	\N	\N	8640.00	уп (12 шт)	1	\N	f	2025-11-17 04:48:28.532	2025-11-22 01:30:48.533	\N	\N	\N	\N
52336	3303	ДОНАТ в глазури Ваниль 58гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2153.00	уп (32 шт)	1	27	t	2025-12-07 13:19:10.766	2025-12-07 13:19:10.766	67.00	шт	32	только уп
52337	3303	ДОНАТ в глазури Ваниль 58гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-07 13:19:10.782	2025-12-07 13:19:10.782	63.00	шт	36	только уп
49688	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	уп (50 шт)	1	\N	f	2025-12-06 08:06:47.151	2025-12-06 08:15:47.733	\N	\N	\N	поштучно
52338	3303	ДОНАТ в глазури Карамель 67гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2484.00	уп (32 шт)	1	103	t	2025-12-07 13:19:10.794	2025-12-07 13:19:10.794	78.00	шт	32	только уп
52339	3303	ДОНАТ в глазури Карамель 67гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-07 13:19:10.806	2025-12-07 13:19:10.806	74.00	шт	36	только уп
51797	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	шт	1	300	f	2025-12-06 12:29:38.394	2025-12-06 12:46:48.447	169.00	шт	50	поштучно
51798	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	шт	1	300	f	2025-12-06 12:48:08.625	2025-12-06 12:48:29.599	169.00	шт	50	поштучно
52340	3303	ДОНАТ в глазури Клубника 58гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2153.00	уп (32 шт)	1	200	t	2025-12-07 13:19:10.818	2025-12-07 13:19:10.818	67.00	шт	32	только уп
51818	3310	Сало Богородское в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	2433.00	кг	1	144	f	2025-12-07 02:06:54.092	2025-12-07 02:08:18.395	811.00	кг	3	поштучно
52341	3303	ДОНАТ в глазури Клубника 58гр в шоу боксах ТМ Вakerton, Mirel	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-07 13:19:10.835	2025-12-07 13:19:10.835	63.00	шт	36	только уп
52342	3303	ДОНАТ в глазури Малиновый джем 68гр в шоу боксе ТМ Bakerton,Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-07 13:19:10.851	2025-12-07 13:19:10.851	74.00	шт	36	только уп
52343	3303	ДОНАТ в глазури Маршмеллоу 58гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	890.00	уп (12 шт)	1	72	t	2025-12-07 13:19:10.862	2025-12-07 13:19:10.862	74.00	шт	12	только уп
52344	3303	ДОНАТ в глазури черника с крем-чиз 67гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-07 13:19:10.875	2025-12-07 13:19:10.875	74.00	шт	36	только уп
52345	3303	ДОНАТ в глазури Шоколад 56гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2153.00	уп (32 шт)	1	200	t	2025-12-07 13:19:10.886	2025-12-07 13:19:10.886	67.00	шт	32	только уп
52346	3303	ДОНАТ в глазури Шоколад 56гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-07 13:19:10.897	2025-12-07 13:19:10.897	63.00	шт	36	только уп
52347	3303	ДОНАТ в глазури Шоколад с начинкой шоколад 67гр в шоу боксе ТМ Bakerton, Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-07 13:19:10.918	2025-12-07 13:19:10.918	74.00	шт	36	только уп
52348	3303	ДОНАТ в глазури Ягодный микс с начинкой вкус ягод 70гр в шоу боксе ТМ Bakerton, Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-07 13:19:10.934	2025-12-07 13:19:10.934	74.00	шт	36	только уп
52349	3303	ДОНАТ в глазури Ягодный микс с начинкой вкусягод 70гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2484.00	уп (32 шт)	1	94	t	2025-12-07 13:19:10.945	2025-12-07 13:19:10.945	78.00	шт	32	только уп
52350	3303	ПЕЧЕНЬЕ "Кукис" овсяный с изюмом и лимоном 70гр ТМ Чизберри	\N	\N	2254.00	шт	1	27	t	2025-12-07 13:19:10.957	2025-12-07 13:19:10.957	81.00	шт	28	поштучно
52351	3303	ПЕЧЕНЬЕ "Кукис" с кусочками темной глазури 70гр ТМ Чизберри	\N	\N	2254.00	шт	1	35	t	2025-12-07 13:19:10.968	2025-12-07 13:19:10.968	81.00	шт	28	поштучно
52352	3303	ПИРОЖНОЕ Бисквитно-сливочное 375гр (1уп-5шт) набор ТМ Татьянин Двор	\N	\N	4830.00	шт	1	188	t	2025-12-07 13:19:10.983	2025-12-07 13:19:10.983	402.00	шт	12	поштучно
52353	3303	ПИРОЖНОЕ Блаженство 375гр (1уп-5шт) набор ТМ Татьянин Двор	\N	\N	4802.00	шт	1	189	t	2025-12-07 13:19:10.995	2025-12-07 13:19:10.995	400.00	шт	12	поштучно
52354	3303	ПИРОЖНОЕ Колечки с творогом 300гр ТМ Mirel	\N	\N	2077.00	шт	1	200	t	2025-12-07 13:19:11.008	2025-12-07 13:19:11.008	346.00	шт	6	поштучно
52355	3303	ПИРОЖНОЕ Корзиночки (цыпленок,с белк кремом, грибочки) 300гр (1уп-6шт) набор ТМ Татьянин Двор	\N	\N	2532.00	шт	1	94	t	2025-12-07 13:19:11.019	2025-12-07 13:19:11.019	422.00	шт	6	поштучно
52356	3303	ПИРОЖНОЕ Корзиночки (шоколадно-вишневая) 300гр (1уп-6шт) набор 1/6шт ТМ Татьянин Двор	\N	\N	2318.00	шт	1	171	t	2025-12-07 13:19:11.031	2025-12-07 13:19:11.031	386.00	шт	6	поштучно
52357	3303	ПИРОЖНОЕ Корзиночки №2 (пломбир/кофейное мороженое) 300гр (1уп-6шт) набор ТМ Татьянин Двор	\N	\N	2284.00	шт	1	200	t	2025-12-07 13:19:11.045	2025-12-07 13:19:11.045	381.00	шт	6	поштучно
52358	3303	ПИРОЖНОЕ Корзиночки №4 (пломбир/клубн морож) 300гр (1уп-6шт) набор 1/6шт ТМ Татьянин Двор	\N	\N	2318.00	шт	1	131	t	2025-12-07 13:19:11.057	2025-12-07 13:19:11.057	386.00	шт	6	поштучно
52359	3303	ПИРОЖНОЕ Корзиночки ягодки (еживика/клубника/малина) 300гр (1уп-6шт) набор ТМ Татьянин Двор	\N	\N	2532.00	шт	1	78	t	2025-12-07 13:19:11.077	2025-12-07 13:19:11.077	422.00	шт	6	поштучно
52360	3303	ПИРОЖНОЕ Маффин с шоколадом 80гр ТМ Русская Нива	\N	\N	1587.00	шт	1	183	t	2025-12-07 13:19:11.098	2025-12-07 13:19:11.098	79.00	шт	20	поштучно
52361	3303	ПИРОЖНОЕ Муравейник 340гр ТМ Mirel	\N	\N	6428.00	шт	1	200	t	2025-12-07 13:19:11.11	2025-12-07 13:19:11.11	321.00	шт	20	поштучно
52362	3303	ПИРОЖНОЕ Парфе 375гр (1уп-5шт) набор ТМ Татьянин Двор	\N	\N	4954.00	шт	1	107	t	2025-12-07 13:19:11.13	2025-12-07 13:19:11.13	413.00	шт	12	поштучно
51802	3314	СЫР вес Сметанковый 45% (1шт~5 кг) брус ТМ Радость вкуса*	\N	\N	12675.00	уп (15 шт)	1	\N	f	2025-12-06 13:05:52.876	2025-12-06 13:06:19.625	\N	\N	\N	поштучно
52363	3303	ПИРОЖНОЕ Прага 400гр (1уп-5шт) набор ТМ Татьянин Двор	\N	\N	4954.00	шт	1	200	t	2025-12-07 13:19:11.141	2025-12-07 13:19:11.141	413.00	шт	12	поштучно
52364	3303	ПИРОЖНОЕ Профитроли с кремом Пломбирный 180гр ТМ Mirel	\N	\N	4026.00	шт	1	200	t	2025-12-07 13:19:11.161	2025-12-07 13:19:11.161	224.00	шт	18	поштучно
52365	3303	ПИРОЖНОЕ Тарты по-французски с заварным кремом 280гр ТМ Mirel	\N	\N	2797.00	шт	1	200	t	2025-12-07 13:19:11.172	2025-12-07 13:19:11.172	350.00	шт	8	поштучно
52366	3303	ПИРОЖНОЕ Тирамису 280гр ТМ Mirel	\N	\N	7302.00	шт	1	200	t	2025-12-07 13:19:11.185	2025-12-07 13:19:11.185	292.00	шт	25	поштучно
51807	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	уп (50 шт)	1	\N	f	2025-12-06 13:08:07.435	2025-12-07 01:04:10.972	\N	\N	\N	поштучно
52367	3303	ПИРОЖНОЕ Эклеры клубничные со сливочно-заварным кремом 235гр ТМ Mirel	\N	\N	2447.00	шт	1	200	t	2025-12-07 13:19:11.197	2025-12-07 13:19:11.197	306.00	шт	8	поштучно
52368	3303	ПИРОЖНОЕ Эклеры с белковым кремом 160гр (1уп-5шт) набор ТМ Mirel	\N	\N	2162.00	шт	1	200	t	2025-12-07 13:19:11.208	2025-12-07 13:19:11.208	216.00	шт	10	поштучно
52369	3303	ПИРОЖНОЕ Эклеры с заварным кремом 250гр ТМ Mirel	\N	\N	2950.00	шт	1	200	t	2025-12-07 13:19:11.218	2025-12-07 13:19:11.218	295.00	шт	10	поштучно
52370	3303	ПИРОЖНОЕ Эклеры с классическим заварным кремом  250гр ТМ Mirel	\N	\N	2760.00	шт	1	200	t	2025-12-07 13:19:11.235	2025-12-07 13:19:11.235	276.00	шт	10	поштучно
52371	3303	ПИРОЖНОЕ Эклеры с крем брюле 160гр ТМ Mirel	\N	\N	2628.00	шт	1	200	t	2025-12-07 13:19:11.267	2025-12-07 13:19:11.267	263.00	шт	10	поштучно
52372	3303	ПИРОЖНОЕ Эклеры с шоколад заварным кремом и соленой карамелью 235гр ТМ Mirel	\N	\N	2433.00	шт	1	200	t	2025-12-07 13:19:11.278	2025-12-07 13:19:11.278	304.00	шт	8	поштучно
52373	3303	ПИРОЖНОЕ Эклеры фисташковый крем и малина 235гр (1уп-5шт) набор ТМ Mirel	\N	\N	2742.00	шт	1	135	t	2025-12-07 13:19:11.312	2025-12-07 13:19:11.312	343.00	шт	8	поштучно
52374	3303	РУЛЕТ Сдобный Абрикос 140гр	\N	\N	690.00	шт	1	108	t	2025-12-07 13:19:11.346	2025-12-07 13:19:11.346	115.00	шт	6	поштучно
52375	3303	РУЛЕТ Сдобный Вишня 140гр	\N	\N	690.00	шт	1	198	t	2025-12-07 13:19:11.371	2025-12-07 13:19:11.371	115.00	шт	6	поштучно
52376	3303	РУЛЕТ Сдобный Лимон 140гр	\N	\N	690.00	шт	1	200	t	2025-12-07 13:19:11.388	2025-12-07 13:19:11.388	115.00	шт	6	поштучно
52377	3303	ТОРТ Ассоль 850гр ТМ Татьянин Двор	\N	\N	4913.00	шт	1	152	t	2025-12-07 13:19:11.4	2025-12-07 13:19:11.4	819.00	шт	6	поштучно
52378	3303	ТОРТ Бельгийский шоколад 750гр ТМ Mirel	\N	\N	6186.00	шт	1	200	t	2025-12-07 13:19:11.412	2025-12-07 13:19:11.412	1031.00	шт	6	поштучно
52379	3303	ТОРТ Венский лес 850гр ТМ Татьянин Двор	\N	\N	5078.00	шт	1	200	t	2025-12-07 13:19:11.435	2025-12-07 13:19:11.435	846.00	шт	6	поштучно
52380	3303	ТОРТ Вишневый 640гр ТМ Мой	\N	\N	3398.00	шт	1	200	t	2025-12-07 13:19:11.446	2025-12-07 13:19:11.446	566.00	шт	6	поштучно
52381	3303	ТОРТ Джулия 800гр ТМ Татьянин Двор	\N	\N	4789.00	шт	1	138	t	2025-12-07 13:19:11.456	2025-12-07 13:19:11.456	798.00	шт	6	поштучно
52382	3303	ТОРТ Желание 625гр ТМ Фантэль нарезной	\N	\N	4043.00	шт	1	153	t	2025-12-07 13:19:11.467	2025-12-07 13:19:11.467	674.00	шт	6	поштучно
52383	3303	ТОРТ Йогурт/кокос/абрикос 600гр ТМ Татьянин Двор	\N	\N	5621.00	шт	1	49	t	2025-12-07 13:19:11.477	2025-12-07 13:19:11.477	703.00	шт	8	поштучно
52384	3303	ТОРТ Йогуртовый с клубникой  650гр ТМ Фантэль	\N	\N	4023.00	шт	1	37	t	2025-12-07 13:19:11.49	2025-12-07 13:19:11.49	670.00	шт	6	поштучно
52385	3303	ТОРТ Казанова шоколадный 800гр ТМ Татьянин Двор	\N	\N	5210.00	шт	1	66	t	2025-12-07 13:19:11.5	2025-12-07 13:19:11.5	868.00	шт	6	поштучно
52386	3303	ТОРТ Карамельный на сгущенке 700гр ТМ Mirel	\N	\N	3826.00	шт	1	200	t	2025-12-07 13:19:11.511	2025-12-07 13:19:11.511	638.00	шт	6	поштучно
52387	3303	ТОРТ Киви-Клубника 650гр ТМ Мой	\N	\N	3398.00	шт	1	200	t	2025-12-07 13:19:11.556	2025-12-07 13:19:11.556	566.00	шт	6	поштучно
52388	3303	ТОРТ Киевский 800гр ТМ Фантэль	\N	\N	6162.00	шт	1	61	t	2025-12-07 13:19:11.578	2025-12-07 13:19:11.578	1027.00	шт	6	поштучно
52389	3303	ТОРТ Клубничные облака 500гр ТМ Татьянин Двор	\N	\N	3864.00	шт	1	194	t	2025-12-07 13:19:11.592	2025-12-07 13:19:11.592	483.00	шт	8	поштучно
52390	3303	ТОРТ Клубничный Милкшейк 650гр ТМ Mirel	\N	\N	4116.00	шт	1	200	t	2025-12-07 13:19:11.607	2025-12-07 13:19:11.607	686.00	шт	6	поштучно
52391	3303	ТОРТ Крем-Брюле 650гр ТМ Mirel	\N	\N	3678.00	шт	1	200	t	2025-12-07 13:19:11.625	2025-12-07 13:19:11.625	613.00	шт	6	поштучно
52392	3303	ТОРТ Латте Макиато 650гр ТМ Mirel	\N	\N	4116.00	шт	1	200	t	2025-12-07 13:19:11.652	2025-12-07 13:19:11.652	686.00	шт	6	поштучно
52393	3303	ТОРТ Медово/сметанный 850гр ТМ Татьянин Двор	\N	\N	5244.00	шт	1	85	t	2025-12-07 13:19:11.672	2025-12-07 13:19:11.672	874.00	шт	6	поштучно
52394	3303	ТОРТ Медовый с вареной сгущенкой 250гр ТМ Mirel	\N	\N	12492.00	шт	1	91	t	2025-12-07 13:19:11.714	2025-12-07 13:19:11.714	500.00	шт	25	поштучно
52395	3303	ТОРТ Министерский 1кг ТМ Фантэль	\N	\N	5444.00	шт	1	20	t	2025-12-07 13:19:11.733	2025-12-07 13:19:11.733	907.00	шт	6	поштучно
52396	3303	ТОРТ Наполеон Классический 550гр ТМ Mirel	\N	\N	3705.00	шт	1	200	t	2025-12-07 13:19:11.744	2025-12-07 13:19:11.744	618.00	шт	6	поштучно
52397	3303	ТОРТ Орфей 650гр ТМ Mirel	\N	\N	5296.00	шт	1	98	t	2025-12-07 13:19:11.754	2025-12-07 13:19:11.754	883.00	шт	6	поштучно
52398	3303	ТОРТ Персик/Малина 700гр ТМ Mirel	\N	\N	4112.00	шт	1	77	t	2025-12-07 13:19:11.773	2025-12-07 13:19:11.773	685.00	шт	6	поштучно
52399	3303	ТОРТ Персик/Маракуйя  650гр ТМ Мой	\N	\N	3398.00	шт	1	200	t	2025-12-07 13:19:11.783	2025-12-07 13:19:11.783	566.00	шт	6	поштучно
52400	3303	ТОРТ Пикник 550гр ТМ Татьянин Двор	\N	\N	5879.00	шт	1	80	t	2025-12-07 13:19:11.794	2025-12-07 13:19:11.794	735.00	шт	8	поштучно
52401	3303	ТОРТ Пломбирный 750гр ТМ Mirel	\N	\N	4216.00	шт	1	200	t	2025-12-07 13:19:11.804	2025-12-07 13:19:11.804	703.00	шт	6	поштучно
52402	3303	ТОРТ Прага 650гр ТМ Фантэль	\N	\N	4023.00	шт	1	8	t	2025-12-07 13:19:11.815	2025-12-07 13:19:11.815	670.00	шт	6	поштучно
52403	3303	ТОРТ Прага 660гр ТМ Mirel	\N	\N	4281.00	шт	1	200	t	2025-12-07 13:19:11.829	2025-12-07 13:19:11.829	714.00	шт	6	поштучно
52404	3303	ТОРТ Прага 850гр ТМ Татьянин Двор	\N	\N	5203.00	шт	1	10	t	2025-12-07 13:19:11.84	2025-12-07 13:19:11.84	867.00	шт	6	поштучно
52405	3303	ТОРТ Пражский 800гр ТМ Татьянин Двор	\N	\N	4844.00	шт	1	56	t	2025-12-07 13:19:11.852	2025-12-07 13:19:11.852	807.00	шт	6	поштучно
52406	3303	ТОРТ Пралине 550гр ТМ Mirel	\N	\N	5147.00	шт	1	200	t	2025-12-07 13:19:11.864	2025-12-07 13:19:11.864	858.00	шт	6	поштучно
52407	3303	ТОРТ Пчелка 750гр ТМ Фантэль АКЦИЯ - 25% старая цена 599р	\N	\N	4133.00	шт	1	38	t	2025-12-07 13:19:11.875	2025-12-07 13:19:11.875	689.00	шт	6	поштучно
52408	3303	ТОРТ Русская ягода 680гр ТМ Mirel	\N	\N	4116.00	шт	1	200	t	2025-12-07 13:19:11.89	2025-12-07 13:19:11.89	686.00	шт	6	поштучно
52409	3303	ТОРТ Сказка Любимая 440гр ТМ Mirel	\N	\N	4952.00	шт	1	200	t	2025-12-07 13:19:11.901	2025-12-07 13:19:11.901	550.00	шт	9	поштучно
52410	3303	ТОРТ Сливочная карамель 650гр ТМ Mirel	\N	\N	3398.00	шт	1	200	t	2025-12-07 13:19:11.932	2025-12-07 13:19:11.932	566.00	шт	6	поштучно
52411	3303	ТОРТ Сметанник малиновый 650гр ТМ Mirel	\N	\N	4233.00	шт	1	200	t	2025-12-07 13:19:11.974	2025-12-07 13:19:11.974	706.00	шт	6	поштучно
52412	3303	ТОРТ Сметанный 650гр ТМ Мой	\N	\N	3398.00	шт	1	200	t	2025-12-07 13:19:11.999	2025-12-07 13:19:11.999	566.00	шт	6	поштучно
52413	3303	ТОРТ Сметанофф классический 650гр ТМ Фантэль	\N	\N	4023.00	шт	1	41	t	2025-12-07 13:19:12.01	2025-12-07 13:19:12.01	670.00	шт	6	поштучно
52414	3303	ТОРТ Сметанчо 800гр ТМ Mirel	\N	\N	5472.00	шт	1	200	t	2025-12-07 13:19:12.028	2025-12-07 13:19:12.028	912.00	шт	6	поштучно
52415	3303	ТОРТ Сметанчо 850гр ТМ Татьянин Двор	\N	\N	5016.00	шт	1	66	t	2025-12-07 13:19:12.042	2025-12-07 13:19:12.042	836.00	шт	6	поштучно
52416	3303	ТОРТ Старая Прага 600гр ТМ Татьянин Двор	\N	\N	5060.00	шт	1	138	t	2025-12-07 13:19:12.052	2025-12-07 13:19:12.052	633.00	шт	8	поштучно
52417	3303	ТОРТ Творожно/йогуртовый 800гр ТМ Татьянин Двор	\N	\N	5016.00	шт	1	46	t	2025-12-07 13:19:12.063	2025-12-07 13:19:12.063	836.00	шт	6	поштучно
52418	3303	ТОРТ Творожный 800гр ТМ Татьянин Двор	\N	\N	5617.00	шт	1	62	t	2025-12-07 13:19:12.08	2025-12-07 13:19:12.08	936.00	шт	6	поштучно
52419	3303	ТОРТ Тирамису 750гр ТМ Mirel	\N	\N	4309.00	шт	1	200	t	2025-12-07 13:19:12.09	2025-12-07 13:19:12.09	718.00	шт	6	поштучно
52420	3303	ТОРТ Тирамису 800гр ТМ Татьянин Двор	\N	\N	4899.00	шт	1	57	t	2025-12-07 13:19:12.101	2025-12-07 13:19:12.101	816.00	шт	6	поштучно
52421	3303	ТОРТ Три шоколада 750гр ТМ Mirel	\N	\N	6338.00	шт	1	25	t	2025-12-07 13:19:12.117	2025-12-07 13:19:12.117	1056.00	шт	6	поштучно
52422	3303	ТОРТ Черничное молоко 750гр ТМ Mirel	\N	\N	4368.00	шт	1	200	t	2025-12-07 13:19:12.144	2025-12-07 13:19:12.144	728.00	шт	6	поштучно
52423	3303	ТОРТ Черный лес 720гр ТМ Mirel	\N	\N	5517.00	шт	1	185	t	2025-12-07 13:19:12.157	2025-12-07 13:19:12.157	919.00	шт	6	поштучно
52424	3303	ТОРТ Чизкейк Шоколадный 700гр ТМ Чизберри	\N	\N	3827.00	шт	1	6	t	2025-12-07 13:19:12.168	2025-12-07 13:19:12.168	957.00	шт	4	поштучно
52425	3303	ТОРТ Шоколадный брауни 600гр ТМ ПБК	\N	\N	4057.00	шт	1	39	t	2025-12-07 13:19:12.182	2025-12-07 13:19:12.182	676.00	шт	6	поштучно
52426	3303	ТОРТ Шоколадный пломбир 700гр ТМ Mirel	\N	\N	4368.00	шт	1	153	t	2025-12-07 13:19:12.193	2025-12-07 13:19:12.193	728.00	шт	6	поштучно
52427	3303	ТОРТ Шоколадный с апельсином 700гр ТМ Mirel	\N	\N	6058.00	шт	1	200	t	2025-12-07 13:19:12.204	2025-12-07 13:19:12.204	1010.00	шт	6	поштучно
52428	3303	ТОРТ Шоколадный тоффи 580гр ТМ Mirel	\N	\N	4119.00	шт	1	13	t	2025-12-07 13:19:12.215	2025-12-07 13:19:12.215	687.00	шт	6	поштучно
52429	3303	ТОРТ Шоколетто 850гр ТМ Татьянин Двор	\N	\N	5003.00	шт	1	55	t	2025-12-07 13:19:12.225	2025-12-07 13:19:12.225	834.00	шт	6	поштучно
52430	3303	ТОРТ Эстерхази 650гр ТМ Mirel	\N	\N	7631.00	шт	1	200	t	2025-12-07 13:19:12.237	2025-12-07 13:19:12.237	1272.00	шт	6	поштучно
52431	3392	ВАФ СТАКАНЧИК ЮККИ Пломбир на сливках шоколадный 70гр 1/24шт ТМ Санта Бремор	\N	\N	2180.00	уп (24 шт)	1	96	t	2025-12-07 13:19:12.248	2025-12-07 13:19:12.248	91.00	шт	24	только уп
52432	3392	КАРТОННЫЙ СТАКАНЧИК БРЕСТ-ЛИТОВСК ваниль 220гр 1/12шт ТМ Санта Бремор	\N	\N	3381.00	уп (12 шт)	1	100	t	2025-12-07 13:19:12.262	2025-12-07 13:19:12.262	282.00	шт	12	только уп
52433	3392	РОЖОК Soletto Classico Гранат Лимон 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	72	t	2025-12-07 13:19:12.282	2025-12-07 13:19:12.282	90.00	шт	24	только уп
52434	3392	РОЖОК Soletto Classico Сладкая Малина сливочное фруктовое 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	24	t	2025-12-07 13:19:12.306	2025-12-07 13:19:12.306	90.00	шт	24	только уп
52435	3392	РОЖОК Soletto Апельсин Юдзу молочное 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	72	t	2025-12-07 13:19:12.317	2025-12-07 13:19:12.317	90.00	шт	24	только уп
52436	3392	РОЖОК Soletto Лаванда Черника 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	24	t	2025-12-07 13:19:12.375	2025-12-07 13:19:12.375	90.00	шт	24	только уп
52437	3392	ЭСКИМО Soletto Черника 75гр 1/24шт ТМ Санта Бремор	\N	\N	3340.00	уп (24 шт)	1	100	t	2025-12-07 13:19:12.434	2025-12-07 13:19:12.434	139.00	шт	24	только уп
52438	3392	ЭСКИМО БРЕСТ-ЛИТОВСК ваниль в глазури 70гр ТМ Санта Бремор	\N	\N	3496.00	уп (32 шт)	1	100	t	2025-12-07 13:19:12.445	2025-12-07 13:19:12.445	109.00	шт	32	только уп
54046	3356	ПЕЛЬМЕНИ Большая кастрюля 800гр Сочные	\N	\N	7259.00	шт	1	300	t	2025-12-07 13:19:41.15	2025-12-07 13:19:41.15	605.00	шт	12	поштучно
51809	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	шт	1	\N	f	2025-12-07 01:05:38.491	2025-12-07 01:05:52.784	\N	\N	\N	поштучно
51810	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	шт	1	300	f	2025-12-07 01:06:12.601	2025-12-07 01:06:55.155	169.00	шт	50	поштучно
52439	3392	ЭСКИМО ДУБАЙ фисташково кунжутная глазурь с кусочками теста Катаифи 60гр ТМ Санта Бремор	\N	\N	3105.00	уп (36 шт)	1	100	t	2025-12-07 13:19:12.475	2025-12-07 13:19:12.475	86.00	шт	36	только уп
52440	3392	ЭСКИМО ЮККИ КОРОВКА слив крем-брюле в карам глазури с ваф сушкой 65гр 1/24шт ТМ Санта Бремор	\N	\N	2484.00	уп (24 шт)	1	100	t	2025-12-07 13:19:12.487	2025-12-07 13:19:12.487	103.00	шт	24	только уп
51814	3310	Сало Домашнее в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	3288.00	кг	1	221	f	2025-12-07 01:20:59.31	2025-12-07 01:21:53.747	822.00	кг	4	поштучно
51815	3310	Сало Домашнее в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	250.00	шт	1	221	f	2025-12-07 01:23:20.458	2025-12-07 01:29:18.101	250.00	шт	4	поштучно
51816	3310	Сало Домашнее в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	250.00	шт	1	221	f	2025-12-07 01:29:40.39	2025-12-07 01:39:50.008	250.00	шт	4	поштучно
51813	3310	САЛО свинина фас вар Сало Народное с/м в/уп (1шт ~ 0,3кг) ТМ БАРС	\N	\N	8976.00	уп (11 шт)	1	100	f	2025-12-07 01:18:10.37	2025-12-07 02:06:06.471	816.00	кг	11	только уп
52441	3392	ВАФ СТАКАНЧИК Пломбир ваниль/варёная сгущенка 15% 70гр ТМ Село Зелёное	\N	\N	2125.00	уп (24 шт)	1	200	t	2025-12-07 13:19:12.532	2025-12-07 13:19:12.532	89.00	шт	24	только уп
52442	3392	ВАФ СТАКАНЧИК Пломбир ванильный 15% на сливках  промо-пак (2+1 в подарок по цене 2х)  1/10шт  ТМ Село Зелёное	\N	\N	2024.00	уп (10 шт)	1	200	t	2025-12-07 13:19:12.55	2025-12-07 13:19:12.55	202.00	шт	10	только уп
52443	3392	ВАФ СТАКАНЧИК Пломбир ванильный 15% на сливках 90гр ТМ Село Зелёное	\N	\N	2429.00	уп (24 шт)	1	200	t	2025-12-07 13:19:12.573	2025-12-07 13:19:12.573	101.00	шт	24	только уп
52444	3392	ВАФ СТАКАНЧИК Пломбир земляника 15% 70гр ТМ Село Зелёное	\N	\N	1794.00	уп (24 шт)	1	200	t	2025-12-07 13:19:12.601	2025-12-07 13:19:12.601	75.00	шт	24	только уп
52445	3392	ВАФ СТАКАНЧИК Пломбир крем-брюле 15% 90гр ТМ Село Зелёное	\N	\N	2429.00	уп (24 шт)	1	200	t	2025-12-07 13:19:12.618	2025-12-07 13:19:12.618	101.00	шт	24	только уп
52446	3392	ВАФ СТАКАНЧИК Пломбир малина 15% 70гр ТМ Село Зелёное	\N	\N	2208.00	уп (24 шт)	1	200	t	2025-12-07 13:19:12.634	2025-12-07 13:19:12.634	92.00	шт	24	только уп
52447	3392	ВАФ СТАКАНЧИК Пломбир фисташковый 15% 70гр ТМ Село Зелёное	\N	\N	2870.00	уп (24 шт)	1	200	t	2025-12-07 13:19:12.646	2025-12-07 13:19:12.646	120.00	шт	24	только уп
52448	3392	ВАФ СТАКАНЧИК Пломбир черника 15% 70гр ТМ Село Зелёное	\N	\N	2180.00	уп (24 шт)	1	200	t	2025-12-07 13:19:12.67	2025-12-07 13:19:12.67	91.00	шт	24	только уп
52449	3392	ВАФ СТАКАНЧИК Пломбир шоколадный 15% на сливках 90гр ТМ Село Зелёное	\N	\N	2429.00	уп (24 шт)	1	200	t	2025-12-07 13:19:12.687	2025-12-07 13:19:12.687	101.00	шт	24	только уп
52450	3392	РОЖОК Пломбир ванильный 15% на сливках 110гр ТМ Село Зелёное	\N	\N	2953.00	уп (24 шт)	1	200	t	2025-12-07 13:19:12.704	2025-12-07 13:19:12.704	123.00	шт	24	только уп
52451	3392	ЭСКИМО Пломбир Ваниль-Вишня-Шоколад 15% на сливках 80гр ТМ Село Зелёное	\N	\N	4515.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.721	2025-12-07 13:19:12.721	174.00	шт	26	только уп
52452	3392	ЭСКИМО Пломбир ванильный без глазури 15% на сливках 70гр ТМ Село Зелёное	\N	\N	2452.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.731	2025-12-07 13:19:12.731	94.00	шт	26	только уп
52453	3392	ЭСКИМО Пломбир ванильный в молочном шоколаде 15% на сливках 80гр ТМ Село Зелёное	\N	\N	4575.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.747	2025-12-07 13:19:12.747	176.00	шт	26	только уп
52454	3392	ЭСКИМО Пломбир Ванильный в молочном шоколаде с миндалем 15% 80гр ТМ Село Зелёное	\N	\N	4814.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.759	2025-12-07 13:19:12.759	185.00	шт	26	только уп
52455	3392	ЭСКИМО Пломбир грецкий орех/кленовый сироп 15% 80гр ТМ Село Зелёное	\N	\N	3169.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.769	2025-12-07 13:19:12.769	122.00	шт	26	только уп
52456	3392	ЭСКИМО Пломбир Клубника во фруктовой глазури 15% 70гр ТМ Село Зелёное	\N	\N	2751.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.781	2025-12-07 13:19:12.781	106.00	шт	26	только уп
52457	3392	ЭСКИМО Пломбир Клюква во фруктовой глазури 15% 70гр ТМ Село Зелёное	\N	\N	2751.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.792	2025-12-07 13:19:12.792	106.00	шт	26	только уп
52458	3392	ЭСКИМО Пломбир крем-брюле в карамельной глазури 15% 80гр ТМ Село Зелёное	\N	\N	3169.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.823	2025-12-07 13:19:12.823	122.00	шт	26	только уп
52459	3392	ЭСКИМО Пломбир малина в молочном шоколаде 15% 80гр ТМ Село Зелёное	\N	\N	4605.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.836	2025-12-07 13:19:12.836	177.00	шт	26	только уп
52460	3392	ЭСКИМО Пломбир Персик во фруктовой глазури 15% 70гр ТМ Село Зелёное	\N	\N	2781.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.847	2025-12-07 13:19:12.847	107.00	шт	26	только уп
52461	3392	ЭСКИМО Пломбир шоколад шоколадный топпинг фундук 15% 80гр ТМ Село Зелёное	\N	\N	3169.00	уп (26 шт)	1	200	t	2025-12-07 13:19:12.857	2025-12-07 13:19:12.857	122.00	шт	26	только уп
52462	3392	ФРУКТОВЫЙ ЛЁД Вишня 50гр ТМ Село Зеленое	\N	\N	2981.00	уп (36 шт)	1	144	t	2025-12-07 13:19:12.868	2025-12-07 13:19:12.868	83.00	шт	36	только уп
52463	3392	ФРУКТОВЫЙ ЛЁД Клубника 50гр ТМ Село Зеленое	\N	\N	2981.00	уп (36 шт)	1	200	t	2025-12-07 13:19:12.88	2025-12-07 13:19:12.88	83.00	шт	36	только уп
52464	3392	ФРУКТОВЫЙ ЛЁД Малина 50гр ТМ Село Зеленое	\N	\N	2981.00	уп (36 шт)	1	144	t	2025-12-07 13:19:12.899	2025-12-07 13:19:12.899	83.00	шт	36	только уп
52465	3392	БРИКЕТ Пломбир ванильный 15% на сливках 200гр ТМ Село Зелёное	\N	\N	3478.00	уп (16 шт)	1	200	t	2025-12-07 13:19:12.91	2025-12-07 13:19:12.91	217.00	шт	16	только уп
52466	3392	БРИКЕТ Пломбир крем-брюле 15% 200гр ТМ Село Зелёное	\N	\N	3478.00	уп (16 шт)	1	200	t	2025-12-07 13:19:12.931	2025-12-07 13:19:12.931	217.00	шт	16	только уп
52467	3392	БРИКЕТ Пломбир шоколадный 15% на сливках 200гр ТМ Село Зелёное	\N	\N	3478.00	уп (16 шт)	1	200	t	2025-12-07 13:19:12.947	2025-12-07 13:19:12.947	217.00	шт	16	только уп
52468	3392	ПАКЕТ Пломбир ванильный 15% 850гр ТМ Село Зелёное	\N	\N	2346.00	шт	1	200	t	2025-12-07 13:19:12.958	2025-12-07 13:19:12.958	587.00	шт	4	поштучно
52469	3392	ПАКЕТ Пломбир ванильный с шоколадной крошкой 15% 400гр ТМ Село Зелёное	\N	\N	2415.00	шт	1	200	t	2025-12-07 13:19:12.968	2025-12-07 13:19:12.968	402.00	шт	6	поштучно
52470	3392	ПЛ/КОНТЕЙНЕР Мороженое ванильное 10% 2кг ТМ УКХ	\N	\N	2318.00	шт	1	200	t	2025-12-07 13:19:12.99	2025-12-07 13:19:12.99	1159.00	шт	2	поштучно
52471	3392	ПЛ/КОНТЕЙНЕР Пломбир ваниль/клубника/карамельный сироп и миндаль 15% 450гр ТМ Село Зелёное	\N	\N	3133.00	шт	1	200	t	2025-12-07 13:19:13.014	2025-12-07 13:19:13.014	522.00	шт	6	поштучно
52472	3392	ПЛ/КОНТЕЙНЕР Пломбир ванильный 15% 280гр ТМ Село Зелёное	\N	\N	2125.00	шт	1	200	t	2025-12-07 13:19:13.027	2025-12-07 13:19:13.027	354.00	шт	6	поштучно
52473	3392	ПЛ/КОНТЕЙНЕР Пломбир Ванильный брусника можжевел 200гр ТМ Село Зелёное	\N	\N	1884.00	шт	1	136	t	2025-12-07 13:19:13.038	2025-12-07 13:19:13.038	314.00	шт	6	поштучно
52474	3392	ПЛ/КОНТЕЙНЕР Пломбир Ванильный Черника-малина 200гр ТМ Село Зелёное	\N	\N	1884.00	шт	1	68	t	2025-12-07 13:19:13.049	2025-12-07 13:19:13.049	314.00	шт	6	поштучно
52475	3392	ПЛ/КОНТЕЙНЕР Пломбир грецкий орех/кленовый сироп 15% 450гр ТМ Село Зелёное	\N	\N	3298.00	шт	1	200	t	2025-12-07 13:19:13.061	2025-12-07 13:19:13.061	550.00	шт	6	поштучно
52476	3392	ПЛ/КОНТЕЙНЕР Пломбир малина/шоколадный топпинг 15% 450гр ТМ Село Зелёное	\N	\N	3133.00	шт	1	200	t	2025-12-07 13:19:13.071	2025-12-07 13:19:13.071	522.00	шт	6	поштучно
52477	3392	ПЛ/КОНТЕЙНЕР Пломбир фисташковый 15% 200гр ТМ Село Зелёное	\N	\N	2298.00	шт	1	162	t	2025-12-07 13:19:13.08	2025-12-07 13:19:13.08	383.00	шт	6	поштучно
52478	3392	ПЛ/КОНТЕЙНЕР Пломбир шоколадный 12% 2кг ТМ УКХ	\N	\N	2760.00	шт	1	91	t	2025-12-07 13:19:13.114	2025-12-07 13:19:13.114	1380.00	шт	2	поштучно
52479	3392	ПЛ/КОНТЕЙНЕР Пломбир шоколадный 15% 280гр ТМ Село Зелёное	\N	\N	2125.00	шт	1	200	t	2025-12-07 13:19:13.128	2025-12-07 13:19:13.128	354.00	шт	6	поштучно
52480	3392	ПЛ/КОНТЕЙНЕР Сорбет малина 280гр ТМ Село Зелёное	\N	\N	2049.00	шт	1	200	t	2025-12-07 13:19:13.138	2025-12-07 13:19:13.138	342.00	шт	6	поштучно
52481	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Апельсин с облепиховым жмыхом  50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.15	2025-12-07 13:19:13.15	140.00	шт	30	только уп
52482	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Барбарис с соком вишни и кусочками яблок 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.167	2025-12-07 13:19:13.167	140.00	шт	30	только уп
52483	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Малина брусника чабрец 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.18	2025-12-07 13:19:13.18	140.00	шт	30	только уп
52484	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Манго маракуйя и кусочками апельсина 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	139	t	2025-12-07 13:19:13.191	2025-12-07 13:19:13.191	140.00	шт	30	только уп
52485	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Облепиха с корицей и яблоком 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.203	2025-12-07 13:19:13.203	140.00	шт	30	только уп
52486	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Облепиха с розмарином 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	190	t	2025-12-07 13:19:13.218	2025-12-07 13:19:13.218	140.00	шт	30	только уп
52487	3392	ВАФ СТАКАНЧИК Десерт на кокосовой основе ванильный без сахарозы (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2731.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.229	2025-12-07 13:19:13.229	109.00	шт	25	только уп
52488	3392	ВАФ СТАКАНЧИК Десерт на кокосовой основе с пюре манго и семенами чиа (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2990.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.281	2025-12-07 13:19:13.281	120.00	шт	25	только уп
52489	3392	ВАФ СТАКАНЧИК Пломбир ванильный (пергамент) 12% 80гр ТМ Чистая Линия	\N	\N	2645.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.318	2025-12-07 13:19:13.318	106.00	шт	25	только уп
52490	3392	ВАФ СТАКАНЧИК Пломбир ванильный (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	25	t	2025-12-07 13:19:13.33	2025-12-07 13:19:13.33	113.00	шт	25	только уп
52491	3392	ВАФ СТАКАНЧИК Пломбир ванильный без лактозы (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	3364.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.356	2025-12-07 13:19:13.356	135.00	шт	25	только уп
52492	3392	ВАФ СТАКАНЧИК Пломбир ванильный без сахарозы (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	3019.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.374	2025-12-07 13:19:13.374	121.00	шт	25	только уп
52493	3392	ВАФ СТАКАНЧИК Пломбир ванильный Вкусовые сосочки 12% 90гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.418	2025-12-07 13:19:13.418	113.00	шт	25	только уп
52494	3392	ВАФ СТАКАНЧИК Пломбир ванильный протеиновый без сахарозы (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	3306.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.462	2025-12-07 13:19:13.462	132.00	шт	25	только уп
52495	3392	ВАФ СТАКАНЧИК Пломбир крем-брюле (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.472	2025-12-07 13:19:13.472	113.00	шт	25	только уп
52496	3392	ВАФ СТАКАНЧИК Пломбир радуга 12% 90гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.51	2025-12-07 13:19:13.51	113.00	шт	25	только уп
52497	3392	ВАФ СТАКАНЧИК Пломбир шоколадный (пергамент) 12% 80гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.52	2025-12-07 13:19:13.52	113.00	шт	25	только уп
52498	3392	ВАФ СТАКАНЧИК Пломбир шоколадный с шоколадной крошкой (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.532	2025-12-07 13:19:13.532	113.00	шт	25	только уп
24513	2755	ПЛ/КОНТ Радуга Пломбир четырехслойный 1000г ТМ Чистая Линия	\N	\N	1120.00	уп (1 шт)	1	62	f	2025-11-10 01:54:53.034	2025-11-22 01:30:48.533	1120.00	шт	1	\N
24518	2755	СЭНДВИЧ Максидуо соленая карамель 94гр ТМ Нестле  Старая цена 131р	\N	\N	2640.00	уп (24 шт)	1	146	f	2025-11-10 01:54:53.27	2025-11-22 01:30:48.533	110.00	шт	24	\N
52499	3392	ЛАКОМКА Московская пломбир ванильный во взбитой шок глазури 12% 80гр ТМ Чистая Линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.544	2025-12-07 13:19:13.544	140.00	шт	30	только уп
52500	3392	ЛАКОМКА Московская пломбир шоколадный во взбитой шок глазури 12% 80гр ТМ Чистая Линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.555	2025-12-07 13:19:13.555	140.00	шт	30	только уп
52501	3392	СЭНДВИЧ Пломбир Ванильный в печенье 12% 90гр ТМ Чистая Линия	\N	\N	4678.00	уп (36 шт)	1	200	t	2025-12-07 13:19:13.568	2025-12-07 13:19:13.568	130.00	шт	36	только уп
52502	3392	СЭНДВИЧ Пломбир Радуга в печенье 12% 90гр ТМ Чистая Линия	\N	\N	4678.00	уп (36 шт)	1	200	t	2025-12-07 13:19:13.579	2025-12-07 13:19:13.579	130.00	шт	36	только уп
52503	3392	РОЖОК Пломбир ванильный 12% 110гр ТМ Чистая Линия	\N	\N	2401.00	уп (18 шт)	1	200	t	2025-12-07 13:19:13.594	2025-12-07 13:19:13.594	133.00	шт	18	только уп
52504	3392	РОЖОК Пломбир ванильный с миндалем в шоколадной глазури с миндалем 12% 90гр ТМ Чистая Линия	\N	\N	2922.00	уп (21 шт)	1	200	t	2025-12-07 13:19:13.605	2025-12-07 13:19:13.605	139.00	шт	21	только уп
52505	3392	РОЖОК Пломбир Радуга 12% 110гр ТМ Чистая Линия	\N	\N	2801.00	уп (21 шт)	1	200	t	2025-12-07 13:19:13.615	2025-12-07 13:19:13.615	133.00	шт	21	только уп
52506	3392	РОЖОК Пломбир шоколадный (пергамент) 12% 110гр ТМ Чистая Линия	\N	\N	2484.00	уп (18 шт)	1	200	t	2025-12-07 13:19:13.625	2025-12-07 13:19:13.625	138.00	шт	18	только уп
52507	3392	РОЖОК Сахарная Трубочка Пломбир ванильный в шоколадной глазури 12% 70гр ТМ Чистая Линия	\N	\N	2650.00	уп (24 шт)	1	200	t	2025-12-07 13:19:13.676	2025-12-07 13:19:13.676	110.00	шт	24	только уп
52508	3392	ЭСКИМО 11 копеек Пломбир ванильный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	4370.00	уп (40 шт)	1	200	t	2025-12-07 13:19:13.687	2025-12-07 13:19:13.687	109.00	шт	40	только уп
52509	3392	ЭСКИМО Единорожка Пломбир ванильный без глазури 12% 65гр ТМ Чистая Линия	\N	\N	2070.00	уп (24 шт)	1	200	t	2025-12-07 13:19:13.713	2025-12-07 13:19:13.713	86.00	шт	24	только уп
52510	3392	ЭСКИМО Зюзя Пломбир ванильный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	4370.00	уп (40 шт)	1	200	t	2025-12-07 13:19:13.732	2025-12-07 13:19:13.732	109.00	шт	40	только уп
52511	3392	ЭСКИМО Ленинградское Пломбир Ванильный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	5313.00	уп (42 шт)	1	200	t	2025-12-07 13:19:13.748	2025-12-07 13:19:13.748	126.00	шт	42	только уп
52512	3392	ЭСКИМО Пломбир без сахарозы 2,5% 70гр ТМ Чистая Линия	\N	\N	3967.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.758	2025-12-07 13:19:13.758	132.00	шт	30	только уп
52513	3392	ЭСКИМО Пломбир ванильный без глазури ( пергамент) 12% 70гр ТМ Чистая Линия	\N	\N	3622.00	уп (42 шт)	1	200	t	2025-12-07 13:19:13.769	2025-12-07 13:19:13.769	86.00	шт	42	только уп
52514	3392	ЭСКИМО Пломбир ванильный в апельсиновой глазури 12% 70гр ТМ Чистая Линия	\N	\N	2156.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.79	2025-12-07 13:19:13.79	86.00	шт	25	только уп
52515	3392	ЭСКИМО Пломбир ванильный в бельгийском шоколаде с клюквой 12% 80гр ТМ Чистая Линия	\N	\N	4223.00	уп (27 шт)	1	200	t	2025-12-07 13:19:13.801	2025-12-07 13:19:13.801	156.00	шт	27	только уп
52516	3392	ЭСКИМО Пломбир ванильный в клубничной глазури 12% 70гр ТМ Чистая Линия	\N	\N	2156.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.811	2025-12-07 13:19:13.811	86.00	шт	25	только уп
52517	3392	ЭСКИМО Пломбир ванильный в шок. глазури с миндалем 12% 80гр ТМ Чистая Линия	\N	\N	3309.00	уп (21 шт)	1	200	t	2025-12-07 13:19:13.821	2025-12-07 13:19:13.821	158.00	шт	21	только уп
52518	3392	ЭСКИМО Пломбир Манго с пюре манго и кусочками манго 12% 70гр ТМ Чистая Линия	\N	\N	2645.00	уп (20 шт)	1	200	t	2025-12-07 13:19:13.837	2025-12-07 13:19:13.837	132.00	шт	20	только уп
52519	3392	ЭСКИМО Пломбир Нежный кокос с аром кокоса в бел глазури 12% 62гр 1/27шт ТМ Чистая Линия	\N	\N	2961.00	уп (25 шт)	1	200	t	2025-12-07 13:19:13.848	2025-12-07 13:19:13.848	118.00	шт	25	только уп
52520	3392	ЭСКИМО Пломбир Радуга 12% 70гр ТМ Чистая Линия	\N	\N	1725.00	уп (20 шт)	1	200	t	2025-12-07 13:19:13.859	2025-12-07 13:19:13.859	86.00	шт	20	только уп
52521	3392	ЭСКИМО Пломбир шоколадный без глазури ( пергамент) 12% 70гр ТМ Чистая Линия	\N	\N	3719.00	уп (42 шт)	1	200	t	2025-12-07 13:19:13.879	2025-12-07 13:19:13.879	89.00	шт	42	только уп
52522	3392	ЭСКИМО Экскимо Российское Пломбир ванильный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	2760.00	уп (20 шт)	1	200	t	2025-12-07 13:19:13.89	2025-12-07 13:19:13.89	138.00	шт	20	только уп
52523	3392	ЭСКИМО Экскимо Российское Пломбир шоколадный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	5520.00	уп (40 шт)	1	200	t	2025-12-07 13:19:13.9	2025-12-07 13:19:13.9	138.00	шт	40	только уп
52524	3392	ЭСКИМО Эскимо Веселый Кактус  Арахис соленая карамель 12% 70гр ТМ Чистая Линия	\N	\N	4140.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.912	2025-12-07 13:19:13.912	138.00	шт	30	только уп
52525	3392	ЭСКИМО Эскимо Веселый Кактус Ананасовое с ананасово-кокосовым наполнителем в ананасово-кокосовой глазури с хлопьями 12% 80гр ТМ Чистая Линия	\N	\N	3898.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.944	2025-12-07 13:19:13.944	130.00	шт	30	только уп
24562	2755	НАРЕЗКА БЕКОН 180гр 1/10шт с/к в/у ТМ Черкизово	\N	\N	3000.00	уп (10 шт)	1	16	f	2025-11-10 01:54:55.584	2025-11-22 01:30:48.533	300.00	шт	10	\N
52526	3392	ЭСКИМО Эскимо Веселый Кактус Апельсин с наполнителем из тропиеских фруктов в глазури апельсин и взрывной карамелью 12% 80гр ТМ Чистая Линия	\N	\N	3898.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.954	2025-12-07 13:19:13.954	130.00	шт	30	только уп
52527	3392	ЭСКИМО Эскимо Веселый Кактус Гранат с наполнителем фруктовый лукум в глазури гранат с взрывной карамелью и кусочками ягод 12% 80гр ТМ Чистая Линия	\N	\N	4451.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.964	2025-12-07 13:19:13.964	148.00	шт	30	только уп
52528	3392	ЭСКИМО Эскимо Веселый Кактус малиновый в глазури с ароматом и кусочками малины 12% 80гр ТМ Чистая Линия	\N	\N	4002.00	уп (30 шт)	1	200	t	2025-12-07 13:19:13.977	2025-12-07 13:19:13.977	133.00	шт	30	только уп
52529	3392	ЭСКИМО Эскимо Веселый Кактус Пралине пломбир ванильный с прослойкой сливочной карамели и орехом пекан в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	3719.00	уп (21 шт)	1	200	t	2025-12-07 13:19:14.014	2025-12-07 13:19:14.014	177.00	шт	21	только уп
52530	3392	ЭСКИМО Эскимо Веселый Кактус с клубникой в глазури с ароматом лимона и кусочками клубники 12% 80гр ТМ Чистая Линия	\N	\N	3898.00	уп (30 шт)	1	200	t	2025-12-07 13:19:14.036	2025-12-07 13:19:14.036	130.00	шт	30	только уп
52531	3392	ЭСКИМО Эскимо Веселый Кактус Фисташковый пломбир с фисташковой пастой с кусочками фисташки в шок глазури 12% 80гр ТМ Чистая Линия	\N	\N	3422.00	уп (16 шт)	1	200	t	2025-12-07 13:19:14.055	2025-12-07 13:19:14.055	214.00	шт	16	только уп
52532	3392	ЭСКИМО Эскимо Гранат-Малина Гранатовый-малиновый сок и кусочки малины 12% 70гр ТМ Чистая Линия	\N	\N	2599.00	уп (20 шт)	1	200	t	2025-12-07 13:19:14.065	2025-12-07 13:19:14.065	130.00	шт	20	только уп
52533	3392	ПАКЕТ Пломбир ванильный без сахарозы 12% 200гр ТМ Чистая Линия	\N	\N	6440.00	шт	1	200	t	2025-12-07 13:19:14.077	2025-12-07 13:19:14.077	258.00	шт	25	поштучно
52534	3392	ПАКЕТ Пломбир Семейное ванильный 12% 200гр ТМ Чистая Линия	\N	\N	5089.00	шт	1	200	t	2025-12-07 13:19:14.089	2025-12-07 13:19:14.089	204.00	шт	25	поштучно
52535	3392	ПАКЕТ Пломбир Семейное ванильный 12% 450гр ТМ Чистая Линия	\N	\N	6982.00	шт	1	200	t	2025-12-07 13:19:14.104	2025-12-07 13:19:14.104	537.00	шт	13	поштучно
52536	3392	ПАКЕТ Пломбир Семейное Крем-Брюле 12% 200гр ТМ Чистая Линия	\N	\N	5089.00	шт	1	200	t	2025-12-07 13:19:14.114	2025-12-07 13:19:14.114	204.00	шт	25	поштучно
52537	3392	ПАКЕТ Пломбир Семейное шоколадный 12% 200гр ТМ Чистая Линия	\N	\N	5089.00	шт	1	200	t	2025-12-07 13:19:14.126	2025-12-07 13:19:14.126	204.00	шт	25	поштучно
52538	3392	ПАКЕТ Пломбир Семейное шоколадный 12% 450гр ТМ Чистая Линия	\N	\N	4296.00	шт	1	200	t	2025-12-07 13:19:14.137	2025-12-07 13:19:14.137	537.00	шт	8	поштучно
52539	3392	ПЛ/КОНТ Банановый Сплит банановое с шоколадной крошкой 1000г ТМ Чистая Линия	\N	\N	1420.00	шт	1	17	t	2025-12-07 13:19:14.147	2025-12-07 13:19:14.147	1420.00	шт	1	поштучно
52540	3392	ПЛ/КОНТ Пломбир клубника ваниль с кусочками клубники 1000г 1/1шт ТМ Чистая Линия	\N	\N	1501.00	шт	1	13	t	2025-12-07 13:19:14.158	2025-12-07 13:19:14.158	1501.00	шт	1	поштучно
52541	3392	ПЛ/КОНТ Радуга Пломбир четырехслойный 1000г ТМ Чистая Линия	\N	\N	1288.00	шт	1	55	t	2025-12-07 13:19:14.168	2025-12-07 13:19:14.168	1288.00	шт	1	поштучно
52542	3392	ПЛ/КОНТ Фейерверк пломбир клубничный бабл-гам карамель 1000г 1/1шт ТМ Чистая Линия	\N	\N	1288.00	шт	1	28	t	2025-12-07 13:19:14.18	2025-12-07 13:19:14.18	1288.00	шт	1	поштучно
52543	3392	ПЛ/КОНТ Шоколад-Шоколадович Пломбир шоколадный с кусочками шоколада1000г ТМ Чистая Линия	\N	\N	1420.00	шт	1	42	t	2025-12-07 13:19:14.203	2025-12-07 13:19:14.203	1420.00	шт	1	поштучно
52544	3392	ВАФ СТАКАНЧИК Пломбир 48 Копеек 15% 88гр ТМ Нестле Старая цена 82р	\N	\N	2484.00	уп (30 шт)	1	200	t	2025-12-07 13:19:14.214	2025-12-07 13:19:14.214	83.00	шт	30	только уп
52545	3392	ВАФ СТАКАНЧИК Пломбир 48 Копеек малина 15% 88гр ТМ Нестле	\N	\N	3381.00	уп (30 шт)	1	200	t	2025-12-07 13:19:14.235	2025-12-07 13:19:14.235	113.00	шт	30	только уп
52546	3392	ВАФ СТАКАНЧИК Пломбир 48 Копеек шоколад 88гр ТМ Нестле	\N	\N	3381.00	уп (30 шт)	1	200	t	2025-12-07 13:19:14.246	2025-12-07 13:19:14.246	113.00	шт	30	только уп
52547	3392	СЭНДВИЧ Максидуо соленая карамель 94гр ТМ Нестле  Старая цена 131р	\N	\N	3036.00	уп (24 шт)	1	200	t	2025-12-07 13:19:14.256	2025-12-07 13:19:14.256	126.00	шт	24	только уп
52548	3392	СЭНДВИЧ Орео 9% 76гр 1/24шт ТМ Нестле Старая цена 100р	\N	\N	2208.00	уп (24 шт)	1	200	t	2025-12-07 13:19:14.267	2025-12-07 13:19:14.267	92.00	шт	24	только уп
52549	3392	РОЖОК Орео 8% 72гр 1/24шт ТМ Нестле	\N	\N	3450.00	уп (24 шт)	1	200	t	2025-12-07 13:19:14.278	2025-12-07 13:19:14.278	144.00	шт	24	только уп
52550	3392	РОЖОК Пломбир 48 Копеек с глазурью и кусочками миндаля 12% 106гр ТМ Нестле	\N	\N	2588.00	уп (18 шт)	1	200	t	2025-12-07 13:19:14.295	2025-12-07 13:19:14.295	144.00	шт	18	только уп
52551	3392	РОЖОК Санрем Клубника со сливками 73гр 1/24шт ТМ Нестле Старая цена 112р	\N	\N	1932.00	уп (24 шт)	1	200	t	2025-12-07 13:19:14.306	2025-12-07 13:19:14.306	81.00	шт	24	только уп
52552	3392	РОЖОК Санрем Малина Банан 78гр 1/24шт ТМ Нестле Старая цена 97р	\N	\N	2208.00	уп (24 шт)	1	200	t	2025-12-07 13:19:14.317	2025-12-07 13:19:14.317	92.00	шт	24	только уп
52553	3392	ЭСКИМО 48 копеек Морс из клюквы 40гр ТМ Нестле Старая цена 81р	\N	\N	3220.00	уп (40 шт)	1	161	t	2025-12-07 13:19:14.332	2025-12-07 13:19:14.332	81.00	шт	40	только уп
52554	3392	ЭСКИМО 48 копеек Яблоко 40гр ТМ Нестле	\N	\N	4416.00	уп (40 шт)	1	40	t	2025-12-07 13:19:14.343	2025-12-07 13:19:14.343	110.00	шт	40	только уп
52555	3392	ЭСКИМО Альпен Гольд 8% 58гр ТМ Нестле Старая цена 142р	\N	\N	3074.00	уп (27 шт)	1	200	t	2025-12-07 13:19:14.357	2025-12-07 13:19:14.357	114.00	шт	27	только уп
52556	3392	ЭСКИМО Максидуо вафельный микс 63гр ТМ Нестле	\N	\N	3260.00	уп (27 шт)	1	200	t	2025-12-07 13:19:14.368	2025-12-07 13:19:14.368	121.00	шт	27	только уп
52557	3392	ЭСКИМО Милка 8% 62гр ТМ Нестле Старая цена 161р	\N	\N	3074.00	уп (27 шт)	1	200	t	2025-12-07 13:19:14.378	2025-12-07 13:19:14.378	114.00	шт	27	только уп
52558	3392	ЭСКИМО Милка лесные ягоды 8% 64гр ТМ Нестле Старая цена 167р	\N	\N	3571.00	уп (27 шт)	1	200	t	2025-12-07 13:19:14.389	2025-12-07 13:19:14.389	132.00	шт	27	только уп
52559	3392	ЭСКИМО Миндаль в глазури 59гр ТМ Нестле	\N	\N	3260.00	уп (27 шт)	1	200	t	2025-12-07 13:19:14.399	2025-12-07 13:19:14.399	121.00	шт	27	только уп
52560	3392	ЭСКИМО Орео 8% 56гр ТМ Нестле Старая цена 120р	\N	\N	3260.00	уп (27 шт)	1	200	t	2025-12-07 13:19:14.413	2025-12-07 13:19:14.413	121.00	шт	27	только уп
52561	3392	БРИКЕТ 48 Копеек Шоколадный с шок.соусом 232гр 1/25шт ТМ Нестле	\N	\N	5664.00	уп (25 шт)	1	200	t	2025-12-07 13:19:14.436	2025-12-07 13:19:14.436	227.00	шт	25	только уп
52562	3392	БРИКЕТ 48 КопеекПломбир 12% 210гр 1/25шт ТМ Нестле	\N	\N	5664.00	уп (25 шт)	1	200	t	2025-12-07 13:19:14.51	2025-12-07 13:19:14.51	227.00	шт	25	только уп
52563	3392	Ведро Максидуо 282гр 1/8шт ТМ Нестле	\N	\N	4692.00	шт	1	200	t	2025-12-07 13:19:14.532	2025-12-07 13:19:14.532	587.00	шт	8	поштучно
52564	3392	ПЛ/КОНТЕЙНЕР Мороженое 48 копеек пломбир 419гр ТМ НЕСТЛЕ	\N	\N	4048.00	шт	1	52	t	2025-12-07 13:19:14.544	2025-12-07 13:19:14.544	506.00	шт	8	поштучно
52565	3392	ФРУКТОВЫЙ ЛЁД Бон Пари Кошмарики 59гр ТМ Нестле	\N	\N	3974.00	уп (32 шт)	1	200	t	2025-12-07 13:19:14.555	2025-12-07 13:19:14.555	124.00	шт	32	только уп
52566	3392	ФРУКТОВЫЙ ЛЁД Бон Пари Ураган с взр.карамелью 60гр ТМ Нестле	\N	\N	4099.00	уп (44 шт)	1	200	t	2025-12-07 13:19:14.567	2025-12-07 13:19:14.567	93.00	шт	44	только уп
52567	3392	ФРУКТОВЫЙ ЛЁД Почемучка 60гр ТМ Нестле	\N	\N	2581.00	уп (44 шт)	1	200	t	2025-12-07 13:19:14.578	2025-12-07 13:19:14.578	59.00	шт	44	только уп
52568	3396	ВЕТЧИНА вар Турбослимский бройлер 400гр Мусульманская Халяль 1/10шт	\N	\N	3450.00	шт	1	26	t	2025-12-07 13:19:14.604	2025-12-07 13:19:14.604	345.00	шт	10	поштучно
52569	3396	ВЕТЧИНА вар Черкизово 400гр Мраморная по-черкизовски 1/6шт	\N	\N	2243.00	шт	1	15	t	2025-12-07 13:19:14.616	2025-12-07 13:19:14.616	374.00	шт	6	поштучно
52570	3396	КОЛБАСА вар Турбослимский бройлер 400гр Мусульманская Халяль 1/10шт	\N	\N	1323.00	шт	1	24	t	2025-12-07 13:19:14.627	2025-12-07 13:19:14.627	132.00	шт	10	поштучно
52571	3396	КОЛБАСА вар Черкизово 380гр Сочная с окороком	\N	\N	1932.00	шт	1	24	t	2025-12-07 13:19:14.638	2025-12-07 13:19:14.638	322.00	шт	6	поштучно
52572	3396	КОЛБАСА вар Черкизово 400гр Молочная по-Черкизовски	\N	\N	2070.00	шт	1	48	t	2025-12-07 13:19:14.65	2025-12-07 13:19:14.65	345.00	шт	6	поштучно
52573	3396	КОЛБАСА вар Черкизово 500гр Губернская в сетке	\N	\N	1932.00	шт	1	48	t	2025-12-07 13:19:14.661	2025-12-07 13:19:14.661	322.00	шт	6	поштучно
52574	3396	ВЕТЧИНА вар Папа может 400гр Мясная	\N	\N	2374.00	шт	1	17	t	2025-12-07 13:19:14.699	2025-12-07 13:19:14.699	297.00	шт	8	поштучно
52575	3396	ВЕТЧИНА вар Папа может 400гр с Индейкой	\N	\N	1856.00	шт	1	28	t	2025-12-07 13:19:14.71	2025-12-07 13:19:14.71	309.00	шт	6	поштучно
52576	3396	КОЛБАСА вар Папа может 400гр Говяжья	\N	\N	2328.00	шт	1	41	t	2025-12-07 13:19:14.72	2025-12-07 13:19:14.72	291.00	шт	8	поштучно
52577	3396	КОЛБАСА вар Папа может 400гр Докторская Премиум	\N	\N	2282.00	шт	1	47	t	2025-12-07 13:19:14.734	2025-12-07 13:19:14.734	285.00	шт	8	поштучно
52578	3396	КОЛБАСА вар Папа может 400гр Домашняя	\N	\N	2328.00	шт	1	30	t	2025-12-07 13:19:14.744	2025-12-07 13:19:14.744	291.00	шт	8	поштучно
52579	3396	КОЛБАСА вар Папа может 400гр Мясная	\N	\N	2134.00	шт	1	42	t	2025-12-07 13:19:14.755	2025-12-07 13:19:14.755	267.00	шт	8	поштучно
52580	3396	КОЛБАСА вар Папа может 400гр Папин бутер	\N	\N	2364.00	шт	1	42	t	2025-12-07 13:19:14.765	2025-12-07 13:19:14.765	296.00	шт	8	поштучно
52581	3396	КОЛБАСА вар Папа может 400гр Сочная	\N	\N	3668.00	шт	1	24	t	2025-12-07 13:19:14.776	2025-12-07 13:19:14.776	367.00	шт	10	поштучно
52582	3396	КОЛБАСА вар Папа может 400гр Филейная	\N	\N	2070.00	шт	1	12	t	2025-12-07 13:19:14.787	2025-12-07 13:19:14.787	259.00	шт	8	поштучно
52583	3396	КОЛБАСА вар Папа может 400гр Экстра	\N	\N	2070.00	шт	1	11	t	2025-12-07 13:19:14.798	2025-12-07 13:19:14.798	259.00	шт	8	поштучно
52584	3396	САРДЕЛЬКИ ПАПА МОЖЕТ Сочные 300гр в/уп	\N	\N	1849.00	шт	1	36	t	2025-12-07 13:19:14.808	2025-12-07 13:19:14.808	231.00	шт	8	поштучно
52585	3396	СОСИСКИ ПАПА МОЖЕТ Молочные ГОСТ 300гр в/уп	\N	\N	1658.00	шт	1	55	t	2025-12-07 13:19:14.82	2025-12-07 13:19:14.82	237.00	шт	7	поштучно
52586	3396	СОСИСКИ ПАПА МОЖЕТ Молочные ПРЕМИУМ 350гр в/уп	\N	\N	1895.00	шт	1	43	t	2025-12-07 13:19:14.83	2025-12-07 13:19:14.83	237.00	шт	8	поштучно
52587	3396	СОСИСКИ ПАПА МОЖЕТ Сочные 350гр в/уп	\N	\N	2171.00	шт	1	57	t	2025-12-07 13:19:14.842	2025-12-07 13:19:14.842	271.00	шт	8	поштучно
52588	3396	ШПИКАЧКИ ПАПА МОЖЕТ Сочные с беконом 300гр в/уп	\N	\N	1849.00	шт	1	62	t	2025-12-07 13:19:14.853	2025-12-07 13:19:14.853	231.00	шт	8	поштучно
52589	3396	КОЛБАСА вар СПК 400гр Докторская в обвязке	\N	\N	16848.00	шт	1	39	t	2025-12-07 13:19:14.876	2025-12-07 13:19:14.876	337.00	шт	50	поштучно
52590	3396	КОЛБАСА вар СПК 400гр Классическая п/а	\N	\N	9718.00	шт	1	30	t	2025-12-07 13:19:14.898	2025-12-07 13:19:14.898	194.00	шт	50	поштучно
52591	3396	КОЛБАСА вар СПК 400гр Любительская п/а	\N	\N	18860.00	шт	1	50	t	2025-12-07 13:19:14.914	2025-12-07 13:19:14.914	377.00	шт	50	поштучно
52592	3396	КОЛБАСА вар СПК 470гр Бутербродная п/а	\N	\N	10523.00	шт	1	38	t	2025-12-07 13:19:14.928	2025-12-07 13:19:14.928	210.00	шт	50	поштучно
52593	3396	КОЛБАСА вар СПК 470гр К чаю	\N	\N	11558.00	шт	1	69	t	2025-12-07 13:19:14.94	2025-12-07 13:19:14.94	231.00	шт	50	поштучно
52594	3396	КОЛБАСА вар СПК 470гр Покровская п/а	\N	\N	11902.00	шт	1	50	t	2025-12-07 13:19:14.951	2025-12-07 13:19:14.951	238.00	шт	50	поштучно
52595	3396	КОЛБАСА вар СПК ВЕС Семейная с чесночком Экстра	\N	\N	10868.00	кг	1	8	t	2025-12-07 13:19:14.963	2025-12-07 13:19:14.963	435.00	кг	25	поштучно
52596	3396	КОЛБАСА вар СПК ВЕС Утренняя	\N	\N	11184.00	кг	1	17	t	2025-12-07 13:19:14.974	2025-12-07 13:19:14.974	447.00	кг	25	поштучно
52597	3396	СОСИСКИ СПК Баварские с сыром 360гр в/уп	\N	\N	14030.00	шт	1	22	t	2025-12-07 13:19:14.985	2025-12-07 13:19:14.985	281.00	шт	50	поштучно
52598	3396	СОСИСКИ СПК Большая SOSиска 1кг в/уп	\N	\N	13478.00	кг	1	15	t	2025-12-07 13:19:14.997	2025-12-07 13:19:14.997	674.00	кг	20	поштучно
52599	3396	СОСИСКИ СПК Молочные 360гр в/уп	\N	\N	12937.00	шт	1	24	t	2025-12-07 13:19:15.12	2025-12-07 13:19:15.12	259.00	шт	50	поштучно
52600	3396	СОСИСКИ СПК С чесночком 360гр в/уп	\N	\N	14777.00	шт	1	14	t	2025-12-07 13:19:15.159	2025-12-07 13:19:15.159	296.00	шт	50	поштучно
52601	3396	КОЛБАСА Черкизово Балыковая по-черкизовски в/к фиб в/уп 300гр цена за шт	\N	\N	2450.00	шт	1	6	t	2025-12-07 13:19:15.183	2025-12-07 13:19:15.183	408.00	шт	6	поштучно
52602	3396	НАРЕЗКА БЕКОН 360гр 1/5шт с/к в/у ТМ Черкизово	\N	\N	3421.00	шт	1	9	t	2025-12-07 13:19:15.212	2025-12-07 13:19:15.212	684.00	шт	5	поштучно
52603	3396	КОЛБАСА ОСТАНКИНО Венская Салями п/к 330гр цена за шт	\N	\N	2668.00	шт	1	18	t	2025-12-07 13:19:15.246	2025-12-07 13:19:15.246	334.00	шт	8	поштучно
52604	3396	КОЛБАСА ОСТАНКИНО Сервелат Европейский в/к 330гр цена за шт	\N	\N	2300.00	шт	1	56	t	2025-12-07 13:19:15.32	2025-12-07 13:19:15.32	288.00	шт	8	поштучно
52605	3396	КОЛБАСА ОСТАНКИНО Сервелат Кремлевский в/к 330гр цена за шт	\N	\N	3404.00	шт	1	12	t	2025-12-07 13:19:15.386	2025-12-07 13:19:15.386	425.00	шт	8	поштучно
52606	3396	КОЛБАСА ПАПА МОЖЕТ Балыковая п/к 310гр цена за шт	\N	\N	2024.00	шт	1	32	t	2025-12-07 13:19:15.417	2025-12-07 13:19:15.417	253.00	шт	8	поштучно
52607	3396	КОЛБАСА ПАПА МОЖЕТ Домашний Рецепт п/к 330гр цена за шт	\N	\N	2277.00	шт	1	27	t	2025-12-07 13:19:15.437	2025-12-07 13:19:15.437	253.00	шт	9	поштучно
52608	3396	КОЛБАСА ПАПА МОЖЕТ Салями п/к 280гр цена за шт	\N	\N	2475.00	шт	1	23	t	2025-12-07 13:19:15.455	2025-12-07 13:19:15.455	309.00	шт	8	поштучно
52609	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Австрийский в/к 420гр цена за шт	\N	\N	3321.00	шт	1	7	t	2025-12-07 13:19:15.47	2025-12-07 13:19:15.47	415.00	шт	8	поштучно
52610	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Зернистый в/к 350гр цена за шт	\N	\N	2438.00	шт	1	45	t	2025-12-07 13:19:15.486	2025-12-07 13:19:15.486	305.00	шт	8	поштучно
52611	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Карельский в/к 280гр цена за шт	\N	\N	1656.00	шт	1	60	t	2025-12-07 13:19:15.497	2025-12-07 13:19:15.497	207.00	шт	8	поштучно
52612	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Ореховый в/к 310гр цена за шт	\N	\N	1794.00	шт	1	53	t	2025-12-07 13:19:15.509	2025-12-07 13:19:15.509	224.00	шт	8	поштучно
52613	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Охотничий в/к 350гр цена за шт	\N	\N	2475.00	шт	1	21	t	2025-12-07 13:19:15.539	2025-12-07 13:19:15.539	309.00	шт	8	поштучно
52614	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Пражский в/к 350гр цена за шт	\N	\N	1932.00	шт	1	28	t	2025-12-07 13:19:15.552	2025-12-07 13:19:15.552	241.00	шт	8	поштучно
52615	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Финский в/к 350гр цена за шт	\N	\N	2668.00	шт	1	6	t	2025-12-07 13:19:15.565	2025-12-07 13:19:15.565	334.00	шт	8	поштучно
52616	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Шварцер в/к 280гр цена за шт	\N	\N	1748.00	шт	1	68	t	2025-12-07 13:19:15.577	2025-12-07 13:19:15.577	218.00	шт	8	поштучно
52617	3396	КОЛБАСА ПАПА МОЖЕТ Чесночная п/к 350гр цена за шт	\N	\N	2392.00	шт	1	17	t	2025-12-07 13:19:15.591	2025-12-07 13:19:15.591	299.00	шт	8	поштучно
52618	3396	КУСОК БЕКОН свиной Пряные специи 400гр в/к в/уп ТМ ВИК	\N	\N	489.00	шт	1	100	t	2025-12-07 13:19:15.621	2025-12-07 13:19:15.621	489.00	шт	1	поштучно
52619	3396	КУСОК БЕКОН свиной Фермерский 400гр в/к в/уп ТМ ВИК	\N	\N	489.00	шт	1	100	t	2025-12-07 13:19:15.652	2025-12-07 13:19:15.652	489.00	шт	1	поштучно
52620	3396	КУСОК ЛОПАТКА свиная 400гр в/к в/уп ТМ ВИК	\N	\N	492.00	шт	1	100	t	2025-12-07 13:19:15.666	2025-12-07 13:19:15.666	492.00	шт	1	поштучно
52621	3396	НАРЕЗКА БЕКОН свиной Фермерский 200гр в/к в/уп ТМ ВИК	\N	\N	267.00	шт	1	100	t	2025-12-07 13:19:15.689	2025-12-07 13:19:15.689	267.00	шт	1	поштучно
52622	3396	НАРЕЗКА ЛОПАТКА свиная  200гр в/к в/уп ТМ ВИК	\N	\N	267.00	шт	1	100	t	2025-12-07 13:19:15.721	2025-12-07 13:19:15.721	267.00	шт	1	поштучно
52623	3396	КОЛБАСА СПК Сервелат Европейский в/к 380гр цена за шт	\N	\N	11615.00	шт	1	11	t	2025-12-07 13:19:15.736	2025-12-07 13:19:15.736	232.00	шт	50	поштучно
52624	3396	КОЛБАСА Останкино с/к Ароматная 250гр	\N	\N	2742.00	шт	1	80	t	2025-12-07 13:19:15.75	2025-12-07 13:19:15.75	343.00	шт	8	поштучно
52625	3396	КОЛБАСА Останкино с/к Пресижн 250гр	\N	\N	3873.00	шт	1	30	t	2025-12-07 13:19:15.78	2025-12-07 13:19:15.78	484.00	шт	8	поштучно
52626	3396	КОЛБАСА Останкино с/к Сальчичон 220гр	\N	\N	2944.00	шт	1	24	t	2025-12-07 13:19:15.815	2025-12-07 13:19:15.815	368.00	шт	8	поштучно
52627	3396	КОЛБАСА Останкино с/к Салями Итальянская 250гр	\N	\N	3238.00	шт	1	16	t	2025-12-07 13:19:15.838	2025-12-07 13:19:15.838	405.00	шт	8	поштучно
52628	3396	КОЛБАСА Останкино с/к Свиная ГОСТ 220гр	\N	\N	3036.00	шт	1	16	t	2025-12-07 13:19:15.852	2025-12-07 13:19:15.852	379.00	шт	8	поштучно
40769	2755	ПРЯНИКИ Хлебный дом Классические 300гр	\N	\N	1104.00	уп (12 шт)	1	94	f	2025-11-30 11:01:31.568	2025-12-06 02:48:51.249	80.00	шт	12	\N
52629	3396	КОЛБАСА Останкино с/к Юбилейная 250гр	\N	\N	2999.00	шт	1	45	t	2025-12-07 13:19:15.863	2025-12-07 13:19:15.863	375.00	шт	8	поштучно
24689	2755	ПЕЧЕНЬЕ СЭНДВИЧ Bang bang вкус клубники 4кг	\N	\N	1988.00	уп (4 шт)	1	32	f	2025-11-10 01:55:02.677	2025-11-22 01:30:48.533	497.00	кг	4	\N
24690	2755	ПЕЧЕНЬЕ СЭНДВИЧ Сладонеж какао молоко 4кг	\N	\N	1988.00	уп (4 шт)	1	12	f	2025-11-10 01:55:02.721	2025-11-22 01:30:48.533	497.00	кг	4	\N
52630	3396	КОЛБАСА Папа может с/к Бургундия 250гр	\N	\N	2852.00	шт	1	58	t	2025-12-07 13:19:15.876	2025-12-07 13:19:15.876	357.00	шт	8	поштучно
52631	3396	КОЛБАСА Папа может с/к Охотничья 220гр	\N	\N	2300.00	шт	1	14	t	2025-12-07 13:19:15.888	2025-12-07 13:19:15.888	288.00	шт	8	поштучно
52632	3396	КОЛБАСА Папа может с/к Салями 250гр	\N	\N	2898.00	шт	1	11	t	2025-12-07 13:19:15.915	2025-12-07 13:19:15.915	362.00	шт	8	поштучно
52633	3396	КОЛБАСА Папа может с/к Экстра 250гр	\N	\N	2392.00	шт	1	48	t	2025-12-07 13:19:15.947	2025-12-07 13:19:15.947	299.00	шт	8	поштучно
52634	3396	КОЛБАСА Черкизово с/к Богородская 300гр	\N	\N	6417.00	шт	1	20	t	2025-12-07 13:19:15.976	2025-12-07 13:19:15.976	535.00	шт	12	поштучно
52635	3396	КОЛБАСА Черкизово с/к Бородинская Экстра 200гр	\N	\N	2277.00	шт	1	48	t	2025-12-07 13:19:15.988	2025-12-07 13:19:15.988	379.00	шт	6	поштучно
52636	3396	КОЛБАСА Черкизово с/к Брауншвейгская срез 200гр	\N	\N	2884.00	шт	1	14	t	2025-12-07 13:19:16.001	2025-12-07 13:19:16.001	481.00	шт	6	поштучно
52637	3396	КОЛБАСА Черкизово с/к Преображенская срез 300гр	\N	\N	3105.00	шт	1	18	t	2025-12-07 13:19:16.025	2025-12-07 13:19:16.025	518.00	шт	6	поштучно
52638	3396	КОЛБАСА Черкизово с/к Сальчичон 300гр	\N	\N	4464.00	шт	1	28	t	2025-12-07 13:19:16.036	2025-12-07 13:19:16.036	744.00	шт	6	поштучно
52639	3396	КОЛБАСА Черкизово с/к Сальчичон с розовым перцем срез 300гр	\N	\N	4140.00	шт	1	16	t	2025-12-07 13:19:16.048	2025-12-07 13:19:16.048	690.00	шт	6	поштучно
52640	3396	КОЛБАСА Черкизово с/к Салями Астория срез 225гр	\N	\N	2691.00	шт	1	17	t	2025-12-07 13:19:16.059	2025-12-07 13:19:16.059	448.00	шт	6	поштучно
52641	3396	КОЛБАСА Черкизово с/к Салями Фламенко 250гр	\N	\N	3381.00	шт	1	18	t	2025-12-07 13:19:16.084	2025-12-07 13:19:16.084	564.00	шт	6	поштучно
52642	3396	КОЛБАСА Черкизово с/к Свиная по-черкизовски 225гр	\N	\N	2484.00	шт	1	38	t	2025-12-07 13:19:16.1	2025-12-07 13:19:16.1	414.00	шт	6	поштучно
52643	3396	КОЛБАСА Черкизово с/к Сервелетти 250гр	\N	\N	3105.00	шт	1	15	t	2025-12-07 13:19:16.113	2025-12-07 13:19:16.113	518.00	шт	6	поштучно
52644	3396	КОЛБАСА Черкизово с/к Элитная срез 225гр	\N	\N	3036.00	шт	1	14	t	2025-12-07 13:19:16.124	2025-12-07 13:19:16.124	506.00	шт	6	поштучно
52645	3396	КОЛБАСА ВИК Нарезка с/к Банкетная 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-07 13:19:16.138	2025-12-07 13:19:16.138	221.00	шт	1	поштучно
52646	3396	КОЛБАСА ВИК Нарезка с/к Берлинская 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-07 13:19:16.149	2025-12-07 13:19:16.149	221.00	шт	1	поштучно
52647	3396	КОЛБАСА ВИК Нарезка с/к Брауншвейгская 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-07 13:19:16.171	2025-12-07 13:19:16.171	221.00	шт	1	поштучно
52648	3396	КОЛБАСА ВИК Нарезка с/к Виковская (Киевская) 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-07 13:19:16.191	2025-12-07 13:19:16.191	221.00	шт	1	поштучно
52649	3396	КОЛБАСА ВИК Нарезка с/к Дальневосточная 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-07 13:19:16.204	2025-12-07 13:19:16.204	221.00	шт	1	поштучно
52650	3396	КОЛБАСА ВИК Нарезка с/к Зернистая 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-07 13:19:16.217	2025-12-07 13:19:16.217	221.00	шт	1	поштучно
52651	3396	КОЛБАСА ВИК Нарезка с/к Коньячная 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-07 13:19:16.233	2025-12-07 13:19:16.233	221.00	шт	1	поштучно
52652	3396	КОЛБАСА ВИК Нарезка с/к Молодежная 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-07 13:19:16.246	2025-12-07 13:19:16.246	221.00	шт	1	поштучно
52653	3396	КОЛБАСА ВИК Нарезка с/к Московская 100гр в/уп	\N	\N	236.00	шт	1	100	t	2025-12-07 13:19:16.263	2025-12-07 13:19:16.263	236.00	шт	1	поштучно
52654	3396	КОЛБАСА ВИК Нарезка с/к Пять Перцев 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-07 13:19:16.319	2025-12-07 13:19:16.319	221.00	шт	1	поштучно
52655	3396	КОЛБАСА ВИК Нарезка с/к Сервелат 100гр в/уп	\N	\N	236.00	шт	1	100	t	2025-12-07 13:19:16.401	2025-12-07 13:19:16.401	236.00	шт	1	поштучно
52656	3396	КОЛБАСА ВИК Нарезка с/к Столичная 100гр в/уп	\N	\N	236.00	шт	1	100	t	2025-12-07 13:19:16.43	2025-12-07 13:19:16.43	236.00	шт	1	поштучно
52657	3396	КОЛБАСА СПК  с/к Салями Русская Просто выгодно в/уп  260гр	\N	\N	27945.00	шт	1	13	t	2025-12-07 13:19:16.469	2025-12-07 13:19:16.469	311.00	шт	90	поштучно
52658	3396	КОЛБАСА СПК Колбаски ПодПивасики оригинальные в/уп 100гр цена за шт	\N	\N	25645.00	шт	1	98	t	2025-12-07 13:19:16.54	2025-12-07 13:19:16.54	256.00	шт	100	поштучно
52659	3396	КОЛБАСА СПК Колбаски ПодПивасики острые в/уп 100гр цена за шт	\N	\N	25645.00	шт	1	79	t	2025-12-07 13:19:16.552	2025-12-07 13:19:16.552	256.00	шт	100	поштучно
52660	3396	КОЛБАСА СПК Нарезка с/к Коньячная Высокий вкус 100гр в/уп	\N	\N	23495.00	шт	1	22	t	2025-12-07 13:19:16.563	2025-12-07 13:19:16.563	261.00	шт	90	поштучно
52661	3396	КОЛБАСА СПК Нарезка с/к Новосибирская Высокий вкус 100гр в/уп	\N	\N	24633.00	шт	1	40	t	2025-12-07 13:19:16.573	2025-12-07 13:19:16.573	274.00	шт	90	поштучно
52662	3396	КОЛБАСА СПК Нарезка с/к Пипперони Эликатессе 100гр в/уп	\N	\N	24115.00	шт	1	69	t	2025-12-07 13:19:16.585	2025-12-07 13:19:16.585	268.00	шт	90	поштучно
52663	3396	КОЛБАСА СПК Нарезка с/к Фестивальная пора 100гр в/уп	\N	\N	18009.00	шт	1	62	t	2025-12-07 13:19:16.613	2025-12-07 13:19:16.613	200.00	шт	90	поштучно
52664	3396	КОЛБАСА СПК с/к Балыковая Эликатессе 200гр	\N	\N	44298.00	шт	1	75	t	2025-12-07 13:19:16.626	2025-12-07 13:19:16.626	492.00	шт	90	поштучно
52665	3396	КОЛБАСА СПК с/к Колбаски ПодПивасики с сыром  в/уп 100гр цена за шт	\N	\N	22770.00	шт	1	38	t	2025-12-07 13:19:16.644	2025-12-07 13:19:16.644	228.00	шт	100	поштучно
52666	3396	КОЛБАСА СПК с/к Колбаски ПодПивасики со вкусом горчицы  в/уп 100гр цена за шт	\N	\N	28980.00	шт	1	85	t	2025-12-07 13:19:16.654	2025-12-07 13:19:16.654	290.00	шт	100	поштучно
52667	3396	КОЛБАСА СПК с/к Коньячная 235гр	\N	\N	31671.00	шт	1	11	t	2025-12-07 13:19:16.667	2025-12-07 13:19:16.667	352.00	шт	90	поштучно
52668	3396	КОЛБАСА СПК с/к Новосибирская 235гр	\N	\N	40365.00	шт	1	89	t	2025-12-07 13:19:16.68	2025-12-07 13:19:16.68	448.00	шт	90	поштучно
52669	3396	КОЛБАСА СПК с/к Оригинальная с перцем 235гр	\N	\N	30532.00	шт	1	83	t	2025-12-07 13:19:16.691	2025-12-07 13:19:16.691	339.00	шт	90	поштучно
52670	3396	КОЛБАСА СПК с/к Пепперони для пиццы ВЕС в/уп	\N	\N	25904.00	кг	1	16	t	2025-12-07 13:19:16.702	2025-12-07 13:19:16.702	1036.00	кг	25	поштучно
52671	3396	КОЛБАСА СПК с/к Праздничная 235гр	\N	\N	44091.00	шт	1	12	t	2025-12-07 13:19:16.737	2025-12-07 13:19:16.737	490.00	шт	90	поштучно
52672	3396	КОЛБАСА СПК с/к Сальчичон Эликатессе 200гр	\N	\N	35190.00	шт	1	24	t	2025-12-07 13:19:16.748	2025-12-07 13:19:16.748	391.00	шт	90	поштучно
52673	3396	КОЛБАСА СПК с/к Фестивальная пора 235гр	\N	\N	30325.00	шт	1	76	t	2025-12-07 13:19:16.759	2025-12-07 13:19:16.759	337.00	шт	90	поштучно
52674	3396	КОЛБАСА СПК с/к Фестивальная пора срез 180гр	\N	\N	23495.00	шт	1	7	t	2025-12-07 13:19:16.769	2025-12-07 13:19:16.769	261.00	шт	90	поштучно
52675	3396	КОЛБАСА СПК с/к Юбилейная 235гр	\N	\N	30015.00	шт	1	8	t	2025-12-07 13:19:16.782	2025-12-07 13:19:16.782	334.00	шт	90	поштучно
52676	3303	ВАФЛИ Коломенские 140гр Палочки с орешками	\N	\N	1780.00	уп (18 шт)	1	321	t	2025-12-07 13:19:16.793	2025-12-07 13:19:16.793	99.00	шт	18	только уп
52677	3303	ВАФЛИ Коломенские 200гр Каприччио	\N	\N	1978.00	уп (20 шт)	1	537	t	2025-12-07 13:19:16.804	2025-12-07 13:19:16.804	99.00	шт	20	только уп
52678	3303	ВАФЛИ Коломенские 200гр с Орехами	\N	\N	1978.00	уп (20 шт)	1	349	t	2025-12-07 13:19:16.816	2025-12-07 13:19:16.816	99.00	шт	20	только уп
52679	3303	ВАФЛИ Коломенские 200гр с Халвой	\N	\N	1978.00	уп (20 шт)	1	425	t	2025-12-07 13:19:16.829	2025-12-07 13:19:16.829	99.00	шт	20	только уп
52680	3303	ВАФЛИ Коломенские 200гр Сливочные	\N	\N	1978.00	уп (20 шт)	1	533	t	2025-12-07 13:19:16.842	2025-12-07 13:19:16.842	99.00	шт	20	только уп
52681	3303	ВАФЛИ Коломенские 200гр Топленое молоко	\N	\N	1978.00	уп (20 шт)	1	647	t	2025-12-07 13:19:16.856	2025-12-07 13:19:16.856	99.00	шт	20	только уп
52682	3303	ВАФЛИ Коломенские 90гр Десертные с Халвой	\N	\N	1196.00	уп (20 шт)	1	199	t	2025-12-07 13:19:16.868	2025-12-07 13:19:16.868	60.00	шт	20	только уп
52683	3303	ВАФЛИ Коломенские 90гр Десертные с Шоколадным кремом	\N	\N	1426.00	уп (20 шт)	1	7	t	2025-12-07 13:19:16.879	2025-12-07 13:19:16.879	71.00	шт	20	только уп
52684	3303	ВАФЛИ МИНИ Коломенские 200гр Сливочные	\N	\N	1311.00	уп (12 шт)	1	119	t	2025-12-07 13:19:16.89	2025-12-07 13:19:16.89	109.00	шт	12	только уп
52685	3303	ВАФЛИ МИНИ Коломенские 200гр Шоколадно ореховые	\N	\N	1311.00	уп (12 шт)	1	285	t	2025-12-07 13:19:16.9	2025-12-07 13:19:16.9	109.00	шт	12	только уп
52686	3303	ПЕЧЕНЬЕ Коломенское 120гр Овсяное хрустящее	\N	\N	1164.00	уп (22 шт)	1	54	t	2025-12-07 13:19:16.911	2025-12-07 13:19:16.911	53.00	шт	22	только уп
52687	3303	ПЕЧЕНЬЕ Коломенское 120гр Сахарное классическое	\N	\N	1037.00	уп (22 шт)	1	87	t	2025-12-07 13:19:16.922	2025-12-07 13:19:16.922	47.00	шт	22	только уп
52688	3303	ПЕЧЕНЬЕ Коломенское 120гр Шоколадное	\N	\N	1164.00	уп (22 шт)	1	187	t	2025-12-07 13:19:16.934	2025-12-07 13:19:16.934	53.00	шт	22	только уп
52689	3303	ПЕЧЕНЬЕ Коломенское 240гр Сахарное классическое	\N	\N	954.00	уп (10 шт)	1	155	t	2025-12-07 13:19:16.946	2025-12-07 13:19:16.946	95.00	шт	10	только уп
52690	3303	СУШКИ МИНИ Хлебный дом 180гр ваниль	\N	\N	1118.00	уп (18 шт)	1	67	t	2025-12-07 13:19:16.956	2025-12-07 13:19:16.956	62.00	шт	18	только уп
52691	3303	СУШКИ МИНИ Хлебный дом 180гр мак	\N	\N	1263.00	уп (18 шт)	1	23	t	2025-12-07 13:19:16.968	2025-12-07 13:19:16.968	70.00	шт	18	только уп
52692	3303	ТОРТ Шоколадница 180гр вафельный с карамелью	\N	\N	3841.00	уп (20 шт)	1	46	t	2025-12-07 13:19:16.982	2025-12-07 13:19:16.982	192.00	шт	20	только уп
52693	3303	ТОРТ Шоколадница 230гр вафельный с арахисом	\N	\N	2429.00	уп (12 шт)	1	28	t	2025-12-07 13:19:16.995	2025-12-07 13:19:16.995	202.00	шт	12	только уп
52694	3303	ТОРТ Шоколадница 230гр вафельный с миндалем	\N	\N	2636.00	уп (12 шт)	1	94	t	2025-12-07 13:19:17.015	2025-12-07 13:19:17.015	220.00	шт	12	только уп
52695	3303	ТОРТ Шоколадница 230гр вафельный с фундуком	\N	\N	2636.00	уп (12 шт)	1	86	t	2025-12-07 13:19:17.025	2025-12-07 13:19:17.025	220.00	шт	12	только уп
52696	3303	ТОРТ Шоколадница 250гр вафельный с орехами и изюмом	\N	\N	2829.00	уп (12 шт)	1	43	t	2025-12-07 13:19:17.036	2025-12-07 13:19:17.036	236.00	шт	12	только уп
52697	3303	ТОРТ Шоколадница 250гр вафельный трюфель	\N	\N	4278.00	уп (20 шт)	1	80	t	2025-12-07 13:19:17.046	2025-12-07 13:19:17.046	214.00	шт	20	только уп
52698	3303	ТОРТ Шоколадница 400гр вафельный с арахисом	\N	\N	2857.00	уп (9 шт)	1	41	t	2025-12-07 13:19:17.061	2025-12-07 13:19:17.061	317.00	шт	9	только уп
52699	3303	БАТОНЧИК 34гр Xrust Go арахис карамель	\N	\N	1932.00	уп (35 шт)	1	350	t	2025-12-07 13:19:17.077	2025-12-07 13:19:17.077	55.00	шт	35	только уп
52700	3303	КОНФЕТЫ Пралине 1кг в мол лазури	\N	\N	3505.00	уп (4 шт)	1	19	t	2025-12-07 13:19:17.105	2025-12-07 13:19:17.105	876.00	кг	4	только уп
52701	3303	КОНФЕТЫ Тоффи 1кг в шок лазури	\N	\N	3068.00	уп (4 шт)	1	44	t	2025-12-07 13:19:17.116	2025-12-07 13:19:17.116	767.00	кг	4	только уп
52702	3303	КОНФЕТЫ Тоффи 200гр в шок лазури	\N	\N	3726.00	уп (20 шт)	1	115	t	2025-12-07 13:19:17.127	2025-12-07 13:19:17.127	186.00	шт	20	только уп
52703	3303	КОНФЕТЫ Шоколадница вафельные 1кг кокос карамель в шок лазури	\N	\N	2674.00	уп (3 шт)	1	12	t	2025-12-07 13:19:17.137	2025-12-07 13:19:17.137	891.00	кг	3	только уп
52704	3303	КОНФЕТЫ Шоколадница вафельные 200гр кокос карамель в шок лазури	\N	\N	3075.00	уп (14 шт)	1	95	t	2025-12-07 13:19:17.157	2025-12-07 13:19:17.157	220.00	шт	14	только уп
52705	3303	КОНФЕТЫ Шоколадница желейные 200гр апельсин в шок лазури	\N	\N	3726.00	уп (20 шт)	1	46	t	2025-12-07 13:19:17.167	2025-12-07 13:19:17.167	186.00	шт	20	только уп
52706	3303	КОНФЕТЫ Шоколадный фадж помадные 200гр в шок лазури	\N	\N	3289.00	уп (20 шт)	1	55	t	2025-12-07 13:19:17.178	2025-12-07 13:19:17.178	164.00	шт	20	только уп
52707	3303	ВАФ ТРУБОЧКИ Сладонеж Сливочный крем 175гр	\N	\N	1601.00	уп (16 шт)	1	125	t	2025-12-07 13:19:17.189	2025-12-07 13:19:17.189	100.00	шт	16	только уп
52708	3303	ВАФ ТРУБОЧКИ Сладонеж Халва 175гр	\N	\N	1601.00	уп (16 шт)	1	192	t	2025-12-07 13:19:17.201	2025-12-07 13:19:17.201	100.00	шт	16	только уп
52709	3303	ВАФ ТРУБОЧКИ Сладонеж Шоколадный крем 175гр	\N	\N	1601.00	уп (16 шт)	1	116	t	2025-12-07 13:19:17.212	2025-12-07 13:19:17.212	100.00	шт	16	только уп
52710	3303	ВАФЛИ Ретро Сладонеж Лимонный вкус 300гр	\N	\N	2139.00	уп (12 шт)	1	157	t	2025-12-07 13:19:17.225	2025-12-07 13:19:17.225	178.00	шт	12	только уп
52711	3303	ВАФЛИ Ретро Сладонеж Шоколадный крем 300гр	\N	\N	2139.00	уп (12 шт)	1	103	t	2025-12-07 13:19:17.287	2025-12-07 13:19:17.287	178.00	шт	12	только уп
52712	3303	ВАФЛИ Сладонеж Bang bang 70гр ТОЛЬКО БЛОЧКАМИ	\N	\N	911.00	уп (12 шт)	1	12	t	2025-12-07 13:19:17.328	2025-12-07 13:19:17.328	76.00	шт	12	только уп
52713	3303	ВАФЛИ Сладонеж Вареная сгущенка 270гр	\N	\N	1895.00	уп (16 шт)	1	205	t	2025-12-07 13:19:17.364	2025-12-07 13:19:17.364	118.00	шт	16	только уп
52714	3303	ВАФЛИ Сладонеж Горы шоколада 3кг	\N	\N	1563.00	уп (3 шт)	1	57	t	2025-12-07 13:19:17.376	2025-12-07 13:19:17.376	521.00	кг	3	только уп
52715	3303	ВАФЛИ Сладонеж Горы шоколада глазированные 3кг	\N	\N	2063.00	уп (3 шт)	1	42	t	2025-12-07 13:19:17.39	2025-12-07 13:19:17.39	688.00	кг	3	только уп
52716	3303	ВАФЛИ Сладонеж Ням-нямка вареная сгущенка 3,5кг	\N	\N	1505.00	уп (4 шт)	1	97	t	2025-12-07 13:19:17.402	2025-12-07 13:19:17.402	430.00	кг	4	только уп
52717	3303	ВАФЛИ Сладонеж Ням-нямка сливки 3,5кг	\N	\N	1505.00	уп (4 шт)	1	189	t	2025-12-07 13:19:17.419	2025-12-07 13:19:17.419	430.00	кг	4	только уп
52718	3303	ВАФЛИ Сладонеж Ням-нямка шоколад 3,5кг	\N	\N	1505.00	уп (4 шт)	1	94	t	2025-12-07 13:19:17.437	2025-12-07 13:19:17.437	430.00	кг	4	только уп
52719	3303	ВАФЛИ Сладонеж Ретро лимон 1/6кг 916	\N	\N	2912.00	уп (6 шт)	1	12	t	2025-12-07 13:19:17.449	2025-12-07 13:19:17.449	485.00	кг	6	только уп
52720	3303	ВАФЛИ Сладонеж Сиропные Вареная сгущенка 120гр	\N	\N	1677.00	уп (18 шт)	1	6	t	2025-12-07 13:19:17.479	2025-12-07 13:19:17.479	93.00	шт	18	только уп
52721	3303	ВАФЛИ Сладонеж Сливочный крем 270гр	\N	\N	1895.00	уп (16 шт)	1	190	t	2025-12-07 13:19:17.492	2025-12-07 13:19:17.492	118.00	шт	16	только уп
52722	3303	ВАФЛИ Сладонеж Шоколадный крем 270гр	\N	\N	1895.00	уп (16 шт)	1	353	t	2025-12-07 13:19:17.513	2025-12-07 13:19:17.513	118.00	шт	16	только уп
52723	3303	КАРАМЕЛЬ XXS фруковот-ягодной желейной начинкой 1кг ТМ Сладонеж	\N	\N	3341.00	уп (7 шт)	1	65	t	2025-12-07 13:19:17.533	2025-12-07 13:19:17.533	477.00	кг	7	только уп
52724	3303	КАРАМЕЛЬ вкус Апельсина 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	75	t	2025-12-07 13:19:17.544	2025-12-07 13:19:17.544	408.00	кг	7	только уп
52725	3303	КАРАМЕЛЬ вкус Груши 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	76	t	2025-12-07 13:19:17.558	2025-12-07 13:19:17.558	408.00	кг	7	только уп
52726	3303	КАРАМЕЛЬ вкус Мяты 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	69	t	2025-12-07 13:19:17.57	2025-12-07 13:19:17.57	408.00	кг	7	только уп
52727	3303	КАРАМЕЛЬ Вуаля вкус клубники 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	69	t	2025-12-07 13:19:17.594	2025-12-07 13:19:17.594	408.00	кг	7	только уп
52728	3303	КАРАМЕЛЬ Ива Дивная 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	77	t	2025-12-07 13:19:17.616	2025-12-07 13:19:17.616	408.00	кг	7	только уп
52729	3303	КАРАМЕЛЬ Красна Ягодка 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	77	t	2025-12-07 13:19:17.685	2025-12-07 13:19:17.685	408.00	кг	7	только уп
52730	3303	КОНФЕТЫ ваф Герои Сказок 400гр ТМ Сладонеж	\N	\N	2558.00	уп (8 шт)	1	37	t	2025-12-07 13:19:17.728	2025-12-07 13:19:17.728	320.00	шт	8	только уп
52731	3303	КОНФЕТЫ Мон Шер Ами со вкусом тирамису 500гр ТМ Сладонеж	\N	\N	5382.00	уп (8 шт)	1	74	t	2025-12-07 13:19:17.745	2025-12-07 13:19:17.745	673.00	шт	8	только уп
52732	3303	КОНФЕТЫ Мон Шер Ами со вкусом трюфеля 2кг ТМ Сладонеж	\N	\N	2024.00	уп (2 шт)	1	12	t	2025-12-07 13:19:17.757	2025-12-07 13:19:17.757	1012.00	кг	2	только уп
52733	3303	КОНФЕТЫ Мон Шер Ами со вкусом трюфеля 500гр ТМ Сладонеж	\N	\N	5382.00	уп (8 шт)	1	26	t	2025-12-07 13:19:17.768	2025-12-07 13:19:17.768	673.00	шт	8	только уп
52734	3303	КОНФЕТЫ Трюфель вкус сливок 2кг ТМ Сладонеж	\N	\N	1739.00	уп (2 шт)	1	6	t	2025-12-07 13:19:17.78	2025-12-07 13:19:17.78	869.00	кг	2	только уп
52735	3303	КРЕКЕР Сладонеж Квадрат с солью 5кг	\N	\N	1466.00	уп (5 шт)	1	80	t	2025-12-07 13:19:17.791	2025-12-07 13:19:17.791	293.00	кг	5	только уп
52736	3303	КРЕКЕР Сладонеж Квадрат с сыром 5кг	\N	\N	1466.00	уп (5 шт)	1	80	t	2025-12-07 13:19:17.801	2025-12-07 13:19:17.801	293.00	кг	5	только уп
52737	3303	КРЕКЕР Сладонеж Магрыбки 4кг	\N	\N	1173.00	уп (4 шт)	1	72	t	2025-12-07 13:19:17.813	2025-12-07 13:19:17.813	293.00	кг	4	только уп
52738	3303	КРЕКЕР Сладонеж Магсмайл с сыром 5кг	\N	\N	1466.00	уп (5 шт)	1	35	t	2025-12-07 13:19:17.823	2025-12-07 13:19:17.823	293.00	кг	5	только уп
52739	3303	ПЕЧЕНЬЕ Сладонеж К кофе вкус топл молока 310гр	\N	\N	2505.00	уп (18 шт)	1	13	t	2025-12-07 13:19:17.834	2025-12-07 13:19:17.834	139.00	шт	18	только уп
52740	3303	ПЕЧЕНЬЕ Сладонеж К кофе вкус шоколада 340гр	\N	\N	2650.00	уп (18 шт)	1	26	t	2025-12-07 13:19:17.845	2025-12-07 13:19:17.845	147.00	шт	18	только уп
52741	3303	ПЕЧЕНЬЕ Сладонеж Овсяное классическое 400гр	\N	\N	2098.00	уп (12 шт)	1	266	t	2025-12-07 13:19:17.86	2025-12-07 13:19:17.86	175.00	шт	12	только уп
52742	3303	ПЕЧЕНЬЕ Сладонеж Сгущенкино раздолье 175гр	\N	\N	1987.00	уп (24 шт)	1	199	t	2025-12-07 13:19:17.872	2025-12-07 13:19:17.872	83.00	шт	24	только уп
52743	3303	ПЕЧЕНЬЕ Сладонеж Советское детство 310гр	\N	\N	1838.00	уп (17 шт)	1	53	t	2025-12-07 13:19:17.883	2025-12-07 13:19:17.883	108.00	шт	17	только уп
52744	3303	ПЕЧЕНЬЕ Сладонеж Топленкино раздолье 5кг	\N	\N	1788.00	уп (5 шт)	1	35	t	2025-12-07 13:19:17.902	2025-12-07 13:19:17.902	358.00	кг	5	только уп
52745	3303	ПЕЧЕНЬЕ Сладонеж Топленые берега 4,5кг	\N	\N	1609.00	уп (5 шт)	1	13	t	2025-12-07 13:19:17.913	2025-12-07 13:19:17.913	358.00	кг	5	только уп
52746	3303	ПЕЧЕНЬЕ СЭНДВИЧ Bang bang 95гр ТОЛЬКО БЛОЧКАМИ	\N	\N	1049.00	уп (12 шт)	1	306	t	2025-12-07 13:19:17.928	2025-12-07 13:19:17.928	87.00	шт	12	только уп
52747	3303	КОНФЕТЫ 150гр жевательный мармелад Злые языки ТМ Победа	\N	\N	1739.00	уп (14 шт)	1	62	t	2025-12-07 13:19:17.94	2025-12-07 13:19:17.94	124.00	шт	14	только уп
52748	3303	КОНФЕТЫ 75гр жевательный мармелад Злые языки ТМ Победа	\N	\N	1058.00	уп (20 шт)	1	176	t	2025-12-07 13:19:17.951	2025-12-07 13:19:17.951	53.00	шт	20	только уп
52749	3303	КОНФЕТЫ Шмелькино Брюшко желейные микс 1кг ТМ Победа	\N	\N	1722.00	уп (3 шт)	1	38	t	2025-12-07 13:19:17.963	2025-12-07 13:19:17.963	574.00	шт	3	только уп
52750	3303	ШОКОЛАД  Горький без сахара 72% какао 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	6693.00	уп (20 шт)	1	220	t	2025-12-07 13:19:17.975	2025-12-07 13:19:17.975	335.00	шт	20	только уп
52751	3303	ШОКОЛАД  Горький без сахара 72% какао 25гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4048.00	уп (40 шт)	1	200	t	2025-12-07 13:19:17.998	2025-12-07 13:19:17.998	101.00	шт	40	только уп
52752	3303	ШОКОЛАД  Горький без сахара 72% какао 50гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	5658.00	уп (30 шт)	1	10	t	2025-12-07 13:19:18.009	2025-12-07 13:19:18.009	189.00	шт	30	только уп
52753	3303	ШОКОЛАД  Горький с кусочками апельсина 72% какао 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	6647.00	уп (20 шт)	1	113	t	2025-12-07 13:19:18.024	2025-12-07 13:19:18.024	332.00	шт	20	только уп
52754	3303	ШОКОЛАД Белый 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3841.00	уп (20 шт)	1	116	t	2025-12-07 13:19:18.036	2025-12-07 13:19:18.036	192.00	шт	20	только уп
52755	3303	ШОКОЛАД Белый с клубникой 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4025.00	уп (20 шт)	1	361	t	2025-12-07 13:19:18.047	2025-12-07 13:19:18.047	201.00	шт	20	только уп
52756	3303	ШОКОЛАД Мишки в лесу с молоком и вафельной крошкой 80гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	2631.00	уп (22 шт)	1	21	t	2025-12-07 13:19:18.059	2025-12-07 13:19:18.059	120.00	шт	22	только уп
52757	3303	ШОКОЛАД Молочный 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4071.00	уп (20 шт)	1	175	t	2025-12-07 13:19:18.07	2025-12-07 13:19:18.07	204.00	шт	20	только уп
52758	3303	ШОКОЛАД Молочный без сахара 36% 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	5152.00	уп (20 шт)	1	147	t	2025-12-07 13:19:18.09	2025-12-07 13:19:18.09	258.00	шт	20	только уп
52759	3303	ШОКОЛАД молочный с лесным орехом 220гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	5794.00	уп (11 шт)	1	102	t	2025-12-07 13:19:18.102	2025-12-07 13:19:18.102	527.00	шт	11	только уп
52760	3303	ШОКОЛАД Молочный с цельным миндалем и морской солью 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3013.00	уп (10 шт)	1	36	t	2025-12-07 13:19:18.113	2025-12-07 13:19:18.113	301.00	шт	10	только уп
52761	3303	ШОКОЛАД Молочный Сливочный с кусочками вишни 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3818.00	уп (20 шт)	1	172	t	2025-12-07 13:19:18.125	2025-12-07 13:19:18.125	191.00	шт	20	только уп
52762	3303	ШОКОЛАД Молочный Сливочный с кусочками вишни 220гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4782.00	уп (11 шт)	1	100	t	2025-12-07 13:19:18.141	2025-12-07 13:19:18.141	435.00	шт	11	только уп
52763	3303	ШОКОЛАД Пористый без сахара горький Шоколадный мусс 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3110.00	уп (16 шт)	1	98	t	2025-12-07 13:19:18.153	2025-12-07 13:19:18.153	194.00	шт	16	только уп
52764	3303	ШОКОЛАД Пористый без сахара молочный Шоколадный мусс 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	2962.00	уп (16 шт)	1	104	t	2025-12-07 13:19:18.163	2025-12-07 13:19:18.163	185.00	шт	16	только уп
52765	3303	ШОКОЛАД Пористый горький Победа вкуса 180гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4306.00	уп (8 шт)	1	50	t	2025-12-07 13:19:18.173	2025-12-07 13:19:18.173	538.00	шт	8	только уп
52766	3303	ШОКОЛАД Пористый молочный classik 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1288.00	уп (16 шт)	1	28	t	2025-12-07 13:19:18.206	2025-12-07 13:19:18.206	81.00	шт	16	только уп
52767	3303	ШОКОЛАД Пористый молочный сливочный classik 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1288.00	уп (16 шт)	1	47	t	2025-12-07 13:19:18.219	2025-12-07 13:19:18.219	81.00	шт	16	только уп
52768	3303	ШОКОЛАД Пористый темный classik 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1803.00	уп (16 шт)	1	10	t	2025-12-07 13:19:18.234	2025-12-07 13:19:18.234	113.00	шт	16	только уп
52769	3303	ШОКОЛАД Темный Десертный с коньяком 100гр  ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4807.00	уп (20 шт)	1	7	t	2025-12-07 13:19:18.246	2025-12-07 13:19:18.246	240.00	шт	20	только уп
52770	3303	КОЗИНАК арахисовый 170гр ТМ Тимоша	\N	\N	3622.00	уп (30 шт)	1	243	t	2025-12-07 13:19:18.256	2025-12-07 13:19:18.256	121.00	шт	30	только уп
52771	3303	КОЗИНАК арахисовый 40гр батончик ТМ Тимоша	\N	\N	2995.00	уп (84 шт)	1	336	t	2025-12-07 13:19:18.266	2025-12-07 13:19:18.266	36.00	шт	84	только уп
52772	3303	КОЗИНАК воздушный рис 50гр  ТМ Тимоша	\N	\N	897.00	уп (20 шт)	1	170	t	2025-12-07 13:19:18.329	2025-12-07 13:19:18.329	45.00	шт	20	только уп
52773	3303	КОЗИНАК кунжутный 150гр ТМ Тимоша	\N	\N	3754.00	уп (34 шт)	1	519	t	2025-12-07 13:19:18.398	2025-12-07 13:19:18.398	110.00	шт	34	только уп
52774	3303	КОЗИНАК кунжутный 40гр батончик ТМ Тимоша	\N	\N	2995.00	уп (84 шт)	1	252	t	2025-12-07 13:19:18.41	2025-12-07 13:19:18.41	36.00	шт	84	только уп
52775	3303	КОЗИНАК МИКС арахис,кунжут,лен 150гр ТМ Тимоша	\N	\N	2346.00	уп (30 шт)	1	545	t	2025-12-07 13:19:18.422	2025-12-07 13:19:18.422	78.00	шт	30	только уп
52776	3303	КОЗИНАК подсолнечный 150гр ТМ Тимоша	\N	\N	1242.00	уп (24 шт)	1	528	t	2025-12-07 13:19:18.433	2025-12-07 13:19:18.433	52.00	шт	24	только уп
52777	3303	КОЗИНАК подсолнечный 40гр батончик ТМ Тимоша	\N	\N	2190.00	уп (112 шт)	1	336	t	2025-12-07 13:19:18.443	2025-12-07 13:19:18.443	20.00	шт	112	только уп
52778	3303	КОЗИНАК ТимМикс Заряд ягод 40гр батончик ТМ Тимоша	\N	\N	3767.00	уп (84 шт)	1	315	t	2025-12-07 13:19:18.517	2025-12-07 13:19:18.517	45.00	шт	84	только уп
52779	3303	КОЗИНАК ТимМикс Сила орехов 40гр батончик ТМ Тимоша	\N	\N	3767.00	уп (84 шт)	1	483	t	2025-12-07 13:19:18.529	2025-12-07 13:19:18.529	45.00	шт	84	только уп
52780	3303	КОЗИНАК ТимМикс Энергия фруктов 40гр батончик ТМ Тимоша	\N	\N	3767.00	уп (84 шт)	1	315	t	2025-12-07 13:19:18.539	2025-12-07 13:19:18.539	45.00	шт	84	только уп
52781	3303	РАХАТ-ЛУКУМ ассорти ароматный 200г 1/12шт Азовчанка ТМ Тимоша	\N	\N	980.00	уп (12 шт)	1	133	t	2025-12-07 13:19:18.549	2025-12-07 13:19:18.549	82.00	шт	12	только уп
52782	3303	РАХАТ-ЛУКУМ с арахисом 250г ТМ Тимоша	\N	\N	1270.00	уп (12 шт)	1	56	t	2025-12-07 13:19:18.567	2025-12-07 13:19:18.567	106.00	шт	12	только уп
52783	3303	РАХАТ-ЛУКУМ с орехом фундук 250г ТМ Тимоша	\N	\N	1794.00	уп (12 шт)	1	53	t	2025-12-07 13:19:18.578	2025-12-07 13:19:18.578	150.00	шт	12	только уп
52784	3303	ХАЛВА арахисовая 250г ТМ Тимоша	\N	\N	3703.00	уп (20 шт)	1	184	t	2025-12-07 13:19:18.589	2025-12-07 13:19:18.589	185.00	шт	20	только уп
52785	3303	ХАЛВА подсолнечная 250г с арахисом ТМ Тимоша	\N	\N	1598.00	уп (20 шт)	1	211	t	2025-12-07 13:19:18.606	2025-12-07 13:19:18.606	80.00	шт	20	только уп
52786	3303	ХАЛВА подсолнечная 250г с какао ТМ Тимоша	\N	\N	1817.00	уп (20 шт)	1	287	t	2025-12-07 13:19:18.616	2025-12-07 13:19:18.616	91.00	шт	20	только уп
52787	3303	ХАЛВА подсолнечная 250г ТМ Тимоша	\N	\N	1461.00	уп (20 шт)	1	429	t	2025-12-07 13:19:18.629	2025-12-07 13:19:18.629	73.00	шт	20	только уп
52788	3303	ХАЛВА подсолнечная 50г батончик ТМ Тимоша	\N	\N	2415.00	уп (84 шт)	1	462	t	2025-12-07 13:19:18.64	2025-12-07 13:19:18.64	29.00	шт	84	только уп
52789	3303	ХАЛВА подсолнечная воздушная 200г ТМ Тимоша	\N	\N	1311.00	уп (12 шт)	1	284	t	2025-12-07 13:19:18.718	2025-12-07 13:19:18.718	109.00	шт	12	только уп
52790	3303	ЩЕРБЕТ арахисовый 200г ТМ Тимоша	\N	\N	1343.00	уп (16 шт)	1	144	t	2025-12-07 13:19:18.73	2025-12-07 13:19:18.73	84.00	шт	16	только уп
52791	3303	ЩЕРБЕТ молочно-арахисовый 200г ТМ Тимоша	\N	\N	1343.00	уп (16 шт)	1	192	t	2025-12-07 13:19:18.74	2025-12-07 13:19:18.74	84.00	шт	16	только уп
52792	3303	ЩЕРБЕТ мраморный 200г ТМ Тимоша	\N	\N	1527.00	уп (16 шт)	1	160	t	2025-12-07 13:19:18.75	2025-12-07 13:19:18.75	95.00	шт	16	только уп
52793	3303	ЩЕРБЕТ с изюмом 250г ТМ Тимоша	\N	\N	1527.00	уп (16 шт)	1	80	t	2025-12-07 13:19:18.76	2025-12-07 13:19:18.76	95.00	шт	16	только уп
52794	3303	СОЛОМКА сладкая 100г 1/18шт ТМ Тимоша	\N	\N	642.00	уп (18 шт)	1	285	t	2025-12-07 13:19:18.77	2025-12-07 13:19:18.77	36.00	шт	18	только уп
52795	3303	СОЛОМКА соленая 100г 1/18шт ТМ Тимоша	\N	\N	642.00	уп (18 шт)	1	344	t	2025-12-07 13:19:18.781	2025-12-07 13:19:18.781	36.00	шт	18	только уп
52796	3303	СОЛОМКА соленая с луком 100г 1/18шт ТМ Тимоша	\N	\N	642.00	уп (18 шт)	1	146	t	2025-12-07 13:19:18.792	2025-12-07 13:19:18.792	36.00	шт	18	только уп
52797	3303	СУШКИ ванильные 200г 1/25шт ТМ Тимоша	\N	\N	1524.00	уп (25 шт)	1	300	t	2025-12-07 13:19:18.802	2025-12-07 13:19:18.802	61.00	шт	25	только уп
52798	3303	СУШКИ простые 200г 1/25шт ТМ Тимоша	\N	\N	1524.00	уп (25 шт)	1	248	t	2025-12-07 13:19:18.813	2025-12-07 13:19:18.813	61.00	шт	25	только уп
52799	3303	СУШКИ с маком 200г 1/25шт ТМ Тимоша	\N	\N	1524.00	уп (25 шт)	1	244	t	2025-12-07 13:19:18.824	2025-12-07 13:19:18.824	61.00	шт	25	только уп
52800	3303	КОНФЕТЫ 1кг молочные Тоффи Мягкая карамель в шоколаде с мармеладом из клюквы ТМ Победа	\N	\N	2226.00	шт	1	50	t	2025-12-07 13:19:18.837	2025-12-07 13:19:18.837	1113.00	шт	2	поштучно
52801	3303	КОНФЕТЫ 200гр Курага в глазури 1/10шт ТМ Тимоша	\N	\N	1943.00	шт	1	117	t	2025-12-07 13:19:18.861	2025-12-07 13:19:18.861	194.00	шт	10	поштучно
52802	3303	КОНФЕТЫ 200гр Чернослив в глазури 1/10шт ТМ Тимоша	\N	\N	1943.00	шт	1	117	t	2025-12-07 13:19:18.872	2025-12-07 13:19:18.872	194.00	шт	10	поштучно
52803	3303	КОНФЕТЫ Нива 250гр	\N	\N	329.00	шт	1	10	t	2025-12-07 13:19:18.885	2025-12-07 13:19:18.885	329.00	шт	1	поштучно
52804	3303	ПЕЧЕНЬЕ 120гр Чоко Пай	\N	\N	1702.00	шт	1	9	t	2025-12-07 13:19:18.896	2025-12-07 13:19:18.896	85.00	шт	20	поштучно
52805	3303	ПЕЧЕНЬЕ 180гр Чоко Пай	\N	\N	2061.00	шт	1	526	t	2025-12-07 13:19:18.906	2025-12-07 13:19:18.906	129.00	шт	16	поштучно
52806	3303	ПЕЧЕНЬЕ 360гр Чоко Пай	\N	\N	1987.00	шт	1	670	t	2025-12-07 13:19:18.918	2025-12-07 13:19:18.918	248.00	шт	8	поштучно
52807	3303	КОНФЕТЫ 150гр Мишки в лесу с начинкой и вафельной крошкой ТМ Победа	\N	\N	5658.00	шт	1	92	t	2025-12-07 13:19:18.948	2025-12-07 13:19:18.948	283.00	шт	20	поштучно
52808	3303	КОНФЕТЫ 150гр Соната с лесным орехом и ореховым кремом ТМ Победа	\N	\N	5267.00	шт	1	87	t	2025-12-07 13:19:18.962	2025-12-07 13:19:18.962	263.00	шт	20	поштучно
52809	3303	КОНФЕТЫ 180гр Трюфели каппучино с кусочками печенья ТМ Победа	\N	\N	8453.00	шт	1	72	t	2025-12-07 13:19:18.974	2025-12-07 13:19:18.974	402.00	шт	21	поштучно
52810	3303	КОНФЕТЫ 180гр Трюфели шоколадные  с ликером Айриш крем посыпанные темным какао ТМ Победа	\N	\N	8453.00	шт	1	18	t	2025-12-07 13:19:18.986	2025-12-07 13:19:18.986	402.00	шт	21	поштучно
52811	3303	КОНФЕТЫ 180гр Трюфели шоколадные посыпанные темным какао ТМ Победа	\N	\N	8453.00	шт	1	15	t	2025-12-07 13:19:18.996	2025-12-07 13:19:18.996	402.00	шт	21	поштучно
52812	3303	КОНФЕТЫ 250гр Мишки в лесу с начинкой и вафельной крошкой ТМ Победа	\N	\N	8280.00	шт	1	11	t	2025-12-07 13:19:19.007	2025-12-07 13:19:19.007	414.00	шт	20	поштучно
52813	3303	КОНФЕТЫ  Мишки в лесу с нач в горьк шок без сахара 1,5кг ТМ Победа	\N	\N	2044.00	уп (2 шт)	1	21	t	2025-12-07 13:19:19.017	2025-12-07 13:19:19.017	1363.00	кг	2	только уп
52814	3303	КОНФЕТЫ AMARE с начинкой со вкусом вареной сгущенки и карамельной крошкой 2кг ТМ Победа	\N	\N	2082.00	уп (2 шт)	1	16	t	2025-12-07 13:19:19.035	2025-12-07 13:19:19.035	1041.00	кг	2	только уп
52815	3303	КОНФЕТЫ Соната в молочном шоколаде без сахара 1,5кг ТМ Победа	\N	\N	2122.00	уп (2 шт)	1	11	t	2025-12-07 13:19:19.045	2025-12-07 13:19:19.045	1415.00	кг	2	только уп
52816	3303	КОНФЕТЫ Соната с лесным орехом и ореховым кремом 2кг ТМ Победа	\N	\N	2617.00	уп (2 шт)	1	72	t	2025-12-07 13:19:19.056	2025-12-07 13:19:19.056	1309.00	кг	2	только уп
52817	3303	КОНФЕТЫ Трюфели каппучино с кусочками печенья 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	36	t	2025-12-07 13:19:19.068	2025-12-07 13:19:19.068	1770.00	кг	2	только уп
52818	3303	КОНФЕТЫ Трюфели шоколадные  в темном какао 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	20	t	2025-12-07 13:19:19.079	2025-12-07 13:19:19.079	1770.00	кг	2	только уп
52819	3303	КОНФЕТЫ Трюфели шоколадные  в темном какао без сахара 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	12	t	2025-12-07 13:19:19.102	2025-12-07 13:19:19.102	1770.00	кг	2	только уп
52820	3303	КОНФЕТЫ Трюфели шоколадные с коньяком без сахара 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	12	t	2025-12-07 13:19:19.114	2025-12-07 13:19:19.114	1770.00	кг	2	только уп
52821	3303	КОНФЕТЫ Трюфели шоколадные с кусочками абрикоса 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	18	t	2025-12-07 13:19:19.124	2025-12-07 13:19:19.124	1770.00	кг	2	только уп
52822	3303	КОНФЕТЫ Трюфели шоколадные с ликером айриш крем 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	16	t	2025-12-07 13:19:19.135	2025-12-07 13:19:19.135	1770.00	кг	2	только уп
52823	3303	КОНФЕТЫ Трюфели шоколадные с ликером айриш крем без сахара 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	20	t	2025-12-07 13:19:19.144	2025-12-07 13:19:19.144	1770.00	кг	2	только уп
52824	3303	КОНФЕТЫ Чаржед в горьком шоколаде без сахара 1,5кг ТМ Победа	\N	\N	2622.00	уп (2 шт)	1	27	t	2025-12-07 13:19:19.154	2025-12-07 13:19:19.154	1748.00	кг	2	только уп
52825	3303	КОНФЕТЫ Чаржед в молочном шоколаде без сахара 1,5кг ТМ Победа	\N	\N	2622.00	уп (2 шт)	1	29	t	2025-12-07 13:19:19.165	2025-12-07 13:19:19.165	1748.00	кг	2	только уп
52826	3303	ПАСТА арахисовая с кусочками арахиса 250гр пл/б ТМ Империя Соусов	\N	\N	1801.00	шт	1	62	t	2025-12-07 13:19:19.174	2025-12-07 13:19:19.174	300.00	шт	6	поштучно
52827	3310	Сало Богородское в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	810.00	шт	1	116	t	2025-12-07 13:19:19.187	2025-12-07 13:19:19.187	810.00	шт	1	поштучно
52828	3310	Сало Домашнее в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	822.00	шт	1	218	t	2025-12-07 13:19:19.198	2025-12-07 13:19:19.198	822.00	шт	1	поштучно
52829	3310	РЕБРЫШКИ свиные Пикантные в/к с/м в/уп (1шт~0,4кг) 1/10-12кг ТМ Алтайский купец	\N	\N	9439.00	уп (12 шт)	1	6	t	2025-12-07 13:19:19.211	2025-12-07 13:19:19.211	816.00	кг	12	только уп
52830	3310	САЛО Народное в/к с/м в/уп 1/10-12кг ТМ Алтайский купец	\N	\N	6785.00	уп (12 шт)	1	8	t	2025-12-07 13:19:19.221	2025-12-07 13:19:19.221	575.00	кг	12	только уп
52831	3310	САЛО Шпик соленый Домашний Премиум в/к с/м в/уп (1шт ~ 1,5кг) 1/10-13кг ТМ Алтайский купец	\N	\N	11740.00	уп (12 шт)	1	11	t	2025-12-07 13:19:19.255	2025-12-07 13:19:19.255	954.00	кг	12	только уп
52832	3310	САЛО Шпик соленый Домашний Премиум в/к с/м в/уп (1шт~0,3кг) 1/10-13кг ТМ Алтайский купец	\N	\N	12313.00	уп (13 шт)	1	14	t	2025-12-07 13:19:19.312	2025-12-07 13:19:19.312	954.00	кг	13	только уп
52833	3310	САЛО Шпик соленый Копченый Закусочный в/к с/м в/уп (1шт~0,3кг) 1/5-7кг ТМ Алтайский купец	\N	\N	4523.00	уп (6 шт)	1	30	t	2025-12-07 13:19:19.327	2025-12-07 13:19:19.327	793.00	кг	6	только уп
52834	3310	САЛО Шпик соленый с укропом в/к с/м в/уп (1шт~1,5кг) 1/10-13кг ТМ Алтайский купец	\N	\N	8776.00	уп (11 шт)	1	9	t	2025-12-07 13:19:19.373	2025-12-07 13:19:19.373	793.00	кг	11	только уп
52835	3310	САЛО Шпик соленый с чесноком в/к с/м в/уп (1шт~0,3кг) 1/8-10кг ТМ Алтайский купец	\N	\N	6665.00	уп (8 шт)	1	17	t	2025-12-07 13:19:19.384	2025-12-07 13:19:19.384	793.00	кг	8	только уп
52836	3310	ГРУДИНКА свиная фас в/к Пикантная с/м в/уп (1шт~0,4кг) ТМ Алтайский купец	\N	\N	5548.00	уп (7 шт)	1	11	t	2025-12-07 13:19:19.399	2025-12-07 13:19:19.399	770.00	кг	7	только уп
52837	3310	ГРУДИНКА свиная фас соленая с паприкой с/м в/уп (1шт-150гр) ТМ Алтайский купец	\N	\N	4278.00	уп (24 шт)	1	69	t	2025-12-07 13:19:19.41	2025-12-07 13:19:19.41	178.00	шт	24	только уп
52838	3310	ГРУДИНКА свиная фас соленая с черным перцем с/м в/уп (1шт-150гр) ТМ Алтайский купец	\N	\N	4278.00	уп (24 шт)	1	52	t	2025-12-07 13:19:19.421	2025-12-07 13:19:19.421	178.00	шт	24	только уп
52839	3310	ГРУДИНКА свиная фас соленая с/м в/уп в/уп (1шт~0,3кг) ТМ Алтайский купец	\N	\N	7535.00	уп (11 шт)	1	58	t	2025-12-07 13:19:19.431	2025-12-07 13:19:19.431	683.00	кг	11	только уп
52840	3310	ГРУДИНКА свиная фас соленая с/м вес ТМ Алтайский купец	\N	\N	13594.00	уп (20 шт)	1	12	t	2025-12-07 13:19:19.443	2025-12-07 13:19:19.443	683.00	кг	20	только уп
52841	3310	РЕБРЫШКИ свиные фас в/к с/м в/уп (1шт ~ 0,3кг) 1/10-13кг ТМ БАРС	\N	\N	8395.00	уп (10 шт)	1	8	t	2025-12-07 13:19:19.453	2025-12-07 13:19:19.453	839.00	кг	10	только уп
52842	3310	ХРЯЩИ свиные Фирменные в/к в/уп (1шт ~ 0,3кг) 1/10-12кг ТМ БАРС	\N	\N	8510.00	уп (10 шт)	1	34	t	2025-12-07 13:19:19.463	2025-12-07 13:19:19.463	851.00	кг	10	только уп
52843	3310	ГРУДИНКА свиная вес в/к Деревенская с/м (1шт ~ 1,2кг) ТМ БАРС ТОЛЬКО МЕСТАМИ	\N	\N	8880.00	уп (11 шт)	1	88	t	2025-12-07 13:19:19.474	2025-12-07 13:19:19.474	807.00	кг	11	только уп
54521	3395	КАРТОФЕЛЬ Фри 450гр ТМ Морозко Green	\N	\N	2852.00	шт	1	163	t	2025-12-07 13:19:49.188	2025-12-07 13:19:49.188	178.00	шт	16	поштучно
52844	3310	ГРУДИНКА свиная вес соленая в зелени с/м в/уп (1шт ~ 3кг) ТМ БАРС ТОЛЬКО МЕСТАМИ	\N	\N	10436.00	уп (15 шт)	1	16	t	2025-12-07 13:19:19.488	2025-12-07 13:19:19.488	696.00	кг	15	только уп
52845	3310	ГРУДИНКА свиная вес соленая Летняя с/м в/уп (1шт ~ 3кг) ТМ БАРС	\N	\N	10436.00	уп (15 шт)	1	31	t	2025-12-07 13:19:19.505	2025-12-07 13:19:19.505	696.00	кг	15	только уп
52846	3310	ГРУДИНКА свиная фас соленая в зелени с/м в/уп (1шт ~ 0,3кг) ТМ БАРС	\N	\N	8349.00	уп (12 шт)	1	9	t	2025-12-07 13:19:19.515	2025-12-07 13:19:19.515	696.00	кг	12	только уп
52847	3310	ГРУДИНКА свиная фас соленая Домашняя с/м в/уп (1шт ~ 0,3кг) ТМ БАРС	\N	\N	9741.00	уп (14 шт)	1	37	t	2025-12-07 13:19:19.526	2025-12-07 13:19:19.526	696.00	кг	14	только уп
52848	3310	САЛО свинина вес вар Сало Народное с/м в/уп вес (1шт ~ 1кг) ТМ БАРС	\N	\N	8982.00	уп (11 шт)	1	31	t	2025-12-07 13:19:19.536	2025-12-07 13:19:19.536	816.00	кг	11	только уп
52849	3310	САЛО свинина фас вар Сало Народное с/м в/уп (1шт ~ 0,3кг) ТМ БАРС	\N	\N	8982.00	уп (11 шт)	1	34	t	2025-12-07 13:19:19.545	2025-12-07 13:19:19.545	816.00	кг	11	только уп
52850	3314	ПРОДУКТ молокосодержащий Моцарелла полутвердый с змж Original Alti (1шт~2кг) батон	\N	\N	1426.00	шт	1	300	t	2025-12-07 13:19:19.555	2025-12-07 13:19:19.555	1426.00	шт	1	поштучно
52851	3314	ПРОДУКТ полутвердый вес Российский (1шт~2,5кг) брус 50%  ТМ Простонародный	\N	\N	1509.00	шт	1	300	t	2025-12-07 13:19:19.572	2025-12-07 13:19:19.572	1509.00	шт	1	поштучно
52852	3314	СЫР вес "Брест-Литовск Голландский" 45% полутвердый (1шт~3,5кг) брус ТМ Савушкин продукт	\N	\N	3360.00	шт	1	193	t	2025-12-07 13:19:19.583	2025-12-07 13:19:19.583	3360.00	шт	1	поштучно
52853	3314	СЫР вес "Брест-Литовск Мраморный" 45% полутвердый (1шт~3,5кг) брус ТМ Брест-Литовск Беларусь	\N	\N	3340.00	шт	1	99	t	2025-12-07 13:19:19.596	2025-12-07 13:19:19.596	3340.00	шт	1	поштучно
52854	3314	СЫР вес "Брест-Литовск Пошехонский" 45% полутвердый (1шт~3,5кг) брус ТМ Савушкин продукт	\N	\N	10663.00	кг	1	94	t	2025-12-07 13:19:19.608	2025-12-07 13:19:19.608	960.00	кг	11	поштучно
52855	3314	СЫР вес "Брест-Литовск Российский" 50% полутвердый (1шт~3,5кг) брус ТМ Савушкин продукт	\N	\N	3360.00	шт	1	300	t	2025-12-07 13:19:19.618	2025-12-07 13:19:19.618	3360.00	шт	1	поштучно
52856	3314	СЫР вес "Брест-Литовск Финский" 45% полутвердый (1шт~3,5кг) брус ТМ Савушкин продукт	\N	\N	3360.00	шт	1	110	t	2025-12-07 13:19:19.629	2025-12-07 13:19:19.629	3360.00	шт	1	поштучно
52857	3314	СЫР вес Белорусское Золото 45% (1шт~2кг) кубик ТМ Воложин Беларусь	\N	\N	1851.00	шт	1	177	t	2025-12-07 13:19:19.686	2025-12-07 13:19:19.686	1851.00	шт	1	поштучно
52858	3314	СЫР вес Великокняжеский с ароматом топленого молока 46% (1шт~3,5кг) брус ТМ Брест-Литовск Беларусь	\N	\N	3340.00	шт	1	72	t	2025-12-07 13:19:19.697	2025-12-07 13:19:19.697	3340.00	шт	1	поштучно
52859	3314	СЫР вес Голландский люкс 45% (1шт~1,7кг) шар ТМ Молодея Беларусь	\N	\N	1574.00	шт	1	206	t	2025-12-07 13:19:19.708	2025-12-07 13:19:19.708	1574.00	шт	1	поштучно
52860	3314	СЫР вес Ламберт голд 45% (1шт~1,7кг) шар ТМ Молодея Беларусь	\N	\N	1574.00	шт	1	288	t	2025-12-07 13:19:19.72	2025-12-07 13:19:19.72	1574.00	шт	1	поштучно
52861	3314	СЫР вес Моцарелла 42% (1шт~3,5кг) брус ТМ La Paulina Аргентина	\N	\N	4004.00	шт	1	300	t	2025-12-07 13:19:19.738	2025-12-07 13:19:19.738	4004.00	шт	1	поштучно
52862	3314	СЫР вес Моцарелла Пицца 40% полутвердый (1шт-1кг) ТМ Бонфесто Туровский МК	\N	\N	6854.00	кг	1	43	t	2025-12-07 13:19:19.763	2025-12-07 13:19:19.763	857.00	кг	8	поштучно
52863	3314	СЫР вес Пармезан 42% (1шт~2,5 кг) брус ТМ Ricrem	\N	\N	4396.00	шт	1	227	t	2025-12-07 13:19:19.781	2025-12-07 13:19:19.781	4396.00	шт	1	поштучно
52864	3314	СЫР вес Сметанковый 50% (1шт~3,5кг) брус ТМ Брест-Литовск Беларусь	\N	\N	3360.00	шт	1	7	t	2025-12-07 13:19:19.815	2025-12-07 13:19:19.815	3360.00	шт	1	поштучно
52865	3314	СЫР Колосок 100гр СПК	\N	\N	8453.00	шт	1	34	t	2025-12-07 13:19:19.826	2025-12-07 13:19:19.826	169.00	шт	50	поштучно
52866	3314	СЫР Колосок копченый 100гр СПК	\N	\N	8453.00	шт	1	300	t	2025-12-07 13:19:19.837	2025-12-07 13:19:19.837	169.00	шт	50	поштучно
52867	3314	СЫР Сарыбалык рассольный копченый  100гр СибБарс	\N	\N	8798.00	шт	1	6	t	2025-12-07 13:19:19.854	2025-12-07 13:19:19.854	176.00	шт	50	поштучно
52868	3314	СЫР Сочинский рассольный 100гр СибБарс	\N	\N	9545.00	шт	1	13	t	2025-12-07 13:19:19.865	2025-12-07 13:19:19.865	191.00	шт	50	поштучно
52869	3314	СЫР Сочинский рассольный копченый 100гр СибБарс	\N	\N	9545.00	шт	1	16	t	2025-12-07 13:19:19.875	2025-12-07 13:19:19.875	191.00	шт	50	поштучно
52870	3314	СЫР Спагетти Саргуль рассольный 100гр вкус Маринованые огурцы	\N	\N	8798.00	шт	1	39	t	2025-12-07 13:19:19.887	2025-12-07 13:19:19.887	176.00	шт	50	поштучно
52871	3314	СЫР Спагетти Саргуль рассольный 100гр со вкусом Васаби СибБарс	\N	\N	8798.00	шт	1	38	t	2025-12-07 13:19:19.903	2025-12-07 13:19:19.903	176.00	шт	50	поштучно
52872	3314	СЫР Спагетти Саргуль рассольный копченый 100гр СибБарс	\N	\N	8798.00	шт	1	18	t	2025-12-07 13:19:19.914	2025-12-07 13:19:19.914	176.00	шт	50	поштучно
52873	3314	СЫР фас Bonfesto Моцарелла Пицца 250гр 40% 1/6шт Туровский МК	\N	\N	1566.00	шт	1	24	t	2025-12-07 13:19:19.926	2025-12-07 13:19:19.926	261.00	шт	6	поштучно
52874	3314	СЫР фас Bonfesto Сулугуни 180гр 40% 1/6шт Туровский МК	\N	\N	1497.00	шт	1	155	t	2025-12-07 13:19:19.937	2025-12-07 13:19:19.937	250.00	шт	6	поштучно
52875	3314	СЫР-БРУС Ricrem 180гр Пармезан 42% твердый Аргентина	\N	\N	3303.00	шт	1	139	t	2025-12-07 13:19:19.947	2025-12-07 13:19:19.947	413.00	шт	8	поштучно
52876	3314	СЫР-БРУС SVEZA Моцарелла для пиццы 200гр 40%	\N	\N	2415.00	шт	1	35	t	2025-12-07 13:19:19.958	2025-12-07 13:19:19.958	241.00	шт	10	поштучно
52877	3314	СЫР-БРУС SVEZA Сулугуни 200гр 40%	\N	\N	2415.00	шт	1	109	t	2025-12-07 13:19:19.968	2025-12-07 13:19:19.968	241.00	шт	10	поштучно
52878	3314	СЫР-БРУС Брест-Литовск 200гр Гауда 45% полутвердый Беларусь	\N	\N	3013.00	шт	1	185	t	2025-12-07 13:19:19.978	2025-12-07 13:19:19.978	301.00	шт	10	поштучно
24974	2755	МАСЛО "Алтай" 0,9л подсолнечное рафинированное Высший сорт *	\N	\N	1988.00	уп (15 шт)	1	42	f	2025-11-10 01:55:18.447	2025-11-22 01:30:48.533	132.50	шт	15	\N
52879	3314	СЫР-БРУС Брест-Литовск 200гр Голландский 45% полутвердый Беларусь	\N	\N	3013.00	шт	1	300	t	2025-12-07 13:19:19.999	2025-12-07 13:19:19.999	301.00	шт	10	поштучно
52880	3314	СЫР-БРУС Брест-Литовск 200гр Классический 45% полутвердый Беларусь	\N	\N	3013.00	шт	1	300	t	2025-12-07 13:19:20.018	2025-12-07 13:19:20.018	301.00	шт	10	поштучно
52881	3314	СЫР-БРУС Брест-Литовск 200гр Легкий 35% полутвердый	\N	\N	3013.00	шт	1	282	t	2025-12-07 13:19:20.032	2025-12-07 13:19:20.032	301.00	шт	10	поштучно
52882	3314	СЫР-БРУС Брест-Литовск 200гр Российский 50% полутвердый	\N	\N	3013.00	шт	1	300	t	2025-12-07 13:19:20.045	2025-12-07 13:19:20.045	301.00	шт	10	поштучно
52883	3314	СЫР-БРУС Брест-Литовск 200гр с аром.топл.молока 45% полутвердый	\N	\N	3013.00	шт	1	210	t	2025-12-07 13:19:20.057	2025-12-07 13:19:20.057	301.00	шт	10	поштучно
52884	3314	СЫР-БРУС Брест-Литовск 200гр Сливочный 50% полутвердый	\N	\N	3013.00	шт	1	300	t	2025-12-07 13:19:20.068	2025-12-07 13:19:20.068	301.00	шт	10	поштучно
52885	3314	СЫР-БРУС Брест-Литовск 200гр Тильзитер 45% полутвердый	\N	\N	3013.00	шт	1	300	t	2025-12-07 13:19:20.078	2025-12-07 13:19:20.078	301.00	шт	10	поштучно
52886	3314	СЫР-БРУС Брест-Литовск 200гр Финский 45% полутвердый	\N	\N	3013.00	шт	1	283	t	2025-12-07 13:19:20.089	2025-12-07 13:19:20.089	301.00	шт	10	поштучно
52887	3314	СЫР-БРУС Брест-Литовск 200гр Чеддер 45% полутвердый Беларусь	\N	\N	3013.00	шт	1	215	t	2025-12-07 13:19:20.104	2025-12-07 13:19:20.104	301.00	шт	10	поштучно
52888	3314	СЫР-БРУС Король Севера 180гр  45% твердый	\N	\N	2944.00	шт	1	92	t	2025-12-07 13:19:20.114	2025-12-07 13:19:20.114	294.00	шт	10	поштучно
52889	3314	СЫР-НАРЕЗКА Брест-Литовский Голландский полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-07 13:19:20.125	2025-12-07 13:19:20.125	230.00	шт	8	поштучно
52890	3314	СЫР-НАРЕЗКА Брест-Литовский Классический полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-07 13:19:20.167	2025-12-07 13:19:20.167	230.00	шт	8	поштучно
52891	3314	СЫР-НАРЕЗКА Брест-Литовский Легкий полутвердый 130гр 35% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-07 13:19:20.179	2025-12-07 13:19:20.179	230.00	шт	8	поштучно
52892	3314	СЫР-НАРЕЗКА Брест-Литовский Российский полутвердый 130гр 50% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-07 13:19:20.189	2025-12-07 13:19:20.189	230.00	шт	8	поштучно
52893	3314	СЫР-НАРЕЗКА Брест-Литовский Сливочный полутвердый 150гр 50% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-07 13:19:20.2	2025-12-07 13:19:20.2	230.00	шт	8	поштучно
52894	3314	СЫР-НАРЕЗКА Брест-Литовский Тильзитер полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-07 13:19:20.211	2025-12-07 13:19:20.211	230.00	шт	8	поштучно
52895	3314	СЫР-НАРЕЗКА Брест-Литовский Финский полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	234	t	2025-12-07 13:19:20.222	2025-12-07 13:19:20.222	230.00	шт	8	поштучно
52896	3314	СЫР-НАРЕЗКА Брест-Литовский Чеддер полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	290	t	2025-12-07 13:19:20.233	2025-12-07 13:19:20.233	230.00	шт	8	поштучно
52897	3314	СЫР брынза легкая Сербская 450гр 22% с сывороткой 515гр Млекара Сербия	\N	\N	2056.00	шт	1	140	t	2025-12-07 13:19:20.249	2025-12-07 13:19:20.249	343.00	шт	6	поштучно
52898	3314	СЫР брынза Сербская 200гр 40% с сывороткой 230гр Млекара Сербия	\N	\N	2553.00	шт	1	55	t	2025-12-07 13:19:20.268	2025-12-07 13:19:20.268	213.00	шт	12	поштучно
52899	3314	СЫР брынза Сербская 450гр 40% с сывороткой 515гр Млекара Сербия	\N	\N	2898.00	шт	1	7	t	2025-12-07 13:19:20.29	2025-12-07 13:19:20.29	483.00	шт	6	поштучно
52900	3314	СЫР мягкий Bonfesto Cream Cheese 500гр 70% МК Туровский Беларусь	\N	\N	3208.00	шт	1	300	t	2025-12-07 13:19:20.3	2025-12-07 13:19:20.3	535.00	шт	6	поштучно
52901	3314	СЫР мягкий Bonfesto Cream Cheese воздушный вяленые томаты 125гр МК Туровский Беларусь	\N	\N	1224.00	шт	1	105	t	2025-12-07 13:19:20.311	2025-12-07 13:19:20.311	153.00	шт	8	поштучно
52902	3314	СЫР мягкий Bonfesto Cream Cheese воздушный сливочный 125гр МК Туровский Беларусь	\N	\N	1155.00	шт	1	216	t	2025-12-07 13:19:20.375	2025-12-07 13:19:20.375	144.00	шт	8	поштучно
52903	3314	СЫР мягкий Bonfesto Cream Cheese классик 400гр МК Туровский Беларусь	\N	\N	2498.00	шт	1	134	t	2025-12-07 13:19:20.414	2025-12-07 13:19:20.414	416.00	шт	6	поштучно
52904	3314	СЫР мягкий Bonfesto Cream Cheese креветки и зелень140гр МК Туровский Беларусь	\N	\N	1042.00	шт	1	262	t	2025-12-07 13:19:20.431	2025-12-07 13:19:20.431	174.00	шт	6	поштучно
52905	3314	СЫР мягкий Bonfesto Cream Cheese сливочный 140гр МК Туровский Беларусь	\N	\N	959.00	шт	1	256	t	2025-12-07 13:19:20.442	2025-12-07 13:19:20.442	160.00	шт	6	поштучно
52906	3314	СЫР мягкий Bonfesto Cream Cheese экстрамягкий 400гр МК Туровский Беларусь	\N	\N	2098.00	шт	1	30	t	2025-12-07 13:19:20.521	2025-12-07 13:19:20.521	350.00	шт	6	поштучно
52907	3314	СЫР мягкий Bonfesto Mascarpone 500гр 78% МК Туровский Беларусь	\N	\N	4678.00	шт	1	205	t	2025-12-07 13:19:20.536	2025-12-07 13:19:20.536	780.00	шт	6	поштучно
52908	3314	СЫР мягкий Bonfesto Ricotta Light 250гр 40% МК Туровский Беларусь	\N	\N	1056.00	шт	1	32	t	2025-12-07 13:19:20.547	2025-12-07 13:19:20.547	176.00	шт	6	поштучно
52909	3314	СЫР мягкий Bonfesto Ricotta Light 500гр 40% МК Туровский Беларусь	\N	\N	1766.00	шт	1	85	t	2025-12-07 13:19:20.567	2025-12-07 13:19:20.567	294.00	шт	6	поштучно
52910	3314	СЫР мягкий Bonfesto Мascarpone 250гр 78% МК Туровский Беларусь	\N	\N	2201.00	шт	1	240	t	2025-12-07 13:19:20.579	2025-12-07 13:19:20.579	367.00	шт	6	поштучно
52911	3314	СЫР мягкий а ла Каймак 150гр 70% стаканчик Mlekara Сербия	\N	\N	2263.00	шт	1	296	t	2025-12-07 13:19:20.613	2025-12-07 13:19:20.613	189.00	шт	12	поштучно
52912	3314	СЫР мягкий а ла Каймак 250гр 70% стаканчик Mlekara Сербия	\N	\N	2732.00	шт	1	48	t	2025-12-07 13:19:20.626	2025-12-07 13:19:20.626	228.00	шт	12	поштучно
24982	2755	МАСЛО "Я Люблю готовить" 1л подсолнечное рафинированное	\N	\N	2550.00	уп (15 шт)	1	300	f	2025-11-10 01:55:18.836	2025-11-22 01:30:48.533	170.00	шт	15	\N
24988	2755	Сахар весовой 50кг	\N	\N	4335.00	уп (50 шт)	1	500	f	2025-11-10 01:55:19.105	2025-11-22 01:30:48.533	86.70	кг	50	\N
52913	3314	СЫР Мягкий Хохланд Профессионал Фетакса 480гр в рассоле	\N	\N	2270.00	шт	1	120	t	2025-12-07 13:19:20.64	2025-12-07 13:19:20.64	378.00	шт	6	поштучно
52914	3314	СЫР творожный Cremette Professional 10 кг 65% ведро	\N	\N	8453.00	шт	1	300	t	2025-12-07 13:19:20.652	2025-12-07 13:19:20.652	8453.00	шт	1	поштучно
52915	3314	СЫР Творожный Cremette Professional 2,2 кг 65%  ведро	\N	\N	5899.00	шт	1	300	t	2025-12-07 13:19:20.666	2025-12-07 13:19:20.666	1966.00	шт	3	поштучно
52916	3314	СЫР творожный SVEZA Воздушный овощи гриль 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	175	t	2025-12-07 13:19:20.679	2025-12-07 13:19:20.679	167.00	шт	6	поштучно
52917	3314	СЫР творожный SVEZA Воздушный с авокадо 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	128	t	2025-12-07 13:19:20.689	2025-12-07 13:19:20.689	167.00	шт	6	поштучно
52918	3314	СЫР творожный SVEZA Воздушный с зеленью 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	300	t	2025-12-07 13:19:20.7	2025-12-07 13:19:20.7	167.00	шт	6	поштучно
52919	3314	СЫР творожный SVEZA Воздушный сливочный 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	300	t	2025-12-07 13:19:20.712	2025-12-07 13:19:20.712	167.00	шт	6	поштучно
52920	3314	СЫР творожный SVEZA легкий 35% 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	285	t	2025-12-07 13:19:20.73	2025-12-07 13:19:20.73	167.00	шт	6	поштучно
52921	3314	СЫР творожный SVEZA с зеленью 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	193	t	2025-12-07 13:19:20.741	2025-12-07 13:19:20.741	167.00	шт	6	поштучно
52922	3314	ДОП Сыр Президент плав "MY CHEESE ВАСАБИ" 51% 125гр ТМ Президент	\N	\N	938.00	шт	1	7	t	2025-12-07 13:19:20.753	2025-12-07 13:19:20.753	156.00	шт	6	поштучно
52923	3314	СЫР Белый город плавленный 120гр Сливочный ванна	\N	\N	1811.00	шт	1	6	t	2025-12-07 13:19:20.763	2025-12-07 13:19:20.763	121.00	шт	15	поштучно
52924	3314	СЫР Белый город плавленный 380гр Сливочный ванна	\N	\N	2944.00	шт	1	11	t	2025-12-07 13:19:20.782	2025-12-07 13:19:20.782	368.00	шт	8	поштучно
52925	3314	СЫР плавленный Президент 140гр Ассорти № 1 (2 с ветчиной/4 сливочных/2 с грибами) сегменты	\N	\N	2639.00	шт	1	400	t	2025-12-07 13:19:20.793	2025-12-07 13:19:20.793	176.00	шт	15	поштучно
52926	3314	СЫР плавленный Президент 140гр Ассорти №3 (2 сыр чедр/4 сливочных/2 сыр маасдам) сегменты	\N	\N	2639.00	шт	1	246	t	2025-12-07 13:19:20.806	2025-12-07 13:19:20.806	176.00	шт	15	поштучно
52927	3314	СЫР плавленный Президент 140гр Ветчина сегменты	\N	\N	2639.00	шт	1	245	t	2025-12-07 13:19:20.821	2025-12-07 13:19:20.821	176.00	шт	15	поштучно
52928	3314	СЫР плавленный Президент 140гр Грибы сегменты	\N	\N	2639.00	шт	1	76	t	2025-12-07 13:19:20.835	2025-12-07 13:19:20.835	176.00	шт	15	поштучно
52929	3314	СЫР плавленный Президент 140гр Мааздам сегменты	\N	\N	2639.00	шт	1	182	t	2025-12-07 13:19:20.85	2025-12-07 13:19:20.85	176.00	шт	15	поштучно
52930	3314	СЫР плавленный Президент 140гр Сливочный сегменты	\N	\N	2639.00	шт	1	500	t	2025-12-07 13:19:20.86	2025-12-07 13:19:20.86	176.00	шт	15	поштучно
52931	3314	СЫР плавленный Президент 140гр Чеддер сегменты	\N	\N	2070.00	шт	1	120	t	2025-12-07 13:19:20.871	2025-12-07 13:19:20.871	138.00	шт	15	поштучно
52932	3314	СЫР плавленный Президент 150гр Ветчина тост	\N	\N	2691.00	шт	1	190	t	2025-12-07 13:19:20.903	2025-12-07 13:19:20.903	179.00	шт	15	поштучно
52933	3314	СЫР плавленный Президент 150гр Чизбургер тост	\N	\N	2691.00	шт	1	307	t	2025-12-07 13:19:20.914	2025-12-07 13:19:20.914	179.00	шт	15	поштучно
52934	3314	СЫР плавленный Президент 200гр Ветчина ванна	\N	\N	3864.00	шт	1	287	t	2025-12-07 13:19:20.934	2025-12-07 13:19:20.934	241.00	шт	16	поштучно
52935	3314	СЫР плавленный Президент 200гр Грибы ванна	\N	\N	3864.00	шт	1	76	t	2025-12-07 13:19:20.945	2025-12-07 13:19:20.945	241.00	шт	16	поштучно
52936	3314	СЫР плавленный Президент 200гр Мааздам ванна	\N	\N	3864.00	шт	1	89	t	2025-12-07 13:19:20.963	2025-12-07 13:19:20.963	241.00	шт	16	поштучно
52937	3314	СЫР плавленный Президент 200гр Сливочный ванна	\N	\N	3864.00	шт	1	500	t	2025-12-07 13:19:20.973	2025-12-07 13:19:20.973	241.00	шт	16	поштучно
52938	3314	СЫР плавленный Президент 400гр Маасдам ванна	\N	\N	3496.00	шт	1	24	t	2025-12-07 13:19:20.984	2025-12-07 13:19:20.984	437.00	шт	8	поштучно
52939	3314	СЫР плавленный Президент 50гр Сливочный брусок	\N	\N	2898.00	шт	1	480	t	2025-12-07 13:19:20.994	2025-12-07 13:19:20.994	48.00	шт	60	поштучно
52940	3314	СЫР плавленный Хохланд Профессионал Сливочный 400гр ванна	\N	\N	2436.00	шт	1	184	t	2025-12-07 13:19:21.006	2025-12-07 13:19:21.006	406.00	шт	6	поштучно
52941	3314	Сыр Президент плав 200 шоколад 1/16шт  ванна	\N	\N	3864.00	шт	1	21	t	2025-12-07 13:19:21.017	2025-12-07 13:19:21.017	241.00	шт	16	поштучно
52942	3400	МАЙОНЕЗ EFKO FOOD classic универсальный 67% ведро 10000мл	\N	\N	2277.00	шт	1	200	t	2025-12-07 13:19:21.027	2025-12-07 13:19:21.027	2277.00	шт	1	поштучно
52943	3400	МАЙОНЕЗ EFKO FOOD Special для запекания 67% ведро 10000мл	\N	\N	2703.00	шт	1	200	t	2025-12-07 13:19:21.048	2025-12-07 13:19:21.048	2703.00	шт	1	поштучно
52944	3400	МАЙОНЕЗ Мастер Gurme Оливковый 50,5% дой-пак 350мл	\N	\N	3036.00	шт	1	17	t	2025-12-07 13:19:21.059	2025-12-07 13:19:21.059	126.00	шт	24	поштучно
52945	3400	МАЙОНЕЗ Мечта хозяйки "Классический" 50.5% дой-пак 200мл	\N	\N	2291.00	шт	1	87	t	2025-12-07 13:19:21.108	2025-12-07 13:19:21.108	95.00	шт	24	поштучно
52946	3400	МАЙОНЕЗ Мечта хозяйки "Классический" 50.5% дой-пак 350мл	\N	\N	2944.00	шт	1	200	t	2025-12-07 13:19:21.118	2025-12-07 13:19:21.118	147.00	шт	20	поштучно
52947	3400	МАЙОНЕЗ Мечта хозяйки "Классический" 50.5% дой-пак 700мл	\N	\N	3312.00	шт	1	40	t	2025-12-07 13:19:21.132	2025-12-07 13:19:21.132	276.00	шт	12	поштучно
52948	3400	МАЙОНЕЗ Мечта хозяйки "На перепелинных яйцах" 50.5% дой-пак 700мл	\N	\N	3326.00	шт	1	78	t	2025-12-07 13:19:21.144	2025-12-07 13:19:21.144	277.00	шт	12	поштучно
52949	3400	МАЙОНЕЗ Мечта хозяйки "Оливковый" 50.5% дой-пак 200мл	\N	\N	2429.00	шт	1	81	t	2025-12-07 13:19:21.154	2025-12-07 13:19:21.154	101.00	шт	24	поштучно
52950	3400	МАЙОНЕЗ Мечта хозяйки "Оливковый" 50.5% дой-пак 350мл	\N	\N	3082.00	шт	1	7	t	2025-12-07 13:19:21.164	2025-12-07 13:19:21.164	154.00	шт	20	поштучно
52951	3400	МАЙОНЕЗ Мечта хозяйки "Оливковый" 50.5% дой-пак 700мл	\N	\N	3505.00	шт	1	46	t	2025-12-07 13:19:21.174	2025-12-07 13:19:21.174	292.00	шт	12	поштучно
52952	3400	МАЙОНЕЗ Мечта хозяйки "Провансаль" 67% дой-пак 200мл	\N	\N	2622.00	шт	1	49	t	2025-12-07 13:19:21.187	2025-12-07 13:19:21.187	109.00	шт	24	поштучно
52953	3400	МАЙОНЕЗ Мечта хозяйки "Провансаль" 67% дой-пак 350мл	\N	\N	3174.00	шт	1	30	t	2025-12-07 13:19:21.198	2025-12-07 13:19:21.198	159.00	шт	20	поштучно
52954	3400	МАЙОНЕЗ Мечта хозяйки "Провансаль" 67% дой-пак 700мл	\N	\N	3505.00	шт	1	91	t	2025-12-07 13:19:21.208	2025-12-07 13:19:21.208	292.00	шт	12	поштучно
52955	3400	МАЙОНЕЗ Слобода Провансаль 67% дой-пак 400мл	\N	\N	3671.00	шт	1	200	t	2025-12-07 13:19:21.22	2025-12-07 13:19:21.22	153.00	шт	24	поштучно
52956	3400	МАЙОНЕЗ Слобода Провансаль 67% дой-пак 800мл	\N	\N	3353.00	шт	1	200	t	2025-12-07 13:19:21.233	2025-12-07 13:19:21.233	279.00	шт	12	поштучно
52957	3400	МАЙОНЕЗ Слобода Провансаль Сметанный 67% дой-пак 800мл	\N	\N	3353.00	шт	1	191	t	2025-12-07 13:19:21.292	2025-12-07 13:19:21.292	279.00	шт	12	поштучно
52958	3400	МАЙОНЕЗ Я Люблю Готовить "Домашний" 55% дой-пак 200мл	\N	\N	2208.00	шт	1	57	t	2025-12-07 13:19:21.306	2025-12-07 13:19:21.306	92.00	шт	24	поштучно
52959	3400	МАЙОНЕЗ Я Люблю Готовить "Домашний" 55% дой-пак 390мл	\N	\N	3335.00	шт	1	173	t	2025-12-07 13:19:21.356	2025-12-07 13:19:21.356	167.00	шт	20	поштучно
52960	3400	МАЙОНЕЗ Я Люблю Готовить "Домашний" 55% дой-пак 670мл	\N	\N	3091.00	шт	1	132	t	2025-12-07 13:19:21.372	2025-12-07 13:19:21.372	258.00	шт	12	поштучно
52961	3400	МАЙОНЕЗ Я Люблю Готовить "На перепелинных яйцах" 67% дой-пак 390мл	\N	\N	3749.00	шт	1	83	t	2025-12-07 13:19:21.383	2025-12-07 13:19:21.383	187.00	шт	20	поштучно
52962	3400	МАЙОНЕЗ Я Люблю Готовить "Оливковый" 67% дой-пак 390мл	\N	\N	3749.00	шт	1	113	t	2025-12-07 13:19:21.393	2025-12-07 13:19:21.393	187.00	шт	20	поштучно
52963	3400	МАЙОНЕЗ Я Люблю Готовить Провансаль "Классический" 67% дой-пак 700мл	\N	\N	3616.00	шт	1	169	t	2025-12-07 13:19:21.403	2025-12-07 13:19:21.403	301.00	шт	12	поштучно
52964	3400	МАЙОНЕЗ Я Люблю Готовить Провансаль"Классический" 67% дой-пак 390мл	\N	\N	3611.00	шт	1	98	t	2025-12-07 13:19:21.423	2025-12-07 13:19:21.423	181.00	шт	20	поштучно
52965	3400	СОУС EFKO FOOD Professional сырный 35% 1кг	\N	\N	5877.00	шт	1	58	t	2025-12-07 13:19:21.445	2025-12-07 13:19:21.445	588.00	шт	10	поштучно
52966	3400	СОУС EFKO FOOD Professional цезарь 50,5% 1кг	\N	\N	5865.00	шт	1	20	t	2025-12-07 13:19:21.457	2025-12-07 13:19:21.457	587.00	шт	10	поштучно
52967	3400	СОУС EFKO FOOD Professional чесночный 35% 1кг	\N	\N	5877.00	шт	1	104	t	2025-12-07 13:19:21.472	2025-12-07 13:19:21.472	588.00	шт	10	поштучно
52968	3400	СОУС EFKO FOOD Special барбекю 1кг	\N	\N	5877.00	шт	1	200	t	2025-12-07 13:19:21.482	2025-12-07 13:19:21.482	588.00	шт	10	поштучно
52969	3400	СОУС EFKO FOOD Special горчичный 22% 1кг	\N	\N	6060.00	шт	1	44	t	2025-12-07 13:19:21.493	2025-12-07 13:19:21.493	606.00	шт	10	поштучно
52970	3400	СОУС EFKO FOOD Special грибной 25% 1кг	\N	\N	6060.00	шт	1	20	t	2025-12-07 13:19:21.503	2025-12-07 13:19:21.503	606.00	шт	10	поштучно
52971	3400	СОУС EFKO FOOD Special гриль 30% 1кг	\N	\N	6060.00	шт	1	30	t	2025-12-07 13:19:21.514	2025-12-07 13:19:21.514	606.00	шт	10	поштучно
52972	3400	СОУС EFKO FOOD Special кисло-сладкий 1кг	\N	\N	5877.00	шт	1	53	t	2025-12-07 13:19:21.524	2025-12-07 13:19:21.524	588.00	шт	10	поштучно
52973	3400	СОУС EFKO FOOD Special терияки 1кг	\N	\N	5877.00	шт	1	6	t	2025-12-07 13:19:21.537	2025-12-07 13:19:21.537	588.00	шт	10	поштучно
52974	3400	СОУС заправка Я Люблю готовить "Азиатский микс" 250мл	\N	\N	1380.00	шт	1	12	t	2025-12-07 13:19:21.55	2025-12-07 13:19:21.55	230.00	шт	6	поштучно
52975	3400	СОУС заправка Я Люблю готовить "Итальянский букет и вяленые томаты" 250мл	\N	\N	1359.00	шт	1	30	t	2025-12-07 13:19:21.563	2025-12-07 13:19:21.563	227.00	шт	6	поштучно
52976	3400	СОУС заправка Я Люблю готовить дой-пак "Пряный базилик и пармезан" 250мл	\N	\N	1359.00	шт	1	18	t	2025-12-07 13:19:21.575	2025-12-07 13:19:21.575	227.00	шт	6	поштучно
52977	3400	СОУС заправка Я Люблю готовить дой-пак "Французские пряности и чеснок" 250мл	\N	\N	1380.00	шт	1	12	t	2025-12-07 13:19:21.586	2025-12-07 13:19:21.586	230.00	шт	6	поштучно
52978	3400	СОУС Пиканта дой-пак 280гр Краснодарский	\N	\N	1288.00	шт	1	96	t	2025-12-07 13:19:21.598	2025-12-07 13:19:21.598	81.00	шт	16	поштучно
52979	3400	СОУС Пиканта дой-пак 280гр По грузински острый	\N	\N	2079.00	шт	1	21	t	2025-12-07 13:19:21.623	2025-12-07 13:19:21.623	130.00	шт	16	поштучно
52980	3400	СОУС Пиканта дой-пак 280гр Сладкий чили	\N	\N	2079.00	шт	1	69	t	2025-12-07 13:19:21.653	2025-12-07 13:19:21.653	130.00	шт	16	поштучно
52981	3400	СОУС Пиканта дой-пак 280гр Терияки	\N	\N	1564.00	шт	1	48	t	2025-12-07 13:19:21.666	2025-12-07 13:19:21.666	98.00	шт	16	поштучно
52982	3400	СОУС Пиканта ст/банка 350гр Польпа томаты резаные	\N	\N	1228.00	шт	1	72	t	2025-12-07 13:19:21.679	2025-12-07 13:19:21.679	205.00	шт	6	поштучно
52983	3400	СОУС Пиканта ст/банка 350гр Томатный с базиликом	\N	\N	1228.00	шт	1	132	t	2025-12-07 13:19:21.713	2025-12-07 13:19:21.713	205.00	шт	6	поштучно
52334	3398	N2	\N	\N	15.00	шт	1	\N	f	2025-12-07 08:06:31.155	2025-12-07 08:12:48.73	15.00	шт	1	поштучно
52333	3398	N1	\N	\N	10.00	л	1	\N	f	2025-12-07 08:06:31.137	2025-12-07 08:12:50.967	10.00	л	1	поштучно
52984	3400	СОУС Пиканта ст/банка 350гр Томатный с луком и чесноком	\N	\N	1228.00	шт	1	158	t	2025-12-07 13:19:21.726	2025-12-07 13:19:21.726	205.00	шт	6	поштучно
52985	3400	СОУС Пиканта ст/банка 360гр Томатный с перцем чили Арраббьята	\N	\N	1228.00	шт	1	138	t	2025-12-07 13:19:21.744	2025-12-07 13:19:21.744	205.00	шт	6	поштучно
52986	3400	СОУС Слобода дой-пак 220гр Сырный 60%	\N	\N	2001.00	шт	1	68	t	2025-12-07 13:19:21.759	2025-12-07 13:19:21.759	167.00	шт	12	поштучно
52987	3400	СОУС Слобода дой-пак 220гр Чесночный 60%	\N	\N	2001.00	шт	1	61	t	2025-12-07 13:19:21.771	2025-12-07 13:19:21.771	167.00	шт	12	поштучно
52988	3400	СОУС Соевый 500мл классический Мастер Шифу	\N	\N	1573.00	шт	1	113	t	2025-12-07 13:19:21.783	2025-12-07 13:19:21.783	131.00	шт	12	поштучно
52989	3400	СОУС Стебель Бамбука 280гр к Спагетти	\N	\N	1118.00	шт	1	11	t	2025-12-07 13:19:21.797	2025-12-07 13:19:21.797	93.00	шт	12	поштучно
52990	3400	СОУС Стебель Бамбука 280гр Сладкий	\N	\N	1118.00	шт	1	17	t	2025-12-07 13:19:21.807	2025-12-07 13:19:21.807	93.00	шт	12	поштучно
52991	3400	СОУС Стебель Бамбука 280гр Соевый Классик	\N	\N	1118.00	шт	1	22	t	2025-12-07 13:19:21.818	2025-12-07 13:19:21.818	93.00	шт	12	поштучно
52992	3400	СОУС Стебель Бамбука 300гр дой-пак Чили Карри	\N	\N	911.00	шт	1	114	t	2025-12-07 13:19:21.845	2025-12-07 13:19:21.845	76.00	шт	12	поштучно
52993	3400	СОУС Стебель Бамбука 380гр ст/б Гранатовый Наршараб	\N	\N	1863.00	шт	1	83	t	2025-12-07 13:19:21.858	2025-12-07 13:19:21.858	186.00	шт	10	поштучно
52994	3400	СОУС Тай Со 460мл Соевый Классический	\N	\N	862.00	шт	1	6	t	2025-12-07 13:19:21.884	2025-12-07 13:19:21.884	144.00	шт	6	поштучно
52995	3400	СОУС томатный Я Люблю готовить ст/б "Базилик" 330гр	\N	\N	1394.00	шт	1	75	t	2025-12-07 13:19:21.896	2025-12-07 13:19:21.896	232.00	шт	6	поштучно
52996	3400	СОУС томатный Я Люблю готовить ст/б "Наполетана" 330гр	\N	\N	1394.00	шт	1	75	t	2025-12-07 13:19:21.942	2025-12-07 13:19:21.942	232.00	шт	6	поштучно
52997	3400	СОУС томатный Я Люблю готовить ст/б "Прованские травы" 330гр	\N	\N	1394.00	шт	1	75	t	2025-12-07 13:19:21.982	2025-12-07 13:19:21.982	232.00	шт	6	поштучно
52998	3400	СОУС томатный Я Люблю готовить ст/б "Томатный" 330гр	\N	\N	1394.00	шт	1	75	t	2025-12-07 13:19:22.007	2025-12-07 13:19:22.007	232.00	шт	6	поштучно
52999	3400	СОУС Хохланд Профессионал Blue Cheese пакет 500гр	\N	\N	3634.00	шт	1	50	t	2025-12-07 13:19:22.024	2025-12-07 13:19:22.024	363.00	шт	10	поштучно
53000	3400	СОУС Хохланд Профессионал Чеддер пакет 1кг	\N	\N	5354.00	шт	1	63	t	2025-12-07 13:19:22.037	2025-12-07 13:19:22.037	669.00	шт	8	поштучно
53001	3400	СОУС Хреновина 360гр ст/б ТМ Славянский Дар	\N	\N	824.00	шт	1	31	t	2025-12-07 13:19:22.049	2025-12-07 13:19:22.049	103.00	шт	8	поштучно
53002	3400	СОУС Чили "Острый" 200мл ТМ "Мастер Шифу"  Вьетнам	\N	\N	1352.00	шт	1	200	t	2025-12-07 13:19:22.066	2025-12-07 13:19:22.066	56.00	шт	24	поштучно
53003	3400	СОУС Чили кисло-сладкиц 200мл ТМ Мастер Шифу	\N	\N	1463.00	шт	1	200	t	2025-12-07 13:19:22.084	2025-12-07 13:19:22.084	61.00	шт	24	поштучно
53004	3400	КЕТЧУП EFKO FOOD Special томатный 1кг	\N	\N	3507.00	шт	1	200	t	2025-12-07 13:19:22.095	2025-12-07 13:19:22.095	351.00	шт	10	поштучно
53005	3400	КЕТЧУП МАСТЕР GURME дой-пак 300гр Томатный Первая категория	\N	\N	2346.00	шт	1	95	t	2025-12-07 13:19:22.117	2025-12-07 13:19:22.117	98.00	шт	24	поштучно
53006	3400	КЕТЧУП МЕЧТА ХОЗЯЙКИ дой-пак 350гр Острый Чили	\N	\N	3505.00	шт	1	145	t	2025-12-07 13:19:22.132	2025-12-07 13:19:22.132	146.00	шт	24	поштучно
53007	3400	КЕТЧУП МЕЧТА ХОЗЯЙКИ дой-пак 350гр Шашлычный	\N	\N	3505.00	шт	1	80	t	2025-12-07 13:19:22.147	2025-12-07 13:19:22.147	146.00	шт	24	поштучно
53008	3400	КЕТЧУП Пиканта дой-пак 280гр Острый	\N	\N	2079.00	шт	1	200	t	2025-12-07 13:19:22.158	2025-12-07 13:19:22.158	130.00	шт	16	поштучно
53009	3400	КЕТЧУП Пиканта дой-пак 280гр Томатный	\N	\N	1564.00	шт	1	147	t	2025-12-07 13:19:22.172	2025-12-07 13:19:22.172	98.00	шт	16	поштучно
53010	3400	КЕТЧУП Пиканта дой-пак 280гр Шашлычный	\N	\N	1564.00	шт	1	165	t	2025-12-07 13:19:22.191	2025-12-07 13:19:22.191	98.00	шт	16	поштучно
53011	3400	КЕТЧУП Пиканта дой-пак 480гр Шашлычный	\N	\N	1973.00	шт	1	120	t	2025-12-07 13:19:22.207	2025-12-07 13:19:22.207	164.00	шт	12	поштучно
53012	3400	КЕТЧУП Слобода дой-пак 320гр Гриль Первая категория	\N	\N	3202.00	шт	1	11	t	2025-12-07 13:19:22.22	2025-12-07 13:19:22.22	133.00	шт	24	поштучно
53013	3400	КЕТЧУП Слобода дой-пак 320гр Лечо Высшая категория	\N	\N	3229.00	шт	1	16	t	2025-12-07 13:19:22.233	2025-12-07 13:19:22.233	135.00	шт	24	поштучно
53014	3400	КЕТЧУП Слобода дой-пак 320гр Томатный Высшая категория	\N	\N	3229.00	шт	1	186	t	2025-12-07 13:19:22.244	2025-12-07 13:19:22.244	135.00	шт	24	поштучно
53015	3400	КЕТЧУП Слобода дой-пак 320гр Чесночный Первая категория	\N	\N	3229.00	шт	1	24	t	2025-12-07 13:19:22.255	2025-12-07 13:19:22.255	135.00	шт	24	поштучно
53016	3400	КЕТЧУП Стебель Бамбука дой-пак 300гр Сладкий	\N	\N	2015.00	шт	1	200	t	2025-12-07 13:19:22.268	2025-12-07 13:19:22.268	84.00	шт	24	поштучно
53017	3400	КЕТЧУП Стебель Бамбука дой-пак 300гр Томатный	\N	\N	2015.00	шт	1	6	t	2025-12-07 13:19:22.331	2025-12-07 13:19:22.331	84.00	шт	24	поштучно
53018	3400	КЕТЧУП Стебель Бамбука дой-пак 300гр Шашлычный	\N	\N	2015.00	шт	1	73	t	2025-12-07 13:19:22.39	2025-12-07 13:19:22.39	84.00	шт	24	поштучно
53019	3400	ГОРЧИЦА Мечта хозяйки Русская жгучая 130гр туба	\N	\N	1380.00	шт	1	178	t	2025-12-07 13:19:22.401	2025-12-07 13:19:22.401	69.00	шт	20	поштучно
53020	3317	Крупа Геркулес вес 30кг Горлов	\N	\N	2018.00	уп (30 шт)	1	60	t	2025-12-07 13:19:22.415	2025-12-07 13:19:22.415	67.00	кг	30	только уп
53021	3317	Крупа Горох колотый вес 50кг Зерносервис	\N	\N	4002.00	уп (50 шт)	1	750	t	2025-12-07 13:19:22.43	2025-12-07 13:19:22.43	80.00	кг	50	только уп
53022	3317	Крупа Гречка вес 50кг Вишневый сад	\N	\N	3151.00	уп (50 шт)	1	8850	t	2025-12-07 13:19:22.443	2025-12-07 13:19:22.443	63.00	кг	50	только уп
53023	3317	Крупа Овсяная недробленая вес 50кг	\N	\N	3737.00	уп (50 шт)	1	50	t	2025-12-07 13:19:22.484	2025-12-07 13:19:22.484	75.00	кг	50	только уп
53024	3317	Крупа Рис круглый вес 1/25кг Краснодарский	\N	\N	3335.00	уп (25 шт)	1	875	t	2025-12-07 13:19:22.52	2025-12-07 13:19:22.52	133.00	кг	25	только уп
53025	3317	Крупа Ячневая вес 45кг Ларица	\N	\N	2065.00	уп (45 шт)	1	45	t	2025-12-07 13:19:22.531	2025-12-07 13:19:22.531	46.00	кг	45	только уп
53026	3317	РИС 1 сорт 1/25кг Китай	\N	\N	3134.00	уп (25 шт)	1	1000	t	2025-12-07 13:19:22.591	2025-12-07 13:19:22.591	125.00	кг	25	только уп
53027	3317	РИС 1 сорт 10кг Китай	\N	\N	1254.00	уп (10 шт)	1	400	t	2025-12-07 13:19:22.61	2025-12-07 13:19:22.61	125.00	кг	10	только уп
53028	3317	РИС круглозерный золотой мешок 1/25кг	\N	\N	2444.00	уп (25 шт)	1	6895	t	2025-12-07 13:19:22.64	2025-12-07 13:19:22.64	98.00	кг	25	только уп
53029	3405	СМЕСЬ КОМПОТНАЯ сухофрукты Экстра 1/10 кг	\N	\N	2185.00	уп (10 шт)	1	2500	t	2025-12-07 13:19:22.652	2025-12-07 13:19:22.652	218.00	кг	10	только уп
53030	3317	МАКАРОНЫ "Алмак" Паутинка №11 1/20кг	\N	\N	1490.00	уп (20 шт)	1	860	t	2025-12-07 13:19:22.664	2025-12-07 13:19:22.664	75.00	кг	20	только уп
53031	3317	МАКАРОНЫ "Алмак" Перья рифленые №15 1/18кг	\N	\N	1393.00	уп (18 шт)	1	2304	t	2025-12-07 13:19:22.698	2025-12-07 13:19:22.698	77.00	кг	18	только уп
53032	3317	МАКАРОНЫ "Алмак" Ракушка мелкая №8 1/20кг	\N	\N	1490.00	уп (20 шт)	1	2280	t	2025-12-07 13:19:22.711	2025-12-07 13:19:22.711	75.00	кг	20	только уп
53033	3317	МАКАРОНЫ "Алмак" Рожки №6 1/20кг	\N	\N	1548.00	уп (20 шт)	1	1920	t	2025-12-07 13:19:22.759	2025-12-07 13:19:22.759	77.00	кг	20	только уп
53034	3317	МАКАРОНЫ "Алмак" Рожки витые №4 1/16кг	\N	\N	1238.00	уп (16 шт)	1	2608	t	2025-12-07 13:19:22.79	2025-12-07 13:19:22.79	77.00	кг	16	только уп
53035	3317	МАКАРОНЫ "Алмак" Рожки гладкие №16 1/20кг	\N	\N	1548.00	уп (20 шт)	1	2440	t	2025-12-07 13:19:22.802	2025-12-07 13:19:22.802	77.00	кг	20	только уп
53036	3317	МАКАРОНЫ "Алмак" Рожки с гребешком №13/16кг	\N	\N	1238.00	уп (16 шт)	1	1696	t	2025-12-07 13:19:22.821	2025-12-07 13:19:22.821	77.00	кг	16	только уп
53037	3317	МАКАРОНЫ "Алмак" Сапожок мелкий  №2 1/16кг	\N	\N	1192.00	уп (16 шт)	1	1088	t	2025-12-07 13:19:22.832	2025-12-07 13:19:22.832	75.00	кг	16	только уп
53038	3317	МАКАРОНЫ "Алмак" спиралька №27 1/13кг	\N	\N	1006.00	уп (13 шт)	1	1222	t	2025-12-07 13:19:22.843	2025-12-07 13:19:22.843	77.00	кг	13	только уп
53039	3317	МАКАРОНЫ "Монте Бьянко" 2кг Рожок полубублик №202	\N	\N	803.00	уп (4 шт)	1	23	t	2025-12-07 13:19:22.862	2025-12-07 13:19:22.862	201.00	шт	4	только уп
53040	3398	ВОДОРОСЛИ морские жареные прессованные (Нори) 1уп-100листов 1/50шт ТМ Tamaki № 8 цена за 100 листов	\N	\N	115747.00	шт	1	24	t	2025-12-07 13:19:22.872	2025-12-07 13:19:22.872	2315.00	шт	50	поштучно
53041	3398	ВОДОРОСЛИ морские жареные прессованные (Нори) 1уп-100листов ТМ Tamaki №3	\N	\N	62100.00	шт	1	46	t	2025-12-07 13:19:22.892	2025-12-07 13:19:22.892	1725.00	шт	36	поштучно
53042	3398	ИМБИРЬ розовый маринованный 1,4кг пакет ТМ Мастер Шифу	\N	\N	1828.00	шт	1	155	t	2025-12-07 13:19:22.903	2025-12-07 13:19:22.903	183.00	шт	10	поштучно
53043	3398	ИМБИРЬ розовый маринованный вес имбиря 1кг Китай	\N	\N	2116.00	шт	1	226	t	2025-12-07 13:19:22.915	2025-12-07 13:19:22.915	212.00	шт	10	поштучно
53044	3398	ЛАПША гречневая Соба 300гр ТМ ToDoFood	\N	\N	5888.00	шт	1	451	t	2025-12-07 13:19:22.934	2025-12-07 13:19:22.934	147.00	шт	40	поштучно
53045	3398	ЛАПША Удон пшеничная 300гр ТМ ToDoFood	\N	\N	4830.00	шт	1	400	t	2025-12-07 13:19:22.945	2025-12-07 13:19:22.945	121.00	шт	40	поштучно
53046	3398	ЛАПША яичная Рамен 300гр ТМ ToDoFood	\N	\N	5566.00	шт	1	500	t	2025-12-07 13:19:22.956	2025-12-07 13:19:22.956	139.00	шт	40	поштучно
53047	3398	МУКА темпурная 1кг 1/10шт ТМ ToDoFood	\N	\N	2438.00	шт	1	114	t	2025-12-07 13:19:22.974	2025-12-07 13:19:22.974	244.00	шт	10	поштучно
53048	3398	ПАСТА Том Ям 1кг	\N	\N	10640.00	шт	1	9	t	2025-12-07 13:19:22.986	2025-12-07 13:19:22.986	887.00	шт	12	поштучно
53049	3398	ПРИПРАВА Васаби сухая на основе хрена 1кг ТМ Tamaki Pro Light	\N	\N	5704.00	шт	1	66	t	2025-12-07 13:19:22.998	2025-12-07 13:19:22.998	570.00	шт	10	поштучно
53050	3398	ПРИПРАВА Васаби сухая на основе хрена 1кг ТМ ToDoFood	\N	\N	7337.00	шт	1	9	t	2025-12-07 13:19:23.012	2025-12-07 13:19:23.012	734.00	шт	10	поштучно
53051	3398	РИС среднезерный 25кг ТМ TAMAKI	\N	\N	4686.00	кг	1	500	t	2025-12-07 13:19:23.023	2025-12-07 13:19:23.023	187.00	кг	25	поштучно
53052	3398	СМЕСЬ Оригинальная панировочная 1кг ТМ Tamaki	\N	\N	4292.00	шт	1	96	t	2025-12-07 13:19:23.037	2025-12-07 13:19:23.037	358.00	шт	12	поштучно
53053	3398	СМЕСЬ Темпура панировочная 1кг  ТМ Tamaki Pro	\N	\N	1766.00	шт	1	31	t	2025-12-07 13:19:23.061	2025-12-07 13:19:23.061	147.00	шт	12	поштучно
53054	3398	СОУС Кимчи 1,5л ТМ Tamaki Pro	\N	\N	3898.00	шт	1	16	t	2025-12-07 13:19:23.085	2025-12-07 13:19:23.085	650.00	шт	6	поштучно
53055	3398	СОУС Соевый 0,25л ТМ ToDoFood	\N	\N	1449.00	шт	1	8	t	2025-12-07 13:19:23.108	2025-12-07 13:19:23.108	97.00	шт	15	поштучно
53056	3398	СОУС Соевый 1л ТМ Tamaki	\N	\N	2412.00	шт	1	31	t	2025-12-07 13:19:23.119	2025-12-07 13:19:23.119	268.00	шт	9	поштучно
53057	3398	СОУС Соевый 20л ТМ ToDoFood	\N	\N	2887.00	шт	1	33	t	2025-12-07 13:19:23.13	2025-12-07 13:19:23.13	2887.00	шт	1	поштучно
53058	3398	СОУС Терияки 0,25л ТМ ToDoFood	\N	\N	1880.00	шт	1	186	t	2025-12-07 13:19:23.146	2025-12-07 13:19:23.146	125.00	шт	15	поштучно
53059	3398	СОУС Терияки 1,5л ТМ Tamaki	\N	\N	3277.00	шт	1	174	t	2025-12-07 13:19:23.162	2025-12-07 13:19:23.162	546.00	шт	6	поштучно
53060	3398	СОУС Унаги 0,25л ТМ ToDoFood	\N	\N	2329.00	шт	1	57	t	2025-12-07 13:19:23.173	2025-12-07 13:19:23.173	155.00	шт	15	поштучно
53061	3398	СОУС Унаги 1,8л ТМ Tamaki	\N	\N	5796.00	шт	1	42	t	2025-12-07 13:19:23.185	2025-12-07 13:19:23.185	966.00	шт	6	поштучно
53062	3398	СОУС Унаги Про 1л ТМ ToDoFood	\N	\N	4048.00	шт	1	21	t	2025-12-07 13:19:23.196	2025-12-07 13:19:23.196	506.00	шт	8	поштучно
53063	3398	СОУС Устричный 1л ТМ Tamaki	\N	\N	4802.00	шт	1	40	t	2025-12-07 13:19:23.209	2025-12-07 13:19:23.209	534.00	шт	9	поштучно
53064	3398	СОУС Чили сладкий для курицы 1,5л ТМ Tamaki	\N	\N	3843.00	шт	1	116	t	2025-12-07 13:19:23.225	2025-12-07 13:19:23.225	641.00	шт	6	поштучно
53065	3398	СУХАРИ панировочные Панко 1кг 1/10шт ТМ ToDoFood	\N	\N	3070.00	шт	1	95	t	2025-12-07 13:19:23.237	2025-12-07 13:19:23.237	307.00	шт	10	поштучно
25178	2755	ЧАЙ Ява Зелёный традиционный 100пак	\N	\N	3996.00	уп (18 шт)	1	53	f	2025-11-10 01:55:28.498	2025-11-22 01:30:48.533	222.00	шт	18	\N
25193	2755	КАША овсяная клубника 35гр ТМ Мастер Дак	\N	\N	660.00	уп (30 шт)	1	200	f	2025-11-10 01:55:29.274	2025-11-22 01:30:48.533	22.00	шт	30	\N
53066	3398	СУХАРИ панировочные Панко 1кг ТМ Tamaki	\N	\N	3323.00	шт	1	132	t	2025-12-07 13:19:23.301	2025-12-07 13:19:23.301	332.00	шт	10	поштучно
53067	3398	СУХАРИ панировочные Панко G'old 1кг ТМ Tamaki	\N	\N	3427.00	шт	1	40	t	2025-12-07 13:19:23.312	2025-12-07 13:19:23.312	343.00	шт	10	поштучно
53068	3398	СУХАРИ панировочные Панко Голд 1кг 1/10шт ТМ ToDoFood	\N	\N	3427.00	шт	1	49	t	2025-12-07 13:19:23.323	2025-12-07 13:19:23.323	343.00	шт	10	поштучно
53069	3398	УКСУС Рисовый 20л Premium ТМ Marukai канистра	\N	\N	2417.00	шт	1	72	t	2025-12-07 13:19:23.334	2025-12-07 13:19:23.334	2417.00	шт	1	поштучно
53070	3402	МЕД натуральный 1000гр Гречишный ПЭТ ТМ Гордость Алтая	\N	\N	3215.00	шт	1	29	t	2025-12-07 13:19:23.369	2025-12-07 13:19:23.369	536.00	шт	6	поштучно
53071	3402	МЕД натуральный 1000гр Цветочный ПЭТ ТМ Гордость Алтая	\N	\N	3478.00	шт	1	42	t	2025-12-07 13:19:23.382	2025-12-07 13:19:23.382	580.00	шт	6	поштучно
53072	3402	МЕД натуральный 250гр Алтайское Разнотравье ст/б ТМ Гордость Алтая	\N	\N	3036.00	шт	1	32	t	2025-12-07 13:19:23.393	2025-12-07 13:19:23.393	253.00	шт	12	поштучно
53073	3402	МЕД натуральный 250гр Горный ст/б ТМ Гордость Алтая	\N	\N	3547.00	шт	1	30	t	2025-12-07 13:19:23.403	2025-12-07 13:19:23.403	296.00	шт	12	поштучно
53074	3402	МЕД натуральный 250гр Луговой ст/б ТМ Гордость Алтая	\N	\N	3547.00	шт	1	70	t	2025-12-07 13:19:23.426	2025-12-07 13:19:23.426	296.00	шт	12	поштучно
53075	3402	МЕД натуральный 250гр Таежный ст/б ТМ Гордость Алтая	\N	\N	4181.00	шт	1	24	t	2025-12-07 13:19:23.448	2025-12-07 13:19:23.448	348.00	шт	12	поштучно
53076	3402	МЕД натуральный 500гр Луговой ПЭТ ТМ Гордость Алтая	\N	\N	5410.00	шт	1	102	t	2025-12-07 13:19:23.46	2025-12-07 13:19:23.46	451.00	шт	12	поштучно
53077	3401	МАСЛО  Живой янтарь 0,9л подсолнечное рафинированное*	\N	\N	2329.00	уп (15 шт)	1	300	t	2025-12-07 13:19:23.47	2025-12-07 13:19:23.47	155.00	шт	15	только уп
53078	3401	МАСЛО  Живой янтарь 1л подсолнечное рафинированное*	\N	\N	2570.00	уп (15 шт)	1	300	t	2025-12-07 13:19:23.487	2025-12-07 13:19:23.487	171.00	шт	15	только уп
53079	3401	МАСЛО  Краснодарское Отборное 0,9л подсолнечное рафинированное*	\N	\N	2329.00	уп (15 шт)	1	30	t	2025-12-07 13:19:23.501	2025-12-07 13:19:23.501	155.00	шт	15	только уп
53080	3401	МАСЛО  Краснодарское Отборное 1,8л подсолнечное рафинированное*	\N	\N	2084.00	уп (6 шт)	1	300	t	2025-12-07 13:19:23.513	2025-12-07 13:19:23.513	347.00	шт	6	только уп
53081	3401	МАСЛО  Южный полюс 0,9л подсолнечное рафинированное*	\N	\N	2329.00	уп (15 шт)	1	300	t	2025-12-07 13:19:23.525	2025-12-07 13:19:23.525	155.00	шт	15	только уп
53082	3401	МАСЛО  Южный полюс 1,8л подсолнечное рафинированное*	\N	\N	2084.00	уп (6 шт)	1	258	t	2025-12-07 13:19:23.536	2025-12-07 13:19:23.536	347.00	шт	6	только уп
53083	3401	МАСЛО "ALTERO Original" 0,81л подсолнечное рафинированное Высший сорт *	\N	\N	3312.00	уп (15 шт)	1	300	t	2025-12-07 13:19:23.548	2025-12-07 13:19:23.548	221.00	шт	15	только уп
53084	3401	МАСЛО "ALTERO" 0,81л подсолнечное рафинированное с оливковым маслом	\N	\N	3381.00	уп (15 шт)	1	300	t	2025-12-07 13:19:23.557	2025-12-07 13:19:23.557	225.00	шт	15	только уп
53085	3401	МАСЛО "Алтай" 0,9л подсолнечное рафинированное Высший сорт *	\N	\N	2286.00	уп (15 шт)	1	9	t	2025-12-07 13:19:23.568	2025-12-07 13:19:23.568	152.00	шт	15	только уп
53086	3401	МАСЛО "Алтай" 5л подсолнечное рафинированное Высший сорт *	\N	\N	2536.00	уп (3 шт)	1	124	t	2025-12-07 13:19:23.58	2025-12-07 13:19:23.58	845.00	шт	3	только уп
53087	3401	МАСЛО "Диво Алтая" 1л подсолнечное рафинированное Высший сорт *	\N	\N	2570.00	уп (15 шт)	1	9	t	2025-12-07 13:19:23.596	2025-12-07 13:19:23.596	171.00	шт	15	только уп
53088	3401	МАСЛО "Знаток" Pomace для тушения и жарки 0,25л ОЛИВКОВОЕ ст/б	\N	\N	5216.00	уп (12 шт)	1	111	t	2025-12-07 13:19:23.61	2025-12-07 13:19:23.61	435.00	шт	12	только уп
53089	3401	МАСЛО "Слобода" 1,8л подсолнечное рафинированное Высший сорт *	\N	\N	2318.00	уп (6 шт)	1	185	t	2025-12-07 13:19:23.621	2025-12-07 13:19:23.621	386.00	шт	6	только уп
53090	3401	МАСЛО "Слобода" 1л подсолнечное рафинированное Высший сорт *	\N	\N	3174.00	уп (15 шт)	1	300	t	2025-12-07 13:19:23.646	2025-12-07 13:19:23.646	212.00	шт	15	только уп
53091	3401	МАСЛО "Слобода" 1л подсолнечное рафинированное для жарки и фритюра	\N	\N	3157.00	уп (15 шт)	1	120	t	2025-12-07 13:19:23.704	2025-12-07 13:19:23.704	210.00	шт	15	только уп
53092	3401	МАСЛО "Слобода" 5л подсолнечное рафинированное Высший сорт *	\N	\N	3171.00	уп (3 шт)	1	99	t	2025-12-07 13:19:23.72	2025-12-07 13:19:23.72	1057.00	шт	3	только уп
53093	3401	МАСЛО "Я Люблю готовить" 1л подсолнечное рафинированное	\N	\N	2933.00	уп (15 шт)	1	300	t	2025-12-07 13:19:23.73	2025-12-07 13:19:23.73	195.00	шт	15	только уп
53094	3401	МАСЛО Аверино 1л подсолнечное рафинированное*	\N	\N	2579.00	уп (15 шт)	1	300	t	2025-12-07 13:19:23.753	2025-12-07 13:19:23.753	172.00	шт	15	только уп
53095	3401	МАСЛО Для фритюра подсолнечное EFKO FOOD Professional  5л	\N	\N	3277.00	уп (3 шт)	1	300	t	2025-12-07 13:19:23.763	2025-12-07 13:19:23.763	1093.00	шт	3	только уп
53096	3401	МАСЛО Для фритюра ЮЖНЫЙ ПОЛЮС 5л	\N	\N	2905.00	уп (3 шт)	1	6	t	2025-12-07 13:19:23.787	2025-12-07 13:19:23.787	968.00	шт	3	только уп
53097	3401	МАСЛО Умные рецепты Алтая 1л подсолнечное рафинированное*	\N	\N	2579.00	уп (15 шт)	1	300	t	2025-12-07 13:19:23.801	2025-12-07 13:19:23.801	172.00	шт	15	только уп
53098	3404	МУКА 1сорт Гост вес 50кг Союзмука	\N	\N	2875.00	уп (50 шт)	1	300	t	2025-12-07 13:19:23.819	2025-12-07 13:19:23.819	57.00	кг	50	только уп
53099	3404	МУКА 1сорт Гост вес 50кг ТМ Беляевская	\N	\N	2559.00	уп (50 шт)	1	200	t	2025-12-07 13:19:23.834	2025-12-07 13:19:23.834	51.00	кг	50	только уп
53100	3404	МУКА в/с Гост 2кг ТМ Беляевская	\N	\N	702.00	уп (6 шт)	1	330	t	2025-12-07 13:19:23.847	2025-12-07 13:19:23.847	117.00	шт	6	только уп
53101	3404	МУКА в/с Гост вес 10кг ТМ Беляевская	\N	\N	551.00	уп (10 шт)	1	500	t	2025-12-07 13:19:23.858	2025-12-07 13:19:23.858	55.00	кг	10	только уп
53102	3404	МУКА в/с ГОСТ вес 50кг Союзмука	\N	\N	3019.00	уп (50 шт)	1	500	t	2025-12-07 13:19:23.869	2025-12-07 13:19:23.869	60.00	кг	50	только уп
53103	3404	МУКА в/с Гост вес 50кг ТМ Беляевская	\N	\N	2576.00	уп (50 шт)	1	500	t	2025-12-07 13:19:23.879	2025-12-07 13:19:23.879	52.00	кг	50	только уп
53104	3404	МУКА в/с Гост вес 5кг ТМ Беляевская	\N	\N	279.00	уп (5 шт)	1	500	t	2025-12-07 13:19:23.89	2025-12-07 13:19:23.89	56.00	кг	5	только уп
53105	3404	МУКА ржаная Гост вес 45кг ТМ Беляевская	\N	\N	2220.00	уп (45 шт)	1	500	t	2025-12-07 13:19:23.901	2025-12-07 13:19:23.901	49.00	кг	45	только уп
53106	3404	Сахар весовой 50кг	\N	\N	4985.00	уп (50 шт)	1	500	t	2025-12-07 13:19:23.912	2025-12-07 13:19:23.912	100.00	кг	50	только уп
53107	3404	САХАР Рафинад Русский 1кг	\N	\N	2709.00	уп (20 шт)	1	86	t	2025-12-07 13:19:23.923	2025-12-07 13:19:23.923	135.00	шт	20	только уп
53108	3404	САХАР Рафинад Чайкофский 1кг	\N	\N	2709.00	уп (20 шт)	1	500	t	2025-12-07 13:19:23.938	2025-12-07 13:19:23.938	135.00	шт	20	только уп
53109	3404	САХАР Рафинад Чайкофский 250гр	\N	\N	1670.00	уп (40 шт)	1	500	t	2025-12-07 13:19:23.95	2025-12-07 13:19:23.95	42.00	шт	40	только уп
53110	3404	САХАР Рафинад Чайкофский 500гр	\N	\N	2737.00	уп (40 шт)	1	500	t	2025-12-07 13:19:23.96	2025-12-07 13:19:23.96	68.00	шт	40	только уп
53111	3404	СОЛЬ Усольская Экстра 1кг	\N	\N	931.00	уп (20 шт)	1	500	t	2025-12-07 13:19:23.977	2025-12-07 13:19:23.977	47.00	кг	20	только уп
53112	3305	МОЛОКО сухое цельное ГОСТ 26% ВЕС мешок 25кг	\N	\N	14289.00	уп (25 шт)	1	500	t	2025-12-07 13:19:23.996	2025-12-07 13:19:23.996	572.00	кг	25	только уп
53113	3305	СЛИВКИ сухие Фрима 500г	\N	\N	10074.00	шт	1	500	t	2025-12-07 13:19:24.008	2025-12-07 13:19:24.008	420.00	шт	24	поштучно
53114	3305	ЯИЧНЫЙ ПОРОШОК (меланж сухой) ГОСТ мешок 20кг	\N	\N	15065.00	уп (20 шт)	1	500	t	2025-12-07 13:19:24.018	2025-12-07 13:19:24.018	753.00	кг	20	только уп
53115	3317	МАКАРОНЫ "Аньези" 250гр Паппарделле яичные №216	\N	\N	3229.00	шт	1	79	t	2025-12-07 13:19:24.03	2025-12-07 13:19:24.03	269.00	шт	12	поштучно
53116	3317	МАКАРОНЫ "Аньези" 500гр Перо рифленое №019	\N	\N	4057.00	шт	1	111	t	2025-12-07 13:19:24.042	2025-12-07 13:19:24.042	169.00	шт	24	поштучно
53117	3317	МАКАРОНЫ "Мальтальяти" 450гр Бантики №106	\N	\N	1975.00	шт	1	200	t	2025-12-07 13:19:24.052	2025-12-07 13:19:24.052	132.00	шт	15	поштучно
53118	3317	МАКАРОНЫ "Мальтальяти" 450гр Букатини №008	\N	\N	2254.00	шт	1	200	t	2025-12-07 13:19:24.062	2025-12-07 13:19:24.062	113.00	шт	20	поштучно
53119	3317	МАКАРОНЫ "Мальтальяти" 450гр Вермишель №090	\N	\N	2254.00	шт	1	200	t	2025-12-07 13:19:24.438	2025-12-07 13:19:24.438	113.00	шт	20	поштучно
53120	3317	МАКАРОНЫ "Мальтальяти" 450гр Лапша №010	\N	\N	2254.00	шт	1	200	t	2025-12-07 13:19:24.453	2025-12-07 13:19:24.453	113.00	шт	20	поштучно
53121	3317	МАКАРОНЫ "Мальтальяти" 450гр Перо рифленое №074	\N	\N	2254.00	шт	1	200	t	2025-12-07 13:19:24.465	2025-12-07 13:19:24.465	113.00	шт	20	поштучно
53122	3317	МАКАРОНЫ "Мальтальяти" 450гр Радиаторе №079	\N	\N	1690.00	шт	1	200	t	2025-12-07 13:19:24.489	2025-12-07 13:19:24.489	113.00	шт	15	поштучно
53123	3317	МАКАРОНЫ "Мальтальяти" 450гр Ракушка мелкая №040	\N	\N	2254.00	шт	1	200	t	2025-12-07 13:19:24.522	2025-12-07 13:19:24.522	113.00	шт	20	поштучно
53124	3317	МАКАРОНЫ "Мальтальяти" 450гр Рожки №038	\N	\N	2254.00	шт	1	200	t	2025-12-07 13:19:24.541	2025-12-07 13:19:24.541	113.00	шт	20	поштучно
53125	3317	МАКАРОНЫ "Мальтальяти" 450гр Рожок витой №069	\N	\N	2254.00	шт	1	200	t	2025-12-07 13:19:24.553	2025-12-07 13:19:24.553	113.00	шт	20	поштучно
53126	3317	МАКАРОНЫ "Мальтальяти" 450гр Рожок крупный №096	\N	\N	2254.00	шт	1	196	t	2025-12-07 13:19:24.566	2025-12-07 13:19:24.566	113.00	шт	20	поштучно
53127	3317	МАКАРОНЫ "Мальтальяти" 450гр Спагетти классические №004	\N	\N	2705.00	шт	1	200	t	2025-12-07 13:19:24.586	2025-12-07 13:19:24.586	113.00	шт	24	поштучно
53128	3317	МАКАРОНЫ "Мальтальяти" 450гр Спагетти тонкие №002	\N	\N	2705.00	шт	1	200	t	2025-12-07 13:19:24.597	2025-12-07 13:19:24.597	113.00	шт	24	поштучно
53129	3317	МАКАРОНЫ "Мальтальяти" 450гр Спираль №078	\N	\N	2254.00	шт	1	200	t	2025-12-07 13:19:24.608	2025-12-07 13:19:24.608	113.00	шт	20	поштучно
53130	3317	МАКАРОНЫ "Мальтальяти" 450гр Спираль лигурийская №102	\N	\N	2254.00	шт	1	200	t	2025-12-07 13:19:24.62	2025-12-07 13:19:24.62	113.00	шт	20	поштучно
53131	3317	МАКАРОНЫ "Мальтальяти" 450гр Фузилоне №098	\N	\N	1690.00	шт	1	200	t	2025-12-07 13:19:24.633	2025-12-07 13:19:24.633	113.00	шт	15	поштучно
53132	3317	МАКАРОНЫ "Мальтальяти" 500гр Лазанья №087	\N	\N	4085.00	шт	1	200	t	2025-12-07 13:19:24.645	2025-12-07 13:19:24.645	340.00	шт	12	поштучно
53133	3317	МАКАРОНЫ "Паста Зара" 500гр Бантики №31	\N	\N	2760.00	шт	1	200	t	2025-12-07 13:19:24.656	2025-12-07 13:19:24.656	138.00	шт	20	поштучно
53134	3317	МАКАРОНЫ "Паста Зара" 500гр Вермишель №80	\N	\N	2461.00	шт	1	200	t	2025-12-07 13:19:24.665	2025-12-07 13:19:24.665	123.00	шт	20	поштучно
53135	3317	МАКАРОНЫ "Паста Зара" 500гр Перо №46	\N	\N	2461.00	шт	1	200	t	2025-12-07 13:19:24.676	2025-12-07 13:19:24.676	123.00	шт	20	поштучно
53136	3317	МАКАРОНЫ "Паста Зара" 500гр Перо рифленое №49	\N	\N	2461.00	шт	1	200	t	2025-12-07 13:19:24.687	2025-12-07 13:19:24.687	123.00	шт	20	поштучно
53137	3317	МАКАРОНЫ "Паста Зара" 500гр Рожки №27	\N	\N	2461.00	шт	1	200	t	2025-12-07 13:19:24.697	2025-12-07 13:19:24.697	123.00	шт	20	поштучно
53138	3317	МАКАРОНЫ "Паста Зара" 500гр Рожок витой №61	\N	\N	2461.00	шт	1	200	t	2025-12-07 13:19:24.717	2025-12-07 13:19:24.717	123.00	шт	20	поштучно
53139	3317	МАКАРОНЫ "Паста Зара" 500гр Спагетти классические №4	\N	\N	2461.00	шт	1	200	t	2025-12-07 13:19:24.729	2025-12-07 13:19:24.729	123.00	шт	20	поштучно
53140	3317	МАКАРОНЫ "Паста Зара" 500гр Спагетти тонкие №1	\N	\N	2461.00	шт	1	200	t	2025-12-07 13:19:24.74	2025-12-07 13:19:24.74	123.00	шт	20	поштучно
53141	3317	МАКАРОНЫ "Паста Зара" 500гр Спираль №57	\N	\N	2461.00	шт	1	200	t	2025-12-07 13:19:24.755	2025-12-07 13:19:24.755	123.00	шт	20	поштучно
53142	3317	МАКАРОНЫ "Паста Зара" 500гр Трубка витая №45	\N	\N	2461.00	шт	1	200	t	2025-12-07 13:19:24.766	2025-12-07 13:19:24.766	123.00	шт	20	поштучно
53143	3317	МАКАРОНЫ "Шебекинские" 350гр Бабочки №400	\N	\N	2015.00	шт	1	200	t	2025-12-07 13:19:24.776	2025-12-07 13:19:24.776	101.00	шт	20	поштучно
53144	3317	МАКАРОНЫ "Шебекинские" 350гр Букатини №007	\N	\N	3494.00	шт	1	200	t	2025-12-07 13:19:24.796	2025-12-07 13:19:24.796	97.00	шт	36	поштучно
53145	3317	МАКАРОНЫ "Шебекинские" 350гр Лагман-лапша №517	\N	\N	2718.00	шт	1	200	t	2025-12-07 13:19:24.807	2025-12-07 13:19:24.807	97.00	шт	28	поштучно
53146	3317	МАКАРОНЫ "Шебекинские" 400гр Зити №708	\N	\N	1708.00	шт	1	200	t	2025-12-07 13:19:24.818	2025-12-07 13:19:24.818	114.00	шт	15	поштучно
53147	3317	МАКАРОНЫ "Шебекинские" 450гр Вермишелька брикет (новая упаковка) №111	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.83	2025-12-07 13:19:24.83	97.00	шт	20	поштучно
53148	3317	МАКАРОНЫ "Шебекинские" 450гр Витой рожок №388	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.845	2025-12-07 13:19:24.845	97.00	шт	20	поштучно
53149	3317	МАКАРОНЫ "Шебекинские" 450гр Звездочки №190	\N	\N	1932.00	шт	1	48	t	2025-12-07 13:19:24.859	2025-12-07 13:19:24.859	97.00	шт	20	поштучно
53150	3317	МАКАРОНЫ "Шебекинские" 450гр лапша лингвини №011	\N	\N	2705.00	шт	1	200	t	2025-12-07 13:19:24.871	2025-12-07 13:19:24.871	97.00	шт	28	поштучно
53151	3317	МАКАРОНЫ "Шебекинские" 450гр Перышки №223	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.892	2025-12-07 13:19:24.892	97.00	шт	20	поштучно
53152	3317	МАКАРОНЫ "Шебекинские" 450гр Перья брикет (новая упаквока) №343	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.904	2025-12-07 13:19:24.904	97.00	шт	20	поштучно
53153	3317	МАКАРОНЫ "Шебекинские" 450гр Перья гладкие №340	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.93	2025-12-07 13:19:24.93	97.00	шт	20	поштучно
53154	3317	МАКАРОНЫ "Шебекинские" 450гр Ракушка брикет (новая упаковка) №393	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.942	2025-12-07 13:19:24.942	97.00	шт	20	поштучно
53155	3317	МАКАРОНЫ "Шебекинские" 450гр Ракушка маленькая №193	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.96	2025-12-07 13:19:24.96	97.00	шт	20	поштучно
53156	3317	МАКАРОНЫ "Шебекинские" 450гр Рожки №203	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.97	2025-12-07 13:19:24.97	97.00	шт	20	поштучно
53157	3317	МАКАРОНЫ "Шебекинские" 450гр Рожок полубублик брикет (новая упаковка) №202	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.981	2025-12-07 13:19:24.981	97.00	шт	20	поштучно
53158	3317	МАКАРОНЫ "Шебекинские" 450гр Русский рожок брикет (новая упаковка) №230	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:24.994	2025-12-07 13:19:24.994	97.00	шт	20	поштучно
53159	3317	МАКАРОНЫ "Шебекинские" 450гр Сердечки №370	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:25.006	2025-12-07 13:19:25.006	97.00	шт	20	поштучно
53160	3317	МАКАРОНЫ "Шебекинские" 450гр Спагетти №002	\N	\N	2718.00	шт	1	200	t	2025-12-07 13:19:25.017	2025-12-07 13:19:25.017	97.00	шт	28	поштучно
53161	3317	МАКАРОНЫ "Шебекинские" 450гр Спагеттини №001	\N	\N	2718.00	шт	1	200	t	2025-12-07 13:19:25.027	2025-12-07 13:19:25.027	97.00	шт	28	поштучно
53162	3317	МАКАРОНЫ "Шебекинские" 450гр Спирали №366	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:25.044	2025-12-07 13:19:25.044	97.00	шт	20	поштучно
53163	3317	МАКАРОНЫ "Шебекинские" 450гр Спирали три цвета №366.5	\N	\N	2084.00	шт	1	200	t	2025-12-07 13:19:25.073	2025-12-07 13:19:25.073	104.00	шт	20	поштучно
53164	3317	МАКАРОНЫ "Шебекинские" 450гр Трубки №353	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:25.092	2025-12-07 13:19:25.092	97.00	шт	20	поштучно
53165	3317	МАКАРОНЫ "Шебекинские" 450гр Улитка Мезо №390	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:25.108	2025-12-07 13:19:25.108	97.00	шт	20	поштучно
53166	3317	МАКАРОНЫ "Шебекинские" 450гр Улитки брикет (новая упаковка) №295	\N	\N	1941.00	шт	1	200	t	2025-12-07 13:19:25.122	2025-12-07 13:19:25.122	97.00	шт	20	поштучно
53167	3317	МАКАРОНЫ "Шебекинские" 450гр Фузили №266	\N	\N	2718.00	шт	1	200	t	2025-12-07 13:19:25.138	2025-12-07 13:19:25.138	97.00	шт	28	поштучно
53168	3317	МАКАРОНЫ Фунчоза 500гр	\N	\N	5227.00	шт	1	85	t	2025-12-07 13:19:25.154	2025-12-07 13:19:25.154	174.00	шт	30	поштучно
53169	3317	КРУПА "Агромастер" 400гр Перловая	\N	\N	344.00	шт	1	30	t	2025-12-07 13:19:25.167	2025-12-07 13:19:25.167	57.00	шт	6	поштучно
53170	3317	КРУПА "Прозапас" 600гр Пшеничная	\N	\N	621.00	шт	1	10	t	2025-12-07 13:19:25.18	2025-12-07 13:19:25.18	62.00	шт	10	поштучно
53171	3317	КРУПА "Прозапас" 600гр Ячневая	\N	\N	436.00	шт	1	40	t	2025-12-07 13:19:25.191	2025-12-07 13:19:25.191	44.00	шт	10	поштучно
53172	3317	КРУПА "Прозапас" 700гр Манная	\N	\N	730.00	шт	1	72	t	2025-12-07 13:19:25.202	2025-12-07 13:19:25.202	73.00	шт	10	поштучно
53173	3317	КРУПА "Прозапас" 800гр Геркулес	\N	\N	676.00	шт	1	200	t	2025-12-07 13:19:25.213	2025-12-07 13:19:25.213	85.00	шт	8	поштучно
53174	3317	КРУПА "Прозапас" 800гр Гречневая	\N	\N	627.00	шт	1	200	t	2025-12-07 13:19:25.224	2025-12-07 13:19:25.224	63.00	шт	10	поштучно
53175	3317	КРУПА "Прозапас" 800гр Перловая	\N	\N	580.00	шт	1	9	t	2025-12-07 13:19:25.287	2025-12-07 13:19:25.287	58.00	шт	10	поштучно
53176	3317	КРУПА "Прозапас" 800гр Пшено	\N	\N	730.00	шт	1	37	t	2025-12-07 13:19:25.299	2025-12-07 13:19:25.299	73.00	шт	10	поштучно
53177	3317	КРУПА "Прозапас" 800гр Рис для плова Камолино	\N	\N	1392.00	шт	1	148	t	2025-12-07 13:19:25.356	2025-12-07 13:19:25.356	139.00	шт	10	поштучно
53178	3317	КРУПА "Прозапас" 800гр Рис Краснодарский	\N	\N	1375.00	шт	1	137	t	2025-12-07 13:19:25.368	2025-12-07 13:19:25.368	138.00	шт	10	поштучно
53179	3317	КРУПА "Прозапас" 800гр Рис пропаренный	\N	\N	1662.00	шт	1	200	t	2025-12-07 13:19:25.379	2025-12-07 13:19:25.379	166.00	шт	10	поштучно
25315	2755	ЛЕЧО по-болгарски 680гр ст/б Сыта-Загора	\N	\N	1272.00	уп (8 шт)	1	26	f	2025-11-10 01:55:35.834	2025-11-22 01:30:48.533	159.00	шт	8	\N
53180	3317	КРУПА "Шебекинская" 500гр Манная	\N	\N	1352.00	шт	1	200	t	2025-12-07 13:19:25.389	2025-12-07 13:19:25.389	97.00	шт	14	поштучно
53181	3323	КАКАО МакЧоколат Классический 20гр	\N	\N	492.00	шт	1	500	t	2025-12-07 13:19:25.403	2025-12-07 13:19:25.403	25.00	шт	20	поштучно
53182	3323	КАКАО Микс Фикс м/уп 175гр	\N	\N	5054.00	шт	1	153	t	2025-12-07 13:19:25.415	2025-12-07 13:19:25.415	168.00	шт	30	поштучно
53183	3323	КИСЕЛЬ брикет Вишня 180гр ТМ Мастер Дак	\N	\N	1693.00	шт	1	418	t	2025-12-07 13:19:25.427	2025-12-07 13:19:25.427	53.00	шт	32	поштучно
53184	3323	КИСЕЛЬ брикет Клубника 180гр ТМ Мастер Дак	\N	\N	1693.00	шт	1	176	t	2025-12-07 13:19:25.447	2025-12-07 13:19:25.447	53.00	шт	32	поштучно
53185	3323	КИСЕЛЬ брикет Малина 180гр ТМ Мастер Дак	\N	\N	1693.00	шт	1	160	t	2025-12-07 13:19:25.458	2025-12-07 13:19:25.458	53.00	шт	32	поштучно
53186	3323	КИСЕЛЬ брикет Плодово-ягодный 180гр ТМ Мастер Дак	\N	\N	1693.00	шт	1	15	t	2025-12-07 13:19:25.47	2025-12-07 13:19:25.47	53.00	шт	32	поштучно
53187	3323	Кофе BUSHIDO BLACK KATANA ст/б 100гр	\N	\N	11033.00	шт	1	53	t	2025-12-07 13:19:25.493	2025-12-07 13:19:25.493	1226.00	шт	9	поштучно
53188	3323	Кофе BUSHIDO BLACK KATANA ст/б 50гр	\N	\N	9508.00	шт	1	19	t	2025-12-07 13:19:25.508	2025-12-07 13:19:25.508	792.00	шт	12	поштучно
53189	3323	Кофе BUSHIDO ORIGINAL м/уп 75гр	\N	\N	10626.00	шт	1	195	t	2025-12-07 13:19:25.519	2025-12-07 13:19:25.519	885.00	шт	12	поштучно
53190	3323	Кофе BUSHIDO ORIGINAL ст/б 100гр	\N	\N	8963.00	шт	1	169	t	2025-12-07 13:19:25.53	2025-12-07 13:19:25.53	996.00	шт	9	поштучно
53191	3323	Кофе BUSHIDO RED KATANA м/у 75гр	\N	\N	11040.00	шт	1	52	t	2025-12-07 13:19:25.544	2025-12-07 13:19:25.544	920.00	шт	12	поштучно
53192	3323	Кофе BUSHIDO RED KATANA ст/б 100гр	\N	\N	10785.00	шт	1	81	t	2025-12-07 13:19:25.556	2025-12-07 13:19:25.556	1198.00	шт	9	поштучно
53193	3323	Кофе BUSHIDO SENSEI зерно м/у 227гр	\N	\N	9301.00	шт	1	96	t	2025-12-07 13:19:25.578	2025-12-07 13:19:25.578	775.00	шт	12	поштучно
53194	3323	КОФЕ CARTE NOIRE м/уп 150гр	\N	\N	9936.00	шт	1	57	t	2025-12-07 13:19:25.592	2025-12-07 13:19:25.592	1104.00	шт	9	поштучно
53195	3323	КОФЕ CARTE NOIRE м/уп 75гр	\N	\N	7894.00	шт	1	225	t	2025-12-07 13:19:25.603	2025-12-07 13:19:25.603	658.00	шт	12	поштучно
53196	3323	КОФЕ CARTE NOIRE ст/б 190гр	\N	\N	8484.00	шт	1	45	t	2025-12-07 13:19:25.617	2025-12-07 13:19:25.617	1414.00	шт	6	поштучно
53197	3323	КОФЕ EGOISTE DOUBLE 100гр ст/б	\N	\N	9260.00	шт	1	92	t	2025-12-07 13:19:25.627	2025-12-07 13:19:25.627	772.00	шт	12	поштучно
53198	3323	КОФЕ EGOISTE NOIRE 100гр ст/б	\N	\N	8556.00	шт	1	9	t	2025-12-07 13:19:25.689	2025-12-07 13:19:25.689	713.00	шт	12	поштучно
53199	3323	КОФЕ EGOISTE PLATINUM 100гр ст/б	\N	\N	11913.00	шт	1	222	t	2025-12-07 13:19:25.732	2025-12-07 13:19:25.732	1324.00	шт	9	поштучно
53200	3323	КОФЕ EGOISTE PRIVATE 100гр ст/б	\N	\N	10754.00	шт	1	106	t	2025-12-07 13:19:25.746	2025-12-07 13:19:25.746	1195.00	шт	9	поштучно
53201	3323	КОФЕ EGOISTE SPECIAL 100гр ст/б	\N	\N	9864.00	шт	1	102	t	2025-12-07 13:19:25.773	2025-12-07 13:19:25.773	1096.00	шт	9	поштучно
53202	3323	КОФЕ EGOISTE V.S. 30% 100гр ст/б	\N	\N	9874.00	шт	1	106	t	2025-12-07 13:19:25.787	2025-12-07 13:19:25.787	1097.00	шт	9	поштучно
53203	3323	КОФЕ EGOISTE X.O. 100гр ст/б	\N	\N	11033.00	шт	1	78	t	2025-12-07 13:19:25.8	2025-12-07 13:19:25.8	1226.00	шт	9	поштучно
53204	3323	КОФЕ МакКофе Арабика 150гр м/уп	\N	\N	8181.00	шт	1	6	t	2025-12-07 13:19:25.813	2025-12-07 13:19:25.813	682.00	шт	12	поштучно
53205	3323	КОФЕ МакКофе Арабика 2гр	\N	\N	473.00	шт	1	500	t	2025-12-07 13:19:25.824	2025-12-07 13:19:25.824	16.00	шт	30	поштучно
53206	3323	КОФЕ МакКофе Голд 1,8гр	\N	\N	445.00	шт	1	500	t	2025-12-07 13:19:25.839	2025-12-07 13:19:25.839	15.00	шт	30	поштучно
53207	3323	КОФЕ МакКофе Голд 30гр м/уп	\N	\N	3574.00	шт	1	157	t	2025-12-07 13:19:25.852	2025-12-07 13:19:25.852	149.00	шт	24	поштучно
53208	3323	КОФЕ МакКофе Голд 75гр м/уп	\N	\N	4447.00	шт	1	32	t	2025-12-07 13:19:25.863	2025-12-07 13:19:25.863	371.00	шт	12	поштучно
53209	3323	КОФЕ МакКофе Капучино ди Торино 2в1 16,5гр	\N	\N	706.00	шт	1	500	t	2025-12-07 13:19:25.875	2025-12-07 13:19:25.875	35.00	шт	20	поштучно
53210	3323	КОФЕ МакКофе Капучино ди Торино с корицей 25,5гр	\N	\N	706.00	шт	1	500	t	2025-12-07 13:19:25.886	2025-12-07 13:19:25.886	35.00	шт	20	поштучно
53211	3323	КОФЕ МакКофе Капучино ди Торино с темным шоколадом 3в1 25,5гр	\N	\N	706.00	шт	1	500	t	2025-12-07 13:19:25.898	2025-12-07 13:19:25.898	35.00	шт	20	поштучно
53212	3323	КОФЕ МакКофе Капучино Дольче Вита 24гр	\N	\N	515.00	шт	1	500	t	2025-12-07 13:19:25.908	2025-12-07 13:19:25.908	26.00	шт	20	поштучно
53213	3323	КОФЕ МакКофе Карамель 3в1 18гр	\N	\N	555.00	шт	1	500	t	2025-12-07 13:19:25.918	2025-12-07 13:19:25.918	22.00	шт	25	поштучно
53214	3323	КОФЕ МакКофе Латте Карамель 22гр	\N	\N	515.00	шт	1	500	t	2025-12-07 13:19:25.932	2025-12-07 13:19:25.932	26.00	шт	20	поштучно
53215	3323	КОФЕ МакКофе Лесной орех 3в1 18гр	\N	\N	555.00	шт	1	500	t	2025-12-07 13:19:25.952	2025-12-07 13:19:25.952	22.00	шт	25	поштучно
53216	3323	КОФЕ МакКофе Макс Классик 3в1 16гр	\N	\N	373.00	шт	1	500	t	2025-12-07 13:19:25.963	2025-12-07 13:19:25.963	19.00	шт	20	поштучно
53217	3323	КОФЕ МакКофе Макс Крепкий 3в1 16гр	\N	\N	373.00	шт	1	500	t	2025-12-07 13:19:25.974	2025-12-07 13:19:25.974	19.00	шт	20	поштучно
53218	3323	КОФЕ МакКофе Оригинал 3в1 20гр	\N	\N	2220.00	шт	1	500	t	2025-12-07 13:19:25.996	2025-12-07 13:19:25.996	22.00	шт	100	поштучно
53219	3323	КОФЕ МакКофе Сгущеное молоко 3в1 20гр	\N	\N	222.00	шт	1	500	t	2025-12-07 13:19:26.007	2025-12-07 13:19:26.007	22.00	шт	10	поштучно
53220	3323	КОФЕ МакКофе Стронг 3в1 18гр	\N	\N	222.00	шт	1	500	t	2025-12-07 13:19:26.019	2025-12-07 13:19:26.019	22.00	шт	10	поштучно
53221	3323	КОФЕ Максим м/у 190гр 1/9шт	\N	\N	7587.00	шт	1	383	t	2025-12-07 13:19:26.038	2025-12-07 13:19:26.038	843.00	шт	9	поштучно
53222	3323	КОФЕ Максим м/у 300гр 1/9шт	\N	\N	12296.00	шт	1	500	t	2025-12-07 13:19:26.064	2025-12-07 13:19:26.064	1366.00	шт	9	поштучно
53223	3323	КОФЕ Максим м/у 500гр 1/6шт	\N	\N	12006.00	шт	1	500	t	2025-12-07 13:19:26.077	2025-12-07 13:19:26.077	2001.00	шт	6	поштучно
25336	2755	ЗАКУСКА Венгерская 470гр ст/б ТМ Пиканта	\N	\N	1122.00	уп (6 шт)	1	200	f	2025-11-10 01:55:36.987	2025-11-22 01:30:48.533	187.00	шт	6	\N
53224	3323	КОФЕ Монарх 3в1 Классик 13,5гр	\N	\N	437.00	шт	1	500	t	2025-12-07 13:19:26.089	2025-12-07 13:19:26.089	18.00	шт	24	поштучно
53225	3323	КОФЕ Монарх 3в1 Крепкий 13гр	\N	\N	437.00	шт	1	500	t	2025-12-07 13:19:26.099	2025-12-07 13:19:26.099	18.00	шт	24	поштучно
53226	3323	КОФЕ Монарх 3в1 Мягкий 13,5гр	\N	\N	437.00	шт	1	500	t	2025-12-07 13:19:26.11	2025-12-07 13:19:26.11	18.00	шт	24	поштучно
53227	3323	КОФЕ Монарх Голд ст/банка 190гр	\N	\N	5141.00	шт	1	158	t	2025-12-07 13:19:26.121	2025-12-07 13:19:26.121	857.00	шт	6	поштучно
53228	3323	КОФЕ Монарх Голд ст/банка 95гр	\N	\N	5962.00	шт	1	37	t	2025-12-07 13:19:26.132	2025-12-07 13:19:26.132	497.00	шт	12	поштучно
53229	3323	КОФЕ Монарх Милиграно ст/банка 90гр	\N	\N	2981.00	шт	1	55	t	2025-12-07 13:19:26.144	2025-12-07 13:19:26.144	497.00	шт	6	поштучно
53230	3323	КОФЕ Монарх Ориджинал м/уп 200гр	\N	\N	5472.00	шт	1	23	t	2025-12-07 13:19:26.154	2025-12-07 13:19:26.154	912.00	шт	6	поштучно
53231	3323	КОФЕ Монарх Ориджинал м/уп 500гр	\N	\N	13600.00	шт	1	268	t	2025-12-07 13:19:26.164	2025-12-07 13:19:26.164	2267.00	шт	6	поштучно
53232	3323	КОФЕ Московская Кофейная на Паяхъ Коломбо м/уп 150гр	\N	\N	8809.00	шт	1	92	t	2025-12-07 13:19:26.173	2025-12-07 13:19:26.173	881.00	шт	10	поштучно
53233	3323	КОФЕ Московская Кофейная на Паяхъ Коломбо м/уп 230гр	\N	\N	6734.00	шт	1	33	t	2025-12-07 13:19:26.183	2025-12-07 13:19:26.183	1122.00	шт	6	поштучно
53234	3323	КОФЕ Московская Кофейная на Паяхъ Коломбо м/уп 75гр	\N	\N	5762.00	шт	1	221	t	2025-12-07 13:19:26.194	2025-12-07 13:19:26.194	480.00	шт	12	поштучно
53235	3323	КОФЕ Московская Кофейная на Паяхъ Коломбо м/уп 95гр	\N	\N	6112.00	шт	1	123	t	2025-12-07 13:19:26.205	2025-12-07 13:19:26.205	509.00	шт	12	поштучно
53236	3323	КОФЕ Московская Кофейная на Паяхъ Мокко м/уп 230гр	\N	\N	6603.00	шт	1	93	t	2025-12-07 13:19:26.215	2025-12-07 13:19:26.215	1101.00	шт	6	поштучно
53237	3323	КОФЕ Московская Кофейная на Паяхъ Мокко м/уп 75гр	\N	\N	5051.00	шт	1	136	t	2025-12-07 13:19:26.225	2025-12-07 13:19:26.225	421.00	шт	12	поштучно
53238	3323	КОФЕ Московская Кофейная на Паяхъ Мокко ст/банка 95гр	\N	\N	3050.00	шт	1	103	t	2025-12-07 13:19:26.235	2025-12-07 13:19:26.235	508.00	шт	6	поштучно
53239	3323	КОФЕ Нескафе 3в1 Классик 14,5гр	\N	\N	382.00	шт	1	180	t	2025-12-07 13:19:26.253	2025-12-07 13:19:26.253	19.00	шт	20	поштучно
53240	3323	КОФЕ Нескафе 3в1 Крепкий 14,5гр	\N	\N	362.00	шт	1	500	t	2025-12-07 13:19:26.263	2025-12-07 13:19:26.263	18.00	шт	20	поштучно
53241	3323	КОФЕ Нескафе 3в1 Мягкий 14,5гр	\N	\N	382.00	шт	1	380	t	2025-12-07 13:19:26.309	2025-12-07 13:19:26.309	19.00	шт	20	поштучно
53242	3323	КОФЕ Черная Карта Exclusive Brasilia ст/б 190гр	\N	\N	4727.00	шт	1	20	t	2025-12-07 13:19:26.376	2025-12-07 13:19:26.376	788.00	шт	6	поштучно
53243	3323	КОФЕ Черная Карта Exclusive Brasilia ст/б 95гр	\N	\N	2374.00	шт	1	132	t	2025-12-07 13:19:26.424	2025-12-07 13:19:26.424	396.00	шт	6	поштучно
53244	3323	КОФЕ Черная Карта Gold м/у 75гр	\N	\N	3360.00	шт	1	109	t	2025-12-07 13:19:26.44	2025-12-07 13:19:26.44	280.00	шт	12	поштучно
53245	3323	КОФЕ Черная Карта Gold ст/б 190гр	\N	\N	4727.00	шт	1	62	t	2025-12-07 13:19:26.513	2025-12-07 13:19:26.513	788.00	шт	6	поштучно
53246	3323	НАПИТОК ЧАЙНЫЙ МакТи Лимон 16гр	\N	\N	294.00	шт	1	500	t	2025-12-07 13:19:26.527	2025-12-07 13:19:26.527	15.00	шт	20	поштучно
53247	3323	НАПИТОК ЧАЙНЫЙ МакТи Малина 16гр	\N	\N	294.00	шт	1	500	t	2025-12-07 13:19:26.542	2025-12-07 13:19:26.542	15.00	шт	20	поштучно
53248	3323	ЦИКОРИЙ Здоровье растворимый 100гр	\N	\N	1960.00	шт	1	118	t	2025-12-07 13:19:26.561	2025-12-07 13:19:26.561	163.00	шт	12	поштучно
53249	3323	ЧАЙ Curtic Delicate Mango Green пирамидки 20пак	\N	\N	1339.00	шт	1	23	t	2025-12-07 13:19:26.587	2025-12-07 13:19:26.587	112.00	шт	12	поштучно
53250	3323	ЧАЙ Curtic Summer Berries пирамидки 20пак	\N	\N	1339.00	шт	1	13	t	2025-12-07 13:19:26.599	2025-12-07 13:19:26.599	112.00	шт	12	поштучно
53251	3323	ЧАЙ Curtic Sunny Lemon пирамидки 20пак	\N	\N	1339.00	шт	1	8	t	2025-12-07 13:19:26.61	2025-12-07 13:19:26.61	112.00	шт	12	поштучно
53252	3323	ЧАЙ Азерчай Бергамот без конверта 25пак	\N	\N	1090.00	шт	1	24	t	2025-12-07 13:19:26.62	2025-12-07 13:19:26.62	91.00	шт	12	поштучно
53253	3323	ЧАЙ Азерчай Клубника конверт 25пак	\N	\N	2716.00	шт	1	8	t	2025-12-07 13:19:26.631	2025-12-07 13:19:26.631	113.00	шт	24	поштучно
53254	3323	ЧАЙ Акбар Лесные ягоды 100пак	\N	\N	1697.00	шт	1	111	t	2025-12-07 13:19:26.642	2025-12-07 13:19:26.642	283.00	шт	6	поштучно
53255	3323	ЧАЙ Гранд Великий Тигр 100пак	\N	\N	1831.00	шт	1	136	t	2025-12-07 13:19:26.654	2025-12-07 13:19:26.654	229.00	шт	8	поштучно
53256	3323	ЧАЙ Гранд Великий Тигр 25пак	\N	\N	1504.00	шт	1	306	t	2025-12-07 13:19:26.665	2025-12-07 13:19:26.665	63.00	шт	24	поштучно
53257	3323	ЧАЙ Гранд Семь слонов м/уп 100гр	\N	\N	2047.00	шт	1	70	t	2025-12-07 13:19:26.679	2025-12-07 13:19:26.679	102.00	шт	20	поштучно
53258	3323	ЧАЙ Гранд Семь слонов м/уп 200гр	\N	\N	2933.00	шт	1	150	t	2025-12-07 13:19:26.69	2025-12-07 13:19:26.69	195.00	шт	15	поштучно
53259	3323	ЧАЙ Гранд Суприм Гавайский мохито зеленый пирамидки 20пак	\N	\N	1125.00	шт	1	275	t	2025-12-07 13:19:26.7	2025-12-07 13:19:26.7	94.00	шт	12	поштучно
53260	3323	ЧАЙ Гранд Суприм Дикий чабрец пирамидки 20пак	\N	\N	1125.00	шт	1	18	t	2025-12-07 13:19:26.711	2025-12-07 13:19:26.711	94.00	шт	12	поштучно
53261	3323	ЧАЙ Гранд Суприм Земляничный цитрус пирамидки 20пак	\N	\N	1125.00	шт	1	186	t	2025-12-07 13:19:26.722	2025-12-07 13:19:26.722	94.00	шт	12	поштучно
53262	3323	ЧАЙ Гранд Суприм Манго маракуйя черный пирамидки 15пак	\N	\N	1104.00	шт	1	108	t	2025-12-07 13:19:26.733	2025-12-07 13:19:26.733	92.00	шт	12	поштучно
53263	3323	ЧАЙ Гранд Суприм Медовый имбирь зеленый пирамидки 20пак	\N	\N	1125.00	шт	1	115	t	2025-12-07 13:19:26.748	2025-12-07 13:19:26.748	94.00	шт	12	поштучно
53264	3323	ЧАЙ Гранд Суприм Пряный бергамот пирамидки 20пак	\N	\N	1125.00	шт	1	240	t	2025-12-07 13:19:26.76	2025-12-07 13:19:26.76	94.00	шт	12	поштучно
53265	3323	ЧАЙ Гранд Суприм Смородина апельсин пирамидки 20пак	\N	\N	1125.00	шт	1	141	t	2025-12-07 13:19:26.778	2025-12-07 13:19:26.778	94.00	шт	12	поштучно
53266	3323	ЧАЙ Гранд Суприм Таежные ягоды пирамидки 20пак	\N	\N	1125.00	шт	1	168	t	2025-12-07 13:19:26.791	2025-12-07 13:19:26.791	94.00	шт	12	поштучно
25383	2755	ФАСОЛЬ Отборная красная 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	1392.00	уп (12 шт)	1	47	f	2025-11-10 01:55:39.559	2025-11-22 01:30:48.533	116.00	шт	12	\N
25395	2755	ГОРОШЕК консервир 400гр ж/б  ТМ Знаток	\N	\N	1164.00	уп (12 шт)	1	200	f	2025-11-10 01:55:40.164	2025-11-22 01:30:48.533	97.00	шт	12	\N
25403	2755	КУКУРУЗА консервир 425мл ж/б  ТМ Знаток	\N	\N	1224.00	уп (12 шт)	1	200	f	2025-11-10 01:55:40.603	2025-11-22 01:30:48.533	102.00	шт	12	\N
53267	3323	ЧАЙ Гринфилд Голден Цейлон 100пак	\N	\N	3664.00	шт	1	412	t	2025-12-07 13:19:26.813	2025-12-07 13:19:26.813	407.00	шт	9	поштучно
53268	3323	ЧАЙ Гринфилд Голден Цейлон 25пак	\N	\N	1288.00	шт	1	180	t	2025-12-07 13:19:26.826	2025-12-07 13:19:26.826	129.00	шт	10	поштучно
53269	3323	ЧАЙ Гринфилд Грин Мелиса 25пак	\N	\N	1213.00	шт	1	80	t	2025-12-07 13:19:26.842	2025-12-07 13:19:26.842	121.00	шт	10	поштучно
53270	3323	ЧАЙ Гринфилд Ерл Грей Фэнтази 25пак	\N	\N	1213.00	шт	1	179	t	2025-12-07 13:19:26.853	2025-12-07 13:19:26.853	121.00	шт	10	поштучно
53271	3323	ЧАЙ Гринфилд Ерл Грей Фэнтази с бергамотом 100пак	\N	\N	3664.00	шт	1	248	t	2025-12-07 13:19:26.864	2025-12-07 13:19:26.864	407.00	шт	9	поштучно
53272	3323	ЧАЙ Гринфилд Кения Санрайс 100пак	\N	\N	3674.00	шт	1	195	t	2025-12-07 13:19:26.874	2025-12-07 13:19:26.874	408.00	шт	9	поштучно
53273	3323	ЧАЙ Гринфилд Кения Санрайс 25пак	\N	\N	1265.00	шт	1	126	t	2025-12-07 13:19:26.884	2025-12-07 13:19:26.884	126.00	шт	10	поштучно
53274	3323	ЧАЙ Гринфилд Классик Бреакфаст 100пак	\N	\N	3933.00	шт	1	379	t	2025-12-07 13:19:26.898	2025-12-07 13:19:26.898	437.00	шт	9	поштучно
53275	3323	ЧАЙ Гринфилд Классик Бреакфаст 25пак	\N	\N	1213.00	шт	1	6	t	2025-12-07 13:19:26.915	2025-12-07 13:19:26.915	121.00	шт	10	поштучно
53276	3323	ЧАЙ Гринфилд Саммер Боуквит Малина 25пак	\N	\N	1213.00	шт	1	130	t	2025-12-07 13:19:26.926	2025-12-07 13:19:26.926	121.00	шт	10	поштучно
53277	3323	ЧАЙ Гринфилд Спринг Мелоди Душистые травы 25пак	\N	\N	1265.00	шт	1	147	t	2025-12-07 13:19:26.936	2025-12-07 13:19:26.936	126.00	шт	10	поштучно
53278	3323	ЧАЙ Гринфилд Спринг Мелоди с чабрецом 100пак	\N	\N	3664.00	шт	1	315	t	2025-12-07 13:19:26.957	2025-12-07 13:19:26.957	407.00	шт	9	поштучно
53279	3323	ЧАЙ Лисма Крепкий 100пак	\N	\N	1304.00	шт	1	97	t	2025-12-07 13:19:26.97	2025-12-07 13:19:26.97	217.00	шт	6	поштучно
53280	3323	ЧАЙ Лисма Крепкий 25пак	\N	\N	1025.00	шт	1	296	t	2025-12-07 13:19:26.982	2025-12-07 13:19:26.982	57.00	шт	18	поштучно
53281	3323	ЧАЙ Лисма Лимон 25пак	\N	\N	1118.00	шт	1	273	t	2025-12-07 13:19:26.997	2025-12-07 13:19:26.997	62.00	шт	18	поштучно
53282	3323	ЧАЙ Майский Ароматный бергамот 25пак	\N	\N	1511.00	шт	1	194	t	2025-12-07 13:19:27.01	2025-12-07 13:19:27.01	84.00	шт	18	поштучно
53283	3323	ЧАЙ Майский Душистый чабрец с лимоном 25пак	\N	\N	1573.00	шт	1	42	t	2025-12-07 13:19:27.022	2025-12-07 13:19:27.022	87.00	шт	18	поштучно
53284	3323	ЧАЙ Майский Корона Российской Империи 100пак	\N	\N	1704.00	шт	1	166	t	2025-12-07 13:19:27.035	2025-12-07 13:19:27.035	284.00	шт	6	поштучно
53285	3323	ЧАЙ Майский Корона Российской Империи 25пак	\N	\N	1366.00	шт	1	305	t	2025-12-07 13:19:27.067	2025-12-07 13:19:27.067	76.00	шт	18	поштучно
53286	3323	ЧАЙ Майский Лесные ягоды 25пак	\N	\N	1511.00	шт	1	192	t	2025-12-07 13:19:27.088	2025-12-07 13:19:27.088	84.00	шт	18	поштучно
53287	3323	ЧАЙ Майский Лимон 25пак	\N	\N	1511.00	шт	1	114	t	2025-12-07 13:19:27.098	2025-12-07 13:19:27.098	84.00	шт	18	поштучно
53288	3323	ЧАЙ Майский Отборный 25пак	\N	\N	1366.00	шт	1	182	t	2025-12-07 13:19:27.108	2025-12-07 13:19:27.108	76.00	шт	18	поштучно
53289	3323	ЧАЙ Майский Смородина мята 25пак	\N	\N	1511.00	шт	1	261	t	2025-12-07 13:19:27.118	2025-12-07 13:19:27.118	84.00	шт	18	поштучно
53290	3323	ЧАЙ пакетированный Акбар классический зеленый 100п*2гр	\N	\N	1366.00	шт	1	30	t	2025-12-07 13:19:27.128	2025-12-07 13:19:27.128	228.00	шт	6	поштучно
53291	3323	ЧАЙ Тэсс Брикфаст 100пак	\N	\N	3364.00	шт	1	52	t	2025-12-07 13:19:27.139	2025-12-07 13:19:27.139	374.00	шт	9	поштучно
53292	3323	ЧАЙ Тэсс Кения 100пак	\N	\N	3364.00	шт	1	136	t	2025-12-07 13:19:27.15	2025-12-07 13:19:27.15	374.00	шт	9	поштучно
53293	3323	ЧАЙ Тэсс Плэйсар Блэк 25пак	\N	\N	1023.00	шт	1	147	t	2025-12-07 13:19:27.161	2025-12-07 13:19:27.161	102.00	шт	10	поштучно
53294	3323	ЧАЙ Тэсс Плэйсар Блэк Плэжа 100пак	\N	\N	3364.00	шт	1	141	t	2025-12-07 13:19:27.174	2025-12-07 13:19:27.174	374.00	шт	9	поштучно
53295	3323	ЧАЙ Тэсс Санрайс Блэк 100пак	\N	\N	3364.00	шт	1	96	t	2025-12-07 13:19:27.185	2025-12-07 13:19:27.185	374.00	шт	9	поштучно
53296	3323	ЧАЙ Тэсс Санрайс Блэк 25пак	\N	\N	1023.00	шт	1	137	t	2025-12-07 13:19:27.195	2025-12-07 13:19:27.195	102.00	шт	10	поштучно
53297	3323	ЧАЙ Тэсс Флирт Грин 25пак	\N	\N	1023.00	шт	1	108	t	2025-12-07 13:19:27.214	2025-12-07 13:19:27.214	102.00	шт	10	поштучно
53298	3323	ЧАЙ Тэсс Хай Цейлон 25пак	\N	\N	1023.00	шт	1	37	t	2025-12-07 13:19:27.226	2025-12-07 13:19:27.226	102.00	шт	10	поштучно
53299	3323	ЧАЙ Хэйлис Английский Аристократический  круп лист 250гр	\N	\N	8746.00	шт	1	392	t	2025-12-07 13:19:27.296	2025-12-07 13:19:27.296	583.00	шт	15	поштучно
53300	3323	ЧАЙ Хэйлис Английский Аристократический 100пак	\N	\N	5423.00	шт	1	357	t	2025-12-07 13:19:27.331	2025-12-07 13:19:27.331	452.00	шт	12	поштучно
53301	3323	ЧАЙ Хэйлис Английский Аристократический 500гр	\N	\N	10063.00	шт	1	127	t	2025-12-07 13:19:27.366	2025-12-07 13:19:27.366	1006.00	шт	10	поштучно
53302	3323	ЧАЙ Чай Тэсс Банана Сплит 20пак	\N	\N	1228.00	шт	1	131	t	2025-12-07 13:19:27.378	2025-12-07 13:19:27.378	102.00	шт	12	поштучно
53303	3323	ЧАЙ Чай Тэсс Гингер Моджито Грин 20пак	\N	\N	1228.00	шт	1	126	t	2025-12-07 13:19:27.401	2025-12-07 13:19:27.401	102.00	шт	12	поштучно
53304	3323	ЧАЙ Чай Тэсс Карамель Шарм 20пак	\N	\N	1339.00	шт	1	74	t	2025-12-07 13:19:27.412	2025-12-07 13:19:27.412	112.00	шт	12	поштучно
53305	3323	ЧАЙ Чай Тэсс Пина Колада Грин 20пак	\N	\N	1187.00	шт	1	36	t	2025-12-07 13:19:27.423	2025-12-07 13:19:27.423	99.00	шт	12	поштучно
53306	3323	ЧАЙ Чай Тэсс Форест Дрим Блэк 20пак	\N	\N	1228.00	шт	1	120	t	2025-12-07 13:19:27.441	2025-12-07 13:19:27.441	102.00	шт	12	поштучно
53307	3323	ЧАЙ Ява Зелёный традиционный 100пак	\N	\N	4595.00	шт	1	250	t	2025-12-07 13:19:27.453	2025-12-07 13:19:27.453	255.00	шт	18	поштучно
53308	3303	ПОП КОРН 99гр с маслом ТМ Jolly Time США	\N	\N	2979.00	шт	1	155	t	2025-12-07 13:19:27.465	2025-12-07 13:19:27.465	165.00	шт	18	поштучно
53309	3303	ПОП КОРН 99гр сладкий ТМ Jolly Time США	\N	\N	3498.00	шт	1	13	t	2025-12-07 13:19:27.476	2025-12-07 13:19:27.476	194.00	шт	18	поштучно
53310	3303	ХЛЕБЦЫ МОЛОДЦЫ Lепешка кунжут и сыр 150гр	\N	\N	3671.00	уп (24 шт)	1	200	t	2025-12-07 13:19:27.497	2025-12-07 13:19:27.497	153.00	шт	24	только уп
53311	3303	ХЛЕБЦЫ МОЛОДЦЫ Lепешка лук и семена льна 150гр	\N	\N	3671.00	уп (24 шт)	1	200	t	2025-12-07 13:19:27.508	2025-12-07 13:19:27.508	153.00	шт	24	только уп
53312	3303	ХЛЕБЦЫ МОЛОДЦЫ Бородинские цельнозерновые 150гр	\N	\N	2450.00	уп (30 шт)	1	200	t	2025-12-07 13:19:27.521	2025-12-07 13:19:27.521	82.00	шт	30	только уп
53313	3303	ХЛЕБЦЫ МОЛОДЦЫ Гречнево-ржаные с провитамином А 110гр	\N	\N	2029.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.537	2025-12-07 13:19:27.537	56.00	шт	36	только уп
53314	3303	ХЛЕБЦЫ МОЛОДЦЫ Лайт вафельные ржаные 70гр	\N	\N	2401.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.551	2025-12-07 13:19:27.551	67.00	шт	36	только уп
53315	3303	ХЛЕБЦЫ МОЛОДЦЫ Лайт вафельные с витаминами 70гр	\N	\N	2401.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.564	2025-12-07 13:19:27.564	67.00	шт	36	только уп
53316	3303	ХЛЕБЦЫ МОЛОДЦЫ Лайт вафельные с экстрактом виноградных косточек 70гр	\N	\N	2401.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.574	2025-12-07 13:19:27.574	67.00	шт	36	только уп
53317	3303	ХЛЕБЦЫ МОЛОДЦЫ Лайт вафельные с экстрактом зеленого чая 70гр	\N	\N	2401.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.589	2025-12-07 13:19:27.589	67.00	шт	36	только уп
53318	3303	ХЛЕБЦЫ МОЛОДЦЫ Овсяные с пророщенной пшеницей 100гр	\N	\N	2029.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.608	2025-12-07 13:19:27.608	56.00	шт	36	только уп
53319	3303	ХЛЕБЦЫ МОЛОДЦЫ Пшенично-ржаные 100гр	\N	\N	2029.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.63	2025-12-07 13:19:27.63	56.00	шт	36	только уп
53320	3303	ХЛЕБЦЫ МОЛОДЦЫ Ржаные 110гр	\N	\N	1987.00	уп (36 шт)	1	90	t	2025-12-07 13:19:27.698	2025-12-07 13:19:27.698	55.00	шт	36	только уп
53321	3303	ХЛЕБЦЫ МОЛОДЦЫ ФитнесЛайн витамин плюс 100гр	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.714	2025-12-07 13:19:27.714	63.00	шт	36	только уп
53322	3303	ХЛЕБЦЫ МОЛОДЦЫ ФитнесЛайн железо плюс 100гр	\N	\N	2236.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.727	2025-12-07 13:19:27.727	62.00	шт	36	только уп
53323	3303	ХЛЕБЦЫ МОЛОДЦЫ ФитнесЛайн минерал плюс 100гр	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-07 13:19:27.738	2025-12-07 13:19:27.738	63.00	шт	36	только уп
53324	3317	КАША овсяная клубника 35гр ТМ Мастер Дак	\N	\N	759.00	уп (30 шт)	1	200	t	2025-12-07 13:19:27.748	2025-12-07 13:19:27.748	25.00	шт	30	только уп
53325	3317	КАША овсяная малина 35гр ТМ Мастер Дак	\N	\N	759.00	уп (30 шт)	1	200	t	2025-12-07 13:19:27.758	2025-12-07 13:19:27.758	25.00	шт	30	только уп
53326	3317	КАША овсяная персик 35гр ТМ Мастер Дак	\N	\N	759.00	уп (30 шт)	1	200	t	2025-12-07 13:19:27.774	2025-12-07 13:19:27.774	25.00	шт	30	только уп
53327	3317	КАША овсяная черника 35гр ТМ Мастер Дак	\N	\N	759.00	уп (30 шт)	1	200	t	2025-12-07 13:19:27.786	2025-12-07 13:19:27.786	25.00	шт	30	только уп
53328	3403	АДЖИКА сухая 15гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	129	t	2025-12-07 13:19:27.795	2025-12-07 13:19:27.795	14.00	шт	40	только уп
53329	3403	БАЗИЛИК 500гр ТМ Мастер Дак	\N	\N	1455.00	уп (5 шт)	1	15	t	2025-12-07 13:19:27.805	2025-12-07 13:19:27.805	291.00	шт	5	только уп
53330	3403	БУЛЬОН грибной 100гр ТМ Мастер Дак	\N	\N	1667.00	уп (50 шт)	1	130	t	2025-12-07 13:19:27.815	2025-12-07 13:19:27.815	33.00	шт	50	только уп
53331	3403	ВАНИЛИН 500гр ТМ Мастер Дак	\N	\N	4451.00	уп (10 шт)	1	52	t	2025-12-07 13:19:27.825	2025-12-07 13:19:27.825	445.00	шт	10	только уп
53332	3403	ГОРЧИЧНЫЙ ПОРОШОК 150гр ТМ Мастер Дак	\N	\N	2668.00	уп (40 шт)	1	200	t	2025-12-07 13:19:27.836	2025-12-07 13:19:27.836	67.00	шт	40	только уп
53333	3403	ГОРЧИЧНЫЙ ПОРОШОК 500гр ТМ Мастер Дак	\N	\N	1323.00	уп (10 шт)	1	40	t	2025-12-07 13:19:27.847	2025-12-07 13:19:27.847	132.00	шт	10	только уп
53334	3403	ДРОЖЖИ 8гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	200	t	2025-12-07 13:19:27.859	2025-12-07 13:19:27.859	14.00	шт	40	только уп
53335	3403	КИСЕЛЬ в ассортименте 220гр	\N	\N	2087.00	уп (36 шт)	1	21	t	2025-12-07 13:19:27.885	2025-12-07 13:19:27.885	58.00	шт	36	только уп
53336	3403	КОРИЦА молотая 500гр ТМ Мастер Дак	\N	\N	4129.00	уп (10 шт)	1	53	t	2025-12-07 13:19:27.896	2025-12-07 13:19:27.896	413.00	шт	10	только уп
53337	3403	КУНЖУТ 10гр ТМ Мастер Дак	\N	\N	690.00	уп (40 шт)	1	110	t	2025-12-07 13:19:27.914	2025-12-07 13:19:27.914	17.00	шт	40	только уп
53338	3403	КУНЖУТ семя с дозатором 300гр ТМ Трапеза	\N	\N	3323.00	уп (10 шт)	1	7	t	2025-12-07 13:19:27.929	2025-12-07 13:19:27.929	332.00	шт	10	только уп
53339	3403	ЛАВРОВЫЙ лист целый 200гр ТМ Мастер Дак	\N	\N	1696.00	уп (5 шт)	1	117	t	2025-12-07 13:19:27.96	2025-12-07 13:19:27.96	339.00	шт	5	только уп
53340	3403	ЛАПША Доширак Говядина 90гр	\N	\N	1877.00	уп (24 шт)	1	200	t	2025-12-07 13:19:27.98	2025-12-07 13:19:27.98	78.00	шт	24	только уп
53341	3403	ЛАПША Доширак Курица 90гр	\N	\N	1877.00	уп (24 шт)	1	200	t	2025-12-07 13:19:28.001	2025-12-07 13:19:28.001	78.00	шт	24	только уп
53342	3403	ЛИМОННАЯ КИСЛОТА 10гр ТМ Мастер Дак	\N	\N	414.00	уп (40 шт)	1	199	t	2025-12-07 13:19:28.015	2025-12-07 13:19:28.015	10.00	шт	40	только уп
53343	3403	ЛИМОННАЯ КИСЛОТА 20гр ТМ Capo di Gusto	\N	\N	828.00	уп (40 шт)	1	200	t	2025-12-07 13:19:28.026	2025-12-07 13:19:28.026	21.00	шт	40	только уп
53344	3403	ЛУК зеленый сушеный 5гр ТМ Мастер Дак	\N	\N	546.00	уп (25 шт)	1	200	t	2025-12-07 13:19:28.044	2025-12-07 13:19:28.044	22.00	шт	25	только уп
53345	3403	ЛУК сушеный вес Китай	\N	\N	6152.00	уп (10 шт)	1	20	t	2025-12-07 13:19:28.055	2025-12-07 13:19:28.055	615.00	кг	10	только уп
53346	3403	МАК пищевой 50гр ТМ Мастер Дак	\N	\N	5382.00	уп (60 шт)	1	200	t	2025-12-07 13:19:28.065	2025-12-07 13:19:28.065	90.00	шт	60	только уп
53347	3403	МОРКОВЬ дробленая сушеная 500гр ТМ Мастер Дак	\N	\N	3300.00	уп (10 шт)	1	19	t	2025-12-07 13:19:28.078	2025-12-07 13:19:28.078	330.00	шт	10	только уп
53348	3403	ПАПРИКА молотая сладкая 500гр ТМ Мастер Дак	\N	\N	3220.00	уп (10 шт)	1	40	t	2025-12-07 13:19:28.091	2025-12-07 13:19:28.091	322.00	шт	10	только уп
53349	3403	ПЕРЕЦ красный молотый 10гр ТМ Мастер Дак	\N	\N	483.00	уп (35 шт)	1	200	t	2025-12-07 13:19:28.104	2025-12-07 13:19:28.104	14.00	шт	35	только уп
53350	3403	ПЕРЕЦ черный горошек 10гр ТМ Мастер Дак	\N	\N	1311.00	уп (30 шт)	1	180	t	2025-12-07 13:19:28.116	2025-12-07 13:19:28.116	44.00	шт	30	только уп
53351	3403	ПЕРЕЦ черный горошек 500гр ТМ Мастер Дак	\N	\N	10868.00	уп (10 шт)	1	81	t	2025-12-07 13:19:28.127	2025-12-07 13:19:28.127	1087.00	шт	10	только уп
53352	3403	ПЕРЕЦ черный молотый 10гр ТМ Мастер Дак	\N	\N	690.00	уп (40 шт)	1	200	t	2025-12-07 13:19:28.137	2025-12-07 13:19:28.137	17.00	шт	40	только уп
53353	3403	ПЕРЕЦ черный молотый 500гр ТМ Мастер Дак	\N	\N	3864.00	уп (10 шт)	1	183	t	2025-12-07 13:19:28.151	2025-12-07 13:19:28.151	386.00	шт	10	только уп
53354	3403	ПЕТРУШКА сушеная 250гр ТМ Мастер Дак	\N	\N	1415.00	уп (10 шт)	1	200	t	2025-12-07 13:19:28.161	2025-12-07 13:19:28.161	141.00	шт	10	только уп
53355	3403	ПЕТРУШКА сушеная 5гр ТМ Мастер Дак	\N	\N	345.00	уп (30 шт)	1	200	t	2025-12-07 13:19:28.171	2025-12-07 13:19:28.171	12.00	шт	30	только уп
53356	3403	ПРИПРАВА для борща 15гр ТМ Мастер Дак	\N	\N	690.00	уп (40 шт)	1	200	t	2025-12-07 13:19:28.182	2025-12-07 13:19:28.182	17.00	шт	40	только уп
53357	3403	ПРИПРАВА для говядины 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	180	t	2025-12-07 13:19:28.193	2025-12-07 13:19:28.193	13.00	шт	40	только уп
53358	3403	ПРИПРАВА для гриля 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	200	t	2025-12-07 13:19:28.211	2025-12-07 13:19:28.211	13.00	шт	40	только уп
53359	3403	ПРИПРАВА для картофеля 15гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	200	t	2025-12-07 13:19:28.221	2025-12-07 13:19:28.221	14.00	шт	40	только уп
53360	3403	ПРИПРАВА для куриных окорочков 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	200	t	2025-12-07 13:19:28.232	2025-12-07 13:19:28.232	15.00	шт	40	только уп
53361	3403	ПРИПРАВА для курицы 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	200	t	2025-12-07 13:19:28.244	2025-12-07 13:19:28.244	13.00	шт	40	только уп
53362	3403	ПРИПРАВА для курицы 500гр ТМ Мастер Дак	\N	\N	2243.00	уп (10 шт)	1	25	t	2025-12-07 13:19:28.256	2025-12-07 13:19:28.256	224.00	шт	10	только уп
53363	3403	ПРИПРАВА для курицы с дозатором 300гр ТМ Трапеза	\N	\N	3703.00	уп (10 шт)	1	10	t	2025-12-07 13:19:28.266	2025-12-07 13:19:28.266	370.00	шт	10	только уп
53364	3403	ПРИПРАВА для моркови по-корейски острая 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	60	t	2025-12-07 13:19:28.279	2025-12-07 13:19:28.279	15.00	шт	40	только уп
53365	3403	ПРИПРАВА для моркови по-корейски острая 500гр ТМ Мастер Дак	\N	\N	2530.00	уп (10 шт)	1	8	t	2025-12-07 13:19:28.29	2025-12-07 13:19:28.29	253.00	шт	10	только уп
53366	3403	ПРИПРАВА для мяса 15гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	160	t	2025-12-07 13:19:28.301	2025-12-07 13:19:28.301	14.00	шт	40	только уп
53367	3403	ПРИПРАВА для мяса 500гр ТМ Мастер Дак	\N	\N	2243.00	уп (10 шт)	1	34	t	2025-12-07 13:19:28.371	2025-12-07 13:19:28.371	224.00	шт	10	только уп
53368	3403	ПРИПРАВА для плова 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	200	t	2025-12-07 13:19:28.385	2025-12-07 13:19:28.385	15.00	шт	40	только уп
53369	3403	ПРИПРАВА для рыбы 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	40	t	2025-12-07 13:19:28.396	2025-12-07 13:19:28.396	15.00	шт	40	только уп
53370	3403	ПРИПРАВА для свинины 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	20	t	2025-12-07 13:19:28.407	2025-12-07 13:19:28.407	13.00	шт	40	только уп
53371	3403	ПРИПРАВА для фарша 500гр ТМ Мастер Дак	\N	\N	2070.00	уп (10 шт)	1	43	t	2025-12-07 13:19:28.418	2025-12-07 13:19:28.418	207.00	шт	10	только уп
53372	3403	ПРИПРАВА для цыплят табака 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	80	t	2025-12-07 13:19:28.429	2025-12-07 13:19:28.429	13.00	шт	40	только уп
53373	3403	ПРИПРАВА для шашлыка 15гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	119	t	2025-12-07 13:19:28.456	2025-12-07 13:19:28.456	14.00	шт	40	только уп
53374	3403	ПРИПРАВА Карри 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	155	t	2025-12-07 13:19:28.526	2025-12-07 13:19:28.526	15.00	шт	40	только уп
53375	3403	ПРИПРАВА Карри 500гр ТМ Мастер Дак	\N	\N	1702.00	уп (10 шт)	1	16	t	2025-12-07 13:19:28.538	2025-12-07 13:19:28.538	170.00	шт	10	только уп
53376	3403	ПРИПРАВА Летняя с зеленью 8гр ТМ Мастер Дак	\N	\N	431.00	уп (25 шт)	1	100	t	2025-12-07 13:19:28.554	2025-12-07 13:19:28.554	17.00	шт	25	только уп
53377	3403	ПРИПРАВА Универсальная 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	200	t	2025-12-07 13:19:28.565	2025-12-07 13:19:28.565	15.00	шт	40	только уп
53378	3403	ПРИПРАВА Универсальная 20 трав и овощей 100гр ТМ Spice Master	\N	\N	1403.00	уп (20 шт)	1	200	t	2025-12-07 13:19:28.575	2025-12-07 13:19:28.575	70.00	шт	20	только уп
53379	3403	ПРИПРАВА Универсальная 500гр ТМ Мастер Дак	\N	\N	2243.00	уп (10 шт)	1	51	t	2025-12-07 13:19:28.592	2025-12-07 13:19:28.592	224.00	шт	10	только уп
53380	3403	ПРИПРАВА Хмели-сунели 15гр ТМ Мастер Дак	\N	\N	448.00	уп (30 шт)	1	120	t	2025-12-07 13:19:28.605	2025-12-07 13:19:28.605	15.00	шт	30	только уп
53381	3403	Пюре картофельное с жареным луком 34гр ТМ Мастер Дак	\N	\N	1610.00	уп (40 шт)	1	120	t	2025-12-07 13:19:28.616	2025-12-07 13:19:28.616	40.00	шт	40	только уп
53382	3403	Пюре картофельное с курицей 34гр ТМ Мастер Дак	\N	\N	1610.00	уп (40 шт)	1	21	t	2025-12-07 13:19:28.639	2025-12-07 13:19:28.639	40.00	шт	40	только уп
53383	3403	СУХАРИ панировочные 400гр ТМ Мастер Дак	\N	\N	3162.00	уп (25 шт)	1	140	t	2025-12-07 13:19:28.653	2025-12-07 13:19:28.653	126.00	шт	25	только уп
53384	3403	УКРОП сушеный 250гр ТМ Мастер Дак	\N	\N	3335.00	уп (20 шт)	1	100	t	2025-12-07 13:19:28.663	2025-12-07 13:19:28.663	167.00	шт	20	только уп
53385	3403	УКРОП сушеный 5гр ТМ Мастер Дак	\N	\N	345.00	уп (30 шт)	1	200	t	2025-12-07 13:19:28.674	2025-12-07 13:19:28.674	12.00	шт	30	только уп
53386	3403	УКСУС Столовый Боген 9% 500мл	\N	\N	1004.00	уп (18 шт)	1	200	t	2025-12-07 13:19:28.689	2025-12-07 13:19:28.689	56.00	шт	18	только уп
53387	3403	УКСУСНАЯ КИСЛОТА Боген 70% 160гр	\N	\N	1033.00	уп (18 шт)	1	200	t	2025-12-07 13:19:28.699	2025-12-07 13:19:28.699	57.00	шт	18	только уп
53388	3403	ЧЕСНОК гранулированный сушеный 10гр ТМ Мастер Дак	\N	\N	1006.00	уп (50 шт)	1	200	t	2025-12-07 13:19:28.713	2025-12-07 13:19:28.713	20.00	шт	50	только уп
53389	3403	ЧЕСНОК гранулированный сушеный 500гр ТМ Мастер Дак	\N	\N	5658.00	уп (10 шт)	1	82	t	2025-12-07 13:19:28.729	2025-12-07 13:19:28.729	566.00	шт	10	только уп
53390	3327	МОЛОКО цельное сгущенное вареное Лакомка 8,5% 380гр ж/б  ТМ Минская Марка	\N	\N	5106.00	шт	1	200	t	2025-12-07 13:19:28.762	2025-12-07 13:19:28.762	170.00	шт	30	поштучно
53391	3327	МОЛОКО цельное сгущенное с сахаром 8,5% 380гр ж/б  ТМ Минская Марка	\N	\N	4444.00	шт	1	200	t	2025-12-07 13:19:28.776	2025-12-07 13:19:28.776	148.00	шт	30	поштучно
53392	3327	МОЛОКО цельное сгущенное с сахаром ГОСТ 8,5%  380гр ж/б МКЗ Верховский	\N	\N	2634.00	шт	1	200	t	2025-12-07 13:19:28.798	2025-12-07 13:19:28.798	132.00	шт	20	поштучно
53393	3327	ГОВЯДИНА тушеная 325гр ГОСТ ж/б  ТМ Деревня Потанино	\N	\N	3105.00	шт	1	200	t	2025-12-07 13:19:28.81	2025-12-07 13:19:28.81	259.00	шт	12	поштучно
53394	3327	ГОВЯДИНА тушеная 325гр Золотой Резерв в/с ГОСТ ж/б ключ ТМ Барс	\N	\N	7659.00	шт	1	200	t	2025-12-07 13:19:28.825	2025-12-07 13:19:28.825	425.00	шт	18	поштучно
53395	3327	ГОВЯДИНА тушеная 325гр Классическая ж/б ключ ТМ Барс	\N	\N	3008.00	шт	1	200	t	2025-12-07 13:19:28.836	2025-12-07 13:19:28.836	251.00	шт	12	поштучно
53396	3327	ГОВЯДИНА тушеная 325гр Экстра в/с ГОСТ ж/б ТМ Мясовсем	\N	\N	8239.00	шт	1	200	t	2025-12-07 13:19:28.854	2025-12-07 13:19:28.854	229.00	шт	36	поштучно
53397	3327	ГОВЯДИНА тушеная 325гр Экстра Спецзаказ Клетка в/с ГОСТ ж/б ключ ТМ Барс (Продмост)	\N	\N	6293.00	шт	1	200	t	2025-12-07 13:19:28.867	2025-12-07 13:19:28.867	350.00	шт	18	поштучно
53398	3327	ГОВЯДИНА тушеная 338гр  рубленая Камуфляж ГОСТ ж/б ключ ТМ Деревня Потанино	\N	\N	9574.00	шт	1	200	t	2025-12-07 13:19:28.881	2025-12-07 13:19:28.881	213.00	шт	45	поштучно
53399	3327	ГОВЯДИНА тушеная 338гр ж/б ТМ Мясоделов	\N	\N	4830.00	шт	1	74	t	2025-12-07 13:19:28.893	2025-12-07 13:19:28.893	322.00	шт	15	поштучно
53400	3327	СВИНИНА ветчина 325гр ГОСТ в/с ж/б ключ ТМ Деревня Потанино	\N	\N	2553.00	шт	1	71	t	2025-12-07 13:19:28.906	2025-12-07 13:19:28.906	213.00	шт	12	поштучно
53401	3327	СВИНИНА рулька копченая 540гр ж/б  ключ ТМ Знаток	\N	\N	2615.00	шт	1	114	t	2025-12-07 13:19:28.921	2025-12-07 13:19:28.921	436.00	шт	6	поштучно
53402	3327	СВИНИНА тушеная "Барс" ГОСТ в/с 325гр ключ ЭКСТРА	\N	\N	5630.00	шт	1	200	t	2025-12-07 13:19:28.934	2025-12-07 13:19:28.934	313.00	шт	18	поштучно
53403	3327	СВИНИНА тушеная 325гр ГОСТ в/с ж/б ключ ТМ Деревня Потанино	\N	\N	2995.00	шт	1	200	t	2025-12-07 13:19:28.948	2025-12-07 13:19:28.948	250.00	шт	12	поштучно
53404	3327	СВИНИНА тушеная 325гр Золотой резерв в/с ГОСТ ж/б  ключ ТМ Барс	\N	\N	5258.00	шт	1	200	t	2025-12-07 13:19:28.959	2025-12-07 13:19:28.959	292.00	шт	18	поштучно
53405	3327	СВИНИНА тушеная 325гр рубленая ГОСТ ж/б 1/36шт ТМ Деревня Потанино	\N	\N	4554.00	шт	1	200	t	2025-12-07 13:19:28.971	2025-12-07 13:19:28.971	126.00	шт	36	поштучно
53406	3327	СВИНИНА тушеная 325гр Экстра в/с ГОСТ ж/б 1/36шт ТМ Мясовсем	\N	\N	5796.00	шт	1	200	t	2025-12-07 13:19:28.981	2025-12-07 13:19:28.981	161.00	шт	36	поштучно
53407	3327	СВИНИНА тушеная 325гр Экстра Спецзаказ клетка в/с ГОСТ ж/б ключ ТМ Барс	\N	\N	4554.00	шт	1	200	t	2025-12-07 13:19:28.991	2025-12-07 13:19:28.991	253.00	шт	18	поштучно
53408	3327	СВИНИНА тушеная 338гр Экстра в/с ГОСТ ж/б 1/30шт ТМ Деревня Потанино	\N	\N	4796.00	шт	1	200	t	2025-12-07 13:19:29.003	2025-12-07 13:19:29.003	160.00	шт	30	поштучно
53409	3327	СВИНИНА тушеная 525гр Сельская ж/б 1/24шт ТМ Деревня Потанино	\N	\N	4140.00	шт	1	96	t	2025-12-07 13:19:29.014	2025-12-07 13:19:29.014	173.00	шт	24	поштучно
53410	3327	ГОЛУБЦЫ фаршированные мясом и рисом в томате 525гр ж/б ключ ТМ Барс	\N	\N	1732.00	шт	1	200	t	2025-12-07 13:19:29.024	2025-12-07 13:19:29.024	289.00	шт	6	поштучно
53411	3327	ГУЛЯШ говяжий 325гр ж/б ключ ТМ Барс	\N	\N	7038.00	шт	1	180	t	2025-12-07 13:19:29.036	2025-12-07 13:19:29.036	391.00	шт	18	поштучно
53412	3327	КАША Дворянская гречневая с говядиной 325гр ж/б ключ ТМ Барс	\N	\N	3726.00	шт	1	200	t	2025-12-07 13:19:29.046	2025-12-07 13:19:29.046	207.00	шт	18	поштучно
53413	3327	КАША Дворянская гречневая со свининой 325гр ж/б ключ ТМ Барс	\N	\N	3001.00	шт	1	96	t	2025-12-07 13:19:29.059	2025-12-07 13:19:29.059	167.00	шт	18	поштучно
53414	3327	КАША рисовая с говядиной 325гр ГОСТ в/с ж/б ТМ Деревня Потанино	\N	\N	1615.00	шт	1	11	t	2025-12-07 13:19:29.083	2025-12-07 13:19:29.083	135.00	шт	12	поштучно
53415	3327	МЯСО цыпленка филе грудки в с/с 325гр в/с ГОСТ ж/б ТМ Деревня Потанино	\N	\N	2857.00	шт	1	200	t	2025-12-07 13:19:29.109	2025-12-07 13:19:29.109	238.00	шт	12	поштучно
53416	3327	ПЕРЕЦ фаршированный мясом и рисом в томате 525гр ж/б ключ ТМ Барс	\N	\N	3436.00	шт	1	95	t	2025-12-07 13:19:29.124	2025-12-07 13:19:29.124	286.00	шт	12	поштучно
53417	3327	ПЛОВ Узбекский с говядиной 325гр ж/б ключ ТМ Барс	\N	\N	4451.00	шт	1	200	t	2025-12-07 13:19:29.136	2025-12-07 13:19:29.136	247.00	шт	18	поштучно
53418	3327	ПЛОВ Узбекский с мясов 325гр ж/б ключ ТМ Барс	\N	\N	4451.00	шт	1	21	t	2025-12-07 13:19:29.147	2025-12-07 13:19:29.147	247.00	шт	18	поштучно
53419	3327	ТЕФТЕЛИ мясные  в томате 325гр ключ ТМ Барс	\N	\N	4016.00	шт	1	10	t	2025-12-07 13:19:29.158	2025-12-07 13:19:29.158	223.00	шт	18	поштучно
53420	3327	ПАШТЕТ 100гр Печеночный со сливочным маслом  ТМ Знаток	\N	\N	1633.00	шт	1	168	t	2025-12-07 13:19:29.168	2025-12-07 13:19:29.168	82.00	шт	20	поштучно
53421	3327	ПАШТЕТ 100гр Печеночный со сливочным маслом ключ ТМ Знаток	\N	\N	1932.00	шт	1	14	t	2025-12-07 13:19:29.178	2025-12-07 13:19:29.178	81.00	шт	24	поштучно
53422	3327	ПАШТЕТ 100гр Пражский из свиной печени  ТМ Знаток	\N	\N	1552.00	шт	1	141	t	2025-12-07 13:19:29.189	2025-12-07 13:19:29.189	78.00	шт	20	поштучно
53423	3327	ПАШТЕТ 100гр Пражский из свиной печени ключ ТМ Знаток	\N	\N	1932.00	шт	1	41	t	2025-12-07 13:19:29.2	2025-12-07 13:19:29.2	81.00	шт	24	поштучно
53424	3327	ПАШТЕТ 100гр Эстонский из говяжьей печени  ТМ Знаток	\N	\N	1633.00	шт	1	80	t	2025-12-07 13:19:29.212	2025-12-07 13:19:29.212	82.00	шт	20	поштучно
53425	3327	ПАШТЕТ 200гр Печеночный Гусь ст/б ТМ Знаток	\N	\N	959.00	шт	1	99	t	2025-12-07 13:19:29.223	2025-12-07 13:19:29.223	160.00	шт	6	поштучно
53426	3327	ПАШТЕТ 200гр Печеночный Индейка ст/б ТМ Знаток	\N	\N	959.00	шт	1	52	t	2025-12-07 13:19:29.295	2025-12-07 13:19:29.295	160.00	шт	6	поштучно
53427	3327	ПАШТЕТ 200гр Печеночный Курица ст/б ТМ Знаток	\N	\N	994.00	шт	1	124	t	2025-12-07 13:19:29.307	2025-12-07 13:19:29.307	166.00	шт	6	поштучно
53428	3327	ПАШТЕТ 200гр Печеночный Утка ст/б ТМ Знаток	\N	\N	959.00	шт	1	54	t	2025-12-07 13:19:29.358	2025-12-07 13:19:29.358	160.00	шт	6	поштучно
53429	3327	ПАШТЕТ 230гр Печеночный со сливочным маслом ключ ТМ Знаток	\N	\N	2760.00	шт	1	200	t	2025-12-07 13:19:29.371	2025-12-07 13:19:29.371	115.00	шт	24	поштучно
53430	3327	ПАШТЕТ 230гр Пражский из свиной печени ключ ТМ Знаток	\N	\N	2760.00	шт	1	200	t	2025-12-07 13:19:29.383	2025-12-07 13:19:29.383	115.00	шт	24	поштучно
53431	3327	ПАШТЕТ 230гр Эстонский из говяжьей печени ключ ТМ Знаток	\N	\N	2760.00	шт	1	59	t	2025-12-07 13:19:29.398	2025-12-07 13:19:29.398	115.00	шт	24	поштучно
53432	3327	АДЖИКА Домашняя 280гр ст/б ТМ Сава	\N	\N	787.00	уп (8 шт)	1	16	t	2025-12-07 13:19:29.409	2025-12-07 13:19:29.409	98.00	шт	8	только уп
53433	3327	ВАРЕНЬЕ Малина ст/б 300гр ТМ Сава	\N	\N	1794.00	уп (8 шт)	1	8	t	2025-12-07 13:19:29.42	2025-12-07 13:19:29.42	224.00	шт	8	только уп
53434	3327	ДЖЕМ 250гр Сава Черника вишня на яблочном мусе дойпак	\N	\N	1720.00	уп (15 шт)	1	43	t	2025-12-07 13:19:29.43	2025-12-07 13:19:29.43	115.00	шт	15	только уп
53435	3327	КОМПОТ Черешня 580мл ст/б ТМ Золотая долина	\N	\N	2287.00	уп (12 шт)	1	53	t	2025-12-07 13:19:29.446	2025-12-07 13:19:29.446	191.00	шт	12	только уп
53436	3327	ОГУРЦЫ маринованные ст/б 670гр По-Деревенски хрен смородина ТМ Лукашино	\N	\N	1266.00	уп (6 шт)	1	47	t	2025-12-07 13:19:29.456	2025-12-07 13:19:29.456	211.00	шт	6	только уп
53437	3327	ПОВИДЛО Персиковое 1кг пластиковое ведро ТМ Сава	\N	\N	1011.00	уп (4 шт)	1	16	t	2025-12-07 13:19:29.473	2025-12-07 13:19:29.473	253.00	шт	4	только уп
53438	3327	ПОВИДЛО Яблочное ведро 13кг ТМ Еврофрут	\N	\N	2377.00	уп (13 шт)	1	26	t	2025-12-07 13:19:29.493	2025-12-07 13:19:29.493	183.00	кг	13	только уп
53439	3327	ТОМАТЫ марин 680гр ст/б ТМ Принцесса вкуса	\N	\N	888.00	уп (8 шт)	1	7	t	2025-12-07 13:19:29.513	2025-12-07 13:19:29.513	111.00	шт	8	только уп
53440	3327	ГРИБЫ ШАМПИНЬОНЫ резаные 425мл ж/б  ТМ Сыта-Загора	\N	\N	1822.00	уп (24 шт)	1	173	t	2025-12-07 13:19:29.525	2025-12-07 13:19:29.525	76.00	шт	24	только уп
53441	3327	ГРИБЫ ШАМПИНЬОНЫ резаные 850мл ж/б  ТМ Сыта-Загора	\N	\N	1946.00	уп (12 шт)	1	206	t	2025-12-07 13:19:29.538	2025-12-07 13:19:29.538	162.00	шт	12	только уп
53442	3327	КОРНИШОНЫ 1500мл ст/б ТМ Сыта-Загора	\N	\N	2256.00	уп (6 шт)	1	152	t	2025-12-07 13:19:29.554	2025-12-07 13:19:29.554	376.00	шт	6	только уп
53443	3327	КОРНИШОНЫ 720мл ст/б ТМ Сыта-Загора	\N	\N	2263.00	уп (12 шт)	1	287	t	2025-12-07 13:19:29.566	2025-12-07 13:19:29.566	189.00	шт	12	только уп
53444	3327	КОРНИШОНЫ с луком 540мл ст/б ТМ Сыта-Загора	\N	\N	1918.00	уп (12 шт)	1	11	t	2025-12-07 13:19:29.577	2025-12-07 13:19:29.577	160.00	шт	12	только уп
53445	3327	КОРНИШОНЫ с перцем 540мл ст/б ТМ Сыта-Загора	\N	\N	1918.00	уп (12 шт)	1	138	t	2025-12-07 13:19:29.599	2025-12-07 13:19:29.599	160.00	шт	12	только уп
53446	3327	КОРНИШОНЫ с хреном 540мл ст/б ТМ Сыта-Загора	\N	\N	1973.00	уп (12 шт)	1	108	t	2025-12-07 13:19:29.611	2025-12-07 13:19:29.611	164.00	шт	12	только уп
53447	3327	ЛЕЧО по-болгарски 680гр ст/б Сыта-Загора	\N	\N	1463.00	уп (8 шт)	1	18	t	2025-12-07 13:19:29.623	2025-12-07 13:19:29.623	183.00	шт	8	только уп
53448	3327	ЛЕЧО твист 680гр ГОСТ  ТМ Закромеево	\N	\N	1242.00	уп (8 шт)	1	22	t	2025-12-07 13:19:29.654	2025-12-07 13:19:29.654	155.00	шт	8	только уп
53449	3327	ОГУРЧИКИ 1500мл консервированные ст/б ТМ Сыта-Загора	\N	\N	1973.00	уп (6 шт)	1	371	t	2025-12-07 13:19:29.678	2025-12-07 13:19:29.678	329.00	шт	6	только уп
53450	3327	ОГУРЧИКИ 3100мл консервированные ж/б ТМ Сыта-Загора	\N	\N	3478.00	уп (6 шт)	1	449	t	2025-12-07 13:19:29.709	2025-12-07 13:19:29.709	580.00	шт	6	только уп
53451	3327	ОГУРЧИКИ 720мл консервированные ж/б ТМ Сыта-Загора	\N	\N	2070.00	уп (12 шт)	1	1400	t	2025-12-07 13:19:29.719	2025-12-07 13:19:29.719	173.00	шт	12	только уп
53452	3327	ПОМИДОРКИ 1500мл маринованые в собственном соку ст/б ТМ Сыта-Загора	\N	\N	2056.00	уп (6 шт)	1	296	t	2025-12-07 13:19:29.731	2025-12-07 13:19:29.731	343.00	шт	6	только уп
53453	3327	ПОМИДОРКИ 1500мл маринованые ст/б ТМ Сыта-Загора	\N	\N	1904.00	уп (6 шт)	1	172	t	2025-12-07 13:19:29.758	2025-12-07 13:19:29.758	317.00	шт	6	только уп
53454	3327	ПОМИДОРКИ 720мл маринованые в собственном соку ст/б ТМ Сыта-Загора	\N	\N	1932.00	уп (12 шт)	1	431	t	2025-12-07 13:19:29.777	2025-12-07 13:19:29.777	161.00	шт	12	только уп
53455	3394	ВАРЕНЬЕ Абрикосовое ст/б 320гр ТМ Знаток	\N	\N	2318.00	уп (12 шт)	1	276	t	2025-12-07 13:19:29.789	2025-12-07 13:19:29.789	193.00	шт	12	только уп
53456	3394	ВАРЕНЬЕ Клубничное ст/б 320гр ТМ Знаток	\N	\N	2318.00	уп (12 шт)	1	779	t	2025-12-07 13:19:29.816	2025-12-07 13:19:29.816	193.00	шт	12	только уп
53457	3394	ВАРЕНЬЕ Клюквенное ст/б 320гр ТМ Знаток	\N	\N	2318.00	уп (12 шт)	1	265	t	2025-12-07 13:19:29.832	2025-12-07 13:19:29.832	193.00	шт	12	только уп
53458	3394	ВАРЕНЬЕ Малиновое ст/б 320гр ТМ Знаток	\N	\N	2677.00	уп (12 шт)	1	665	t	2025-12-07 13:19:29.844	2025-12-07 13:19:29.844	223.00	шт	12	только уп
53459	3394	ДЖЕМ Абрикосовый ст/б 320гр ТМ Знаток	\N	\N	3229.00	уп (12 шт)	1	37	t	2025-12-07 13:19:29.856	2025-12-07 13:19:29.856	269.00	шт	12	только уп
53460	3394	ДЖЕМ Клубничный ст/б 320гр ТМ Знаток	\N	\N	1973.00	уп (12 шт)	1	75	t	2025-12-07 13:19:29.867	2025-12-07 13:19:29.867	164.00	шт	12	только уп
53461	3327	АДЖИКА Домашняя 350гр ст/б ТМ Пиканта	\N	\N	1042.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.88	2025-12-07 13:19:29.88	174.00	шт	6	только уп
53462	3327	АППЕТИТКА с нежно-острым вкусом 360гр ст/б ТМ Пиканта	\N	\N	980.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.89	2025-12-07 13:19:29.89	163.00	шт	6	только уп
53463	3327	БАКЛАЖАНЫ в аджике 460гр ст/б ТМ Пиканта	\N	\N	1277.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.9	2025-12-07 13:19:29.9	213.00	шт	6	только уп
53464	3327	БАКЛАЖАНЫ печёные в томатном соусе 450гр ст/б ТМ Пиканта	\N	\N	1277.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.911	2025-12-07 13:19:29.911	213.00	шт	6	только уп
53465	3327	БАКЛАЖАНЫ по-Домашнему 450гр ст/б ТМ Пиканта	\N	\N	1228.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.93	2025-12-07 13:19:29.93	205.00	шт	6	только уп
53466	3327	БАКЛАЖАНЫ по-Китайски кисло-сладкий соус 360гр ст/б ТМ Пиканта	\N	\N	1394.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.941	2025-12-07 13:19:29.941	232.00	шт	6	только уп
53467	3327	ЗАКУСКА Астраханская 460гр ст/б ТМ Пиканта	\N	\N	1359.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.953	2025-12-07 13:19:29.953	227.00	шт	6	только уп
53468	3327	ЗАКУСКА Венгерская 470гр ст/б ТМ Пиканта	\N	\N	1290.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.965	2025-12-07 13:19:29.965	215.00	шт	6	только уп
53469	3327	ЗАКУСКА для зятя ст/б 460гр ТМ Пиканта	\N	\N	1359.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.975	2025-12-07 13:19:29.975	227.00	шт	6	только уп
53470	3327	ЗАКУСКА для тещи ст/б 440гр ТМ Пиканта	\N	\N	1290.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.989	2025-12-07 13:19:29.989	215.00	шт	6	только уп
53471	3327	ЗАКУСКА Закарпатская ст/б 460гр ТМ Пиканта	\N	\N	1228.00	уп (6 шт)	1	200	t	2025-12-07 13:19:29.999	2025-12-07 13:19:29.999	205.00	шт	6	только уп
53472	3327	ИКРА из баклажанов 450гр ст/б ТМ Пиканта	\N	\N	1104.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.066	2025-12-07 13:19:30.066	184.00	шт	6	только уп
53473	3327	ИКРА из кабачков 450гр ст/б ТМ Пиканта	\N	\N	987.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.091	2025-12-07 13:19:30.091	164.00	шт	6	только уп
53474	3327	ЛЕЧО 450гр ст/б Пиканта	\N	\N	1118.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.121	2025-12-07 13:19:30.121	186.00	шт	6	только уп
53475	3327	ОГУРЧИКИ корнишоны по-Баварски 3-6см 700гр ст/б ТМ Пиканта	\N	\N	1780.00	уп (6 шт)	1	32	t	2025-12-07 13:19:30.147	2025-12-07 13:19:30.147	297.00	шт	6	только уп
53476	3327	ОГУРЧИКИ маринованные ГОСТ 460гр ст/б ТМ Пиканта	\N	\N	1435.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.211	2025-12-07 13:19:30.211	239.00	шт	6	только уп
53477	3327	ОГУРЧИКИ маринованные отборные в томатном соусе 700гр ст/б ТМ Пиканта	\N	\N	1511.00	уп (6 шт)	1	9	t	2025-12-07 13:19:30.245	2025-12-07 13:19:30.245	252.00	шт	6	только уп
53478	3327	ОГУРЧИКИ по-Баварски 3-6см 460гр ст/б ТМ Пиканта	\N	\N	1387.00	уп (6 шт)	1	94	t	2025-12-07 13:19:30.263	2025-12-07 13:19:30.263	231.00	шт	6	только уп
53479	3327	ПАССАТА (измельченная  мякоть томатов) 340гр т/пак ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.281	2025-12-07 13:19:30.281	152.00	шт	6	только уп
53480	3327	ТОМАТЫ Астраханские в собственном соку 690гр ст/б ТМ Пиканта	\N	\N	1277.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.296	2025-12-07 13:19:30.296	213.00	шт	6	только уп
53481	3327	ТОМАТЫ Астраханские маринованные 670гр ст/б ТМ Пиканта	\N	\N	1028.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.378	2025-12-07 13:19:30.378	171.00	шт	6	только уп
53482	3327	ТОМАТЫ протёртая мякоть 500гр тетра-пак ТМ Пиканта ИТАЛИЯ	\N	\N	1956.00	уп (9 шт)	1	13	t	2025-12-07 13:19:30.447	2025-12-07 13:19:30.447	217.00	шт	9	только уп
53483	3327	ФАСОЛЬ печёная в аджике 470гр ст/б ТМ Пиканта	\N	\N	1373.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.53	2025-12-07 13:19:30.53	229.00	шт	6	только уп
53484	3327	ФАСОЛЬ печёная в томатном соусе 470гр ст/б ТМ Пиканта	\N	\N	1235.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.55	2025-12-07 13:19:30.55	206.00	шт	6	только уп
53485	3327	ФАСОЛЬ печёная с баклажанами 470гр ст/б ТМ Пиканта	\N	\N	1373.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.563	2025-12-07 13:19:30.563	229.00	шт	6	только уп
53486	3327	ФАСОЛЬ по-Домашнему с грибами 470гр ст/б ТМ Пиканта	\N	\N	1421.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.578	2025-12-07 13:19:30.578	237.00	шт	6	только уп
53487	3327	ФАСОЛЬ по-Мексикански с кукурузой 470гр ст/б ТМ Пиканта	\N	\N	1511.00	уп (6 шт)	1	146	t	2025-12-07 13:19:30.59	2025-12-07 13:19:30.59	252.00	шт	6	только уп
53488	3327	ФАСОЛЬ по-Монастырски с овощами 470гр ТМ Пиканта	\N	\N	1283.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.621	2025-12-07 13:19:30.621	214.00	шт	6	только уп
53489	3327	ХЕ из баклажанов по-Корейски 360гр ст/б ТМ Пиканта	\N	\N	1270.00	уп (6 шт)	1	191	t	2025-12-07 13:19:30.635	2025-12-07 13:19:30.635	212.00	шт	6	только уп
53490	3327	АССОРТИ корнишон/черри 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	2401.00	уп (8 шт)	1	124	t	2025-12-07 13:19:30.662	2025-12-07 13:19:30.662	300.00	шт	8	только уп
53491	3327	АССОРТИ огурцы/томаты 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	2033.00	уп (8 шт)	1	99	t	2025-12-07 13:19:30.684	2025-12-07 13:19:30.684	254.00	шт	8	только уп
53492	3327	ГРИБЫ ГРИБНОЕ ЛУКОШКО 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	2815.00	уп (12 шт)	1	112	t	2025-12-07 13:19:30.728	2025-12-07 13:19:30.728	235.00	шт	12	только уп
25617	2755	СЫРОК Савушкин Творобушки малина глазированный 40гр	\N	\N	828.00	уп (18 шт)	1	200	f	2025-11-10 01:55:51.411	2025-11-22 01:30:48.533	46.00	шт	18	\N
25618	2755	СЫРОК Савушкин Творобушки шоколад глазированный 40гр	\N	\N	828.00	уп (18 шт)	1	18	f	2025-11-10 01:55:51.463	2025-11-22 01:30:48.533	46.00	шт	18	\N
53493	3327	ГРИБЫ ГРУЗДИ маринованные 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	3271.00	уп (12 шт)	1	200	t	2025-12-07 13:19:30.749	2025-12-07 13:19:30.749	273.00	шт	12	только уп
53494	3327	ГРИБЫ МАСЛЯТА маринованные 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	3685.00	уп (12 шт)	1	122	t	2025-12-07 13:19:30.764	2025-12-07 13:19:30.764	307.00	шт	12	только уп
53495	3327	ГРИБЫ ОПЯТА маринованные 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	3671.00	уп (12 шт)	1	200	t	2025-12-07 13:19:30.779	2025-12-07 13:19:30.779	306.00	шт	12	только уп
53496	3327	ГРИБЫ ОПЯТА маринованные 580мл ст/б ТМ Скатерть-Самобранка	\N	\N	4830.00	уп (12 шт)	1	128	t	2025-12-07 13:19:30.799	2025-12-07 13:19:30.799	402.00	шт	12	только уп
53497	3327	ИКРА из кабачков 500мл ст/б Скатерть-Самобранка	\N	\N	2208.00	уп (12 шт)	1	200	t	2025-12-07 13:19:30.81	2025-12-07 13:19:30.81	184.00	шт	12	только уп
53498	3327	ИМБИРЬ маринованный розовый 250гр ст/б ТМ Скатерть-Самобранка	\N	\N	2443.00	уп (12 шт)	1	200	t	2025-12-07 13:19:30.822	2025-12-07 13:19:30.822	204.00	шт	12	только уп
53499	3327	КОРНИШОНЫ 370мл хрустящие ст/б ТМ Скатерть-Самобранка	\N	\N	2346.00	уп (12 шт)	1	111	t	2025-12-07 13:19:30.839	2025-12-07 13:19:30.839	195.00	шт	12	только уп
53500	3327	КОРНИШОНЫ 500мл хрустящие ст/б ТМ Скатерть-Самобранка	\N	\N	3091.00	уп (12 шт)	1	85	t	2025-12-07 13:19:30.852	2025-12-07 13:19:30.852	258.00	шт	12	только уп
53501	3327	КОРНИШОНЫ 720мл хрустящие ст/б ТМ Скатерть-Самобранка	\N	\N	2622.00	уп (8 шт)	1	200	t	2025-12-07 13:19:30.868	2025-12-07 13:19:30.868	328.00	шт	8	только уп
53502	3327	ЛЕЧО 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	1969.00	уп (8 шт)	1	200	t	2025-12-07 13:19:30.889	2025-12-07 13:19:30.889	246.00	шт	8	только уп
53503	3327	МОРКОВЬ по-Корейски Острая 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	1877.00	уп (12 шт)	1	200	t	2025-12-07 13:19:30.906	2025-12-07 13:19:30.906	156.00	шт	12	только уп
53504	3327	ОГУРЦЫ Соленые по-Домашнему 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	2337.00	уп (8 шт)	1	200	t	2025-12-07 13:19:30.918	2025-12-07 13:19:30.918	292.00	шт	8	только уп
53505	3327	ОГУРЦЫ Соленые по-Домашнему бочковые 950мл ст/б ТМ Скатерть-Самобранка СКИДКА 20%	\N	\N	1856.00	уп (6 шт)	1	80	t	2025-12-07 13:19:30.931	2025-12-07 13:19:30.931	309.00	шт	6	только уп
53506	3327	ОГУРЧИКИ 1415мл хрустящие ст/б ТМ Скатерть-Самобранка	\N	\N	2650.00	уп (6 шт)	1	101	t	2025-12-07 13:19:30.977	2025-12-07 13:19:30.977	442.00	шт	6	только уп
53507	3327	ОГУРЧИКИ 1500мл маринованые ст/б ТМ Скатерть-Самобранка	\N	\N	2760.00	уп (6 шт)	1	200	t	2025-12-07 13:19:30.997	2025-12-07 13:19:30.997	460.00	шт	6	только уп
53508	3327	ОГУРЧИКИ 720мл хрустящие марин ст/б ТМ Скатерть-Самобранка	\N	\N	2088.00	уп (8 шт)	1	200	t	2025-12-07 13:19:31.012	2025-12-07 13:19:31.012	261.00	шт	8	только уп
53509	3327	ПАТИССОНЧИКИ маринованные 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	2760.00	уп (8 шт)	1	200	t	2025-12-07 13:19:31.024	2025-12-07 13:19:31.024	345.00	шт	8	только уп
53510	3327	ПЕРЧИК Мини острый 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	2926.00	уп (12 шт)	1	177	t	2025-12-07 13:19:31.04	2025-12-07 13:19:31.04	244.00	шт	12	только уп
53511	3327	ПЕРЧИК Халапеньо красный 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	2415.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.061	2025-12-07 13:19:31.061	201.00	шт	12	только уп
53512	3327	ПЕРЧИК Халапеньо острый 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	2277.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.083	2025-12-07 13:19:31.083	190.00	шт	12	только уп
53513	3327	ПИКУЛИ ДЕЛИКАТЕСНЫЕ 1415мл маринованые (огурчики) ст/б ТМ Скатерть-Самобранка	\N	\N	4630.00	уп (6 шт)	1	108	t	2025-12-07 13:19:31.095	2025-12-07 13:19:31.095	772.00	шт	6	только уп
53514	3327	ПИКУЛИ ДЕЛИКАТЕСНЫЕ 580мл маринованые (огурчики) ст/б ТМ Скатерть-Самобранка	\N	\N	4085.00	уп (12 шт)	1	172	t	2025-12-07 13:19:31.11	2025-12-07 13:19:31.11	340.00	шт	12	только уп
53515	3327	ПОМИДОРЧИКИ  в собственном соку 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	1748.00	уп (8 шт)	1	200	t	2025-12-07 13:19:31.123	2025-12-07 13:19:31.123	218.00	шт	8	только уп
53516	3327	ПОМИДОРЧИКИ  маринованные 1500мл ст/б ТМ Скатерть-Самобранка	\N	\N	2332.00	уп (6 шт)	1	200	t	2025-12-07 13:19:31.134	2025-12-07 13:19:31.134	389.00	шт	6	только уп
53517	3327	ПОМИДОРЧИКИ  маринованные 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	1739.00	уп (8 шт)	1	200	t	2025-12-07 13:19:31.15	2025-12-07 13:19:31.15	217.00	шт	8	только уп
53518	3327	ТОМАТЫ Желтые медовые маринованные 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	1674.00	уп (8 шт)	1	200	t	2025-12-07 13:19:31.165	2025-12-07 13:19:31.165	209.00	шт	8	только уп
53519	3327	ТОМАТЫ Медовые маринованные 1500мл ст/б ТМ Скатерть-Самобранка	\N	\N	2249.00	уп (6 шт)	1	24	t	2025-12-07 13:19:31.176	2025-12-07 13:19:31.176	375.00	шт	6	только уп
53520	3327	ТОМАТЫ ЧЕРРИ маринованные 580мл ст/б ТМ Скатерть-Самобранка	\N	\N	2926.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.192	2025-12-07 13:19:31.192	244.00	шт	12	только уп
53521	3327	ТОМАТЫ ЧЕРРИ медовые 580мл ст/б ТМ Скатерть-Самобранка	\N	\N	3077.00	уп (12 шт)	1	64	t	2025-12-07 13:19:31.203	2025-12-07 13:19:31.203	256.00	шт	12	только уп
54522	3395	КАРТОФЕЛЬ Фри 700гр ТМ Морозко Green	\N	\N	3312.00	шт	1	164	t	2025-12-07 13:19:49.199	2025-12-07 13:19:49.199	276.00	шт	12	поштучно
53522	3327	ФАСОЛЬ Отборная белая 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	1725.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.215	2025-12-07 13:19:31.215	144.00	шт	12	только уп
53523	3327	ФАСОЛЬ Отборная красная 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	1601.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.295	2025-12-07 13:19:31.295	133.00	шт	12	только уп
53524	3327	ЧЕРЕМША маринованная По-Восточному 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	3160.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.315	2025-12-07 13:19:31.315	263.00	шт	12	только уп
53525	3327	ГРИБЫ шампиньоны резаные ж/б 850мл ст/б ТМ Знаток	\N	\N	2360.00	уп (12 шт)	1	45	t	2025-12-07 13:19:31.326	2025-12-07 13:19:31.326	197.00	шт	12	только уп
53526	3327	АССОРТИ марин 720мл ТМ Сонна Мера	\N	\N	3036.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.373	2025-12-07 13:19:31.373	253.00	шт	12	только уп
53527	3327	ОГУРЦЫ марин 720мл с луком ТМ Сонна Мера	\N	\N	3560.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.385	2025-12-07 13:19:31.385	297.00	шт	12	только уп
53528	3327	ОГУРЦЫ марин 720мл с острым перцем ТМ Сонна Мера	\N	\N	3560.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.4	2025-12-07 13:19:31.4	297.00	шт	12	только уп
53529	3327	ОГУРЦЫ марин 720мл с чесноком ТМ Сонна Мера	\N	\N	3574.00	уп (12 шт)	1	192	t	2025-12-07 13:19:31.416	2025-12-07 13:19:31.416	298.00	шт	12	только уп
53530	3327	ОГУРЦЫ марин Корнишоны 370мл 3-6мм ТМ Сонна Мера	\N	\N	2829.00	уп (12 шт)	1	119	t	2025-12-07 13:19:31.439	2025-12-07 13:19:31.439	236.00	шт	12	только уп
53531	3327	ОГУРЦЫ марин Корнишоны 370мл Мини ТМ Сонна Мера	\N	\N	3008.00	уп (12 шт)	1	71	t	2025-12-07 13:19:31.45	2025-12-07 13:19:31.45	251.00	шт	12	только уп
53532	3327	ОГУРЦЫ марин Корнишоны 500мл 3-6см ТМ Сонна Мера	\N	\N	3409.00	уп (12 шт)	1	123	t	2025-12-07 13:19:31.462	2025-12-07 13:19:31.462	284.00	шт	12	только уп
53533	3327	ОГУРЦЫ марин Корнишоны 500мл Мини ТМ Сонна Мера	\N	\N	3519.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.474	2025-12-07 13:19:31.474	293.00	шт	12	только уп
53534	3327	ОГУРЦЫ марин Корнишоны 720мл ТМ Сонна Мера	\N	\N	3905.00	уп (12 шт)	1	99	t	2025-12-07 13:19:31.486	2025-12-07 13:19:31.486	325.00	шт	12	только уп
53535	3327	ГОРОШЕК консервир 400гр ж/б  ТМ Знаток	\N	\N	1339.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.504	2025-12-07 13:19:31.504	112.00	шт	12	только уп
53536	3327	ГОРОШЕК консервир 425гр ж/б ТМ Сыта-Загора	\N	\N	2788.00	уп (24 шт)	1	200	t	2025-12-07 13:19:31.515	2025-12-07 13:19:31.515	116.00	шт	24	только уп
53537	3327	ГОРОШЕК консервир 425мл ж/б  ТМ Добровита	\N	\N	952.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.528	2025-12-07 13:19:31.528	79.00	шт	12	только уп
53538	3327	ГОРОШЕК консервир 425мл ж/б  ТМ Прошу к столу	\N	\N	787.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.54	2025-12-07 13:19:31.54	66.00	шт	12	только уп
53539	3327	ГОРОШЕК консервир 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	1863.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.553	2025-12-07 13:19:31.553	155.00	шт	12	только уп
53540	3327	ГОРОШЕК консервир 450гр ст/б  ТМ Знаток	\N	\N	1086.00	уп (8 шт)	1	148	t	2025-12-07 13:19:31.565	2025-12-07 13:19:31.565	136.00	шт	8	только уп
53541	3327	ГОРОШЕК молодой консервир 425мл ж/б  ТМ Добровита	\N	\N	2153.00	уп (24 шт)	1	200	t	2025-12-07 13:19:31.576	2025-12-07 13:19:31.576	90.00	шт	24	только уп
53542	3327	КУКУРУЗА консервир 425мл ж/б  ТМ Добровита	\N	\N	2249.00	уп (24 шт)	1	200	t	2025-12-07 13:19:31.588	2025-12-07 13:19:31.588	94.00	шт	24	только уп
53543	3327	КУКУРУЗА консервир 425мл ж/б  ТМ Знаток	\N	\N	1408.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.599	2025-12-07 13:19:31.599	117.00	шт	12	только уп
53544	3327	КУКУРУЗА консервир 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	2070.00	уп (12 шт)	1	200	t	2025-12-07 13:19:31.61	2025-12-07 13:19:31.61	173.00	шт	12	только уп
53545	3327	КУКУРУЗА консервир 425мл ж/б  ТМ Сыта-Загора	\N	\N	2249.00	уп (24 шт)	1	200	t	2025-12-07 13:19:31.624	2025-12-07 13:19:31.624	94.00	шт	24	только уп
53546	3327	КАПУСТА квашеная бочковая (бочка + вкдадыш) 50кг	\N	\N	13800.00	кг	1	100	t	2025-12-07 13:19:31.67	2025-12-07 13:19:31.67	276.00	кг	50	поштучно
53547	3327	ОГУРЦЫ соленые бочковые (бочка + вкдадыш) 1/34кг	\N	\N	10987.00	кг	1	100	t	2025-12-07 13:19:31.713	2025-12-07 13:19:31.713	323.00	кг	34	поштучно
53548	3327	ТОМАТЫ соленые бочковые (бочка + вкдадыш) 1/31кг	\N	\N	10624.00	кг	1	100	t	2025-12-07 13:19:31.726	2025-12-07 13:19:31.726	343.00	кг	31	поштучно
53549	3327	ТОМАТЫ соленые бочковые (бочка + вкдадыш) 1/36кг	\N	\N	12337.00	кг	1	100	t	2025-12-07 13:19:31.739	2025-12-07 13:19:31.739	343.00	кг	36	поштучно
53550	3327	ТОМАТНАЯ ПАСТА  3000гр ведро ТМ Знаток	\N	\N	891.00	уп (1 шт)	1	200	t	2025-12-07 13:19:31.784	2025-12-07 13:19:31.784	891.00	шт	1	только уп
53551	3327	ТОМАТНАЯ ПАСТА 270гр ст/б ТМ Пиканта	\N	\N	1014.00	уп (6 шт)	1	200	t	2025-12-07 13:19:31.795	2025-12-07 13:19:31.795	169.00	шт	6	только уп
53552	3327	ТОМАТНАЯ ПАСТА 280гр дойпак ТМ Пиканта	\N	\N	1426.00	уп (10 шт)	1	200	t	2025-12-07 13:19:31.808	2025-12-07 13:19:31.808	143.00	шт	10	только уп
53553	3327	ТОМАТНАЯ ПАСТА 490гр ст/б ТМ Пиканта	\N	\N	1470.00	уп (6 шт)	1	200	t	2025-12-07 13:19:31.827	2025-12-07 13:19:31.827	245.00	шт	6	только уп
53554	3327	ТОМАТНАЯ ПАСТА 70гр дойпак ТМ Пиканта	\N	\N	989.00	уп (20 шт)	1	200	t	2025-12-07 13:19:31.84	2025-12-07 13:19:31.84	49.00	шт	20	только уп
53555	3327	Абрикосовый компот 680гр ст/б ТМ Знаток	\N	\N	1766.00	уп (8 шт)	1	27	t	2025-12-07 13:19:31.865	2025-12-07 13:19:31.865	221.00	шт	8	только уп
53556	3327	АНАНАС кусочки 565гр ж/б ТМ Знаток	\N	\N	5410.00	уп (24 шт)	1	12	t	2025-12-07 13:19:31.892	2025-12-07 13:19:31.892	225.00	шт	24	только уп
53557	3327	Вишневый компот 680гр ст/б ТМ Знаток	\N	\N	1932.00	уп (8 шт)	1	119	t	2025-12-07 13:19:31.904	2025-12-07 13:19:31.904	241.00	шт	8	только уп
53558	3327	ВИШНЯ в сладком сиропе с/к 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	3146.00	уп (8 шт)	1	140	t	2025-12-07 13:19:31.933	2025-12-07 13:19:31.933	393.00	шт	8	только уп
53559	3327	МАНГО дольки 425мл ж/б 1/12шт ТМ VITALAND	\N	\N	3160.00	уп (12 шт)	1	79	t	2025-12-07 13:19:31.969	2025-12-07 13:19:31.969	263.00	шт	12	только уп
53560	3327	ПЕРСИКИ половинки в сиропе 410гр ж/б ТМ Знаток	\N	\N	4112.00	уп (24 шт)	1	200	t	2025-12-07 13:19:31.998	2025-12-07 13:19:31.998	171.00	шт	24	только уп
53561	3327	Сливовый компот 680гр ст/б ТМ Знаток	\N	\N	1720.00	уп (8 шт)	1	24	t	2025-12-07 13:19:32.012	2025-12-07 13:19:32.012	215.00	шт	8	только уп
53562	3327	ФРУКТОВЫЙ коктейль 410гр ж/б ТМ Знаток	\N	\N	3947.00	уп (24 шт)	1	172	t	2025-12-07 13:19:32.025	2025-12-07 13:19:32.025	164.00	шт	24	только уп
25679	2755	Азу из курицы с картоф пюре 350гр ТМ Сытоедов	\N	\N	2650.00	уп (10 шт)	1	99	f	2025-11-10 01:55:54.629	2025-11-22 01:30:48.533	265.00	шт	10	\N
25703	2755	Лапша WOK Удон с говядиной и овощами 300гр ТМ Главобед	\N	\N	2244.00	уп (6 шт)	1	112	f	2025-11-10 01:55:56.009	2025-11-22 01:30:48.533	374.00	шт	6	\N
25712	2755	Паста Палермо с курицей и грибами 300гр ТМ Сытоедов	\N	\N	2304.00	уп (8 шт)	1	15	f	2025-11-10 01:55:56.455	2025-11-22 01:30:48.533	288.00	шт	8	\N
53563	3327	МАСЛИНЫ отборные 280гр без косточки ж/б ТМ Знаток	\N	\N	2194.00	уп (12 шт)	1	130	t	2025-12-07 13:19:32.037	2025-12-07 13:19:32.037	183.00	шт	12	только уп
53564	3327	МАСЛИНЫ отборные 300мл  без косточки ж/б ТМ Скатерть-Самобранка	\N	\N	3367.00	уп (12 шт)	1	200	t	2025-12-07 13:19:32.054	2025-12-07 13:19:32.054	281.00	шт	12	только уп
53565	3327	МАСЛИНЫ отборные 330гр без косточки ст/б ТМ Знаток	\N	\N	4043.00	уп (12 шт)	1	176	t	2025-12-07 13:19:32.07	2025-12-07 13:19:32.07	337.00	шт	12	только уп
53566	3327	Маслины Халкидики б/к чёрные 340гр 1/12	\N	\N	3864.00	уп (12 шт)	1	200	t	2025-12-07 13:19:32.092	2025-12-07 13:19:32.092	322.00	шт	12	только уп
53567	3327	Оливки "Гигант" Греческие б/к  340гр 1/12	\N	\N	3864.00	уп (12 шт)	1	200	t	2025-12-07 13:19:32.111	2025-12-07 13:19:32.111	322.00	шт	12	только уп
53568	3327	ОЛИВКИ отборные 280гр без косточки ж/б ТМ Знаток	\N	\N	2111.00	уп (12 шт)	1	200	t	2025-12-07 13:19:32.122	2025-12-07 13:19:32.122	176.00	шт	12	только уп
53569	3327	ОЛИВКИ отборные 300мл  без косточки ж/б ТМ Скатерть-Самобранка	\N	\N	3215.00	уп (12 шт)	1	200	t	2025-12-07 13:19:32.134	2025-12-07 13:19:32.134	268.00	шт	12	только уп
53570	3327	ОЛИВКИ с анчоусом 280гр без косточки ж/б ТМ Знаток	\N	\N	2429.00	уп (12 шт)	1	9	t	2025-12-07 13:19:32.149	2025-12-07 13:19:32.149	202.00	шт	12	только уп
53571	3327	ОЛИВКИ с креветкой 280гр без косточки ж/б ТМ Знаток	\N	\N	2429.00	уп (12 шт)	1	37	t	2025-12-07 13:19:32.161	2025-12-07 13:19:32.161	202.00	шт	12	только уп
53572	3327	ОЛИВКИ с лимоном 280гр без косточки ж/б ТМ Знаток	\N	\N	2429.00	уп (12 шт)	1	100	t	2025-12-07 13:19:32.18	2025-12-07 13:19:32.18	202.00	шт	12	только уп
53573	3303	СИРОП 250мл апельсиновый ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-07 13:19:32.201	2025-12-07 13:19:32.201	152.00	шт	6	только уп
53574	3303	СИРОП 250мл вишневый ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-07 13:19:32.213	2025-12-07 13:19:32.213	152.00	шт	6	только уп
53575	3303	СИРОП 250мл Дюшес ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	157	t	2025-12-07 13:19:32.225	2025-12-07 13:19:32.225	152.00	шт	6	только уп
53576	3303	СИРОП 250мл кленовый ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-07 13:19:32.239	2025-12-07 13:19:32.239	152.00	шт	6	только уп
53577	3303	СИРОП 250мл клубничный ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-07 13:19:32.254	2025-12-07 13:19:32.254	152.00	шт	6	только уп
53578	3303	СИРОП 250мл клюквенный ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	193	t	2025-12-07 13:19:32.269	2025-12-07 13:19:32.269	152.00	шт	6	только уп
53579	3303	СИРОП 250мл лимонный ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-07 13:19:32.35	2025-12-07 13:19:32.35	152.00	шт	6	только уп
53580	3303	СИРОП 250мл малиновый ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-07 13:19:32.411	2025-12-07 13:19:32.411	152.00	шт	6	только уп
53581	3303	СИРОП 250мл Черная смородина ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-07 13:19:32.43	2025-12-07 13:19:32.43	152.00	шт	6	только уп
53582	3303	СИРОП 250мл шиповник ТМ Пиканта	\N	\N	1283.00	уп (6 шт)	1	191	t	2025-12-07 13:19:32.442	2025-12-07 13:19:32.442	214.00	шт	6	только уп
53583	3327	САЙРА масло 240гр Морское Содружество	\N	\N	8004.00	шт	1	200	t	2025-12-07 13:19:32.518	2025-12-07 13:19:32.518	167.00	шт	48	поштучно
53584	3327	САЙРА натуральная 240гр Морское Содружество	\N	\N	7894.00	шт	1	200	t	2025-12-07 13:19:32.536	2025-12-07 13:19:32.536	164.00	шт	48	поштучно
53585	3327	САЙРА натуральная 250гр ключ ТМ Барс	\N	\N	8418.00	шт	1	200	t	2025-12-07 13:19:32.556	2025-12-07 13:19:32.556	351.00	шт	24	поштучно
53586	3327	САЙРА с добавлением масла 250гр ключ ТМ Барс	\N	\N	8418.00	шт	1	200	t	2025-12-07 13:19:32.578	2025-12-07 13:19:32.578	351.00	шт	24	поштучно
53587	3327	САРДИНА 230гр т/о ИВАСИ 1/24шт ТМ Санта Бремор	\N	\N	3947.00	шт	1	6	t	2025-12-07 13:19:32.605	2025-12-07 13:19:32.605	164.00	шт	24	поштучно
53588	3327	САРДИНА атлантическая в томате (куски) 250гр ключ ТМ Барс	\N	\N	5354.00	шт	1	200	t	2025-12-07 13:19:32.624	2025-12-07 13:19:32.624	223.00	шт	24	поштучно
53589	3327	САРДИНА атлантическая масло (куски) 250гр ключ ТМ Барс	\N	\N	5023.00	шт	1	200	t	2025-12-07 13:19:32.635	2025-12-07 13:19:32.635	209.00	шт	24	поштучно
53590	3327	КИЛЬКА в томате Балтийская 240гр Рыбная Бухта	\N	\N	3367.00	шт	1	268	t	2025-12-07 13:19:32.653	2025-12-07 13:19:32.653	70.00	шт	48	поштучно
53591	3327	КИЛЬКА в томате Балтийская 250гр ключ ТМ Барс	\N	\N	3478.00	шт	1	300	t	2025-12-07 13:19:32.664	2025-12-07 13:19:32.664	145.00	шт	24	поштучно
53592	3327	КИЛЬКА в томате Балтийская в соусе По-болгарски с овощным гарниром 240гр ключ ТМ Барс	\N	\N	3560.00	шт	1	216	t	2025-12-07 13:19:32.68	2025-12-07 13:19:32.68	148.00	шт	24	поштучно
53593	3327	КИЛЬКА в томате Балтийская обжаренная 240гр ТМ Барс	\N	\N	3781.00	шт	1	300	t	2025-12-07 13:19:32.695	2025-12-07 13:19:32.695	158.00	шт	24	поштучно
53594	3327	КИЛЬКА в томате копченая Балтийская 250гр ключ ТМ Барс	\N	\N	3367.00	шт	1	300	t	2025-12-07 13:19:32.711	2025-12-07 13:19:32.711	140.00	шт	24	поштучно
53595	3327	ШПРОТЫ в масле 160гр ключ ТМ Барс	\N	\N	4168.00	шт	1	300	t	2025-12-07 13:19:32.741	2025-12-07 13:19:32.741	174.00	шт	24	поштучно
53596	3327	ШПРОТЫ в масле 175гр ключ  Ханса из балтийской кильки ТМ Барс Замок	\N	\N	2926.00	шт	1	300	t	2025-12-07 13:19:32.763	2025-12-07 13:19:32.763	244.00	шт	12	поштучно
53597	3327	ШПРОТЫ в масле 240гр ключ ТМ Барс	\N	\N	5713.00	шт	1	300	t	2025-12-07 13:19:32.776	2025-12-07 13:19:32.776	238.00	шт	24	поштучно
25747	2755	ВАРЕНИКИ Бабушка Аня 430гр картофель и лук 1/10шт ТМ Санта Бремор	\N	\N	1360.00	уп (10 шт)	1	141	f	2025-11-10 01:55:58.127	2025-11-22 01:30:48.533	136.00	шт	10	\N
25748	2755	ВАРЕНИКИ Бабушка Аня 430гр картофель и шкварки 1/10шт ТМ Санта Бремор	\N	\N	1430.00	уп (10 шт)	1	139	f	2025-11-10 01:55:58.22	2025-11-22 01:30:48.533	143.00	шт	10	\N
53598	3367	ГОРБУША натуральная 250гр Морепродукт	\N	\N	11316.00	шт	1	300	t	2025-12-07 13:19:32.794	2025-12-07 13:19:32.794	236.00	шт	48	поштучно
53599	3367	ИКРА трески натуральная 160гр ключТМ Барс	\N	\N	5106.00	шт	1	96	t	2025-12-07 13:19:32.808	2025-12-07 13:19:32.808	213.00	шт	24	поштучно
53600	3367	МОРСКАЯ КАПУСТА Салат Дальневосточный 220гр Морское Содружество	\N	\N	1642.00	шт	1	300	t	2025-12-07 13:19:32.82	2025-12-07 13:19:32.82	68.00	шт	24	поштучно
53601	3367	ПЕЧЕНЬ трески натуральная 115гр ключТМ Барс	\N	\N	4388.00	шт	1	223	t	2025-12-07 13:19:32.832	2025-12-07 13:19:32.832	366.00	шт	12	поштучно
53602	3367	СЕЛЬДЬ 175гр Атлантическая в масле филе 1/9шт ТМ Санта Бремор	\N	\N	2039.00	шт	1	9	t	2025-12-07 13:19:32.858	2025-12-07 13:19:32.858	227.00	шт	9	поштучно
53603	3367	СЕЛЬДЬ 175гр Атлантическая в томате филе 1/9шт ТМ Санта Бремор	\N	\N	2039.00	шт	1	10	t	2025-12-07 13:19:32.869	2025-12-07 13:19:32.869	227.00	шт	9	поштучно
53604	3367	СЕЛЬДЬ Атлантическая в сладком соусе Чили 175гр ключ Ханса ТМ Барс	\N	\N	2429.00	шт	1	108	t	2025-12-07 13:19:32.888	2025-12-07 13:19:32.888	202.00	шт	12	поштучно
53605	3367	СКУМБРИЯ 175гр Атлантическая в масле филе ключ ханса 1/9шт ТМ Санта Бремор	\N	\N	3043.00	шт	1	60	t	2025-12-07 13:19:32.904	2025-12-07 13:19:32.904	338.00	шт	9	поштучно
53606	3367	СКУМБРИЯ 175гр Атлантическая натуральная с добавлением масла филе ключ ханса 1/9шт ТМ Санта Бремор	\N	\N	2029.00	шт	1	6	t	2025-12-07 13:19:32.916	2025-12-07 13:19:32.916	225.00	шт	9	поштучно
53607	3367	СКУМБРИЯ с добавлением масла 250гр ключ ТМ Барс Северная Атлантика-20 North Atlantic N.A.	\N	\N	4177.00	шт	1	160	t	2025-12-07 13:19:32.926	2025-12-07 13:19:32.926	261.00	шт	16	поштучно
53608	3367	ТУНЕЦ в масле 120гр с перцем чили ТМ УЛЬТРАМАРИН	\N	\N	4744.00	шт	1	300	t	2025-12-07 13:19:32.937	2025-12-07 13:19:32.937	190.00	шт	25	поштучно
53609	3367	ТУНЕЦ в масле филе 250гр ТМ Барс	\N	\N	5189.00	шт	1	225	t	2025-12-07 13:19:32.949	2025-12-07 13:19:32.949	216.00	шт	24	поштучно
53610	3367	ТУНЕЦ натур 240гр ключ ТМ Знаток	\N	\N	10488.00	шт	1	196	t	2025-12-07 13:19:32.968	2025-12-07 13:19:32.968	218.00	шт	48	поштучно
53611	3367	ТУНЕЦ натуральный филе 185гр ТМ УЛЬТРАМАРИН	\N	\N	4278.00	шт	1	300	t	2025-12-07 13:19:32.98	2025-12-07 13:19:32.98	178.00	шт	24	поштучно
53612	3323	АЗЕРБАЙДЖАНСКИЙ ФРУКТ нектар 1л вишневый ст/бут 1/8шт ТМ Twist-Off	\N	\N	1095.00	уп (8 шт)	1	56	t	2025-12-07 13:19:33	2025-12-07 13:19:33	137.00	шт	8	только уп
53613	3323	АЗЕРБАЙДЖАНСКИЙ ФРУКТ сок 1л виноградный ст/бут 1/8шт ТМ Twist-Off	\N	\N	1095.00	уп (8 шт)	1	130	t	2025-12-07 13:19:33.016	2025-12-07 13:19:33.016	137.00	шт	8	только уп
53614	3323	АЗЕРБАЙДЖАНСКИЙ ФРУКТ сок 1л ежевика ст/бут 1/8шт ТМ Twist-Off	\N	\N	1095.00	уп (8 шт)	1	159	t	2025-12-07 13:19:33.028	2025-12-07 13:19:33.028	137.00	шт	8	только уп
53615	3323	АЗЕРБАЙДЖАНСКИЙ ФРУКТ сок 1л яблоко ст/бут 1/8шт ТМ Twist-Off	\N	\N	1095.00	уп (8 шт)	1	66	t	2025-12-07 13:19:33.043	2025-12-07 13:19:33.043	137.00	шт	8	только уп
53616	3323	ВИШ Виш микс нектар 2л мультифруктовый пэт 1/6шт	\N	\N	1125.00	уп (6 шт)	1	107	t	2025-12-07 13:19:33.06	2025-12-07 13:19:33.06	187.00	шт	6	только уп
53617	3323	ВИШ Виш микс нектар 2л яблочный пэт 1/6шт	\N	\N	1125.00	уп (6 шт)	1	300	t	2025-12-07 13:19:33.089	2025-12-07 13:19:33.089	187.00	шт	6	только уп
53618	3323	ВИШ Виш нектар 1л гранатовый пэт 1/12шт	\N	\N	1759.00	уп (12 шт)	1	93	t	2025-12-07 13:19:33.106	2025-12-07 13:19:33.106	147.00	шт	12	только уп
53619	3323	ВИШ Виш нектар 1л персиковый пэт 1/12шт	\N	\N	1759.00	уп (12 шт)	1	12	t	2025-12-07 13:19:33.119	2025-12-07 13:19:33.119	147.00	шт	12	только уп
53620	3323	ВИШ Виш нектар 2л вишневый пэт 1/6шт	\N	\N	1125.00	уп (6 шт)	1	19	t	2025-12-07 13:19:33.129	2025-12-07 13:19:33.129	187.00	шт	6	только уп
53621	3323	ВОЛЖСКИЙ ПОСАД нектар 0,2л мультифрук пэт	\N	\N	854.00	уп (27 шт)	1	300	t	2025-12-07 13:19:33.145	2025-12-07 13:19:33.145	32.00	шт	27	только уп
53622	3323	ВОЛЖСКИЙ ПОСАД нектар 0,2л яблочно/персиковый пэт	\N	\N	854.00	уп (27 шт)	1	300	t	2025-12-07 13:19:33.161	2025-12-07 13:19:33.161	32.00	шт	27	только уп
53623	3323	ВОЛЖСКИЙ ПОСАД нектар 1л мультифрук пэт	\N	\N	1504.00	уп (12 шт)	1	9	t	2025-12-07 13:19:33.175	2025-12-07 13:19:33.175	125.00	шт	12	только уп
53624	3323	ВОЛЖСКИЙ ПОСАД нектар 1л яблочно/виноградный пэт	\N	\N	1504.00	уп (12 шт)	1	12	t	2025-12-07 13:19:33.202	2025-12-07 13:19:33.202	125.00	шт	12	только уп
53625	3323	ВОЛЖСКИЙ ПОСАД нектар 1л яблочно/персиковый пэт	\N	\N	1504.00	уп (12 шт)	1	144	t	2025-12-07 13:19:33.213	2025-12-07 13:19:33.213	125.00	шт	12	только уп
53626	3323	ВОЛЖСКИЙ ПОСАД нектар 2л мультифрук пэт	\N	\N	1290.00	уп (6 шт)	1	222	t	2025-12-07 13:19:33.227	2025-12-07 13:19:33.227	215.00	шт	6	только уп
53627	3323	ВОЛЖСКИЙ ПОСАД нектар 2л яблочно/персиковый пэт	\N	\N	1290.00	уп (6 шт)	1	244	t	2025-12-07 13:19:33.299	2025-12-07 13:19:33.299	215.00	шт	6	только уп
53628	3323	ВОЛЖСКИЙ ПОСАД сок 0,2л мультифрукт для детского питания с 6 мес пэт	\N	\N	994.00	уп (27 шт)	1	300	t	2025-12-07 13:19:33.322	2025-12-07 13:19:33.322	37.00	шт	27	только уп
53629	3323	ВОЛЖСКИЙ ПОСАД сок 0,2л яблочно/вишневый для детского питания с 5 мес пэт	\N	\N	994.00	уп (27 шт)	1	300	t	2025-12-07 13:19:33.359	2025-12-07 13:19:33.359	37.00	шт	27	только уп
53630	3323	ВОЛЖСКИЙ ПОСАД сок 0,2л яблочный осветленный для детского питания с 4 мес пэт	\N	\N	994.00	уп (27 шт)	1	27	t	2025-12-07 13:19:33.381	2025-12-07 13:19:33.381	37.00	шт	27	только уп
25781	2755	ПЕЛЬМЕНИ БУЛЬМЕНИ 400гр с говядиной и свининой  ТМ Горячая Штучка	\N	\N	2112.00	уп (16 шт)	1	300	f	2025-11-10 01:55:59.973	2025-11-22 01:30:48.533	132.00	шт	16	\N
53631	3323	ВОЛЖСКИЙ ПОСАД сок 0,2л яблочный осветленный пэт	\N	\N	994.00	уп (27 шт)	1	17	t	2025-12-07 13:19:33.395	2025-12-07 13:19:33.395	37.00	шт	27	только уп
53632	3323	ВОЛЖСКИЙ ПОСАД сок 1л яблочный осветленный пэт	\N	\N	1504.00	уп (12 шт)	1	36	t	2025-12-07 13:19:33.41	2025-12-07 13:19:33.41	125.00	шт	12	только уп
53633	3323	ВОЛЖСКИЙ ПОСАД сок 2л томатный с мякотью пэт	\N	\N	1290.00	уп (6 шт)	1	234	t	2025-12-07 13:19:33.432	2025-12-07 13:19:33.432	215.00	шт	6	только уп
53634	3323	ВОЛЖСКИЙ ПОСАД сок 2л яблочный пэт	\N	\N	1290.00	уп (6 шт)	1	179	t	2025-12-07 13:19:33.447	2025-12-07 13:19:33.447	215.00	шт	6	только уп
53635	3323	ВОДА АЛТАЙ АКВА 0,5л природно артезианская газированная пэт	\N	\N	649.00	уп (12 шт)	1	200	t	2025-12-07 13:19:33.458	2025-12-07 13:19:33.458	54.00	шт	12	только уп
53636	3323	ВОДА АЛТАЙ АКВА 0,5л природно артезианская негазированная пэт	\N	\N	649.00	уп (12 шт)	1	24	t	2025-12-07 13:19:33.469	2025-12-07 13:19:33.469	54.00	шт	12	только уп
53637	3323	ВОДА АЛТАЙ АКВА 1,3л природная артезианская негазированная пэт	\N	\N	455.00	уп (6 шт)	1	58	t	2025-12-07 13:19:33.48	2025-12-07 13:19:33.48	76.00	шт	6	только уп
53638	3323	ВОДА АЛТАЙ АКВА 1,3л природно артезианская газированная пэт	\N	\N	455.00	уп (6 шт)	1	180	t	2025-12-07 13:19:33.491	2025-12-07 13:19:33.491	76.00	шт	6	только уп
53639	3323	ВОДА МОНАСТЫРСКАЯ 0,5л газированная пэт	\N	\N	814.00	уп (12 шт)	1	200	t	2025-12-07 13:19:33.506	2025-12-07 13:19:33.506	68.00	шт	12	только уп
53640	3323	ВОДА МОНАСТЫРСКАЯ 0,5л негазированная пэт	\N	\N	814.00	уп (12 шт)	1	200	t	2025-12-07 13:19:33.517	2025-12-07 13:19:33.517	68.00	шт	12	только уп
53641	3323	ВОДА МОНАСТЫРСКАЯ 1,5л газированная пэт	\N	\N	656.00	уп (6 шт)	1	200	t	2025-12-07 13:19:33.527	2025-12-07 13:19:33.527	109.00	шт	6	только уп
53642	3323	ВОДА ОЛЬСКАЯ 0,5л  газированная пэт Тальский завод	\N	\N	957.00	уп (16 шт)	1	48	t	2025-12-07 13:19:33.537	2025-12-07 13:19:33.537	60.00	шт	16	только уп
53643	3323	ВОДА ОЛЬСКАЯ 0,5л  Лимон газированная пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	176	t	2025-12-07 13:19:33.55	2025-12-07 13:19:33.55	67.00	шт	16	только уп
53644	3323	ВОДА ОЛЬСКАЯ 0,5л  Лимон негазированная пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	128	t	2025-12-07 13:19:33.565	2025-12-07 13:19:33.565	67.00	шт	16	только уп
53645	3323	ВОДА ОЛЬСКАЯ 0,5л  негазированная пэт Тальский завод	\N	\N	957.00	уп (16 шт)	1	200	t	2025-12-07 13:19:33.58	2025-12-07 13:19:33.58	60.00	шт	16	только уп
53646	3323	ВОДА ОЛЬСКАЯ 1,5л газированная пэт Тальский завод	\N	\N	800.00	уп (8 шт)	1	200	t	2025-12-07 13:19:33.595	2025-12-07 13:19:33.595	100.00	шт	8	только уп
53647	3323	ВОДА ОЛЬСКАЯ 1,5л Лимон газированная пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	185	t	2025-12-07 13:19:33.608	2025-12-07 13:19:33.608	109.00	шт	8	только уп
53648	3323	ВОДА ОЛЬСКАЯ 1,5л Лимон негазированная пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	104	t	2025-12-07 13:19:33.623	2025-12-07 13:19:33.623	109.00	шт	8	только уп
53649	3323	ВОДА ОЛЬСКАЯ 1,5л негазированная пэт Тальский завод	\N	\N	800.00	уп (8 шт)	1	200	t	2025-12-07 13:19:33.711	2025-12-07 13:19:33.711	100.00	шт	8	только уп
53650	3323	ВОДА ОЛЬСКАЯ 5л  негазированная пэт Тальский завод	\N	\N	736.00	уп (4 шт)	1	200	t	2025-12-07 13:19:33.725	2025-12-07 13:19:33.725	184.00	шт	4	только уп
53651	3323	ВОДА СЛАВДА 1,5л Курортная газированная пэт	\N	\N	662.00	уп (6 шт)	1	18	t	2025-12-07 13:19:33.736	2025-12-07 13:19:33.736	110.00	шт	6	только уп
53652	3323	ВОДА ШМАКОВКА №1 0,5л газированная пэт	\N	\N	869.00	уп (12 шт)	1	200	t	2025-12-07 13:19:33.76	2025-12-07 13:19:33.76	72.00	шт	12	только уп
53653	3323	ВОДА ШМАКОВКА №1 1,5л газированная пэт	\N	\N	718.00	уп (6 шт)	1	200	t	2025-12-07 13:19:33.787	2025-12-07 13:19:33.787	120.00	шт	6	только уп
53654	3323	НАПИТОК БОЧКАРИ Капибара Банананааа вкус банана 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	107	t	2025-12-07 13:19:33.798	2025-12-07 13:19:33.798	92.00	шт	12	только уп
53655	3323	НАПИТОК БОЧКАРИ Капибара Кислый микс 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	59	t	2025-12-07 13:19:33.811	2025-12-07 13:19:33.811	92.00	шт	12	только уп
53656	3323	НАПИТОК БОЧКАРИ Капибара Кола 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	128	t	2025-12-07 13:19:33.85	2025-12-07 13:19:33.85	92.00	шт	12	только уп
53657	3323	НАПИТОК БОЧКАРИ Капибара Мятный буст 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	118	t	2025-12-07 13:19:33.876	2025-12-07 13:19:33.876	92.00	шт	12	только уп
53658	3323	НАПИТОК БОЧКАРИ Капибара Персик юзу 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	131	t	2025-12-07 13:19:33.899	2025-12-07 13:19:33.899	92.00	шт	12	только уп
53659	3323	НАПИТОК БОЧКАРИ Кола 0,5л газированный пэт	\N	\N	1063.00	уп (12 шт)	1	48	t	2025-12-07 13:19:33.911	2025-12-07 13:19:33.911	89.00	шт	12	только уп
53660	3323	НАПИТОК БОЧКАРИ Кола 0,9л газированный пэт	\N	\N	780.00	уп (6 шт)	1	162	t	2025-12-07 13:19:33.926	2025-12-07 13:19:33.926	130.00	шт	6	только уп
53661	3323	НАПИТОК ДЮШЕС 0,5л газированный пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	84	t	2025-12-07 13:19:33.946	2025-12-07 13:19:33.946	67.00	шт	16	только уп
53662	3323	НАПИТОК ДЮШЕС 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	200	t	2025-12-07 13:19:33.967	2025-12-07 13:19:33.967	109.00	шт	8	только уп
53663	3323	НАПИТОК КОКА-КОЛА 0,5л газированная пэт	\N	\N	2153.00	уп (24 шт)	1	200	t	2025-12-07 13:19:33.979	2025-12-07 13:19:33.979	90.00	шт	24	только уп
53664	3323	НАПИТОК КОКА-КОЛА 0,88л газированная пэт Китай	\N	\N	1477.00	уп (12 шт)	1	200	t	2025-12-07 13:19:33.996	2025-12-07 13:19:33.996	123.00	шт	12	только уп
53665	3323	НАПИТОК КОКА-КОЛА 2л газ пэт Китай	\N	\N	1221.00	уп (6 шт)	1	200	t	2025-12-07 13:19:34.009	2025-12-07 13:19:34.009	204.00	шт	6	только уп
25795	2755	ПЕЛЬМЕНИ Цезарь 450гр Мясо бычков	\N	\N	2736.00	уп (12 шт)	1	97	f	2025-11-10 01:56:00.865	2025-11-22 01:30:48.533	228.00	шт	12	\N
25827	2755	СУПОВОЙ НАБОР ИНДЕЙКА подложка (1шт~700гр) ТМ Индилайт	\N	\N	1290.00	уп (6 шт)	1	45	f	2025-11-10 01:56:02.666	2025-11-22 01:30:48.533	215.00	кг	6	\N
53666	3323	НАПИТОК КОЛА 1,5л газированный пэт Тальский завод	\N	\N	957.00	уп (8 шт)	1	104	t	2025-12-07 13:19:34.021	2025-12-07 13:19:34.021	120.00	шт	8	только уп
53667	3323	НАПИТОК КРЕМ СОДА 0,5л газированный пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	96	t	2025-12-07 13:19:34.032	2025-12-07 13:19:34.032	67.00	шт	16	только уп
53668	3323	НАПИТОК КРЕМ СОДА 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	200	t	2025-12-07 13:19:34.056	2025-12-07 13:19:34.056	109.00	шт	8	только уп
53669	3323	НАПИТОК ЛИМОНАД 0,5л газированный пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	176	t	2025-12-07 13:19:34.069	2025-12-07 13:19:34.069	67.00	шт	16	только уп
53670	3323	НАПИТОК ЛИМОНАД 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	200	t	2025-12-07 13:19:34.082	2025-12-07 13:19:34.082	109.00	шт	8	только уп
53671	3323	НАПИТОК МОНАСТЫРСКИЙ 0,5 Буратино газированный пэт	\N	\N	1021.00	уп (12 шт)	1	200	t	2025-12-07 13:19:34.098	2025-12-07 13:19:34.098	85.00	шт	12	только уп
53672	3323	НАПИТОК МОНАСТЫРСКИЙ 0,5 Дюшес газированный пэт	\N	\N	1021.00	уп (12 шт)	1	179	t	2025-12-07 13:19:34.11	2025-12-07 13:19:34.11	85.00	шт	12	только уп
53673	3323	НАПИТОК МОНАСТЫРСКИЙ 0,5 Спорт газированный пэт	\N	\N	1021.00	уп (12 шт)	1	110	t	2025-12-07 13:19:34.127	2025-12-07 13:19:34.127	85.00	шт	12	только уп
53674	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Ананас и Кокос газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-07 13:19:34.139	2025-12-07 13:19:34.139	145.00	шт	6	только уп
53675	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Апельсин газированный пэт	\N	\N	869.00	уп (6 шт)	1	174	t	2025-12-07 13:19:34.157	2025-12-07 13:19:34.157	145.00	шт	6	только уп
53676	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Буратино газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-07 13:19:34.182	2025-12-07 13:19:34.182	145.00	шт	6	только уп
53677	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Гуава - Цветы яблони газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-07 13:19:34.203	2025-12-07 13:19:34.203	145.00	шт	6	только уп
53678	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Дюшес газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-07 13:19:34.227	2025-12-07 13:19:34.227	145.00	шт	6	только уп
53679	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Лайм Мята газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-07 13:19:34.243	2025-12-07 13:19:34.243	145.00	шт	6	только уп
53680	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Лимонад газированный пэт	\N	\N	869.00	уп (6 шт)	1	42	t	2025-12-07 13:19:34.258	2025-12-07 13:19:34.258	145.00	шт	6	только уп
53681	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Спорт газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-07 13:19:34.27	2025-12-07 13:19:34.27	145.00	шт	6	только уп
53682	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Тархун газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-07 13:19:34.357	2025-12-07 13:19:34.357	145.00	шт	6	только уп
53683	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Фруктовый коктейль газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-07 13:19:34.406	2025-12-07 13:19:34.406	145.00	шт	6	только уп
53684	3323	НАПИТОК СПРАЙТ 0,5л газированная пэт Китай	\N	\N	2236.00	уп (24 шт)	1	200	t	2025-12-07 13:19:34.431	2025-12-07 13:19:34.431	93.00	шт	24	только уп
53685	3323	НАПИТОК СПРАЙТ 0,88л газированная пэт	\N	\N	1477.00	уп (12 шт)	1	200	t	2025-12-07 13:19:34.446	2025-12-07 13:19:34.446	123.00	шт	12	только уп
53686	3323	НАПИТОК СПРАЙТ 2л газированная пэт	\N	\N	1339.00	уп (6 шт)	1	48	t	2025-12-07 13:19:34.518	2025-12-07 13:19:34.518	223.00	шт	6	только уп
53687	3323	НАПИТОК ТАРХУН 0,5л газированный пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	64	t	2025-12-07 13:19:34.55	2025-12-07 13:19:34.55	67.00	шт	16	только уп
53688	3323	НАПИТОК ТАРХУН 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	152	t	2025-12-07 13:19:34.57	2025-12-07 13:19:34.57	109.00	шт	8	только уп
53689	3323	НАПИТОК ТРОПИК 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	56	t	2025-12-07 13:19:34.584	2025-12-07 13:19:34.584	109.00	шт	8	только уп
53690	3323	НАПИТОК ФАНТА 0,5л газированная пэт Китай	\N	\N	2236.00	уп (24 шт)	1	200	t	2025-12-07 13:19:34.609	2025-12-07 13:19:34.609	93.00	шт	24	только уп
53691	3323	НАПИТОК ФАНТА 0,88л газированная пэт Китай	\N	\N	1477.00	уп (12 шт)	1	200	t	2025-12-07 13:19:34.625	2025-12-07 13:19:34.625	123.00	шт	12	только уп
53692	3323	НАПИТОК ФАНТА 2л газированная пэт	\N	\N	1339.00	уп (6 шт)	1	24	t	2025-12-07 13:19:34.644	2025-12-07 13:19:34.644	223.00	шт	6	только уп
53693	3323	НАПИТОК ЭКСТРАСИТРО 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	200	t	2025-12-07 13:19:34.66	2025-12-07 13:19:34.66	109.00	шт	8	только уп
53694	3323	НАПИТОК ЯБЛОКО 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	184	t	2025-12-07 13:19:34.671	2025-12-07 13:19:34.671	109.00	шт	8	только уп
53695	3393	МЫЛО туалетное 100гр Банное	\N	\N	777.00	шт	1	6	t	2025-12-07 13:19:34.688	2025-12-07 13:19:34.688	194.00	шт	4	поштучно
53696	3393	БУМАГА ТУАЛЕТНАЯ "Nuvola" Asia 3-х сл 29м	\N	\N	92.00	шт	1	300	t	2025-12-07 13:19:34.699	2025-12-07 13:19:34.699	92.00	шт	\N	поштучно
53697	3393	БУМАГА ТУАЛЕТНАЯ "Nuvola" БЕЛАЯ 2-х сл (4 рул)	\N	\N	1960.00	шт	1	90	t	2025-12-07 13:19:34.71	2025-12-07 13:19:34.71	163.00	шт	12	поштучно
53698	3393	БУМАГА ТУАЛЕТНАЯ "Soffione" Decor Blue ГОЛУБАЯ 2-х сл (4 рул)	\N	\N	2588.00	шт	1	166	t	2025-12-07 13:19:34.725	2025-12-07 13:19:34.725	259.00	шт	10	поштучно
53699	3393	БУМАГА ТУАЛЕТНАЯ "Tubum" БЕЛАЯ 2-х сл (4 рул)	\N	\N	2447.00	шт	1	300	t	2025-12-07 13:19:34.739	2025-12-07 13:19:34.739	153.00	шт	16	поштучно
25856	2755	ФИЛЕ ОКОРОЧКА КУР без кожи без кости лоток ТМ ДОМОСЕДКА	\N	\N	4850.00	уп (10 шт)	1	161	f	2025-11-10 01:56:04.463	2025-11-22 01:30:48.533	485.00	кг	10	\N
53700	3393	БУМАГА ТУАЛЕТНАЯ "Veiro" Elit/Delicate БЕЛАЯ 3-х сл (4 рул)	\N	\N	3461.00	шт	1	98	t	2025-12-07 13:19:34.762	2025-12-07 13:19:34.762	346.00	шт	10	поштучно
53701	3393	БУМАГА ТУАЛЕТНАЯ "Veiro" Luxoria БЕЛАЯ 3-х сл (4 рул)	\N	\N	3116.00	шт	1	101	t	2025-12-07 13:19:34.777	2025-12-07 13:19:34.777	312.00	шт	10	поштучно
53702	3393	БУМАГА ТУАЛЕТНАЯ "Veiro" Standart Plus БЕЛАЯ 2-х сл (4 рул)	\N	\N	3398.00	шт	1	300	t	2025-12-07 13:19:34.789	2025-12-07 13:19:34.789	227.00	шт	15	поштучно
53703	3393	БУМАГА ТУАЛЕТНАЯ "Veiro" Домашняя БЕЛАЯ 2-х сл (4 рул)	\N	\N	2001.00	шт	1	300	t	2025-12-07 13:19:34.82	2025-12-07 13:19:34.82	167.00	шт	12	поштучно
53704	3393	БУМАГА ТУАЛЕТНАЯ "Лилия комфорт" БЕЛАЯ 2-х сл (4 рул)	\N	\N	1960.00	шт	1	6	t	2025-12-07 13:19:34.834	2025-12-07 13:19:34.834	163.00	шт	12	поштучно
53705	3393	ПОЛОТЕНЦА БУМАЖНЫЕ "Soffione"Maxi белые 2-х сл (1 рул)	\N	\N	4792.00	шт	1	54	t	2025-12-07 13:19:34.85	2025-12-07 13:19:34.85	532.00	шт	9	поштучно
53706	3393	ПОЛОТЕНЦА БУМАЖНЫЕ "Tubum"  белые 2-х сл (2 рул)	\N	\N	2742.00	шт	1	185	t	2025-12-07 13:19:34.863	2025-12-07 13:19:34.863	171.00	шт	16	поштучно
53707	3393	САЛФЕТКА ВИСКОЗНАЯ 22*23 "Paterra" (70шт) рулон	\N	\N	8441.00	шт	1	36	t	2025-12-07 13:19:34.877	2025-12-07 13:19:34.877	422.00	шт	20	поштучно
53708	3393	САЛФЕТКА ВИСКОЗНАЯ 30*38  "Paterra" (10шт)	\N	\N	4071.00	шт	1	47	t	2025-12-07 13:19:34.89	2025-12-07 13:19:34.89	204.00	шт	20	поштучно
53709	3393	САЛФЕТКА ВЛАЖНЫЕ "AMRA" 4 фруктовых аромата (15шт) лайм, мята, ягодный микс, ромашка	\N	\N	2153.00	шт	1	49	t	2025-12-07 13:19:34.907	2025-12-07 13:19:34.907	45.00	шт	48	поштучно
53710	3393	САЛФЕТКА ВЛАЖНЫЕ "NUVOLA" (120шт) 1/24шт	\N	\N	5051.00	шт	1	126	t	2025-12-07 13:19:34.921	2025-12-07 13:19:34.921	210.00	шт	24	поштучно
53711	3393	САЛФЕТКА ВЛАЖНЫЕ "NUVOLA" (15шт) 1/100шт	\N	\N	1955.00	шт	1	129	t	2025-12-07 13:19:34.933	2025-12-07 13:19:34.933	39.00	шт	50	поштучно
53712	3393	САЛФЕТКА ВЛАЖНЫЕ "NUVOLA" (80шт) 1/32шт	\N	\N	4931.00	шт	1	82	t	2025-12-07 13:19:34.964	2025-12-07 13:19:34.964	154.00	шт	32	поштучно
53713	3393	САЛФЕТКИ БУМАЖНЫЕ белые 24*24 "SOLFI" 1сл п/п (100шт)	\N	\N	2705.00	шт	1	300	t	2025-12-07 13:19:34.976	2025-12-07 13:19:34.976	56.00	шт	48	поштучно
53714	3393	САЛФЕТКИ БУМАЖНЫЕ в коробке "NUVOLA" Deluxe 2-х сл (150шт)	\N	\N	10419.00	шт	1	150	t	2025-12-07 13:19:34.987	2025-12-07 13:19:34.987	174.00	шт	60	поштучно
53715	3393	САЛФЕТКИ БУМАЖНЫЕ в коробке "NUVOLA" Design Red 2-х сл (200шт)	\N	\N	12144.00	шт	1	300	t	2025-12-07 13:19:35.003	2025-12-07 13:19:35.003	202.00	шт	60	поштучно
53716	3393	САЛФЕТКИ БУМАЖНЫЕ в мягкой упак  "ONE TIME"  2-х сл (200шт)	\N	\N	7590.00	шт	1	110	t	2025-12-07 13:19:35.014	2025-12-07 13:19:35.014	126.00	шт	60	поштучно
53717	3393	САЛФЕТКИ БУМАЖНЫЕ в тубе "NUVOLA" Clory 2-х сл (50шт)	\N	\N	7820.00	шт	1	7	t	2025-12-07 13:19:35.028	2025-12-07 13:19:35.028	98.00	шт	80	поштучно
53718	3393	ПЕРГАМЕНТ ДЛЯ ВЫПЕЧКИ 380мм х 6м силиконизированный натуральный Pattera	\N	\N	11930.00	шт	1	211	t	2025-12-07 13:19:35.062	2025-12-07 13:19:35.062	284.00	шт	42	поштучно
53719	3393	РУКАВ ДЛЯ ЗАПЕКАНИЯ Impacto 30см*3м в пленке	\N	\N	2875.00	шт	1	177	t	2025-12-07 13:19:35.073	2025-12-07 13:19:35.073	57.00	шт	50	поштучно
53720	3393	РУКАВ ДЛЯ ЗАПЕКАНИЯ Pattera 30см*3м в футляре с клипсами	\N	\N	2374.00	шт	1	13	t	2025-12-07 13:19:35.084	2025-12-07 13:19:35.084	99.00	шт	24	поштучно
53721	3393	ФОЛЬГА для выпечки и хранения 29см*10м в рулоне 11/12мк Pattera	\N	\N	17460.00	шт	1	300	t	2025-12-07 13:19:35.095	2025-12-07 13:19:35.095	277.00	шт	63	поштучно
53722	3393	ФОЛЬГА для выпечки и хранения 29см*10м в рулоне 8мк Горница	\N	\N	13476.00	шт	1	87	t	2025-12-07 13:19:35.107	2025-12-07 13:19:35.107	214.00	шт	63	поштучно
53723	3393	ФОЛЬГА для выпечки и хранения 29см*80м в рулоне 8мк Горница	\N	\N	51198.00	шт	1	144	t	2025-12-07 13:19:35.133	2025-12-07 13:19:35.133	853.00	шт	60	поштучно
53724	3393	ПАКЕТЫ под мусор "IMPACTO" 120л особо прочные (10 шт)	\N	\N	174.00	шт	1	119	t	2025-12-07 13:19:35.167	2025-12-07 13:19:35.167	174.00	шт	1	поштучно
53725	3393	ПАКЕТЫ под мусор "IMPACTO" 120л с завязками (20 шт)	\N	\N	424.00	шт	1	173	t	2025-12-07 13:19:35.181	2025-12-07 13:19:35.181	424.00	шт	1	поштучно
53726	3393	ПАКЕТЫ под мусор "IMPACTO" 30л особо прочные (25 шт)	\N	\N	98.00	шт	1	42	t	2025-12-07 13:19:35.197	2025-12-07 13:19:35.197	98.00	шт	1	поштучно
53727	3393	ПАКЕТЫ под мусор "IMPACTO" 30л с завязками  (25 шт)	\N	\N	160.00	шт	1	74	t	2025-12-07 13:19:35.215	2025-12-07 13:19:35.215	160.00	шт	1	поштучно
53728	3393	ПАКЕТЫ под мусор "IMPACTO" 60л (25 шт)	\N	\N	243.00	шт	1	96	t	2025-12-07 13:19:35.227	2025-12-07 13:19:35.227	243.00	шт	1	поштучно
53729	3393	ПАКЕТЫ с ручками майка синяя 43+18х65 40мк (1упаковка 50шт)  ЦЕНА ЗА 50 ШТУК	\N	\N	9695.00	шт	1	104	t	2025-12-07 13:19:35.312	2025-12-07 13:19:35.312	969.00	шт	10	поштучно
53730	3393	ПАКЕТЫ фасовочные "IMPACTO" 30мк 25х40 (1упаковка 200шт)	\N	\N	3663.00	шт	1	137	t	2025-12-07 13:19:35.37	2025-12-07 13:19:35.37	733.00	шт	5	поштучно
53731	3393	ПАКЕТЫ фасовочные в рулоне 10мк 24х37 (1упаковка 500шт)	\N	\N	12017.00	шт	1	253	t	2025-12-07 13:19:35.384	2025-12-07 13:19:35.384	633.00	шт	19	поштучно
53732	3393	ТЕРМОПАКЕТ ПВД 42*45см (3 часа) 85мк	\N	\N	35305.00	шт	1	87	t	2025-12-07 13:19:35.4	2025-12-07 13:19:35.4	353.00	шт	100	поштучно
53733	3393	ТЕРМОПАКЕТ ПВД 60*55см (3 часа) 40мк	\N	\N	35765.00	шт	1	28	t	2025-12-07 13:19:35.424	2025-12-07 13:19:35.424	358.00	шт	100	поштучно
53734	3393	ТЕРМОПАКЕТ ФОЛЬГИРОВАННЫЙ 42*45см (3 часа) 80мк	\N	\N	20930.00	шт	1	121	t	2025-12-07 13:19:35.453	2025-12-07 13:19:35.453	209.00	шт	100	поштучно
53735	3393	БАХИЛЫ для обуви 4гр синие компакт (50шт/25 пар) ЦЕНА ЗА УПАК 50шт	\N	\N	8280.00	упак	1	125	t	2025-12-07 13:19:35.477	2025-12-07 13:19:35.477	69.00	упак	120	поштучно
53736	3393	БАХИЛЫ для обуви 5гр синие компакт с двойной подошвой (100шт/50пар) ЦЕНА ЗА УПАК 100шт	\N	\N	18975.00	упак	1	87	t	2025-12-07 13:19:35.499	2025-12-07 13:19:35.499	190.00	упак	100	поштучно
53737	3393	ГУБКА металлическая для посуды из гнержавеющей стали 1шт Pattera	\N	\N	9660.00	шт	1	394	t	2025-12-07 13:19:35.528	2025-12-07 13:19:35.528	97.00	шт	100	поштучно
53738	3393	ГУБКИ для посуды 5шт Aktiv	\N	\N	6417.00	шт	1	144	t	2025-12-07 13:19:35.557	2025-12-07 13:19:35.557	143.00	шт	45	поштучно
53739	3393	ГУБКИ для посуды эко макси Авикомп 5шт	\N	\N	56.00	шт	1	9	t	2025-12-07 13:19:35.577	2025-12-07 13:19:35.577	56.00	шт	1	поштучно
53740	3393	ПЕРЧАТКИ ЛАТЕКСНЫЕ HIGH RISK синие "S" (50 пар)	\N	\N	1063.00	шт	1	20	t	2025-12-07 13:19:35.601	2025-12-07 13:19:35.601	1063.00	шт	1	поштучно
53741	3393	ПЕРЧАТКИ ЛАТЕКСНЫЕ HIGH RISK синие "М" (50 пар)	\N	\N	1063.00	шт	1	30	t	2025-12-07 13:19:35.625	2025-12-07 13:19:35.625	1063.00	шт	1	поштучно
53742	3393	ПЕРЧАТКИ ЛАТЕКСНЫЕ ЦЕРЕБРУМ "L" (50 пар)	\N	\N	6808.00	шт	1	85	t	2025-12-07 13:19:35.707	2025-12-07 13:19:35.707	681.00	шт	10	поштучно
53743	3393	БОЧКА полиэтиленовая 50л Тара для бочковой продукции Спасский	\N	\N	3721.00	шт	1	6	t	2025-12-07 13:19:35.732	2025-12-07 13:19:35.732	3721.00	шт	1	поштучно
53744	3393	Бочка тара полиэтиленовая	\N	\N	1150.00	шт	1	20	t	2025-12-07 13:19:35.754	2025-12-07 13:19:35.754	1150.00	шт	1	поштучно
53745	3393	НАБОР для пикника на 5 персон 1/18шт	\N	\N	4036.00	шт	1	48	t	2025-12-07 13:19:35.796	2025-12-07 13:19:35.796	224.00	шт	18	поштучно
53746	3392	ПАКЕТ вакуумный 300*400 70 мкм 1шт	\N	\N	2.00	шт	1	3800	t	2025-12-07 13:19:35.811	2025-12-07 13:19:35.811	2.00	шт	1	поштучно
53747	3392	СКОТЧ ЖЕЛТЫЙ 4,8см*36м ТМ МИР УПАКОВКИ	\N	\N	4430.00	шт	1	102	t	2025-12-07 13:19:35.823	2025-12-07 13:19:35.823	123.00	шт	36	поштучно
53748	3392	СКОТЧ КРАСНЫЙ 4,8см*36м ТМ МИР УПАКОВКИ	\N	\N	4678.00	шт	1	102	t	2025-12-07 13:19:35.835	2025-12-07 13:19:35.835	130.00	шт	36	поштучно
53749	3392	СКОТЧ красный 4,8см*66м TAI ROLL 2043	\N	\N	4678.00	шт	1	26	t	2025-12-07 13:19:35.849	2025-12-07 13:19:35.849	130.00	шт	36	поштучно
53750	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 200гр Домашняя Буренка 15% с ЗМЖ Стакан МЗ Янино	\N	\N	1739.00	уп (24 шт)	1	100	t	2025-12-07 13:19:35.87	2025-12-07 13:19:35.87	72.00	шт	24	только уп
53751	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 200гр Домашняя Буренка 20% с ЗМЖ Стакан МЗ Янино	\N	\N	1932.00	уп (24 шт)	1	100	t	2025-12-07 13:19:35.891	2025-12-07 13:19:35.891	81.00	шт	24	только уп
53752	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 400гр Домашняя Буренка 15% с ЗМЖ Стакан МЗ Янино	\N	\N	2898.00	уп (24 шт)	1	100	t	2025-12-07 13:19:35.903	2025-12-07 13:19:35.903	121.00	шт	24	только уп
53753	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 400гр Домашняя Буренка 20% с ЗМЖ Стакан МЗ Янино	\N	\N	3091.00	уп (24 шт)	1	100	t	2025-12-07 13:19:35.927	2025-12-07 13:19:35.927	129.00	шт	24	только уп
53754	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 400гр Домашняя Буренка 30% с ЗМЖ Стакан МЗ Янино	\N	\N	4085.00	уп (24 шт)	1	100	t	2025-12-07 13:19:35.941	2025-12-07 13:19:35.941	170.00	шт	24	только уп
53755	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 5кг Домашняя Буренка 20% с ЗМЖ Ведро МЗ Янино	\N	\N	1380.00	уп (1 шт)	1	100	t	2025-12-07 13:19:35.966	2025-12-07 13:19:35.966	1380.00	шт	1	только уп
53756	3305	МОЛОКО Северная долина 1,5% 950мл ультрапастеризованное 1/12шт	\N	\N	1559.00	уп (12 шт)	1	200	t	2025-12-07 13:19:35.985	2025-12-07 13:19:35.985	130.00	шт	12	только уп
53757	3305	МОЛОКО Северная долина 2,5% 950мл ультрапастеризованное 1/12шт	\N	\N	1587.00	уп (12 шт)	1	200	t	2025-12-07 13:19:35.998	2025-12-07 13:19:35.998	132.00	шт	12	только уп
53758	3305	МОЛОКО Северная долина 3,2% 950мл ультрапастеризованное 1/12шт	\N	\N	1642.00	уп (12 шт)	1	200	t	2025-12-07 13:19:36.01	2025-12-07 13:19:36.01	137.00	шт	12	только уп
53759	3305	МОЛОКО Северная долина для капучино 3,2% 950мл ультрапастеризованное 1/12шт	\N	\N	1739.00	уп (12 шт)	1	200	t	2025-12-07 13:19:36.07	2025-12-07 13:19:36.07	145.00	шт	12	только уп
53760	3305	СЛИВКИ питьевые Молочный мир 10% 500мл стерилизованные	\N	\N	1725.00	уп (12 шт)	1	66	t	2025-12-07 13:19:36.086	2025-12-07 13:19:36.086	144.00	шт	12	только уп
53761	3305	СЛИВКИ питьевые Молочный мир 20% 500мл стерилизованные	\N	\N	2732.00	уп (12 шт)	1	66	t	2025-12-07 13:19:36.104	2025-12-07 13:19:36.104	228.00	шт	12	только уп
53762	3305	СЛИВКИ питьевые Молочный мир 33% 500мл стерилизованные	\N	\N	4071.00	уп (12 шт)	1	138	t	2025-12-07 13:19:36.118	2025-12-07 13:19:36.118	339.00	шт	12	только уп
53763	3305	Сливки питьевые Молочный мир 33% 980гр стерилизованный	\N	\N	8404.00	уп (12 шт)	1	70	t	2025-12-07 13:19:36.149	2025-12-07 13:19:36.149	700.00	шт	12	только уп
53764	3401	МАРГАРИН 170гр Домашнее утро 30% 1/40шт Фабрика Фаворит	\N	\N	1748.00	шт	1	10	t	2025-12-07 13:19:36.188	2025-12-07 13:19:36.188	44.00	шт	40	поштучно
53765	3401	МАРГАРИН 200 Хозяюшка для выпечки 75%	\N	\N	1932.00	шт	1	15	t	2025-12-07 13:19:36.208	2025-12-07 13:19:36.208	97.00	шт	20	поштучно
53766	3401	МАРГАРИН 500 Щедрое лето 72%	\N	\N	4623.00	шт	1	29	t	2025-12-07 13:19:36.227	2025-12-07 13:19:36.227	231.00	шт	20	поштучно
53767	3401	МАСЛО 120гр 82,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	2841.00	шт	1	192	t	2025-12-07 13:19:36.239	2025-12-07 13:19:36.239	284.00	шт	10	поштучно
53768	3401	МАСЛО 180гр 62% Продукты из Елани Шоколадное Еланский СК	\N	\N	3809.00	шт	1	66	t	2025-12-07 13:19:36.348	2025-12-07 13:19:36.348	317.00	шт	12	поштучно
53769	3401	МАСЛО 180гр 72,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	3783.00	шт	1	300	t	2025-12-07 13:19:36.426	2025-12-07 13:19:36.426	378.00	шт	10	поштучно
53770	3401	МАСЛО 180гр 72,5% Минская марка Крестьянское Беларусь	\N	\N	4830.00	шт	1	300	t	2025-12-07 13:19:36.444	2025-12-07 13:19:36.444	241.00	шт	20	поштучно
53771	3401	МАСЛО 180гр 72,5% Радость Вкуса Крестьянское Еланский СК	\N	\N	4292.00	шт	1	173	t	2025-12-07 13:19:36.466	2025-12-07 13:19:36.466	358.00	шт	12	поштучно
53772	3401	МАСЛО 180гр 72,5% Чулымское Крестьянское слив Фабрика Фаворит	\N	\N	7618.00	шт	1	6	t	2025-12-07 13:19:36.536	2025-12-07 13:19:36.536	317.00	шт	24	поштучно
53773	3401	МАСЛО 180гр 82,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	4082.00	шт	1	300	t	2025-12-07 13:19:36.551	2025-12-07 13:19:36.551	408.00	шт	10	поштучно
53774	3401	МАСЛО 180гр 82,5% Доярушка Традиционное	\N	\N	6624.00	шт	1	300	t	2025-12-07 13:19:36.563	2025-12-07 13:19:36.563	331.00	шт	20	поштучно
53775	3401	МАСЛО 180гр 82,5% Минская марка Беларусь	\N	\N	5035.00	шт	1	300	t	2025-12-07 13:19:36.574	2025-12-07 13:19:36.574	252.00	шт	20	поштучно
53776	3401	МАСЛО 180гр 82,5% Радость Вкуса Традиционное Еланский СК	\N	\N	4554.00	шт	1	107	t	2025-12-07 13:19:36.607	2025-12-07 13:19:36.607	379.00	шт	12	поштучно
53777	3401	МАСЛО 180гр 84%  сладкосливочное несоленое ТМ Zealandia	\N	\N	7107.00	шт	1	288	t	2025-12-07 13:19:36.628	2025-12-07 13:19:36.628	355.00	шт	20	поштучно
53778	3401	МАСЛО 360гр 82,5% Брест-Литовск сливочное ТМ Савушкин продукт	\N	\N	7820.00	шт	1	300	t	2025-12-07 13:19:36.646	2025-12-07 13:19:36.646	782.00	шт	10	поштучно
53779	3401	МАСЛО 400гр 72,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	8038.00	шт	1	300	t	2025-12-07 13:19:36.659	2025-12-07 13:19:36.659	804.00	шт	10	поштучно
53780	3401	МАСЛО 400гр 72,5% Радость Вкуса Крестьянское Еланский СК	\N	\N	4561.00	шт	1	103	t	2025-12-07 13:19:36.672	2025-12-07 13:19:36.672	760.00	шт	6	поштучно
53781	3401	МАСЛО 400гр 82,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	8694.00	шт	1	300	t	2025-12-07 13:19:36.688	2025-12-07 13:19:36.688	869.00	шт	10	поштучно
53782	3401	МАСЛО 400гр 82,5% Радость Вкуса Традиционное Еланский СК	\N	\N	4761.00	шт	1	142	t	2025-12-07 13:19:36.706	2025-12-07 13:19:36.706	793.00	шт	6	поштучно
53783	3401	МАСЛО 500гр 72,5% Крестьянское Курск	\N	\N	3852.00	шт	1	300	t	2025-12-07 13:19:36.727	2025-12-07 13:19:36.727	385.00	шт	10	поштучно
53784	3401	МАСЛО 500гр 72,5%Чулымское Крестьянское слив Фабрика Фаворит	\N	\N	13984.00	шт	1	83	t	2025-12-07 13:19:36.747	2025-12-07 13:19:36.747	874.00	шт	16	поштучно
53785	3401	МАСЛО 500гр 82,5% Белорусское село Традиционное слив Фабрика Фаворит	\N	\N	15548.00	шт	1	125	t	2025-12-07 13:19:36.765	2025-12-07 13:19:36.765	972.00	шт	16	поштучно
53786	3401	МАСЛО 500гр 82,5% Традиционное Курск	\N	\N	4082.00	шт	1	300	t	2025-12-07 13:19:36.778	2025-12-07 13:19:36.778	408.00	шт	10	поштучно
53787	3401	МАСЛО вес 10кг 72,5% Крестьянское ГОСТ Чулымское	\N	\N	10465.00	уп (10 шт)	1	500	t	2025-12-07 13:19:36.799	2025-12-07 13:19:36.799	1047.00	кг	10	только уп
53788	3401	МАСЛО вес 5кг 72,5% Крестьянское ГОСТ Нижрезерв	\N	\N	4715.00	уп (5 шт)	1	500	t	2025-12-07 13:19:36.811	2025-12-07 13:19:36.811	943.00	кг	5	только уп
53789	3401	МАСЛО вес 5кг 72,5% Крестьянское Курск ГОСТ	\N	\N	3967.00	уп (5 шт)	1	500	t	2025-12-07 13:19:36.823	2025-12-07 13:19:36.823	793.00	кг	5	только уп
53790	3401	МАСЛО вес 5кг 82,5% Традиционное ГОСТ Нижрезерв	\N	\N	5290.00	уп (5 шт)	1	115	t	2025-12-07 13:19:36.836	2025-12-07 13:19:36.836	1058.00	кг	5	только уп
53791	3401	МАСЛО вес 5кг 82,5% Традиционное Курск ГОСТ	\N	\N	4255.00	уп (5 шт)	1	500	t	2025-12-07 13:19:36.86	2025-12-07 13:19:36.86	851.00	кг	5	только уп
53792	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС  Клубника-Земляника в молочном шоколаде 50гр	\N	\N	773.00	уп (6 шт)	1	30	t	2025-12-07 13:19:36.874	2025-12-07 13:19:36.874	129.00	шт	6	только уп
53793	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с  Малиной  и фисташкой в белом шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	120	t	2025-12-07 13:19:36.9	2025-12-07 13:19:36.9	178.00	шт	6	только уп
53794	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Вишней и миндалем в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	144	t	2025-12-07 13:19:36.915	2025-12-07 13:19:36.915	178.00	шт	6	только уп
53795	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Земляникой и фисташкой в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	138	t	2025-12-07 13:19:36.927	2025-12-07 13:19:36.927	178.00	шт	6	только уп
53796	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Кленовым сиропом и грецким орехом в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	132	t	2025-12-07 13:19:36.94	2025-12-07 13:19:36.94	178.00	шт	6	только уп
53797	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Манго и семенами чиа фундук в молочном шоколаде 45гр	\N	\N	1070.00	уп (6 шт)	1	60	t	2025-12-07 13:19:36.955	2025-12-07 13:19:36.955	178.00	шт	6	только уп
53798	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Мандарином и фундуком в молочном шоколаде 45гр	\N	\N	1070.00	уп (6 шт)	1	144	t	2025-12-07 13:19:36.976	2025-12-07 13:19:36.976	178.00	шт	6	только уп
53799	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Фисташкой в белом шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	108	t	2025-12-07 13:19:36.993	2025-12-07 13:19:36.993	178.00	шт	6	только уп
53800	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Фисташкой в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	114	t	2025-12-07 13:19:37.029	2025-12-07 13:19:37.029	178.00	шт	6	только уп
53801	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Черешней и фисташкой в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	96	t	2025-12-07 13:19:37.047	2025-12-07 13:19:37.047	178.00	шт	6	только уп
53802	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Ваниль в белом шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-07 13:19:37.058	2025-12-07 13:19:37.058	126.00	шт	12	только уп
53803	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Ваниль в молочном шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-07 13:19:37.08	2025-12-07 13:19:37.08	126.00	шт	12	только уп
53804	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Ваниль в темном шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	96	t	2025-12-07 13:19:37.1	2025-12-07 13:19:37.1	126.00	шт	12	только уп
54523	3395	КАРТОФЕЛЬ Фри 900гр ТМ 4 Сезона	\N	\N	3887.00	шт	1	200	t	2025-12-07 13:19:49.211	2025-12-07 13:19:49.211	389.00	шт	10	поштучно
42046	2755	ОКОРОЧОК КУР Вес 15кг БРАЗИЛИЯ	\N	\N	4640.00	уп (15 шт)	1	300	f	2025-11-30 11:02:30.822	2025-12-06 02:48:51.249	269.00	кг	15	\N
53805	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Земляника в молочном шоколаде 50гр	\N	\N	1546.00	уп (12 шт)	1	108	t	2025-12-07 13:19:37.122	2025-12-07 13:19:37.122	129.00	шт	12	только уп
53806	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Картошка в молочном шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-07 13:19:37.134	2025-12-07 13:19:37.134	126.00	шт	12	только уп
53807	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Красный апельсин в молочном шоколаде 50гр	\N	\N	773.00	уп (6 шт)	1	30	t	2025-12-07 13:19:37.146	2025-12-07 13:19:37.146	129.00	шт	6	только уп
53808	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Малина в молочном шоколаде 50гр	\N	\N	773.00	уп (6 шт)	1	18	t	2025-12-07 13:19:37.158	2025-12-07 13:19:37.158	129.00	шт	6	только уп
53809	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Манго-Клубника в молочном шоколаде 50гр	\N	\N	773.00	уп (6 шт)	1	84	t	2025-12-07 13:19:37.171	2025-12-07 13:19:37.171	129.00	шт	6	только уп
53810	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС с Вар. сгущенкой в молочном шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-07 13:19:37.184	2025-12-07 13:19:37.184	126.00	шт	12	только уп
53811	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Суфле ваниль в молочном шоколаде 40гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-07 13:19:37.198	2025-12-07 13:19:37.198	126.00	шт	12	только уп
53812	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Суфле ваниль в темном шоколаде 40гр	\N	\N	1518.00	уп (12 шт)	1	168	t	2025-12-07 13:19:37.212	2025-12-07 13:19:37.212	126.00	шт	12	только уп
53813	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Суфле с вар. сгущенкой в молочном шоколаде 40гр	\N	\N	1394.00	уп (12 шт)	1	192	t	2025-12-07 13:19:37.227	2025-12-07 13:19:37.227	116.00	шт	12	только уп
53814	3305	СЫРОК А.РОСТАГРОЭКСПОРТ с Вар. сгущенкой 45гр	\N	\N	1346.00	уп (20 шт)	1	200	t	2025-12-07 13:19:37.245	2025-12-07 13:19:37.245	67.00	шт	20	только уп
53815	3305	СЫРОК А.РОСТАГРОЭКСПОРТ с Вар. сгущенкой 45гр флоупак	\N	\N	4036.00	уп (60 шт)	1	200	t	2025-12-07 13:19:37.262	2025-12-07 13:19:37.262	67.00	шт	60	только уп
53816	3305	СЫРОК Божья Коровка Ваниль глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	20	t	2025-12-07 13:19:37.309	2025-12-07 13:19:37.309	36.00	шт	20	только уп
53817	3305	СЫРОК Божья Коровка Вареная сгущенка глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	20	t	2025-12-07 13:19:37.322	2025-12-07 13:19:37.322	36.00	шт	20	только уп
53818	3305	СЫРОК Божья Коровка Картошка вареная сгущенка глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	60	t	2025-12-07 13:19:37.333	2025-12-07 13:19:37.333	36.00	шт	20	только уп
53819	3305	СЫРОК Божья Коровка Картошка Крем-брюле глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	20	t	2025-12-07 13:19:37.367	2025-12-07 13:19:37.367	36.00	шт	20	только уп
53820	3305	СЫРОК Пастухов Ваниль в молочном шоколаде глазированный 40гр	\N	\N	927.00	уп (9 шт)	1	18	t	2025-12-07 13:19:37.38	2025-12-07 13:19:37.38	103.00	шт	9	только уп
53821	3305	СЫРОК Пастухов Вар сгущенка в молочном шоколаде глазированный 40гр	\N	\N	927.00	уп (9 шт)	1	36	t	2025-12-07 13:19:37.391	2025-12-07 13:19:37.391	103.00	шт	9	только уп
53822	3305	СЫРОК Пингвиненок Понго Ваниль глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	20	t	2025-12-07 13:19:37.404	2025-12-07 13:19:37.404	36.00	шт	20	только уп
53823	3305	СЫРОК Пингвиненок Понго Картошка вареная сгущенка  глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	40	t	2025-12-07 13:19:37.418	2025-12-07 13:19:37.418	36.00	шт	20	только уп
53824	3305	СЫРОК Пингвиненок Понго Картошка крем брюле глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	120	t	2025-12-07 13:19:37.43	2025-12-07 13:19:37.43	36.00	шт	20	только уп
53825	3305	СЫРОК Пингвиненок Понго Картошка с грецким орехом со сгущенным молоком глазированный  40гр	\N	\N	727.00	уп (20 шт)	1	20	t	2025-12-07 13:19:37.448	2025-12-07 13:19:37.448	36.00	шт	20	только уп
53826	3305	СЫРОК Савушкин кокос-миндаль глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	t	2025-12-07 13:19:37.495	2025-12-07 13:19:37.495	53.00	шт	18	только уп
53827	3305	СЫРОК Савушкин Творобушки ваниль глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	t	2025-12-07 13:19:37.509	2025-12-07 13:19:37.509	53.00	шт	18	только уп
53828	3305	СЫРОК Савушкин Творобушки клубника глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	18	t	2025-12-07 13:19:37.526	2025-12-07 13:19:37.526	53.00	шт	18	только уп
53829	3305	СЫРОК Савушкин Творобушки малина глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	t	2025-12-07 13:19:37.542	2025-12-07 13:19:37.542	53.00	шт	18	только уп
53830	3305	СЫРОК Савушкин Творобушки манго глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	t	2025-12-07 13:19:37.56	2025-12-07 13:19:37.56	53.00	шт	18	только уп
53831	3305	СЫРОК Савушкин фисташка глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	t	2025-12-07 13:19:37.574	2025-12-07 13:19:37.574	53.00	шт	18	только уп
53832	3305	СЫРОК Советские традиции  Крем-брюле глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	t	2025-12-07 13:19:37.598	2025-12-07 13:19:37.598	91.00	шт	10	только уп
53833	3305	СЫРОК Советские традиции Барбарис глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	t	2025-12-07 13:19:37.701	2025-12-07 13:19:37.701	91.00	шт	10	только уп
53834	3305	СЫРОК Советские традиции Ваниль глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	t	2025-12-07 13:19:37.713	2025-12-07 13:19:37.713	91.00	шт	10	только уп
53835	3305	СЫРОК Советские традиции Вар Сгущенка глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	t	2025-12-07 13:19:37.735	2025-12-07 13:19:37.735	91.00	шт	10	только уп
53836	3305	СЫРОК Советские традиции Вишня глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	t	2025-12-07 13:19:37.783	2025-12-07 13:19:37.783	91.00	шт	10	только уп
53837	3305	СЫРОК Советские традиции Какао глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	t	2025-12-07 13:19:37.795	2025-12-07 13:19:37.795	91.00	шт	10	только уп
53838	3305	СЫРОК Советские традиции Карамель глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	t	2025-12-07 13:19:37.807	2025-12-07 13:19:37.807	91.00	шт	10	только уп
26008	2755	СЕЛЬДЬ ТИХООКЕАНСКАЯ мороженая 27+ 1/13кг Тихрыбком*	\N	\N	1269.00	уп (13 шт)	1	1000	f	2025-11-10 01:56:12.586	2025-11-22 01:30:48.533	97.60	кг	13	\N
53839	3305	ТВОРОГ 1кг 9% м/у ТМ Савушкин	\N	\N	2815.00	уп (4 шт)	1	63	t	2025-12-07 13:19:37.824	2025-12-07 13:19:37.824	704.00	шт	4	только уп
53840	3305	ТВОРОГ вес 5кг 5% ТМ Заснеженная Русь	\N	\N	2478.00	уп (5 шт)	1	200	t	2025-12-07 13:19:37.836	2025-12-07 13:19:37.836	496.00	кг	5	только уп
53841	3305	ТВОРОГ вес 5кг Традиционный рассыпчатый 9% (крем продукт с творогм с змж) ТМ Заснеженная Русь	\N	\N	1754.00	уп (5 шт)	1	200	t	2025-12-07 13:19:37.848	2025-12-07 13:19:37.848	351.00	кг	5	только уп
53842	3305	ТВОРОГ вес 5кг Традиционный термостабильный 18% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	1811.00	уп (5 шт)	1	200	t	2025-12-07 13:19:37.862	2025-12-07 13:19:37.862	362.00	кг	5	только уп
53843	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная ваниль 23% (крем продукт термостабильный с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	200	t	2025-12-07 13:19:37.875	2025-12-07 13:19:37.875	423.00	кг	5	только уп
53844	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная изюм 23% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	175	t	2025-12-07 13:19:37.895	2025-12-07 13:19:37.895	423.00	кг	5	только уп
53845	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная клубника 23% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	140	t	2025-12-07 13:19:37.915	2025-12-07 13:19:37.915	423.00	кг	5	только уп
53846	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная курага 23% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	35	t	2025-12-07 13:19:37.928	2025-12-07 13:19:37.928	423.00	кг	5	только уп
53847	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная шоколадная крошка 23% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	40	t	2025-12-07 13:19:37.941	2025-12-07 13:19:37.941	423.00	кг	5	только уп
53848	3391	ГОРЯЧАЯ ШТУЧКА Наггетсы кур Хрустящие вес куриные 6кг ТМ Зареченские	\N	\N	2525.00	уп (6 шт)	1	114	t	2025-12-07 13:19:37.954	2025-12-07 13:19:37.954	421.00	кг	6	только уп
53849	3391	ЗАРЕЧЕНСКИЕ Наггетсы кур Хрустящие 230гр ТМ Стародворье	\N	\N	1753.00	шт	1	11	t	2025-12-07 13:19:37.974	2025-12-07 13:19:37.974	146.00	шт	12	поштучно
53850	3391	ЗАРЕЧЕНСКИЕ Наггетсы кур Хрустящие 300гр ТМ Зареченские	\N	\N	1283.00	шт	1	107	t	2025-12-07 13:19:37.995	2025-12-07 13:19:37.995	143.00	шт	9	поштучно
53851	3391	НАГГЕТСЫ куриные запеченные с сыром 250гр ТМ ТМ Вязанка	\N	\N	2084.00	шт	1	300	t	2025-12-07 13:19:38.007	2025-12-07 13:19:38.007	174.00	шт	12	поштучно
53852	3391	НАГГЕТСЫ куриные растительные 200гр ТМ Foodgital	\N	\N	966.00	шт	1	16	t	2025-12-07 13:19:38.034	2025-12-07 13:19:38.034	161.00	шт	6	поштучно
53853	3391	НАГГЕТСЫ куриные Сливушки Из Печи 250гр ТМ ТМ Вязанка	\N	\N	2084.00	шт	1	300	t	2025-12-07 13:19:38.046	2025-12-07 13:19:38.046	174.00	шт	12	поштучно
53854	3391	НАГГЕТСЫ НАГЕТОСЫ куриные Сочная курочка 250гр ТМ Горячаяя штучка	\N	\N	793.00	шт	1	269	t	2025-12-07 13:19:38.057	2025-12-07 13:19:38.057	132.00	шт	6	поштучно
53855	3391	НАГГЕТСЫ НАГЕТОСЫ куриные Сочная курочка в хрустящей панировке со сметаной и зеленью 250гр ТМ Горячаяя штучка	\N	\N	925.00	шт	1	190	t	2025-12-07 13:19:38.069	2025-12-07 13:19:38.069	154.00	шт	6	поштучно
53856	3391	НАГГЕТСЫ с индейкой Сливушки Из Печи 250гр ТМ ТМ Вязанка	\N	\N	2084.00	шт	1	300	t	2025-12-07 13:19:38.083	2025-12-07 13:19:38.083	174.00	шт	12	поштучно
53857	3391	ОСНОВА для пиццы 350гр (2 штуки в коробке) ТМ Морозко	\N	\N	719.00	уп (5 шт)	1	300	t	2025-12-07 13:19:38.095	2025-12-07 13:19:38.095	144.00	шт	5	только уп
53858	3391	ОСНОВА для пиццы 450гр  (2 штуки в пакете) ТМ Цезарь	\N	\N	1187.00	уп (8 шт)	1	153	t	2025-12-07 13:19:38.106	2025-12-07 13:19:38.106	148.00	шт	8	только уп
53859	3391	ПИЦЦА Цезарь 390гр С моцареллой	\N	\N	1357.00	уп (4 шт)	1	126	t	2025-12-07 13:19:38.117	2025-12-07 13:19:38.117	339.00	шт	4	только уп
53860	3391	ПИЦЦА Цезарь 390гр Четыре сыра	\N	\N	1219.00	уп (4 шт)	1	28	t	2025-12-07 13:19:38.128	2025-12-07 13:19:38.128	305.00	шт	4	только уп
53861	3391	ПИЦЦА Цезарь 420гр С ветчиной	\N	\N	1357.00	уп (4 шт)	1	178	t	2025-12-07 13:19:38.139	2025-12-07 13:19:38.139	339.00	шт	4	только уп
53862	3391	ПИЦЦА Цезарь 420гр С ветчиной и грибами	\N	\N	1385.00	уп (4 шт)	1	157	t	2025-12-07 13:19:38.154	2025-12-07 13:19:38.154	346.00	шт	4	только уп
53863	3391	ГОРЯЧАЯ ШТУЧКА Мини- сосиска в тесте 1кг ТМ Зареченские	\N	\N	1613.00	кг	1	7	t	2025-12-07 13:19:38.164	2025-12-07 13:19:38.164	436.00	кг	4	поштучно
53864	3391	ГОРЯЧАЯ ШТУЧКА бельмеши Сочные с мясом 300гр	\N	\N	2001.00	шт	1	300	t	2025-12-07 13:19:38.176	2025-12-07 13:19:38.176	167.00	шт	12	поштучно
53865	3391	ГОРЯЧАЯ ШТУЧКА Бульмени хрустящие с мясом 220гр	\N	\N	1559.00	шт	1	300	t	2025-12-07 13:19:38.19	2025-12-07 13:19:38.19	130.00	шт	12	поштучно
53866	3391	ГОРЯЧАЯ ШТУЧКА Круггетсы из мяса птицы с сырным соусом 200гр ТМ Горячая Штучка	\N	\N	2056.00	шт	1	300	t	2025-12-07 13:19:38.2	2025-12-07 13:19:38.2	171.00	шт	12	поштучно
53867	3391	ГОРЯЧАЯ ШТУЧКА Круггетсы Сочные из мяса птицы 200гр ТМ Горячая Штучка	\N	\N	2001.00	шт	1	300	t	2025-12-07 13:19:38.211	2025-12-07 13:19:38.211	167.00	шт	12	поштучно
53868	3391	ГОРЯЧАЯ ШТУЧКА крылышки острые к пиву в панировке 300гр ТМ Горячая Штучка	\N	\N	2705.00	шт	1	300	t	2025-12-07 13:19:38.222	2025-12-07 13:19:38.222	225.00	шт	12	поштучно
53869	3391	ГОРЯЧАЯ ШТУЧКА крылышки хрустящие в панировке 300гр ТМ Горячая Штучка	\N	\N	2967.00	шт	1	300	t	2025-12-07 13:19:38.235	2025-12-07 13:19:38.235	247.00	шт	12	поштучно
42115	2755	СВИНИНА ШЕЯ с/м б/к вес (1кусок~1-2,5кг) ТМ Полянское	\N	\N	9712.00	уп (15 шт)	1	300	f	2025-11-30 11:02:34.294	2025-12-06 02:48:51.249	563.00	кг	15	\N
26059	2755	КРЕВЕТКА Тигровая 1кг с/м 16/20 очищенная с хвостиком Бангладеш	\N	\N	12100.00	уп (10 шт)	1	457	f	2025-11-10 01:56:15.355	2025-11-22 01:30:48.533	1210.00	шт	10	\N
53870	3391	ГОРЯЧАЯ ШТУЧКА Пекерсы с индейкой в сливочном соусе 250гр ТМ Горячая Штучка	\N	\N	1987.00	шт	1	300	t	2025-12-07 13:19:38.249	2025-12-07 13:19:38.249	166.00	шт	12	поштучно
53871	3391	ГОРЯЧАЯ ШТУЧКА Хотстеры сосиска в тесте 250гр ТМ Горячая Штучка	\N	\N	2208.00	шт	1	300	t	2025-12-07 13:19:38.261	2025-12-07 13:19:38.261	184.00	шт	12	поштучно
53872	3391	ГОРЯЧАЯ ШТУЧКА Хотстеры сосиска в тесте с сыром 250гр ТМ Горячая Штучка	\N	\N	2332.00	шт	1	300	t	2025-12-07 13:19:38.3	2025-12-07 13:19:38.3	194.00	шт	12	поштучно
53873	3391	ГОРЯЧАЯ ШТУЧКА Чебуманы с говядиной 280г ТМ Горячая Штучка	\N	\N	1070.00	шт	1	207	t	2025-12-07 13:19:38.378	2025-12-07 13:19:38.378	178.00	шт	6	поштучно
53874	3391	ГОРЯЧАЯ ШТУЧКА Чебупели Курочка гриль 300гр ТМ Горячая Штучка	\N	\N	1900.00	шт	1	291	t	2025-12-07 13:19:38.425	2025-12-07 13:19:38.425	136.00	шт	14	поштучно
53875	3391	ГОРЯЧАЯ ШТУЧКА Чебупели острые с мясом 240гр ТМ Горячая Штучка	\N	\N	2015.00	шт	1	290	t	2025-12-07 13:19:38.439	2025-12-07 13:19:38.439	168.00	шт	12	поштучно
53876	3391	ГОРЯЧАЯ ШТУЧКА Чебупели растительные 200гр 1/6шт ТМ Горячая Штучка	\N	\N	849.00	шт	1	83	t	2025-12-07 13:19:38.521	2025-12-07 13:19:38.521	141.00	шт	6	поштучно
53877	3391	ГОРЯЧАЯ ШТУЧКА Чебупели с мясом 240гр ТМ Горячая Штучка	\N	\N	1766.00	шт	1	193	t	2025-12-07 13:19:38.534	2025-12-07 13:19:38.534	147.00	шт	12	поштучно
53878	3391	ГОРЯЧАЯ ШТУЧКА Чебупели с мясом XXL 480гр ТМ Горячая Штучка	\N	\N	2042.00	шт	1	222	t	2025-12-07 13:19:38.55	2025-12-07 13:19:38.55	255.00	шт	8	поштучно
53879	3391	ГОРЯЧАЯ ШТУЧКА Чебупели Сочные с мясом 240гр ТМ Горячая Штучка	\N	\N	1822.00	шт	1	300	t	2025-12-07 13:19:38.561	2025-12-07 13:19:38.561	152.00	шт	12	поштучно
53880	3391	ГОРЯЧАЯ ШТУЧКА Чебупицца 4 сыра 200гр ТМ Foodgital	\N	\N	1014.00	шт	1	300	t	2025-12-07 13:19:38.573	2025-12-07 13:19:38.573	169.00	шт	6	поштучно
53881	3391	ГОРЯЧАЯ ШТУЧКА Чебупицца Курочка по-итальянски 250гр ТМ Горячая Штучка	\N	\N	2139.00	шт	1	300	t	2025-12-07 13:19:38.583	2025-12-07 13:19:38.583	178.00	шт	12	поштучно
53882	3391	ГОРЯЧАЯ ШТУЧКА Чебупицца Маргарита 200гр ТМ Foodgital	\N	\N	1014.00	шт	1	199	t	2025-12-07 13:19:38.595	2025-12-07 13:19:38.595	169.00	шт	6	поштучно
53883	3391	ГОРЯЧАЯ ШТУЧКА Чебупицца Пепперони 250гр ТМ Горячая Штучка	\N	\N	2139.00	шт	1	300	t	2025-12-07 13:19:38.609	2025-12-07 13:19:38.609	178.00	шт	12	поштучно
53884	3391	ГОРЯЧАЯ ШТУЧКА Чебурек с мясом 90гр ТМ Горячая Штучка	\N	\N	1021.00	шт	1	229	t	2025-12-07 13:19:38.62	2025-12-07 13:19:38.62	43.00	шт	24	поштучно
53885	3391	ГОРЯЧАЯ ШТУЧКА Чебуреки растительные 360гр ТМ Foodgital	\N	\N	897.00	шт	1	82	t	2025-12-07 13:19:38.631	2025-12-07 13:19:38.631	224.00	шт	4	поштучно
53886	3391	ГОРЯЧАЯ ШТУЧКА Чебуреки растительные 90гр ТМ Foodgital	\N	\N	1352.00	шт	1	300	t	2025-12-07 13:19:38.641	2025-12-07 13:19:38.641	56.00	шт	24	поштучно
53887	3391	ГОРЯЧАЯ ШТУЧКА Чебуреки свинина и говядина 360гр ТМ Горячая Штучка	\N	\N	1644.00	шт	1	300	t	2025-12-07 13:19:38.652	2025-12-07 13:19:38.652	164.00	шт	10	поштучно
53888	3391	ЖАРЕНКИ колобки с мясом мини 300гр ТМ Морозко	\N	\N	2470.00	шт	1	244	t	2025-12-07 13:19:38.672	2025-12-07 13:19:38.672	206.00	шт	12	поштучно
53889	3391	ЖАРЕНКИ пицца мини 300гр ТМ Морозко	\N	\N	2387.00	шт	1	89	t	2025-12-07 13:19:38.684	2025-12-07 13:19:38.684	199.00	шт	12	поштучно
53890	3391	ЖАРЕНКИ самса с мясом мини 300гр ТМ Морозко	\N	\N	2305.00	шт	1	197	t	2025-12-07 13:19:38.698	2025-12-07 13:19:38.698	192.00	шт	12	поштучно
53891	3391	ЖАРЕНКИ чебурек с бараниной 125гр ТМ Морозко	\N	\N	1495.00	шт	1	300	t	2025-12-07 13:19:38.711	2025-12-07 13:19:38.711	75.00	шт	20	поштучно
53892	3391	ЖАРЕНКИ чебурек с картофелем и грибами 125гр ТМ Морозко	\N	\N	1288.00	шт	1	166	t	2025-12-07 13:19:38.722	2025-12-07 13:19:38.722	64.00	шт	20	поштучно
53893	3391	ЖАРЕНКИ чебурек с мясом Богатырь 180гр ТМ Морозко	\N	\N	1635.00	шт	1	300	t	2025-12-07 13:19:38.736	2025-12-07 13:19:38.736	91.00	шт	18	поштучно
53894	3391	ЖАРЕНКИ чебурек с мясом Вкусный 85гр ТМ Морозко	\N	\N	1840.00	шт	1	300	t	2025-12-07 13:19:38.75	2025-12-07 13:19:38.75	46.00	шт	40	поштучно
53895	3391	ЖАРЕНКИ чебурек с мясом Сочный 125гр ТМ Морозко	\N	\N	1357.00	шт	1	252	t	2025-12-07 13:19:38.762	2025-12-07 13:19:38.762	68.00	шт	20	поштучно
53896	3391	ЖАРЕНКИ чебурешки с ветчиной и сыром мини 300гр ТМ Морозко	\N	\N	2305.00	шт	1	263	t	2025-12-07 13:19:38.781	2025-12-07 13:19:38.781	192.00	шт	12	поштучно
53897	3391	ЖАРЕНКИ чебурешки с мясом мини 300гр ТМ Морозко	\N	\N	2180.00	шт	1	300	t	2025-12-07 13:19:38.791	2025-12-07 13:19:38.791	182.00	шт	12	поштучно
53898	3391	ЗАРЕЧЕНСКИЕ МИНИ-ЧЕБУРЕЧКИ  с мясом вес 5,5кг ТМ Зареченские	\N	\N	1885.00	уп (6 шт)	1	28	t	2025-12-07 13:19:38.802	2025-12-07 13:19:38.802	343.00	кг	6	только уп
53899	3391	ЗАРЕЧЕНСКИЕ Мини-шарики с курочкой и сыром вес 3кг  ТМ Зареченские	\N	\N	1242.00	уп (3 шт)	1	15	t	2025-12-07 13:19:38.813	2025-12-07 13:19:38.813	414.00	кг	3	только уп
53900	3391	ЗАРЕЧЕНСКИЕ Пирожки с яблоком и грушей 300гр ТМ Зареченские	\N	\N	931.00	уп (9 шт)	1	16	t	2025-12-07 13:19:38.824	2025-12-07 13:19:38.824	103.00	шт	9	только уп
53901	3391	ЗАРЕЧЕНСКИЕ Чебуречки мини с мясом 300гр ТМ Зареченские	\N	\N	1056.00	уп (9 шт)	1	157	t	2025-12-07 13:19:38.835	2025-12-07 13:19:38.835	117.00	шт	9	только уп
53902	3391	ЗАРЕЧЕНСКИЕ Чебуречки мини с сыром и ветчисной 300гр ТМ Зареченские	\N	\N	931.00	уп (9 шт)	1	18	t	2025-12-07 13:19:38.848	2025-12-07 13:19:38.848	103.00	шт	9	только уп
53903	3391	СТАРОДВОРЬЕ Биточки в кляре с сырным соусом 220гр ТМ Стародворье	\N	\N	1753.00	шт	1	228	t	2025-12-07 13:19:38.86	2025-12-07 13:19:38.86	146.00	шт	12	поштучно
53904	3391	СТАРОДВОРЬЕ ВАРЕНИКИ жареные с картофелем и беконом 200гр ТМ Стародворье	\N	\N	1808.00	шт	1	300	t	2025-12-07 13:19:38.871	2025-12-07 13:19:38.871	151.00	шт	12	поштучно
26063	2755	КРЕВЕТКА Северная 800гр в/м 70/90 неразделанная Китай	\N	\N	8640.00	уп (12 шт)	1	390	f	2025-11-10 01:56:15.565	2025-11-22 01:30:48.533	720.00	шт	12	\N
26099	2755	ИКРА МОЙВЫ 165гр деликатесная с лососем ТМ Русское Море	\N	\N	1056.00	уп (6 шт)	1	46	f	2025-11-10 01:56:17.379	2025-11-22 01:30:48.533	176.00	шт	6	\N
53905	3391	СТАРОДВОРЬЕ Жар-ладушки с  клубникой и вишней  200гр  ТМ Стародворье	\N	\N	1656.00	шт	1	130	t	2025-12-07 13:19:38.884	2025-12-07 13:19:38.884	138.00	шт	12	поштучно
53906	3391	СТАРОДВОРЬЕ Жар-ладушки яблоком и грушей  200гр  ТМ Стародворье	\N	\N	1656.00	шт	1	168	t	2025-12-07 13:19:38.894	2025-12-07 13:19:38.894	138.00	шт	12	поштучно
53907	3391	СТАРОДВОРЬЕ ПЕЛЬМЕНИ жареные с мясом 200гр ТМ Стародворье	\N	\N	1697.00	шт	1	261	t	2025-12-07 13:19:38.906	2025-12-07 13:19:38.906	141.00	шт	12	поштучно
53908	3391	СТАРОДВОРЬЕ ПЕЛЬМЕНИ жареные с мясом и сыром 200гр ТМ Стародворье	\N	\N	1808.00	шт	1	137	t	2025-12-07 13:19:38.918	2025-12-07 13:19:38.918	151.00	шт	12	поштучно
53909	3391	БЛИНЫ "Царское подворье" вес 5кг с мясом	\N	\N	1719.00	уп (5 шт)	1	100	t	2025-12-07 13:19:38.93	2025-12-07 13:19:38.93	344.00	кг	5	только уп
53910	3391	БЛИНЫ Масленица с мясом вес трубочка	\N	\N	1891.00	уп (6 шт)	1	6	t	2025-12-07 13:19:38.942	2025-12-07 13:19:38.942	315.00	кг	6	только уп
53911	3391	БЛИНЫ Масленица с мясом курицы вес трубочка	\N	\N	2022.00	уп (6 шт)	1	174	t	2025-12-07 13:19:38.953	2025-12-07 13:19:38.953	337.00	кг	6	только уп
53912	3391	БЛИНЫ Масленица с творогом вес трубочка	\N	\N	1856.00	уп (6 шт)	1	102	t	2025-12-07 13:19:38.969	2025-12-07 13:19:38.969	309.00	кг	6	только уп
53913	3391	БЛИНЫ Бабушка Аня 420г мясо 1/12шт ТМ Санта Бремор	\N	\N	2443.00	шт	1	55	t	2025-12-07 13:19:38.98	2025-12-07 13:19:38.98	204.00	шт	12	поштучно
53914	3391	БЛИНЫ Морозко 210гр с ветчиной и сыром конверт пакет	\N	\N	3317.00	шт	1	300	t	2025-12-07 13:19:38.99	2025-12-07 13:19:38.99	118.00	шт	28	поштучно
53915	3391	БЛИНЫ Морозко 210гр с мясом конверт пакет	\N	\N	2415.00	шт	1	300	t	2025-12-07 13:19:39.001	2025-12-07 13:19:39.001	86.00	шт	28	поштучно
53916	3391	БЛИНЫ Морозко 210гр с мясом кур конверт  пакет	\N	\N	2447.00	шт	1	300	t	2025-12-07 13:19:39.012	2025-12-07 13:19:39.012	87.00	шт	28	поштучно
53917	3391	БЛИНЫ Морозко 210гр с творогом конверт пакет	\N	\N	2512.00	шт	1	300	t	2025-12-07 13:19:39.023	2025-12-07 13:19:39.023	90.00	шт	28	поштучно
53918	3391	БЛИНЫ Морозко 370гр с ветчиной и сыром трубочки лоток	\N	\N	3043.00	шт	1	145	t	2025-12-07 13:19:39.034	2025-12-07 13:19:39.034	217.00	шт	14	поштучно
53919	3391	БЛИНЫ Морозко 370гр с вишней трубочки лоток	\N	\N	2399.00	шт	1	300	t	2025-12-07 13:19:39.05	2025-12-07 13:19:39.05	171.00	шт	14	поштучно
53920	3391	БЛИНЫ Морозко 370гр с клубникой трубочки лоток	\N	\N	2657.00	шт	1	300	t	2025-12-07 13:19:39.071	2025-12-07 13:19:39.071	190.00	шт	14	поштучно
53921	3391	БЛИНЫ Морозко 370гр с мясом трубочки лоток	\N	\N	2463.00	шт	1	300	t	2025-12-07 13:19:39.083	2025-12-07 13:19:39.083	176.00	шт	14	поштучно
53922	3391	БЛИНЫ Морозко 370гр с творогом трубочки лоток	\N	\N	2689.00	шт	1	300	t	2025-12-07 13:19:39.105	2025-12-07 13:19:39.105	192.00	шт	14	поштучно
53923	3391	БЛИНЫ Морозко 420гр  с мясом конверт коробка	\N	\N	2732.00	шт	1	300	t	2025-12-07 13:19:39.117	2025-12-07 13:19:39.117	228.00	шт	12	поштучно
53924	3391	БЛИНЫ Морозко 420гр с вареной сгущенкой конверт коробка	\N	\N	2291.00	шт	1	300	t	2025-12-07 13:19:39.129	2025-12-07 13:19:39.129	191.00	шт	12	поштучно
53925	3391	БЛИНЫ Морозко 420гр с ветчиной и сыром конверт коробка	\N	\N	3478.00	шт	1	300	t	2025-12-07 13:19:39.139	2025-12-07 13:19:39.139	290.00	шт	12	поштучно
53926	3391	БЛИНЫ Морозко 420гр с клубничным повидлом конверт коробка	\N	\N	2374.00	шт	1	300	t	2025-12-07 13:19:39.155	2025-12-07 13:19:39.155	198.00	шт	12	поштучно
53927	3391	БЛИНЫ Морозко 420гр с мясом кур конверт коробка	\N	\N	2567.00	шт	1	300	t	2025-12-07 13:19:39.173	2025-12-07 13:19:39.173	214.00	шт	12	поштучно
53928	3391	БЛИНЫ Морозко 420гр с мясом молодых бычков конверт коробка	\N	\N	2829.00	шт	1	300	t	2025-12-07 13:19:39.184	2025-12-07 13:19:39.184	236.00	шт	12	поштучно
53929	3391	БЛИНЫ Морозко 420гр с творогом конверт коробка	\N	\N	2429.00	шт	1	300	t	2025-12-07 13:19:39.196	2025-12-07 13:19:39.196	202.00	шт	12	поштучно
53930	3391	БЛИНЫ Царское подворье 420гр с мясом конверт ванночка	\N	\N	2111.00	шт	1	300	t	2025-12-07 13:19:39.209	2025-12-07 13:19:39.209	176.00	шт	12	поштучно
53931	3391	БЛИНЫ Царское подворье 420гр с творогом конверт ванночка	\N	\N	2236.00	шт	1	300	t	2025-12-07 13:19:39.221	2025-12-07 13:19:39.221	186.00	шт	12	поштучно
53932	3391	БЛИНЫ Цезарь 450гр с отборной ветчиной и сыром конверт ванночка	\N	\N	4858.00	шт	1	248	t	2025-12-07 13:19:39.275	2025-12-07 13:19:39.275	405.00	шт	12	поштучно
53933	3391	БЛИНЫ Цезарь 450гр с творогом деревенским конверт ванночка	\N	\N	3698.00	шт	1	265	t	2025-12-07 13:19:39.311	2025-12-07 13:19:39.311	308.00	шт	12	поштучно
53934	3391	БЛИНЫ Цезарь 450гр с телятиной конверт ванночка	\N	\N	5534.00	шт	1	279	t	2025-12-07 13:19:39.372	2025-12-07 13:19:39.372	461.00	шт	12	поштучно
53935	3391	Азу из курицы с картоф пюре 350гр ТМ Сытоедов	\N	\N	3047.00	шт	1	128	t	2025-12-07 13:19:39.383	2025-12-07 13:19:39.383	305.00	шт	10	поштучно
53936	3391	Азу с рисом из отборной говядины 350гр ТМ Сытоедов	\N	\N	4784.00	шт	1	138	t	2025-12-07 13:19:39.393	2025-12-07 13:19:39.393	478.00	шт	10	поштучно
53937	3391	Бефстроганов из говядины с карт/пюре 320гр ТМ Сытоедов	\N	\N	4209.00	шт	1	162	t	2025-12-07 13:19:39.415	2025-12-07 13:19:39.415	421.00	шт	10	поштучно
40866	2755	КОНФЕТЫ 1кг молочные Тоффи Мягкая карамель в шоколаде с мармеладом из клюквы ТМ Победа	\N	\N	2226.00	уп (2 шт)	1	52	f	2025-11-30 11:01:36.186	2025-12-06 02:48:51.249	968.00	шт	2	\N
40870	2755	ПЕЧЕНЬЕ 360гр Чоко Пай	\N	\N	1987.00	уп (8 шт)	1	758	f	2025-11-30 11:01:36.342	2025-12-06 02:48:51.249	216.00	шт	8	\N
40897	2755	РЕБРЫШКИ свиные Пикантные в/к с/м 1/6-8кг ТМ Алтайский купец	\N	\N	5985.00	уп (7 шт)	1	17	f	2025-11-30 11:01:37.472	2025-12-06 02:48:51.249	710.00	кг	7	\N
40938	2755	СЫР вес Ламберт голд 45% (1шт~1,7кг) шар ТМ Молодея Беларусь	\N	\N	926.00	кг	1	135	f	2025-11-30 11:01:39.276	2025-12-06 02:48:51.249	805.00	кг	\N	\N
41193	2755	МАКАРОНЫ "Шебекинские" 450гр Перья брикет (новая упаквока) №343	\N	\N	1932.00	уп (20 шт)	1	51	f	2025-11-30 11:01:50.512	2025-12-06 02:48:51.249	84.00	шт	20	\N
41629	2755	ВОДА МОНАСТЫРСКАЯ 0,5л газированная пэт	\N	\N	814.00	уп (12 шт)	1	200	f	2025-11-30 11:02:11.512	2025-12-06 02:48:51.249	59.00	шт	12	\N
41739	2755	МОЛОКО Минская марка 3,2% 1л стеризованное тетрапак	\N	\N	1684.00	уп (12 шт)	1	200	f	2025-11-30 11:02:16.507	2025-12-06 02:48:51.249	122.00	шт	12	\N
41741	2755	МОЛОКО Северная долина 2,5% 950мл ультрапастеризованное 1/12шт	\N	\N	1587.00	уп (12 шт)	1	200	f	2025-11-30 11:02:16.592	2025-12-06 02:48:51.249	115.00	шт	12	\N
42047	2755	ОКОРОЧОК КУР вес для жарки Халяль ТМ Благояр	\N	\N	3767.00	уп (13 шт)	1	300	f	2025-11-30 11:02:30.864	2025-12-06 02:48:51.249	252.00	кг	13	\N
42162	2755	КЕТА потрошенная без головы с/м 1/22кг Вылов 2025 - *	\N	\N	13662.00	уп (22 шт)	1	792	f	2025-11-30 11:02:36.439	2025-12-06 02:48:51.249	540.00	кг	22	\N
42175	2755	СЕЛЬДЬ ТИХООКЕАНСКАЯ мороженая 1/20кг с/м*	\N	\N	2047.00	уп (20 шт)	1	1000	f	2025-11-30 11:02:36.954	2025-12-06 02:48:51.249	89.00	кг	20	\N
53938	3391	Бифштекс из говядины с карт/пюре 350гр  ТМ Сытоедов	\N	\N	3185.00	шт	1	225	t	2025-12-07 13:19:39.429	2025-12-07 13:19:39.429	319.00	шт	10	поштучно
53939	3391	Горбушка по царски с картофельным пюре 300гр ТМ Главобед	\N	\N	3045.00	шт	1	62	t	2025-12-07 13:19:39.442	2025-12-07 13:19:39.442	381.00	шт	8	поштучно
53940	3391	Горбушка по царски с рисом 300гр ТМ Главобед	\N	\N	3045.00	шт	1	78	t	2025-12-07 13:19:39.453	2025-12-07 13:19:39.453	381.00	шт	8	поштучно
53941	3391	Грудка куриная в тесте в соусе Сюпрем и карт пюре 350гр ТМ Сытоедов	\N	\N	3392.00	шт	1	177	t	2025-12-07 13:19:39.464	2025-12-07 13:19:39.464	339.00	шт	10	поштучно
53942	3391	Гуляш из говядины с лапшой 300гр ТМ Главобед	\N	\N	3275.00	шт	1	175	t	2025-12-07 13:19:39.474	2025-12-07 13:19:39.474	409.00	шт	8	поштучно
53943	3391	Гуляш из говядины с рисом 300гр ТМ Главобед	\N	\N	3487.00	шт	1	147	t	2025-12-07 13:19:39.484	2025-12-07 13:19:39.484	436.00	шт	8	поштучно
53944	3391	Гуляш из свинины с гречкой 300гр ТМ Сытоедов	\N	\N	2174.00	шт	1	192	t	2025-12-07 13:19:39.499	2025-12-07 13:19:39.499	217.00	шт	10	поштучно
53945	3391	Гуляш из свинины с карт/пюре 300гр ТМ Сытоедов	\N	\N	2369.00	шт	1	224	t	2025-12-07 13:19:39.51	2025-12-07 13:19:39.51	237.00	шт	10	поштучно
53946	3391	Гуляш с макаронами 350гр ТМ Сытоедов	\N	\N	4807.00	шт	1	65	t	2025-12-07 13:19:39.521	2025-12-07 13:19:39.521	481.00	шт	10	поштучно
53947	3391	Жюльен из курицы с грибами 2*125гр ТМ Сытоедов	\N	\N	4099.00	шт	1	132	t	2025-12-07 13:19:39.532	2025-12-07 13:19:39.532	342.00	шт	12	поштучно
53948	3391	Жюльен с белыми грибами и шампиньонами 2*125гр ТМ Сытоедов	\N	\N	4513.00	шт	1	117	t	2025-12-07 13:19:39.547	2025-12-07 13:19:39.547	376.00	шт	12	поштучно
53949	3391	Запеканка творожная ванильная 240гр ТМ Главсуп	\N	\N	3321.00	шт	1	13	t	2025-12-07 13:19:39.557	2025-12-07 13:19:39.557	415.00	шт	8	поштучно
53950	3391	Запеканка творожная с шоколадом и кокосом 240гр ТМ Главобед	\N	\N	3717.00	шт	1	23	t	2025-12-07 13:19:39.57	2025-12-07 13:19:39.57	465.00	шт	8	поштучно
53951	3391	Запеканка творожно-тыквенная с лимоном и корицей 240гр ТМ Главобед	\N	\N	2990.00	шт	1	14	t	2025-12-07 13:19:39.582	2025-12-07 13:19:39.582	374.00	шт	8	поштучно
53952	3391	Зраза куриная фаршированная сыром с рисом 300гр ТМ Сытоедов	\N	\N	3036.00	шт	1	155	t	2025-12-07 13:19:39.592	2025-12-07 13:19:39.592	304.00	шт	10	поштучно
53953	3391	Каша из зеленой гречки на кокосовом молоке с ананасом 250гр ТМ Главобед	\N	\N	2484.00	шт	1	22	t	2025-12-07 13:19:39.624	2025-12-07 13:19:39.624	311.00	шт	8	поштучно
53954	3391	Колбаска куриная с феттучини под сливочным соусом 300гр ТМ Сытоедов	\N	\N	3852.00	шт	1	56	t	2025-12-07 13:19:39.704	2025-12-07 13:19:39.704	385.00	шт	10	поштучно
53955	3391	Колбаска Мюнхенская с карт пюре под соусом Барбекю 300гр ТМ Сытоедов	\N	\N	3093.00	шт	1	167	t	2025-12-07 13:19:39.715	2025-12-07 13:19:39.715	309.00	шт	10	поштучно
53956	3391	Котлета Кокетка с картофельным пюре под красным соусом Бешамель 350гр ТМ Сытоедов	\N	\N	3312.00	шт	1	289	t	2025-12-07 13:19:39.725	2025-12-07 13:19:39.725	331.00	шт	10	поштучно
53957	3391	Котлета куриная с гречкой 300гр ТМ Главобед	\N	\N	2217.00	шт	1	136	t	2025-12-07 13:19:39.75	2025-12-07 13:19:39.75	277.00	шт	8	поштучно
53958	3391	Котлета куриная с карт пюре под белым грибным соусом 350гр ТМ Сытоедов	\N	\N	3381.00	шт	1	159	t	2025-12-07 13:19:39.765	2025-12-07 13:19:39.765	338.00	шт	10	поштучно
53959	3391	Котлета по-домашнему с гречкой и гриб соус 300гр ТМ Сытоедов	\N	\N	2082.00	шт	1	166	t	2025-12-07 13:19:39.781	2025-12-07 13:19:39.781	208.00	шт	10	поштучно
53960	3391	Котлета по-Киевски с рисом 300гр ТМ Сытоедов	\N	\N	3657.00	шт	1	201	t	2025-12-07 13:19:39.814	2025-12-07 13:19:39.814	366.00	шт	10	поштучно
53961	3391	Котлета с картофельным пюре 300гр ТМ Главобед	\N	\N	2364.00	шт	1	171	t	2025-12-07 13:19:39.827	2025-12-07 13:19:39.827	296.00	шт	8	поштучно
53962	3391	Котлета с макаронами и томатным соусо 300гр ТМ Сытоедов	\N	\N	2415.00	шт	1	246	t	2025-12-07 13:19:39.843	2025-12-07 13:19:39.843	241.00	шт	10	поштучно
53963	3391	Курица в соусе Терияки с рисом 300гр ТМ Главобед	\N	\N	3183.00	шт	1	121	t	2025-12-07 13:19:39.855	2025-12-07 13:19:39.855	398.00	шт	8	поштучно
53964	3391	Лапша WOK Удон с говядиной и овощами 300гр ТМ Главобед	\N	\N	2581.00	шт	1	111	t	2025-12-07 13:19:39.866	2025-12-07 13:19:39.866	430.00	шт	6	поштучно
53965	3391	Лапша WOK Удон с курицей и овощами 300гр ТМ Главобед	\N	\N	2091.00	шт	1	117	t	2025-12-07 13:19:39.888	2025-12-07 13:19:39.888	348.00	шт	6	поштучно
53966	3391	Лапша по-китайски с курицей 300гр ТМ Главобед	\N	\N	2834.00	шт	1	78	t	2025-12-07 13:19:39.899	2025-12-07 13:19:39.899	354.00	шт	8	поштучно
53967	3391	Лапша с курицей в соусе Хойсин 300гр ТМ Главобед	\N	\N	2972.00	шт	1	78	t	2025-12-07 13:19:39.911	2025-12-07 13:19:39.911	371.00	шт	8	поштучно
53968	3391	Люля-Кебаб с рисом и соусом Ткемали 300гр ТМ Сытоедов	\N	\N	3887.00	шт	1	141	t	2025-12-07 13:19:39.923	2025-12-07 13:19:39.923	389.00	шт	10	поштучно
53969	3391	Макароны по-флотски 300гр ТМ Главобед	\N	\N	2640.00	шт	1	160	t	2025-12-07 13:19:39.948	2025-12-07 13:19:39.948	330.00	шт	8	поштучно
53970	3391	Макароны по-флотски 300гр ТМ Сытоедов	\N	\N	3093.00	шт	1	164	t	2025-12-07 13:19:39.964	2025-12-07 13:19:39.964	309.00	шт	10	поштучно
53971	3391	Паста Болоньезе 300гр ТМ Сытоедов	\N	\N	2512.00	шт	1	171	t	2025-12-07 13:19:39.977	2025-12-07 13:19:39.977	314.00	шт	8	поштучно
53972	3391	Паста Болоньезе с мясным фаршем 300гр ТМ Главобед	\N	\N	2254.00	шт	1	48	t	2025-12-07 13:19:39.998	2025-12-07 13:19:39.998	282.00	шт	8	поштучно
53973	3391	Паста Карбонара 300гр ТМ Главобед	\N	\N	1690.00	шт	1	88	t	2025-12-07 13:19:40.022	2025-12-07 13:19:40.022	282.00	шт	6	поштучно
53974	3391	Паста Палермо с курицей и грибами 300гр ТМ Сытоедов	\N	\N	2650.00	шт	1	167	t	2025-12-07 13:19:40.048	2025-12-07 13:19:40.048	331.00	шт	8	поштучно
53975	3391	Паста с ветчиной и сыром в соусе Бешамель 300гр ТМ Главобед	\N	\N	2870.00	шт	1	87	t	2025-12-07 13:19:40.068	2025-12-07 13:19:40.068	359.00	шт	8	поштучно
53976	3391	Паста с курицей в соусе Том ям 300гр ТМ Главобед	\N	\N	3211.00	шт	1	113	t	2025-12-07 13:19:40.08	2025-12-07 13:19:40.08	401.00	шт	8	поштучно
53977	3391	Печень по-Строгановски с карт пюре 350гр ТМ Сытоедов	\N	\N	3956.00	шт	1	170	t	2025-12-07 13:19:40.091	2025-12-07 13:19:40.091	396.00	шт	10	поштучно
53978	3391	Плов с курицей 300гр ТМ Главобед	\N	\N	2880.00	шт	1	150	t	2025-12-07 13:19:40.102	2025-12-07 13:19:40.102	360.00	шт	8	поштучно
53979	3391	Плов с курицей 300гр ТМ Сытоедов	\N	\N	2990.00	шт	1	294	t	2025-12-07 13:19:40.118	2025-12-07 13:19:40.118	299.00	шт	10	поштучно
53980	3391	Плов со свининой и пряностями  300гр ТМ Сытоедов	\N	\N	3427.00	шт	1	121	t	2025-12-07 13:19:40.129	2025-12-07 13:19:40.129	343.00	шт	10	поштучно
53981	3391	Поджарка из свинины с картофельным пюре 300гр ТМ Главобед	\N	\N	3386.00	шт	1	116	t	2025-12-07 13:19:40.14	2025-12-07 13:19:40.14	423.00	шт	8	поштучно
53982	3391	Суп Борщ оригинальный 250гр ТМ Главсуп	\N	\N	2512.00	шт	1	293	t	2025-12-07 13:19:40.155	2025-12-07 13:19:40.155	209.00	шт	12	поштучно
53983	3391	Суп Борщ с курицей 250гр ТМ Главсуп	\N	\N	2098.00	шт	1	259	t	2025-12-07 13:19:40.165	2025-12-07 13:19:40.165	175.00	шт	12	поштучно
53984	3391	Суп Борщ с курицей XL 360гр ТМ Главсуп	\N	\N	1297.00	шт	1	124	t	2025-12-07 13:19:40.18	2025-12-07 13:19:40.18	216.00	шт	6	поштучно
53985	3391	Суп Борщ Черниговский 300гр ТМ Сытоедов	\N	\N	3047.00	шт	1	270	t	2025-12-07 13:19:40.191	2025-12-07 13:19:40.191	305.00	шт	10	поштучно
53986	3391	Суп Гороховый с копченостями 250гр ТМ Главсуп	\N	\N	2015.00	шт	1	300	t	2025-12-07 13:19:40.206	2025-12-07 13:19:40.206	168.00	шт	12	поштучно
53987	3391	Суп Гороховый с копченостями 250гр ТМ Сытоедов	\N	\N	1646.00	шт	1	238	t	2025-12-07 13:19:40.216	2025-12-07 13:19:40.216	183.00	шт	9	поштучно
53988	3391	Суп Лагман с говядиной 250гр ТМ Главсуп	\N	\N	3105.00	шт	1	300	t	2025-12-07 13:19:40.228	2025-12-07 13:19:40.228	259.00	шт	12	поштучно
53989	3391	Суп Лапша Домашняя с курицей 300гр тарелка ТМ Сытоедов	\N	\N	2668.00	шт	1	173	t	2025-12-07 13:19:40.239	2025-12-07 13:19:40.239	267.00	шт	10	поштучно
53990	3391	Суп Лапша с курицей 250гр ТМ Главсуп	\N	\N	2180.00	шт	1	161	t	2025-12-07 13:19:40.253	2025-12-07 13:19:40.253	182.00	шт	12	поштучно
53991	3391	Суп Лапша с фрикадельками 250гр ТМ Главсуп	\N	\N	2070.00	шт	1	300	t	2025-12-07 13:19:40.265	2025-12-07 13:19:40.265	173.00	шт	12	поштучно
53992	3391	Суп Рассольник Галицкий 300гр тарелка ТМ Сытоедов	\N	\N	2622.00	шт	1	119	t	2025-12-07 13:19:40.342	2025-12-07 13:19:40.342	262.00	шт	10	поштучно
53993	3391	Суп Рассольник с курицей 250гр ТМ Главсуп	\N	\N	2029.00	шт	1	183	t	2025-12-07 13:19:40.404	2025-12-07 13:19:40.404	169.00	шт	12	поштучно
53994	3391	Суп Солянка мясная по-Новгородски 300гр тарелка ТМ Сытоедов	\N	\N	2933.00	шт	1	150	t	2025-12-07 13:19:40.427	2025-12-07 13:19:40.427	293.00	шт	10	поштучно
53995	3391	Суп Солянка по-домашнему 250гр ТМ Главсуп	\N	\N	2194.00	шт	1	14	t	2025-12-07 13:19:40.439	2025-12-07 13:19:40.439	183.00	шт	12	поштучно
53996	3391	Суп Солянка по-домашнему XL 360гр ТМ Главсуп	\N	\N	1325.00	шт	1	130	t	2025-12-07 13:19:40.45	2025-12-07 13:19:40.45	221.00	шт	6	поштучно
53997	3391	Суп Сычуаньский китайский 250гр 250гр ТМ Главсуп	\N	\N	2981.00	шт	1	72	t	2025-12-07 13:19:40.461	2025-12-07 13:19:40.461	248.00	шт	12	поштучно
53998	3391	Суп Том Ям 360гр ТМ Главсуп премиум	\N	\N	2760.00	шт	1	135	t	2025-12-07 13:19:40.488	2025-12-07 13:19:40.488	460.00	шт	6	поштучно
53999	3391	Суп Уха финская из лосося 360гр ТМ Главсуп	\N	\N	2463.00	шт	1	34	t	2025-12-07 13:19:40.529	2025-12-07 13:19:40.529	411.00	шт	6	поштучно
54000	3391	Суп Уха янтарная 250гр ТМ Главсуп	\N	\N	2098.00	шт	1	110	t	2025-12-07 13:19:40.548	2025-12-07 13:19:40.548	175.00	шт	12	поштучно
54001	3391	Суп Фо Бо 360гр ТМ Главсуп премиум	\N	\N	2629.00	шт	1	229	t	2025-12-07 13:19:40.56	2025-12-07 13:19:40.56	438.00	шт	6	поштучно
54002	3391	Суп Харчо с бараниной 300гр ТМ Сытоедов	\N	\N	3312.00	шт	1	161	t	2025-12-07 13:19:40.572	2025-12-07 13:19:40.572	331.00	шт	10	поштучно
54003	3391	Суп Щи по-деревенский 250гр ТМ Главсуп	\N	\N	2029.00	шт	1	97	t	2025-12-07 13:19:40.583	2025-12-07 13:19:40.583	169.00	шт	12	поштучно
54004	3391	Суп-Крем сырный 360гр ТМ Главсуп Премиум	\N	\N	2305.00	шт	1	18	t	2025-12-07 13:19:40.61	2025-12-07 13:19:40.61	384.00	шт	6	поштучно
54005	3391	Суп-пюре из шампиньонов со сливками 250гр ТМ Главсуп	\N	\N	3077.00	шт	1	95	t	2025-12-07 13:19:40.621	2025-12-07 13:19:40.621	256.00	шт	12	поштучно
54006	3391	Тефтели с гречкой под овощным соусом 350гр ТМ Сытоедов	\N	\N	3266.00	шт	1	111	t	2025-12-07 13:19:40.637	2025-12-07 13:19:40.637	327.00	шт	10	поштучно
54007	3391	Феттучини с мясом цыпленка под соусом Морней 350гр ТМ Сытоедов	\N	\N	3990.00	шт	1	35	t	2025-12-07 13:19:40.651	2025-12-07 13:19:40.651	399.00	шт	10	поштучно
54008	3391	Шницель с картофельным пюре под красным соусом 350гр ТМ Сытоедов	\N	\N	3266.00	шт	1	199	t	2025-12-07 13:19:40.663	2025-12-07 13:19:40.663	327.00	шт	10	поштучно
54009	3391	ПЕЛЬМЕНИ "Морозко" вес 6кг Особые	\N	\N	2056.00	уп (6 шт)	1	246	t	2025-12-07 13:19:40.688	2025-12-07 13:19:40.688	343.00	кг	6	только уп
54010	3391	ПЕЛЬМЕНИ "Пельменный Мастер" вес 6кг Классические (класс1шт- 26мм)	\N	\N	2277.00	уп (6 шт)	1	192	t	2025-12-07 13:19:40.699	2025-12-07 13:19:40.699	379.00	кг	6	только уп
54011	3391	ПЕЛЬМЕНИ БУЛЬМЕНИ вес 5кг с говядиной и свининой  ТМ Горячая Штучка	\N	\N	1351.00	уп (5 шт)	1	20	t	2025-12-07 13:19:40.711	2025-12-07 13:19:40.711	270.00	кг	5	только уп
54012	3391	ХИНКАЛИ мини вес ТМ Морозко	\N	\N	2190.00	уп (7 шт)	1	42	t	2025-12-07 13:19:40.721	2025-12-07 13:19:40.721	313.00	кг	7	только уп
54013	3356	ВАРЕНИКИ 4 сочных порции 800гр картофель шкварки	\N	\N	2144.00	шт	1	300	t	2025-12-07 13:19:40.731	2025-12-07 13:19:40.731	268.00	шт	8	поштучно
54014	3356	ВАРЕНИКИ Бабушка Аня 430гр картофель и грибы 1/10шт ТМ Санта Бремор	\N	\N	1644.00	шт	1	53	t	2025-12-07 13:19:40.748	2025-12-07 13:19:40.748	164.00	шт	10	поштучно
54015	3356	ВАРЕНИКИ Бабушка Аня 430гр картофель и лук 1/10шт ТМ Санта Бремор	\N	\N	1564.00	шт	1	16	t	2025-12-07 13:19:40.761	2025-12-07 13:19:40.761	156.00	шт	10	поштучно
54016	3356	ВАРЕНИКИ Бабушка Аня 430гр картофель и шкварки 1/10шт ТМ Санта Бремор	\N	\N	1644.00	шт	1	78	t	2025-12-07 13:19:40.784	2025-12-07 13:19:40.784	164.00	шт	10	поштучно
54017	3356	ВАРЕНИКИ Бабушка Аня 430гр клубника 1/10шт ТМ Санта Бремор	\N	\N	2254.00	шт	1	11	t	2025-12-07 13:19:40.796	2025-12-07 13:19:40.796	225.00	шт	10	поштучно
54018	3356	ВАРЕНИКИ Бабушка Аня 430гр творог 1/10шт ТМ Санта Бремор	\N	\N	2070.00	шт	1	10	t	2025-12-07 13:19:40.807	2025-12-07 13:19:40.807	207.00	шт	10	поштучно
54019	3356	ВАРЕНИКИ Большая кастрюля Экспресс с картофелем 200гр стакан ЗАЛЕЙ КИПЯТКОМ и ВАРИ 4 МИН В СВЧ	\N	\N	3001.00	шт	1	85	t	2025-12-07 13:19:40.82	2025-12-07 13:19:40.82	167.00	шт	18	поштучно
54020	3356	ВАРЕНИКИ Вари вареники 450гр вишня	\N	\N	2585.00	шт	1	173	t	2025-12-07 13:19:40.832	2025-12-07 13:19:40.832	323.00	шт	8	поштучно
54021	3356	ВАРЕНИКИ Вари вареники 450гр клубника	\N	\N	1978.00	шт	1	185	t	2025-12-07 13:19:40.844	2025-12-07 13:19:40.844	247.00	шт	8	поштучно
54022	3356	ВАРЕНИКИ Вари вареники 450гр творог	\N	\N	1739.00	шт	1	28	t	2025-12-07 13:19:40.855	2025-12-07 13:19:40.855	217.00	шт	8	поштучно
54023	3356	ВАРЕНИКИ Вари вареники 800гр картофель	\N	\N	2501.00	шт	1	196	t	2025-12-07 13:19:40.868	2025-12-07 13:19:40.868	250.00	шт	10	поштучно
54024	3356	ВАРЕНИКИ Вари вареники 800гр картофель грибы	\N	\N	1501.00	шт	1	300	t	2025-12-07 13:19:40.879	2025-12-07 13:19:40.879	300.00	шт	5	поштучно
54025	3356	ВАРЕНИКИ Вари вареники 800гр Картофель и сыр	\N	\N	2703.00	шт	1	300	t	2025-12-07 13:19:40.89	2025-12-07 13:19:40.89	270.00	шт	10	поштучно
54026	3356	ВАРЕНИКИ Вари вареники 800гр свежая капуста	\N	\N	3254.00	шт	1	300	t	2025-12-07 13:19:40.902	2025-12-07 13:19:40.902	325.00	шт	10	поштучно
54027	3356	ВАРЕНИКИ Морозко 350гр Домашние с картофелем	\N	\N	1725.00	шт	1	242	t	2025-12-07 13:19:40.913	2025-12-07 13:19:40.913	115.00	шт	15	поштучно
54028	3356	ВАРЕНИКИ Морозко 350гр Домашние с творогом	\N	\N	2432.00	шт	1	75	t	2025-12-07 13:19:40.927	2025-12-07 13:19:40.927	162.00	шт	15	поштучно
54029	3356	ВАРЕНИКИ Морозко 900гр Домашние с картофелем	\N	\N	2199.00	шт	1	43	t	2025-12-07 13:19:40.941	2025-12-07 13:19:40.941	275.00	шт	8	поштучно
54030	3356	БУУЗЫ Бурятские 825гр	\N	\N	8542.00	шт	1	28	t	2025-12-07 13:19:40.952	2025-12-07 13:19:40.952	712.00	шт	12	поштучно
54031	3356	МАНТЫ Южные 800гр ТМ 4 сочных порции	\N	\N	4260.00	шт	1	300	t	2025-12-07 13:19:40.967	2025-12-07 13:19:40.967	532.00	шт	8	поштучно
54032	3356	ПЕЛЬМЕНИ  4 сочных порции 800гр С говядиной и свининой	\N	\N	4950.00	шт	1	300	t	2025-12-07 13:19:40.978	2025-12-07 13:19:40.978	619.00	шт	8	поштучно
54033	3356	ПЕЛЬМЕНИ  4 сочных порции Комбо 2пак пельмени+2пак вареники 800гр	\N	\N	3220.00	шт	1	300	t	2025-12-07 13:19:40.988	2025-12-07 13:19:40.988	402.00	шт	8	поштучно
54034	3356	ПЕЛЬМЕНИ  Зареченские Домашние говядина и свинина 700гр	\N	\N	2012.00	шт	1	197	t	2025-12-07 13:19:41.009	2025-12-07 13:19:41.009	201.00	шт	10	поштучно
54035	3356	ПЕЛЬМЕНИ  Зареченские Домашние со сливочным маслом 700гр	\N	\N	2012.00	шт	1	190	t	2025-12-07 13:19:41.023	2025-12-07 13:19:41.023	201.00	шт	10	поштучно
54036	3356	ПЕЛЬМЕНИ  Стародворье Мясные с говядиной 1кг	\N	\N	1570.00	шт	1	300	t	2025-12-07 13:19:41.033	2025-12-07 13:19:41.033	314.00	шт	5	поштучно
54037	3356	ПЕЛЬМЕНИ  Стародворье Отборные Медвежье ушко говядина 430гр	\N	\N	2558.00	шт	1	96	t	2025-12-07 13:19:41.047	2025-12-07 13:19:41.047	160.00	шт	16	поштучно
54038	3356	ПЕЛЬМЕНИ  Стародворье Отборные Медвежье ушко говядина 900гр	\N	\N	2539.00	шт	1	46	t	2025-12-07 13:19:41.058	2025-12-07 13:19:41.058	317.00	шт	8	поштучно
54039	3356	ПЕЛЬМЕНИ  Стародворье Отборные Медвежье ушко свинина/говядина 430гр	\N	\N	2484.00	шт	1	84	t	2025-12-07 13:19:41.07	2025-12-07 13:19:41.07	155.00	шт	16	поштучно
54040	3356	ПЕЛЬМЕНИ Большая кастрюлька 800гр  Для самых главных (детские)	\N	\N	2639.00	шт	1	43	t	2025-12-07 13:19:41.083	2025-12-07 13:19:41.083	528.00	шт	5	поштучно
54041	3356	ПЕЛЬМЕНИ Большая кастрюля 400гр Классические с говядиной и свининой	\N	\N	3974.00	шт	1	300	t	2025-12-07 13:19:41.094	2025-12-07 13:19:41.094	331.00	шт	12	поштучно
54042	3356	ПЕЛЬМЕНИ Большая кастрюля 750гр Классические Фирменные с говядиной и свининой	\N	\N	4393.00	шт	1	254	t	2025-12-07 13:19:41.105	2025-12-07 13:19:41.105	439.00	шт	10	поштучно
54043	3356	ПЕЛЬМЕНИ Большая кастрюля 800гр Классические с говядиной и свининой	\N	\N	7190.00	шт	1	300	t	2025-12-07 13:19:41.117	2025-12-07 13:19:41.117	599.00	шт	12	поштучно
54044	3356	ПЕЛЬМЕНИ Большая кастрюля 800гр По-особому	\N	\N	7190.00	шт	1	300	t	2025-12-07 13:19:41.128	2025-12-07 13:19:41.128	599.00	шт	12	поштучно
54045	3356	ПЕЛЬМЕНИ Большая кастрюля 800гр Сливочные	\N	\N	7190.00	шт	1	300	t	2025-12-07 13:19:41.139	2025-12-07 13:19:41.139	599.00	шт	12	поштучно
54047	3356	ПЕЛЬМЕНИ Большая кастрюля MAX 800гр Классические с говядиной и свининой	\N	\N	5762.00	шт	1	300	t	2025-12-07 13:19:41.161	2025-12-07 13:19:41.161	576.00	шт	10	поштучно
54048	3356	ПЕЛЬМЕНИ Большая кастрюля Экспресс по-домашнему 200гр стакан ЗАЛЕЙ КИПЯТКОМ и ВАРИ 4 МИН В СВЧ	\N	\N	4637.00	шт	1	209	t	2025-12-07 13:19:41.171	2025-12-07 13:19:41.171	258.00	шт	18	поштучно
54049	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 400гр с говядиной и свининой  ТМ Горячая Штучка	\N	\N	2429.00	шт	1	300	t	2025-12-07 13:19:41.184	2025-12-07 13:19:41.184	152.00	шт	16	поштучно
54050	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 400гр с говядиной и свининой БИГБУЛИ ТМ Горячая Штучка	\N	\N	2650.00	шт	1	300	t	2025-12-07 13:19:41.195	2025-12-07 13:19:41.195	166.00	шт	16	поштучно
54051	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 400гр со сливочным маслом  ТМ Горячая Штучка	\N	\N	2447.00	шт	1	300	t	2025-12-07 13:19:41.206	2025-12-07 13:19:41.206	153.00	шт	16	поштучно
54431	3367	САЛАТ 150гр из Сельди "По-Корейски" "ХЕ"  пл/лоток ТМ Рыбный День	\N	\N	3703.00	шт	1	145	t	2025-12-07 13:19:47.773	2025-12-07 13:19:47.773	185.00	шт	20	поштучно
54432	3367	САЛАТ 180гр из Грибов "По-Корейски" пл/лоток ТМ Рыбный День	\N	\N	7383.00	шт	1	200	t	2025-12-07 13:19:47.785	2025-12-07 13:19:47.785	369.00	шт	20	поштучно
54433	3367	САЛАТ 180гр МК с кальмаром в майонезе пл/лоток ТМ Рыбный День	\N	\N	5014.00	шт	1	200	t	2025-12-07 13:19:47.797	2025-12-07 13:19:47.797	251.00	шт	20	поштучно
54434	3367	САЛАТ 180гр МК с мидией в майонезе пл/лоток ТМ Рыбный День	\N	\N	5037.00	шт	1	200	t	2025-12-07 13:19:47.813	2025-12-07 13:19:47.813	252.00	шт	20	поштучно
54435	3367	САЛАТ 180гр МК с овощами в майонезно-горчичном соусе пл/лоток ТМ Рыбный День	\N	\N	2599.00	шт	1	144	t	2025-12-07 13:19:47.823	2025-12-07 13:19:47.823	130.00	шт	20	поштучно
54436	3367	САЛАТ 180гр Солянка из Морской Капусты с грибами  пл/лоток ТМ Рыбный День	\N	\N	2944.00	шт	1	200	t	2025-12-07 13:19:47.833	2025-12-07 13:19:47.833	147.00	шт	20	поштучно
54437	3367	САЛАТ 180гр Солянка из Морской Капусты с кальмаром  пл/лоток ТМ Рыбный День	\N	\N	2967.00	шт	1	200	t	2025-12-07 13:19:47.847	2025-12-07 13:19:47.847	148.00	шт	20	поштучно
54438	3367	САЛАТ 180гр Солянка из Морской Капусты с папоротником пл/лоток ТМ Рыбный День	\N	\N	4255.00	шт	1	168	t	2025-12-07 13:19:47.869	2025-12-07 13:19:47.869	213.00	шт	20	поштучно
54439	3367	САЛАТ 500гр из Моркови "По-Корейски"  пл/лотокТМ Рыбный День	\N	\N	1884.00	шт	1	139	t	2025-12-07 13:19:47.925	2025-12-07 13:19:47.925	314.00	шт	6	поштучно
54440	3367	САЛАТ 500гр из Морской Капусты "по-Восточному" пл/конт ТМ Рыбный День	\N	\N	1677.00	шт	1	33	t	2025-12-07 13:19:47.937	2025-12-07 13:19:47.937	279.00	шт	6	поштучно
54441	3367	САЛАТ 500гр из Морской Капусты "Юбилейный" с кальмаром пл/конт ТМ Рыбный День	\N	\N	3429.00	шт	1	117	t	2025-12-07 13:19:47.948	2025-12-07 13:19:47.948	572.00	шт	6	поштучно
54442	3367	САЛАТ 500гр из Морской Капусты пл/конт ТМ Рыбный День	\N	\N	1649.00	шт	1	143	t	2025-12-07 13:19:47.959	2025-12-07 13:19:47.959	275.00	шт	6	поштучно
54443	3367	САЛАТ 500гр из Морской капусты с корейской морковью ТМ Рыбный День	\N	\N	1615.00	шт	1	23	t	2025-12-07 13:19:47.975	2025-12-07 13:19:47.975	269.00	шт	6	поштучно
54444	3367	САЛАТ 500гр из Морской Капусты с овощами в майонезно-горчичном соусе  пл/конт ТМ Рыбный День	\N	\N	1863.00	шт	1	9	t	2025-12-07 13:19:47.986	2025-12-07 13:19:47.986	311.00	шт	6	поштучно
54445	3367	САЛАТ 500гр из Папоротника "По-Корейски " пл/лоток ТМ Рыбный День	\N	\N	4464.00	шт	1	36	t	2025-12-07 13:19:47.996	2025-12-07 13:19:47.996	744.00	шт	6	поштучно
54446	3367	ИКРА МИНТАЯ Деликатесная 180гр (пл/банка) РПЗ ТАНДЕМ	\N	\N	8642.00	шт	1	300	t	2025-12-07 13:19:48.007	2025-12-07 13:19:48.007	192.00	шт	45	поштучно
54447	3367	ПАЛОЧКИ Рыбные 310гр для жарки (скин/уп) РПЗ ТАНДЕМ	\N	\N	12282.00	шт	1	25	t	2025-12-07 13:19:48.018	2025-12-07 13:19:48.018	307.00	шт	40	поштучно
54448	3367	ПЕЛЬМЕНИ Адмиральские рыбные с палтусом 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	4554.00	шт	1	6	t	2025-12-07 13:19:48.033	2025-12-07 13:19:48.033	304.00	шт	15	поштучно
54449	3367	ПЕЛЬМЕНИ Деликатесные рыбные с морской капустой 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	3312.00	шт	1	24	t	2025-12-07 13:19:48.045	2025-12-07 13:19:48.045	221.00	шт	15	поштучно
54450	3367	ПЕЛЬМЕНИ Особые рыбные горбуша минтай 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	4388.00	шт	1	36	t	2025-12-07 13:19:48.056	2025-12-07 13:19:48.056	244.00	шт	18	поштучно
54451	3367	ПЕЛЬМЕНИ По-капитански рыбные с трубачом 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	7072.00	шт	1	18	t	2025-12-07 13:19:48.068	2025-12-07 13:19:48.068	471.00	шт	15	поштучно
54452	3367	ПЕЛЬМЕНИ Премиум рыбные с кальмаром 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	4554.00	шт	1	27	t	2025-12-07 13:19:48.079	2025-12-07 13:19:48.079	304.00	шт	15	поштучно
54524	3395	КАРТОФЕЛЬ фри волнистый 2,5кг ТМ Ozgorkey Feast	\N	\N	6886.00	шт	1	200	t	2025-12-07 13:19:49.222	2025-12-07 13:19:49.222	1148.00	шт	6	поштучно
54052	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр с говядиной и свининой  ТМ Горячая Штучка	\N	\N	2565.00	шт	1	300	t	2025-12-07 13:19:41.218	2025-12-07 13:19:41.218	256.00	шт	10	поштучно
54053	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр с говядиной и свининой БИГБУЛИ ТМ Горячая Штучка	\N	\N	2714.00	шт	1	300	t	2025-12-07 13:19:41.309	2025-12-07 13:19:41.309	271.00	шт	10	поштучно
54054	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр с говядиной и свининой с оливковым маслом ТМ Горячая Штучка	\N	\N	3588.00	шт	1	257	t	2025-12-07 13:19:41.32	2025-12-07 13:19:41.32	359.00	шт	10	поштучно
54055	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр с сочной грудинкой Мегавкусище БИГБУЛИ ТМ Горячая Штучка	\N	\N	2852.00	шт	1	300	t	2025-12-07 13:19:41.369	2025-12-07 13:19:41.369	285.00	шт	10	поштучно
54056	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр со сливочным маслом  ТМ Горячая Штучка	\N	\N	2588.00	шт	1	300	t	2025-12-07 13:19:41.381	2025-12-07 13:19:41.381	259.00	шт	10	поштучно
54057	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр со сливочным маслом БИГБУЛИ ТМ Горячая Штучка	\N	\N	2645.00	шт	1	300	t	2025-12-07 13:19:41.392	2025-12-07 13:19:41.392	265.00	шт	10	поштучно
54058	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ НЕЙРОБУСТ 600гр с говядиной и свининой  ТМ Горячая Штучка	\N	\N	3312.00	шт	1	300	t	2025-12-07 13:19:41.405	2025-12-07 13:19:41.405	331.00	шт	10	поштучно
54059	3356	ПЕЛЬМЕНИ ГРАНДМЕНИ 700гр с говядиной и свининой ТМ Горячая Штучка	\N	\N	2806.00	шт	1	160	t	2025-12-07 13:19:41.417	2025-12-07 13:19:41.417	351.00	шт	8	поштучно
54060	3356	ПЕЛЬМЕНИ ГРАНДМЕНИ 700гр с говядиной ТМ Горячая Штучка ЦЕНА НИЖЕ - старая цена 437	\N	\N	2806.00	шт	1	181	t	2025-12-07 13:19:41.428	2025-12-07 13:19:41.428	351.00	шт	8	поштучно
54061	3356	ПЕЛЬМЕНИ ГРАНДМЕНИ 700гр со сливочным маслом ТМ Горячая Штучка	\N	\N	2640.00	шт	1	173	t	2025-12-07 13:19:41.44	2025-12-07 13:19:41.44	330.00	шт	8	поштучно
54062	3356	ПЕЛЬМЕНИ Малышок 500гр Особые	\N	\N	4002.00	шт	1	100	t	2025-12-07 13:19:41.455	2025-12-07 13:19:41.455	200.00	шт	20	поштучно
54063	3356	ПЕЛЬМЕНИ Растительные Foodgital 430гр ТМ Горячая Штучка	\N	\N	1886.00	шт	1	51	t	2025-12-07 13:19:41.466	2025-12-07 13:19:41.466	236.00	шт	8	поштучно
54064	3356	ПЕЛЬМЕНИ Цезарь 450гр Гордость Сибири	\N	\N	5106.00	шт	1	300	t	2025-12-07 13:19:41.477	2025-12-07 13:19:41.477	255.00	шт	20	поштучно
54065	3356	ПЕЛЬМЕНИ Цезарь 450гр Мясо бычков	\N	\N	3146.00	шт	1	161	t	2025-12-07 13:19:41.495	2025-12-07 13:19:41.495	262.00	шт	12	поштучно
54066	3356	ПЕЛЬМЕНИ Цезарь 450гр Царское застолье	\N	\N	5221.00	шт	1	184	t	2025-12-07 13:19:41.507	2025-12-07 13:19:41.507	261.00	шт	20	поштучно
54067	3356	ПЕЛЬМЕНИ Цезарь 600гр Классика	\N	\N	4934.00	шт	1	300	t	2025-12-07 13:19:41.517	2025-12-07 13:19:41.517	329.00	шт	15	поштучно
54068	3356	ПЕЛЬМЕНИ Цезарь 750гр Мясо бычков	\N	\N	5230.00	шт	1	300	t	2025-12-07 13:19:41.528	2025-12-07 13:19:41.528	436.00	шт	12	поштучно
54069	3356	ПЕЛЬМЕНИ Цезарь 750гр Царское застолье	\N	\N	3413.00	шт	1	216	t	2025-12-07 13:19:41.539	2025-12-07 13:19:41.539	427.00	шт	8	поштучно
54070	3356	ПЕЛЬМЕНИ Цезарь 800гр Гордость Сибири	\N	\N	5285.00	шт	1	300	t	2025-12-07 13:19:41.549	2025-12-07 13:19:41.549	440.00	шт	12	поштучно
54071	3356	ПЕЛЬМЕНИ Цезарь 800гр Император	\N	\N	6238.00	шт	1	300	t	2025-12-07 13:19:41.56	2025-12-07 13:19:41.56	520.00	шт	12	поштучно
54072	3356	ПЕЛЬМЕНИ Цезарь 800гр Иркутские	\N	\N	5410.00	шт	1	300	t	2025-12-07 13:19:41.571	2025-12-07 13:19:41.571	451.00	шт	12	поштучно
54073	3356	ПЕЛЬМЕНИ Цезарь 800гр Классика	\N	\N	5189.00	шт	1	300	t	2025-12-07 13:19:41.581	2025-12-07 13:19:41.581	432.00	шт	12	поштучно
54074	3356	ПЕЛЬМЕНИ Цезарь 800гр Куриные	\N	\N	2953.00	шт	1	300	t	2025-12-07 13:19:41.59	2025-12-07 13:19:41.59	369.00	шт	8	поштучно
54075	3356	ПЕЛЬМЕНИ Цезарь 800гр Семейные	\N	\N	5644.00	шт	1	269	t	2025-12-07 13:19:41.601	2025-12-07 13:19:41.601	470.00	шт	12	поштучно
54076	3356	ПЕЛЬМЕНИ Цезарь 800гр Фирменные мини	\N	\N	4913.00	шт	1	300	t	2025-12-07 13:19:41.611	2025-12-07 13:19:41.611	409.00	шт	12	поштучно
54077	3356	ПЕЛЬМЕНИ Цезарь 900гр Классические	\N	\N	3947.00	шт	1	300	t	2025-12-07 13:19:41.623	2025-12-07 13:19:41.623	493.00	шт	8	поштучно
54078	3356	ХИНКАЛИ Цезарь 800гр	\N	\N	6601.00	шт	1	128	t	2025-12-07 13:19:41.69	2025-12-07 13:19:41.69	660.00	шт	10	поштучно
54079	3391	КОТЛЕТЫ растительные 180гр ТМ Foodgital	\N	\N	1014.00	шт	1	29	t	2025-12-07 13:19:41.716	2025-12-07 13:19:41.716	169.00	шт	6	поштучно
54080	3391	ТЕСТО 1кг слоеное бездрожжевое (пласт) ТМ Морозко	\N	\N	3027.00	шт	1	300	t	2025-12-07 13:19:41.726	2025-12-07 13:19:41.726	378.00	шт	8	поштучно
54081	3391	ТЕСТО 1кг слоеное дрожжевое (пласт) ТМ Морозко	\N	\N	3027.00	шт	1	300	t	2025-12-07 13:19:41.737	2025-12-07 13:19:41.737	378.00	шт	8	поштучно
54082	3391	ТЕСТО 400гр слоеное бездрожжевое (пласт) ТМ Морозко	\N	\N	2836.00	шт	1	300	t	2025-12-07 13:19:41.751	2025-12-07 13:19:41.751	158.00	шт	18	поштучно
54083	3391	ТЕСТО 400гр слоеное дрожжевое (пласт) ТМ Морозко	\N	\N	2836.00	шт	1	300	t	2025-12-07 13:19:41.761	2025-12-07 13:19:41.761	158.00	шт	18	поштучно
54084	3397	САМСА с мясом из слоеного бездрожжевого теста 150гр замороженный п/ф ТМ Владхлеб	\N	\N	6670.00	уп (50 шт)	1	150	t	2025-12-07 13:19:41.772	2025-12-07 13:19:41.772	133.00	шт	50	только уп
54085	3397	СДОБА с брусникой из сдобного дрожжевого теста 115гр замороженный п/ф ТМ Владхлеб	\N	\N	5290.00	уп (50 шт)	1	200	t	2025-12-07 13:19:41.783	2025-12-07 13:19:41.783	106.00	шт	50	только уп
54086	3397	СДОБА с маком из сдобного дрожжевого теста 145гр замороженный п/ф ТМ Владхлеб	\N	\N	2156.00	уп (25 шт)	1	200	t	2025-12-07 13:19:41.793	2025-12-07 13:19:41.793	86.00	шт	25	только уп
54087	3397	СДОБА Сосиска в тесте из сдобного дрожжевого теста 110гр замороженный п/ф ТМ Владхлеб	\N	\N	3933.00	уп (30 шт)	1	180	t	2025-12-07 13:19:41.803	2025-12-07 13:19:41.803	131.00	шт	30	только уп
54520	3395	КАРТОФЕЛЬ Фри 450гр ТМ 4 Сезона	\N	\N	3887.00	шт	1	200	t	2025-12-07 13:19:49.161	2025-12-07 13:19:49.161	194.00	шт	20	поштучно
54088	3397	СЛОЙКА Азовская с Сосиской 95гр пф заморож сл дрож тесто ТМ"ВЛАДХЛЕБ"	\N	\N	5520.00	уп (50 шт)	1	200	t	2025-12-07 13:19:41.814	2025-12-07 13:19:41.814	110.00	шт	50	только уп
54089	3397	СЛОЙКА ветчина и сыр из слоеного дрожжевого теста 65гр замороженный п/ф Аппетитные вкусняшки ТМ Владхлеб	\N	\N	3852.00	уп (50 шт)	1	100	t	2025-12-07 13:19:41.826	2025-12-07 13:19:41.826	77.00	шт	50	только уп
54090	3397	СЛОЙКА с вишней из слоеного дрожжевого теста 100гр замороженный п/ф Аппетитные вкусняшки ТМ Владхлеб	\N	\N	3622.00	уп (50 шт)	1	200	t	2025-12-07 13:19:41.839	2025-12-07 13:19:41.839	72.00	шт	50	только уп
54091	3397	СЛОЙКА с курицей из слоеного дрожжевого теста 90гр замороженный п/ф Аппетитные вкусняшки ТМ Владхлеб	\N	\N	4600.00	уп (50 шт)	1	150	t	2025-12-07 13:19:41.853	2025-12-07 13:19:41.853	92.00	шт	50	только уп
54092	3397	ХАЧАПУРИ с сыром слоеного бездрожжевого теста 100гр замороженный п/ф ТМ Владхлеб	\N	\N	3076.00	уп (25 шт)	1	200	t	2025-12-07 13:19:41.865	2025-12-07 13:19:41.865	123.00	шт	25	только уп
54093	3323	ХЛЕБ Итальянский деревенский зерновой (чиабатта) 300гр замороженный п/ф высокой степени готовности ТМ Владхлеб	\N	\N	876.00	уп (6 шт)	1	200	t	2025-12-07 13:19:41.875	2025-12-07 13:19:41.875	146.00	шт	6	только уп
54094	3310	БАРАНИНА ДЛЯ ПЛОВА н/к с/м в/уп (1уп~1кг) Хакасская	\N	\N	11639.00	кг	1	36	t	2025-12-07 13:19:41.896	2025-12-07 13:19:41.896	968.00	кг	12	поштучно
54095	3310	ЯГНЯТИНА ГОЛЯШКА ЗАДНЯЯ н/к в/у (1уп~1,1кг) Хакасская	\N	\N	14205.00	кг	1	38	t	2025-12-07 13:19:41.92	2025-12-07 13:19:41.92	1052.00	кг	14	поштучно
54096	3310	ЯГНЯТИНА ЛОПАТКА н/к в/у  (1уп~1кг) Хакасская	\N	\N	33820.00	кг	1	103	t	2025-12-07 13:19:41.938	2025-12-07 13:19:41.938	2086.00	кг	16	поштучно
54097	3310	ЯГНЯТИНА ОКОРОК н/к стейками в/у (1уп~1кг) Хакасская	\N	\N	16637.00	кг	1	55	t	2025-12-07 13:19:41.969	2025-12-07 13:19:41.969	1441.00	кг	12	поштучно
54098	3310	ЯГНЯТИНА Ребрышки в/у (1уп ~ 1кг) Хакасская	\N	\N	12681.00	кг	1	119	t	2025-12-07 13:19:41.995	2025-12-07 13:19:41.995	1144.00	кг	11	поштучно
54099	3310	БЕДРО ИНДЕЙКА вес ТМ Индилайт	\N	\N	7998.00	уп (13 шт)	1	15	t	2025-12-07 13:19:42.006	2025-12-07 13:19:42.006	615.00	кг	13	только уп
54100	3310	ГОЛЕНЬ ИНДЕЙКА вес Агро-плюс	\N	\N	2661.00	уп (10 шт)	1	220	t	2025-12-07 13:19:42.025	2025-12-07 13:19:42.025	276.00	кг	10	только уп
54101	3310	ПЛЕЧЕВАЯ ЧАСТЬ КРЫЛА ИНДЕЙКА вес Казахстан	\N	\N	4437.00	уп (16 шт)	1	7	t	2025-12-07 13:19:42.052	2025-12-07 13:19:42.052	270.00	кг	16	только уп
54102	3310	ПЛЕЧЕВАЯ ЧАСТЬ КРЫЛА ИНДЕЙКА вес ТМ Индилайт	\N	\N	4170.00	уп (14 шт)	1	14	t	2025-12-07 13:19:42.063	2025-12-07 13:19:42.063	298.00	кг	14	только уп
54103	3310	ФИЛЕ ГРУДКИ ИНДЕЙКА вес Агро-плюс	\N	\N	5949.00	уп (10 шт)	1	20	t	2025-12-07 13:19:42.08	2025-12-07 13:19:42.08	610.00	кг	10	только уп
54104	3310	ФИЛЕ ГРУДКИ ИНДЕЙКА вес ТМ Индилайт	\N	\N	8708.00	уп (12 шт)	1	24	t	2025-12-07 13:19:42.092	2025-12-07 13:19:42.092	725.00	кг	12	только уп
54105	3310	ГОЛЕНЬ ИНДЕЙКА БЕСКОСТНАЯ подложка (1шт~750гр)ТМ Индилайт	\N	\N	4023.00	кг	1	300	t	2025-12-07 13:19:42.102	2025-12-07 13:19:42.102	676.00	кг	6	поштучно
54106	3310	ГОЛЕНЬ ИНДЕЙКА индивидуальная упаковка (1шт~500гр)ТМ Индилайт	\N	\N	2192.00	кг	1	5	t	2025-12-07 13:19:42.117	2025-12-07 13:19:42.117	362.00	кг	6	поштучно
54107	3310	ГОЛЕНЬ ИНДЕЙКА подложка (1шт~900гр)ТМ Индилайт	\N	\N	1811.00	кг	1	292	t	2025-12-07 13:19:42.129	2025-12-07 13:19:42.129	362.00	кг	5	поштучно
54108	3310	КРЫЛО ПЛЕЧЕВАЯ ЧАСТЬ ИНДЕЙКА подложка (1шт~800гр) ТМ Индилайт	\N	\N	2425.00	кг	1	177	t	2025-12-07 13:19:42.145	2025-12-07 13:19:42.145	328.00	кг	7	поштучно
54109	3310	КРЫЛО ЦЕЛОЕ ИНДЕЙКА резаное подложка (1шт~800гр) ТМ Индилайт	\N	\N	2257.00	кг	1	131	t	2025-12-07 13:19:42.16	2025-12-07 13:19:42.16	374.00	кг	6	поштучно
54110	3310	ПЕЧЕНЬ ИНДЕЙКА в/у (1шт~1кг) Казахстан	\N	\N	6788.00	кг	1	53	t	2025-12-07 13:19:42.171	2025-12-07 13:19:42.171	431.00	кг	16	поштучно
54111	3310	УТЕНОК Окорочок скин лоток (1шт~0,5кг) ВЕС ТМ Улыбино	\N	\N	4530.00	кг	1	115	t	2025-12-07 13:19:42.181	2025-12-07 13:19:42.181	788.00	кг	6	поштучно
54112	3310	УТЕНОК Тушка 1 сорт потрошен в/у (1шт~2кг) ТМ Озерка	\N	\N	3155.00	кг	1	300	t	2025-12-07 13:19:42.192	2025-12-07 13:19:42.192	401.00	кг	8	поштучно
54113	3310	УТЕНОК Тушка 1 сорт потрошен в/у пакет (1шт~1,2кг) ТМ Озерка	\N	\N	2351.00	кг	1	99	t	2025-12-07 13:19:42.202	2025-12-07 13:19:42.202	332.00	кг	7	поштучно
54114	3310	УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	6713.00	кг	1	111	t	2025-12-07 13:19:42.213	2025-12-07 13:19:42.213	1041.00	кг	6	поштучно
54115	3310	БЕДРО КУР на кости с кожей вес Межениновская ПФ	\N	\N	2978.00	уп (10 шт)	1	300	t	2025-12-07 13:19:42.225	2025-12-07 13:19:42.225	298.00	кг	10	только уп
54116	3310	БЕДРО КУР на кости с кожей вес ТМ Благояр	\N	\N	3312.00	уп (12 шт)	1	300	t	2025-12-07 13:19:42.238	2025-12-07 13:19:42.238	276.00	кг	12	только уп
54117	3310	ГОЛЕНЬ КУР вес Межениновскаф ПФ	\N	\N	3772.00	уп (10 шт)	1	215	t	2025-12-07 13:19:42.257	2025-12-07 13:19:42.257	377.00	кг	10	только уп
54118	3310	ГОЛЕНЬ КУР вес ТМ Благояр	\N	\N	3850.00	уп (12 шт)	1	300	t	2025-12-07 13:19:42.268	2025-12-07 13:19:42.268	321.00	кг	12	только уп
54119	3310	ГРУДКА КУР (цыплят-бройлеров) с кожей вес Межениновская ПФ	\N	\N	4428.00	уп (10 шт)	1	300	t	2025-12-07 13:19:42.348	2025-12-07 13:19:42.348	443.00	кг	10	только уп
54120	3310	КРЫЛО КУР (3 фаланги) укладка ёлочкой ГОСТ вес ТМ Домоседка	\N	\N	8165.00	уп (20 шт)	1	280	t	2025-12-07 13:19:42.403	2025-12-07 13:19:42.403	408.00	кг	20	только уп
54121	3310	КРЫЛО КУР (плечевая часть) вес	\N	\N	6469.00	уп (15 шт)	1	33	t	2025-12-07 13:19:42.429	2025-12-07 13:19:42.429	431.00	кг	15	только уп
54122	3310	КРЫЛО КУР вес Межениновская ПФ	\N	\N	4025.00	уп (10 шт)	1	300	t	2025-12-07 13:19:42.444	2025-12-07 13:19:42.444	402.00	кг	10	только уп
54123	3310	КРЫЛО КУР вес ТМ Благояр	\N	\N	4582.00	уп (12 шт)	1	300	t	2025-12-07 13:19:42.531	2025-12-07 13:19:42.531	382.00	кг	12	только уп
54124	3310	ОКОРОЧОК КУР Вес 15кг БРАЗИЛИЯ	\N	\N	4640.00	уп (15 шт)	1	300	t	2025-12-07 13:19:42.569	2025-12-07 13:19:42.569	309.00	кг	15	только уп
26347	2755	КЛУБНИКА вес  Египет	\N	\N	2800.00	уп (10 шт)	1	500	f	2025-11-10 01:56:29.743	2025-11-22 01:30:48.533	280.00	кг	10	\N
26356	2755	СМЕСЬ КОМПОТНАЯ ((абрикос,яблоко,слива) вес	\N	\N	2200.00	уп (10 шт)	1	500	f	2025-11-10 01:56:30.175	2025-11-22 01:30:48.533	220.00	кг	10	\N
54125	3310	ОКОРОЧОК КУР вес для жарки Халяль ТМ Благояр	\N	\N	3767.00	уп (13 шт)	1	300	t	2025-12-07 13:19:42.587	2025-12-07 13:19:42.587	290.00	кг	13	только уп
54126	3310	ОКОРОЧОК КУР Деликатесный сухой заморозки вес В/Уп ТМ Домоседка КРАСНЫЙ СКОТЧ	\N	\N	307.00	кг	1	36	t	2025-12-07 13:19:42.61	2025-12-07 13:19:42.61	307.00	кг	\N	только уп
54127	3310	ФИЛЕ БЕДРА КУР бескостное без кожи вес ТД ДОМОСЕДКА	\N	\N	9488.00	уп (15 шт)	1	120	t	2025-12-07 13:19:42.621	2025-12-07 13:19:42.621	633.00	кг	15	только уп
54128	3310	ФИЛЕ ГРУДКИ КУР без кости без кожи вес Межениновская ПФ	\N	\N	5624.00	уп (10 шт)	1	300	t	2025-12-07 13:19:42.631	2025-12-07 13:19:42.631	562.00	кг	10	только уп
54129	3310	ФИЛЕ ГРУДКИ КУР без кости без кожи вес ТМ Благояр	\N	\N	8849.00	уп (15 шт)	1	300	t	2025-12-07 13:19:42.644	2025-12-07 13:19:42.644	590.00	кг	15	только уп
54130	3310	БЕДРО КУР на кости с кожей  подложка (1шт-1кг)  МЕЖЕНИНОВСКАЯ ПФ	\N	\N	2990.00	шт	1	300	t	2025-12-07 13:19:42.664	2025-12-07 13:19:42.664	299.00	шт	10	поштучно
54131	3310	ГОЛЕНЬ КУР подложка (1шт~900гр) ТМ КУРИНОЕ ЦАРСТВО	\N	\N	3130.00	уп (8 шт)	1	8	t	2025-12-07 13:19:42.675	2025-12-07 13:19:42.675	384.00	кг	8	только уп
54132	3310	ГОЛЕНЬ КУР подложка (1шт~950гр) ТМ БЛАГОЯР	\N	\N	2913.00	уп (8 шт)	1	300	t	2025-12-07 13:19:42.692	2025-12-07 13:19:42.692	367.00	кг	8	только уп
54133	3310	ГОЛЕНЬ КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	3806.00	шт	1	300	t	2025-12-07 13:19:42.708	2025-12-07 13:19:42.708	381.00	шт	10	поштучно
54134	3310	ГРУДКА КУР с кожей подложка (1шт~950гр)  МЕЖЕНИНОВСКАЯ ПФ	\N	\N	4543.00	шт	1	23	t	2025-12-07 13:19:42.719	2025-12-07 13:19:42.719	454.00	шт	10	поштучно
54135	3310	ЖЕЛУДКИ КУР подложка (1шт~900гр) ТМ БЛАГОЯР	\N	\N	2060.00	уп (9 шт)	1	300	t	2025-12-07 13:19:42.729	2025-12-07 13:19:42.729	229.00	кг	9	только уп
54136	3310	ЖЕЛУДКИ КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	3059.00	шт	1	300	t	2025-12-07 13:19:42.74	2025-12-07 13:19:42.74	306.00	шт	10	поштучно
54137	3310	КРЫЛО КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	4198.00	шт	1	300	t	2025-12-07 13:19:42.75	2025-12-07 13:19:42.75	420.00	шт	10	поштучно
54138	3310	ОКОРОЧОК КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	3335.00	шт	1	300	t	2025-12-07 13:19:42.76	2025-12-07 13:19:42.76	334.00	шт	10	поштучно
54139	3310	ПЕЧЕНЬ КУР подложка (1шт~900гр) ТМ БЛАГОЯР	\N	\N	3043.00	уп (9 шт)	1	300	t	2025-12-07 13:19:42.772	2025-12-07 13:19:42.772	338.00	кг	9	только уп
54140	3310	ПЕЧЕНЬ КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	3369.00	шт	1	249	t	2025-12-07 13:19:42.783	2025-12-07 13:19:42.783	337.00	шт	10	поштучно
54141	3310	СЕРДЦЕ КУР подложка (1шт~900гр) ТМ БЛАГОЯР	\N	\N	4875.00	уп (9 шт)	1	300	t	2025-12-07 13:19:42.793	2025-12-07 13:19:42.793	542.00	кг	9	только уп
54142	3310	ФИЛЕ БЕДРА КУР без кости без кожи (1шт~900гр) ТМ БЛАГОЯР	\N	\N	5168.00	уп (8 шт)	1	300	t	2025-12-07 13:19:42.803	2025-12-07 13:19:42.803	633.00	кг	8	только уп
54143	3310	ФИЛЕ ГРУДКИ КУР без кожи без кости подложка (1шт~900гр) ТМ БЛАГОЯР Халяль	\N	\N	5354.00	уп (8 шт)	1	300	t	2025-12-07 13:19:42.814	2025-12-07 13:19:42.814	669.00	кг	8	только уп
54144	3310	ФИЛЕ ГРУДКИ КУР без кожи без кости подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	5716.00	шт	1	300	t	2025-12-07 13:19:42.825	2025-12-07 13:19:42.825	572.00	шт	10	поштучно
54145	3310	ФИЛЕ ОКОРОЧКА КУР без кожи без кости лоток ТМ ДОМОСЕДКА	\N	\N	5578.00	уп (10 шт)	1	27	t	2025-12-07 13:19:42.835	2025-12-07 13:19:42.835	558.00	кг	10	только уп
54146	3310	ЦЫПЛЕНОК-БРОЙЛЕР "Межениновская ПФ"	\N	\N	3567.00	уп (12 шт)	1	1000	t	2025-12-07 13:19:42.845	2025-12-07 13:19:42.845	297.00	кг	12	только уп
54147	3310	ЦЫПЛЕНОК-БРОЙЛЕР Благояр ~2кг (калиброванная тушка) с/м*	\N	\N	4449.00	уп (13 шт)	1	1000	t	2025-12-07 13:19:42.86	2025-12-07 13:19:42.86	330.00	кг	13	только уп
54148	3310	ЦЫПЛЕНОК-БРОЙЛЕР Благояр 1,8кг (калиброванная тушка) с/м*	\N	\N	5394.00	уп (16 шт)	1	1000	t	2025-12-07 13:19:42.871	2025-12-07 13:19:42.871	347.00	кг	16	только уп
54149	3310	ЦЫПЛЕНОК-БРОЙЛЕР Дружба Халяль 1 сорт (1шт~1,9кг) с/м БЕЛАРУСЬ	\N	\N	4556.00	уп (14 шт)	1	28	t	2025-12-07 13:19:42.882	2025-12-07 13:19:42.882	321.00	кг	14	только уп
54150	3310	ЦЫПЛЕНОК-КОРНИШОН жёлтый кукурузного откорма 500гр с/м Воронеж ЦЕНА ЗА ШТ	\N	\N	9775.00	шт	1	207	t	2025-12-07 13:19:42.894	2025-12-07 13:19:42.894	489.00	шт	20	поштучно
54151	3310	ЦЫПЛЕНОК-КОРНИШОН СУДАНСКИЙ БРОЙЛЕР (1шт-350-400гр) ЦЕНА ЗА ШТ	\N	\N	5750.00	шт	1	6	t	2025-12-07 13:19:42.904	2025-12-07 13:19:42.904	288.00	шт	20	поштучно
54152	3310	ЦЫПЛЕНОК-КОРНИШОН Ярославль белый 700гр ЦЕНА ЗА ШТ	\N	\N	7825.00	шт	1	177	t	2025-12-07 13:19:42.914	2025-12-07 13:19:42.914	435.00	шт	18	поштучно
54153	3310	ГОВЯДИНА ГЛАЗНОЙ МУСКУЛ (Полусухожильная мышца бедра)  с/м без кости Беларусь	\N	\N	32687.00	уп (27 шт)	1	300	t	2025-12-07 13:19:42.924	2025-12-07 13:19:42.924	1208.00	кг	27	только уп
54154	3310	ГОВЯДИНА ЛОПАТКА без кости вес с/м Алтай	\N	\N	18490.00	уп (19 шт)	1	300	t	2025-12-07 13:19:42.934	2025-12-07 13:19:42.934	975.00	кг	19	только уп
54155	3310	ГОВЯДИНА ЛОПАТКА без кости вес с/м Р/ву Алтай КРАСНЫЙ СКОТЧ	\N	\N	18817.00	уп (19 шт)	1	20	t	2025-12-07 13:19:42.944	2025-12-07 13:19:42.944	992.00	кг	19	только уп
54156	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Алтай	\N	\N	17508.00	уп (18 шт)	1	300	t	2025-12-07 13:19:42.957	2025-12-07 13:19:42.957	997.00	кг	18	только уп
54157	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Р Алтай ЖЕЛТЫЙ СКОТЧ	\N	\N	17508.00	уп (18 шт)	1	17	t	2025-12-07 13:19:42.975	2025-12-07 13:19:42.975	997.00	кг	18	только уп
54158	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Р Солти ЖЕЛТЫЙ СКОТЧ	\N	\N	22414.00	уп (22 шт)	1	55	t	2025-12-07 13:19:42.986	2025-12-07 13:19:42.986	997.00	кг	22	только уп
54159	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Р ТимашевскМясоПродукт	\N	\N	17595.00	уп (20 шт)	1	157	t	2025-12-07 13:19:42.996	2025-12-07 13:19:42.996	880.00	кг	20	только уп
54160	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Р/ву Алтай КРАСНЫЙ СКОТЧ	\N	\N	17811.00	уп (18 шт)	1	71	t	2025-12-07 13:19:43.007	2025-12-07 13:19:43.007	1014.00	кг	18	только уп
54161	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Солти	\N	\N	22414.00	уп (22 шт)	1	300	t	2025-12-07 13:19:43.019	2025-12-07 13:19:43.019	997.00	кг	22	только уп
54162	3310	ГОВЯДИНА ОКОРОК БЕЗ ГОЛЯШКИ ГОСТ 31797-2012 (тазобедреный отруб)  вес с/м б/к б/г ТимашевскМясоПродукт №2	\N	\N	17643.00	уп (20 шт)	1	300	t	2025-12-07 13:19:43.043	2025-12-07 13:19:43.043	880.00	кг	20	только уп
54163	3310	ГОВЯДИНА ПЕЧЕНЬ вес с/м 1/16-19кг Аргентина	\N	\N	7643.00	уп (16 шт)	1	300	t	2025-12-07 13:19:43.058	2025-12-07 13:19:43.058	470.00	кг	16	только уп
54164	3310	ГОВЯДИНА Печень вес с/м Бразилия	\N	\N	470.00	уп (1 шт)	1	300	t	2025-12-07 13:19:43.088	2025-12-07 13:19:43.088	470.00	кг	1	только уп
54165	3310	ГОВЯДИНА ПЕЧЕНЬ вес с/м Р/ву 1/16-19кг Аргентина	\N	\N	7923.00	уп (16 шт)	1	5	t	2025-12-07 13:19:43.1	2025-12-07 13:19:43.1	488.00	кг	16	только уп
54166	3310	ГОВЯДИНА СЕРДЦЕ вес с/м 1/10-12кг Беларусь	\N	\N	6540.00	уп (11 шт)	1	300	t	2025-12-07 13:19:43.115	2025-12-07 13:19:43.115	569.00	кг	11	только уп
54167	3310	ГОВЯДИНА СЕРДЦЕ вес с/м 1/20-25кг Уругвай	\N	\N	13949.00	уп (25 шт)	1	300	t	2025-12-07 13:19:43.13	2025-12-07 13:19:43.13	569.00	кг	25	только уп
54168	3310	ГОВЯДИНА СЕРДЦЕ вес с/м Р 1/20-25кг Уругвай ЖЕЛТЫЙ СКОТЧ	\N	\N	13949.00	уп (25 шт)	1	109	t	2025-12-07 13:19:43.144	2025-12-07 13:19:43.144	569.00	кг	25	только уп
54169	3310	ГОВЯДИНА СЕРДЦЕ вес с/м Р/ву 1/20-25кг Уругвай КРАСНЫЙ СКОТЧ	\N	\N	14372.00	уп (25 шт)	1	108	t	2025-12-07 13:19:43.158	2025-12-07 13:19:43.158	587.00	кг	25	только уп
54170	3310	ГОВЯДИНА СЕРДЦЕ вес с/м разилия	\N	\N	524.00	уп (1 шт)	1	15	t	2025-12-07 13:19:43.169	2025-12-07 13:19:43.169	524.00	кг	1	только уп
54171	3310	ГОВЯДИНА Шейно-лопаточный отруб без голяшки без кости с/м Алтай	\N	\N	17252.00	уп (19 шт)	1	300	t	2025-12-07 13:19:43.179	2025-12-07 13:19:43.179	903.00	кг	19	только уп
54172	3310	ГОВЯДИНА Шейно-лопаточный отруб без голяшки без кости с/м Солти	\N	\N	21016.00	уп (23 шт)	1	300	t	2025-12-07 13:19:43.19	2025-12-07 13:19:43.19	903.00	кг	23	только уп
54173	3310	ГОВЯДИНА шея  б/к  Алтай	\N	\N	880.00	кг	1	81	t	2025-12-07 13:19:43.2	2025-12-07 13:19:43.2	880.00	кг	\N	только уп
54174	3310	ГОВЯДИНА ШЕЯ (Шейный отруб) без кости с/м Алтай	\N	\N	16944.00	уп (19 шт)	1	300	t	2025-12-07 13:19:43.211	2025-12-07 13:19:43.211	880.00	кг	19	только уп
54175	3310	ГОВЯДИНА ЩЕКИ вес с/м 1/24-25кг Уругвай	\N	\N	17468.00	уп (25 шт)	1	262	t	2025-12-07 13:19:43.221	2025-12-07 13:19:43.221	704.00	кг	25	только уп
54176	3310	ГОВЯДИНА ЯЗЫК вес с/м 1/12-17кг Бразилия	\N	\N	1030.00	уп (1 шт)	1	25	t	2025-12-07 13:19:43.248	2025-12-07 13:19:43.248	1030.00	кг	1	только уп
54177	3310	ГОВЯДИНА КОТЛЕТНОЕ МЯСО триминг 70/30 б/к с/м ВЕС ТМ Праймбиф	\N	\N	21992.00	уп (20 шт)	1	300	t	2025-12-07 13:19:43.326	2025-12-07 13:19:43.326	1093.00	кг	20	только уп
54178	3310	ГОВЯДИНА МРАМОРНАЯ ВЫРЕЗКА "Экстра" б/к Чойс (1кусок~2кг) ВЕС ТМ Праймбиф	\N	\N	101775.00	кг	1	108	t	2025-12-07 13:19:43.364	2025-12-07 13:19:43.364	6785.00	кг	15	поштучно
54179	3310	ГОВЯДИНА мраморная ОТРУБ спинной Рибай Топ Чойс (1кусок~5кг) ВЕС ТМ Праймбиф	\N	\N	103258.00	кг	1	87	t	2025-12-07 13:19:43.375	2025-12-07 13:19:43.375	6296.00	кг	16	поштучно
54180	3310	СВИНИНА ВЫРЕЗКА без кости в/уп (1шт~2,5кг) ТМ Агроэко	\N	\N	12978.00	уп (21 шт)	1	300	t	2025-12-07 13:19:43.405	2025-12-07 13:19:43.405	633.00	кг	21	только уп
54181	3310	СВИНИНА ВЫРЕЗКА на кости в/уп (1шт~4,5кг) ТМ Агроэко	\N	\N	8344.00	уп (17 шт)	1	300	t	2025-12-07 13:19:43.426	2025-12-07 13:19:43.426	480.00	кг	17	только уп
54182	3310	СВИНИНА ВЫРЕЗКА с/м без кости  НПЗ Нейма	\N	\N	11514.00	уп (19 шт)	1	300	t	2025-12-07 13:19:43.437	2025-12-07 13:19:43.437	612.00	кг	19	только уп
54183	3310	СВИНИНА ГРУДИНКА без кости в/уп (1шт~3,5кг) ТМ Агроэко	\N	\N	6609.00	уп (16 шт)	1	300	t	2025-12-07 13:19:43.449	2025-12-07 13:19:43.449	415.00	кг	16	только уп
54184	3310	СВИНИНА ГРУДИНКА с/м без кости вес Р ТМ Агроэко ЖЕЛТЫЙ СКОТЧ	\N	\N	6483.00	уп (17 шт)	1	28	t	2025-12-07 13:19:43.46	2025-12-07 13:19:43.46	391.00	кг	17	только уп
54185	3310	СВИНИНА ГРУДИНКА с/м без кости вес ТМ Агроэко	\N	\N	6483.00	уп (17 шт)	1	179	t	2025-12-07 13:19:43.471	2025-12-07 13:19:43.471	391.00	кг	17	только уп
54186	3310	СВИНИНА ГУДИНКА с/м без кости на шкуре НПЗ Нейма	\N	\N	7549.00	уп (15 шт)	1	300	t	2025-12-07 13:19:43.482	2025-12-07 13:19:43.482	518.00	кг	15	только уп
54187	3310	СВИНИНА ГУДИНКА с/м без кости на шкуре Р НПЗ Нейма ЖЕЛТЫЙ СКОТЧ	\N	\N	7549.00	уп (15 шт)	1	16	t	2025-12-07 13:19:43.495	2025-12-07 13:19:43.495	518.00	кг	15	только уп
54188	3310	СВИНИНА КАРБОНАД без кости вес (1кусок~1кг) с/м ТМ Полянское	\N	\N	9143.00	уп (18 шт)	1	12	t	2025-12-07 13:19:43.506	2025-12-07 13:19:43.506	505.00	кг	18	только уп
54189	3310	СВИНИНА КАРБОНАД без кости вес ТМ Агроэко	\N	\N	5584.00	уп (11 шт)	1	169	t	2025-12-07 13:19:43.518	2025-12-07 13:19:43.518	518.00	кг	11	только уп
54190	3310	СВИНИНА ЛОПАТКА без кости без голяшки вес с/м ТМ Полянское	\N	\N	7543.00	уп (16 шт)	1	300	t	2025-12-07 13:19:43.529	2025-12-07 13:19:43.529	480.00	кг	16	только уп
54191	3310	СВИНИНА ЛОПАТКА с/м б/к вес ТМ Агроэко	\N	\N	9553.00	уп (20 шт)	1	300	t	2025-12-07 13:19:43.541	2025-12-07 13:19:43.541	480.00	кг	20	только уп
54192	3310	СВИНИНА ЛОПАТКА с/м без кости 1/18-19кг МПЗ Нейма	\N	\N	9015.00	уп (19 шт)	1	300	t	2025-12-07 13:19:43.557	2025-12-07 13:19:43.557	484.00	кг	19	только уп
54193	3310	СВИНИНА НОГИ задние вес с/м ТК Викинг	\N	\N	1879.00	уп (16 шт)	1	300	t	2025-12-07 13:19:43.568	2025-12-07 13:19:43.568	121.00	кг	16	только уп
54194	3310	СВИНИНА НОГИ передние вес с/м ТМ Коралл	\N	\N	2875.00	уп (20 шт)	1	300	t	2025-12-07 13:19:43.579	2025-12-07 13:19:43.579	144.00	кг	20	только уп
54195	3310	СВИНИНА ОКОРОК с/м б/к без голяшки вес ТимашевскМясоПродукт	\N	\N	9515.00	уп (20 шт)	1	300	t	2025-12-07 13:19:43.593	2025-12-07 13:19:43.593	466.00	кг	20	только уп
54196	3310	СВИНИНА ОКОРОК с/м б/к без голяшки вес ТМ Полянское	\N	\N	7297.00	уп (15 шт)	1	94	t	2025-12-07 13:19:43.603	2025-12-07 13:19:43.603	486.00	кг	15	только уп
54197	3310	СВИНИНА ОКОРОК с/м б/к вес Р/ву ТМ Агроэко КРАСНЫЙ СКОТЧ	\N	\N	10452.00	уп (21 шт)	1	43	t	2025-12-07 13:19:43.627	2025-12-07 13:19:43.627	504.00	кг	21	только уп
54198	3310	СВИНИНА ОКОРОК с/м б/к вес ТМ Агроэко	\N	\N	10094.00	уп (21 шт)	1	300	t	2025-12-07 13:19:43.696	2025-12-07 13:19:43.696	486.00	кг	21	только уп
54199	3310	СВИНИНА ОКОРОК с/м б/к МПЗ Нейма	\N	\N	8326.00	уп (17 шт)	1	300	t	2025-12-07 13:19:43.717	2025-12-07 13:19:43.717	497.00	кг	17	только уп
54200	3310	СВИНИНА ПЕЧЕНЬ вес с/м  ТМ Полянское	\N	\N	3502.00	уп (20 шт)	1	118	t	2025-12-07 13:19:43.728	2025-12-07 13:19:43.728	173.00	кг	20	только уп
54201	3310	СВИНИНА РЁБРА Деликатесные с/м МПЗ Нейма	\N	\N	6410.00	уп (12 шт)	1	300	t	2025-12-07 13:19:43.741	2025-12-07 13:19:43.741	530.00	кг	12	только уп
54202	3310	СВИНИНА РЁБРА для копчения треугольник вес (50% мяса) с/м ТМ Полянское	\N	\N	4756.00	уп (18 шт)	1	143	t	2025-12-07 13:19:43.755	2025-12-07 13:19:43.755	270.00	кг	18	только уп
54203	3310	СВИНИНА РЁБРА лента ПРЕМИУМ (50% мяса) вес с/м ТМ Полянское	\N	\N	9201.00	уп (18 шт)	1	29	t	2025-12-07 13:19:43.789	2025-12-07 13:19:43.789	501.00	кг	18	только уп
54204	3310	СВИНИНА ТРИММИНГ 80/20  с/м б/к 1/21-23кг ТК Викинг	\N	\N	10173.00	уп (19 шт)	1	300	t	2025-12-07 13:19:43.802	2025-12-07 13:19:43.802	547.00	кг	19	только уп
54205	3310	СВИНИНА ШЕЯ (шейный отруб) без кости вес (1кусок~1кг) с/м Р/ву ТМ Полянское	\N	\N	9971.00	уп (15 шт)	1	15	t	2025-12-07 13:19:43.813	2025-12-07 13:19:43.813	665.00	кг	15	только уп
54206	3310	СВИНИНА ШЕЯ с/м б/к вес (1кусок~1-2,5кг) ТМ Полянское	\N	\N	9712.00	уп (15 шт)	1	300	t	2025-12-07 13:19:43.823	2025-12-07 13:19:43.823	647.00	кг	15	только уп
54207	3310	БАРАНИНА ОКОРОК СТЕЙКАМИ  н/к в классическом маринаде с/м в/уп  (1уп~1кг) Хакасская	\N	\N	25003.00	кг	1	35	t	2025-12-07 13:19:43.834	2025-12-07 13:19:43.834	1586.00	кг	16	поштучно
54208	3310	БАРАНИНА ОКОРОК СТЕЙКАМИ  н/к в соусе по-грузински с/м в/уп (1уп~1кг) Хакасская	\N	\N	24118.00	кг	1	16	t	2025-12-07 13:19:43.845	2025-12-07 13:19:43.845	1586.00	кг	15	поштучно
54209	3310	БАРАНИНА ШЕЙКА кольцами в пряном соусе с/м в/уп  (1уп~1кг) Хакасская	\N	\N	1144.00	кг	1	16	t	2025-12-07 13:19:43.855	2025-12-07 13:19:43.855	1144.00	кг	1	поштучно
54210	3310	УТЕНОК Полутушка пряные травы маринад пакет (1шт~1кг) 1/3-4кг ТМ Улыбино	\N	\N	1725.00	кг	1	38	t	2025-12-07 13:19:43.888	2025-12-07 13:19:43.888	431.00	кг	4	поштучно
54211	3310	ЯГНЯТИНА РЕБРЫШКИ в соусе по-грузински с/м в/уп  (1уп~1кг) Хакасская	\N	\N	16041.00	кг	1	17	t	2025-12-07 13:19:43.899	2025-12-07 13:19:43.899	1372.00	кг	12	поштучно
54212	3310	ЯГНЯТИНА РЕБРЫШКИ в соусе ткемали с/м в/уп  (1уп~1кг) Хакасская	\N	\N	1372.00	кг	1	35	t	2025-12-07 13:19:43.912	2025-12-07 13:19:43.912	1372.00	кг	1	поштучно
54213	3396	САРДЕЛЬКИ 600гр Мусульманские ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2674.00	уп (15 шт)	1	100	t	2025-12-07 13:19:43.922	2025-12-07 13:19:43.922	178.00	шт	15	только уп
54214	3396	САРДЕЛЬКИ Вес 10кг Аппетитные полиамид замороженные Обнинский МПК	\N	\N	2668.00	уп (10 шт)	1	100	t	2025-12-07 13:19:43.933	2025-12-07 13:19:43.933	267.00	кг	10	только уп
54215	3396	САРДЕЛЬКИ Вес 10кг Мусульманские ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2588.00	уп (10 шт)	1	100	t	2025-12-07 13:19:43.943	2025-12-07 13:19:43.943	259.00	кг	10	только уп
54216	3396	САРДЕЛЬКИ Вес 5кг Чернышевские Гриль замороженные Обнинский МПК	\N	\N	1541.00	уп (5 шт)	1	65	t	2025-12-07 13:19:43.954	2025-12-07 13:19:43.954	308.00	кг	5	только уп
54217	3396	СОСИСКИ 400гр Мусульманские с бараниной ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2953.00	уп (24 шт)	1	100	t	2025-12-07 13:19:43.965	2025-12-07 13:19:43.965	123.00	шт	24	только уп
54218	3396	СОСИСКИ 400гр Мусульманские с говядиной ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2953.00	уп (24 шт)	1	100	t	2025-12-07 13:19:43.976	2025-12-07 13:19:43.976	123.00	шт	24	только уп
54219	3396	СОСИСКИ 400гр Подкопченые ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2953.00	уп (24 шт)	1	100	t	2025-12-07 13:19:43.996	2025-12-07 13:19:43.996	123.00	шт	24	только уп
54220	3396	СОСИСКИ 480гр Мусульманские полиамид замороженные Обнинский МПК	\N	\N	3367.00	уп (24 шт)	1	100	t	2025-12-07 13:19:44.006	2025-12-07 13:19:44.006	140.00	шт	24	только уп
54221	3396	СОСИСКИ 500гр Молочные полиамид замороженные Обнинский МПК	\N	\N	1323.00	уп (10 шт)	1	100	t	2025-12-07 13:19:44.019	2025-12-07 13:19:44.019	132.00	шт	10	только уп
54222	3396	СОСИСКИ Вес 10кг Дачные 13см замороженные Обнинский МПК	\N	\N	2484.00	уп (10 шт)	1	100	t	2025-12-07 13:19:44.034	2025-12-07 13:19:44.034	248.00	кг	10	только уп
54223	3396	СОСИСКИ Вес 10кг Молочные замороженные Обнинский МПК	\N	\N	2530.00	уп (10 шт)	1	100	t	2025-12-07 13:19:44.044	2025-12-07 13:19:44.044	253.00	кг	10	только уп
54224	3396	СОСИСКИ Вес 10кг Мусульманские ХАЛЯЛЬ замороженные Обнинский МПК	\N	\N	2530.00	уп (10 шт)	1	100	t	2025-12-07 13:19:44.056	2025-12-07 13:19:44.056	253.00	кг	10	только уп
54225	3396	СОСИСКИ д/хот-догов с Говядиной Халяль 600гр ТМ Рамай Обнинский МПК	\N	\N	2502.00	уп (8 шт)	1	100	t	2025-12-07 13:19:44.08	2025-12-07 13:19:44.08	313.00	шт	8	только уп
54226	3396	СОСИСКИ д/хот-догов Филейные Халяль 600гр 1/8шт ТМ Рамай Обнинский МПК	\N	\N	2502.00	уп (8 шт)	1	100	t	2025-12-07 13:19:44.091	2025-12-07 13:19:44.091	313.00	шт	8	только уп
54227	3396	ШПИКАЧКИ Вес 5кг Чернышевские с сыром замороженные Обнинский МПК	\N	\N	1935.00	уп (5 шт)	1	100	t	2025-12-07 13:19:44.103	2025-12-07 13:19:44.103	387.00	кг	5	только уп
54228	3310	КОЛБАСКИ д/жарки Баварские Халяль 600гр 1/10шт ТМ Рамай Обнинский МПК	\N	\N	5382.00	шт	1	100	t	2025-12-07 13:19:44.115	2025-12-07 13:19:44.115	538.00	шт	10	поштучно
54229	3310	КОЛБАСКИ д/жарки Гриль говяжьи Халяль 600гр 1/10шт ТМ Рамай Обнинский МПК	\N	\N	5877.00	шт	1	100	t	2025-12-07 13:19:44.126	2025-12-07 13:19:44.126	588.00	шт	10	поштучно
54230	3310	КОЛБАСКИ д/жарки Гриль с бараниной Халяль 600гр 1/10шт ТМ Рамай Обнинский МПК	\N	\N	5877.00	шт	1	100	t	2025-12-07 13:19:44.136	2025-12-07 13:19:44.136	588.00	шт	10	поштучно
54231	3310	КОЛБАСКИ д/жарки Гриль с курицей Халяль 600гр 1/10шт ТМ Рамай Обнинский МПК	\N	\N	5382.00	шт	1	100	t	2025-12-07 13:19:44.146	2025-12-07 13:19:44.146	538.00	шт	10	поштучно
54232	3310	ШАШЛЫК БАРАНИЙ н/к в классическом маринаде (1уп~1кг) Хакасская	\N	\N	12079.00	кг	1	24	t	2025-12-07 13:19:44.157	2025-12-07 13:19:44.157	1144.00	кг	11	поштучно
54233	3310	ШАШЛЫК БАРАНИЙ н/к в пикантном соусе (1уп~1кг) Хакасская	\N	\N	14168.00	кг	1	11	t	2025-12-07 13:19:44.179	2025-12-07 13:19:44.179	1144.00	кг	12	поштучно
54234	3310	ШАШЛЫК БАРАНИЙ н/к в пряном соусе (1уп~1кг) Хакасская	\N	\N	11443.00	кг	1	26	t	2025-12-07 13:19:44.19	2025-12-07 13:19:44.19	1144.00	кг	10	поштучно
54235	3310	ЯЙЦО пищевое С1  ПФ Бердская ТОЛЬКО МЕСТАМИ *	\N	\N	4347.00	уп (360 шт)	1	500	t	2025-12-07 13:19:44.207	2025-12-07 13:19:44.207	12.00	шт	360	только уп
54236	3367	*УГОЛЬНАЯ рыба  (аналог палтуса) мороженая потрошенная без головы 1/18кг СРТМ Антей	\N	\N	23495.00	уп (18 шт)	1	720	t	2025-12-07 13:19:44.217	2025-12-07 13:19:44.217	1305.00	кг	18	только уп
54237	3367	*ФАРШ МИНТАЯ мороженый 1кг коробка ООО Русский минтай ЦЕНА ЗА ШТУКУ	\N	\N	5506.00	шт	1	702	t	2025-12-07 13:19:44.229	2025-12-07 13:19:44.229	262.00	шт	21	поштучно
54238	3367	*ФИЛЕ МИНТАЯ мороженое без кожи без кости 1кг коробка 1/21кг ООО Русский минтай ЦЕНА ЗА ШТУКУ	\N	\N	11833.00	шт	1	360	t	2025-12-07 13:19:44.239	2025-12-07 13:19:44.239	564.00	шт	21	поштучно
54239	3367	ГОРБУША мороженая потрошенная без головы Вылов 2025*	\N	\N	8804.00	уп (22 шт)	1	298	t	2025-12-07 13:19:44.25	2025-12-07 13:19:44.25	400.00	кг	22	только уп
54240	3367	ГОРБУША мороженая потрошенная с головой  Вылов 2025*	\N	\N	8804.00	уп (22 шт)	1	726	t	2025-12-07 13:19:44.261	2025-12-07 13:19:44.261	400.00	кг	22	только уп
54241	3367	ГОРБУША мороженая потрошенная с головой 1/22кг Вылов 2025г*	\N	\N	8804.00	уп (22 шт)	1	1000	t	2025-12-07 13:19:44.271	2025-12-07 13:19:44.271	400.00	кг	22	только уп
54242	3367	ДОРАДО мороженая 400/600гр 1/5кг Турция	\N	\N	6037.00	уп (5 шт)	1	95	t	2025-12-07 13:19:44.346	2025-12-07 13:19:44.346	1208.00	кг	5	только уп
54243	3367	ЗУБАТКА пестрая мороженая потрошеная б/г 2*16кг М-0138 Капитан Рогозин	\N	\N	20203.00	уп (32 шт)	1	44	t	2025-12-07 13:19:44.412	2025-12-07 13:19:44.412	631.00	кг	32	только уп
54244	3367	КАМБАЛА мороженая неразделанная 21+  ИП Курбатов Л.Д.	\N	\N	3668.00	уп (22 шт)	1	242	t	2025-12-07 13:19:44.445	2025-12-07 13:19:44.445	167.00	кг	22	только уп
54245	3367	КЕТА потрошенная без головы с/м 1/22кг Вылов 2025 - *	\N	\N	13662.00	уп (22 шт)	1	352	t	2025-12-07 13:19:44.522	2025-12-07 13:19:44.522	621.00	кг	22	только уп
54246	3367	КЕТА потрошенная без головы с/м 1/22кг Вылов 2025 - 2*	\N	\N	13662.00	уп (22 шт)	1	254	t	2025-12-07 13:19:44.533	2025-12-07 13:19:44.533	621.00	кг	22	только уп
54247	3367	КИЖУЧ мороженая потрошенная с головой ВЕС 1/20-23кг ВЫЛОВ 2025 Мотыклейский Залив*	\N	\N	12770.00	уп (20 шт)	1	736	t	2025-12-07 13:19:44.544	2025-12-07 13:19:44.544	633.00	кг	20	только уп
54248	3367	КОРЮШКА азиатская мороженая неразделанная М БРЗК Колхоз Октябрь	\N	\N	31625.00	уп (22 шт)	1	132	t	2025-12-07 13:19:44.557	2025-12-07 13:19:44.557	1438.00	кг	22	только уп
54249	3367	МИНТАЙ мороженый без головы 25+ вес 1/14кг Вылов 2025г*	\N	\N	2365.00	уп (14 шт)	1	1000	t	2025-12-07 13:19:44.568	2025-12-07 13:19:44.568	169.00	кг	14	только уп
54250	3367	НАВАГА мороженая блочная б/г морская заморозка 1/24кг РКЗ Командор-Инвест	\N	\N	4554.00	уп (24 шт)	1	1000	t	2025-12-07 13:19:44.58	2025-12-07 13:19:44.58	190.00	кг	24	только уп
54251	3367	НЕРКА мороженая потрошенная без головы L 1/20кг ООО Зюйд	\N	\N	29670.00	уп (20 шт)	1	1000	t	2025-12-07 13:19:44.605	2025-12-07 13:19:44.605	1483.00	кг	20	только уп
54252	3367	НЕРКА мороженая потрошенная без головы М 1/20кг ООО Зюйд	\N	\N	27370.00	уп (20 шт)	1	1000	t	2025-12-07 13:19:44.616	2025-12-07 13:19:44.616	1369.00	кг	20	только уп
54253	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый  "М" 1/22-24кг	\N	\N	43992.00	уп (23 шт)	1	544	t	2025-12-07 13:19:44.626	2025-12-07 13:19:44.626	1932.00	кг	23	только уп
54254	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый  "М" Р 1/22-24кг	\N	\N	44243.00	уп (23 шт)	1	33	t	2025-12-07 13:19:44.636	2025-12-07 13:19:44.636	1932.00	кг	23	только уп
54255	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый "S" (1-2кг) 1/22-23кг	\N	\N	36906.00	уп (23 шт)	1	746	t	2025-12-07 13:19:44.65	2025-12-07 13:19:44.65	1633.00	кг	23	только уп
54256	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый "S" 1/20-24кг	\N	\N	38376.00	уп (24 шт)	1	191	t	2025-12-07 13:19:44.661	2025-12-07 13:19:44.661	1633.00	кг	24	только уп
54257	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый "М" Р/ву 1/22-24кг	\N	\N	45165.00	уп (23 шт)	1	28	t	2025-12-07 13:19:44.672	2025-12-07 13:19:44.672	1972.00	кг	23	только уп
54258	3367	СЕЛЬДЬ ОЛЮТОРСКАЯ мороженая КРУПНАЯ 2L 400-500гр 1/20кг Океанрыбфлот	\N	\N	5750.00	уп (20 шт)	1	1000	t	2025-12-07 13:19:44.682	2025-12-07 13:19:44.682	288.00	кг	20	только уп
54259	3367	СЕЛЬДЬ ТИХООКЕАНСКАЯ мороженая 1/20кг с/м*	\N	\N	2047.00	уп (20 шт)	1	1000	t	2025-12-07 13:19:44.692	2025-12-07 13:19:44.692	102.00	кг	20	только уп
54260	3367	СЕЛЬДЬ ТИХООКЕАНСКАЯ мороженая 27+ 1/13кг Тихрыбком*	\N	\N	1435.00	уп (13 шт)	1	1000	t	2025-12-07 13:19:44.703	2025-12-07 13:19:44.703	110.00	кг	13	только уп
54261	3367	СЕМГА мороженая потрошёная с головой (1шт  6-7кг) вес 1/26-28кг Премиум GRANJA MARINA TORNAGALEONES S A (Чили)	\N	\N	54955.00	кг	1	1000	t	2025-12-07 13:19:44.718	2025-12-07 13:19:44.718	2117.00	кг	26	поштучно
54262	3367	СЕМГА мороженая потрошёная с головой ПРЕМИУМ (1шт 6-7кг) вес 1/26-28кг PTD PAINE LIMITADA ЧИЛИ	\N	\N	61927.00	кг	1	329	t	2025-12-07 13:19:44.729	2025-12-07 13:19:44.729	2117.00	кг	29	поштучно
54263	3367	СКУМБРИЯ мороженая неразделанная 500-800гр вес Китай	\N	\N	3806.00	уп (10 шт)	1	1000	t	2025-12-07 13:19:44.741	2025-12-07 13:19:44.741	381.00	кг	10	только уп
54264	3367	ТЕРПУГ мороженый H/P 2L СРТМ АПОЛЛОН	\N	\N	7597.00	уп (18 шт)	1	162	t	2025-12-07 13:19:44.752	2025-12-07 13:19:44.752	422.00	кг	18	только уп
54265	3367	ТЕРПУГ мороженый H/P L  1/18кг СРТМ Феникс	\N	\N	7245.00	уп (18 шт)	1	1000	t	2025-12-07 13:19:44.765	2025-12-07 13:19:44.765	402.00	кг	18	только уп
54266	3367	ТЕРПУГ мороженый H/P L  СРТМ АПОЛЛОН	\N	\N	7597.00	уп (18 шт)	1	1000	t	2025-12-07 13:19:44.776	2025-12-07 13:19:44.776	422.00	кг	18	только уп
54267	3367	ФАРШ МИНТАЯ Восточный вес с/м Россия	\N	\N	5216.00	уп (22 шт)	1	337	t	2025-12-07 13:19:44.791	2025-12-07 13:19:44.791	232.00	кг	22	только уп
54268	3367	ФАРШ МИНТАЯ Восточный вес с/м Россия Р ЖЕЛТЫЙ СКОТЧ	\N	\N	5216.00	уп (22 шт)	1	112	t	2025-12-07 13:19:44.805	2025-12-07 13:19:44.805	232.00	кг	22	только уп
54269	3367	ФИЛЕ МИНТАЯ мороженое без кожи без кости Мыс Меньшикова	\N	\N	10324.00	уп (23 шт)	1	1000	t	2025-12-07 13:19:44.816	2025-12-07 13:19:44.816	459.00	кг	23	только уп
54270	3367	ФИЛЕ МИНТАЯ мороженое без кожи без кости Р Мыс Меньшикова ЖЕЛТЫЙ СКОТЧ	\N	\N	10324.00	уп (23 шт)	1	91	t	2025-12-07 13:19:44.826	2025-12-07 13:19:44.826	459.00	кг	23	только уп
54271	3367	ФИЛЕ МИНТАЯ мороженое без кожи без кости Р Россия ЖЕЛТЫЙ СКОТЧ	\N	\N	10302.00	уп (22 шт)	1	90	t	2025-12-07 13:19:44.836	2025-12-07 13:19:44.836	459.00	кг	22	только уп
54272	3367	ФИЛЕ ОКУНЯ КРАСНОГО мороженое с/м 1/10кг Китай	\N	\N	7532.00	уп (10 шт)	1	320	t	2025-12-07 13:19:44.851	2025-12-07 13:19:44.851	753.00	кг	10	только уп
54273	3367	ФИЛЕ ПАЛТУСА с/м в/у 400гр Китай	\N	\N	7314.00	уп (30 шт)	1	627	t	2025-12-07 13:19:44.868	2025-12-07 13:19:44.868	244.00	шт	30	только уп
54274	3367	ФИЛЕ ПАЛТУСА с/м Китай	\N	\N	6095.00	уп (10 шт)	1	1000	t	2025-12-07 13:19:44.879	2025-12-07 13:19:44.879	610.00	кг	10	только уп
54275	3367	ФИЛЕ ПАНГАСИУСА с/м Вьетнам	\N	\N	3220.00	уп (10 шт)	1	1000	t	2025-12-07 13:19:44.89	2025-12-07 13:19:44.89	322.00	кг	10	только уп
54276	3367	ФИЛЕ СЁМГА (1уп~2,2 -- 2,6кг)  в/уп с/м 1/17-19кг Китай	\N	\N	46537.00	кг	1	502	t	2025-12-07 13:19:44.901	2025-12-07 13:19:44.901	2415.00	кг	19	поштучно
54277	3367	ФИЛЕ ТИЛАПИИ мороженое 5-7 КНР	\N	\N	9085.00	уп (10 шт)	1	770	t	2025-12-07 13:19:44.912	2025-12-07 13:19:44.912	908.00	кг	10	только уп
54278	3367	ФИЛЕ ТУНЦА желтоперого  в/уп 500гр (стейки по 100+) с/м	\N	\N	12190.00	уп (20 шт)	1	904	t	2025-12-07 13:19:44.924	2025-12-07 13:19:44.924	610.00	шт	20	только уп
54279	3367	ФИЛЕ УГРЯ Унаги жареное замороженное (300-400гр) 10% соуса 1/10кг	\N	\N	24437.00	кг	1	255	t	2025-12-07 13:19:44.935	2025-12-07 13:19:44.935	2444.00	кг	10	поштучно
54280	3367	САЛАТ 150гр из морских водорослей Чука с/м Китай	\N	\N	5428.00	шт	1	260	t	2025-12-07 13:19:44.949	2025-12-07 13:19:44.949	68.00	шт	80	поштучно
54281	3367	САЛАТ 500гр из морских водорослей Чука красная имбирная с/м Китай	\N	\N	4664.00	шт	1	385	t	2025-12-07 13:19:44.96	2025-12-07 13:19:44.96	194.00	шт	24	поштучно
54282	3367	САЛАТ 500гр из морских водорослей Чука красная классическая с/м Китай	\N	\N	4664.00	шт	1	281	t	2025-12-07 13:19:44.971	2025-12-07 13:19:44.971	194.00	шт	24	поштучно
54283	3367	САЛАТ 500гр из морских водорослей Чука с/м Китай	\N	\N	4002.00	шт	1	1000	t	2025-12-07 13:19:44.985	2025-12-07 13:19:44.985	167.00	шт	24	поштучно
54284	3367	САЛАТ 500гр из морских водорослей Чука со вкусом васаби с/м Китай	\N	\N	4664.00	шт	1	280	t	2025-12-07 13:19:44.996	2025-12-07 13:19:44.996	194.00	шт	24	поштучно
54285	3367	САЛАТ 500гр из морских водорослей Чука со вкусом ротангового перца с/м Китай	\N	\N	4664.00	шт	1	388	t	2025-12-07 13:19:45.063	2025-12-07 13:19:45.063	194.00	шт	24	поштучно
54286	3367	КРЕВЕТКА Аргентинская 2кг с/м 10/20 красная в панцире с головой ТМ Вичи	\N	\N	19534.00	шт	1	28	t	2025-12-07 13:19:45.093	2025-12-07 13:19:45.093	3256.00	шт	6	поштучно
54287	3367	КРЕВЕТКА Аргентинская 450гр с/м 41/50 красная в панцире без головы ТМ Вичи Luxury	\N	\N	5444.00	шт	1	250	t	2025-12-07 13:19:45.116	2025-12-07 13:19:45.116	907.00	шт	6	поштучно
54288	3367	КРЕВЕТКА Аргентинская 4кг вес с/м 41/50 красная в панцире без головы ТМ Вичи Приорити	\N	\N	7889.00	кг	1	500	t	2025-12-07 13:19:45.133	2025-12-07 13:19:45.133	1972.00	кг	4	поштучно
54289	3367	КРЕВЕТКА Тигровая 1кг с/м 16/20 в панцире без головы с хвостиком Бангладеш	\N	\N	13915.00	шт	1	405	t	2025-12-07 13:19:45.148	2025-12-07 13:19:45.148	1392.00	шт	10	поштучно
54290	3367	КРЕВЕТКА Тигровая 1кг с/м 16/20 очищенная с хвостиком Бангладеш	\N	\N	15985.00	шт	1	9	t	2025-12-07 13:19:45.163	2025-12-07 13:19:45.163	1598.00	шт	10	поштучно
54291	3367	КРЕВЕТКА  Ваннамей 1кг в/м 30/50 очищенная с хвостиком Китай	\N	\N	12926.00	шт	1	177	t	2025-12-07 13:19:45.177	2025-12-07 13:19:45.177	1293.00	шт	10	поштучно
54292	3367	КРЕВЕТКА Белоногие 500гр в/м 31/40 очищенная с хвостиком в соусе по-азиатски ТМ Вичи	\N	\N	11362.00	шт	1	63	t	2025-12-07 13:19:45.211	2025-12-07 13:19:45.211	1420.00	шт	8	поштучно
54293	3367	КРЕВЕТКА Белоногие 500гр в/м 31/40 очищенная с хвостиком в соусе по-средиземноморски ТМ Вичи	\N	\N	11362.00	шт	1	63	t	2025-12-07 13:19:45.226	2025-12-07 13:19:45.226	1420.00	шт	8	поштучно
54294	3367	КРЕВЕТКА Коктейльная 500гр в/м 100/200 очищенная ошпаренная ТМ Тихая Бухта	\N	\N	11086.00	шт	1	500	t	2025-12-07 13:19:45.31	2025-12-07 13:19:45.31	554.00	шт	20	поштучно
54295	3367	КРЕВЕТКА Королевская 500гр в/м 30/40 в панцире с головой ТМ Вичи Приорити	\N	\N	6090.00	шт	1	500	t	2025-12-07 13:19:45.369	2025-12-07 13:19:45.369	761.00	шт	8	поштучно
54296	3367	КРЕВЕТКА Северная 5кг в/м 70-90 Китай	\N	\N	7676.00	уп (5 шт)	1	500	t	2025-12-07 13:19:45.389	2025-12-07 13:19:45.389	1535.00	кг	5	только уп
54297	3367	Крабовые палочки 5кг вес ТМ VICI Columbus	\N	\N	1897.00	уп (5 шт)	1	10	t	2025-12-07 13:19:45.404	2025-12-07 13:19:45.404	379.00	кг	5	только уп
54298	3367	Крабовое мясо 180гр ТМ VICI Краб ОК	\N	\N	2559.00	шт	1	875	t	2025-12-07 13:19:45.418	2025-12-07 13:19:45.418	102.00	шт	25	поштучно
54299	3367	Крабовое мясо 200гр ТМ VICI	\N	\N	5319.00	шт	1	1000	t	2025-12-07 13:19:45.43	2025-12-07 13:19:45.43	213.00	шт	25	поштучно
54300	3367	Крабовое мясо 200гр ТМ VICI Columbus	\N	\N	2358.00	шт	1	214	t	2025-12-07 13:19:45.442	2025-12-07 13:19:45.442	94.00	шт	25	поштучно
54301	3367	Крабовое мясо 200гр ТМ VICI Краб ОК	\N	\N	2864.00	шт	1	617	t	2025-12-07 13:19:45.46	2025-12-07 13:19:45.46	115.00	шт	25	поштучно
54302	3367	Крабовое мясо 200гр ТМ Бремор	\N	\N	4313.00	шт	1	268	t	2025-12-07 13:19:45.48	2025-12-07 13:19:45.48	144.00	шт	30	поштучно
54303	3367	Крабовое мясо 200гр ТМ Крабия	\N	\N	2415.00	шт	1	180	t	2025-12-07 13:19:45.494	2025-12-07 13:19:45.494	81.00	шт	30	поштучно
54304	3367	Крабовое мясо 200гр ТМ Русское Море	\N	\N	1047.00	шт	1	473	t	2025-12-07 13:19:45.506	2025-12-07 13:19:45.506	150.00	шт	7	поштучно
54305	3367	Крабовое палочки экономные вес 5кг ТМ Бремор	\N	\N	322.00	кг	1	1000	t	2025-12-07 13:19:45.52	2025-12-07 13:19:45.52	322.00	кг	\N	поштучно
54306	3367	Крабовые палочки 100гр ТМ VICI	\N	\N	2933.00	шт	1	1000	t	2025-12-07 13:19:45.533	2025-12-07 13:19:45.533	98.00	шт	30	поштучно
54307	3367	Крабовые палочки 100гр ТМ VICI Columbus	\N	\N	2415.00	шт	1	307	t	2025-12-07 13:19:45.547	2025-12-07 13:19:45.547	43.00	шт	56	поштучно
54308	3367	Крабовые палочки 100гр ТМ VICI Краб ОК	\N	\N	3529.00	шт	1	1000	t	2025-12-07 13:19:45.559	2025-12-07 13:19:45.559	63.00	шт	56	поштучно
54309	3367	Крабовые палочки 100гр ТМ Крабия	\N	\N	2553.00	шт	1	75	t	2025-12-07 13:19:45.572	2025-12-07 13:19:45.572	43.00	шт	60	поштучно
54310	3367	Крабовые палочки 100гр ТМ Русское Море	\N	\N	4554.00	шт	1	759	t	2025-12-07 13:19:45.585	2025-12-07 13:19:45.585	76.00	шт	60	поштучно
54311	3367	Крабовые палочки 200гр с мясом натурального краба ТМ VICI	\N	\N	4637.00	шт	1	1000	t	2025-12-07 13:19:45.611	2025-12-07 13:19:45.611	258.00	шт	18	поштучно
54312	3367	Крабовые палочки 200гр ТМ VICI	\N	\N	6745.00	шт	1	1000	t	2025-12-07 13:19:45.624	2025-12-07 13:19:45.624	225.00	шт	30	поштучно
54313	3367	Крабовые палочки 200гр ТМ VICI Columbus	\N	\N	2691.00	шт	1	317	t	2025-12-07 13:19:45.708	2025-12-07 13:19:45.708	90.00	шт	30	поштучно
54314	3367	Крабовые палочки 200гр ТМ VICI Краб ОК	\N	\N	3933.00	шт	1	1000	t	2025-12-07 13:19:45.72	2025-12-07 13:19:45.72	131.00	шт	30	поштучно
54315	3367	Крабовые палочки 200гр ТМ Бремор	\N	\N	4313.00	шт	1	380	t	2025-12-07 13:19:45.732	2025-12-07 13:19:45.732	144.00	шт	30	поштучно
54316	3367	Крабовые палочки 200гр ТМ Крабия	\N	\N	2346.00	шт	1	327	t	2025-12-07 13:19:45.745	2025-12-07 13:19:45.745	78.00	шт	30	поштучно
54317	3367	Крабовые палочки 200гр ТМ Русское Море	\N	\N	1150.00	шт	1	1000	t	2025-12-07 13:19:45.757	2025-12-07 13:19:45.757	144.00	шт	8	поштучно
54318	3367	Крабовые палочки 240гр ТМ VICI Columbus	\N	\N	2703.00	шт	1	503	t	2025-12-07 13:19:45.779	2025-12-07 13:19:45.779	108.00	шт	25	поштучно
54319	3367	Крабовые палочки 240гр ТМ VICI Краб ОК	\N	\N	4347.00	шт	1	866	t	2025-12-07 13:19:45.791	2025-12-07 13:19:45.791	161.00	шт	27	поштучно
54320	3367	Крабовые палочки 300гр для рулетиков ТМ VICI	\N	\N	2404.00	шт	1	1000	t	2025-12-07 13:19:45.803	2025-12-07 13:19:45.803	218.00	шт	11	поштучно
54321	3367	Крабовые палочки 300гр ТМ VICI	\N	\N	2574.00	шт	1	505	t	2025-12-07 13:19:45.823	2025-12-07 13:19:45.823	184.00	шт	14	поштучно
54322	3367	Крабовые палочки 4*200гр ТМ VICI	\N	\N	4717.00	шт	1	228	t	2025-12-07 13:19:45.837	2025-12-07 13:19:45.837	674.00	шт	7	поштучно
54323	3367	Крабовые палочки 400гр ТМ Бремор	\N	\N	3243.00	шт	1	417	t	2025-12-07 13:19:45.85	2025-12-07 13:19:45.85	270.00	шт	12	поштучно
54324	3367	Крабовые палочки 400гр ТМ Русское Море	\N	\N	4244.00	шт	1	204	t	2025-12-07 13:19:45.866	2025-12-07 13:19:45.866	283.00	шт	15	поштучно
54325	3367	Крабовые палочки 500гр Снежный краб красный 1/12шт ТМ Санта Бремор	\N	\N	4858.00	шт	1	823	t	2025-12-07 13:19:45.878	2025-12-07 13:19:45.878	405.00	шт	12	поштучно
54326	3367	Крабовые палочки 500гр ТМ Бремор	\N	\N	3505.00	шт	1	6	t	2025-12-07 13:19:45.891	2025-12-07 13:19:45.891	292.00	шт	12	поштучно
54327	3398	ИКРА Масаго Энко Люкс зеленая 500гр 1/6шт	\N	\N	5175.00	шт	1	81	t	2025-12-07 13:19:45.902	2025-12-07 13:19:45.902	862.00	шт	6	поштучно
54328	3398	ИКРА Масаго Энко Люкс красная 500гр 1/6шт	\N	\N	5865.00	шт	1	126	t	2025-12-07 13:19:45.919	2025-12-07 13:19:45.919	977.00	шт	6	поштучно
54329	3398	ИКРА Масаго Энко Люкс оранжевая 500гр 1/6шт	\N	\N	5865.00	шт	1	180	t	2025-12-07 13:19:45.934	2025-12-07 13:19:45.934	977.00	шт	6	поштучно
54330	3367	ИКОРКА СЕЛЬДИ 160гр в сливочном соусе ст/б ТМ Меридиан	\N	\N	1610.00	шт	1	41	t	2025-12-07 13:19:45.945	2025-12-07 13:19:45.945	201.00	шт	8	поштучно
54331	3367	ИКОРКА СЕЛЬДИ 160гр подкопченая в соусе ст/б ТМ Меридиан	\N	\N	1610.00	шт	1	261	t	2025-12-07 13:19:45.963	2025-12-07 13:19:45.963	201.00	шт	8	поштучно
54332	3367	ИКОРКА СЕЛЬДИ 160гр с красной рыбкой ст/б ТМ Меридиан	\N	\N	1610.00	шт	1	122	t	2025-12-07 13:19:45.976	2025-12-07 13:19:45.976	201.00	шт	8	поштучно
54333	3367	ИКРА МОЙВЫ 165гр деликатесная с лососем ТМ Русское Море	\N	\N	1214.00	шт	1	146	t	2025-12-07 13:19:45.997	2025-12-07 13:19:45.997	202.00	шт	6	поштучно
54334	3367	ИКРА МОЙВЫ 180гр деликатесная классическая "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	213	t	2025-12-07 13:19:46.008	2025-12-07 13:19:46.008	259.00	шт	6	поштучно
54335	3367	ИКРА МОЙВЫ 180гр деликатесная подкопченая "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	199	t	2025-12-07 13:19:46.022	2025-12-07 13:19:46.022	259.00	шт	6	поштучно
54336	3367	ИКРА МОЙВЫ 180гр деликатесная с копчёным лососем "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	300	t	2025-12-07 13:19:46.036	2025-12-07 13:19:46.036	259.00	шт	6	поштучно
54337	3367	ИКРА МОЙВЫ 180гр деликатесная с креветкой "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	300	t	2025-12-07 13:19:46.048	2025-12-07 13:19:46.048	259.00	шт	6	поштучно
54338	3367	ИКРА МОЙВЫ 180гр деликатесная с лососем и авокадо "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	206	t	2025-12-07 13:19:46.059	2025-12-07 13:19:46.059	259.00	шт	6	поштучно
54339	3367	ИКРА МОЙВЫ 270гр деликатесная с копчёным лососем 1/6шт ТМ Санта Бремор	\N	\N	2084.00	шт	1	40	t	2025-12-07 13:19:46.072	2025-12-07 13:19:46.072	347.00	шт	6	поштучно
54340	3367	ИКРА мойвы деликатесная подкопченая 165гр ст/бан	\N	\N	1214.00	шт	1	158	t	2025-12-07 13:19:46.097	2025-12-07 13:19:46.097	202.00	шт	6	поштучно
54341	3367	ИКРА МОЙВЫ и СЕЛЬДИ 160гр деликатесная подкопченая "Икринка" ст/б ТМ Санта Бремор	\N	\N	1173.00	шт	1	82	t	2025-12-07 13:19:46.135	2025-12-07 13:19:46.135	195.00	шт	6	поштучно
54342	3367	ИКРА МОЙВЫ и СЕЛЬДИ 160гр деликатесная с копчёным лососем "Икринка" ст/б ТМ Санта Бремор	\N	\N	1173.00	шт	1	165	t	2025-12-07 13:19:46.147	2025-12-07 13:19:46.147	195.00	шт	6	поштучно
54343	3367	ИКРА МОЙВЫ и СЕЛЬДИ 160гр деликатесная с креветкой "Икринка" ст/б ТМ Санта Бремор	\N	\N	1173.00	шт	1	38	t	2025-12-07 13:19:46.159	2025-12-07 13:19:46.159	195.00	шт	6	поштучно
54344	3367	ИКРА мойвы с креветкой 165гр ст/бан	\N	\N	1214.00	шт	1	125	t	2025-12-07 13:19:46.177	2025-12-07 13:19:46.177	202.00	шт	6	поштучно
54345	3367	ИКРА Осетровая Черная 230гр имитированная Стольная ст/б 1/6шт ТМ Русское Море	\N	\N	911.00	шт	1	300	t	2025-12-07 13:19:46.188	2025-12-07 13:19:46.188	152.00	шт	6	поштучно
54346	3367	КАЛЬМАР 180гр командорский щупальца в заливке пл/лоток ТМ Русское Море	\N	\N	1808.00	шт	1	139	t	2025-12-07 13:19:46.199	2025-12-07 13:19:46.199	301.00	шт	6	поштучно
54347	3367	КАЛЬМАР 180гр соломка в заливке 1/6шт ТМ Русское Море	\N	\N	1656.00	шт	1	145	t	2025-12-07 13:19:46.21	2025-12-07 13:19:46.21	276.00	шт	6	поштучно
54348	3367	КАЛЬМАР 415гр щупальца и соломка  в рассоле стакан ТМ Milegrin	\N	\N	3843.00	шт	1	16	t	2025-12-07 13:19:46.224	2025-12-07 13:19:46.224	641.00	шт	6	поштучно
54349	3367	Кальмаровые палочки 180гр имитация с сыром ТМ Русское море	\N	\N	1249.00	шт	1	67	t	2025-12-07 13:19:46.236	2025-12-07 13:19:46.236	208.00	шт	6	поштучно
54350	3367	КОКТЕЙЛЬ 180гр из морепродуктов в масле "Оригинал" пл/лоток ТМ Русское Море	\N	\N	1746.00	шт	1	215	t	2025-12-07 13:19:46.247	2025-12-07 13:19:46.247	291.00	шт	6	поштучно
54351	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле  пл/лоток ТМ Меридиан	\N	\N	2870.00	шт	1	66	t	2025-12-07 13:19:46.261	2025-12-07 13:19:46.261	359.00	шт	8	поштучно
54352	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле с зеленью  пл/лоток ТМ Меридиан	\N	\N	2870.00	шт	1	300	t	2025-12-07 13:19:46.273	2025-12-07 13:19:46.273	359.00	шт	8	поштучно
54353	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле с зеленью "По-Мароккански" пл/лоток  Мирамар ТМ Меридиан	\N	\N	2631.00	шт	1	233	t	2025-12-07 13:19:46.35	2025-12-07 13:19:46.35	329.00	шт	8	поштучно
54354	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле с пряностями "По-Мексикански" пл/лоток Мирамар ТМ Меридиан	\N	\N	2631.00	шт	1	191	t	2025-12-07 13:19:46.426	2025-12-07 13:19:46.426	329.00	шт	8	поштучно
54355	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле с пряностями Мехико  пл/лоток ТМ Меридиан	\N	\N	2870.00	шт	1	295	t	2025-12-07 13:19:46.444	2025-12-07 13:19:46.444	359.00	шт	8	поштучно
54356	3367	Крабовые палочки 180гр с мясом натурального краба и сыром ТМ Русское море	\N	\N	1249.00	шт	1	208	t	2025-12-07 13:19:46.47	2025-12-07 13:19:46.47	208.00	шт	6	поштучно
54357	3367	Крабовые палочки 180гр с мясом натурального краба с сыром и зеленью ТМ Русское море	\N	\N	1249.00	шт	1	300	t	2025-12-07 13:19:46.524	2025-12-07 13:19:46.524	208.00	шт	6	поштучно
54358	3367	КРЕВЕТКИ 180гр в заливке пл/лоток ТМ Русское море	\N	\N	2132.00	шт	1	263	t	2025-12-07 13:19:46.549	2025-12-07 13:19:46.549	355.00	шт	6	поштучно
54359	3367	КРЕВЕТКИ 180гр с хвостиком в заливке "Королевские" 1/6шт ТМ Русское Море	\N	\N	2546.00	шт	1	142	t	2025-12-07 13:19:46.56	2025-12-07 13:19:46.56	424.00	шт	6	поштучно
54360	3367	Лососевые палочки 180гр имитация с сыром ТМ Русское море	\N	\N	1249.00	шт	1	136	t	2025-12-07 13:19:46.58	2025-12-07 13:19:46.58	208.00	шт	6	поштучно
54361	3367	М Икра Сельди ястычная 150гр с/с " К картошке" традиционная в масле 1/6шт ТМ Русское Море	\N	\N	1573.00	шт	1	44	t	2025-12-07 13:19:46.61	2025-12-07 13:19:46.61	262.00	шт	6	поштучно
54362	3367	МИДИИ 150гр в майонезно-горчичной заливке  пл/лоток ТМ Меридиан	\N	\N	2404.00	шт	1	300	t	2025-12-07 13:19:46.622	2025-12-07 13:19:46.622	240.00	шт	10	поштучно
54363	3367	МИДИИ 150гр в масле "По-Гречески" пл/лоток Мирамар ТМ Меридиан	\N	\N	1923.00	шт	1	202	t	2025-12-07 13:19:46.633	2025-12-07 13:19:46.633	240.00	шт	8	поштучно
54364	3367	МИДИИ 150гр в масле Брушетта  пл/лоток ТМ Меридиан	\N	\N	2404.00	шт	1	300	t	2025-12-07 13:19:46.645	2025-12-07 13:19:46.645	240.00	шт	10	поштучно
54365	3367	МИДИИ 150гр в масле пл/лоток ТМ Меридиан	\N	\N	2404.00	шт	1	300	t	2025-12-07 13:19:46.663	2025-12-07 13:19:46.663	240.00	шт	10	поштучно
54602	3395	МОРКОВЬ мини вес	\N	\N	3795.00	уп (10 шт)	1	160	t	2025-12-07 13:19:50.661	2025-12-07 13:19:50.661	379.00	кг	10	только уп
54366	3367	МИДИИ 150гр в масле с зеленью "По-Итальянски" пл/лоток Мирамар ТМ Меридиан	\N	\N	1923.00	шт	1	277	t	2025-12-07 13:19:46.675	2025-12-07 13:19:46.675	240.00	шт	8	поштучно
54367	3367	МИДИИ 180гр в масле "Классик" пл/лоток ТМ Русское море	\N	\N	1594.00	шт	1	201	t	2025-12-07 13:19:46.688	2025-12-07 13:19:46.688	266.00	шт	6	поштучно
54368	3367	МИДИИ 180гр чилийские  в заливке пл/лоток ТМ Русское Море	\N	\N	1318.00	шт	1	76	t	2025-12-07 13:19:46.705	2025-12-07 13:19:46.705	220.00	шт	6	поштучно
54369	3367	МИДИИ 415гр отборные в масле с прованскими травами стакан ТМ Milegrin	\N	\N	3284.00	шт	1	16	t	2025-12-07 13:19:46.717	2025-12-07 13:19:46.717	547.00	шт	6	поштучно
54370	3367	МОРСКОЙ МИКС 180гр в заливке пл/лоток ТМ Русское Море	\N	\N	1580.00	шт	1	230	t	2025-12-07 13:19:46.73	2025-12-07 13:19:46.73	263.00	шт	6	поштучно
54371	3367	ПАСТА из морепродуктов 150гр Кальмар рубленый в слив.соусе с авокадо ТМ Санта Бремор	\N	\N	1014.00	шт	1	174	t	2025-12-07 13:19:46.741	2025-12-07 13:19:46.741	169.00	шт	6	поштучно
54372	3367	ПАСТА из морепродуктов 150гр Кальмар рубленый в слив.соусе с креветкой ТМ Санта Бремор	\N	\N	1014.00	шт	1	300	t	2025-12-07 13:19:46.755	2025-12-07 13:19:46.755	169.00	шт	6	поштучно
54373	3367	ПАСТА из морепродуктов 150гр классическая "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	300	t	2025-12-07 13:19:46.767	2025-12-07 13:19:46.767	198.00	шт	6	поштучно
54374	3367	ПАСТА из морепродуктов 150гр Краб в сливочном соусе с имитацией крабового мяса ТМ Санта Бремор	\N	\N	1187.00	шт	1	300	t	2025-12-07 13:19:46.781	2025-12-07 13:19:46.781	198.00	шт	6	поштучно
54375	3367	ПАСТА из морепродуктов 150гр подкопченная "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	300	t	2025-12-07 13:19:46.795	2025-12-07 13:19:46.795	198.00	шт	6	поштучно
54376	3367	ПАСТА из морепродуктов 150гр с Авокадо "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	232	t	2025-12-07 13:19:46.809	2025-12-07 13:19:46.809	198.00	шт	6	поштучно
54377	3367	ПАСТА из морепродуктов 150гр сладкий чили "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	182	t	2025-12-07 13:19:46.821	2025-12-07 13:19:46.821	198.00	шт	6	поштучно
54378	3367	ПАСТА из морепродуктов 150гр Сливочно/Чесночная "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	300	t	2025-12-07 13:19:46.834	2025-12-07 13:19:46.834	198.00	шт	6	поштучно
54379	3367	ПАСТА из мяса мидии 150гр Сальса ТМ Санта Бремор	\N	\N	966.00	шт	1	103	t	2025-12-07 13:19:46.848	2025-12-07 13:19:46.848	161.00	шт	6	поштучно
54380	3367	ПАСТА из филе тресковых рыб 140гр с кальмаром и креветкой "Фиш-мусс" ТМ Санта Бремор	\N	\N	862.00	шт	1	111	t	2025-12-07 13:19:46.86	2025-12-07 13:19:46.86	144.00	шт	6	поштучно
54381	3367	ПАСТА из филе тресковых рыб 140гр с лососем "Фиш-мусс" ТМ Санта Бремор	\N	\N	862.00	шт	1	88	t	2025-12-07 13:19:46.879	2025-12-07 13:19:46.879	144.00	шт	6	поштучно
54382	3367	РИЕТ из лосося 100гр с миндалем ТМ Меридиан	\N	\N	1803.00	шт	1	23	t	2025-12-07 13:19:46.91	2025-12-07 13:19:46.91	225.00	шт	8	поштучно
54383	3367	РИЕТ из тунца 100гр с оливками и огурцами ТМ Меридиан	\N	\N	1711.00	шт	1	12	t	2025-12-07 13:19:46.922	2025-12-07 13:19:46.922	214.00	шт	8	поштучно
54384	3367	САЛАТ 150гр из Морских водорослей "Чука" лоток ТМ Русское Море	\N	\N	959.00	шт	1	214	t	2025-12-07 13:19:46.934	2025-12-07 13:19:46.934	160.00	шт	6	поштучно
54385	3367	САЛАТ 150гр из Морских водорослей "Чука" с ореховым соусом лоток 1/6шт ТМ Русское Море	\N	\N	1083.00	шт	1	181	t	2025-12-07 13:19:46.956	2025-12-07 13:19:46.956	181.00	шт	6	поштучно
54386	3367	САЛАТ 200гр из Морской Капусты классическая лоток ТМ Русское Море	\N	\N	614.00	шт	1	159	t	2025-12-07 13:19:46.973	2025-12-07 13:19:46.973	102.00	шт	6	поштучно
54387	3367	САЛАТ 200гр из Морской Капусты по корейски с баклажанами лоток ТМ Русское Море	\N	\N	711.00	шт	1	138	t	2025-12-07 13:19:46.984	2025-12-07 13:19:46.984	118.00	шт	6	поштучно
54388	3367	САЛАТ 200гр из Морской Капусты по корейски с грибами лоток ТМ Русское Море	\N	\N	711.00	шт	1	168	t	2025-12-07 13:19:46.996	2025-12-07 13:19:46.996	118.00	шт	6	поштучно
54389	3367	САЛАТ 200гр из Морской Капусты по корейски с морковью лоток ТМ Русское Море	\N	\N	711.00	шт	1	239	t	2025-12-07 13:19:47.007	2025-12-07 13:19:47.007	118.00	шт	6	поштучно
54390	3367	САЛАТ 200гр из Морской Капусты с кальмаром лоток ТМ Русское Море	\N	\N	1780.00	шт	1	181	t	2025-12-07 13:19:47.019	2025-12-07 13:19:47.019	148.00	шт	12	поштучно
54391	3367	САЛАТ 200гр из Морской Капусты с луком и сладким перцем лоток ТМ Русское Море	\N	\N	642.00	шт	1	81	t	2025-12-07 13:19:47.031	2025-12-07 13:19:47.031	107.00	шт	6	поштучно
54392	3367	САЛАТ 200гр МК маринованный Витаминный с овощами 1/6шт ТМ Русское Море	\N	\N	738.00	шт	1	140	t	2025-12-07 13:19:47.046	2025-12-07 13:19:47.046	123.00	шт	6	поштучно
54393	3367	САЛАТ 500гр МК маринованная классическая 1/12шт ТМ Русское Море	\N	\N	2277.00	шт	1	13	t	2025-12-07 13:19:47.057	2025-12-07 13:19:47.057	190.00	шт	12	поштучно
54394	3367	СЕЛЬДЬ 230гр Тихоокеанская слабосоленая Традиционный посол в масле 1/6шт ТМ Русское Море	\N	\N	1366.00	шт	1	233	t	2025-12-07 13:19:47.084	2025-12-07 13:19:47.084	228.00	шт	6	поштучно
54395	3367	СЕЛЬДЬ 230гр филе с кожей тихоокеанская слабосоленая Традиционный посол в масле ТМ Русское Море	\N	\N	1822.00	шт	1	119	t	2025-12-07 13:19:47.105	2025-12-07 13:19:47.105	228.00	шт	8	поштучно
54396	3367	СЕЛЬДЬ 230гр филе тихоокеанская слабосоленая Селедочка аппетитная в масле ТМ Русское Море	\N	\N	1366.00	шт	1	209	t	2025-12-07 13:19:47.116	2025-12-07 13:19:47.116	228.00	шт	6	поштучно
38200	2755	ВАФ СТАКАНЧИК ЮККИ Пломбир на сливках шоколадный 70гр 1/24шт ТМ Санта Бремор	\N	\N	2180.00	уп (24 шт)	1	100	f	2025-11-23 22:31:20.065	2025-12-06 02:48:51.249	79.00	шт	24	\N
38203	2755	РОЖОК Soletto Classico Сладкая Малина сливочное фруктовое 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	72	f	2025-11-23 22:31:20.2	2025-12-06 02:48:51.249	78.00	шт	24	\N
38204	2755	РОЖОК Soletto Апельсин Юдзу молочное 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	96	f	2025-11-23 22:31:20.237	2025-12-06 02:48:51.249	78.00	шт	24	\N
38346	2755	КОЛБАСА вар Папа может 400гр Докторская Премиум	\N	\N	2282.00	уп (8 шт)	1	42	f	2025-11-23 22:31:26.679	2025-12-06 02:48:51.249	248.00	шт	8	\N
38376	2755	НАРЕЗКА БЕКОН 180гр 1/10шт с/к в/у ТМ Черкизово	\N	\N	3737.00	уп (10 шт)	1	64	f	2025-11-23 22:31:28.002	2025-12-06 02:48:51.249	325.00	шт	10	\N
38587	2755	КОНФЕТЫ 1кг молочные Тоффи Мягкая карамель в шоколаде с мармеладом из клюквы ТМ Победа	\N	\N	2226.00	уп (2 шт)	1	56	f	2025-11-23 22:31:38.212	2025-12-06 02:48:51.249	968.00	шт	2	\N
38616	2755	КОНФЕТЫ Шантарель 500гр	\N	\N	221.00	уп (1 шт)	1	8	f	2025-11-23 22:31:39.457	2025-12-06 02:48:51.249	192.58	шт	1	\N
38662	2755	СЫР вес Голландский люкс 45% (1шт~1,7кг) шар ТМ Молодея Беларусь	\N	\N	926.00	кг	1	291	f	2025-11-23 22:31:41.436	2025-12-06 02:48:51.249	805.00	кг	\N	\N
38929	2755	МУКА в/с ГОСТ вес 50кг Союзмука	\N	\N	3019.00	уп (50 шт)	1	500	f	2025-11-23 22:31:53.538	2025-12-06 02:48:51.249	52.50	кг	50	\N
38947	2755	МАКАРОНЫ "Мальтальяти" 450гр Рожок витой №069	\N	\N	2254.00	уп (20 шт)	1	200	f	2025-11-23 22:31:54.319	2025-12-06 02:48:51.249	98.00	шт	20	\N
38962	2755	МАКАРОНЫ "Шебекинские" 450гр Витой рожок №388	\N	\N	1932.00	уп (20 шт)	1	200	f	2025-11-23 22:31:54.958	2025-12-06 02:48:51.249	84.00	шт	20	\N
39134	2755	КАША овсяная малина 35гр ТМ Мастер Дак	\N	\N	759.00	уп (30 шт)	1	200	f	2025-11-23 22:32:03.221	2025-12-06 02:48:51.249	22.00	шт	30	\N
39331	2755	ГОРОШЕК консервир 400гр ж/б  ТМ Знаток	\N	\N	1339.00	уп (12 шт)	1	200	f	2025-11-23 22:32:11.956	2025-12-06 02:48:51.249	97.00	шт	12	\N
39339	2755	КУКУРУЗА консервир 425мл ж/б  ТМ Знаток	\N	\N	1408.00	уп (12 шт)	1	200	f	2025-11-23 22:32:12.282	2025-12-06 02:48:51.249	102.00	шт	12	\N
39444	2755	НАПИТОК БОЧКАРИ Капибара Кислый микс 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	119	f	2025-11-23 22:32:16.857	2025-12-06 02:48:51.249	80.00	шт	12	\N
39445	2755	НАПИТОК БОЧКАРИ Капибара Кола 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	176	f	2025-11-23 22:32:16.894	2025-12-06 02:48:51.249	80.00	шт	12	\N
39449	2755	НАПИТОК БОЧКАРИ Капибара Персик юзу 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	179	f	2025-11-23 22:32:17.041	2025-12-06 02:48:51.249	80.00	шт	12	\N
39526	2755	ЧИСТЯЩЕЕ СРЕДСТВО 600мл Грасс Азелит Спрей Антижир	\N	\N	212.00	уп (1 шт)	1	8	f	2025-11-23 22:32:20.338	2025-12-06 02:48:51.249	184.00	шт	1	\N
54397	3367	СЕЛЬДЬ 250гр филе деликатесное Матиас с приправами 1/6шт ТМ Санта Бремор	\N	\N	1822.00	шт	1	147	t	2025-12-07 13:19:47.132	2025-12-07 13:19:47.132	304.00	шт	6	поштучно
54398	3367	СЕЛЬДЬ 250гр филе Матиас Оригинальная в масле в/у ТМ Санта Бремор	\N	\N	1822.00	шт	1	179	t	2025-12-07 13:19:47.145	2025-12-07 13:19:47.145	304.00	шт	6	поштучно
54399	3367	СЕЛЬДЬ 250гр филе Матиас с ароматом дыма в/у ТМ Санта Бремор	\N	\N	1822.00	шт	1	141	t	2025-12-07 13:19:47.156	2025-12-07 13:19:47.156	304.00	шт	6	поштучно
54400	3367	СЕЛЬДЬ 250гр филе Матиас свежая зелень в/у ТМ Санта Бремор	\N	\N	3036.00	шт	1	91	t	2025-12-07 13:19:47.168	2025-12-07 13:19:47.168	304.00	шт	10	поштучно
54401	3367	СЕЛЬДЬ 300гр филе деликатесное Матиас XXL отборный в масле 1/6шт ТМ Санта Бремор	\N	\N	2291.00	шт	1	68	t	2025-12-07 13:19:47.181	2025-12-07 13:19:47.181	382.00	шт	6	поштучно
54402	3367	СЕЛЬДЬ 300гр филе деликатесное Матиас XXL отборный Оливковый в масле с добавлением оливкового 1/6шт ТМ Санта Бремор	\N	\N	2291.00	шт	1	82	t	2025-12-07 13:19:47.195	2025-12-07 13:19:47.195	382.00	шт	6	поштучно
54403	3367	СЕЛЬДЬ 500гр филе деликатесное Матиас Оригинал 1/6шт ТМ Санта Бремор	\N	\N	3346.00	шт	1	54	t	2025-12-07 13:19:47.206	2025-12-07 13:19:47.206	558.00	шт	6	поштучно
54404	3367	СЕЛЬДЬ ф/кусочки 150гр в масле Селедочка на перекус 1/10шт ТМ Русское Море	\N	\N	1461.00	шт	1	145	t	2025-12-07 13:19:47.222	2025-12-07 13:19:47.222	146.00	шт	10	поштучно
54405	3367	СЕЛЬДЬ ф/кусочки 240гр слабосоленые А-ля лосось в масле 1/8шт ТМ Русское Море	\N	\N	1840.00	шт	1	145	t	2025-12-07 13:19:47.299	2025-12-07 13:19:47.299	230.00	шт	8	поштучно
54406	3367	СЕЛЬДЬ ф/кусочки 240гр слабосоленые Традиционный посол в масле 1/8шт ТМ Русское Море	\N	\N	1840.00	шт	1	131	t	2025-12-07 13:19:47.32	2025-12-07 13:19:47.32	230.00	шт	8	поштучно
54407	3367	СЕЛЬДЬ ф/кусочки 400гр слабосоленые атлант К картошке в масле 1/6шт ТМ Русское Море	\N	\N	2084.00	шт	1	163	t	2025-12-07 13:19:47.363	2025-12-07 13:19:47.363	347.00	шт	6	поштучно
54408	3367	СЕЛЬДЬ ф/кусочки 400гр слабосоленые атлант К картошке с пряностями в масле 1/6шт ТМ Русское Море	\N	\N	2084.00	шт	1	107	t	2025-12-07 13:19:47.382	2025-12-07 13:19:47.382	347.00	шт	6	поштучно
54409	3367	СЕЛЬДЬ ф/кусочки 400гр слабосоленые тихоокеанские Селедочка аппетитная в масле ТМ Русское Море	\N	\N	2470.00	шт	1	46	t	2025-12-07 13:19:47.396	2025-12-07 13:19:47.396	412.00	шт	6	поштучно
54410	3367	СЕМГА 200гр п/копч филе-кусок ТМ Русское море	\N	\N	6313.00	ШТ	1	25	t	2025-12-07 13:19:47.408	2025-12-07 13:19:47.408	1052.00	ШТ	6	поштучно
54411	3367	СЕМГА 300гр п/копч филе-кусок ТМ Русское море	\N	\N	9212.00	шт	1	30	t	2025-12-07 13:19:47.422	2025-12-07 13:19:47.422	1535.00	шт	6	поштучно
54412	3367	ФОРЕЛЬ 200гр п/копч филе-кусок ТМ Русское море	\N	\N	6313.00	шт	1	17	t	2025-12-07 13:19:47.434	2025-12-07 13:19:47.434	1052.00	шт	6	поштучно
54413	3367	ФОРЕЛЬ 300гр п/копч филе-кусок ТМ Русское море	\N	\N	9212.00	шт	1	24	t	2025-12-07 13:19:47.451	2025-12-07 13:19:47.451	1535.00	шт	6	поштучно
54414	3367	КИЛЬКА балтийская пряного посола 220гр пл/бан	\N	\N	3133.00	шт	1	71	t	2025-12-07 13:19:47.464	2025-12-07 13:19:47.464	261.00	шт	12	поштучно
39533	2755	МОЛОКО Минская марка 3,2% 1л стеризованное тетрапак	\N	\N	1684.00	уп (12 шт)	1	200	f	2025-11-23 22:32:20.644	2025-12-06 02:48:51.249	122.00	шт	12	\N
39613	2755	СЫРОК Савушкин ваниль глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-11-23 22:32:24.163	2025-12-06 02:48:51.249	46.00	шт	18	\N
39614	2755	СЫРОК Савушкин вареная сгущенка глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-11-23 22:32:24.206	2025-12-06 02:48:51.249	46.00	шт	18	\N
39617	2755	СЫРОК Савушкин Творобушки вареная сгущенка глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-11-23 22:32:24.32	2025-12-06 02:48:51.249	46.00	шт	18	\N
39618	2755	СЫРОК Савушкин Творобушки клубника глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-11-23 22:32:24.367	2025-12-06 02:48:51.249	46.00	шт	18	\N
39619	2755	СЫРОК Савушкин Творобушки малина глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-11-23 22:32:24.409	2025-12-06 02:48:51.249	46.00	шт	18	\N
39620	2755	СЫРОК Савушкин Творобушки манго глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-11-23 22:32:24.449	2025-12-06 02:48:51.249	46.00	шт	18	\N
39621	2755	СЫРОК Савушкин Творобушки шоколад глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-11-23 22:32:24.486	2025-12-06 02:48:51.249	46.00	шт	18	\N
39627	2755	ТВОРОГ вес 5кг 9% ТМ Заснеженная Русь	\N	\N	2588.00	уп (5 шт)	1	70	f	2025-11-23 22:32:24.791	2025-12-06 02:48:51.249	450.00	кг	5	\N
39782	2755	ПЕЛЬМЕНИ Большая кастрюля 750гр Классические Фирменные с говядиной и свининой	\N	\N	4393.00	уп (10 шт)	1	170	f	2025-11-23 22:32:32.086	2025-12-06 02:48:51.249	382.00	шт	10	\N
39815	2755	ТЕСТО 1кг слоеное бездрожжевое (пласт) ТМ Морозко	\N	\N	3027.00	уп (8 шт)	1	300	f	2025-11-23 22:32:33.635	2025-12-06 02:48:51.249	329.00	шт	8	\N
39936	2755	СВИНИНА ЛОПАТКА без кости без голяшки вес с/м ТМ Полянское	\N	\N	7543.00	уп (16 шт)	1	300	f	2025-11-23 22:32:39.273	2025-12-06 02:48:51.249	417.00	кг	16	\N
39954	2755	СВИНИНА РУЛЬКА (голяшка) передняя на кости с/м ТМ Коралл	\N	\N	5369.00	уп (20 шт)	1	300	f	2025-11-23 22:32:40.106	2025-12-06 02:48:51.249	235.00	кг	20	\N
39958	2755	СВИНИНА ШЕЯ вес ТМ СибАгро	\N	\N	6385.00	уп (16 шт)	1	38	f	2025-11-23 22:32:40.255	2025-12-06 02:48:51.249	347.00	кг	16	\N
39984	2755	САРДЕЛЬКИ Вес 10кг Мусульманские ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2588.00	уп (10 шт)	1	100	f	2025-11-23 22:32:41.3	2025-12-06 02:48:51.249	225.00	кг	10	\N
40006	2755	ЯЙЦО пищевое С1  ПФ Уссурийская  ТОЛЬКО МЕСТАМИ *	\N	\N	3519.00	уп (360 шт)	1	500	f	2025-11-23 22:32:42.277	2025-12-06 02:48:51.249	8.50	шт	360	\N
40067	2755	КАЛЬМАР КОЛЬЦА 500гр с/м Китай	\N	\N	6969.00	уп (20 шт)	1	199	f	2025-11-23 22:32:44.857	2025-12-06 02:48:51.249	303.00	шт	20	\N
40224	2755	ГОРБУША тушка п/к ВЕС (в/уп)  РПЗ ТАНДЕМ	\N	\N	531.00	кг	1	19	f	2025-11-23 22:32:51.892	2025-12-06 02:48:51.249	462.00	кг	\N	\N
40370	2755	СМЕСЬ ЛЕЧО ( перец,помидор,лку,морковь,кабачок) вес Россия	\N	\N	2012.00	уп (10 шт)	1	430	f	2025-11-23 22:32:58.357	2025-12-06 02:48:51.249	175.00	кг	10	\N
54415	3367	САЛАТ 100гр из Баклажанов с капустой "По-Корейски" в/уп ТМ Рыбный День	\N	\N	4175.00	шт	1	146	t	2025-12-07 13:19:47.478	2025-12-07 13:19:47.478	139.00	шт	30	поштучно
54416	3367	САЛАТ 100гр из Кальмара с морковью "По-Корейски" в/уп ТМ Рыбный День	\N	\N	6210.00	шт	1	159	t	2025-12-07 13:19:47.491	2025-12-07 13:19:47.491	207.00	шт	30	поштучно
54417	3367	САЛАТ 100гр из Моркови "По-Корейски"  в/уп ТМ Рыбный День	\N	\N	2346.00	шт	1	200	t	2025-12-07 13:19:47.508	2025-12-07 13:19:47.508	78.00	шт	30	поштучно
54418	3367	САЛАТ 100гр из Морских водорослей "Чука" пл/лоток ТМ Рыбный День	\N	\N	4278.00	шт	1	173	t	2025-12-07 13:19:47.523	2025-12-07 13:19:47.523	143.00	шт	30	поштучно
54419	3367	САЛАТ 100гр из Папоротника "По-Корейски " пл/лоток ТМ Рыбный День	\N	\N	4865.00	шт	1	200	t	2025-12-07 13:19:47.537	2025-12-07 13:19:47.537	162.00	шт	30	поштучно
54420	3367	САЛАТ 150гр из Баклажанов "По-Корейски" пл/лоток ТМ Рыбный День	\N	\N	5060.00	шт	1	166	t	2025-12-07 13:19:47.548	2025-12-07 13:19:47.548	253.00	шт	20	поштучно
54421	3367	САЛАТ 150гр из Кальмара "По-Восточному" пл/лоток ТМ Рыбный День	\N	\N	8188.00	шт	1	200	t	2025-12-07 13:19:47.558	2025-12-07 13:19:47.558	409.00	шт	20	поштучно
54422	3367	САЛАТ 150гр из Кальмара "По-Корейски"  пл/лоток ТМ Рыбный День	\N	\N	9407.00	шт	1	190	t	2025-12-07 13:19:47.569	2025-12-07 13:19:47.569	470.00	шт	20	поштучно
54423	3367	САЛАТ 150гр из Мидии по-Корейски ТМ Рыбный День	\N	\N	8878.00	шт	1	147	t	2025-12-07 13:19:47.58	2025-12-07 13:19:47.58	444.00	шт	20	поштучно
54424	3367	САЛАТ 150гр из Моркови "По-Корейски"  пл/лоток ТМ Рыбный День	\N	\N	2369.00	шт	1	200	t	2025-12-07 13:19:47.592	2025-12-07 13:19:47.592	118.00	шт	20	поштучно
54425	3367	САЛАТ 150гр из Моркови с Грибами "По-Корейски"  пл/лоток ТМ Рыбный День	\N	\N	3082.00	шт	1	200	t	2025-12-07 13:19:47.612	2025-12-07 13:19:47.612	154.00	шт	20	поштучно
54426	3367	САЛАТ 150гр из Морской Капусты  "По-Восточному"  пл/лоток ТМ Рыбный День	\N	\N	2070.00	шт	1	130	t	2025-12-07 13:19:47.622	2025-12-07 13:19:47.622	103.00	шт	20	поштучно
54427	3367	САЛАТ 150гр из Морской Капусты  пл/лоток ТМ Рыбный День	\N	\N	2093.00	шт	1	200	t	2025-12-07 13:19:47.716	2025-12-07 13:19:47.716	105.00	шт	20	поштучно
54428	3367	САЛАТ 150гр из Морской Капусты "По-Восточному" с кальмаром пл/лоток ТМ Рыбный День	\N	\N	3818.00	шт	1	200	t	2025-12-07 13:19:47.73	2025-12-07 13:19:47.73	191.00	шт	20	поштучно
54429	3367	САЛАТ 150гр из Морской Капусты" Юбилейный " с кальмаром  пл/лоток ТМ Рыбный День	\N	\N	3956.00	шт	1	200	t	2025-12-07 13:19:47.741	2025-12-07 13:19:47.741	198.00	шт	20	поштучно
54430	3367	САЛАТ 150гр из Папоротника "По-Корейски " пл/лоток ТМ Рыбный День	\N	\N	5037.00	шт	1	200	t	2025-12-07 13:19:47.752	2025-12-07 13:19:47.752	252.00	шт	20	поштучно
54453	3367	ТРУБАЧ филе мороженый очищенный  500гр в/уп коробка РПЗ ТАНДЕМ	\N	\N	1518.00	шт	1	300	t	2025-12-07 13:19:48.089	2025-12-07 13:19:48.089	1518.00	шт	1	поштучно
54454	3367	ФАРШ Лосось мороженый 500гр (в/уп) РПЗ ТАНДЕМ	\N	\N	9729.00	шт	1	300	t	2025-12-07 13:19:48.1	2025-12-07 13:19:48.1	270.00	шт	36	поштучно
54455	3367	ФИЛЕ ГОРБУШИ св/морож 1кг (в/уп) РПЗ ТАНДЕМ	\N	\N	13156.00	шт	1	113	t	2025-12-07 13:19:48.111	2025-12-07 13:19:48.111	822.00	шт	16	поштучно
54456	3367	ФИЛЕ КЕТЫ  св/морож вес (1шт~300-500гр) (скин/уп) РПЗ ТАНДЕМ	\N	\N	994.00	кг	1	86	t	2025-12-07 13:19:48.122	2025-12-07 13:19:48.122	994.00	кг	1	поштучно
54457	3399	НАБОР к пиву Лососевый закусочный (Горбуша, Кета) 100гр в/уп РПЗ ТАНДЕМ	\N	\N	8211.00	шт	1	276	t	2025-12-07 13:19:48.133	2025-12-07 13:19:48.133	117.00	шт	70	поштучно
54458	3399	СОЛОМКА Лосось суш/вяленая ароматная 70гр пакет в/у	\N	\N	31050.00	шт	1	300	t	2025-12-07 13:19:48.143	2025-12-07 13:19:48.143	155.00	шт	200	поштучно
54459	3399	СОЛОМКА Минтай суш/вяленая 100гр пакет РПЗ ТАНДЕМ	\N	\N	5681.00	шт	1	174	t	2025-12-07 13:19:48.154	2025-12-07 13:19:48.154	284.00	шт	20	поштучно
54460	3367	ГОРБУША боковник п/к 250гр (в/уп) РПЗ ТАНДЕМ	\N	\N	9706.00	шт	1	54	t	2025-12-07 13:19:48.165	2025-12-07 13:19:48.165	243.00	шт	40	поштучно
54461	3367	КЕТА брюшки м/с 300гр (в/уп) РПЗ ТАНДЕМ	\N	\N	28462.00	шт	1	300	t	2025-12-07 13:19:48.2	2025-12-07 13:19:48.2	569.00	шт	50	поштучно
54462	3367	КЕТА ф/кусок 100гр (в/уп) Юкола суш/вял с пряностью РПЗ ТАНДЕМ	\N	\N	20355.00	шт	1	51	t	2025-12-07 13:19:48.211	2025-12-07 13:19:48.211	339.00	шт	60	поштучно
54463	3367	КЕТА ф/кусок п/к 250гр (в/уп) РПЗ ТАНДЕМ	\N	\N	19320.00	шт	1	92	t	2025-12-07 13:19:48.222	2025-12-07 13:19:48.222	483.00	шт	40	поштучно
54464	3367	КЕТА ф/кусочки 230гр (пл/банка) Закусочные в масле с чесноком м/сол РПЗ ТАНДЕМ	\N	\N	17336.00	шт	1	83	t	2025-12-07 13:19:48.233	2025-12-07 13:19:48.233	385.00	шт	45	поштучно
54465	3367	КЕТА ф/ломтики 100гр (подложка) м/сол РПЗ ТАНДЕМ	\N	\N	17469.00	шт	1	260	t	2025-12-07 13:19:48.245	2025-12-07 13:19:48.245	250.00	шт	70	поштучно
54466	3367	КЕТА ф/ломтики 100гр (подложка) подкопченная ДВ РПЗ ТАНДЕМ	\N	\N	17469.00	шт	1	300	t	2025-12-07 13:19:48.257	2025-12-07 13:19:48.257	250.00	шт	70	поштучно
54467	3367	КЕТА ф/ломтики 230гр (пл/банка) м/сол в горчичном соусе РПЗ ТАНДЕМ	\N	\N	20183.00	шт	1	90	t	2025-12-07 13:19:48.27	2025-12-07 13:19:48.27	448.00	шт	45	поштучно
54468	3367	КЕТА ф/ломтики 230гр (пл/банка) м/сол в масле РПЗ ТАНДЕМ	\N	\N	20183.00	шт	1	57	t	2025-12-07 13:19:48.346	2025-12-07 13:19:48.346	448.00	шт	45	поштучно
54469	3367	КЕТА ф/ломтики 230гр (пл/банка) м/сол в масле с пряностями РПЗ ТАНДЕМ	\N	\N	26910.00	шт	1	50	t	2025-12-07 13:19:48.409	2025-12-07 13:19:48.409	448.00	шт	60	поштучно
54470	3367	КЕТА ф/ломтики 230гр (пл/банка) подкопченная в масле РПЗ ТАНДЕМ	\N	\N	20183.00	шт	1	180	t	2025-12-07 13:19:48.433	2025-12-07 13:19:48.433	448.00	шт	45	поштучно
54471	3367	СЕЛЬДЬ вес ароматная жирная (в/уп) РПЗ ТАНДЕМ	\N	\N	3723.00	кг	1	65	t	2025-12-07 13:19:48.443	2025-12-07 13:19:48.443	286.00	кг	13	поштучно
54472	3367	СЕЛЬДЬ вес ароматная ОЛЮТОРКА (в/уп)	\N	\N	493.00	кг	1	93	t	2025-12-07 13:19:48.473	2025-12-07 13:19:48.473	493.00	кг	1	поштучно
54473	3367	СЕЛЬДЬ вес малосоленая жирная (в/уп) РПЗ ТАНДЕМ	\N	\N	3220.00	кг	1	300	t	2025-12-07 13:19:48.528	2025-12-07 13:19:48.528	230.00	кг	14	поштучно
54474	3367	СЕЛЬДЬ вес малосоленая жирная в ведре 10кг РПЗ ТАНДЕМ	\N	\N	2277.00	уп (10 шт)	1	130	t	2025-12-07 13:19:48.543	2025-12-07 13:19:48.543	228.00	кг	10	только уп
54475	3367	СЕЛЬДЬ вес малосоленая ОЛЮТОРКА (в/уп)	\N	\N	493.00	кг	1	228	t	2025-12-07 13:19:48.57	2025-12-07 13:19:48.57	493.00	кг	1	поштучно
54476	3367	СЕЛЬДЬ вес малосоленая ОЛЮТОРКА (в/уп) РПЗ ТАНДЕМ	\N	\N	7567.00	кг	1	18	t	2025-12-07 13:19:48.584	2025-12-07 13:19:48.584	541.00	кг	14	поштучно
54477	3367	СЕЛЬДЬ вес с Пряностью "По-Голландски" тушка потрошен без головы (в/уп)  РПЗ ТАНДЕМ	\N	\N	4605.00	кг	1	233	t	2025-12-07 13:19:48.609	2025-12-07 13:19:48.609	329.00	кг	14	поштучно
54478	3367	СЕЛЬДЬ вес с Пряностью "По-Голландски" тушка потрошен без головы в ведре 5кг РПЗ ТАНДЕМ	\N	\N	1644.00	уп (5 шт)	1	50	t	2025-12-07 13:19:48.621	2025-12-07 13:19:48.621	329.00	кг	5	только уп
54479	3367	СЕЛЬДЬ вес с Пряностью "По-Шведски" (в/уп)  РПЗ ТАНДЕМ	\N	\N	3188.00	кг	1	213	t	2025-12-07 13:19:48.633	2025-12-07 13:19:48.633	228.00	кг	14	поштучно
54480	3367	СЕЛЬДЬ ф/кусочки 200гр (т/ф) в горчичном соусе РПЗ ТАНДЕМ	\N	\N	11077.00	шт	1	125	t	2025-12-07 13:19:48.643	2025-12-07 13:19:48.643	198.00	шт	56	поштучно
54481	3367	СЕЛЬДЬ ф/кусочки 200гр (т/ф) в масле РПЗ ТАНДЕМ	\N	\N	11077.00	шт	1	300	t	2025-12-07 13:19:48.654	2025-12-07 13:19:48.654	198.00	шт	56	поштучно
54482	3367	СЕЛЬДЬ ф/кусочки 200гр (т/ф) в томате РПЗ ТАНДЕМ	\N	\N	11077.00	шт	1	300	t	2025-12-07 13:19:48.664	2025-12-07 13:19:48.664	198.00	шт	56	поштучно
54483	3367	СЕЛЬДЬ ф/кусочки 200гр (т/ф) в укропном соусе РПЗ ТАНДЕМ	\N	\N	11077.00	шт	1	300	t	2025-12-07 13:19:48.681	2025-12-07 13:19:48.681	198.00	шт	56	поштучно
54484	3367	СЕЛЬДЬ ф/кусочки 230гр (пл/бан) в горчичном соусе  РПЗ ТАНДЕМ	\N	\N	11644.00	шт	1	300	t	2025-12-07 13:19:48.694	2025-12-07 13:19:48.694	259.00	шт	45	поштучно
54485	3367	СЕЛЬДЬ ф/кусочки 230гр (пл/бан) в масле РПЗ ТАНДЕМ	\N	\N	11644.00	шт	1	300	t	2025-12-07 13:19:48.718	2025-12-07 13:19:48.718	259.00	шт	45	поштучно
54486	3367	СЕЛЬДЬ ф/кусочки 230гр (пл/бан) в томатном соусе РПЗ ТАНДЕМ	\N	\N	11644.00	шт	1	300	t	2025-12-07 13:19:48.73	2025-12-07 13:19:48.73	259.00	шт	45	поштучно
54487	3367	СЕЛЬДЬ ф/кусочки 230гр (пл/бан) в укропном соусе РПЗ ТАНДЕМ	\N	\N	11644.00	шт	1	300	t	2025-12-07 13:19:48.74	2025-12-07 13:19:48.74	259.00	шт	45	поштучно
54488	3367	СЕЛЬДЬ филе Жирная Малосоленая 200гр (в/уп) РПЗ ТАНДЕМ	\N	\N	8901.00	шт	1	300	t	2025-12-07 13:19:48.75	2025-12-07 13:19:48.75	148.00	шт	60	поштучно
54489	3367	САЛАТ из морской капусты 150гр в/уп Здоровье с брусникой РПЗ ТАНДЕМ	\N	\N	9660.00	шт	1	285	t	2025-12-07 13:19:48.761	2025-12-07 13:19:48.761	121.00	шт	80	поштучно
54490	3367	САЛАТ из морской капусты 150гр в/уп РПЗ ТАНДЕМ	\N	\N	9844.00	шт	1	300	t	2025-12-07 13:19:48.771	2025-12-07 13:19:48.771	123.00	шт	80	поштучно
54491	3367	САЛАТ из морской капусты 150гр в/уп с икрой сельди РПЗ ТАНДЕМ	\N	\N	11960.00	шт	1	300	t	2025-12-07 13:19:48.782	2025-12-07 13:19:48.782	150.00	шт	80	поштучно
54492	3367	САЛАТ из морской капусты 150гр в/уп с мясом краба РПЗ ТАНДЕМ	\N	\N	19688.00	шт	1	180	t	2025-12-07 13:19:48.794	2025-12-07 13:19:48.794	246.00	шт	80	поштучно
54493	3367	САЛАТ из морской капусты 150гр в/уп с трубачом РПЗ ТАНДЕМ	\N	\N	13156.00	шт	1	258	t	2025-12-07 13:19:48.805	2025-12-07 13:19:48.805	164.00	шт	80	поштучно
54494	3367	САЛАТ из морской капусты 150гр в/уп Юбилейный с кальмаром РПЗ ТАНДЕМ	\N	\N	19412.00	шт	1	300	t	2025-12-07 13:19:48.816	2025-12-07 13:19:48.816	243.00	шт	80	поштучно
54495	3367	САЛАТ из морской капусты 200гр пл/банка Любимый с кальмаром в томате РПЗ ТАНДЕМ	\N	\N	13196.00	шт	1	299	t	2025-12-07 13:19:48.829	2025-12-07 13:19:48.829	293.00	шт	45	поштучно
54496	3367	САЛАТ из морской капусты 200гр пл/банка Солянка с кальмаром РПЗ ТАНДЕМ	\N	\N	13196.00	шт	1	300	t	2025-12-07 13:19:48.839	2025-12-07 13:19:48.839	293.00	шт	45	поштучно
54497	3367	САЛАТ из морской капусты 200гр т/форма Восточный РПЗ ТАНДЕМ	\N	\N	7535.00	шт	1	17	t	2025-12-07 13:19:48.851	2025-12-07 13:19:48.851	135.00	шт	56	поштучно
54498	3367	САЛАТ из морской капусты 200гр т/форма Острая Закуска РПЗ ТАНДЕМ	\N	\N	7857.00	шт	1	300	t	2025-12-07 13:19:48.862	2025-12-07 13:19:48.862	140.00	шт	56	поштучно
54499	3367	САЛАТ из морской капусты 200гр т/форма с сельдью в морковно-томат соусе РПЗ ТАНДЕМ	\N	\N	7857.00	шт	1	300	t	2025-12-07 13:19:48.876	2025-12-07 13:19:48.876	140.00	шт	56	поштучно
54500	3395	ИНДЕЙКА ПО-БУРГУНСКИ 600гр пакет ТМ 4 Сезона	\N	\N	5327.00	шт	1	21	t	2025-12-07 13:19:48.894	2025-12-07 13:19:48.894	444.00	шт	12	поштучно
54501	3395	КУРОЧКА по-ПЕКИНСКИ китайское блюдо (рис, грудка кур, морковь, чёрный китайский гриб, бамбук, ростки маш, зел горошек, приправы) 600гр пакет ТМ 4 Сезона	\N	\N	5203.00	шт	1	111	t	2025-12-07 13:19:48.907	2025-12-07 13:19:48.907	434.00	шт	12	поштучно
54502	3395	ПАЭЛЬЯ испанское блюдо (рис, грудка кур, креветки, мидии, кальмар) 600гр пакет ТМ 4 Сезона СНИЖЕНИЕ ЦЕНЫ	\N	\N	7204.00	шт	1	58	t	2025-12-07 13:19:48.917	2025-12-07 13:19:48.917	600.00	шт	12	поштучно
54503	3395	ПЕННЕ КАРБОНАРА итальянское блюдо (макароны, ветчина, шампиньоны, горошек, сыр) 600гр пакет ТМ 4 Сезона СНИЖЕНИЕ ЦЕНЫ	\N	\N	5672.00	шт	1	43	t	2025-12-07 13:19:48.928	2025-12-07 13:19:48.928	473.00	шт	12	поштучно
54504	3395	ПРИМА ВЕРДЕ итальянское  блюдо (макароны, грудка кур, шпинат, цукини, томаты, сыр, специи) 600гр пакет ТМ 4 Сезона СНИЖЕНИЕ ЦЕНЫ	\N	\N	6486.00	шт	1	118	t	2025-12-07 13:19:48.939	2025-12-07 13:19:48.939	541.00	шт	12	поштучно
54505	3395	РИЗОТТО с МОРЕПРОДУКТАМИ итальянское блюдо (рис,  кальмары, мясо мидий, осьминоги, креветки, лук, приправы) 600гр пакет ТМ 4 Сезона СНИЖЕНИЕ ЦЕНЫ	\N	\N	8970.00	шт	1	58	t	2025-12-07 13:19:48.949	2025-12-07 13:19:48.949	747.00	шт	12	поштучно
54506	3395	ФОНДЮ ЭМЕНТАЛЬ швейцарское блюдо (макароны, грудка, грибы, броколи, сыр) 600гр пакет ТМ 4 Сезона	\N	\N	7673.00	шт	1	113	t	2025-12-07 13:19:48.959	2025-12-07 13:19:48.959	639.00	шт	12	поштучно
54507	3395	ЦЫПЛЕНОК ПО-МЕКСИКАНСКИ латиноамериканское блюдо (картофель, грудка кур, красная фасоль, зелёная стручковая фасоль, зёрна кукурузы, сладкий перец, лук) 600гр пакет ТМ 4 Сезона	\N	\N	5272.00	шт	1	81	t	2025-12-07 13:19:48.972	2025-12-07 13:19:48.972	439.00	шт	12	поштучно
54508	3395	ШАМПИНЬОНЫ де ПАРИ французское блюдо (картофель, грудка кур, шампиньоны, зелёная стручковая фасоль, томаты, лук) 600гр пакет ТМ 4 Сезона	\N	\N	5272.00	шт	1	71	t	2025-12-07 13:19:48.983	2025-12-07 13:19:48.983	439.00	шт	12	поштучно
54509	3395	Якисоба 600гр пакет ТМ 4 Сезона	\N	\N	5368.00	шт	1	44	t	2025-12-07 13:19:48.993	2025-12-07 13:19:48.993	447.00	шт	12	поштучно
54510	3395	КАРТОФЕЛЬ для жарки 450гр ТМ Морозко Green	\N	\N	2061.00	шт	1	136	t	2025-12-07 13:19:49.003	2025-12-07 13:19:49.003	129.00	шт	16	поштучно
54511	3395	КАРТОФЕЛЬ По-Деревенски 700гр ТМ 4 Сезона	\N	\N	3864.00	шт	1	170	t	2025-12-07 13:19:49.013	2025-12-07 13:19:49.013	322.00	шт	12	поштучно
54512	3395	КАРТОФЕЛЬ Фри 2,5кг 10мм Прямой 1/4шт ТМ Вичи	\N	\N	3565.00	шт	1	200	t	2025-12-07 13:19:49.032	2025-12-07 13:19:49.032	891.00	шт	4	поштучно
54513	3395	КАРТОФЕЛЬ Фри 2,5кг 6мм с панировкой Фрай Ми ТМ Ви Фрай	\N	\N	5020.00	шт	1	75	t	2025-12-07 13:19:49.043	2025-12-07 13:19:49.043	1004.00	шт	5	поштучно
54514	3395	КАРТОФЕЛЬ Фри 2,5кг 6мм Триумф ТМ Ви Фрай	\N	\N	5020.00	шт	1	200	t	2025-12-07 13:19:49.065	2025-12-07 13:19:49.065	1004.00	шт	5	поштучно
54515	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм  обжаренный ТМ ООО БИЛД	\N	\N	3179.00	шт	1	184	t	2025-12-07 13:19:49.088	2025-12-07 13:19:49.088	795.00	шт	4	поштучно
54516	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм  ТМ Fine Food	\N	\N	7666.00	шт	1	94	t	2025-12-07 13:19:49.101	2025-12-07 13:19:49.101	1278.00	шт	6	поштучно
54517	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм с панировкой ТМ Lamb Weston	\N	\N	4842.00	шт	1	200	t	2025-12-07 13:19:49.111	2025-12-07 13:19:49.111	968.00	шт	5	поштучно
54518	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм Сладкий Батат в панировке ТМ ТМ Ви Фрай	\N	\N	9355.00	шт	1	61	t	2025-12-07 13:19:49.122	2025-12-07 13:19:49.122	1871.00	шт	5	поштучно
54519	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм Триумф ТМ Ви Фрай	\N	\N	5221.00	шт	1	200	t	2025-12-07 13:19:49.133	2025-12-07 13:19:49.133	1044.00	шт	5	поштучно
54525	3395	КАРТОФЕЛЬНЫЕ Cтрипсы 2,5кг с луком и черным перцем ТМ Ви Фрай	\N	\N	5894.00	шт	1	50	t	2025-12-07 13:19:49.233	2025-12-07 13:19:49.233	1179.00	шт	5	поштучно
54526	3395	КАРТОФЕЛЬНЫЕ Бруски вес	\N	\N	2766.00	кг	1	200	t	2025-12-07 13:19:49.245	2025-12-07 13:19:49.245	213.00	кг	13	поштучно
54527	3395	КАРТОФЕЛЬНЫЕ Дольки 2,5кг в кожуре Astrafray ТМ ООО БИЛД	\N	\N	3179.00	шт	1	13	t	2025-12-07 13:19:49.256	2025-12-07 13:19:49.256	795.00	шт	4	поштучно
54528	3395	КАРТОФЕЛЬНЫЕ Дольки 2,5кг в кожуре со специями ТМ Ви Фрай	\N	\N	6290.00	шт	1	200	t	2025-12-07 13:19:49.305	2025-12-07 13:19:49.305	1258.00	шт	5	поштучно
54529	3395	КАРТОФЕЛЬНЫЕ Дольки 2,5кг в кожуре ТМ Ви Фрай	\N	\N	5503.00	шт	1	200	t	2025-12-07 13:19:49.316	2025-12-07 13:19:49.316	1101.00	шт	5	поштучно
54530	3395	КАРТОФЕЛЬНЫЕ Дольки в кожуре вес	\N	\N	3381.00	кг	1	84	t	2025-12-07 13:19:49.337	2025-12-07 13:19:49.337	241.00	кг	14	поштучно
54531	3395	ЛУКОВЫЕ Луковые кольца 1,5кг в панировке ТМ Ozgorkey Feast	\N	\N	5313.00	шт	1	156	t	2025-12-07 13:19:49.367	2025-12-07 13:19:49.367	885.00	шт	6	поштучно
54532	3395	Сырные палочки Моцарелла в панировке 1кг ТМ Фрост-А	\N	\N	9867.00	шт	1	200	t	2025-12-07 13:19:49.377	2025-12-07 13:19:49.377	987.00	шт	10	поштучно
54533	3395	ГОРОХ зеленый 400гр ТМ 4 Сезона	\N	\N	2806.00	шт	1	200	t	2025-12-07 13:19:49.388	2025-12-07 13:19:49.388	140.00	шт	20	поштучно
54534	3395	ГОРОХ зеленый 400гр ТМ Бондюэль	\N	\N	2153.00	шт	1	56	t	2025-12-07 13:19:49.398	2025-12-07 13:19:49.398	179.00	шт	12	поштучно
54535	3395	ГРИБЫ ГРИБНОЕ ассорти (лесные грибы, шампиньоны) 400гр ТМ 4 Сезона	\N	\N	8050.00	шт	1	200	t	2025-12-07 13:19:49.409	2025-12-07 13:19:49.409	402.00	шт	20	поштучно
54536	3395	ГРИБЫ шампиньоны резаные 400гр ТМ 4 Сезона	\N	\N	3220.00	шт	1	200	t	2025-12-07 13:19:49.427	2025-12-07 13:19:49.427	161.00	шт	20	поштучно
54537	3395	ГРИБЫ шампиньоны резаные 400гр ТМ ТМ Морозко Green	\N	\N	2208.00	шт	1	138	t	2025-12-07 13:19:49.438	2025-12-07 13:19:49.438	138.00	шт	16	поштучно
54538	3395	КАПУСТА брокколи 400гр ТМ 4 Сезона	\N	\N	5428.00	шт	1	200	t	2025-12-07 13:19:49.448	2025-12-07 13:19:49.448	271.00	шт	20	поштучно
54539	3395	КАПУСТА брокколи 400гр ТМ Морозко Green	\N	\N	3588.00	шт	1	92	t	2025-12-07 13:19:49.458	2025-12-07 13:19:49.458	224.00	шт	16	поштучно
54540	3395	КАПУСТА брюссельская 400гр ТМ 4 Сезона	\N	\N	5428.00	шт	1	200	t	2025-12-07 13:19:49.474	2025-12-07 13:19:49.474	271.00	шт	20	поштучно
54541	3395	КАПУСТА цветная 30-60мм 400гр ТМ Бондюэль	\N	\N	2318.00	шт	1	162	t	2025-12-07 13:19:49.485	2025-12-07 13:19:49.485	193.00	шт	12	поштучно
54542	3395	КАПУСТА цветная 400гр ТМ 4 Сезона	\N	\N	3703.00	шт	1	200	t	2025-12-07 13:19:49.497	2025-12-07 13:19:49.497	185.00	шт	20	поштучно
54543	3395	КАПУСТА цветная 400гр ТМ Морозко Green	\N	\N	2760.00	шт	1	62	t	2025-12-07 13:19:49.507	2025-12-07 13:19:49.507	173.00	шт	16	поштучно
54544	3395	КАПУСТА цветная мини 10-20мм 300гр ТМ Бондюэль	\N	\N	2167.00	шт	1	153	t	2025-12-07 13:19:49.517	2025-12-07 13:19:49.517	181.00	шт	12	поштучно
54545	3395	ЛЕЧО 400гр ТМ 4 Сезона	\N	\N	3243.00	шт	1	200	t	2025-12-07 13:19:49.531	2025-12-07 13:19:49.531	162.00	шт	20	поштучно
54546	3395	ОВОЩИ Весенние 400гр ТМ 4 Сезона	\N	\N	3013.00	шт	1	200	t	2025-12-07 13:19:49.543	2025-12-07 13:19:49.543	151.00	шт	20	поштучно
54547	3395	ОВОЩИ для жарки с шампиньонами 400гр ТМ 4 Сезона	\N	\N	3588.00	шт	1	200	t	2025-12-07 13:19:49.553	2025-12-07 13:19:49.553	179.00	шт	20	поштучно
54548	3395	ОВОЩИ Летние 400гр ТМ 4 Сезона	\N	\N	3312.00	шт	1	200	t	2025-12-07 13:19:49.567	2025-12-07 13:19:49.567	166.00	шт	20	поштучно
54549	3395	ОВОЩИ по-азиатски Вок  (Перец сл. капуста цв. фасоль стр. шамп рез) 400гр ТМ Бондюэль	\N	\N	3188.00	шт	1	200	t	2025-12-07 13:19:49.577	2025-12-07 13:19:49.577	266.00	шт	12	поштучно
54550	3395	ОВОЩИ По-Деревенски 400гр ТМ 4 Сезона	\N	\N	3220.00	шт	1	200	t	2025-12-07 13:19:49.589	2025-12-07 13:19:49.589	161.00	шт	20	поштучно
54551	3395	ОВОЩИ по-индийски Сабджи (Брокколи. брюссельская. картофель. морковь) 400гр ТМ Бондюэль	\N	\N	3188.00	шт	1	200	t	2025-12-07 13:19:49.611	2025-12-07 13:19:49.611	266.00	шт	12	поштучно
54552	3395	ОВОЩИ по-итальянски Орзотто (Крупа перл. брокколи. томаты. перец сл) 400гр ТМ Бондюэль	\N	\N	3409.00	шт	1	170	t	2025-12-07 13:19:49.622	2025-12-07 13:19:49.622	284.00	шт	12	поштучно
54553	3395	ОВОЩИ по-китайски Мунг (Бобы мунг. перец сл. грибы шамп. шиитаке) 400гр ТМ Бондюэль	\N	\N	3409.00	шт	1	128	t	2025-12-07 13:19:49.655	2025-12-07 13:19:49.655	284.00	шт	12	поштучно
54554	3395	ОВОЩИ по-мароккански Тажин (Нут. кабачок. шампиньоны. томаты) 400гр ТМ Бондюэль	\N	\N	3409.00	шт	1	132	t	2025-12-07 13:19:49.708	2025-12-07 13:19:49.708	284.00	шт	12	поштучно
54555	3395	ОВОЩИ по-турецки Фасулье (Капуста цветная. брокколи. фасоль струч) 400гр ТМ Бондюэль	\N	\N	3215.00	шт	1	6	t	2025-12-07 13:19:49.72	2025-12-07 13:19:49.72	268.00	шт	12	поштучно
54556	3395	ПЕРЕЦ сладкий резаный 400гр ТМ 4 Сезона	\N	\N	2737.00	шт	1	200	t	2025-12-07 13:19:49.733	2025-12-07 13:19:49.733	137.00	шт	20	поштучно
54557	3395	РАГУ ОВОЩНОЕ 400гр ТМ 4 Сезона	\N	\N	2852.00	шт	1	200	t	2025-12-07 13:19:49.767	2025-12-07 13:19:49.767	143.00	шт	20	поштучно
54558	3395	СМЕСЬ Восточная 400гр ТМ 4 Сезона	\N	\N	3450.00	шт	1	198	t	2025-12-07 13:19:49.792	2025-12-07 13:19:49.792	173.00	шт	20	поштучно
54559	3395	СМЕСЬ Гавайская 400гр ТМ 4 Сезона	\N	\N	3427.00	шт	1	200	t	2025-12-07 13:19:49.821	2025-12-07 13:19:49.821	171.00	шт	20	поштучно
54560	3395	СМЕСЬ Гавайский микс (Рис, горошек, кукуруза. перец сладкий) 400гр ТМ Бондюэль	\N	\N	2291.00	шт	1	200	t	2025-12-07 13:19:49.834	2025-12-07 13:19:49.834	191.00	шт	12	поштучно
54561	3395	СМЕСЬ Калифорния 400гр ТМ 4 Сезона	\N	\N	3519.00	шт	1	200	t	2025-12-07 13:19:49.847	2025-12-07 13:19:49.847	176.00	шт	20	поштучно
54562	3395	СМЕСЬ Китайская 400гр ТМ 4 Сезона	\N	\N	4002.00	шт	1	200	t	2025-12-07 13:19:49.86	2025-12-07 13:19:49.86	200.00	шт	20	поштучно
54563	3395	СМЕСЬ Мексиканская 400гр ТМ 4 Сезона	\N	\N	3427.00	шт	1	200	t	2025-12-07 13:19:49.873	2025-12-07 13:19:49.873	171.00	шт	20	поштучно
54564	3395	СМЕСЬ Мексиканский микс (Рис. кукуруза. горошек. фасоль струч.) 400гр ТМ Бондюэль	\N	\N	2167.00	шт	1	200	t	2025-12-07 13:19:49.885	2025-12-07 13:19:49.885	181.00	шт	12	поштучно
54565	3395	СМЕСЬ Овощная рис из цветной капусты с грибами и травами 400гр ТМ Бондюэль	\N	\N	3119.00	шт	1	200	t	2025-12-07 13:19:49.896	2025-12-07 13:19:49.896	260.00	шт	12	поштучно
54566	3395	СМЕСЬ Овощная рис из цветной капусты с летними овощами и травами 400гр ТМ Бондюэль	\N	\N	3119.00	шт	1	200	t	2025-12-07 13:19:49.908	2025-12-07 13:19:49.908	260.00	шт	12	поштучно
54567	3395	СМЕСЬ Овощной микс с кабачком завтрак 200гр ТМ Бондюэль	\N	\N	3091.00	шт	1	200	t	2025-12-07 13:19:49.918	2025-12-07 13:19:49.918	129.00	шт	24	поштучно
54568	3395	СМЕСЬ Овощной микс с томатами завтрак 200гр ТМ Бондюэль	\N	\N	3091.00	шт	1	200	t	2025-12-07 13:19:49.929	2025-12-07 13:19:49.929	129.00	шт	24	поштучно
54569	3395	СМЕСЬ Сибирская 400гр ТМ 4 Сезона	\N	\N	4209.00	шт	1	200	t	2025-12-07 13:19:49.94	2025-12-07 13:19:49.94	210.00	шт	20	поштучно
54570	3395	СМЕСЬ Скандинавская 400гр ТМ 4 Сезона	\N	\N	3795.00	шт	1	200	t	2025-12-07 13:19:49.95	2025-12-07 13:19:49.95	190.00	шт	20	поштучно
54571	3395	СУП БОРЩ Московский (свёкла, белокочанная капуста, перец, томаты, картофель, морковь, лук) 400гр ТМ 4 Сезона	\N	\N	2760.00	шт	1	200	t	2025-12-07 13:19:49.96	2025-12-07 13:19:49.96	138.00	шт	20	поштучно
54572	3395	СУП ГРИБНОЙ (картофель, шампиньоны, морковь, лук) 400гр ТМ 4 Сезона	\N	\N	2944.00	шт	1	187	t	2025-12-07 13:19:49.977	2025-12-07 13:19:49.977	147.00	шт	20	поштучно
54573	3395	СУП ЩАВЕЛЬНЫЙ (щавель, картофель, морковь, лук) 400гр ТМ 4 Сезона	\N	\N	4094.00	шт	1	200	t	2025-12-07 13:19:49.996	2025-12-07 13:19:49.996	205.00	шт	20	поштучно
54574	3395	СУП-КРЕМ с цветной капустой 350гр ТМ Бондюэль	\N	\N	2829.00	шт	1	172	t	2025-12-07 13:19:50.015	2025-12-07 13:19:50.015	236.00	шт	12	поштучно
54575	3395	СУП-КРЕМ с шампиньонами 350гр ТМ Бондюэль	\N	\N	2829.00	шт	1	200	t	2025-12-07 13:19:50.027	2025-12-07 13:19:50.027	236.00	шт	12	поштучно
54576	3395	ТЫКВА нарезанная 400гр ТМ 4 Сезона	\N	\N	2323.00	шт	1	200	t	2025-12-07 13:19:50.04	2025-12-07 13:19:50.04	116.00	шт	20	поштучно
54577	3395	ФАСОЛЬ стручковая зеленая 400гр ТМ 4 Сезона	\N	\N	2806.00	шт	1	200	t	2025-12-07 13:19:50.051	2025-12-07 13:19:50.051	140.00	шт	20	поштучно
54578	3395	ФАСОЛЬ стручковаяи 400гр ТМ Морозко Green	\N	\N	2208.00	шт	1	161	t	2025-12-07 13:19:50.063	2025-12-07 13:19:50.063	138.00	шт	16	поштучно
54579	3395	ФАСОЛЬ тонкая зеленая целая 400гр ТМ Бондюэль	\N	\N	1656.00	шт	1	200	t	2025-12-07 13:19:50.073	2025-12-07 13:19:50.073	138.00	шт	12	поштучно
54580	3395	ФАСОЛЬ экстра-тонкая зеленая целая 400гр ТМ Бондюэль	\N	\N	1656.00	шт	1	167	t	2025-12-07 13:19:50.086	2025-12-07 13:19:50.086	138.00	шт	12	поштучно
54581	3395	ШПИНАТ резан 400гр ТМ 4 Сезона	\N	\N	5175.00	шт	1	200	t	2025-12-07 13:19:50.097	2025-12-07 13:19:50.097	259.00	шт	20	поштучно
54582	3395	ГОРОШЕК зелёный вес Россия	\N	\N	4054.00	уп (15 шт)	1	35	t	2025-12-07 13:19:50.108	2025-12-07 13:19:50.108	270.00	кг	15	только уп
54583	3395	ГРИБЫ АССОРТИ Сказки Лукоморья резанные вес Россия	\N	\N	5049.00	уп (10 шт)	1	20	t	2025-12-07 13:19:50.12	2025-12-07 13:19:50.12	505.00	кг	10	только уп
54584	3395	ГРИБЫ ОПЯТА вес Китай	\N	\N	4025.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.13	2025-12-07 13:19:50.13	402.00	кг	10	только уп
54585	3395	ГРИБЫ ШАМПИНЬОНЫ резаные вес Беларусь	\N	\N	2760.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.142	2025-12-07 13:19:50.142	276.00	кг	10	только уп
54586	3395	ГРИБЫ ШАМПИНЬОНЫ резаные вес Россия	\N	\N	2875.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.174	2025-12-07 13:19:50.174	288.00	кг	10	только уп
54587	3395	ГРИБЫ ШАМПИНЬОНЫ целые  вес РОССИЯ	\N	\N	2935.00	уп (8 шт)	1	288	t	2025-12-07 13:19:50.23	2025-12-07 13:19:50.23	367.00	кг	8	только уп
54588	3395	ГРИБЫ ШАМПИНЬОНЫ целые вес Россия	\N	\N	2875.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.269	2025-12-07 13:19:50.269	288.00	кг	10	только уп
54589	3395	КАБАЧКИ кубик резаные вес Россия	\N	\N	1656.00	уп (10 шт)	1	10	t	2025-12-07 13:19:50.281	2025-12-07 13:19:50.281	166.00	кг	10	только уп
54590	3395	КАПУСТА БРОККОЛИ вес Египет	\N	\N	2519.00	уп (10 шт)	1	180	t	2025-12-07 13:19:50.383	2025-12-07 13:19:50.383	252.00	кг	10	только уп
54591	3395	КАПУСТА БРОККОЛИ вес Китай	\N	\N	2519.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.406	2025-12-07 13:19:50.406	252.00	кг	10	только уп
54592	3395	КАПУСТА БРОККОЛИ вес Россия	\N	\N	1759.00	уп (9 шт)	1	500	t	2025-12-07 13:19:50.419	2025-12-07 13:19:50.419	207.00	кг	9	только уп
54593	3395	КАПУСТА БРЮССЕЛЬСКАЯ  вес	\N	\N	3749.00	уп (10 шт)	1	70	t	2025-12-07 13:19:50.43	2025-12-07 13:19:50.43	375.00	кг	10	только уп
54594	3395	КАПУСТА Романеско вес Россия	\N	\N	2571.00	уп (9 шт)	1	68	t	2025-12-07 13:19:50.453	2025-12-07 13:19:50.453	302.00	кг	9	только уп
54595	3395	КАПУСТА ЦВЕТНАЯ  вес Узбекистан	\N	\N	2818.00	уп (10 шт)	1	30	t	2025-12-07 13:19:50.466	2025-12-07 13:19:50.466	282.00	кг	10	только уп
54596	3395	КАПУСТА ЦВЕТНАЯ вес Россия	\N	\N	2519.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.533	2025-12-07 13:19:50.533	252.00	кг	10	только уп
54597	3395	КУКУРУЗА зерно вес Россия	\N	\N	3852.00	уп (10 шт)	1	30	t	2025-12-07 13:19:50.559	2025-12-07 13:19:50.559	385.00	кг	10	только уп
54598	3395	КУКУРУЗА зерно вес Сербия	\N	\N	3795.00	уп (10 шт)	1	90	t	2025-12-07 13:19:50.575	2025-12-07 13:19:50.575	379.00	кг	10	только уп
54599	3395	КУКУРУЗА початки вес Индия	\N	\N	5046.00	уп (14 шт)	1	500	t	2025-12-07 13:19:50.589	2025-12-07 13:19:50.589	374.00	кг	14	только уп
54600	3395	КУКУРУЗА початки вес Россия	\N	\N	1801.00	уп (9 шт)	1	144	t	2025-12-07 13:19:50.626	2025-12-07 13:19:50.626	200.00	кг	9	только уп
54601	3395	МОРКОВЬ кубики вес Россия	\N	\N	2251.00	уп (14 шт)	1	27	t	2025-12-07 13:19:50.648	2025-12-07 13:19:50.648	167.00	кг	14	только уп
54603	3395	МОРКОВЬ мини вес Китай	\N	\N	3795.00	уп (10 шт)	1	50	t	2025-12-07 13:19:50.672	2025-12-07 13:19:50.672	379.00	кг	10	только уп
54604	3395	ОВОЩИ ДЛЯ ЖАРКИ с картошкой и грибами вес Россия	\N	\N	2519.00	уп (10 шт)	1	40	t	2025-12-07 13:19:50.685	2025-12-07 13:19:50.685	252.00	кг	10	только уп
54605	3395	ОВОЩИ ДЛЯ ЖАРКИ с шампиньонами  вес Россия	\N	\N	2473.00	уп (10 шт)	1	360	t	2025-12-07 13:19:50.705	2025-12-07 13:19:50.705	247.00	кг	10	только уп
54606	3395	ОВОЩИ ЛЕТНИЕ вес  (горошек,морковь,фасоль, цветная капуста) Россия	\N	\N	2369.00	уп (10 шт)	1	200	t	2025-12-07 13:19:50.729	2025-12-07 13:19:50.729	237.00	кг	10	только уп
54607	3395	ПЕРЕЦ ПОЛОСКИ микс (красный,зелёный,жёлтый) вес Россия	\N	\N	2277.00	уп (9 шт)	1	500	t	2025-12-07 13:19:50.742	2025-12-07 13:19:50.742	253.00	кг	9	только уп
54608	3395	ПЕРЕЦ ЦЕЛЫЙ микс (красный,зелёный,жёлтый)  вес Россия	\N	\N	1811.00	уп (7 шт)	1	145	t	2025-12-07 13:19:50.755	2025-12-07 13:19:50.755	259.00	кг	7	только уп
54609	3395	СМЕСЬ ГАВАЙСКАЯ (рис,горошек,кукуруза,перец зеленый и красный) вес Россия	\N	\N	2128.00	уп (10 шт)	1	160	t	2025-12-07 13:19:50.77	2025-12-07 13:19:50.77	213.00	кг	10	только уп
54610	3395	СМЕСЬ ЛЕЧО ( перец,помидор,лку,морковь,кабачок) вес Россия	\N	\N	2012.00	уп (10 шт)	1	200	t	2025-12-07 13:19:50.786	2025-12-07 13:19:50.786	201.00	кг	10	только уп
54611	3395	СМЕСЬ МЕКСИКАНСКАЯ (перец, морковь, фасоль, горошек, кукуруза, сельдерей, лук) вес Россия	\N	\N	2128.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.809	2025-12-07 13:19:50.809	213.00	кг	10	только уп
54612	3395	СМЕСЬ РАТАТУЙ ( баклажан,перец,кабачок) вес Россия	\N	\N	2220.00	уп (10 шт)	1	350	t	2025-12-07 13:19:50.827	2025-12-07 13:19:50.827	222.00	кг	10	только уп
54613	3395	СМЕСЬ ЦАРСКАЯ ( морковь,цветная капуста,брокколи) вес Россия	\N	\N	2737.00	уп (10 шт)	1	460	t	2025-12-07 13:19:50.843	2025-12-07 13:19:50.843	274.00	кг	10	только уп
54614	3395	ТЫКВА кубик вес Россия	\N	\N	2415.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.856	2025-12-07 13:19:50.856	241.00	кг	10	только уп
54615	3395	ФАСОЛЬ красная бланшированная вес Россия	\N	\N	5921.00	уп (19 шт)	1	76	t	2025-12-07 13:19:50.892	2025-12-07 13:19:50.892	312.00	кг	19	только уп
54616	3395	ФАСОЛЬ стручковая рез вес Египет	\N	\N	2116.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.909	2025-12-07 13:19:50.909	212.00	кг	10	только уп
54617	3395	АБРИКОСЫ половинки вес Россия	\N	\N	3346.00	уп (10 шт)	1	500	t	2025-12-07 13:19:50.923	2025-12-07 13:19:50.923	335.00	кг	10	только уп
54618	3395	БРУСНИКА вес КНР	\N	\N	6037.00	уп (10 шт)	1	420	t	2025-12-07 13:19:50.937	2025-12-07 13:19:50.937	604.00	кг	10	только уп
54619	3395	ВИШНЯ без косточки вес Киргизия	\N	\N	8257.00	уп (10 шт)	1	470	t	2025-12-07 13:19:50.955	2025-12-07 13:19:50.955	826.00	кг	10	только уп
54620	3395	ВИШНЯ без косточки вес Россия	\N	\N	8257.00	уп (10 шт)	1	130	t	2025-12-07 13:19:50.972	2025-12-07 13:19:50.972	826.00	кг	10	только уп
54621	3395	ГОЛУБИКА вес  Россия	\N	\N	8844.00	уп (10 шт)	1	300	t	2025-12-07 13:19:50.985	2025-12-07 13:19:50.985	884.00	кг	10	только уп
54622	3395	ГОЛУБИКА вес Китай	\N	\N	5980.00	уп (10 шт)	1	40	t	2025-12-07 13:19:51.001	2025-12-07 13:19:51.001	598.00	кг	10	только уп
54623	3395	ЕЖЕВИКА вес Россия	\N	\N	4543.00	уп (10 шт)	1	350	t	2025-12-07 13:19:51.016	2025-12-07 13:19:51.016	454.00	кг	10	только уп
54624	3395	ЕЖЕВИКА вес Сербия	\N	\N	5566.00	уп (10 шт)	1	50	t	2025-12-07 13:19:51.027	2025-12-07 13:19:51.027	557.00	кг	10	только уп
54625	3395	ЖИМОЛОСТЬ вес Китай	\N	\N	8349.00	уп (10 шт)	1	500	t	2025-12-07 13:19:51.047	2025-12-07 13:19:51.047	835.00	кг	10	только уп
54626	3395	КЛУБНИКА вес  Египет	\N	\N	3220.00	уп (10 шт)	1	500	t	2025-12-07 13:19:51.059	2025-12-07 13:19:51.059	322.00	кг	10	только уп
54627	3395	КЛЮКВА САДОВАЯ вес Россия	\N	\N	5394.00	уп (10 шт)	1	300	t	2025-12-07 13:19:51.081	2025-12-07 13:19:51.081	539.00	кг	10	только уп
54628	3395	КРЫЖОВНИК  вес Китай	\N	\N	3277.00	уп (10 шт)	1	30	t	2025-12-07 13:19:51.092	2025-12-07 13:19:51.092	328.00	кг	10	только уп
54629	3395	МАЛИНА Экстра вес 1/10кг Россия	\N	\N	8038.00	уп (10 шт)	1	500	t	2025-12-07 13:19:51.103	2025-12-07 13:19:51.103	804.00	кг	10	только уп
54630	3395	МАЛИНА ЭКСТРА вес 4*2,5кг Китай	\N	\N	7935.00	уп (10 шт)	1	500	t	2025-12-07 13:19:51.118	2025-12-07 13:19:51.118	793.00	кг	10	только уп
54631	3395	МАНГО вес  Китай	\N	\N	4025.00	уп (10 шт)	1	30	t	2025-12-07 13:19:51.128	2025-12-07 13:19:51.128	402.00	кг	10	только уп
54632	3395	ОБЛЕПИХА вес Китай	\N	\N	3392.00	уп (10 шт)	1	180	t	2025-12-07 13:19:51.146	2025-12-07 13:19:51.146	339.00	кг	10	только уп
54633	3395	ПЕРСИК половинки вес Китай	\N	\N	4876.00	уп (10 шт)	1	150	t	2025-12-07 13:19:51.158	2025-12-07 13:19:51.158	488.00	кг	10	только уп
54634	3395	СЛИВА половинки  вес Россия	\N	\N	3220.00	уп (10 шт)	1	360	t	2025-12-07 13:19:51.171	2025-12-07 13:19:51.171	322.00	кг	10	только уп
54635	3395	СМЕСЬ КОМПОТНАЯ ((абрикос,яблоко,слива) вес	\N	\N	2530.00	уп (10 шт)	1	500	t	2025-12-07 13:19:51.181	2025-12-07 13:19:51.181	253.00	кг	10	только уп
54636	3395	СМЕСЬ КОМПОТНАЯ Фруктово-Ягодная вес	\N	\N	2530.00	уп (10 шт)	1	500	t	2025-12-07 13:19:51.195	2025-12-07 13:19:51.195	253.00	кг	10	только уп
54637	3395	ЧЕРЕШНЯ без косточки вес Молдова	\N	\N	7739.00	уп (10 шт)	1	220	t	2025-12-07 13:19:51.206	2025-12-07 13:19:51.206	774.00	кг	10	только уп
54638	3395	ЧЕРНАЯ СМОРОДИНА  вес Россия	\N	\N	7820.00	уп (10 шт)	1	90	t	2025-12-07 13:19:51.217	2025-12-07 13:19:51.217	782.00	кг	10	только уп
54639	3395	ЧЕРНАЯ СМОРОДИНА вес Китай	\N	\N	7302.00	уп (10 шт)	1	500	t	2025-12-07 13:19:51.231	2025-12-07 13:19:51.231	730.00	кг	10	только уп
54640	3395	БРУСНИКА 300гр ТМ 4 Сезона	\N	\N	7705.00	шт	1	200	t	2025-12-07 13:19:51.304	2025-12-07 13:19:51.304	385.00	шт	20	поштучно
54641	3395	ВИШНЯ без косточки 300гр ТМ 4 Сезона	\N	\N	14297.00	шт	1	200	t	2025-12-07 13:19:51.316	2025-12-07 13:19:51.316	596.00	шт	24	поштучно
54642	3395	ВИШНЯ без косточки 300гр ТМ Морозко Green	\N	\N	7015.00	шт	1	52	t	2025-12-07 13:19:51.326	2025-12-07 13:19:51.326	351.00	шт	20	поштучно
54643	3395	КЛУБНИКА 300гр ТМ 4 Сезона	\N	\N	4453.00	шт	1	200	t	2025-12-07 13:19:51.373	2025-12-07 13:19:51.373	202.00	шт	22	поштучно
54644	3395	КЛУБНИКА 300гр ТМ Морозко Green	\N	\N	3841.00	шт	1	47	t	2025-12-07 13:19:51.384	2025-12-07 13:19:51.384	192.00	шт	20	поштучно
54645	3395	КЛЮКВА садовая 300гр ТМ 4 Сезона	\N	\N	10373.00	шт	1	70	t	2025-12-07 13:19:51.396	2025-12-07 13:19:51.396	471.00	шт	22	поштучно
54646	3395	МАЛИНА 300гр ТМ 4 Сезона	\N	\N	7291.00	шт	1	200	t	2025-12-07 13:19:51.409	2025-12-07 13:19:51.409	365.00	шт	20	поштучно
54647	3395	МАЛИНА 300гр ТМ Морозко Green	\N	\N	7130.00	шт	1	149	t	2025-12-07 13:19:51.42	2025-12-07 13:19:51.42	357.00	шт	20	поштучно
54648	3395	ОБЛЕПИХА садовая 300гр ТМ 4 Сезона	\N	\N	8252.00	шт	1	39	t	2025-12-07 13:19:51.44	2025-12-07 13:19:51.44	344.00	шт	24	поштучно
54649	3395	СЛИВА без косточки 300гр ТМ 4 Сезона	\N	\N	3846.00	шт	1	127	t	2025-12-07 13:19:51.451	2025-12-07 13:19:51.451	175.00	шт	22	поштучно
54650	3395	СМЕСЬ Фруктовая Компотная 300гр ТМ 4 Сезона	\N	\N	6044.00	шт	1	200	t	2025-12-07 13:19:51.461	2025-12-07 13:19:51.461	252.00	шт	24	поштучно
54651	3395	СМОРОДИНА черная 300гр ТМ 4 Сезона	\N	\N	10856.00	шт	1	31	t	2025-12-07 13:19:51.473	2025-12-07 13:19:51.473	543.00	шт	20	поштучно
54652	3395	СМОРОДИНА черная 300гр ТМ Морозко Green	\N	\N	6555.00	шт	1	200	t	2025-12-07 13:19:51.487	2025-12-07 13:19:51.487	328.00	шт	20	поштучно
54653	3395	ЧЕРНИКА 300гр ТМ 4 Сезона	\N	\N	7958.00	шт	1	159	t	2025-12-07 13:19:51.498	2025-12-07 13:19:51.498	398.00	шт	20	поштучно
54654	3305	ДИСКОНТ МАСЛО 500гр 72,5% Крестьянское Курск	\N	\N	3277.00	шт	1	279	t	2025-12-07 13:19:51.508	2025-12-07 13:19:51.508	328.00	шт	10	поштучно
54655	3305	ДИСКОНТ МАСЛО 500гр 82,5% Традиционное Курск	\N	\N	3450.00	шт	1	520	t	2025-12-07 13:19:51.518	2025-12-07 13:19:51.518	345.00	шт	10	поштучно
54656	3367	ГРЕБЕШОК Золотой 1кг на половинке ракушки 7-8 с/м (пакет)	\N	\N	12075.00	кг	1	86	t	2025-12-08 02:23:31.664	2025-12-08 02:23:31.664	1208.00	кг	10	поштучно
54657	3367	ГРЕБЕШОК ФИЛЕ 500гр 40/60 с/м ТМ Тихая Бухта	\N	\N	9085.00	шт	1	637	t	2025-12-08 02:23:31.681	2025-12-08 02:23:31.681	454.00	шт	20	поштучно
54658	3367	КАЛЬМАР ЁЖИКИ  500гр с/м Китай	\N	\N	7245.00	шт	1	16	t	2025-12-08 02:23:31.693	2025-12-08 02:23:31.693	362.00	шт	20	поштучно
54659	3367	КАЛЬМАР КОЛЬЦА 500гр с/м Китай	\N	\N	6969.00	шт	1	158	t	2025-12-08 02:23:31.706	2025-12-08 02:23:31.706	348.00	шт	20	поштучно
54660	3367	КАЛЬМАР мороженый Тушка с пластинкой	\N	\N	8510.00	кг	1	1000	t	2025-12-08 02:23:31.719	2025-12-08 02:23:31.719	425.00	кг	20	поштучно
54661	3367	КАЛЬМАР ФИЛЕ 1кг очищенный без кожи без плавника коробка с/м БМРТ Бутовск	\N	\N	19079.00	шт	1	1000	t	2025-12-08 02:23:31.736	2025-12-08 02:23:31.736	908.00	шт	21	поштучно
54662	3367	КАЛЬМАР ФИЛЕ 600гр очищенный без кожи без плавника коробка с/м АО ОКЕАНРЫБФЛОТ	\N	\N	19624.00	шт	1	1000	t	2025-12-08 02:23:31.792	2025-12-08 02:23:31.792	545.00	шт	36	поштучно
54663	3367	КОКТЕЙЛЬ 500гр морской с гребешком Китай	\N	\N	5405.00	шт	1	13	t	2025-12-08 02:23:31.812	2025-12-08 02:23:31.812	270.00	шт	20	поштучно
54664	3367	КОКТЕЙЛЬ 500гр морской, ассорти из морепродуктов с/м ТМ Тихая бухта	\N	\N	4577.00	шт	1	1000	t	2025-12-08 02:23:31.823	2025-12-08 02:23:31.823	229.00	шт	20	поштучно
54665	3367	МИДИИ 1кг 30/45 "М" синии в половинке раковины коробочка с/м Китай	\N	\N	6095.00	шт	1	182	t	2025-12-08 02:23:31.837	2025-12-08 02:23:31.837	610.00	шт	10	поштучно
\.


--
-- Data for Name: supplier_category_mappings; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.supplier_category_mappings (id, "supplierCategory", "targetCategoryId", confidence, "timesUsed", "createdAt", "updatedAt", "saleType") FROM stdin;
1391	- Крабовые палочки , крабовое мясо	3367	auto	0	2025-11-22 11:52:05.58	2025-11-23 10:40:08.4	поштучно
1392	- Креветка варёно-мороженая	3367	auto	0	2025-11-22 11:52:05.597	2025-11-23 10:40:08.415	поштучно
1364	- Карамель весовая	3303	auto	0	2025-11-22 11:52:05.019	2025-11-23 10:40:07.895	поштучно
1461	- Сухофрукты, орехи	3405	auto	0	2025-11-22 11:52:07.049	2025-11-23 10:40:09.787	только уп
1370	- Колбаса ТМ Анком Санкт-Питербург замороженая (срок 360 суток при -18)	3396	auto	0	2025-11-22 11:52:05.14	2025-11-23 10:40:08.008	поштучно
1376	- Консервы и закуски овощные  пр-ва "СПАССКИЙ КЗ"	3327	manual	0	2025-11-22 11:52:05.258	2025-11-23 10:40:08.125	поштучно
1379	- Консервы и закуски овощные  ТМ "РЕСТОРАЦИЯ ОБЛОМОВ"	3327	manual	0	2025-11-22 11:52:05.333	2025-11-23 10:40:08.184	поштучно
1384	- Консервы под заказ	3327	manual	0	2025-11-22 11:52:05.472	2025-11-23 10:40:08.259	поштучно
1385	- Консервы томатные Италия	3327	auto	0	2025-11-22 11:52:05.487	2025-11-23 10:40:08.287	поштучно
1362	- Индейка разделка фасованная	3310	auto	0	2025-11-22 11:52:04.988	2025-11-23 10:40:07.854	поштучно
1363	- К пиву	3399	manual	0	2025-11-22 11:52:05.004	2025-11-23 10:40:07.869	поштучно
1365	- Карамель фасованная	3303	auto	0	2025-11-22 11:52:05.034	2025-11-23 10:40:07.912	поштучно
1366	- Картофель фри, изделия из картофеля	3395	auto	0	2025-11-22 11:52:05.049	2025-11-23 10:40:07.933	поштучно
1367	- Кетчуп (B)	3400	auto	0	2025-11-22 11:52:05.066	2025-11-23 10:40:07.948	поштучно
1368	- Килька консервированная	3327	auto	0	2025-11-22 11:52:05.082	2025-11-23 10:40:07.962	поштучно
1369	- Колбаса ВИК	3396	manual	0	2025-11-22 11:52:05.117	2025-11-23 10:40:07.993	поштучно
1371	- Колбаса ТМ ВИК	3396	auto	0	2025-11-22 11:52:05.154	2025-11-23 10:40:08.023	поштучно
1372	- Колбаса ТМ Останкино	3396	auto	0	2025-11-22 11:52:05.17	2025-11-23 10:40:08.04	поштучно
1373	- Колбаса ТМ СПК	3396	auto	0	2025-11-22 11:52:05.207	2025-11-23 10:40:08.075	поштучно
1374	- Колбаса ТМ Черкизово	3396	auto	0	2025-11-22 11:52:05.224	2025-11-23 10:40:08.091	поштучно
1375	- Компоты  фруктовые	3327	auto	0	2025-11-22 11:52:05.24	2025-11-23 10:40:08.106	только уп
1377	- Консервы и закуски овощные  ТМ "ЗНАТОК"	3327	manual	0	2025-11-22 11:52:05.273	2025-11-23 10:40:08.139	только уп
1378	- Консервы и закуски овощные  ТМ "ПИКАНТА"	3327	manual	0	2025-11-22 11:52:05.313	2025-11-23 10:40:08.153	только уп
1380	- Консервы и закуски овощные  ТМ "СКАТЕРТЬ-САМОБРАНКА"	3327	manual	0	2025-11-22 11:52:05.389	2025-11-23 10:40:08.2	только уп
1381	- Консервы и закуски овощные  ТМ "СЫТА-ЗАГОРА"	3327	manual	0	2025-11-22 11:52:05.424	2025-11-23 10:40:08.217	только уп
1383	- Консервы овощные ТМ "СОННА МЕРА"  Индия	3327	auto	0	2025-11-22 11:52:05.453	2025-11-23 10:40:08.244	только уп
1382	- Консервы овощные горошек, кукуруза	3327	auto	0	2025-11-22 11:52:05.438	2025-11-23 10:40:08.231	только уп
1386	- Конфеты	3303	auto	0	2025-11-22 11:52:05.501	2025-11-23 10:40:08.302	только уп
1387	- Конфеты в коробках	3303	auto	0	2025-11-22 11:52:05.516	2025-11-23 10:40:08.318	поштучно
1388	- Конфеты шоколадные весовые	3303	auto	0	2025-11-22 11:52:05.531	2025-11-23 10:40:08.333	только уп
1389	- Конфеты шоколадные фасованные	3303	auto	0	2025-11-22 11:52:05.551	2025-11-23 10:40:08.346	поштучно
1390	- Кофе, чай  (C)	3323	auto	0	2025-11-22 11:52:05.565	2025-11-23 10:40:08.373	поштучно
1420	- Перчатки.губки для посуды. халаты. чехлы для обуви	3393	manual	0	2025-11-22 11:52:06.148	2025-11-23 10:40:09.023	поштучно
1421	- Печенье весовое	3303	auto	0	2025-11-22 11:52:06.169	2025-11-23 10:40:09.036	поштучно
1425	- Пирожные, десерты, пончики	3303	auto	0	2025-11-22 11:52:06.25	2025-11-23 10:40:09.106	поштучно
1433	- Пресервы и салаты из рыбы и морепродуктов ТМ ВРК, Владивосток	3367	auto	0	2025-11-22 11:52:06.426	2025-11-23 10:40:09.236	поштучно
1415	- Оливки маслины	3327	auto	0	2025-11-22 11:52:06.066	2025-11-23 10:40:08.877	только уп
1416	- Пакеты	3393	manual	0	2025-11-22 11:52:06.083	2025-11-23 10:40:08.891	поштучно
1417	- Паста арахисовая, шоколадная	3303	auto	0	2025-11-22 11:52:06.101	2025-11-23 10:40:08.924	поштучно
1418	- Паштеты	3327	auto	0	2025-11-22 11:52:06.12	2025-11-23 10:40:08.989	поштучно
1419	- Пельмени, манты, хинкали фасованные (S)	3356	auto	0	2025-11-22 11:52:06.133	2025-11-23 10:40:09.004	поштучно
1422	- Печенье фасованное	3303	auto	0	2025-11-22 11:52:06.202	2025-11-23 10:40:09.054	поштучно
1423	- Печенье,крекер	3303	auto	0	2025-11-22 11:52:06.219	2025-11-23 10:40:09.077	только уп
1424	- Печенье,сушки,пряники	3303	auto	0	2025-11-22 11:52:06.233	2025-11-23 10:40:09.091	только уп
1426	- Пицца, основа для пиццы	3391	auto	0	2025-11-22 11:52:06.266	2025-11-23 10:40:09.12	только уп
1427	- Полуфабрикаты весовые (S)	3391	manual	0	2025-11-22 11:52:06.281	2025-11-23 10:40:09.135	только уп
1428	- Полуфабрикаты для разогрева	3391	auto	0	2025-11-22 11:52:06.344	2025-11-23 10:40:09.152	поштучно
1429	- Полуфабрикаты и деликатесы мороженые	3367	auto	0	2025-11-22 11:52:06.364	2025-11-23 10:40:09.168	поштучно
1430	- Полуфабрикаты фасованные (S)	3391	manual	0	2025-11-22 11:52:06.381	2025-11-23 10:40:09.184	поштучно
1431	- Попкорн	3303	manual	0	2025-11-22 11:52:06.397	2025-11-23 10:40:09.198	поштучно
1432	- Пресервы и салаты из рыбы и морепродуктов пр-во Дальпико Фиш, Владивосток	3367	auto	0	2025-11-22 11:52:06.412	2025-11-23 10:40:09.213	поштучно
1520	МОРОЖЕНОЕ ТМ "ПРОЧЕЕ" (R)	3392	auto	0	2025-11-22 11:52:08.248	2025-11-23 10:40:10.881	поштучно
1521	МОРОЖЕНОЕ ТМ "СЕЛО ЗЕЛЕНОЕ"  (R)	3392	auto	0	2025-11-22 11:52:08.263	2025-11-23 10:40:10.895	поштучно
1522	МОРОЖЕНОЕ ТМ "ЧИСТАЯ ЛИНИЯ"  (R)	3392	auto	0	2025-11-22 11:52:08.282	2025-11-23 10:40:10.934	поштучно
1523	МЯСО, ПТИЦА, ЯЙЦО  (P)	3310	auto	0	2025-11-22 11:52:08.351	2025-11-23 10:40:10.948	поштучно
1524	НАПИТКИ	3323	auto	0	2025-11-22 11:52:08.372	2025-11-23 10:40:10.976	поштучно
1525	ОВОЩИ, ФРУКТЫ, ГРИБЫ ЗАМОРОЖЕННЫЕ  (T)	3395	auto	0	2025-11-22 11:52:08.387	2025-11-23 10:40:10.99	поштучно
1526	ПОЛУФАБРИКАТЫ ГОТОВЫЕ  (S)	3391	manual	0	2025-11-22 11:52:08.403	2025-11-23 10:40:11.012	поштучно
1527	ПОЛУФАБРИКАТЫ ДЛЯ ПРИГОТОВЛЕНИЯ	3391	auto	0	2025-11-22 11:52:08.418	2025-11-23 10:40:11.051	поштучно
1528	РЫБА И МОРЕПРОДУКТЫ СВЕЖЕМОРОЖЕННЫЕ  (L)	3367	auto	0	2025-11-22 11:52:08.432	2025-11-23 10:40:11.078	поштучно
1529	САЛО, ШПИК, ГРУДИНКА СОЛЕНЫЕ и В/К замороженные (P)	3310	auto	0	2025-11-22 11:52:08.448	2025-11-23 10:40:11.124	поштучно
1530	СНЕКИ	3303	auto	0	2025-11-22 11:52:08.468	2025-11-23 10:40:11.138	поштучно
1531	Сыры	3314	auto	0	2025-11-22 11:52:08.488	2025-11-23 10:40:11.153	поштучно
1532	СЫРЫ (B)	3314	auto	0	2025-11-22 11:52:08.503	2025-11-23 10:40:11.168	поштучно
1533	ТОРТЫ и ПИРОЖНЫЕ ЗАМОРОЖЕННЫЕ (R)	3303	auto	0	2025-11-22 11:52:08.518	2025-11-23 10:40:11.183	поштучно
1466	- Сыры плавленые	3314	auto	0	2025-11-22 11:52:07.172	2025-11-23 10:40:09.879	поштучно
1467	- Сыры творожные, мягкие, брынза	3314	auto	0	2025-11-22 11:52:07.189	2025-11-23 10:40:09.896	поштучно
1468	- Сыры фасованные	3314	auto	0	2025-11-22 11:52:07.203	2025-11-23 10:40:09.917	поштучно
1469	- Сэндвич	3392	manual	0	2025-11-22 11:52:07.225	2025-11-23 10:40:09.942	только уп
1329	- Бытовая химия	3393	manual	0	2025-11-22 11:52:04.334	2025-11-23 10:40:07.122	поштучно
1333	- Вафли весовые	3303	auto	0	2025-11-22 11:52:04.4	2025-11-23 10:40:07.198	поштучно
1334	- Вафли фасованные	3303	auto	0	2025-11-22 11:52:04.415	2025-11-23 10:40:07.215	поштучно
1341	- Деликатессы по-корейски (B)	3396	auto	0	2025-11-22 11:52:04.548	2025-11-23 10:40:07.369	поштучно
1343	- Дой-пак	3392	manual	0	2025-11-22 11:52:04.588	2025-11-23 10:40:07.423	поштучно
1345	- Зефир	3303	auto	0	2025-11-22 11:52:04.642	2025-11-23 10:40:07.48	поштучно
1346	- Зефир, мармелад  весовые	3303	auto	0	2025-11-22 11:52:04.675	2025-11-23 10:40:07.506	поштучно
1348	- Изделия из гольца	3367	manual	0	2025-11-22 11:52:04.713	2025-11-23 10:40:07.549	поштучно
1350	- Изделия из кальмара и трубача	3367	auto	0	2025-11-22 11:52:04.745	2025-11-23 10:40:07.591	поштучно
1352	- Изделия из кеты ДАЛЬРЫБФЛОТПРОДУКТ	3367	manual	0	2025-11-22 11:52:04.816	2025-11-23 10:40:07.68	поштучно
1353	- Изделия из кильки, мойвы	3367	manual	0	2025-11-22 11:52:04.836	2025-11-23 10:40:07.697	поштучно
1354	- Изделия из минтая	3367	manual	0	2025-11-22 11:52:04.85	2025-11-23 10:40:07.715	поштучно
1355	- Изделия из палтуса, кижуча, нерки	3367	auto	0	2025-11-22 11:52:04.869	2025-11-23 10:40:07.73	поштучно
1357	- Изделия из скумбрии	3367	manual	0	2025-11-22 11:52:04.905	2025-11-23 10:40:07.761	поштучно
1323	- Ассорти	3367	manual	0	2025-11-22 11:52:04.192	2025-11-23 10:40:06.991	поштучно
1327	- Брикет	3392	manual	0	2025-11-22 11:52:04.285	2025-11-23 10:40:07.087	только уп
1331	- Варенье, джем, повидло	3394	auto	0	2025-11-22 11:52:04.363	2025-11-23 10:40:07.151	только уп
1332	- Вафли	3303	auto	0	2025-11-22 11:52:04.38	2025-11-23 10:40:07.166	только уп
1335	- Ведерко, контейнер, пакет	3392	manual	0	2025-11-22 11:52:04.433	2025-11-23 10:40:07.228	поштучно
1336	- Говядина весовая	3310	auto	0	2025-11-22 11:52:04.449	2025-11-23 10:40:07.256	только уп
1349	- Изделия из горбуши	3367	auto	0	2025-11-22 11:52:04.731	2025-11-23 10:40:07.567	поштучно
1351	- Изделия из кеты	3367	manual	0	2025-11-22 11:52:04.789	2025-11-23 10:40:07.634	поштучно
1356	- Изделия из сельди	3367	manual	0	2025-11-22 11:52:04.889	2025-11-23 10:40:07.745	поштучно
1358	- Изделия из слоеного и сдобного теста	3397	manual	0	2025-11-22 11:52:04.922	2025-11-23 10:40:07.78	только уп
1359	- Икра	3367	auto	0	2025-11-22 11:52:04.938	2025-11-23 10:40:07.797	поштучно
1360	- Икра замороженная для суши	3398	manual	0	2025-11-22 11:52:04.954	2025-11-23 10:40:07.821	поштучно
1361	- Индейка разделка весовая	3310	auto	0	2025-11-22 11:52:04.969	2025-11-23 10:40:07.838	только уп
1393	- Креветка сыромороженая	3367	auto	0	2025-11-22 11:52:05.622	2025-11-23 10:40:08.428	поштучно
1394	- Крупы фасованные (C)	3317	auto	0	2025-11-22 11:52:05.64	2025-11-23 10:40:08.469	поштучно
1395	- Курица разделка весовая	3310	auto	0	2025-11-22 11:52:05.666	2025-11-23 10:40:08.501	только уп
1396	- Курица разделка фасованная	3310	auto	0	2025-11-22 11:52:05.688	2025-11-23 10:40:08.519	поштучно
1397	- Курица тушка	3310	auto	0	2025-11-22 11:52:05.708	2025-11-23 10:40:08.535	поштучно
1398	- Майонез (C)	3400	auto	0	2025-11-22 11:52:05.724	2025-11-23 10:40:08.55	поштучно
1399	- Макаронные изделия весовые (C)	3317	auto	0	2025-11-22 11:52:05.739	2025-11-23 10:40:08.571	только уп
1400	- Макаронные изделия фасованные (C)	3317	auto	0	2025-11-22 11:52:05.754	2025-11-23 10:40:08.604	поштучно
1401	- Масло растительное	3401	auto	0	2025-11-22 11:52:05.77	2025-11-23 10:40:08.619	только уп
1403	- Масло сливочное фасованное	3401	auto	0	2025-11-22 11:52:05.822	2025-11-23 10:40:08.647	поштучно
1404	- Мед	3402	manual	0	2025-11-22 11:52:05.84	2025-11-23 10:40:08.662	поштучно
1405	- Молоко сгущеное консервированное	3327	auto	0	2025-11-22 11:52:05.864	2025-11-23 10:40:08.686	поштучно
1406	- Молоко, сливки (D)	3305	auto	0	2025-11-22 11:52:05.881	2025-11-23 10:40:08.73	только уп
1407	- Морепродукты мороженые	3367	auto	0	2025-11-22 11:52:05.898	2025-11-23 10:40:08.746	поштучно
1408	- Мороженое ТМ "Брест-Литовск", "Солетто", "ЮККИ"	3392	auto	0	2025-11-22 11:52:05.914	2025-11-23 10:40:08.761	только уп
1409	- Мясо и птица в Маринадах	3310	auto	0	2025-11-22 11:52:05.931	2025-11-23 10:40:08.775	поштучно
1410	- Наггетсы	3391	auto	0	2025-11-22 11:52:05.946	2025-11-23 10:40:08.791	поштучно
1434	- Пресервы и салаты из рыбы и морепродуктов ТМ Русское Море, Санта Бремор, Меридиан	3367	auto	0	2025-11-22 11:52:06.444	2025-11-23 10:40:09.307	поштучно
1435	- Приправы, супы, пюре картофельное, лапша быстрого приготовления (C)	3403	auto	0	2025-11-22 11:52:06.474	2025-11-23 10:40:09.322	поштучно
1437	- Продукция ТМ Алтайский купец, Новосибирск	3310	manual	0	2025-11-22 11:52:06.531	2025-11-23 10:40:09.351	только уп
1438	- Продукция ТМ Барс, Новосибирск	3310	manual	0	2025-11-22 11:52:06.545	2025-11-23 10:40:09.367	только уп
1439	- Продукция ТМ Богородский фермер	3310	manual	0	2025-11-22 11:52:06.573	2025-11-23 10:40:09.381	поштучно
1436	- Продукция для приготовления суши и ролл (A)	3398	manual	0	2025-11-22 11:52:06.498	2025-11-23 10:40:09.337	поштучно
1440	- Прочие консервы из рыбы и морепродуктов	3367	auto	0	2025-11-22 11:52:06.638	2025-11-23 10:40:09.396	поштучно
1443	- Пряники фасованные	3303	auto	0	2025-11-22 11:52:06.69	2025-11-23 10:40:09.445	поштучно
1445	- Рулеты, пирожные, кексы фасованные	3303	auto	0	2025-11-22 11:52:06.722	2025-11-23 10:40:09.48	поштучно
1456	- Сосиски рыбные охлаженые	3396	auto	0	2025-11-22 11:52:06.922	2025-11-23 10:40:09.713	поштучно
1462	- Сушки,баранки,соломка, сухари весовые	3303	auto	0	2025-11-22 11:52:07.073	2025-11-23 10:40:09.801	поштучно
1463	- Сушки,баранки,соломка, сухари фасованные	3303	auto	0	2025-11-22 11:52:07.102	2025-11-23 10:40:09.822	поштучно
1472	- Телятина молодая	3310	auto	0	2025-11-22 11:52:07.283	2025-11-23 10:40:10.017	поштучно
1475	- Торт	3392	manual	0	2025-11-22 11:52:07.385	2025-11-23 10:40:10.08	поштучно
1477	- Торты, рулеты, чизкейки	3303	auto	0	2025-11-22 11:52:07.43	2025-11-23 10:40:10.109	поштучно
1478	- Упаковка и одноразовая посуда	3393	manual	0	2025-11-22 11:52:07.445	2025-11-23 10:40:10.123	поштучно
1480	- Фарш	3310	auto	0	2025-11-22 11:52:07.477	2025-11-23 10:40:10.19	поштучно
1481	- Фруктовые снеки сушеные	3303	auto	0	2025-11-22 11:52:07.497	2025-11-23 10:40:10.204	поштучно
1490	- Чипсы и снеки (D)	3303	auto	0	2025-11-22 11:52:07.685	2025-11-23 10:40:10.339	поштучно
1491	- Чистящие средства	3393	manual	0	2025-11-22 11:52:07.7	2025-11-23 10:40:10.354	поштучно
1494	- Шоколадные батончики	3303	auto	0	2025-11-22 11:52:07.756	2025-11-23 10:40:10.409	поштучно
1499	- Яичный меланж	3310	auto	0	2025-11-22 11:52:07.837	2025-11-23 10:40:10.522	поштучно
1502	БАКАЛЕЯ (C)	3317	manual	0	2025-11-22 11:52:07.908	2025-11-23 10:40:10.574	поштучно
1503	БЫТОВАЯ ХИМИЯ И ХОЗ ТОВАРЫ (C)	3393	manual	0	2025-11-22 11:52:07.922	2025-11-23 10:40:10.609	поштучно
1504	ИЗДЕЛИЯ ИЗ РЫБЫ И МОРЕПРОДУКТОВ ВЛАДИВОСТОК, МОСКВА (А)	3367	auto	0	2025-11-22 11:52:07.939	2025-11-23 10:40:10.623	поштучно
1505	ИЗДЕЛИЯ ИЗ РЫБЫ И МОРЕПРОДУКТОВ МЕСТНЫХ ПРОИЗВОДИТЕЛЕЙ (А)	3367	auto	0	2025-11-22 11:52:07.955	2025-11-23 10:40:10.638	поштучно
1506	КОЛБАСА ВАР, ВЕТЧИНА, СОСИСКИ (B)	3396	auto	0	2025-11-22 11:52:07.97	2025-11-23 10:40:10.652	поштучно
1507	КОЛБАСА ПОЛУКОПЧЕНАЯ, ВАРЕНОКОПЧЕНАЯ, ДЕЛИКАТЕСЫ (B)	3396	auto	0	2025-11-22 11:52:08.008	2025-11-23 10:40:10.682	поштучно
1508	КОЛБАСА СЫРОКОПЧЕНАЯ, НАРЕЗКИ (B)	3396	auto	0	2025-11-22 11:52:08.025	2025-11-23 10:40:10.7	поштучно
1509	КОНДИТЕРСКИЕ ИЗДЕЛИЯ (D)	3303	auto	0	2025-11-22 11:52:08.04	2025-11-23 10:40:10.714	поштучно
1510	КОНДИТЕРСКИЕ ИЗДЕЛИЯ ТМ "КОЛОМЕНСКОЕ" (D)	3303	auto	0	2025-11-22 11:52:08.066	2025-11-23 10:40:10.728	поштучно
1511	КОНДИТЕРСКИЕ ИЗДЕЛИЯ ТМ "СЛАДОНЕЖ" (D)	3303	auto	0	2025-11-22 11:52:08.082	2025-11-23 10:40:10.743	поштучно
1512	КОНСЕРВЫ МОЛОЧНЫЕ  (D)	3327	auto	0	2025-11-22 11:52:08.101	2025-11-23 10:40:10.758	поштучно
1513	КОНСЕРВЫ МЯСНЫЕ (C)	3327	auto	0	2025-11-22 11:52:08.118	2025-11-23 10:40:10.776	поштучно
1514	КОНСЕРВЫ ПЛОДООВОЩНЫЕ	3327	auto	0	2025-11-22 11:52:08.144	2025-11-23 10:40:10.794	поштучно
1515	КОНСЕРВЫ РЫБНЫЕ (C)	3327	auto	0	2025-11-22 11:52:08.159	2025-11-23 10:40:10.809	поштучно
1516	МАЙОНЕЗЫ, КЕТЧУПЫ, СОУСЫ	3400	auto	0	2025-11-22 11:52:08.174	2025-11-23 10:40:10.825	поштучно
1517	МОЛОЧНЫЕ ПРОДУКТЫ	3305	auto	0	2025-11-22 11:52:08.191	2025-11-23 10:40:10.839	поштучно
1442	- Пряники весовые	3303	auto	0	2025-11-22 11:52:06.675	2025-11-23 10:40:09.429	только уп
1447	- Сайра, сардина консервированные	3327	auto	0	2025-11-22 11:52:06.749	2025-11-23 10:40:09.517	поштучно
1448	- Салаты из морской капусты	3367	manual	0	2025-11-22 11:52:06.769	2025-11-23 10:40:09.532	поштучно
1460	- Сухое молоко, яичный порошок (C)	3305	auto	0	2025-11-22 11:52:07.033	2025-11-23 10:40:09.772	поштучно
1464	- Сырки, рожки творожные (R)	3305	auto	0	2025-11-22 11:52:07.117	2025-11-23 10:40:09.838	только уп
1465	- Сыры весовые	3314	auto	0	2025-11-22 11:52:07.133	2025-11-23 10:40:09.854	поштучно
1470	- Сэндвич, лакомка	3392	manual	0	2025-11-22 11:52:07.24	2025-11-23 10:40:09.961	только уп
1471	- Творог, творожная масса (T)	3305	auto	0	2025-11-22 11:52:07.254	2025-11-23 10:40:09.984	только уп
1473	- Тесто  (R)	3391	auto	0	2025-11-22 11:52:07.304	2025-11-23 10:40:10.042	поштучно
1474	- Томатная паста	3327	auto	0	2025-11-22 11:52:07.321	2025-11-23 10:40:10.057	только уп
1476	- Торт вафельный	3303	manual	0	2025-11-22 11:52:07.415	2025-11-23 10:40:10.095	только уп
1479	- УТКА разделка с/м  Россия	3310	auto	0	2025-11-22 11:52:07.461	2025-11-23 10:40:10.172	поштучно
1482	- Фруктовый лед	3392	manual	0	2025-11-22 11:52:07.516	2025-11-23 10:40:10.218	только уп
1483	- Халва, козинак	3303	auto	0	2025-11-22 11:52:07.536	2025-11-23 10:40:10.233	только уп
1484	- Хлеб п/ф заморож высокой степени готовности	3323	auto	0	2025-11-22 11:52:07.552	2025-11-23 10:40:10.247	только уп
1487	- Хлебцы, батончики, мюсли	3303	auto	0	2025-11-22 11:52:07.624	2025-11-23 10:40:10.292	только уп
1488	- Хлопья, каши, семена (C)	3317	manual	0	2025-11-22 11:52:07.65	2025-11-23 10:40:10.307	только уп
1489	- Хрен, горчица, аджика (B)	3400	auto	0	2025-11-22 11:52:07.665	2025-11-23 10:40:10.321	поштучно
1500	- Яйцо куриное (А)	3310	auto	0	2025-11-22 11:52:07.851	2025-11-23 10:40:10.542	только уп
1501	-Крупы весовые  (C)	3317	auto	0	2025-11-22 11:52:07.892	2025-11-23 10:40:10.557	только уп
1518	МОРОЖЕНОЕ "САНТА БРЕМОР" БЕЛАРУСЬ (R)	3392	auto	0	2025-11-22 11:52:08.206	2025-11-23 10:40:10.852	поштучно
1519	МОРОЖЕНОЕ ТМ "НЕСТЛЕ" АКЦИЯ от ПРОИЗВОДИТЕЛЯ -"Летний ЦеноПад" (R)	3392	auto	0	2025-11-22 11:52:08.221	2025-11-23 10:40:10.867	поштучно
1324	- Баранина весовая	3310	auto	0	2025-11-22 11:52:04.224	2025-11-23 10:40:07.028	поштучно
1325	- Блинчики весовые	3391	auto	0	2025-11-22 11:52:04.239	2025-11-23 10:40:07.055	только уп
1326	- Блинчики фасованые	3391	auto	0	2025-11-22 11:52:04.253	2025-11-23 10:40:07.07	поштучно
1328	- Бумага туалетная, салфетки, полотенца бумажные	3393	manual	0	2025-11-22 11:52:04.31	2025-11-23 10:40:07.104	поштучно
1330	- Вареники фасованные  (S)	3356	auto	0	2025-11-22 11:52:04.349	2025-11-23 10:40:07.136	поштучно
1337	- Говядина консервированная	3327	auto	0	2025-11-22 11:52:04.466	2025-11-23 10:40:07.303	поштучно
1338	- Говядина мраморная	3310	auto	0	2025-11-22 11:52:04.494	2025-11-23 10:40:07.321	поштучно
1339	- Готовые блюда замороженные для разогрева	3391	auto	0	2025-11-22 11:52:04.517	2025-11-23 10:40:07.335	поштучно
1340	- Готовые блюда из овощей	3395	manual	0	2025-11-22 11:52:04.533	2025-11-23 10:40:07.352	поштучно
1342	- Для запекания	3393	manual	0	2025-11-22 11:52:04.563	2025-11-23 10:40:07.406	поштучно
1344	- Замороженные фруктовые чаи из натуральных ягод и трав (просто положи в кипяток)	3392	manual	0	2025-11-22 11:52:04.626	2025-11-23 10:40:07.445	только уп
1347	- Зефир, мармелад фасованные	3303	auto	0	2025-11-22 11:52:04.696	2025-11-23 10:40:07.527	только уп
1402	- Масло сливочное весовое	3401	auto	0	2025-11-22 11:52:05.799	2025-11-23 10:40:08.633	только уп
1411	- Напитки газированные, вода, чай (D)	3323	auto	0	2025-11-22 11:52:05.974	2025-11-23 10:40:08.806	только уп
1412	- Напитки негазированные, соки, нектары (C)	3323	auto	0	2025-11-22 11:52:05.996	2025-11-23 10:40:08.823	только уп
1413	- Овощи и грибы  весовые	3395	auto	0	2025-11-22 11:52:06.014	2025-11-23 10:40:08.837	только уп
1414	- Овощи и грибы фасованные	3395	auto	0	2025-11-22 11:52:06.046	2025-11-23 10:40:08.852	поштучно
1441	- Прочие консервы мясные, каши	3327	auto	0	2025-11-22 11:52:06.66	2025-11-23 10:40:09.415	поштучно
1444	- Рожок	3392	manual	0	2025-11-22 11:52:06.706	2025-11-23 10:40:09.462	только уп
1446	- Рыба мороженая	3367	auto	0	2025-11-22 11:52:06.735	2025-11-23 10:40:09.497	только уп
1449	- Свинина весовая	3310	auto	0	2025-11-22 11:52:06.785	2025-11-23 10:40:09.548	только уп
1450	- Свинина консервированная	3327	auto	0	2025-11-22 11:52:06.811	2025-11-23 10:40:09.562	поштучно
1451	- Свинина фасованная	3310	auto	0	2025-11-22 11:52:06.833	2025-11-23 10:40:09.576	поштучно
1452	- Сиропы и десерты	3303	auto	0	2025-11-22 11:52:06.848	2025-11-23 10:40:09.595	только уп
1453	- Сметанные продукты и десерты (B)	3305	auto	0	2025-11-22 11:52:06.87	2025-11-23 10:40:09.661	только уп
1454	- Соленья овощные  (А)	3327	auto	0	2025-11-22 11:52:06.888	2025-11-23 10:40:09.675	поштучно
1455	- Соль, сахар, мука (C)	3404	manual	0	2025-11-22 11:52:06.903	2025-11-23 10:40:09.697	только уп
1457	- Сосиски, сардельки мороженые	3396	auto	0	2025-11-22 11:52:06.951	2025-11-23 10:40:09.728	поштучно
1458	- Соусы  (B)	3400	auto	0	2025-11-22 11:52:06.971	2025-11-23 10:40:09.742	поштучно
1459	- Стаканчик	3392	manual	0	2025-11-22 11:52:07.013	2025-11-23 10:40:09.756	только уп
1492	- Шашлыки и колбаски замороженные для жарки	3310	auto	0	2025-11-22 11:52:07.714	2025-11-23 10:40:10.368	поштучно
1493	- Шоколад плиточный	3303	auto	0	2025-11-22 11:52:07.738	2025-11-23 10:40:10.395	только уп
1495	- Шпроты консервированные	3327	auto	0	2025-11-22 11:52:07.769	2025-11-23 10:40:10.423	поштучно
1496	- Эскимо	3392	manual	0	2025-11-22 11:52:07.784	2025-11-23 10:40:10.437	только уп
1497	- Ягоды и фрукты весовые	3395	auto	0	2025-11-22 11:52:07.805	2025-11-23 10:40:10.492	только уп
1498	- Ягоды и фрукты фасованные	3395	auto	0	2025-11-22 11:52:07.821	2025-11-23 10:40:10.507	поштучно
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.system_settings (id, key, value, description, "updatedAt") FROM stdin;
3	payment_mode	test	Режим платежей: test или production	2025-09-06 13:10:15.944
4	enable_test_cards	false	Разрешить тестовые карты в боевом режиме	2025-09-07 03:33:21.658
1	default_margin_percent	15	Маржа по умолчанию для новых партий (%)	2025-11-22 01:25:16.858
2	vat_code	6	Код НДС: 1=20%, 2=10%, 3=20/120, 4=10/110, 5=0%, 6=без НДС	2025-10-02 12:17:11.988
24	maintenance_mode	false	Режим технического обслуживания	2025-12-07 09:16:38.834
25	maintenance_message	Проводятся технические работы	Сообщение при техническом обслуживании	2025-12-07 09:16:38.861
26	maintenance_end_time	2 Часа	Планируемое время окончания обслуживания	2025-12-07 09:16:38.87
23	allowed_phones	["+79148291630"]	Телефоны с доступом во время обслуживания	2025-12-07 09:16:38.887
11	checkout_enabled	true	Разрешить пользователям оформлять заказы	2025-12-07 13:20:52.457
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.users (id, phone, "firstName", "lastName", email, "isActive", "createdAt", "updatedAt", "acceptedTerms", "acceptedTermsAt", "acceptedTermsIp") FROM stdin;
88	79141030067	Мила	\N	\N	t	2025-08-23 22:55:31.933	2025-08-23 22:55:31.933	t	2025-08-23 22:55:31.933	\N
338	79148223314	Ксения	Козлова	skalonksenia@gmail.com	t	2025-10-30 06:25:21.538	2025-10-30 06:25:21.538	f	\N	\N
126	79841037050	Александр	Шпак	proics2009_94@mail.ru	t	2025-09-11 05:42:52.01	2025-09-11 05:42:52.01	f	\N	\N
159	79618777204	Наталья	Доброва	\N	t	2025-10-02 11:32:33.796	2025-10-02 11:32:33.796	f	\N	\N
302	79142779540	Евгения	\N	\N	t	2025-10-18 00:40:45.486	2025-10-18 00:40:45.486	f	\N	\N
303	79141065163	Яков	\N	\N	t	2025-10-18 01:44:00.759	2025-10-18 01:44:00.759	f	\N	\N
304	79244641217	Дария	\N	\N	t	2025-10-18 03:38:47.26	2025-10-18 03:38:47.26	f	\N	\N
305	79240192298	Евгений	Загребин	\N	t	2025-10-18 05:37:05.805	2025-10-18 05:37:05.805	f	\N	\N
306	79142614967	Сергей	\N	\N	t	2025-10-18 09:58:15.394	2025-10-18 09:58:15.394	f	\N	\N
307	79142325158	Марина	\N	\N	t	2025-10-18 11:35:11.909	2025-10-18 11:35:11.909	f	\N	\N
308	79141072652	Александр	Навьяво	trezubec357@gmail.com	t	2025-10-19 14:27:19.893	2025-10-19 14:27:19.893	f	\N	\N
309	79142347019	Алиса	\N	\N	t	2025-10-19 15:16:05.926	2025-10-19 15:16:05.926	f	\N	\N
280	79137194519	Ульяна	Шпак	uunguryanu@list.ru	t	2025-10-17 11:55:18.161	2025-10-17 11:55:18.161	f	\N	\N
281	79241650132	Дмитрий	\N	\N	t	2025-10-17 12:00:11.314	2025-10-17 12:00:11.314	f	\N	\N
282	79142654503	Дмитрий	Рогачук	arcticsniper1990@gmail.com	t	2025-10-17 12:00:55.815	2025-10-17 12:00:55.815	f	\N	\N
283	79148263243	Алексей	Василевский	vasilevskiy52@gmail.com	t	2025-10-17 12:02:10.283	2025-10-17 12:02:10.283	f	\N	\N
284	79193213413	Сергей	Никитюк	\N	t	2025-10-17 12:48:23.41	2025-10-17 12:48:23.41	f	\N	\N
285	79841042898	Айаан	Корнилов	ajaankornilov4@gmail.com	t	2025-10-17 12:52:36.039	2025-10-17 12:52:36.039	f	\N	\N
286	79142668685	Мадина	\N	\N	t	2025-10-17 13:17:46.932	2025-10-17 13:17:46.932	f	\N	\N
287	79141000633	Аркадий	\N	\N	t	2025-10-17 13:27:53.239	2025-10-17 13:27:53.239	f	\N	\N
288	79142610288	Ренат	Мукангалиев	renatmukangaliev@gmail.com	t	2025-10-17 13:32:17.917	2025-10-17 13:32:17.917	f	\N	\N
289	79142645218	Сергей	\N	\N	t	2025-10-17 13:54:14.481	2025-10-17 13:54:14.481	f	\N	\N
290	79148250885	Владимир	Куртов	\N	t	2025-10-17 13:56:25.148	2025-10-17 13:56:25.148	f	\N	\N
291	79148250886	Владимир	\N	\N	t	2025-10-17 13:57:04.896	2025-10-17 13:57:04.896	f	\N	\N
292	79841180754	Анастасия	\N	stasya_860703@mail.ru	t	2025-10-17 14:05:06.593	2025-10-17 14:05:06.593	f	\N	\N
293	79142330790	Анна	Таркова	anechkacoi_1992@mail.ru	t	2025-10-17 14:10:17.902	2025-10-17 14:10:17.902	f	\N	\N
294	79142660395	Марина	\N	\N	t	2025-10-17 14:21:47.592	2025-10-17 14:21:47.592	f	\N	\N
295	79142275728	Мария	\N	\N	t	2025-10-17 16:52:12.413	2025-10-17 16:52:12.413	f	\N	\N
296	79142441436	Артур	\N	\N	t	2025-10-17 17:25:31.788	2025-10-17 17:25:31.788	f	\N	\N
297	79143051993	Марина	\N	\N	t	2025-10-17 21:38:40.052	2025-10-17 21:38:40.052	f	\N	\N
298	79241756129	Кюннэй	Федорова	\N	t	2025-10-17 22:15:42.395	2025-10-17 22:15:42.395	f	\N	\N
299	79142915378	Виктория	\N	ms.ponamarchuk@mail.ru	t	2025-10-17 22:48:26.676	2025-10-17 22:48:26.676	f	\N	\N
300	79841053020	Дана	Сард	\N	t	2025-10-18 00:06:25.333	2025-10-18 00:06:25.333	f	\N	\N
301	79142771616	Ахмед	Муцольгов	ahmedmus2000@icloud.com	t	2025-10-18 00:26:47.611	2025-10-18 00:26:47.611	f	\N	\N
310	79143054952	Валерия	\N	\N	t	2025-10-19 15:20:12.449	2025-10-19 15:20:12.449	f	\N	\N
311	79142217151	Таня	Жукова	\N	t	2025-10-19 21:21:58.031	2025-10-19 21:21:58.031	f	\N	\N
312	79198736787	Богдан	Сердюков	\N	t	2025-10-19 23:41:07.073	2025-10-19 23:41:07.073	f	\N	\N
313	79148241712	Денис	Проскурнов	\N	t	2025-10-20 00:49:17.886	2025-10-20 00:49:17.886	f	\N	\N
314	79148252779	Наталья	Проскурнова	\N	t	2025-10-20 01:00:42.294	2025-10-20 01:00:42.294	f	\N	\N
315	79142335194	Лев	\N	\N	t	2025-10-20 07:24:06.852	2025-10-20 07:24:06.852	f	\N	\N
316	79244693592	Alek	\N	\N	t	2025-10-21 07:03:38.917	2025-10-21 07:03:38.917	f	\N	\N
317	79148291630	Тамя	Карлина	\N	t	2025-10-21 11:26:41.074	2025-10-21 11:26:41.074	f	\N	\N
318	79143006934	Екатерина	\N	varaksina-ek@mail.ru	t	2025-10-22 05:50:31.792	2025-10-22 05:50:31.792	f	\N	\N
319	79141049482	Александра	Харитонова	a.a.haritonova@mail.ru	t	2025-10-22 05:50:40.92	2025-10-22 05:50:40.92	f	\N	\N
320	79887509250	Елена	Делова	elena.delova.78@mail.ru	t	2025-10-22 06:19:21.178	2025-10-22 06:19:21.178	f	\N	\N
321	79148267165	Саша	\N	\N	t	2025-10-22 07:16:43.871	2025-10-22 07:16:43.871	f	\N	\N
322	79142992805	Нина	\N	\N	t	2025-10-23 23:08:24.64	2025-10-23 23:08:24.64	f	\N	\N
323	79142667582	Игорь	\N	\N	t	2025-10-25 13:37:49.435	2025-10-25 13:37:49.435	f	\N	\N
324	79142200417	Ирина	Никитина	bormashova_1978@icloud.com	t	2025-10-25 14:05:19.447	2025-10-25 14:05:19.447	f	\N	\N
325	79142884070	Елена	\N	\N	t	2025-10-26 01:35:24.605	2025-10-26 01:35:24.605	f	\N	\N
326	79241680191	Анна	\N	\N	t	2025-10-27 00:16:06.38	2025-10-27 00:16:06.38	f	\N	\N
327	79142248519	Татьяна	\N	\N	t	2025-10-27 00:24:11.948	2025-10-27 00:24:11.948	f	\N	\N
328	79841009107	Денис	\N	\N	t	2025-10-27 00:36:50.695	2025-10-27 00:36:50.695	f	\N	\N
329	79141040480	Инга	Инга	arhivoimyakon@mail.ru	t	2025-10-27 00:58:48.292	2025-10-27 00:58:48.292	f	\N	\N
330	79248735878	Карина	Шнейдер	\N	t	2025-10-27 01:34:06.75	2025-10-27 01:34:06.75	f	\N	\N
331	79148251264	Валентина	Васильева	vvd.unr@mail.ru	t	2025-10-27 02:52:26.178	2025-10-27 02:52:26.178	f	\N	\N
332	79288466601	Артем	Ребриков	\N	t	2025-10-27 07:01:54.478	2025-10-27 07:01:54.478	f	\N	\N
333	79142380707	Елена	\N	\N	t	2025-10-30 02:20:06.387	2025-10-30 02:20:06.387	f	\N	\N
334	79142654726	Анастасия	\N	\N	t	2025-10-30 03:04:09.543	2025-10-30 03:04:09.543	f	\N	\N
335	79148267324	Анастасия	Крекер	nastya.kreker.03@mail.ru	t	2025-10-30 03:10:54.76	2025-10-30 03:10:54.76	f	\N	\N
336	79841058575	Людмила	\N	\N	t	2025-10-30 03:37:13.706	2025-10-30 03:37:13.706	f	\N	\N
337	79841058988	Анна	Пашина	\N	t	2025-10-30 04:24:21.809	2025-10-30 04:24:21.809	f	\N	\N
339	79142988068	Елизавета	\N	\N	t	2025-10-30 06:44:36.557	2025-10-30 06:44:36.557	f	\N	\N
340	79142221665	Егор	\N	\N	t	2025-10-30 09:13:06.029	2025-10-30 09:13:06.029	f	\N	\N
341	79142221412	Надежда	\N	\N	t	2025-10-30 21:55:16.919	2025-10-30 21:55:16.919	f	\N	\N
342	79841151201	Елена	\N	\N	t	2025-10-31 00:24:06.273	2025-10-31 00:24:06.273	f	\N	\N
343	79132238605	Дарья	Куликова	vasidaria@bk.ru	t	2025-11-02 16:15:49.705	2025-11-02 16:15:49.705	f	\N	\N
344	79132290331	Надежда	\N	\N	t	2025-11-03 07:44:52.176	2025-11-03 07:44:52.176	f	\N	\N
345	79142379172	Галина	\N	\N	t	2025-11-03 07:55:21.84	2025-11-03 07:55:21.84	f	\N	\N
346	79832447814	Ирина	\N	irina01022006@gmail.com	t	2025-11-03 08:09:54.673	2025-11-03 08:09:54.673	f	\N	\N
347	79191958938	Егор	\N	\N	t	2025-11-04 07:27:15.93	2025-11-04 07:27:15.93	f	\N	\N
348	79142675571	Резеда	Панова	urr7@mail.ru	t	2025-11-04 11:24:06.184	2025-11-04 11:24:06.184	f	\N	\N
349	79142254637	Светлана	Головина	\N	t	2025-11-05 03:36:50.535	2025-11-05 03:36:50.535	f	\N	\N
350	79841011978	Антонина	\N	\N	t	2025-11-06 05:27:18.33	2025-11-06 05:27:18.33	f	\N	\N
351	79142785860	Анастасия	\N	\N	t	2025-11-06 06:00:57.983	2025-11-06 06:00:57.983	f	\N	\N
352	79140393329	Андрей	Барыкин	barykin.86@internet.ru	t	2025-11-07 00:45:27.476	2025-11-07 00:45:27.476	f	\N	\N
353	79142615727	Борис	\N	\N	t	2025-11-07 05:54:44.345	2025-11-07 05:54:44.345	f	\N	\N
354	79142610302	Дмитрий	\N	demonnn81@mail.ru	t	2025-11-07 09:51:34	2025-11-07 09:51:34	f	\N	\N
355	79148272565	Александр	Скориков	skorik-ov@mail.ru	t	2025-11-11 11:13:09.559	2025-11-11 11:13:09.559	f	\N	\N
356	79142330838	Юлия	Никулина	jaika353@gmail.com	t	2025-11-11 11:13:46.159	2025-11-11 11:13:46.159	f	\N	\N
357	79148232431	Валентина	Демченко	valya.demchenko.2000@bk.ru	t	2025-11-11 11:15:20.669	2025-11-11 11:15:20.669	f	\N	\N
358	79891659490	Ксения	\N	\N	t	2025-11-11 11:17:06.07	2025-11-11 11:17:06.07	f	\N	\N
359	79142675504	Анна	Игнатьева	annamaxim2015anna@gmail.com	t	2025-11-11 11:20:29.96	2025-11-11 11:20:29.96	f	\N	\N
360	79141012494	Иван	\N	\N	t	2025-11-11 11:21:11.162	2025-11-11 11:21:11.162	f	\N	\N
361	79141029766	Татьяна	Кривошапкина	taevdo@mail.ru	t	2025-11-11 11:22:58.596	2025-11-11 11:22:58.596	f	\N	\N
362	79142808169	Екатерина	Даутова	katerinadusembaevna@gmail.com	t	2025-11-11 11:25:37.269	2025-11-11 11:25:37.269	f	\N	\N
363	79143006521	Сергей	Сафонов	greysafonov13@gmail.com	t	2025-11-11 11:39:04.623	2025-11-11 11:39:04.623	f	\N	\N
364	79140130627	Виктор	\N	sadykov.viktor.91@mail.ru	t	2025-11-11 11:50:07.289	2025-11-11 11:50:07.289	f	\N	\N
365	79141050314	Инна	\N	yk4017@mail.ru	t	2025-11-11 12:16:41.76	2025-11-11 12:16:41.76	f	\N	\N
366	79142284716	Евгений	Зинченко	Wnezakonabusiness@gmail.com	t	2025-11-11 12:19:36.061	2025-11-11 12:19:36.061	f	\N	\N
367	79142254581	Артур	\N	\N	t	2025-11-11 12:36:37.111	2025-11-11 12:36:37.111	f	\N	\N
368	79142817512	Елена	\N	stepchenko_8181@mail.ru	t	2025-11-11 13:17:39.059	2025-11-11 13:17:39.059	f	\N	\N
369	79142498651	Ида	\N	\N	t	2025-11-11 13:59:19.137	2025-11-11 13:59:19.137	f	\N	\N
370	79143058050	Валертя	\N	\N	t	2025-11-11 14:00:32.222	2025-11-11 14:00:32.222	f	\N	\N
371	79142237424	Инна	Химчак	\N	t	2025-11-11 14:00:56.069	2025-11-11 14:00:56.069	f	\N	\N
372	79142394702	Александр	Вараксин	\N	t	2025-11-11 14:19:17.423	2025-11-11 14:19:17.423	f	\N	\N
373	79831341706	Аида	\N	\N	t	2025-11-11 15:28:04.23	2025-11-11 15:28:04.23	f	\N	\N
374	79142324164	Михаил	\N	\N	t	2025-11-11 21:31:18.774	2025-11-11 21:31:18.774	f	\N	\N
375	79141062795	Елена	\N	snyapka@mail.ru	t	2025-11-11 22:02:20.204	2025-11-11 22:02:20.204	f	\N	\N
376	79141049436	Ольга	Мещерякова	olenka.yasinskay@mail.ru	t	2025-11-11 23:36:22.046	2025-11-11 23:36:22.046	f	\N	\N
377	79142393210	Александра	\N	\N	t	2025-11-12 00:08:08.991	2025-11-12 00:08:08.991	f	\N	\N
378	79141074282	Татьяна	\N	\N	t	2025-11-12 00:27:06.951	2025-11-12 00:27:06.951	f	\N	\N
379	79141074202	Татьяна	\N	\N	t	2025-11-12 00:33:23.679	2025-11-12 00:33:23.679	f	\N	\N
380	79841027967	Алина	\N	\N	t	2025-11-12 02:16:21.133	2025-11-12 02:16:21.133	f	\N	\N
381	79142380906	Сергей	\N	\N	t	2025-11-12 03:21:31.086	2025-11-12 03:21:31.086	f	\N	\N
382	79148208914	Амгалена	Гайнутдинова	\N	t	2025-11-12 03:21:43.103	2025-11-12 03:21:43.103	f	\N	\N
383	79142994320	Надежда	Егорова	\N	t	2025-11-12 03:37:25.443	2025-11-12 03:37:25.443	f	\N	\N
384	79142960993	Татьяна	\N	\N	t	2025-11-12 06:05:34.979	2025-11-12 06:05:34.979	f	\N	\N
385	79841198905	Наталья	Волдаева	\N	t	2025-11-12 07:47:19.98	2025-11-12 07:47:19.98	f	\N	\N
386	79142355345	Светлана	Кочемас	skochemas@mail.ru	t	2025-11-12 23:34:52.503	2025-11-12 23:34:52.503	f	\N	\N
387	79137062283	Анастасия	\N	\N	t	2025-11-13 00:19:53.05	2025-11-13 00:19:53.05	f	\N	\N
388	79841178120	Игорь	Головин	Golovin752@gmail.com	t	2025-11-13 00:33:09.481	2025-11-13 00:33:09.481	f	\N	\N
389	79841019722	Светлана	\N	\N	t	2025-11-13 03:11:10.606	2025-11-13 03:11:10.606	f	\N	\N
390	79141098079	Антонина	Жигулина	jav1984@yandex.ru	t	2025-11-13 06:07:24.891	2025-11-13 06:07:24.891	f	\N	\N
391	79240171919	Евгений	И.	\N	t	2025-11-13 06:31:04.874	2025-11-13 06:31:04.874	f	\N	\N
392	79148261159	Виктория	Лимонова	vl2905@mail.ru	t	2025-11-13 16:19:46.993	2025-11-13 16:19:46.993	f	\N	\N
393	79141082002	Елена	Никитина	\N	t	2025-11-14 01:00:35.246	2025-11-14 01:00:35.246	f	\N	\N
394	79148291518	Александр	\N	\N	t	2025-11-14 13:22:55.115	2025-11-14 13:22:55.115	f	\N	\N
395	79142351753	Альбина	\N	\N	t	2025-11-14 18:40:29.774	2025-11-14 18:40:29.774	f	\N	\N
396	79142965848	Евгения	\N	\N	t	2025-11-15 06:48:14.103	2025-11-15 06:48:14.103	f	\N	\N
397	79143037006	Наталья	\N	\N	t	2025-11-15 11:00:25.212	2025-11-15 11:00:25.212	f	\N	\N
398	79141050338	Светлана	\N	\N	t	2025-11-16 09:09:41.847	2025-11-16 09:09:41.847	f	\N	\N
399	79142247789	Айдар	Газизуллин	\N	t	2025-11-17 02:29:39.746	2025-11-17 02:29:39.746	f	\N	\N
400	79841180476	Алина	Газизуллина	\N	t	2025-11-17 02:42:06.907	2025-11-17 02:42:06.907	f	\N	\N
401	79148242310	Елена	Зайцева	\N	t	2025-11-17 06:04:28.218	2025-11-17 06:04:28.218	f	\N	\N
402	79142375224	Людмила	\N	\N	t	2025-11-17 07:51:49.846	2025-11-17 07:51:49.846	f	\N	\N
403	79143003137	Валентина	Кондакова	konda-75@mail.ru	t	2025-11-18 21:50:46.094	2025-11-18 21:50:46.094	f	\N	\N
404	79182553297	Лена	\N	\N	t	2025-11-20 00:54:27.005	2025-11-20 00:54:27.005	f	\N	\N
405	79148265613	Надежда	Ширяева	nadyuha12578@mail.ru	t	2025-11-20 05:53:48.643	2025-11-20 05:53:48.643	f	\N	\N
406	79245637130	Надежда	Ширяева	nadyuha12578@mail.ru	t	2025-11-20 05:54:53.293	2025-11-20 05:54:53.293	f	\N	\N
407	79888692936	Александра	\N	aleksa.vinichenko@mail.ru	t	2025-11-23 00:02:38.491	2025-11-23 00:02:38.491	f	\N	\N
408	79142997302	Ольга	\N	\N	t	2025-11-23 00:59:43.62	2025-11-23 00:59:43.62	f	\N	\N
409	79841020736	Максим	\N	maksandrushenko44@gmail.com	t	2025-11-23 09:56:23.685	2025-11-23 09:56:23.685	f	\N	\N
410	79870193994	Айгуль	Закирова	ajgulzin@yandex.ru	t	2025-11-23 23:49:08.042	2025-11-23 23:49:08.042	f	\N	\N
411	79148290329	Алена	Васильева	vasalena97@mail.ru	t	2025-11-24 07:16:20.355	2025-11-24 07:16:20.355	f	\N	\N
412	79142987606	Яна	\N	\N	t	2025-11-24 09:24:33.724	2025-11-24 09:24:33.724	f	\N	\N
413	79141051484	Людмила	Ермакова	ludmilaermakova08@gmail.com	t	2025-11-24 11:19:57.228	2025-11-24 11:19:57.228	f	\N	\N
414	79104728501	Наталья	\N	tusia2180@yandex.ru	t	2025-11-24 23:46:02.299	2025-11-24 23:46:02.299	f	\N	\N
415	79142808155	Анастасия	Попова	\N	t	2025-11-25 09:54:29.29	2025-11-25 09:54:29.29	f	\N	\N
416	79142653784	Татьяна	\N	\N	t	2025-11-25 09:57:14.835	2025-11-25 09:57:14.835	f	\N	\N
417	79141001394	Елена	Поцелуева	\N	t	2025-11-25 10:03:39.917	2025-11-25 10:03:39.917	f	\N	\N
418	79141024616	Александр	Андросов	androsov95@mail.ru	t	2025-11-25 10:13:12.02	2025-11-25 10:13:12.02	f	\N	\N
419	79142810781	Максим	Егоров	egmaximego@yandex.ru	t	2025-11-25 10:37:40.16	2025-11-25 10:37:40.16	f	\N	\N
420	79143006295	Дима	\N	\N	t	2025-11-25 11:20:30.656	2025-11-25 11:20:30.656	f	\N	\N
421	79141067855	Елена	\N	\N	t	2025-11-26 01:29:40.849	2025-11-26 01:29:40.849	f	\N	\N
422	79148271162	Наталья	\N	\N	t	2025-11-26 08:56:36.67	2025-11-26 08:56:36.67	f	\N	\N
423	79247077091	Татьяна	\N	\N	t	2025-11-27 02:17:00.218	2025-11-27 02:17:00.218	f	\N	\N
424	79142329421	Таисия	\N	\N	t	2025-11-29 00:57:55.536	2025-11-29 00:57:55.536	f	\N	\N
425	79142985424	Мария	Никитенко	\N	t	2025-11-30 06:06:14.827	2025-11-30 06:06:14.827	f	\N	\N
426	79841087232	Олег	Муратов	neramuratov@mail.ru	t	2025-12-01 06:49:49.746	2025-12-01 06:49:49.746	f	\N	\N
427	79141161748	Александра	Матаркина	matarkina_1997@mail.com	t	2025-12-01 07:33:51.848	2025-12-01 07:33:51.848	f	\N	\N
460	79142325769	Надежда	\N	\N	t	2025-12-02 06:36:02.482	2025-12-02 06:36:02.482	f	\N	\N
461	79142325762	Надежда	\N	\N	t	2025-12-02 06:36:35.947	2025-12-02 06:36:35.947	f	\N	\N
462	79142380779	Ксенья	\N	\N	t	2025-12-02 09:05:57.227	2025-12-02 09:05:57.227	f	\N	\N
463	79841184149	Екатерина	Загребина	e.zagrebina@bk.ru	t	2025-12-04 09:11:07.018	2025-12-04 09:11:07.018	f	\N	\N
464	79142306055	Валерий	\N	\N	t	2025-12-07 13:36:37.15	2025-12-07 13:36:37.15	f	\N	\N
465	79142805341	Виктория	\N	\N	t	2025-12-07 13:45:33.6	2025-12-07 13:45:33.6	f	\N	\N
466	79142269276	Любовь	\N	\N	t	2025-12-07 23:03:47.373	2025-12-07 23:03:47.373	f	\N	\N
467	79142834713	Дулма	Комиссарова	kom-dulma@yandex.ru	t	2025-12-08 04:59:40.746	2025-12-08 04:59:40.746	f	\N	\N
468	79142854121	Анна	\N	anna.muratova.1983@mail.ru	t	2025-12-08 05:55:52.622	2025-12-08 05:55:52.622	f	\N	\N
469	79969146616	Olga	\N	\N	t	2025-12-09 09:40:22.945	2025-12-09 09:40:22.945	f	\N	\N
\.


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.addresses_id_seq', 132, true);


--
-- Name: batch_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.batch_items_id_seq', 73, true);


--
-- Name: batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.batches_id_seq', 246, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.categories_id_seq', 4252, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.order_items_id_seq', 686, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.orders_id_seq', 560, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.payments_id_seq', 255, true);


--
-- Name: product_snapshots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.product_snapshots_id_seq', 14380, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.products_id_seq', 54665, true);


--
-- Name: supplier_category_mappings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.supplier_category_mappings_id_seq', 1765, true);


--
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 612, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.users_id_seq', 469, true);


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
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: product_snapshots product_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.product_snapshots
    ADD CONSTRAINT product_snapshots_pkey PRIMARY KEY (id);


--
-- Name: product_snapshots product_snapshots_product_id_key; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.product_snapshots
    ADD CONSTRAINT product_snapshots_product_id_key UNIQUE (product_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: supplier_category_mappings supplier_category_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.supplier_category_mappings
    ADD CONSTRAINT supplier_category_mappings_pkey PRIMARY KEY (id);


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
-- Name: idx_product_snapshots_product_id; Type: INDEX; Schema: public; Owner: superadmin
--

CREATE INDEX idx_product_snapshots_product_id ON public.product_snapshots USING btree (product_id);


--
-- Name: payments_createdAt_idx; Type: INDEX; Schema: public; Owner: superadmin
--

CREATE INDEX "payments_createdAt_idx" ON public.payments USING btree ("createdAt");


--
-- Name: payments_orderId_idx; Type: INDEX; Schema: public; Owner: superadmin
--

CREATE INDEX "payments_orderId_idx" ON public.payments USING btree ("orderId");


--
-- Name: payments_paymentId_key; Type: INDEX; Schema: public; Owner: superadmin
--

CREATE UNIQUE INDEX "payments_paymentId_key" ON public.payments USING btree ("paymentId");


--
-- Name: payments_status_idx; Type: INDEX; Schema: public; Owner: superadmin
--

CREATE INDEX payments_status_idx ON public.payments USING btree (status);


--
-- Name: supplier_category_mappings_supplierCategory_key; Type: INDEX; Schema: public; Owner: superadmin
--

CREATE UNIQUE INDEX "supplier_category_mappings_supplierCategory_key" ON public.supplier_category_mappings USING btree ("supplierCategory");


--
-- Name: supplier_category_mappings_targetCategoryId_idx; Type: INDEX; Schema: public; Owner: superadmin
--

CREATE INDEX "supplier_category_mappings_targetCategoryId_idx" ON public.supplier_category_mappings USING btree ("targetCategoryId");


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
-- Name: payments payments_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT "payments_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES public.orders(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: products products_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "products_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: supplier_category_mappings supplier_category_mappings_targetCategoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superadmin
--

ALTER TABLE ONLY public.supplier_category_mappings
    ADD CONSTRAINT "supplier_category_mappings_targetCategoryId_fkey" FOREIGN KEY ("targetCategoryId") REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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

\unrestrict 7tIGHStsGpSdgRybUdGlZnP0bvxLjNxqx1Ito7dOunwgbPz0ESvcjA4WQUnJxqu

