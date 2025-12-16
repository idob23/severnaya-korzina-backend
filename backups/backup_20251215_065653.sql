--
-- PostgreSQL database dump
--

\restrict AOwvaVfRG9RWLjc42XgealxgxhQItwm5PBcHNlXN5vL4liBvNCU2o8SP25P76EL

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
42	285	Дом	пгт. Усть-Нера, ул. Мацкепладзе, д. 15	t	2025-10-17 12:54:08.797
43	295	дом	п. Усть-Нера, ул. Цареградского, д. 12, кв. 7	t	2025-10-18 00:31:53.019
44	293	дом	п. Усть-Нера,ул. Мацкепладзе 16 квартира 11	f	2025-10-18 00:46:18.174
45	293	дом	п. Усть-Нера, улица Мацкепладзе 16 кв 11	t	2025-10-18 00:47:05.648
46	297	Дом	Усть-нера  Гагарина 20а кв 1	f	2025-10-20 02:37:46.296
47	317	дом	пооаоаволлвлвлвдыдяьчьшччд	f	2025-10-21 11:36:13.016
48	309	дом	Ленина 1пллплп	f	2025-10-21 23:20:01.389
50	317	щошыува	ыщвшопы	f	2025-10-22 11:31:06.428
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
133	398	дом	п.Усть Нера ул.Мацкепладзе д 12 кв 30	f	2025-12-09 22:11:24.161
134	360	Дом	пгт. Усть-Нера, ул. Водная, д.2	f	2025-12-10 03:24:28.965
135	360	Дом	пгт. Усть-Нера, ул. Водная, д.2	t	2025-12-10 04:22:47.922
136	473	Дом	п. Усть-Нера, ул. Мацкепладзе д. 12, кВ. 24	f	2025-12-11 09:22:03.33
137	473	Дом	п. Усть-Нера, ул.Мацкепладзе д. 12, кВ.24	t	2025-12-11 09:25:50.017
139	475	коунистичс	коунистичс	f	2025-12-12 01:41:40.976
140	476	Усть-Нера,Молодежная д.3 кв.30	Усть-Нера,Молодежная д.3 кв.30	f	2025-12-14 06:48:27.361
138	323	коммунистическая 7,11	коммунистическая 7,11	f	2025-12-11 11:38:16.013
141	471	Чисхана Заболоцкого, дом 12	Чисхана Заболоцкого, дом 12	f	2025-12-15 01:25:23.445
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
249	14.12.25	Автоматически созданная партия для сбора заказов	2025-12-14 13:41:16.113	2025-12-21 13:41:16.113	\N	5	\N	collecting	\N	250000.00	22132.04	2	9	2025-12-15 01:36:00.408	t	15.00	2025-12-14 13:41:16.114	2025-12-15 01:36:00.409	2025-12-14 13:41:16.113
246	7.12.25	Автоматически созданная партия для сбора заказов	2025-12-07 13:20:08.565	2025-12-14 13:20:08.565	\N	5	\N	completed	\N	200000.00	255926.83	10	100	2025-12-10 11:36:00.711	t	15.00	2025-12-07 13:20:08.566	2025-12-10 11:39:23.331	2025-12-07 13:20:08.565
210	1.12.25	Автоматически созданная партия для сбора заказов	2025-11-30 10:56:19.418	2025-12-07 10:56:19.418	\N	5	\N	completed	\N	150000.00	78885.40	5	53	2025-12-03 08:48:00.334	t	15.00	2025-11-30 10:56:19.419	2025-12-03 11:49:08.822	2025-11-30 10:56:19.418
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.categories (id, name, description, "imageUrl", "isActive", "createdAt") FROM stdin;
3367	Рыба и морепродукты	Автоматически из прайса	\N	t	2025-11-22 11:50:47.914
4594	Дисконт	Товары со скидкой	\N	t	2025-12-11 09:02:43.974
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
686	560	54106	1	420.13
761	577	53840	1	2849.70
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
1009	589	52956	6	321.33
1010	589	54145	2	6414.70
1011	589	52447	1	3300.50
1012	589	52880	25	346.50
1013	589	53091	1	3630.55
1014	589	53778	10	899.30
1015	589	54031	15	612.38
1016	589	54210	15	495.94
1017	589	54556	20	157.38
1018	589	54549	12	305.52
1019	589	54540	15	312.11
1020	589	54535	15	462.88
1021	589	54452	15	349.14
1022	589	54144	15	657.34
1023	589	53556	1	6221.50
1024	589	53455	1	2665.70
1025	589	53934	12	530.34
1026	589	54245	1	15711.30
1027	589	52876	20	277.73
1028	589	52544	1	2856.60
1029	589	53441	1	2237.90
1030	589	52662	5	308.14
671	550	54176	1	1184.50
672	550	54133	1	437.69
673	550	54661	1	1044.80
674	550	54151	2	330.62
1031	589	53762	1	4681.65
1032	589	54299	15	244.67
1033	590	52789	1	1507.65
1034	590	52801	10	223.45
1035	590	53113	2	482.71
1036	590	53221	1	969.45
1037	590	53491	1	2337.95
1038	590	54103	1	6841.35
1039	590	54235	1	4999.05
1040	590	54659	5	400.72
1041	591	54239	1	10124.60
1042	591	54258	1	6612.50
1043	591	54263	1	4376.90
1044	591	54124	1	5336.00
1097	603	56519	1	10367.25
1098	603	55509	20	111.61
1099	603	56104	1	1825.05
1102	606	56258	1	1976.85
1103	606	56420	1	435.13
1104	606	56421	1	435.13
1105	606	56201	1	826.85
1106	606	56617	2	416.59
1107	606	56644	2	1600.23
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.orders (id, "userId", "batchId", "addressId", status, "totalAmount", notes, "createdAt", "updatedAt") FROM stdin;
420	309	191	48	delivered	4287.50	\N	2025-10-26 23:55:00.414	2025-11-05 11:31:58.367
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
536	384	246	132	shipped	2916.40	\N	2025-12-09 08:49:40.165	2025-12-14 08:17:22.573
589	360	246	135	shipped	141008.25	Связаться со мной за час до доставки	2025-12-10 05:58:14.503	2025-12-14 08:17:22.573
590	282	246	53	shipped	21858.91	\N	2025-12-10 07:30:46.894	2025-12-14 08:17:22.573
591	372	246	87	shipped	26450.00	\N	2025-12-10 11:33:22.961	2025-12-14 08:17:22.573
427	282	193	53	delivered	5490.00	\N	2025-11-03 00:51:07.834	2025-11-11 09:35:33.779
430	342	193	54	delivered	7623.75	\N	2025-11-04 06:29:44.358	2025-11-11 09:35:33.779
455	374	207	73	delivered	26008.40	\N	2025-11-24 03:25:16.934	2025-12-02 05:53:00.604
456	399	207	67	delivered	6744.75	\N	2025-11-24 06:17:28.942	2025-12-02 05:53:00.604
458	282	207	53	delivered	31389.25	\N	2025-11-25 09:00:05.771	2025-12-02 05:53:00.604
460	391	207	65	delivered	243.80	\N	2025-11-25 10:04:15.472	2025-12-02 05:53:00.604
461	407	207	80	delivered	6725.20	позвонить за час до доставки 	2025-11-25 11:09:07.147	2025-12-02 05:53:00.604
463	416	207	81	delivered	4041.10	\N	2025-11-25 11:19:11.166	2025-12-02 05:53:00.604
464	399	207	67	delivered	5783.35	привет как дела?)	2025-11-25 23:32:11.949	2025-12-02 05:53:00.604
550	465	246	131	shipped	3328.24	Перезвонить о доставке. 	2025-12-09 10:08:37.759	2025-12-14 08:17:22.573
560	465	246	131	shipped	420.13	\N	2025-12-09 10:29:21.373	2025-12-14 08:17:22.573
466	359	207	85	delivered	3873.20	\N	2025-11-26 01:17:15.885	2025-12-02 05:53:00.604
603	399	249	67	paid	14424.45	\N	2025-12-15 00:28:11.323	2025-12-15 00:30:00.233
606	471	249	141	paid	7707.59	\N	2025-12-15 01:32:36.996	2025-12-15 01:36:00.384
467	412	207	83	delivered	9279.35	позвонить за час	2025-11-26 03:12:45.357	2025-12-02 05:53:00.604
469	411	207	74	delivered	8674.45	Позвонить за час до доставки 	2025-11-26 04:13:55.751	2025-12-02 05:53:00.604
577	416	246	81	shipped	2849.70	\N	2025-12-10 03:32:28.225	2025-12-14 08:17:22.573
522	415	246	129	shipped	11833.50	\N	2025-12-07 23:40:20.736	2025-12-14 08:17:22.573
527	466	246	130	shipped	4332.05	да,пожайлуста, позвоните за 1 час.	2025-12-08 02:04:55.167	2025-12-14 08:17:22.573
529	407	246	80	shipped	15163.90	предупредить заранее о доставке	2025-12-08 10:37:02.935	2025-12-14 08:17:22.573
530	374	246	73	shipped	25765.75	\N	2025-12-08 14:51:52.108	2025-12-14 08:17:22.573
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.payments (id, "paymentId", "orderId", provider, status, amount, metadata, "createdAt", "paidAt") FROM stdin;
163	77e5b39d-c435-443a-8199-df9b8f1aaf0a	450	tochka	APPROVED	26178.75	{"breakdown":{"goods":20943,"service":5235.75,"total":26178.75,"marginPercent":25,"itemsCount":7},"confirmationUrl":"https://merch.tochka.com/order/?uuid=77e5b39d-c435-443a-8199-df9b8f1aaf0a","userId":371,"batchId":199,"customerPhone":"79142237424","cronUpdatedAt":"2025-11-12T09:42:00.650Z","previousStatus":"CREATED"}	2025-11-12 09:39:29.191	2025-11-12 09:42:00.65
169	9c143911-4506-4495-9293-0fdc9e52afd1	458	tochka	APPROVED	31389.25	{"breakdown":{"goods":27295,"service":4094.25,"total":31389.249999999996,"marginPercent":15,"itemsCount":11},"confirmationUrl":"https://merch.tochka.com/order/?uuid=9c143911-4506-4495-9293-0fdc9e52afd1","userId":282,"batchId":207,"customerPhone":"79142654503","cronUpdatedAt":"2025-11-25T09:03:00.429Z","previousStatus":"CREATED"}	2025-11-25 09:00:06.607	2025-11-25 09:03:00.429
171	a7a9213b-2a67-41d0-b3fb-98e08849b04d	460	tochka	APPROVED	243.80	{"breakdown":{"goods":212,"service":31.8,"total":243.79999999999998,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=a7a9213b-2a67-41d0-b3fb-98e08849b04d","userId":391,"batchId":207,"customerPhone":"79240171919","cronUpdatedAt":"2025-11-25T10:12:00.505Z","previousStatus":"CREATED"}	2025-11-25 10:04:16.494	2025-11-25 10:12:00.505
172	b2326fb0-0c56-456d-ba66-5a6c97539f49	461	tochka	APPROVED	6725.20	{"breakdown":{"goods":5848,"service":877.2,"total":6725.2,"marginPercent":15,"itemsCount":4},"confirmationUrl":"https://merch.tochka.com/order/?uuid=b2326fb0-0c56-456d-ba66-5a6c97539f49","userId":407,"batchId":207,"customerPhone":"79888692936","cronUpdatedAt":"2025-11-25T11:12:00.408Z","previousStatus":"CREATED"}	2025-11-25 11:09:07.697	2025-11-25 11:12:00.408
174	5e74b1fa-bd36-403c-bd2a-a2bc54970dcf	463	tochka	APPROVED	4041.10	{"breakdown":{"goods":3514,"service":527.1,"total":4041.0999999999995,"marginPercent":15,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=5e74b1fa-bd36-403c-bd2a-a2bc54970dcf","userId":416,"batchId":207,"customerPhone":"79142653784","cronUpdatedAt":"2025-11-25T11:21:00.566Z","previousStatus":"CREATED"}	2025-11-25 11:19:11.671	2025-11-25 11:21:00.566
175	7457d0da-875d-4f25-b8a2-fc6a4305cbb1	464	tochka	APPROVED	5783.35	{"breakdown":{"goods":5029,"service":754.35,"total":5783.349999999999,"marginPercent":15,"itemsCount":3},"confirmationUrl":"https://merch.tochka.com/order/?uuid=7457d0da-875d-4f25-b8a2-fc6a4305cbb1","userId":399,"batchId":207,"customerPhone":"79142247789","cronUpdatedAt":"2025-11-25T23:36:00.308Z","previousStatus":"CREATED"}	2025-11-25 23:32:12.5	2025-11-25 23:36:00.308
255	ee19336b-b2e8-427c-981b-62b5fb623caa	560	tochka	APPROVED	420.13	{"breakdown":{"goods":365.3333333333333,"service":54.8,"total":420.13333333333327,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=ee19336b-b2e8-427c-981b-62b5fb623caa","userId":465,"batchId":246,"customerPhone":"79142805341","cronUpdatedAt":"2025-12-09T10:33:01.282Z","previousStatus":"CREATED"}	2025-12-09 10:29:21.803	2025-12-09 10:33:01.282
264	c044d770-164c-4eec-876f-673b3739d2b1	577	tochka	APPROVED	2849.70	{"breakdown":{"goods":2478,"service":371.7,"total":2849.7,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=c044d770-164c-4eec-876f-673b3739d2b1","userId":416,"batchId":246,"customerPhone":"79142653784","cronUpdatedAt":"2025-12-10T03:36:01.175Z","previousStatus":"CREATED"}	2025-12-10 03:32:28.743	2025-12-10 03:36:01.175
269	af5e8b1e-b293-4d8b-b89b-81d766b40f7d	589	tochka	APPROVED	141008.25	{"breakdown":{"goods":122615.87,"service":18392.3,"total":141008.25305555554,"marginPercent":15,"itemsCount":24},"confirmationUrl":"https://merch.tochka.com/order/?uuid=af5e8b1e-b293-4d8b-b89b-81d766b40f7d","userId":360,"batchId":246,"customerPhone":"79141012494","cronUpdatedAt":"2025-12-10T06:00:00.422Z","previousStatus":"CREATED"}	2025-12-10 05:58:15.357	2025-12-10 06:00:00.422
270	c681e0d3-c83a-40b0-a0e0-8feb33788d59	590	tochka	APPROVED	21858.91	{"breakdown":{"goods":19007.75,"service":2851.16,"total":21858.9125,"marginPercent":15,"itemsCount":8},"confirmationUrl":"https://merch.tochka.com/order/?uuid=c681e0d3-c83a-40b0-a0e0-8feb33788d59","userId":282,"batchId":246,"customerPhone":"79142654503","cronUpdatedAt":"2025-12-10T07:33:00.258Z","previousStatus":"CREATED"}	2025-12-10 07:30:47.949	2025-12-10 07:33:00.258
283	b0b13865-9318-44d3-bb43-59ddb6749717	603	tochka	APPROVED	14424.45	{"breakdown":{"goods":12543,"service":1881.45,"total":14424.449999999999,"marginPercent":15,"itemsCount":3},"confirmationUrl":"https://merch.tochka.com/order/?uuid=b0b13865-9318-44d3-bb43-59ddb6749717","userId":399,"batchId":249,"customerPhone":"79142247789","cronUpdatedAt":"2025-12-15T00:30:00.213Z","previousStatus":"CREATED"}	2025-12-15 00:28:11.807	2025-12-15 00:30:00.213
284	e5908873-f7b1-415d-80e5-f5bc35d07080	606	tochka	APPROVED	7707.59	{"breakdown":{"goods":6702.26,"service":1005.33,"total":7707.5875,"marginPercent":15,"itemsCount":6},"confirmationUrl":"https://merch.tochka.com/order/?uuid=e5908873-f7b1-415d-80e5-f5bc35d07080","userId":471,"batchId":249,"customerPhone":"79142880332","cronUpdatedAt":"2025-12-15T01:36:00.361Z","previousStatus":"CREATED"}	2025-12-15 01:32:37.372	2025-12-15 01:36:00.361
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
271	0fc3e28d-a812-40a4-b32f-3d5c876b93ed	591	tochka	APPROVED	26450.00	{"breakdown":{"goods":23000,"service":3450,"total":26450,"marginPercent":15,"itemsCount":4},"confirmationUrl":"https://merch.tochka.com/order/?uuid=0fc3e28d-a812-40a4-b32f-3d5c876b93ed","userId":372,"batchId":246,"customerPhone":"79142394702","cronUpdatedAt":"2025-12-10T11:36:00.679Z","previousStatus":"CREATED"}	2025-12-10 11:33:23.903	2025-12-10 11:36:00.679
159	a0af753a-7819-4385-901b-a34aca2306d7	446	tochka	APPROVED	2437.50	{"breakdown":{"goods":1950,"service":487.5,"total":2437.5,"marginPercent":25,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=a0af753a-7819-4385-901b-a34aca2306d7","userId":356,"batchId":199,"customerPhone":"79142330838","cronUpdatedAt":"2025-11-11T11:33:00.289Z","previousStatus":"CREATED"}	2025-11-11 11:30:59.891	2025-11-11 11:33:00.289
160	e85419e1-6226-4454-9d6c-c01500815355	447	tochka	APPROVED	6020.00	{"breakdown":{"goods":4816,"service":1204,"total":6020,"marginPercent":25,"itemsCount":3},"confirmationUrl":"https://merch.tochka.com/order/?uuid=e85419e1-6226-4454-9d6c-c01500815355","userId":361,"batchId":199,"customerPhone":"79141029766","cronUpdatedAt":"2025-11-11T11:57:00.231Z","previousStatus":"CREATED"}	2025-11-11 11:52:36.609	2025-11-11 11:57:00.231
161	bb049aaf-9b84-4741-8efd-bcfc33981aab	448	tochka	APPROVED	25157.50	{"breakdown":{"goods":20126,"service":5031.5,"total":25157.5,"marginPercent":25,"itemsCount":7},"confirmationUrl":"https://merch.tochka.com/order/?uuid=bb049aaf-9b84-4741-8efd-bcfc33981aab","userId":374,"batchId":199,"customerPhone":"79142324164","cronUpdatedAt":"2025-11-12T01:42:00.350Z","previousStatus":"CREATED"}	2025-11-12 01:36:54.853	2025-11-12 01:42:00.35
162	ab2d9f49-544c-4b09-bcfd-3843040fb457	449	tochka	APPROVED	47921.25	{"breakdown":{"goods":38337,"service":9584.25,"total":47921.25,"marginPercent":25,"itemsCount":12},"confirmationUrl":"https://merch.tochka.com/order/?uuid=ab2d9f49-544c-4b09-bcfd-3843040fb457","userId":360,"batchId":199,"customerPhone":"79141012494","cronUpdatedAt":"2025-11-12T07:15:00.411Z","previousStatus":"CREATED"}	2025-11-12 07:11:34.686	2025-11-12 07:15:00.411
167	7161168a-d64a-47c6-aa2a-92f2af42b7c9	455	tochka	APPROVED	26008.40	{"breakdown":{"goods":22616,"service":3392.4,"total":26008.39999999999,"marginPercent":15,"itemsCount":13},"confirmationUrl":"https://merch.tochka.com/order/?uuid=7161168a-d64a-47c6-aa2a-92f2af42b7c9","userId":374,"batchId":207,"customerPhone":"79142324164","cronUpdatedAt":"2025-11-24T03:27:00.254Z","previousStatus":"CREATED"}	2025-11-24 03:25:17.586	2025-11-24 03:27:00.254
168	0ec573a6-1491-47bd-9451-6c7854cf6809	456	tochka	APPROVED	6744.75	{"breakdown":{"goods":5865,"service":879.75,"total":6744.749999999999,"marginPercent":15,"itemsCount":3},"confirmationUrl":"https://merch.tochka.com/order/?uuid=0ec573a6-1491-47bd-9451-6c7854cf6809","userId":399,"batchId":207,"customerPhone":"79142247789","cronUpdatedAt":"2025-11-24T06:21:00.414Z","previousStatus":"CREATED"}	2025-11-24 06:17:29.5	2025-11-24 06:21:00.414
136	5327a5b5-4ed1-4544-8f9e-b1dc8b1cd9da	420	tochka	APPROVED	4287.50	{"breakdown":{"goods":3430,"service":857.5,"total":4287.5,"marginPercent":25,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=5327a5b5-4ed1-4544-8f9e-b1dc8b1cd9da","userId":309,"batchId":191,"customerPhone":"79142347019","cronUpdatedAt":"2025-10-26T23:57:00.390Z","previousStatus":"CREATED"}	2025-10-26 23:55:00.98	2025-10-26 23:57:00.39
238	4cd54db7-8050-4e98-8ba3-83d2adb9a04a	536	tochka	APPROVED	2916.40	{"breakdown":{"goods":2536,"service":380.4,"total":2916.3999999999996,"marginPercent":15,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=4cd54db7-8050-4e98-8ba3-83d2adb9a04a","userId":384,"batchId":246,"customerPhone":"79142960993","cronUpdatedAt":"2025-12-09T08:54:01.070Z","previousStatus":"CREATED"}	2025-12-09 08:49:40.633	2025-12-09 08:54:01.07
140	8e24a989-27a7-46f4-bee8-7ab0b10e451e	427	tochka	APPROVED	5490.00	{"breakdown":{"goods":4392,"service":1098,"total":5490,"marginPercent":25,"itemsCount":1},"confirmationUrl":"https://merch.tochka.com/order/?uuid=8e24a989-27a7-46f4-bee8-7ab0b10e451e","userId":282,"batchId":193,"customerPhone":"79142654503","cronUpdatedAt":"2025-11-03T00:57:00.321Z","previousStatus":"CREATED"}	2025-11-03 00:51:08.356	2025-11-03 00:57:00.321
143	a21d2e26-da9e-490a-ad4c-48a0ba9c8363	430	tochka	APPROVED	7623.75	{"breakdown":{"goods":6099,"service":1524.75,"total":7623.75,"marginPercent":25,"itemsCount":2},"confirmationUrl":"https://merch.tochka.com/order/?uuid=a21d2e26-da9e-490a-ad4c-48a0ba9c8363","userId":342,"batchId":193,"customerPhone":"79841151201","cronUpdatedAt":"2025-11-04T06:33:00.576Z","previousStatus":"CREATED"}	2025-11-04 06:29:44.857	2025-11-04 06:33:00.576
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
14381	54452	ПЕЛЬМЕНИ Премиум рыбные с кальмаром 400гр п/пак коробка РПЗ ТАНДЕМ	шт	4554.00	2025-12-14 11:20:30.049223
14382	54210	УТЕНОК Полутушка пряные травы маринад пакет (1шт~1кг) 1/3-4кг ТМ Улыбино	кг	1725.00	2025-12-14 11:21:41.79195
14383	54151	ЦЫПЛЕНОК-КОРНИШОН СУДАНСКИЙ БРОЙЛЕР (1шт-350-400гр) ЦЕНА ЗА ШТ	шт	5750.00	2025-12-14 11:21:42.131744
14384	54145	ФИЛЕ ОКОРОЧКА КУР без кожи без кости лоток ТМ ДОМОСЕДКА	уп (10 шт)	5578.00	2025-12-14 11:21:42.485519
14385	54106	ГОЛЕНЬ ИНДЕЙКА индивидуальная упаковка (1шт~500гр)ТМ Индилайт	кг	2192.00	2025-12-14 11:21:42.834804
14386	53830	СЫРОК Савушкин Творобушки манго глазированный 40гр	уп (18 шт)	952.00	2025-12-14 11:21:43.167818
14387	53829	СЫРОК Савушкин Творобушки малина глазированный 40гр	уп (18 шт)	952.00	2025-12-14 11:21:43.517251
14388	53762	СЛИВКИ питьевые Молочный мир 33% 500мл стерилизованные	уп (12 шт)	4071.00	2025-12-14 11:21:44.684838
14389	53556	АНАНАС кусочки 565гр ж/б ТМ Знаток	уп (24 шт)	5410.00	2025-12-14 11:21:45.075729
14390	52438	ЭСКИМО БРЕСТ-ЛИТОВСК ваниль в глазури 70гр ТМ Санта Бремор	уп (32 шт)	3496.00	2025-12-14 15:09:05.974921
14391	52447	ВАФ СТАКАНЧИК Пломбир фисташковый 15% 70гр ТМ Село Зелёное	уп (24 шт)	2870.00	2025-12-14 15:09:05.984329
14392	52517	ЭСКИМО Пломбир ванильный в шок. глазури с миндалем 12% 80гр ТМ Чистая Линия	уп (21 шт)	3309.00	2025-12-14 15:09:05.998615
14393	52544	ВАФ СТАКАНЧИК Пломбир 48 Копеек 15% 88гр ТМ Нестле Старая цена 82р	уп (30 шт)	2484.00	2025-12-14 15:09:06.014449
14394	52662	КОЛБАСА СПК Нарезка с/к Пипперони Эликатессе 100гр в/уп	шт	24115.00	2025-12-14 15:09:06.02839
14395	52676	ВАФЛИ Коломенские 140гр Палочки с орешками	уп (18 шт)	1780.00	2025-12-14 15:09:06.06106
14396	52686	ПЕЧЕНЬЕ Коломенское 120гр Овсяное хрустящее	уп (22 шт)	1164.00	2025-12-14 15:09:06.070813
14397	52688	ПЕЧЕНЬЕ Коломенское 120гр Шоколадное	уп (22 шт)	1164.00	2025-12-14 15:09:06.082243
14398	52789	ХАЛВА подсолнечная воздушная 200г ТМ Тимоша	уп (12 шт)	1311.00	2025-12-14 15:09:06.100002
14399	52801	КОНФЕТЫ 200гр Курага в глазури 1/10шт ТМ Тимоша	шт	1943.00	2025-12-14 15:09:06.109828
14400	52857	СЫР вес Белорусское Золото 45% (1шт~2кг) кубик ТМ Воложин Беларусь	шт	1851.00	2025-12-14 15:09:06.119211
14401	52876	СЫР-БРУС SVEZA Моцарелла для пиццы 200гр 40%	шт	2415.00	2025-12-14 15:09:06.131875
14402	52880	СЫР-БРУС Брест-Литовск 200гр Классический 45% полутвердый Беларусь	шт	3013.00	2025-12-14 15:09:06.141175
14403	52956	МАЙОНЕЗ Слобода Провансаль 67% дой-пак 800мл	шт	3353.00	2025-12-14 15:09:06.151535
14404	53086	МАСЛО "Алтай" 5л подсолнечное рафинированное Высший сорт *	уп (3 шт)	2536.00	2025-12-14 15:09:06.16484
14405	53091	МАСЛО "Слобода" 1л подсолнечное рафинированное для жарки и фритюра	уп (15 шт)	3157.00	2025-12-14 15:09:06.17393
14406	53113	СЛИВКИ сухие Фрима 500г	шт	10074.00	2025-12-14 15:09:06.187682
14407	53221	КОФЕ Максим м/у 190гр 1/9шт	шт	7587.00	2025-12-14 15:09:06.224473
14408	53441	ГРИБЫ ШАМПИНЬОНЫ резаные 850мл ж/б  ТМ Сыта-Загора	уп (12 шт)	1946.00	2025-12-14 15:09:06.236931
14409	53455	ВАРЕНЬЕ Абрикосовое ст/б 320гр ТМ Знаток	уп (12 шт)	2318.00	2025-12-14 15:09:06.249111
14410	53491	АССОРТИ огурцы/томаты 720мл ст/б ТМ Скатерть-Самобранка	уп (8 шт)	2033.00	2025-12-14 15:09:06.25938
14411	53758	МОЛОКО Северная долина 3,2% 950мл ультрапастеризованное 1/12шт	уп (12 шт)	1642.00	2025-12-14 15:09:06.303475
14412	53778	МАСЛО 360гр 82,5% Брест-Литовск сливочное ТМ Савушкин продукт	шт	7820.00	2025-12-14 15:09:06.31309
14413	53823	СЫРОК Пингвиненок Понго Картошка вареная сгущенка  глазированный 40гр	уп (20 шт)	727.00	2025-12-14 15:09:06.328416
14414	53840	ТВОРОГ вес 5кг 5% ТМ Заснеженная Русь	уп (5 шт)	2478.00	2025-12-14 15:09:06.35148
14415	53934	БЛИНЫ Цезарь 450гр с телятиной конверт ванночка	шт	5534.00	2025-12-14 15:09:06.403023
14416	54031	МАНТЫ Южные 800гр ТМ 4 сочных порции	шт	4260.00	2025-12-14 15:09:06.412974
14417	54103	ФИЛЕ ГРУДКИ ИНДЕЙКА вес Агро-плюс	уп (10 шт)	5949.00	2025-12-14 15:09:06.425276
14418	54119	ГРУДКА КУР (цыплят-бройлеров) с кожей вес Межениновская ПФ	уп (10 шт)	4428.00	2025-12-14 15:09:06.435914
14419	54124	ОКОРОЧОК КУР Вес 15кг БРАЗИЛИЯ	уп (15 шт)	4640.00	2025-12-14 15:09:06.445322
14420	54125	ОКОРОЧОК КУР вес для жарки Халяль ТМ Благояр	уп (13 шт)	3767.00	2025-12-14 15:09:06.455192
14421	54133	ГОЛЕНЬ КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	шт	3806.00	2025-12-14 15:09:06.470573
14422	54144	ФИЛЕ ГРУДКИ КУР без кожи без кости подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	шт	5716.00	2025-12-14 15:09:06.480955
14423	54176	ГОВЯДИНА ЯЗЫК вес с/м 1/12-17кг Бразилия	уп (1 шт)	1030.00	2025-12-14 15:09:06.491276
14424	54206	СВИНИНА ШЕЯ с/м б/к вес (1кусок~1-2,5кг) ТМ Полянское	уп (15 шт)	9712.00	2025-12-14 15:09:06.504605
14425	54235	ЯЙЦО пищевое С1  ПФ Бердская ТОЛЬКО МЕСТАМИ *	уп (360 шт)	4347.00	2025-12-14 15:09:06.516319
14426	54239	ГОРБУША мороженая потрошенная без головы Вылов 2025*	уп (22 шт)	8804.00	2025-12-14 15:09:06.532032
14427	54245	КЕТА потрошенная без головы с/м 1/22кг Вылов 2025 - *	уп (22 шт)	13662.00	2025-12-14 15:09:06.546233
14428	54258	СЕЛЬДЬ ОЛЮТОРСКАЯ мороженая КРУПНАЯ 2L 400-500гр 1/20кг Океанрыбфлот	уп (20 шт)	5750.00	2025-12-14 15:09:06.557646
14429	54263	СКУМБРИЯ мороженая неразделанная 500-800гр вес Китай	уп (10 шт)	3806.00	2025-12-14 15:09:06.577307
14430	54299	Крабовое мясо 200гр ТМ VICI	шт	5319.00	2025-12-14 15:09:06.598697
14431	54535	ГРИБЫ ГРИБНОЕ ассорти (лесные грибы, шампиньоны) 400гр ТМ 4 Сезона	шт	8050.00	2025-12-14 15:09:06.609785
14432	54540	КАПУСТА брюссельская 400гр ТМ 4 Сезона	шт	5428.00	2025-12-14 15:09:06.618692
14433	54549	ОВОЩИ по-азиатски Вок  (Перец сл. капуста цв. фасоль стр. шамп рез) 400гр ТМ Бондюэль	шт	3188.00	2025-12-14 15:09:06.629518
14434	54556	ПЕРЕЦ сладкий резаный 400гр ТМ 4 Сезона	шт	2737.00	2025-12-14 15:09:06.641008
14435	54659	КАЛЬМАР КОЛЬЦА 500гр с/м Китай	шт	6969.00	2025-12-14 15:09:06.65971
14436	54661	КАЛЬМАР ФИЛЕ 1кг очищенный без кожи без плавника коробка с/м БМРТ Бутовск	шт	19079.00	2025-12-14 15:09:06.669452
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.products (id, "categoryId", name, description, "imageUrl", price, unit, "minQuantity", "maxQuantity", "isActive", "createdAt", "updatedAt", "basePrice", "baseUnit", "inPackage", "saleType") FROM stdin;
22088	2755	Тест	\N	\N	26.00	л	1	\N	f	2025-11-09 05:30:09.946	2025-11-09 07:32:28.015	\N	\N	\N	\N
40371	2755	СМЕСЬ МЕКСИКАНСКАЯ (перец, морковь, фасоль, горошек, кукуруза, сельдерей, лук) вес Россия	\N	\N	2128.00	уп (10 шт)	1	500	f	2025-11-23 22:32:58.394	2025-12-06 02:48:51.249	185.00	кг	10	\N
54689	3303	ДОНАТ в глазури Банан с начинкой банан 67гр в шоу боксе ТМ Bakerton,Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-14 13:03:55.081	2025-12-14 13:03:55.081	74.00	шт	36	только уп
28717	2755	ДОНАТ в глазури Банан с начинкой банан 67гр в шоу боксе ТМ Bakerton,Mirel	\N	\N	2322.00	уп (36 шт)	1	\N	f	2025-11-17 04:47:06.122	2025-11-22 01:30:48.533	\N	\N	\N	\N
28718	2755	КРЕВЕТКА Северная 800гр в/м 70/90 неразделанная Китай	\N	\N	8640.00	уп (12 шт)	1	\N	f	2025-11-17 04:48:28.532	2025-11-22 01:30:48.533	\N	\N	\N	\N
54690	3303	ДОНАТ в глазури Ваниль 58гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-14 13:03:55.097	2025-12-14 13:03:55.097	63.00	шт	36	только уп
54691	3303	ДОНАТ в глазури Карамель 67гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2484.00	уп (32 шт)	1	29	t	2025-12-14 13:03:55.113	2025-12-14 13:03:55.113	78.00	шт	32	только уп
49688	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	уп (50 шт)	1	\N	f	2025-12-06 08:06:47.151	2025-12-06 08:15:47.733	\N	\N	\N	поштучно
54692	3303	ДОНАТ в глазури Карамель 67гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-14 13:03:55.14	2025-12-14 13:03:55.14	74.00	шт	36	только уп
54693	3303	ДОНАТ в глазури Клубника 58гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2153.00	уп (32 шт)	1	200	t	2025-12-14 13:03:55.154	2025-12-14 13:03:55.154	67.00	шт	32	только уп
51797	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	шт	1	300	f	2025-12-06 12:29:38.394	2025-12-06 12:46:48.447	169.00	шт	50	поштучно
51798	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	шт	1	300	f	2025-12-06 12:48:08.625	2025-12-06 12:48:29.599	169.00	шт	50	поштучно
54694	3303	ДОНАТ в глазури Клубника 58гр в шоу боксах ТМ Вakerton, Mirel	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-14 13:03:55.167	2025-12-14 13:03:55.167	63.00	шт	36	только уп
51818	3310	Сало Богородское в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	2433.00	кг	1	144	f	2025-12-07 02:06:54.092	2025-12-07 02:08:18.395	811.00	кг	3	поштучно
54695	3303	ДОНАТ в глазури Малиновый джем 68гр в шоу боксе ТМ Bakerton,Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-14 13:03:55.18	2025-12-14 13:03:55.18	74.00	шт	36	только уп
54696	3303	ДОНАТ в глазури Маршмеллоу 58гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	890.00	уп (12 шт)	1	72	t	2025-12-14 13:03:55.199	2025-12-14 13:03:55.199	74.00	шт	12	только уп
54697	3303	ДОНАТ в глазури черника с крем-чиз 67гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-14 13:03:55.215	2025-12-14 13:03:55.215	74.00	шт	36	только уп
54698	3303	ДОНАТ в глазури Шоколад 56гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2153.00	уп (32 шт)	1	200	t	2025-12-14 13:03:55.23	2025-12-14 13:03:55.23	67.00	шт	32	только уп
54699	3303	ДОНАТ в глазури Шоколад 56гр в шоу боксах ТМ Bakerton, Mirel	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-14 13:03:55.246	2025-12-14 13:03:55.246	63.00	шт	36	только уп
54700	3303	ДОНАТ в глазури Шоколад с начинкой шоколад 67гр в шоу боксе ТМ Bakerton, Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-14 13:03:55.267	2025-12-14 13:03:55.267	74.00	шт	36	только уп
54701	3303	ДОНАТ в глазури Ягодный микс с начинкой вкус ягод 70гр в шоу боксе ТМ Bakerton, Mirel	\N	\N	2670.00	уп (36 шт)	1	200	t	2025-12-14 13:03:55.284	2025-12-14 13:03:55.284	74.00	шт	36	только уп
54702	3303	ДОНАТ в глазури Ягодный микс с начинкой вкусягод 70гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2484.00	уп (32 шт)	1	30	t	2025-12-14 13:03:55.301	2025-12-14 13:03:55.301	78.00	шт	32	только уп
54703	3303	ПЕЧЕНЬЕ "Кукис" овсяный с изюмом и лимоном 70гр ТМ Чизберри	\N	\N	2254.00	шт	1	27	t	2025-12-14 13:03:55.312	2025-12-14 13:03:55.312	81.00	шт	28	поштучно
54704	3303	ПЕЧЕНЬЕ "Кукис" с кусочками темной глазури 70гр ТМ Чизберри	\N	\N	2254.00	шт	1	35	t	2025-12-14 13:03:55.325	2025-12-14 13:03:55.325	81.00	шт	28	поштучно
54705	3303	ПИРОЖНОЕ Бисквитно-сливочное 375гр (1уп-5шт) набор ТМ Татьянин Двор	\N	\N	4830.00	шт	1	174	t	2025-12-14 13:03:55.337	2025-12-14 13:03:55.337	402.00	шт	12	поштучно
54706	3303	ПИРОЖНОЕ Блаженство 375гр (1уп-5шт) набор ТМ Татьянин Двор	\N	\N	4802.00	шт	1	178	t	2025-12-14 13:03:55.352	2025-12-14 13:03:55.352	400.00	шт	12	поштучно
54707	3303	ПИРОЖНОЕ Колечки с творогом 300гр ТМ Mirel	\N	\N	2077.00	шт	1	200	t	2025-12-14 13:03:55.368	2025-12-14 13:03:55.368	346.00	шт	6	поштучно
54708	3303	ПИРОЖНОЕ Корзиночки (цыпленок,с белк кремом, грибочки) 300гр (1уп-6шт) набор ТМ Татьянин Двор	\N	\N	2532.00	шт	1	94	t	2025-12-14 13:03:55.382	2025-12-14 13:03:55.382	422.00	шт	6	поштучно
54709	3303	ПИРОЖНОЕ Корзиночки (шоколадно-вишневая) 300гр (1уп-6шт) набор 1/6шт ТМ Татьянин Двор	\N	\N	2318.00	шт	1	164	t	2025-12-14 13:03:55.394	2025-12-14 13:03:55.394	386.00	шт	6	поштучно
54710	3303	ПИРОЖНОЕ Корзиночки №2 (пломбир/кофейное мороженое) 300гр (1уп-6шт) набор ТМ Татьянин Двор	\N	\N	2284.00	шт	1	200	t	2025-12-14 13:03:55.406	2025-12-14 13:03:55.406	381.00	шт	6	поштучно
54711	3303	ПИРОЖНОЕ Корзиночки №4 (пломбир/клубн морож) 300гр (1уп-6шт) набор 1/6шт ТМ Татьянин Двор	\N	\N	2318.00	шт	1	119	t	2025-12-14 13:03:55.416	2025-12-14 13:03:55.416	386.00	шт	6	поштучно
54712	3303	ПИРОЖНОЕ Корзиночки ягодки (еживика/клубника/малина) 300гр (1уп-6шт) набор ТМ Татьянин Двор	\N	\N	2532.00	шт	1	84	t	2025-12-14 13:03:55.431	2025-12-14 13:03:55.431	422.00	шт	6	поштучно
54713	3303	ПИРОЖНОЕ Маффин с шоколадом 80гр ТМ Русская Нива	\N	\N	1587.00	шт	1	19	t	2025-12-14 13:03:55.442	2025-12-14 13:03:55.442	79.00	шт	20	поштучно
54714	3303	ПИРОЖНОЕ Муравейник 340гр ТМ Mirel	\N	\N	6428.00	шт	1	200	t	2025-12-14 13:03:55.455	2025-12-14 13:03:55.455	321.00	шт	20	поштучно
54715	3303	ПИРОЖНОЕ Парфе 375гр (1уп-5шт) набор ТМ Татьянин Двор	\N	\N	4954.00	шт	1	96	t	2025-12-14 13:03:55.471	2025-12-14 13:03:55.471	413.00	шт	12	поштучно
54716	3303	ПИРОЖНОЕ Прага 400гр (1уп-5шт) набор ТМ Татьянин Двор	\N	\N	4954.00	шт	1	200	t	2025-12-14 13:03:55.484	2025-12-14 13:03:55.484	413.00	шт	12	поштучно
54717	3303	ПИРОЖНОЕ Профитроли с кремом Пломбирный 180гр ТМ Mirel	\N	\N	4026.00	шт	1	200	t	2025-12-14 13:03:55.495	2025-12-14 13:03:55.495	224.00	шт	18	поштучно
51802	3314	СЫР вес Сметанковый 45% (1шт~5 кг) брус ТМ Радость вкуса*	\N	\N	12675.00	уп (15 шт)	1	\N	f	2025-12-06 13:05:52.876	2025-12-06 13:06:19.625	\N	\N	\N	поштучно
54718	3303	ПИРОЖНОЕ Тарты по-французски с заварным кремом 280гр ТМ Mirel	\N	\N	2797.00	шт	1	200	t	2025-12-14 13:03:55.508	2025-12-14 13:03:55.508	350.00	шт	8	поштучно
54719	3303	ПИРОЖНОЕ Тирамису 280гр ТМ Mirel	\N	\N	7302.00	шт	1	200	t	2025-12-14 13:03:55.525	2025-12-14 13:03:55.525	292.00	шт	25	поштучно
54720	3303	ПИРОЖНОЕ Эклеры клубничные со сливочно-заварным кремом 235гр ТМ Mirel	\N	\N	2447.00	шт	1	200	t	2025-12-14 13:03:55.538	2025-12-14 13:03:55.538	306.00	шт	8	поштучно
54721	3303	ПИРОЖНОЕ Эклеры с белковым кремом 160гр (1уп-5шт) набор ТМ Mirel	\N	\N	2162.00	шт	1	200	t	2025-12-14 13:03:55.554	2025-12-14 13:03:55.554	216.00	шт	10	поштучно
51807	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	уп (50 шт)	1	\N	f	2025-12-06 13:08:07.435	2025-12-07 01:04:10.972	\N	\N	\N	поштучно
54722	3303	ПИРОЖНОЕ Эклеры с заварным кремом 250гр ТМ Mirel	\N	\N	2950.00	шт	1	200	t	2025-12-14 13:03:55.566	2025-12-14 13:03:55.566	295.00	шт	10	поштучно
54723	3303	ПИРОЖНОЕ Эклеры с классическим заварным кремом  250гр ТМ Mirel	\N	\N	2760.00	шт	1	200	t	2025-12-14 13:03:55.581	2025-12-14 13:03:55.581	276.00	шт	10	поштучно
54724	3303	ПИРОЖНОЕ Эклеры с крем брюле 160гр ТМ Mirel	\N	\N	2628.00	шт	1	200	t	2025-12-14 13:03:55.595	2025-12-14 13:03:55.595	263.00	шт	10	поштучно
54725	3303	ПИРОЖНОЕ Эклеры с шоколад заварным кремом и соленой карамелью 235гр ТМ Mirel	\N	\N	2433.00	шт	1	200	t	2025-12-14 13:03:55.607	2025-12-14 13:03:55.607	304.00	шт	8	поштучно
54726	3303	ПИРОЖНОЕ Эклеры фисташковый крем и малина 235гр (1уп-5шт) набор ТМ Mirel	\N	\N	2742.00	шт	1	110	t	2025-12-14 13:03:55.617	2025-12-14 13:03:55.617	343.00	шт	8	поштучно
54727	3303	РУЛЕТ Сдобный Абрикос 140гр	\N	\N	690.00	шт	1	84	t	2025-12-14 13:03:55.631	2025-12-14 13:03:55.631	115.00	шт	6	поштучно
54728	3303	РУЛЕТ Сдобный Вишня 140гр	\N	\N	690.00	шт	1	174	t	2025-12-14 13:03:55.643	2025-12-14 13:03:55.643	115.00	шт	6	поштучно
54729	3303	РУЛЕТ Сдобный Лимон 140гр	\N	\N	690.00	шт	1	200	t	2025-12-14 13:03:55.654	2025-12-14 13:03:55.654	115.00	шт	6	поштучно
54730	3303	ТОРТ Ассоль 850гр ТМ Татьянин Двор	\N	\N	4913.00	шт	1	125	t	2025-12-14 13:03:55.664	2025-12-14 13:03:55.664	819.00	шт	6	поштучно
54731	3303	ТОРТ Бельгийский шоколад 750гр ТМ Mirel	\N	\N	6186.00	шт	1	200	t	2025-12-14 13:03:55.684	2025-12-14 13:03:55.684	1031.00	шт	6	поштучно
54732	3303	ТОРТ Венский лес 850гр ТМ Татьянин Двор	\N	\N	5078.00	шт	1	200	t	2025-12-14 13:03:55.709	2025-12-14 13:03:55.709	846.00	шт	6	поштучно
54733	3303	ТОРТ Вишневый 640гр ТМ Мой	\N	\N	3398.00	шт	1	200	t	2025-12-14 13:03:55.756	2025-12-14 13:03:55.756	566.00	шт	6	поштучно
54734	3303	ТОРТ Джулия 800гр ТМ Татьянин Двор	\N	\N	4789.00	шт	1	100	t	2025-12-14 13:03:55.797	2025-12-14 13:03:55.797	798.00	шт	6	поштучно
54735	3303	ТОРТ Желание 625гр ТМ Фантэль нарезной	\N	\N	4043.00	шт	1	124	t	2025-12-14 13:03:55.81	2025-12-14 13:03:55.81	674.00	шт	6	поштучно
54736	3303	ТОРТ Йогурт/кокос/абрикос 600гр ТМ Татьянин Двор	\N	\N	5621.00	шт	1	33	t	2025-12-14 13:03:55.874	2025-12-14 13:03:55.874	703.00	шт	8	поштучно
54737	3303	ТОРТ Йогуртовый с клубникой  650гр ТМ Фантэль	\N	\N	4023.00	шт	1	17	t	2025-12-14 13:03:55.889	2025-12-14 13:03:55.889	670.00	шт	6	поштучно
54738	3303	ТОРТ Казанова шоколадный 800гр ТМ Татьянин Двор	\N	\N	5210.00	шт	1	49	t	2025-12-14 13:03:55.902	2025-12-14 13:03:55.902	868.00	шт	6	поштучно
54739	3303	ТОРТ Карамельный на сгущенке 700гр ТМ Mirel	\N	\N	3826.00	шт	1	200	t	2025-12-14 13:03:55.917	2025-12-14 13:03:55.917	638.00	шт	6	поштучно
54740	3303	ТОРТ Киви-Клубника 650гр ТМ Мой	\N	\N	3398.00	шт	1	200	t	2025-12-14 13:03:55.932	2025-12-14 13:03:55.932	566.00	шт	6	поштучно
54741	3303	ТОРТ Киевский 800гр ТМ Фантэль	\N	\N	6162.00	шт	1	30	t	2025-12-14 13:03:55.946	2025-12-14 13:03:55.946	1027.00	шт	6	поштучно
54742	3303	ТОРТ Клубничные облака 500гр ТМ Татьянин Двор	\N	\N	3864.00	шт	1	194	t	2025-12-14 13:03:55.97	2025-12-14 13:03:55.97	483.00	шт	8	поштучно
54743	3303	ТОРТ Клубничный Милкшейк 650гр ТМ Mirel	\N	\N	4116.00	шт	1	200	t	2025-12-14 13:03:55.983	2025-12-14 13:03:55.983	686.00	шт	6	поштучно
54744	3303	ТОРТ Крем-Брюле 650гр ТМ Mirel	\N	\N	3678.00	шт	1	200	t	2025-12-14 13:03:55.996	2025-12-14 13:03:55.996	613.00	шт	6	поштучно
54745	3303	ТОРТ Латте Макиато 650гр ТМ Mirel	\N	\N	4116.00	шт	1	200	t	2025-12-14 13:03:56.01	2025-12-14 13:03:56.01	686.00	шт	6	поштучно
54746	3303	ТОРТ Медово/сметанный 850гр ТМ Татьянин Двор	\N	\N	5244.00	шт	1	50	t	2025-12-14 13:03:56.023	2025-12-14 13:03:56.023	874.00	шт	6	поштучно
54747	3303	ТОРТ Медовый с вареной сгущенкой 250гр ТМ Mirel	\N	\N	12492.00	шт	1	90	t	2025-12-14 13:03:56.035	2025-12-14 13:03:56.035	500.00	шт	25	поштучно
54748	3303	ТОРТ Министерский 1кг ТМ Фантэль	\N	\N	5444.00	шт	1	15	t	2025-12-14 13:03:56.049	2025-12-14 13:03:56.049	907.00	шт	6	поштучно
54749	3303	ТОРТ Наполеон Классический 550гр ТМ Mirel	\N	\N	3705.00	шт	1	200	t	2025-12-14 13:03:56.064	2025-12-14 13:03:56.064	618.00	шт	6	поштучно
54750	3303	ТОРТ Орфей 650гр ТМ Mirel	\N	\N	5296.00	шт	1	94	t	2025-12-14 13:03:56.078	2025-12-14 13:03:56.078	883.00	шт	6	поштучно
54751	3303	ТОРТ Персик/Малина 700гр ТМ Mirel	\N	\N	4112.00	шт	1	70	t	2025-12-14 13:03:56.091	2025-12-14 13:03:56.091	685.00	шт	6	поштучно
54752	3303	ТОРТ Персик/Маракуйя  650гр ТМ Мой	\N	\N	3398.00	шт	1	200	t	2025-12-14 13:03:56.101	2025-12-14 13:03:56.101	566.00	шт	6	поштучно
54753	3303	ТОРТ Пикник 550гр ТМ Татьянин Двор	\N	\N	5879.00	шт	1	77	t	2025-12-14 13:03:56.114	2025-12-14 13:03:56.114	735.00	шт	8	поштучно
54754	3303	ТОРТ Пломбирный 750гр ТМ Mirel	\N	\N	4216.00	шт	1	200	t	2025-12-14 13:03:56.129	2025-12-14 13:03:56.129	703.00	шт	6	поштучно
54755	3303	ТОРТ Прага 660гр ТМ Mirel	\N	\N	4281.00	шт	1	170	t	2025-12-14 13:03:56.141	2025-12-14 13:03:56.141	714.00	шт	6	поштучно
54756	3303	ТОРТ Прага 850гр ТМ Татьянин Двор	\N	\N	5203.00	шт	1	10	t	2025-12-14 13:03:56.152	2025-12-14 13:03:56.152	867.00	шт	6	поштучно
54757	3303	ТОРТ Пражский 800гр ТМ Татьянин Двор	\N	\N	4844.00	шт	1	32	t	2025-12-14 13:03:56.166	2025-12-14 13:03:56.166	807.00	шт	6	поштучно
54758	3303	ТОРТ Пралине 550гр ТМ Mirel	\N	\N	5147.00	шт	1	200	t	2025-12-14 13:03:56.178	2025-12-14 13:03:56.178	858.00	шт	6	поштучно
54759	3303	ТОРТ Пчелка 750гр ТМ Фантэль АКЦИЯ - 25% старая цена 599р	\N	\N	4133.00	шт	1	38	t	2025-12-14 13:03:56.19	2025-12-14 13:03:56.19	689.00	шт	6	поштучно
54760	3303	ТОРТ Русская ягода 680гр ТМ Mirel	\N	\N	4116.00	шт	1	184	t	2025-12-14 13:03:56.204	2025-12-14 13:03:56.204	686.00	шт	6	поштучно
54761	3303	ТОРТ Сказка Любимая 440гр ТМ Mirel	\N	\N	4952.00	шт	1	200	t	2025-12-14 13:03:56.215	2025-12-14 13:03:56.215	550.00	шт	9	поштучно
54762	3303	ТОРТ Сливочная карамель 650гр ТМ Mirel	\N	\N	3398.00	шт	1	200	t	2025-12-14 13:03:56.229	2025-12-14 13:03:56.229	566.00	шт	6	поштучно
54763	3303	ТОРТ Сметанник малиновый 650гр ТМ Mirel	\N	\N	4233.00	шт	1	200	t	2025-12-14 13:03:56.242	2025-12-14 13:03:56.242	706.00	шт	6	поштучно
54764	3303	ТОРТ Сметанный 650гр ТМ Мой	\N	\N	3398.00	шт	1	200	t	2025-12-14 13:03:56.253	2025-12-14 13:03:56.253	566.00	шт	6	поштучно
54765	3303	ТОРТ Сметанофф классический 650гр ТМ Фантэль	\N	\N	4023.00	шт	1	33	t	2025-12-14 13:03:56.265	2025-12-14 13:03:56.265	670.00	шт	6	поштучно
54766	3303	ТОРТ Сметанчо 800гр ТМ Mirel	\N	\N	5472.00	шт	1	200	t	2025-12-14 13:03:56.275	2025-12-14 13:03:56.275	912.00	шт	6	поштучно
54767	3303	ТОРТ Сметанчо 850гр ТМ Татьянин Двор	\N	\N	5016.00	шт	1	57	t	2025-12-14 13:03:56.293	2025-12-14 13:03:56.293	836.00	шт	6	поштучно
54768	3303	ТОРТ Старая Прага 600гр ТМ Татьянин Двор	\N	\N	5060.00	шт	1	136	t	2025-12-14 13:03:56.304	2025-12-14 13:03:56.304	633.00	шт	8	поштучно
54769	3303	ТОРТ Творожно/йогуртовый 800гр ТМ Татьянин Двор	\N	\N	5016.00	шт	1	8	t	2025-12-14 13:03:56.316	2025-12-14 13:03:56.316	836.00	шт	6	поштучно
54770	3303	ТОРТ Творожный 800гр ТМ Татьянин Двор	\N	\N	5617.00	шт	1	56	t	2025-12-14 13:03:56.329	2025-12-14 13:03:56.329	936.00	шт	6	поштучно
54771	3303	ТОРТ Тирамису 750гр ТМ Mirel	\N	\N	4309.00	шт	1	200	t	2025-12-14 13:03:56.341	2025-12-14 13:03:56.341	718.00	шт	6	поштучно
54772	3303	ТОРТ Тирамису 800гр ТМ Татьянин Двор	\N	\N	4899.00	шт	1	54	t	2025-12-14 13:03:56.355	2025-12-14 13:03:56.355	816.00	шт	6	поштучно
54773	3303	ТОРТ Три шоколада 750гр ТМ Mirel	\N	\N	6338.00	шт	1	13	t	2025-12-14 13:03:56.366	2025-12-14 13:03:56.366	1056.00	шт	6	поштучно
54774	3303	ТОРТ Черничное молоко 750гр ТМ Mirel	\N	\N	4368.00	шт	1	200	t	2025-12-14 13:03:56.377	2025-12-14 13:03:56.377	728.00	шт	6	поштучно
54775	3303	ТОРТ Черный лес 720гр ТМ Mirel	\N	\N	5517.00	шт	1	185	t	2025-12-14 13:03:56.397	2025-12-14 13:03:56.397	919.00	шт	6	поштучно
54776	3303	ТОРТ Чизкейк Шоколадный 700гр ТМ Чизберри	\N	\N	3827.00	шт	1	6	t	2025-12-14 13:03:56.409	2025-12-14 13:03:56.409	957.00	шт	4	поштучно
54777	3303	ТОРТ Шоколадный брауни 600гр ТМ ПБК	\N	\N	4057.00	шт	1	33	t	2025-12-14 13:03:56.42	2025-12-14 13:03:56.42	676.00	шт	6	поштучно
54778	3303	ТОРТ Шоколадный пломбир 700гр ТМ Mirel	\N	\N	4368.00	шт	1	148	t	2025-12-14 13:03:56.433	2025-12-14 13:03:56.433	728.00	шт	6	поштучно
54779	3303	ТОРТ Шоколадный с апельсином 700гр ТМ Mirel	\N	\N	6058.00	шт	1	200	t	2025-12-14 13:03:56.444	2025-12-14 13:03:56.444	1010.00	шт	6	поштучно
54780	3303	ТОРТ Шоколадный тоффи 580гр ТМ Mirel	\N	\N	4119.00	шт	1	12	t	2025-12-14 13:03:56.456	2025-12-14 13:03:56.456	687.00	шт	6	поштучно
54781	3303	ТОРТ Шоколетто 850гр ТМ Татьянин Двор	\N	\N	5003.00	шт	1	55	t	2025-12-14 13:03:56.469	2025-12-14 13:03:56.469	834.00	шт	6	поштучно
54782	3303	ТОРТ Эстерхази 650гр ТМ Mirel	\N	\N	7631.00	шт	1	200	t	2025-12-14 13:03:56.486	2025-12-14 13:03:56.486	1272.00	шт	6	поштучно
54783	3392	ВАФ СТАКАНЧИК ЮККИ Пломбир на сливках шоколадный 70гр 1/24шт ТМ Санта Бремор	\N	\N	2180.00	уп (24 шт)	1	96	t	2025-12-14 13:03:56.498	2025-12-14 13:03:56.498	91.00	шт	24	только уп
54784	3392	КАРТОННЫЙ СТАКАНЧИК БРЕСТ-ЛИТОВСК ваниль 220гр 1/12шт ТМ Санта Бремор	\N	\N	3381.00	уп (12 шт)	1	100	t	2025-12-14 13:03:56.52	2025-12-14 13:03:56.52	282.00	шт	12	только уп
54785	3392	РОЖОК Soletto Лаванда Черника 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	24	t	2025-12-14 13:03:56.584	2025-12-14 13:03:56.584	90.00	шт	24	только уп
54786	3392	ЭСКИМО Soletto Черника 75гр 1/24шт ТМ Санта Бремор	\N	\N	3340.00	уп (24 шт)	1	100	t	2025-12-14 13:03:56.608	2025-12-14 13:03:56.608	139.00	шт	24	только уп
54787	3392	ЭСКИМО БРЕСТ-ЛИТОВСК ваниль в глазури 70гр ТМ Санта Бремор	\N	\N	3496.00	уп (32 шт)	1	32	t	2025-12-14 13:03:56.629	2025-12-14 13:03:56.629	109.00	шт	32	только уп
54788	3392	ЭСКИМО ДУБАЙ фисташково кунжутная глазурь с кусочками теста Катаифи 60гр ТМ Санта Бремор	\N	\N	3105.00	уп (36 шт)	1	72	t	2025-12-14 13:03:56.651	2025-12-14 13:03:56.651	86.00	шт	36	только уп
54789	3392	ЭСКИМО ЮККИ КОРОВКА слив крем-брюле в карам глазури с ваф сушкой 65гр 1/24шт ТМ Санта Бремор	\N	\N	2484.00	уп (24 шт)	1	100	t	2025-12-14 13:03:56.664	2025-12-14 13:03:56.664	103.00	шт	24	только уп
54790	3392	ВАФ СТАКАНЧИК Пломбир ваниль/варёная сгущенка 15% 70гр ТМ Село Зелёное	\N	\N	2125.00	уп (24 шт)	1	200	t	2025-12-14 13:03:56.678	2025-12-14 13:03:56.678	89.00	шт	24	только уп
55908	3327	ТОМАТНАЯ ПАСТА 270гр ст/б ТМ Пиканта	\N	\N	1014.00	уп (6 шт)	1	200	t	2025-12-14 13:04:17.047	2025-12-14 13:04:17.047	169.00	шт	6	только уп
52402	3303	ТОРТ Прага 650гр ТМ Фантэль	\N	\N	4023.00	шт	1	8	f	2025-12-07 13:19:11.815	2025-12-14 08:13:19.347	670.00	шт	6	поштучно
52438	3392	ЭСКИМО БРЕСТ-ЛИТОВСК ваниль в глазури 70гр ТМ Санта Бремор	\N	\N	3496.00	уп (32 шт)	1	100	f	2025-12-07 13:19:12.445	2025-12-14 12:09:06.688	109.00	шт	32	только уп
51809	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	шт	1	\N	f	2025-12-07 01:05:38.491	2025-12-07 01:05:52.784	\N	\N	\N	поштучно
51810	3314	СЫР Колосок 100гр СПК	\N	\N	8450.00	шт	1	300	f	2025-12-07 01:06:12.601	2025-12-07 01:06:55.155	169.00	шт	50	поштучно
54791	3392	ВАФ СТАКАНЧИК Пломбир ванильный 15% на сливках  промо-пак (2+1 в подарок по цене 2х)  1/10шт  ТМ Село Зелёное	\N	\N	2024.00	уп (10 шт)	1	200	t	2025-12-14 13:03:56.69	2025-12-14 13:03:56.69	202.00	шт	10	только уп
54792	3392	ВАФ СТАКАНЧИК Пломбир ванильный 15% на сливках 90гр ТМ Село Зелёное	\N	\N	2429.00	уп (24 шт)	1	200	t	2025-12-14 13:03:56.703	2025-12-14 13:03:56.703	101.00	шт	24	только уп
51814	3310	Сало Домашнее в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	3288.00	кг	1	221	f	2025-12-07 01:20:59.31	2025-12-07 01:21:53.747	822.00	кг	4	поштучно
51815	3310	Сало Домашнее в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	250.00	шт	1	221	f	2025-12-07 01:23:20.458	2025-12-07 01:29:18.101	250.00	шт	4	поштучно
51816	3310	Сало Домашнее в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	250.00	шт	1	221	f	2025-12-07 01:29:40.39	2025-12-07 01:39:50.008	250.00	шт	4	поштучно
51813	3310	САЛО свинина фас вар Сало Народное с/м в/уп (1шт ~ 0,3кг) ТМ БАРС	\N	\N	8976.00	уп (11 шт)	1	100	f	2025-12-07 01:18:10.37	2025-12-07 02:06:06.471	816.00	кг	11	только уп
54793	3392	ВАФ СТАКАНЧИК Пломбир земляника 15% 70гр ТМ Село Зелёное	\N	\N	1794.00	уп (24 шт)	1	200	t	2025-12-14 13:03:56.715	2025-12-14 13:03:56.715	75.00	шт	24	только уп
54794	3392	ВАФ СТАКАНЧИК Пломбир крем-брюле 15% 90гр ТМ Село Зелёное	\N	\N	2429.00	уп (24 шт)	1	200	t	2025-12-14 13:03:56.731	2025-12-14 13:03:56.731	101.00	шт	24	только уп
54795	3392	ВАФ СТАКАНЧИК Пломбир малина 15% 70гр ТМ Село Зелёное	\N	\N	2208.00	уп (24 шт)	1	200	t	2025-12-14 13:03:56.746	2025-12-14 13:03:56.746	92.00	шт	24	только уп
54796	3392	ВАФ СТАКАНЧИК Пломбир фисташковый 15% 70гр ТМ Село Зелёное	\N	\N	2870.00	уп (24 шт)	1	200	t	2025-12-14 13:03:56.768	2025-12-14 13:03:56.768	120.00	шт	24	только уп
54797	3392	ВАФ СТАКАНЧИК Пломбир черника 15% 70гр ТМ Село Зелёное	\N	\N	2180.00	уп (24 шт)	1	200	t	2025-12-14 13:03:56.782	2025-12-14 13:03:56.782	91.00	шт	24	только уп
54798	3392	ВАФ СТАКАНЧИК Пломбир шоколадный 15% на сливках 90гр ТМ Село Зелёное	\N	\N	2429.00	уп (24 шт)	1	200	t	2025-12-14 13:03:56.793	2025-12-14 13:03:56.793	101.00	шт	24	только уп
54799	3392	РОЖОК Пломбир ванильный 15% на сливках 110гр ТМ Село Зелёное	\N	\N	2953.00	уп (24 шт)	1	200	t	2025-12-14 13:03:56.805	2025-12-14 13:03:56.805	123.00	шт	24	только уп
54800	3392	ЭСКИМО Пломбир Ваниль-Вишня-Шоколад 15% на сливках 80гр ТМ Село Зелёное	\N	\N	4515.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.818	2025-12-14 13:03:56.818	174.00	шт	26	только уп
54801	3392	ЭСКИМО Пломбир ванильный без глазури 15% на сливках 70гр ТМ Село Зелёное	\N	\N	2452.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.84	2025-12-14 13:03:56.84	94.00	шт	26	только уп
54802	3392	ЭСКИМО Пломбир ванильный в молочном шоколаде 15% на сливках 80гр ТМ Село Зелёное	\N	\N	4575.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.865	2025-12-14 13:03:56.865	176.00	шт	26	только уп
54803	3392	ЭСКИМО Пломбир Ванильный в молочном шоколаде с миндалем 15% 80гр ТМ Село Зелёное	\N	\N	4814.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.879	2025-12-14 13:03:56.879	185.00	шт	26	только уп
54804	3392	ЭСКИМО Пломбир грецкий орех/кленовый сироп 15% 80гр ТМ Село Зелёное	\N	\N	3169.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.89	2025-12-14 13:03:56.89	122.00	шт	26	только уп
54805	3392	ЭСКИМО Пломбир Клубника во фруктовой глазури 15% 70гр ТМ Село Зелёное	\N	\N	2751.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.906	2025-12-14 13:03:56.906	106.00	шт	26	только уп
54806	3392	ЭСКИМО Пломбир Клюква во фруктовой глазури 15% 70гр ТМ Село Зелёное	\N	\N	2751.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.918	2025-12-14 13:03:56.918	106.00	шт	26	только уп
54807	3392	ЭСКИМО Пломбир крем-брюле в карамельной глазури 15% 80гр ТМ Село Зелёное	\N	\N	3169.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.941	2025-12-14 13:03:56.941	122.00	шт	26	только уп
54808	3392	ЭСКИМО Пломбир малина в молочном шоколаде 15% 80гр ТМ Село Зелёное	\N	\N	4605.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.955	2025-12-14 13:03:56.955	177.00	шт	26	только уп
54809	3392	ЭСКИМО Пломбир Персик во фруктовой глазури 15% 70гр ТМ Село Зелёное	\N	\N	2781.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.967	2025-12-14 13:03:56.967	107.00	шт	26	только уп
54810	3392	ЭСКИМО Пломбир шоколад шоколадный топпинг фундук 15% 80гр ТМ Село Зелёное	\N	\N	3169.00	уп (26 шт)	1	200	t	2025-12-14 13:03:56.981	2025-12-14 13:03:56.981	122.00	шт	26	только уп
54811	3392	ФРУКТОВЫЙ ЛЁД Вишня 50гр ТМ Село Зеленое	\N	\N	2981.00	уп (36 шт)	1	144	t	2025-12-14 13:03:56.994	2025-12-14 13:03:56.994	83.00	шт	36	только уп
54812	3392	ФРУКТОВЫЙ ЛЁД Клубника 50гр ТМ Село Зеленое	\N	\N	2981.00	уп (36 шт)	1	200	t	2025-12-14 13:03:57.016	2025-12-14 13:03:57.016	83.00	шт	36	только уп
54813	3392	ФРУКТОВЫЙ ЛЁД Малина 50гр ТМ Село Зеленое	\N	\N	2981.00	уп (36 шт)	1	108	t	2025-12-14 13:03:57.039	2025-12-14 13:03:57.039	83.00	шт	36	только уп
54814	3392	БРИКЕТ Пломбир ванильный 15% на сливках 200гр ТМ Село Зелёное	\N	\N	3478.00	уп (16 шт)	1	200	t	2025-12-14 13:03:57.051	2025-12-14 13:03:57.051	217.00	шт	16	только уп
54815	3392	БРИКЕТ Пломбир крем-брюле 15% 200гр ТМ Село Зелёное	\N	\N	3478.00	уп (16 шт)	1	200	t	2025-12-14 13:03:57.064	2025-12-14 13:03:57.064	217.00	шт	16	только уп
54816	3392	БРИКЕТ Пломбир шоколадный 15% на сливках 200гр ТМ Село Зелёное	\N	\N	3478.00	уп (16 шт)	1	200	t	2025-12-14 13:03:57.081	2025-12-14 13:03:57.081	217.00	шт	16	только уп
54817	3392	ПАКЕТ Пломбир ванильный 15% 850гр ТМ Село Зелёное	\N	\N	2346.00	шт	1	200	t	2025-12-14 13:03:57.093	2025-12-14 13:03:57.093	587.00	шт	4	поштучно
55909	3327	ТОМАТНАЯ ПАСТА 280гр дойпак ТМ Пиканта	\N	\N	1426.00	уп (10 шт)	1	200	t	2025-12-14 13:04:17.08	2025-12-14 13:04:17.08	143.00	шт	10	только уп
54818	3392	ПАКЕТ Пломбир ванильный с шоколадной крошкой 15% 400гр ТМ Село Зелёное	\N	\N	2415.00	шт	1	200	t	2025-12-14 13:03:57.105	2025-12-14 13:03:57.105	402.00	шт	6	поштучно
54819	3392	ПЛ/КОНТЕЙНЕР Мороженое ванильное 10% 2кг ТМ УКХ	\N	\N	2318.00	шт	1	200	t	2025-12-14 13:03:57.119	2025-12-14 13:03:57.119	1159.00	шт	2	поштучно
54820	3392	ПЛ/КОНТЕЙНЕР Пломбир ваниль/клубника/карамельный сироп и миндаль 15% 450гр ТМ Село Зелёное	\N	\N	3133.00	шт	1	200	t	2025-12-14 13:03:57.133	2025-12-14 13:03:57.133	522.00	шт	6	поштучно
54821	3392	ПЛ/КОНТЕЙНЕР Пломбир ванильный 15% 280гр ТМ Село Зелёное	\N	\N	2125.00	шт	1	200	t	2025-12-14 13:03:57.146	2025-12-14 13:03:57.146	354.00	шт	6	поштучно
54822	3392	ПЛ/КОНТЕЙНЕР Пломбир Ванильный брусника можжевел 200гр ТМ Село Зелёное	\N	\N	1884.00	шт	1	130	t	2025-12-14 13:03:57.158	2025-12-14 13:03:57.158	314.00	шт	6	поштучно
54823	3392	ПЛ/КОНТЕЙНЕР Пломбир Ванильный Черника-малина 200гр ТМ Село Зелёное	\N	\N	1884.00	шт	1	59	t	2025-12-14 13:03:57.169	2025-12-14 13:03:57.169	314.00	шт	6	поштучно
54824	3392	ПЛ/КОНТЕЙНЕР Пломбир грецкий орех/кленовый сироп 15% 450гр ТМ Село Зелёное	\N	\N	3298.00	шт	1	200	t	2025-12-14 13:03:57.181	2025-12-14 13:03:57.181	550.00	шт	6	поштучно
54825	3392	ПЛ/КОНТЕЙНЕР Пломбир малина/шоколадный топпинг 15% 450гр ТМ Село Зелёное	\N	\N	3133.00	шт	1	200	t	2025-12-14 13:03:57.195	2025-12-14 13:03:57.195	522.00	шт	6	поштучно
54826	3392	ПЛ/КОНТЕЙНЕР Пломбир фисташковый 15% 200гр ТМ Село Зелёное	\N	\N	2298.00	шт	1	151	t	2025-12-14 13:03:57.209	2025-12-14 13:03:57.209	383.00	шт	6	поштучно
54827	3392	ПЛ/КОНТЕЙНЕР Пломбир шоколадный 12% 2кг ТМ УКХ	\N	\N	2760.00	шт	1	84	t	2025-12-14 13:03:57.227	2025-12-14 13:03:57.227	1380.00	шт	2	поштучно
54828	3392	ПЛ/КОНТЕЙНЕР Пломбир шоколадный 15% 280гр ТМ Село Зелёное	\N	\N	2125.00	шт	1	200	t	2025-12-14 13:03:57.24	2025-12-14 13:03:57.24	354.00	шт	6	поштучно
54829	3392	ПЛ/КОНТЕЙНЕР Сорбет малина 280гр ТМ Село Зелёное	\N	\N	2049.00	шт	1	200	t	2025-12-14 13:03:57.253	2025-12-14 13:03:57.253	342.00	шт	6	поштучно
54830	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Апельсин с облепиховым жмыхом  50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-14 13:03:57.268	2025-12-14 13:03:57.268	140.00	шт	30	только уп
54831	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Барбарис с соком вишни и кусочками яблок 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-14 13:03:57.322	2025-12-14 13:03:57.322	140.00	шт	30	только уп
54832	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Малина брусника чабрец 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-14 13:03:57.334	2025-12-14 13:03:57.334	140.00	шт	30	только уп
54833	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Манго маракуйя и кусочками апельсина 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	129	t	2025-12-14 13:03:57.395	2025-12-14 13:03:57.395	140.00	шт	30	только уп
54834	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Облепиха с корицей и яблоком 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-14 13:03:57.42	2025-12-14 13:03:57.42	140.00	шт	30	только уп
54835	3392	ЧАЙ ФРУКТОВО-ЯГОДНЫЙ НА ПАЛОЧКЕ заморож Облепиха с розмарином 50гр ТМ Чистая линия	\N	\N	4209.00	уп (30 шт)	1	190	t	2025-12-14 13:03:57.435	2025-12-14 13:03:57.435	140.00	шт	30	только уп
54836	3392	ВАФ СТАКАНЧИК Десерт на кокосовой основе ванильный без сахарозы (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2731.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.449	2025-12-14 13:03:57.449	109.00	шт	25	только уп
54837	3392	ВАФ СТАКАНЧИК Десерт на кокосовой основе с пюре манго и семенами чиа (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2990.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.462	2025-12-14 13:03:57.462	120.00	шт	25	только уп
54838	3392	ВАФ СТАКАНЧИК Пломбир ванильный (пергамент) 12% 80гр ТМ Чистая Линия	\N	\N	2645.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.477	2025-12-14 13:03:57.477	106.00	шт	25	только уп
54839	3392	ВАФ СТАКАНЧИК Пломбир ванильный (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	25	t	2025-12-14 13:03:57.49	2025-12-14 13:03:57.49	113.00	шт	25	только уп
54840	3392	ВАФ СТАКАНЧИК Пломбир ванильный без лактозы (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	3364.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.503	2025-12-14 13:03:57.503	135.00	шт	25	только уп
54841	3392	ВАФ СТАКАНЧИК Пломбир ванильный без сахарозы (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	3019.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.515	2025-12-14 13:03:57.515	121.00	шт	25	только уп
54842	3392	ВАФ СТАКАНЧИК Пломбир ванильный Вкусовые сосочки 12% 90гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.528	2025-12-14 13:03:57.528	113.00	шт	25	только уп
54843	3392	ВАФ СТАКАНЧИК Пломбир ванильный протеиновый без сахарозы (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	3306.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.565	2025-12-14 13:03:57.565	132.00	шт	25	только уп
54844	3392	ВАФ СТАКАНЧИК Пломбир крем-брюле (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.58	2025-12-14 13:03:57.58	113.00	шт	25	только уп
54845	3392	ВАФ СТАКАНЧИК Пломбир радуга 12% 90гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.596	2025-12-14 13:03:57.596	113.00	шт	25	только уп
54846	3392	ВАФ СТАКАНЧИК Пломбир шоколадный (пергамент) 12% 80гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.607	2025-12-14 13:03:57.607	113.00	шт	25	только уп
54847	3392	ВАФ СТАКАНЧИК Пломбир шоколадный с шоколадной крошкой (флоу-пак) 12% 80гр ТМ Чистая Линия	\N	\N	2818.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.619	2025-12-14 13:03:57.619	113.00	шт	25	только уп
54848	3392	ЛАКОМКА Московская пломбир ванильный во взбитой шок глазури 12% 80гр ТМ Чистая Линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-14 13:03:57.63	2025-12-14 13:03:57.63	140.00	шт	30	только уп
54849	3392	ЛАКОМКА Московская пломбир шоколадный во взбитой шок глазури 12% 80гр ТМ Чистая Линия	\N	\N	4209.00	уп (30 шт)	1	200	t	2025-12-14 13:03:57.643	2025-12-14 13:03:57.643	140.00	шт	30	только уп
24513	2755	ПЛ/КОНТ Радуга Пломбир четырехслойный 1000г ТМ Чистая Линия	\N	\N	1120.00	уп (1 шт)	1	62	f	2025-11-10 01:54:53.034	2025-11-22 01:30:48.533	1120.00	шт	1	\N
24518	2755	СЭНДВИЧ Максидуо соленая карамель 94гр ТМ Нестле  Старая цена 131р	\N	\N	2640.00	уп (24 шт)	1	146	f	2025-11-10 01:54:53.27	2025-11-22 01:30:48.533	110.00	шт	24	\N
54850	3392	СЭНДВИЧ Пломбир Ванильный в печенье 12% 90гр ТМ Чистая Линия	\N	\N	4678.00	уп (36 шт)	1	200	t	2025-12-14 13:03:57.656	2025-12-14 13:03:57.656	130.00	шт	36	только уп
54851	3392	СЭНДВИЧ Пломбир Радуга в печенье 12% 90гр ТМ Чистая Линия	\N	\N	4678.00	уп (36 шт)	1	200	t	2025-12-14 13:03:57.667	2025-12-14 13:03:57.667	130.00	шт	36	только уп
54852	3392	РОЖОК Пломбир ванильный 12% 110гр ТМ Чистая Линия	\N	\N	2401.00	уп (18 шт)	1	200	t	2025-12-14 13:03:57.702	2025-12-14 13:03:57.702	133.00	шт	18	только уп
54853	3392	РОЖОК Пломбир ванильный с миндалем в шоколадной глазури с миндалем 12% 90гр ТМ Чистая Линия	\N	\N	2922.00	уп (21 шт)	1	200	t	2025-12-14 13:03:57.77	2025-12-14 13:03:57.77	139.00	шт	21	только уп
54854	3392	РОЖОК Пломбир Радуга 12% 110гр ТМ Чистая Линия	\N	\N	2801.00	уп (21 шт)	1	200	t	2025-12-14 13:03:57.795	2025-12-14 13:03:57.795	133.00	шт	21	только уп
54855	3392	РОЖОК Пломбир шоколадный (пергамент) 12% 110гр ТМ Чистая Линия	\N	\N	2484.00	уп (18 шт)	1	200	t	2025-12-14 13:03:57.813	2025-12-14 13:03:57.813	138.00	шт	18	только уп
54856	3392	РОЖОК Сахарная Трубочка Пломбир ванильный в шоколадной глазури 12% 70гр ТМ Чистая Линия	\N	\N	2650.00	уп (24 шт)	1	200	t	2025-12-14 13:03:57.865	2025-12-14 13:03:57.865	110.00	шт	24	только уп
54857	3392	ЭСКИМО 11 копеек Пломбир ванильный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	4370.00	уп (40 шт)	1	200	t	2025-12-14 13:03:57.89	2025-12-14 13:03:57.89	109.00	шт	40	только уп
54858	3392	ЭСКИМО Единорожка Пломбир ванильный без глазури 12% 65гр ТМ Чистая Линия	\N	\N	2070.00	уп (24 шт)	1	200	t	2025-12-14 13:03:57.901	2025-12-14 13:03:57.901	86.00	шт	24	только уп
54859	3392	ЭСКИМО Зюзя Пломбир ванильный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	4370.00	уп (40 шт)	1	200	t	2025-12-14 13:03:57.912	2025-12-14 13:03:57.912	109.00	шт	40	только уп
54860	3392	ЭСКИМО Ленинградское Пломбир Ванильный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	5313.00	уп (42 шт)	1	200	t	2025-12-14 13:03:57.925	2025-12-14 13:03:57.925	126.00	шт	42	только уп
54861	3392	ЭСКИМО Пломбир без сахарозы 2,5% 70гр ТМ Чистая Линия	\N	\N	3967.00	уп (30 шт)	1	200	t	2025-12-14 13:03:57.937	2025-12-14 13:03:57.937	132.00	шт	30	только уп
54862	3392	ЭСКИМО Пломбир ванильный без глазури ( пергамент) 12% 70гр ТМ Чистая Линия	\N	\N	3622.00	уп (42 шт)	1	200	t	2025-12-14 13:03:57.948	2025-12-14 13:03:57.948	86.00	шт	42	только уп
54863	3392	ЭСКИМО Пломбир ванильный в апельсиновой глазури 12% 70гр ТМ Чистая Линия	\N	\N	2156.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.96	2025-12-14 13:03:57.96	86.00	шт	25	только уп
54864	3392	ЭСКИМО Пломбир ванильный в бельгийском шоколаде с клюквой 12% 80гр ТМ Чистая Линия	\N	\N	4223.00	уп (27 шт)	1	200	t	2025-12-14 13:03:57.971	2025-12-14 13:03:57.971	156.00	шт	27	только уп
54865	3392	ЭСКИМО Пломбир ванильный в клубничной глазури 12% 70гр ТМ Чистая Линия	\N	\N	2156.00	уп (25 шт)	1	200	t	2025-12-14 13:03:57.982	2025-12-14 13:03:57.982	86.00	шт	25	только уп
54866	3392	ЭСКИМО Пломбир ванильный в шок. глазури с миндалем 12% 80гр ТМ Чистая Линия	\N	\N	3309.00	уп (21 шт)	1	200	t	2025-12-14 13:03:57.995	2025-12-14 13:03:57.995	158.00	шт	21	только уп
54867	3392	ЭСКИМО Пломбир Манго с пюре манго и кусочками манго 12% 70гр ТМ Чистая Линия	\N	\N	2645.00	уп (20 шт)	1	200	t	2025-12-14 13:03:58.007	2025-12-14 13:03:58.007	132.00	шт	20	только уп
54868	3392	ЭСКИМО Пломбир Нежный кокос с аром кокоса в бел глазури 12% 62гр 1/27шт ТМ Чистая Линия	\N	\N	2961.00	уп (25 шт)	1	200	t	2025-12-14 13:03:58.018	2025-12-14 13:03:58.018	118.00	шт	25	только уп
54869	3392	ЭСКИМО Пломбир Радуга 12% 70гр ТМ Чистая Линия	\N	\N	1725.00	уп (20 шт)	1	200	t	2025-12-14 13:03:58.033	2025-12-14 13:03:58.033	86.00	шт	20	только уп
54870	3392	ЭСКИМО Пломбир шоколадный без глазури ( пергамент) 12% 70гр ТМ Чистая Линия	\N	\N	3719.00	уп (42 шт)	1	200	t	2025-12-14 13:03:58.074	2025-12-14 13:03:58.074	89.00	шт	42	только уп
54871	3392	ЭСКИМО Экскимо Российское Пломбир ванильный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	2760.00	уп (20 шт)	1	200	t	2025-12-14 13:03:58.094	2025-12-14 13:03:58.094	138.00	шт	20	только уп
54872	3392	ЭСКИМО Экскимо Российское Пломбир шоколадный в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	5520.00	уп (40 шт)	1	200	t	2025-12-14 13:03:58.111	2025-12-14 13:03:58.111	138.00	шт	40	только уп
54873	3392	ЭСКИМО Эскимо Веселый Кактус  Арахис соленая карамель 12% 70гр ТМ Чистая Линия	\N	\N	4140.00	уп (30 шт)	1	200	t	2025-12-14 13:03:58.125	2025-12-14 13:03:58.125	138.00	шт	30	только уп
54874	3392	ЭСКИМО Эскимо Веселый Кактус Ананасовое с ананасово-кокосовым наполнителем в ананасово-кокосовой глазури с хлопьями 12% 80гр ТМ Чистая Линия	\N	\N	3898.00	уп (30 шт)	1	200	t	2025-12-14 13:03:58.137	2025-12-14 13:03:58.137	130.00	шт	30	только уп
55910	3327	ТОМАТНАЯ ПАСТА 490гр ст/б ТМ Пиканта	\N	\N	1470.00	уп (6 шт)	1	200	t	2025-12-14 13:04:17.104	2025-12-14 13:04:17.104	245.00	шт	6	только уп
54875	3392	ЭСКИМО Эскимо Веселый Кактус Апельсин с наполнителем из тропиеских фруктов в глазури апельсин и взрывной карамелью 12% 80гр ТМ Чистая Линия	\N	\N	3898.00	уп (30 шт)	1	200	t	2025-12-14 13:03:58.149	2025-12-14 13:03:58.149	130.00	шт	30	только уп
24562	2755	НАРЕЗКА БЕКОН 180гр 1/10шт с/к в/у ТМ Черкизово	\N	\N	3000.00	уп (10 шт)	1	16	f	2025-11-10 01:54:55.584	2025-11-22 01:30:48.533	300.00	шт	10	\N
54876	3392	ЭСКИМО Эскимо Веселый Кактус Гранат с наполнителем фруктовый лукум в глазури гранат с взрывной карамелью и кусочками ягод 12% 80гр ТМ Чистая Линия	\N	\N	4451.00	уп (30 шт)	1	200	t	2025-12-14 13:03:58.16	2025-12-14 13:03:58.16	148.00	шт	30	только уп
54877	3392	ЭСКИМО Эскимо Веселый Кактус малиновый в глазури с ароматом и кусочками малины 12% 80гр ТМ Чистая Линия	\N	\N	4002.00	уп (30 шт)	1	200	t	2025-12-14 13:03:58.178	2025-12-14 13:03:58.178	133.00	шт	30	только уп
54878	3392	ЭСКИМО Эскимо Веселый Кактус Пралине пломбир ванильный с прослойкой сливочной карамели и орехом пекан в шоколадной глазури 12% 80гр ТМ Чистая Линия	\N	\N	3719.00	уп (21 шт)	1	200	t	2025-12-14 13:03:58.189	2025-12-14 13:03:58.189	177.00	шт	21	только уп
54879	3392	ЭСКИМО Эскимо Веселый Кактус с клубникой в глазури с ароматом лимона и кусочками клубники 12% 80гр ТМ Чистая Линия	\N	\N	3898.00	уп (30 шт)	1	200	t	2025-12-14 13:03:58.2	2025-12-14 13:03:58.2	130.00	шт	30	только уп
54880	3392	ЭСКИМО Эскимо Веселый Кактус Фисташковый пломбир с фисташковой пастой с кусочками фисташки в шок глазури 12% 80гр ТМ Чистая Линия	\N	\N	3422.00	уп (16 шт)	1	200	t	2025-12-14 13:03:58.21	2025-12-14 13:03:58.21	214.00	шт	16	только уп
54881	3392	ЭСКИМО Эскимо Гранат-Малина Гранатовый-малиновый сок и кусочки малины 12% 70гр ТМ Чистая Линия	\N	\N	2599.00	уп (20 шт)	1	190	t	2025-12-14 13:03:58.222	2025-12-14 13:03:58.222	130.00	шт	20	только уп
54882	3392	ПАКЕТ Пломбир ванильный без сахарозы 12% 200гр ТМ Чистая Линия	\N	\N	6440.00	шт	1	200	t	2025-12-14 13:03:58.235	2025-12-14 13:03:58.235	258.00	шт	25	поштучно
54883	3392	ПАКЕТ Пломбир Семейное ванильный 12% 200гр ТМ Чистая Линия	\N	\N	5089.00	шт	1	200	t	2025-12-14 13:03:58.246	2025-12-14 13:03:58.246	204.00	шт	25	поштучно
54884	3392	ПАКЕТ Пломбир Семейное ванильный 12% 450гр ТМ Чистая Линия	\N	\N	6982.00	шт	1	200	t	2025-12-14 13:03:58.262	2025-12-14 13:03:58.262	537.00	шт	13	поштучно
54885	3392	ПАКЕТ Пломбир Семейное Крем-Брюле 12% 200гр ТМ Чистая Линия	\N	\N	5089.00	шт	1	200	t	2025-12-14 13:03:58.274	2025-12-14 13:03:58.274	204.00	шт	25	поштучно
54886	3392	ПАКЕТ Пломбир Семейное шоколадный 12% 200гр ТМ Чистая Линия	\N	\N	5089.00	шт	1	200	t	2025-12-14 13:03:58.288	2025-12-14 13:03:58.288	204.00	шт	25	поштучно
54887	3392	ПАКЕТ Пломбир Семейное шоколадный 12% 450гр ТМ Чистая Линия	\N	\N	4296.00	шт	1	200	t	2025-12-14 13:03:58.3	2025-12-14 13:03:58.3	537.00	шт	8	поштучно
54888	3392	ПЛ/КОНТ Банановый Сплит банановое с шоколадной крошкой 1000г ТМ Чистая Линия	\N	\N	1420.00	шт	1	12	t	2025-12-14 13:03:58.311	2025-12-14 13:03:58.311	1420.00	шт	1	поштучно
54889	3392	ПЛ/КОНТ Пломбир клубника ваниль с кусочками клубники 1000г 1/1шт ТМ Чистая Линия	\N	\N	1501.00	шт	1	8	t	2025-12-14 13:03:58.325	2025-12-14 13:03:58.325	1501.00	шт	1	поштучно
54890	3392	ПЛ/КОНТ Радуга Пломбир четырехслойный 1000г ТМ Чистая Линия	\N	\N	1288.00	шт	1	49	t	2025-12-14 13:03:58.339	2025-12-14 13:03:58.339	1288.00	шт	1	поштучно
54891	3392	ПЛ/КОНТ Шоколад-Шоколадович Пломбир шоколадный с кусочками шоколада1000г ТМ Чистая Линия	\N	\N	1420.00	шт	1	32	t	2025-12-14 13:03:58.351	2025-12-14 13:03:58.351	1420.00	шт	1	поштучно
54892	3392	ВАФ СТАКАНЧИК Пломбир 48 Копеек 15% 88гр ТМ Нестле Старая цена 82р	\N	\N	2484.00	уп (30 шт)	1	200	t	2025-12-14 13:03:58.365	2025-12-14 13:03:58.365	83.00	шт	30	только уп
54893	3392	ВАФ СТАКАНЧИК Пломбир 48 Копеек малина 15% 88гр ТМ Нестле	\N	\N	3381.00	уп (30 шт)	1	200	t	2025-12-14 13:03:58.375	2025-12-14 13:03:58.375	113.00	шт	30	только уп
54894	3392	ВАФ СТАКАНЧИК Пломбир 48 Копеек шоколад 88гр ТМ Нестле	\N	\N	3381.00	уп (30 шт)	1	200	t	2025-12-14 13:03:58.388	2025-12-14 13:03:58.388	113.00	шт	30	только уп
54895	3392	СЭНДВИЧ Максидуо соленая карамель 94гр ТМ Нестле  Старая цена 131р	\N	\N	3036.00	уп (24 шт)	1	170	t	2025-12-14 13:03:58.398	2025-12-14 13:03:58.398	126.00	шт	24	только уп
54896	3392	СЭНДВИЧ Орео 9% 76гр 1/24шт ТМ Нестле Старая цена 100р	\N	\N	2208.00	уп (24 шт)	1	200	t	2025-12-14 13:03:58.423	2025-12-14 13:03:58.423	92.00	шт	24	только уп
54897	3392	РОЖОК Орео 8% 72гр 1/24шт ТМ Нестле	\N	\N	3450.00	уп (24 шт)	1	200	t	2025-12-14 13:03:58.449	2025-12-14 13:03:58.449	144.00	шт	24	только уп
54898	3392	РОЖОК Пломбир 48 Копеек с глазурью и кусочками миндаля 12% 106гр ТМ Нестле	\N	\N	2588.00	уп (18 шт)	1	200	t	2025-12-14 13:03:58.466	2025-12-14 13:03:58.466	144.00	шт	18	только уп
54899	3392	РОЖОК Санрем Клубника со сливками 73гр 1/24шт ТМ Нестле Старая цена 112р	\N	\N	1932.00	уп (24 шт)	1	200	t	2025-12-14 13:03:58.478	2025-12-14 13:03:58.478	81.00	шт	24	только уп
54900	3392	РОЖОК Санрем Малина Банан 78гр 1/24шт ТМ Нестле Старая цена 97р	\N	\N	2208.00	уп (24 шт)	1	200	t	2025-12-14 13:03:58.499	2025-12-14 13:03:58.499	92.00	шт	24	только уп
54901	3392	ЭСКИМО Альпен Гольд 8% 58гр ТМ Нестле Старая цена 142р	\N	\N	3074.00	уп (27 шт)	1	200	t	2025-12-14 13:03:58.539	2025-12-14 13:03:58.539	114.00	шт	27	только уп
52544	3392	ВАФ СТАКАНЧИК Пломбир 48 Копеек 15% 88гр ТМ Нестле Старая цена 82р	\N	\N	2484.00	уп (30 шт)	1	200	f	2025-12-07 13:19:14.214	2025-12-14 12:09:06.688	83.00	шт	30	только уп
54902	3392	ЭСКИМО Максидуо вафельный микс 63гр ТМ Нестле	\N	\N	3260.00	уп (27 шт)	1	200	t	2025-12-14 13:03:58.577	2025-12-14 13:03:58.577	121.00	шт	27	только уп
54903	3392	ЭСКИМО Милка 8% 62гр ТМ Нестле Старая цена 161р	\N	\N	3074.00	уп (27 шт)	1	200	t	2025-12-14 13:03:58.591	2025-12-14 13:03:58.591	114.00	шт	27	только уп
54904	3392	ЭСКИМО Милка лесные ягоды 8% 64гр ТМ Нестле Старая цена 167р	\N	\N	3571.00	уп (27 шт)	1	200	t	2025-12-14 13:03:58.603	2025-12-14 13:03:58.603	132.00	шт	27	только уп
54905	3392	ЭСКИМО Миндаль в глазури 59гр ТМ Нестле	\N	\N	3260.00	уп (27 шт)	1	200	t	2025-12-14 13:03:58.616	2025-12-14 13:03:58.616	121.00	шт	27	только уп
54906	3392	ЭСКИМО Орео 8% 56гр ТМ Нестле Старая цена 120р	\N	\N	3260.00	уп (27 шт)	1	200	t	2025-12-14 13:03:58.628	2025-12-14 13:03:58.628	121.00	шт	27	только уп
54907	3392	БРИКЕТ 48 Копеек Шоколадный с шок.соусом 232гр 1/25шт ТМ Нестле	\N	\N	5664.00	уп (25 шт)	1	200	t	2025-12-14 13:03:58.64	2025-12-14 13:03:58.64	227.00	шт	25	только уп
54908	3392	БРИКЕТ 48 КопеекПломбир 12% 210гр 1/25шт ТМ Нестле	\N	\N	5664.00	уп (25 шт)	1	200	t	2025-12-14 13:03:58.651	2025-12-14 13:03:58.651	227.00	шт	25	только уп
54909	3392	Ведро Максидуо 282гр 1/8шт ТМ Нестле	\N	\N	4692.00	шт	1	200	t	2025-12-14 13:03:58.663	2025-12-14 13:03:58.663	587.00	шт	8	поштучно
54910	3392	ПЛ/КОНТЕЙНЕР Мороженое 48 копеек пломбир 419гр ТМ НЕСТЛЕ	\N	\N	4048.00	шт	1	32	t	2025-12-14 13:03:58.675	2025-12-14 13:03:58.675	506.00	шт	8	поштучно
54911	3392	ФРУКТОВЫЙ ЛЁД Бон Пари Кошмарики 59гр ТМ Нестле	\N	\N	3974.00	уп (32 шт)	1	200	t	2025-12-14 13:03:58.695	2025-12-14 13:03:58.695	124.00	шт	32	только уп
54912	3392	ФРУКТОВЫЙ ЛЁД Бон Пари Ураган с взр.карамелью 60гр ТМ Нестле	\N	\N	4099.00	уп (44 шт)	1	200	t	2025-12-14 13:03:58.708	2025-12-14 13:03:58.708	93.00	шт	44	только уп
54913	3392	ФРУКТОВЫЙ ЛЁД Почемучка 60гр ТМ Нестле	\N	\N	2581.00	уп (44 шт)	1	88	t	2025-12-14 13:03:58.722	2025-12-14 13:03:58.722	59.00	шт	44	только уп
54914	3396	ВЕТЧИНА вар Турбослимский бройлер 400гр Мусульманская Халяль 1/10шт	\N	\N	3450.00	шт	1	22	t	2025-12-14 13:03:58.738	2025-12-14 13:03:58.738	345.00	шт	10	поштучно
54915	3396	ВЕТЧИНА вар Черкизово 400гр Мраморная по-черкизовски 1/6шт	\N	\N	2243.00	шт	1	34	t	2025-12-14 13:03:58.75	2025-12-14 13:03:58.75	374.00	шт	6	поштучно
54916	3396	КОЛБАСА вар Турбослимский бройлер 400гр Мусульманская Халяль 1/10шт	\N	\N	1725.00	шт	1	25	t	2025-12-14 13:03:58.77	2025-12-14 13:03:58.77	173.00	шт	10	поштучно
54917	3396	КОЛБАСА вар Черкизово 380гр Сочная с окороком	\N	\N	1932.00	шт	1	11	t	2025-12-14 13:03:58.781	2025-12-14 13:03:58.781	322.00	шт	6	поштучно
54918	3396	КОЛБАСА вар Черкизово 400гр Молочная по-Черкизовски	\N	\N	2070.00	шт	1	9	t	2025-12-14 13:03:58.792	2025-12-14 13:03:58.792	345.00	шт	6	поштучно
54919	3396	КОЛБАСА вар Черкизово 500гр Губернская в сетке	\N	\N	1932.00	шт	1	16	t	2025-12-14 13:03:58.803	2025-12-14 13:03:58.803	322.00	шт	6	поштучно
54920	3396	ВЕТЧИНА вар Папа может 400гр с Индейкой	\N	\N	1856.00	шт	1	26	t	2025-12-14 13:03:58.814	2025-12-14 13:03:58.814	309.00	шт	6	поштучно
54921	3396	КОЛБАСА вар Папа может 400гр Докторская Премиум	\N	\N	2282.00	шт	1	26	t	2025-12-14 13:03:58.826	2025-12-14 13:03:58.826	285.00	шт	8	поштучно
54922	3396	КОЛБАСА вар Папа может 400гр Мясная	\N	\N	2134.00	шт	1	21	t	2025-12-14 13:03:58.839	2025-12-14 13:03:58.839	267.00	шт	8	поштучно
54923	3396	КОЛБАСА вар Папа может 400гр Папин бутер	\N	\N	2364.00	шт	1	40	t	2025-12-14 13:03:58.866	2025-12-14 13:03:58.866	296.00	шт	8	поштучно
54924	3396	КОЛБАСА вар Папа может 400гр Сочная	\N	\N	1725.00	шт	1	7	t	2025-12-14 13:03:58.877	2025-12-14 13:03:58.877	173.00	шт	10	поштучно
54925	3396	КОЛБАСА вар Папа может 400гр Филейная	\N	\N	1380.00	шт	1	7	t	2025-12-14 13:03:58.889	2025-12-14 13:03:58.889	173.00	шт	8	поштучно
54926	3396	КОЛБАСА вар Папа может 400гр Экстра	\N	\N	1380.00	шт	1	10	t	2025-12-14 13:03:58.901	2025-12-14 13:03:58.901	173.00	шт	8	поштучно
54927	3396	САРДЕЛЬКИ ПАПА МОЖЕТ Сочные 300гр в/уп	\N	\N	1849.00	шт	1	28	t	2025-12-14 13:03:58.912	2025-12-14 13:03:58.912	231.00	шт	8	поштучно
54928	3396	СОСИСКИ ПАПА МОЖЕТ Молочные ГОСТ 300гр в/уп	\N	\N	1658.00	шт	1	42	t	2025-12-14 13:03:58.922	2025-12-14 13:03:58.922	237.00	шт	7	поштучно
54929	3396	СОСИСКИ ПАПА МОЖЕТ Молочные ПРЕМИУМ 350гр в/уп	\N	\N	1895.00	шт	1	35	t	2025-12-14 13:03:58.949	2025-12-14 13:03:58.949	237.00	шт	8	поштучно
54930	3396	СОСИСКИ ПАПА МОЖЕТ Сочные 350гр в/уп	\N	\N	2171.00	шт	1	31	t	2025-12-14 13:03:58.96	2025-12-14 13:03:58.96	271.00	шт	8	поштучно
54931	3396	ШПИКАЧКИ ПАПА МОЖЕТ Сочные с беконом 300гр в/уп	\N	\N	1849.00	шт	1	51	t	2025-12-14 13:03:58.973	2025-12-14 13:03:58.973	231.00	шт	8	поштучно
54934	3396	КОЛБАСА вар СПК 400гр Любительская п/а	\N	\N	18860.00	шт	1	14	t	2025-12-14 13:03:59.009	2025-12-14 13:03:59.009	377.00	шт	50	поштучно
54935	3396	КОЛБАСА Черкизово Балыковая по-черкизовски в/к фиб в/уп 300гр цена за шт	\N	\N	2450.00	шт	1	9	t	2025-12-14 13:03:59.022	2025-12-14 13:03:59.022	408.00	шт	6	поштучно
54936	3396	КОЛБАСА ОСТАНКИНО Венская Салями п/к 330гр цена за шт	\N	\N	2024.00	шт	1	12	t	2025-12-14 13:03:59.035	2025-12-14 13:03:59.035	253.00	шт	8	поштучно
52578	3396	КОЛБАСА вар Папа может 400гр Домашняя	\N	\N	2328.00	шт	1	30	f	2025-12-07 13:19:14.744	2025-12-14 08:13:15.964	291.00	шт	8	поштучно
52576	3396	КОЛБАСА вар Папа может 400гр Говяжья	\N	\N	2328.00	шт	1	41	f	2025-12-07 13:19:14.72	2025-12-14 08:13:16.276	291.00	шт	8	поштучно
52554	3392	ЭСКИМО 48 копеек Яблоко 40гр ТМ Нестле	\N	\N	4416.00	уп (40 шт)	1	40	f	2025-12-07 13:19:14.343	2025-12-14 08:13:16.984	110.00	шт	40	только уп
52553	3392	ЭСКИМО 48 копеек Морс из клюквы 40гр ТМ Нестле Старая цена 81р	\N	\N	3220.00	уп (40 шт)	1	161	f	2025-12-07 13:19:14.332	2025-12-14 08:13:17.339	81.00	шт	40	только уп
54933	3396	КОЛБАСА вар Анком ВЕС Анкомовская в/с замороженая п/а	\N	\N	11638.00	кг	1	41	f	2025-12-14 13:03:58.996	2025-12-14 17:05:05.323	582.00	кг	20	поштучно
54937	3396	КОЛБАСА ОСТАНКИНО Сервелат Европейский в/к 330гр цена за шт	\N	\N	3404.00	шт	1	8	t	2025-12-14 13:03:59.048	2025-12-14 13:03:59.048	425.00	шт	8	поштучно
54938	3396	КОЛБАСА ОСТАНКИНО Сервелат Копченый на Буке в/к 350гр цена за шт	\N	\N	2456.00	шт	1	46	t	2025-12-14 13:03:59.06	2025-12-14 13:03:59.06	307.00	шт	8	поштучно
54939	3396	КОЛБАСА ОСТАНКИНО Сервелат Кремлевский в/к 330гр цена за шт	\N	\N	3404.00	шт	1	51	t	2025-12-14 13:03:59.073	2025-12-14 13:03:59.073	425.00	шт	8	поштучно
54940	3396	КОЛБАСА ПАПА МОЖЕТ Балыковая п/к 310гр цена за шт	\N	\N	1840.00	шт	1	21	t	2025-12-14 13:03:59.084	2025-12-14 13:03:59.084	230.00	шт	8	поштучно
54941	3396	КОЛБАСА ПАПА МОЖЕТ Домашний Рецепт п/к 330гр цена за шт	\N	\N	2784.00	шт	1	24	t	2025-12-14 13:03:59.098	2025-12-14 13:03:59.098	309.00	шт	9	поштучно
54942	3396	КОЛБАСА ПАПА МОЖЕТ Салями п/к 280гр цена за шт	\N	\N	1380.00	шт	1	13	t	2025-12-14 13:03:59.112	2025-12-14 13:03:59.112	173.00	шт	8	поштучно
54943	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Австрийский в/к 420гр цена за шт	\N	\N	2576.00	шт	1	36	t	2025-12-14 13:03:59.126	2025-12-14 13:03:59.126	322.00	шт	8	поштучно
54944	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Зернистый в/к 350гр цена за шт	\N	\N	2438.00	шт	1	50	t	2025-12-14 13:03:59.14	2025-12-14 13:03:59.14	305.00	шт	8	поштучно
54945	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Карельский в/к 280гр цена за шт	\N	\N	1472.00	шт	1	30	t	2025-12-14 13:03:59.153	2025-12-14 13:03:59.153	184.00	шт	8	поштучно
54946	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Ореховый в/к 310гр цена за шт	\N	\N	2475.00	шт	1	51	t	2025-12-14 13:03:59.165	2025-12-14 13:03:59.165	309.00	шт	8	поштучно
54947	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Охотничий в/к 350гр цена за шт	\N	\N	2475.00	шт	1	9	t	2025-12-14 13:03:59.176	2025-12-14 13:03:59.176	309.00	шт	8	поштучно
54948	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Пражский в/к 350гр цена за шт	\N	\N	2475.00	шт	1	56	t	2025-12-14 13:03:59.186	2025-12-14 13:03:59.186	309.00	шт	8	поштучно
54949	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Финский в/к 350гр цена за шт	\N	\N	1748.00	шт	1	19	t	2025-12-14 13:03:59.199	2025-12-14 13:03:59.199	218.00	шт	8	поштучно
54950	3396	КОЛБАСА ПАПА МОЖЕТ Сервелат Шварцер в/к 280гр цена за шт	\N	\N	1518.00	шт	1	42	t	2025-12-14 13:03:59.213	2025-12-14 13:03:59.213	190.00	шт	8	поштучно
54951	3396	КОЛБАСА ПАПА МОЖЕТ Чесночная п/к 350гр цена за шт	\N	\N	2438.00	шт	1	46	t	2025-12-14 13:03:59.227	2025-12-14 13:03:59.227	305.00	шт	8	поштучно
54952	3396	КУСОК БЕКОН свиной Пряные специи 400гр в/к в/уп ТМ ВИК	\N	\N	489.00	шт	1	100	t	2025-12-14 13:03:59.239	2025-12-14 13:03:59.239	489.00	шт	1	поштучно
54953	3396	КУСОК БЕКОН свиной Фермерский 400гр в/к в/уп ТМ ВИК	\N	\N	489.00	шт	1	100	t	2025-12-14 13:03:59.251	2025-12-14 13:03:59.251	489.00	шт	1	поштучно
54954	3396	КУСОК ЛОПАТКА свиная 400гр в/к в/уп ТМ ВИК	\N	\N	492.00	шт	1	100	t	2025-12-14 13:03:59.27	2025-12-14 13:03:59.27	492.00	шт	1	поштучно
54955	3396	НАРЕЗКА БЕКОН свиной Фермерский 200гр в/к в/уп ТМ ВИК	\N	\N	267.00	шт	1	100	t	2025-12-14 13:03:59.28	2025-12-14 13:03:59.28	267.00	шт	1	поштучно
54956	3396	НАРЕЗКА ЛОПАТКА свиная  200гр в/к в/уп ТМ ВИК	\N	\N	267.00	шт	1	70	t	2025-12-14 13:03:59.332	2025-12-14 13:03:59.332	267.00	шт	1	поштучно
54957	3396	КОЛБАСА Останкино с/к Ароматная 250гр	\N	\N	2898.00	шт	1	9	t	2025-12-14 13:03:59.373	2025-12-14 13:03:59.373	362.00	шт	8	поштучно
54958	3396	КОЛБАСА Останкино с/к Пресижн 250гр	\N	\N	3873.00	шт	1	48	t	2025-12-14 13:03:59.41	2025-12-14 13:03:59.41	484.00	шт	8	поштучно
54959	3396	КОЛБАСА Останкино с/к Сальчичон 220гр	\N	\N	2944.00	шт	1	7	t	2025-12-14 13:03:59.424	2025-12-14 13:03:59.424	368.00	шт	8	поштучно
54960	3396	КОЛБАСА Останкино с/к Салями Итальянская 250гр	\N	\N	3238.00	шт	1	8	t	2025-12-14 13:03:59.444	2025-12-14 13:03:59.444	405.00	шт	8	поштучно
54961	3396	КОЛБАСА Папа может с/к Бургундия 250гр	\N	\N	2852.00	шт	1	8	t	2025-12-14 13:03:59.734	2025-12-14 13:03:59.734	357.00	шт	8	поштучно
54962	3396	КОЛБАСА Папа может с/к Охотничья 220гр	\N	\N	2300.00	шт	1	28	t	2025-12-14 13:03:59.79	2025-12-14 13:03:59.79	288.00	шт	8	поштучно
54963	3396	КОЛБАСА Папа может с/к Экстра 250гр	\N	\N	2392.00	шт	1	44	t	2025-12-14 13:03:59.808	2025-12-14 13:03:59.808	299.00	шт	8	поштучно
54964	3396	КОЛБАСА Черкизово с/к Богородская 300гр	\N	\N	6417.00	шт	1	7	t	2025-12-14 13:03:59.867	2025-12-14 13:03:59.867	535.00	шт	12	поштучно
54965	3396	КОЛБАСА Черкизово с/к Бородинская Экстра 200гр	\N	\N	2277.00	шт	1	21	t	2025-12-14 13:03:59.879	2025-12-14 13:03:59.879	379.00	шт	6	поштучно
54966	3396	КОЛБАСА Черкизово с/к Брауншвейгская срез 200гр	\N	\N	2884.00	шт	1	11	t	2025-12-14 13:03:59.894	2025-12-14 13:03:59.894	481.00	шт	6	поштучно
54967	3396	КОЛБАСА Черкизово с/к Преображенская срез 300гр	\N	\N	3105.00	шт	1	12	t	2025-12-14 13:03:59.905	2025-12-14 13:03:59.905	518.00	шт	6	поштучно
52599	3396	СОСИСКИ СПК Молочные 360гр в/уп	\N	\N	12937.00	шт	1	24	f	2025-12-07 13:19:15.12	2025-12-14 08:13:13.02	259.00	шт	50	поштучно
52598	3396	СОСИСКИ СПК Большая SOSиска 1кг в/уп	\N	\N	13478.00	кг	1	15	f	2025-12-07 13:19:14.997	2025-12-14 08:13:13.345	674.00	кг	20	поштучно
52597	3396	СОСИСКИ СПК Баварские с сыром 360гр в/уп	\N	\N	14030.00	шт	1	22	f	2025-12-07 13:19:14.985	2025-12-14 08:13:13.689	281.00	шт	50	поштучно
52596	3396	КОЛБАСА вар СПК ВЕС Утренняя	\N	\N	11184.00	кг	1	17	f	2025-12-07 13:19:14.974	2025-12-14 08:13:13.977	447.00	кг	25	поштучно
52594	3396	КОЛБАСА вар СПК 470гр Покровская п/а	\N	\N	11902.00	шт	1	50	f	2025-12-07 13:19:14.951	2025-12-14 08:13:14.29	238.00	шт	50	поштучно
52593	3396	КОЛБАСА вар СПК 470гр К чаю	\N	\N	11558.00	шт	1	69	f	2025-12-07 13:19:14.94	2025-12-14 08:13:14.622	231.00	шт	50	поштучно
52592	3396	КОЛБАСА вар СПК 470гр Бутербродная п/а	\N	\N	10523.00	шт	1	38	f	2025-12-07 13:19:14.928	2025-12-14 08:13:14.926	210.00	шт	50	поштучно
40769	2755	ПРЯНИКИ Хлебный дом Классические 300гр	\N	\N	1104.00	уп (12 шт)	1	94	f	2025-11-30 11:01:31.568	2025-12-06 02:48:51.249	80.00	шт	12	\N
24689	2755	ПЕЧЕНЬЕ СЭНДВИЧ Bang bang вкус клубники 4кг	\N	\N	1988.00	уп (4 шт)	1	32	f	2025-11-10 01:55:02.677	2025-11-22 01:30:48.533	497.00	кг	4	\N
24690	2755	ПЕЧЕНЬЕ СЭНДВИЧ Сладонеж какао молоко 4кг	\N	\N	1988.00	уп (4 шт)	1	12	f	2025-11-10 01:55:02.721	2025-11-22 01:30:48.533	497.00	кг	4	\N
54968	3396	КОЛБАСА Черкизово с/к Салями Астория срез 225гр	\N	\N	2691.00	шт	1	14	t	2025-12-14 13:03:59.918	2025-12-14 13:03:59.918	448.00	шт	6	поштучно
54969	3396	КОЛБАСА Черкизово с/к Салями Фламенко 250гр	\N	\N	3381.00	шт	1	6	t	2025-12-14 13:03:59.93	2025-12-14 13:03:59.93	564.00	шт	6	поштучно
54970	3396	КОЛБАСА Черкизово с/к Свиная по-черкизовски 225гр	\N	\N	2484.00	шт	1	33	t	2025-12-14 13:03:59.942	2025-12-14 13:03:59.942	414.00	шт	6	поштучно
54971	3396	КОЛБАСА ВИК Нарезка с/к Банкетная 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-14 13:03:59.954	2025-12-14 13:03:59.954	221.00	шт	1	поштучно
54972	3396	КОЛБАСА ВИК Нарезка с/к Берлинская 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-14 13:03:59.986	2025-12-14 13:03:59.986	221.00	шт	1	поштучно
54973	3396	КОЛБАСА ВИК Нарезка с/к Брауншвейгская 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-14 13:04:00.002	2025-12-14 13:04:00.002	221.00	шт	1	поштучно
54974	3396	КОЛБАСА ВИК Нарезка с/к Виковская (Киевская) 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-14 13:04:00.168	2025-12-14 13:04:00.168	221.00	шт	1	поштучно
54975	3396	КОЛБАСА ВИК Нарезка с/к Дальневосточная 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-14 13:04:00.204	2025-12-14 13:04:00.204	221.00	шт	1	поштучно
54976	3396	КОЛБАСА ВИК Нарезка с/к Зернистая 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-14 13:04:00.248	2025-12-14 13:04:00.248	221.00	шт	1	поштучно
54977	3396	КОЛБАСА ВИК Нарезка с/к Коньячная 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-14 13:04:00.268	2025-12-14 13:04:00.268	221.00	шт	1	поштучно
54978	3396	КОЛБАСА ВИК Нарезка с/к Молодежная 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-14 13:04:00.306	2025-12-14 13:04:00.306	221.00	шт	1	поштучно
54979	3396	КОЛБАСА ВИК Нарезка с/к Московская 100гр в/уп	\N	\N	236.00	шт	1	100	t	2025-12-14 13:04:00.32	2025-12-14 13:04:00.32	236.00	шт	1	поштучно
54980	3396	КОЛБАСА ВИК Нарезка с/к Пять Перцев 100гр в/уп	\N	\N	221.00	шт	1	100	t	2025-12-14 13:04:00.343	2025-12-14 13:04:00.343	221.00	шт	1	поштучно
54981	3396	КОЛБАСА ВИК Нарезка с/к Сервелат 100гр в/уп	\N	\N	236.00	шт	1	100	t	2025-12-14 13:04:00.361	2025-12-14 13:04:00.361	236.00	шт	1	поштучно
54982	3396	КОЛБАСА ВИК Нарезка с/к Столичная 100гр в/уп	\N	\N	236.00	шт	1	89	t	2025-12-14 13:04:00.386	2025-12-14 13:04:00.386	236.00	шт	1	поштучно
54983	3396	КОЛБАСА СПК Колбаски ПодПивасики оригинальные в/уп 100гр цена за шт	\N	\N	25645.00	шт	1	11	t	2025-12-14 13:04:00.404	2025-12-14 13:04:00.404	256.00	шт	100	поштучно
54984	3396	КОЛБАСА СПК Нарезка с/к Новосибирская Высокий вкус 100гр в/уп	\N	\N	24633.00	шт	1	19	t	2025-12-14 13:04:00.416	2025-12-14 13:04:00.416	274.00	шт	90	поштучно
54985	3396	КОЛБАСА СПК Нарезка с/к Пипперони Эликатессе 100гр в/уп	\N	\N	24115.00	шт	1	36	t	2025-12-14 13:04:00.439	2025-12-14 13:04:00.439	268.00	шт	90	поштучно
54986	3396	КОЛБАСА СПК Нарезка с/к Фестивальная пора 100гр в/уп	\N	\N	18009.00	шт	1	7	t	2025-12-14 13:04:00.455	2025-12-14 13:04:00.455	200.00	шт	90	поштучно
54987	3396	КОЛБАСА СПК с/к Балыковая Эликатессе 200гр	\N	\N	38295.00	шт	1	46	t	2025-12-14 13:04:00.474	2025-12-14 13:04:00.474	425.00	шт	90	поштучно
54988	3396	КОЛБАСА СПК с/к Новосибирская 235гр	\N	\N	40365.00	шт	1	42	t	2025-12-14 13:04:00.487	2025-12-14 13:04:00.487	448.00	шт	90	поштучно
54989	3396	КОЛБАСА СПК с/к Оригинальная с перцем 235гр	\N	\N	30532.00	шт	1	60	t	2025-12-14 13:04:00.501	2025-12-14 13:04:00.501	339.00	шт	90	поштучно
54990	3396	КОЛБАСА СПК с/к Пепперони для пиццы ВЕС в/уп	\N	\N	25904.00	кг	1	9	t	2025-12-14 13:04:00.515	2025-12-14 13:04:00.515	1036.00	кг	25	поштучно
54991	3396	КОЛБАСА СПК с/к Сальчичон Эликатессе 200гр	\N	\N	35190.00	шт	1	16	t	2025-12-14 13:04:00.528	2025-12-14 13:04:00.528	391.00	шт	90	поштучно
54992	3396	КОЛБАСА СПК с/к Фестивальная пора 235гр	\N	\N	30325.00	шт	1	47	t	2025-12-14 13:04:00.587	2025-12-14 13:04:00.587	337.00	шт	90	поштучно
54993	3303	ВАФЛИ Коломенские 140гр Палочки с орешками	\N	\N	1780.00	уп (18 шт)	1	285	t	2025-12-14 13:04:00.603	2025-12-14 13:04:00.603	99.00	шт	18	только уп
54994	3303	ВАФЛИ Коломенские 200гр Каприччио	\N	\N	1978.00	уп (20 шт)	1	519	t	2025-12-14 13:04:00.621	2025-12-14 13:04:00.621	99.00	шт	20	только уп
54995	3303	ВАФЛИ Коломенские 200гр с Орехами	\N	\N	1978.00	уп (20 шт)	1	329	t	2025-12-14 13:04:00.639	2025-12-14 13:04:00.639	99.00	шт	20	только уп
54996	3303	ВАФЛИ Коломенские 200гр с Халвой	\N	\N	1978.00	уп (20 шт)	1	405	t	2025-12-14 13:04:00.651	2025-12-14 13:04:00.651	99.00	шт	20	только уп
52659	3396	КОЛБАСА СПК Колбаски ПодПивасики острые в/уп 100гр цена за шт	\N	\N	25645.00	шт	1	79	f	2025-12-07 13:19:16.552	2025-12-14 08:13:08.565	256.00	шт	100	поштучно
52644	3396	КОЛБАСА Черкизово с/к Элитная срез 225гр	\N	\N	3036.00	шт	1	14	f	2025-12-07 13:19:16.124	2025-12-14 08:13:09.649	506.00	шт	6	поштучно
52643	3396	КОЛБАСА Черкизово с/к Сервелетти 250гр	\N	\N	3105.00	шт	1	15	f	2025-12-07 13:19:16.113	2025-12-14 08:13:09.947	518.00	шт	6	поштучно
52638	3396	КОЛБАСА Черкизово с/к Сальчичон 300гр	\N	\N	4464.00	шт	1	28	f	2025-12-07 13:19:16.036	2025-12-14 08:13:10.643	744.00	шт	6	поштучно
52632	3396	КОЛБАСА Папа может с/к Салями 250гр	\N	\N	2898.00	шт	1	11	f	2025-12-07 13:19:15.915	2025-12-14 08:13:10.952	362.00	шт	8	поштучно
52629	3396	КОЛБАСА Останкино с/к Юбилейная 250гр	\N	\N	2999.00	шт	1	45	f	2025-12-07 13:19:15.863	2025-12-14 08:13:11.284	375.00	шт	8	поштучно
52662	3396	КОЛБАСА СПК Нарезка с/к Пипперони Эликатессе 100гр в/уп	\N	\N	24115.00	шт	1	69	f	2025-12-07 13:19:16.585	2025-12-14 12:09:06.688	268.00	шт	90	поштучно
54997	3303	ВАФЛИ Коломенские 200гр Сливочные	\N	\N	1978.00	уп (20 шт)	1	505	t	2025-12-14 13:04:00.666	2025-12-14 13:04:00.666	99.00	шт	20	только уп
54998	3303	ВАФЛИ Коломенские 200гр Топленое молоко	\N	\N	1978.00	уп (20 шт)	1	610	t	2025-12-14 13:04:00.679	2025-12-14 13:04:00.679	99.00	шт	20	только уп
54999	3303	ВАФЛИ Коломенские 90гр Десертные с Халвой	\N	\N	1196.00	уп (20 шт)	1	199	t	2025-12-14 13:04:00.691	2025-12-14 13:04:00.691	60.00	шт	20	только уп
55000	3303	ВАФЛИ Коломенские 90гр Десертные с Шоколадным кремом	\N	\N	1426.00	уп (20 шт)	1	7	t	2025-12-14 13:04:00.702	2025-12-14 13:04:00.702	71.00	шт	20	только уп
55001	3303	ВАФЛИ МИНИ Коломенские 200гр Сливочные	\N	\N	1311.00	уп (12 шт)	1	119	t	2025-12-14 13:04:00.717	2025-12-14 13:04:00.717	109.00	шт	12	только уп
55002	3303	ВАФЛИ МИНИ Коломенские 200гр Шоколадно ореховые	\N	\N	1311.00	уп (12 шт)	1	285	t	2025-12-14 13:04:00.731	2025-12-14 13:04:00.731	109.00	шт	12	только уп
55003	3303	ПЕЧЕНЬЕ Коломенское 120гр Овсяное хрустящее	\N	\N	1164.00	уп (22 шт)	1	32	t	2025-12-14 13:04:00.748	2025-12-14 13:04:00.748	53.00	шт	22	только уп
55004	3303	ПЕЧЕНЬЕ Коломенское 120гр Сахарное классическое	\N	\N	1037.00	уп (22 шт)	1	87	t	2025-12-14 13:04:00.775	2025-12-14 13:04:00.775	47.00	шт	22	только уп
55005	3303	ПЕЧЕНЬЕ Коломенское 120гр Шоколадное	\N	\N	1164.00	уп (22 шт)	1	165	t	2025-12-14 13:04:00.788	2025-12-14 13:04:00.788	53.00	шт	22	только уп
55006	3303	ПЕЧЕНЬЕ Коломенское 240гр Сахарное классическое	\N	\N	954.00	уп (10 шт)	1	150	t	2025-12-14 13:04:00.801	2025-12-14 13:04:00.801	95.00	шт	10	только уп
55007	3303	СУШКИ МИНИ Хлебный дом 180гр ваниль	\N	\N	1118.00	уп (18 шт)	1	61	t	2025-12-14 13:04:00.816	2025-12-14 13:04:00.816	62.00	шт	18	только уп
55008	3303	СУШКИ МИНИ Хлебный дом 180гр мак	\N	\N	1263.00	уп (18 шт)	1	23	t	2025-12-14 13:04:00.828	2025-12-14 13:04:00.828	70.00	шт	18	только уп
55009	3303	ТОРТ Шоколадница 180гр вафельный с карамелью	\N	\N	3841.00	уп (20 шт)	1	41	t	2025-12-14 13:04:00.868	2025-12-14 13:04:00.868	192.00	шт	20	только уп
55010	3303	ТОРТ Шоколадница 230гр вафельный с арахисом	\N	\N	2429.00	уп (12 шт)	1	22	t	2025-12-14 13:04:00.883	2025-12-14 13:04:00.883	202.00	шт	12	только уп
55011	3303	ТОРТ Шоколадница 230гр вафельный с миндалем	\N	\N	2636.00	уп (12 шт)	1	91	t	2025-12-14 13:04:00.895	2025-12-14 13:04:00.895	220.00	шт	12	только уп
55012	3303	ТОРТ Шоколадница 230гр вафельный с фундуком	\N	\N	2636.00	уп (12 шт)	1	72	t	2025-12-14 13:04:00.908	2025-12-14 13:04:00.908	220.00	шт	12	только уп
55013	3303	ТОРТ Шоколадница 250гр вафельный с орехами и изюмом	\N	\N	2829.00	уп (12 шт)	1	43	t	2025-12-14 13:04:00.919	2025-12-14 13:04:00.919	236.00	шт	12	только уп
55014	3303	ТОРТ Шоколадница 250гр вафельный трюфель	\N	\N	4278.00	уп (20 шт)	1	78	t	2025-12-14 13:04:00.956	2025-12-14 13:04:00.956	214.00	шт	20	только уп
55015	3303	ТОРТ Шоколадница 400гр вафельный с арахисом	\N	\N	2857.00	уп (9 шт)	1	35	t	2025-12-14 13:04:00.972	2025-12-14 13:04:00.972	317.00	шт	9	только уп
55016	3303	БАТОНЧИК 34гр Xrust Go арахис карамель	\N	\N	1932.00	уп (35 шт)	1	350	t	2025-12-14 13:04:00.986	2025-12-14 13:04:00.986	55.00	шт	35	только уп
55017	3303	КОНФЕТЫ Пралине 1кг в мол лазури	\N	\N	3505.00	уп (4 шт)	1	19	t	2025-12-14 13:04:01.006	2025-12-14 13:04:01.006	876.00	кг	4	только уп
55018	3303	КОНФЕТЫ Тоффи 1кг в шок лазури	\N	\N	3068.00	уп (4 шт)	1	44	t	2025-12-14 13:04:01.02	2025-12-14 13:04:01.02	767.00	кг	4	только уп
55019	3303	КОНФЕТЫ Тоффи 200гр в шок лазури	\N	\N	3726.00	уп (20 шт)	1	112	t	2025-12-14 13:04:01.035	2025-12-14 13:04:01.035	186.00	шт	20	только уп
55020	3303	КОНФЕТЫ Шоколадница вафельные 1кг кокос карамель в шок лазури	\N	\N	2674.00	уп (3 шт)	1	12	t	2025-12-14 13:04:01.056	2025-12-14 13:04:01.056	891.00	кг	3	только уп
55021	3303	КОНФЕТЫ Шоколадница вафельные 200гр кокос карамель в шок лазури	\N	\N	3075.00	уп (14 шт)	1	87	t	2025-12-14 13:04:01.07	2025-12-14 13:04:01.07	220.00	шт	14	только уп
55022	3303	КОНФЕТЫ Шоколадница желейные 200гр апельсин в шок лазури	\N	\N	3726.00	уп (20 шт)	1	38	t	2025-12-14 13:04:01.09	2025-12-14 13:04:01.09	186.00	шт	20	только уп
55023	3303	КОНФЕТЫ Шоколадный фадж помадные 200гр в шок лазури	\N	\N	3289.00	уп (20 шт)	1	49	t	2025-12-14 13:04:01.105	2025-12-14 13:04:01.105	164.00	шт	20	только уп
55024	3303	ВАФ ТРУБОЧКИ Сладонеж Сливочный крем 175гр	\N	\N	1601.00	уп (16 шт)	1	119	t	2025-12-14 13:04:01.118	2025-12-14 13:04:01.118	100.00	шт	16	только уп
55025	3303	ВАФ ТРУБОЧКИ Сладонеж Халва 175гр	\N	\N	1601.00	уп (16 шт)	1	188	t	2025-12-14 13:04:01.131	2025-12-14 13:04:01.131	100.00	шт	16	только уп
55026	3303	ВАФ ТРУБОЧКИ Сладонеж Шоколадный крем 175гр	\N	\N	1601.00	уп (16 шт)	1	97	t	2025-12-14 13:04:01.144	2025-12-14 13:04:01.144	100.00	шт	16	только уп
55027	3303	ВАФЛИ Ретро Сладонеж Лимонный вкус 300гр	\N	\N	2139.00	уп (12 шт)	1	153	t	2025-12-14 13:04:01.16	2025-12-14 13:04:01.16	178.00	шт	12	только уп
55028	3303	ВАФЛИ Ретро Сладонеж Шоколадный крем 300гр	\N	\N	2139.00	уп (12 шт)	1	103	t	2025-12-14 13:04:01.195	2025-12-14 13:04:01.195	178.00	шт	12	только уп
55029	3303	ВАФЛИ Сладонеж Bang bang 70гр ТОЛЬКО БЛОЧКАМИ	\N	\N	911.00	уп (12 шт)	1	12	t	2025-12-14 13:04:01.211	2025-12-14 13:04:01.211	76.00	шт	12	только уп
52667	3396	КОЛБАСА СПК с/к Коньячная 235гр	\N	\N	31671.00	шт	1	11	f	2025-12-07 13:19:16.667	2025-12-14 08:13:06.522	352.00	шт	90	поштучно
52666	3396	КОЛБАСА СПК с/к Колбаски ПодПивасики со вкусом горчицы  в/уп 100гр цена за шт	\N	\N	28980.00	шт	1	85	f	2025-12-07 13:19:16.654	2025-12-14 08:13:06.888	290.00	шт	100	поштучно
52676	3303	ВАФЛИ Коломенские 140гр Палочки с орешками	\N	\N	1780.00	уп (18 шт)	1	321	f	2025-12-07 13:19:16.793	2025-12-14 12:09:06.688	99.00	шт	18	только уп
52686	3303	ПЕЧЕНЬЕ Коломенское 120гр Овсяное хрустящее	\N	\N	1164.00	уп (22 шт)	1	54	f	2025-12-07 13:19:16.911	2025-12-14 12:09:06.688	53.00	шт	22	только уп
52688	3303	ПЕЧЕНЬЕ Коломенское 120гр Шоколадное	\N	\N	1164.00	уп (22 шт)	1	187	f	2025-12-07 13:19:16.934	2025-12-14 12:09:06.688	53.00	шт	22	только уп
55030	3303	ВАФЛИ Сладонеж Вареная сгущенка 270гр	\N	\N	1895.00	уп (16 шт)	1	184	t	2025-12-14 13:04:01.232	2025-12-14 13:04:01.232	118.00	шт	16	только уп
55031	3303	ВАФЛИ Сладонеж Горы шоколада 3кг	\N	\N	1563.00	уп (3 шт)	1	48	t	2025-12-14 13:04:01.247	2025-12-14 13:04:01.247	521.00	кг	3	только уп
55032	3303	ВАФЛИ Сладонеж Горы шоколада глазированные 3кг	\N	\N	2063.00	уп (3 шт)	1	36	t	2025-12-14 13:04:01.315	2025-12-14 13:04:01.315	688.00	кг	3	только уп
55033	3303	ВАФЛИ Сладонеж Ням-нямка вареная сгущенка 3,5кг	\N	\N	1505.00	уп (4 шт)	1	69	t	2025-12-14 13:04:01.339	2025-12-14 13:04:01.339	430.00	кг	4	только уп
55034	3303	ВАФЛИ Сладонеж Ням-нямка сливки 3,5кг	\N	\N	1505.00	уп (4 шт)	1	157	t	2025-12-14 13:04:01.416	2025-12-14 13:04:01.416	430.00	кг	4	только уп
55035	3303	ВАФЛИ Сладонеж Ням-нямка шоколад 3,5кг	\N	\N	1505.00	уп (4 шт)	1	73	t	2025-12-14 13:04:01.431	2025-12-14 13:04:01.431	430.00	кг	4	только уп
55036	3303	ВАФЛИ Сладонеж Ретро лимон 1/6кг 916	\N	\N	2912.00	уп (6 шт)	1	12	t	2025-12-14 13:04:01.443	2025-12-14 13:04:01.443	485.00	кг	6	только уп
55037	3303	ВАФЛИ Сладонеж Сливочный крем 270гр	\N	\N	1895.00	уп (16 шт)	1	185	t	2025-12-14 13:04:01.458	2025-12-14 13:04:01.458	118.00	шт	16	только уп
55038	3303	ВАФЛИ Сладонеж Шоколадный крем 270гр	\N	\N	1895.00	уп (16 шт)	1	348	t	2025-12-14 13:04:01.47	2025-12-14 13:04:01.47	118.00	шт	16	только уп
55039	3303	КАРАМЕЛЬ XXS фруковот-ягодной желейной начинкой 1кг ТМ Сладонеж	\N	\N	3341.00	уп (7 шт)	1	64	t	2025-12-14 13:04:01.483	2025-12-14 13:04:01.483	477.00	кг	7	только уп
55040	3303	КАРАМЕЛЬ вкус Апельсина 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	74	t	2025-12-14 13:04:01.501	2025-12-14 13:04:01.501	408.00	кг	7	только уп
55041	3303	КАРАМЕЛЬ вкус Груши 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	75	t	2025-12-14 13:04:01.52	2025-12-14 13:04:01.52	408.00	кг	7	только уп
55042	3303	КАРАМЕЛЬ вкус Мяты 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	69	t	2025-12-14 13:04:01.543	2025-12-14 13:04:01.543	408.00	кг	7	только уп
55043	3303	КАРАМЕЛЬ Вуаля вкус клубники 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	68	t	2025-12-14 13:04:01.582	2025-12-14 13:04:01.582	408.00	кг	7	только уп
55044	3303	КАРАМЕЛЬ Ива Дивная 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	76	t	2025-12-14 13:04:01.595	2025-12-14 13:04:01.595	408.00	кг	7	только уп
55045	3303	КАРАМЕЛЬ Красна Ягодка 1кг ТМ Сладонеж	\N	\N	2858.00	уп (7 шт)	1	75	t	2025-12-14 13:04:01.607	2025-12-14 13:04:01.607	408.00	кг	7	только уп
55046	3303	КОНФЕТЫ Батончики шоколад 5кг ТМ Сладонеж	\N	\N	3162.00	уп (5 шт)	1	9	t	2025-12-14 13:04:01.622	2025-12-14 13:04:01.622	633.00	кг	5	только уп
55047	3303	КОНФЕТЫ ваф Герои Сказок 400гр ТМ Сладонеж	\N	\N	2558.00	уп (8 шт)	1	37	t	2025-12-14 13:04:01.641	2025-12-14 13:04:01.641	320.00	шт	8	только уп
55048	3303	КОНФЕТЫ Мон Шер Ами со вкусом тирамису 500гр ТМ Сладонеж	\N	\N	5382.00	уп (8 шт)	1	74	t	2025-12-14 13:04:01.654	2025-12-14 13:04:01.654	673.00	шт	8	только уп
55049	3303	КОНФЕТЫ Мон Шер Ами со вкусом трюфеля 500гр ТМ Сладонеж	\N	\N	5382.00	уп (8 шт)	1	26	t	2025-12-14 13:04:01.666	2025-12-14 13:04:01.666	673.00	шт	8	только уп
55050	3303	КОНФЕТЫ Трюфель вкус сливок 2кг ТМ Сладонеж	\N	\N	1739.00	уп (2 шт)	1	6	t	2025-12-14 13:04:01.748	2025-12-14 13:04:01.748	869.00	кг	2	только уп
55051	3303	КРЕКЕР Сладонеж Квадрат с солью 5кг	\N	\N	1466.00	уп (5 шт)	1	80	t	2025-12-14 13:04:01.804	2025-12-14 13:04:01.804	293.00	кг	5	только уп
55052	3303	КРЕКЕР Сладонеж Квадрат с сыром 5кг	\N	\N	1466.00	уп (5 шт)	1	80	t	2025-12-14 13:04:01.849	2025-12-14 13:04:01.849	293.00	кг	5	только уп
55053	3303	КРЕКЕР Сладонеж Магрыбки 4кг	\N	\N	1173.00	уп (4 шт)	1	72	t	2025-12-14 13:04:01.873	2025-12-14 13:04:01.873	293.00	кг	4	только уп
55054	3303	КРЕКЕР Сладонеж Магсмайл с сыром 5кг	\N	\N	1466.00	уп (5 шт)	1	35	t	2025-12-14 13:04:01.924	2025-12-14 13:04:01.924	293.00	кг	5	только уп
55055	3303	ПЕЧЕНЬЕ Сладонеж К кофе вкус топл молока 310гр	\N	\N	2505.00	уп (18 шт)	1	11	t	2025-12-14 13:04:01.939	2025-12-14 13:04:01.939	139.00	шт	18	только уп
55056	3303	ПЕЧЕНЬЕ Сладонеж К кофе вкус шоколада 340гр	\N	\N	2650.00	уп (18 шт)	1	25	t	2025-12-14 13:04:01.953	2025-12-14 13:04:01.953	147.00	шт	18	только уп
55057	3303	ПЕЧЕНЬЕ Сладонеж Овсяное классическое 400гр	\N	\N	2098.00	уп (12 шт)	1	266	t	2025-12-14 13:04:02.004	2025-12-14 13:04:02.004	175.00	шт	12	только уп
55058	3303	ПЕЧЕНЬЕ Сладонеж Сгущенкино раздолье 175гр	\N	\N	1987.00	уп (24 шт)	1	199	t	2025-12-14 13:04:02.027	2025-12-14 13:04:02.027	83.00	шт	24	только уп
55059	3303	ПЕЧЕНЬЕ Сладонеж Советское детство 310гр	\N	\N	1838.00	уп (17 шт)	1	36	t	2025-12-14 13:04:02.05	2025-12-14 13:04:02.05	108.00	шт	17	только уп
55911	3327	ТОМАТНАЯ ПАСТА 70гр дойпак ТМ Пиканта	\N	\N	989.00	уп (20 шт)	1	200	t	2025-12-14 13:04:17.127	2025-12-14 13:04:17.127	49.00	шт	20	только уп
55913	3327	Вишневый компот 680гр ст/б ТМ Знаток	\N	\N	1932.00	уп (8 шт)	1	111	t	2025-12-14 13:04:17.164	2025-12-14 13:04:17.164	241.00	шт	8	только уп
55914	3327	ВИШНЯ в сладком сиропе с/к 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	3146.00	уп (8 шт)	1	132	t	2025-12-14 13:04:17.188	2025-12-14 13:04:17.188	393.00	шт	8	только уп
55915	3327	МАНГО дольки 425мл ж/б 1/12шт ТМ VITALAND	\N	\N	3160.00	уп (12 шт)	1	77	t	2025-12-14 13:04:17.206	2025-12-14 13:04:17.206	263.00	шт	12	только уп
55916	3327	ПЕРСИКИ половинки в сиропе 410гр ж/б ТМ Знаток	\N	\N	4112.00	уп (24 шт)	1	200	t	2025-12-14 13:04:17.216	2025-12-14 13:04:17.216	171.00	шт	24	только уп
55917	3327	Сливовый компот 680гр ст/б ТМ Знаток	\N	\N	1720.00	уп (8 шт)	1	24	t	2025-12-14 13:04:17.228	2025-12-14 13:04:17.228	215.00	шт	8	только уп
55918	3327	ФРУКТОВЫЙ коктейль 410гр ж/б ТМ Знаток	\N	\N	3947.00	уп (24 шт)	1	172	t	2025-12-14 13:04:17.254	2025-12-14 13:04:17.254	164.00	шт	24	только уп
55919	3327	МАСЛИНЫ отборные 280гр без косточки ж/б ТМ Знаток	\N	\N	2194.00	уп (12 шт)	1	127	t	2025-12-14 13:04:17.323	2025-12-14 13:04:17.323	183.00	шт	12	только уп
55060	3303	ПЕЧЕНЬЕ Сладонеж Топленкино раздолье 5кг	\N	\N	1788.00	уп (5 шт)	1	10	t	2025-12-14 13:04:02.077	2025-12-14 13:04:02.077	358.00	кг	5	только уп
55061	3303	ПЕЧЕНЬЕ Сладонеж Топленые берега 4,5кг	\N	\N	1609.00	уп (5 шт)	1	13	t	2025-12-14 13:04:02.122	2025-12-14 13:04:02.122	358.00	кг	5	только уп
55062	3303	ПЕЧЕНЬЕ СЭНДВИЧ Bang bang 95гр ТОЛЬКО БЛОЧКАМИ	\N	\N	1049.00	уп (12 шт)	1	222	t	2025-12-14 13:04:02.145	2025-12-14 13:04:02.145	87.00	шт	12	только уп
55063	3303	КОНФЕТЫ 150гр жевательный мармелад Активный мозг ТМ Победа	\N	\N	2732.00	уп (22 шт)	1	224	t	2025-12-14 13:04:02.176	2025-12-14 13:04:02.176	124.00	шт	22	только уп
55064	3303	КОНФЕТЫ 150гр жевательный мармелад без сахара Райские ягодки ТМ Победа	\N	\N	2318.00	уп (18 шт)	1	180	t	2025-12-14 13:04:02.19	2025-12-14 13:04:02.19	129.00	шт	18	только уп
55065	3303	КОНФЕТЫ 150гр жевательный мармелад Здоровые глаза ТМ Победа	\N	\N	2732.00	уп (22 шт)	1	110	t	2025-12-14 13:04:02.203	2025-12-14 13:04:02.203	124.00	шт	22	только уп
55066	3303	КОНФЕТЫ 150гр жевательный мармелад Злые языки ТМ Победа	\N	\N	1739.00	уп (14 шт)	1	253	t	2025-12-14 13:04:02.221	2025-12-14 13:04:02.221	124.00	шт	14	только уп
55067	3303	КОНФЕТЫ 150гр жевательный мармелад Иммунити ТМ Победа	\N	\N	2732.00	уп (22 шт)	1	220	t	2025-12-14 13:04:02.238	2025-12-14 13:04:02.238	124.00	шт	22	только уп
55068	3303	КОНФЕТЫ 75гр жевательный мармелад Злые языки ТМ Победа	\N	\N	1058.00	уп (20 шт)	1	154	t	2025-12-14 13:04:02.266	2025-12-14 13:04:02.266	53.00	шт	20	только уп
55069	3303	КОНФЕТЫ 75гр желейные Страшно симпатичные ТМ Победа	\N	\N	1058.00	уп (20 шт)	1	281	t	2025-12-14 13:04:02.278	2025-12-14 13:04:02.278	53.00	шт	20	только уп
55070	3303	КОНФЕТЫ Шмелькино Брюшко желейные микс 1кг ТМ Победа	\N	\N	1722.00	уп (3 шт)	1	35	t	2025-12-14 13:04:02.321	2025-12-14 13:04:02.321	574.00	шт	3	только уп
55071	3303	ШОКОЛАД  Горький 72% какао 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	6992.00	уп (20 шт)	1	200	t	2025-12-14 13:04:02.341	2025-12-14 13:04:02.341	350.00	шт	20	только уп
55072	3303	ШОКОЛАД  Горький без сахара 72% какао 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	6693.00	уп (20 шт)	1	175	t	2025-12-14 13:04:02.375	2025-12-14 13:04:02.375	335.00	шт	20	только уп
55073	3303	ШОКОЛАД  Горький без сахара 72% какао 25гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4048.00	уп (40 шт)	1	360	t	2025-12-14 13:04:02.398	2025-12-14 13:04:02.398	101.00	шт	40	только уп
55074	3303	ШОКОЛАД  Горький без сахара 72% какао 50гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	5658.00	уп (30 шт)	1	10	t	2025-12-14 13:04:02.41	2025-12-14 13:04:02.41	189.00	шт	30	только уп
55075	3303	ШОКОЛАД  Горький с кусочками апельсина 72% какао 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	6647.00	уп (20 шт)	1	91	t	2025-12-14 13:04:02.424	2025-12-14 13:04:02.424	332.00	шт	20	только уп
55076	3303	ШОКОЛАД Белый 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3841.00	уп (20 шт)	1	471	t	2025-12-14 13:04:02.443	2025-12-14 13:04:02.443	192.00	шт	20	только уп
55077	3303	ШОКОЛАД Белый с клубникой 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4025.00	уп (20 шт)	1	286	t	2025-12-14 13:04:02.458	2025-12-14 13:04:02.458	201.00	шт	20	только уп
55078	3303	ШОКОЛАД Мишки в лесу с молоком и вафельной крошкой 80гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	2631.00	уп (22 шт)	1	16	t	2025-12-14 13:04:02.475	2025-12-14 13:04:02.475	120.00	шт	22	только уп
55079	3303	ШОКОЛАД Молочный 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4071.00	уп (20 шт)	1	445	t	2025-12-14 13:04:02.49	2025-12-14 13:04:02.49	204.00	шт	20	только уп
55080	3303	ШОКОЛАД Молочный AMARE с начинкой со вкусом вареной сгущенки и карамельной крошкой 25гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	598.00	уп (20 шт)	1	220	t	2025-12-14 13:04:02.566	2025-12-14 13:04:02.566	30.00	шт	20	только уп
55081	3303	ШОКОЛАД Молочный AMARE с начинкой со вкусом топленого молока 25гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	506.00	уп (20 шт)	1	440	t	2025-12-14 13:04:02.58	2025-12-14 13:04:02.58	25.00	шт	20	только уп
55082	3303	ШОКОЛАД Молочный Dos Bros с хрустящей вафлей с молочной начинкой 37гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1058.00	уп (20 шт)	1	500	t	2025-12-14 13:04:02.606	2025-12-14 13:04:02.606	53.00	шт	20	только уп
55083	3303	ШОКОЛАД Молочный Dos Bros с хрустящей вафлей с молочной начинкой со вкусом карамели 37гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1058.00	уп (20 шт)	1	480	t	2025-12-14 13:04:02.62	2025-12-14 13:04:02.62	53.00	шт	20	только уп
55084	3303	ШОКОЛАД Молочный Dos Bros с хрустящей вафлей с молочной начинкой со вкусом кокоса 37гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1058.00	уп (20 шт)	1	460	t	2025-12-14 13:04:02.643	2025-12-14 13:04:02.643	53.00	шт	20	только уп
55085	3303	ШОКОЛАД Молочный Dos Bros с хрустящей вафлей с молочной начинкой со вкусом попкорна 37гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1058.00	уп (20 шт)	1	460	t	2025-12-14 13:04:02.67	2025-12-14 13:04:02.67	53.00	шт	20	только уп
55086	3303	ШОКОЛАД Молочный без сахара 36% 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	5152.00	уп (20 шт)	1	422	t	2025-12-14 13:04:02.709	2025-12-14 13:04:02.709	258.00	шт	20	только уп
55087	3303	ШОКОЛАД Молочный без сахара с цельным миндалем Чаржед 90гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3367.00	уп (12 шт)	1	120	t	2025-12-14 13:04:02.722	2025-12-14 13:04:02.722	281.00	шт	12	только уп
55088	3303	ШОКОЛАД молочный с лесным орехом 220гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	5794.00	уп (11 шт)	1	61	t	2025-12-14 13:04:02.739	2025-12-14 13:04:02.739	527.00	шт	11	только уп
55089	3303	ШОКОЛАД молочный с лесными орехами и изюмом 250гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	5532.00	уп (10 шт)	1	124	t	2025-12-14 13:04:02.773	2025-12-14 13:04:02.773	553.00	шт	10	только уп
55090	3303	ШОКОЛАД Молочный с начинкой и вафельной крошкой Мишки в лесу 30грТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	589.00	уп (16 шт)	1	2464	t	2025-12-14 13:04:02.786	2025-12-14 13:04:02.786	37.00	шт	16	только уп
55091	3303	Шоколад Молочный с начинкой миндальное пралине Птица счастья 30гр 1/16шт ТМ Победа 1594 ТОЛЬКО БЛОЧКАМИ	\N	\N	681.00	уп (16 шт)	1	2464	t	2025-12-14 13:04:02.8	2025-12-14 13:04:02.8	43.00	шт	16	только уп
55092	3303	ШОКОЛАД Молочный с цельным миндалем и морской солью 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3013.00	уп (10 шт)	1	26	t	2025-12-14 13:04:02.827	2025-12-14 13:04:02.827	301.00	шт	10	только уп
55093	3303	ШОКОЛАД Молочный с цельным фундуком  100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3105.00	уп (10 шт)	1	100	t	2025-12-14 13:04:02.839	2025-12-14 13:04:02.839	311.00	шт	10	только уп
55094	3303	ШОКОЛАД Молочный Сливочный 25гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	2254.00	уп (40 шт)	1	400	t	2025-12-14 13:04:02.857	2025-12-14 13:04:02.857	56.00	шт	40	только уп
55095	3303	ШОКОЛАД Молочный Сливочный с кусочками вишни 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3818.00	уп (20 шт)	1	121	t	2025-12-14 13:04:02.877	2025-12-14 13:04:02.877	191.00	шт	20	только уп
55096	3303	ШОКОЛАД Молочный Сливочный с кусочками вишни 220гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4870.00	уп (11 шт)	1	179	t	2025-12-14 13:04:02.891	2025-12-14 13:04:02.891	443.00	шт	11	только уп
55097	3303	ШОКОЛАД Пористый без сахара горький Шоколадный мусс 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3220.00	уп (16 шт)	1	306	t	2025-12-14 13:04:02.906	2025-12-14 13:04:02.906	201.00	шт	16	только уп
55098	3303	ШОКОЛАД Пористый без сахара молочный Шоколадный мусс 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	2962.00	уп (16 шт)	1	328	t	2025-12-14 13:04:02.921	2025-12-14 13:04:02.921	185.00	шт	16	только уп
55099	3303	ШОКОЛАД Пористый горький Победа вкуса 180гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4306.00	уп (8 шт)	1	143	t	2025-12-14 13:04:02.966	2025-12-14 13:04:02.966	538.00	шт	8	только уп
55100	3303	ШОКОЛАД Пористый молочный classik 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1288.00	уп (16 шт)	1	322	t	2025-12-14 13:04:02.98	2025-12-14 13:04:02.98	81.00	шт	16	только уп
55101	3303	ШОКОЛАД Пористый молочный Победа вкуса 180гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3275.00	уп (8 шт)	1	82	t	2025-12-14 13:04:03.02	2025-12-14 13:04:03.02	409.00	шт	8	только уп
55102	3303	ШОКОЛАД Пористый молочный Победа вкуса сливочный 180гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	2613.00	уп (8 шт)	1	81	t	2025-12-14 13:04:03.034	2025-12-14 13:04:03.034	327.00	шт	8	только уп
55103	3303	ШОКОЛАД Пористый молочный сливочный classik 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1288.00	уп (16 шт)	1	181	t	2025-12-14 13:04:03.046	2025-12-14 13:04:03.046	81.00	шт	16	только уп
55104	3303	ШОКОЛАД Пористый темный classik 65гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	1803.00	уп (16 шт)	1	90	t	2025-12-14 13:04:03.077	2025-12-14 13:04:03.077	113.00	шт	16	только уп
55105	3303	ШОКОЛАД Темный б/с 57% какао 25гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	2760.00	уп (40 шт)	1	200	t	2025-12-14 13:04:03.095	2025-12-14 13:04:03.095	69.00	шт	40	только уп
55106	3303	ШОКОЛАД Темный без сахара 57% какао 100гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	5704.00	уп (20 шт)	1	120	t	2025-12-14 13:04:03.127	2025-12-14 13:04:03.127	285.00	шт	20	только уп
55107	3303	ШОКОЛАД Темный без сахара 57% какао 50гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4658.00	уп (30 шт)	1	150	t	2025-12-14 13:04:03.147	2025-12-14 13:04:03.147	155.00	шт	30	только уп
55108	3303	ШОКОЛАД Темный без сахара с цельным миндалем Чаржед 90гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3629.00	уп (12 шт)	1	120	t	2025-12-14 13:04:03.161	2025-12-14 13:04:03.161	302.00	шт	12	только уп
55109	3303	ШОКОЛАД Темный без сахара с цельным фундуком Чаржед 90гр ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	3629.00	уп (12 шт)	1	120	t	2025-12-14 13:04:03.173	2025-12-14 13:04:03.173	302.00	шт	12	только уп
55110	3303	ШОКОЛАД Темный Десертный с коньяком 100гр  ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4807.00	уп (20 шт)	1	80	t	2025-12-14 13:04:03.187	2025-12-14 13:04:03.187	240.00	шт	20	только уп
55111	3303	ШОКОЛАД Темный Десертный с лесным орехом 100гр  ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	5658.00	уп (20 шт)	1	240	t	2025-12-14 13:04:03.198	2025-12-14 13:04:03.198	283.00	шт	20	только уп
55112	3303	ШОКОЛАД Темный Десертный с лесным орехом и изюмом 100гр  ТМ Победа ТОЛЬКО БЛОЧКАМИ	\N	\N	4738.00	уп (20 шт)	1	100	t	2025-12-14 13:04:03.211	2025-12-14 13:04:03.211	237.00	шт	20	только уп
55113	3303	КОЗИНАК арахисовый 170гр ТМ Тимоша	\N	\N	3622.00	уп (30 шт)	1	233	t	2025-12-14 13:04:03.223	2025-12-14 13:04:03.223	121.00	шт	30	только уп
55114	3303	КОЗИНАК кунжутный 150гр ТМ Тимоша	\N	\N	3754.00	уп (34 шт)	1	514	t	2025-12-14 13:04:03.237	2025-12-14 13:04:03.237	110.00	шт	34	только уп
55115	3303	КОЗИНАК МИКС арахис,кунжут,лен 150гр ТМ Тимоша	\N	\N	2346.00	уп (30 шт)	1	524	t	2025-12-14 13:04:03.25	2025-12-14 13:04:03.25	78.00	шт	30	только уп
55116	3303	КОЗИНАК подсолнечный 150гр ТМ Тимоша	\N	\N	1242.00	уп (24 шт)	1	484	t	2025-12-14 13:04:03.324	2025-12-14 13:04:03.324	52.00	шт	24	только уп
52788	3303	ХАЛВА подсолнечная 50г батончик ТМ Тимоша	\N	\N	2415.00	уп (84 шт)	1	462	f	2025-12-07 13:19:18.64	2025-12-14 08:13:00.237	29.00	шт	84	только уп
52779	3303	КОЗИНАК ТимМикс Сила орехов 40гр батончик ТМ Тимоша	\N	\N	3767.00	уп (84 шт)	1	483	f	2025-12-07 13:19:18.529	2025-12-14 08:13:01.531	45.00	шт	84	только уп
52778	3303	КОЗИНАК ТимМикс Заряд ягод 40гр батончик ТМ Тимоша	\N	\N	3767.00	уп (84 шт)	1	315	f	2025-12-07 13:19:18.517	2025-12-14 08:13:01.861	45.00	шт	84	только уп
52777	3303	КОЗИНАК подсолнечный 40гр батончик ТМ Тимоша	\N	\N	2190.00	уп (112 шт)	1	336	f	2025-12-07 13:19:18.443	2025-12-14 08:13:02.7	20.00	шт	112	только уп
52789	3303	ХАЛВА подсолнечная воздушная 200г ТМ Тимоша	\N	\N	1311.00	уп (12 шт)	1	284	f	2025-12-07 13:19:18.718	2025-12-14 12:09:06.688	109.00	шт	12	только уп
52801	3303	КОНФЕТЫ 200гр Курага в глазури 1/10шт ТМ Тимоша	\N	\N	1943.00	шт	1	117	f	2025-12-07 13:19:18.861	2025-12-14 12:09:06.688	194.00	шт	10	поштучно
55117	3303	РАХАТ-ЛУКУМ ассорти ароматный 200г 1/12шт Азовчанка ТМ Тимоша	\N	\N	980.00	уп (12 шт)	1	131	t	2025-12-14 13:04:03.351	2025-12-14 13:04:03.351	82.00	шт	12	только уп
55118	3303	РАХАТ-ЛУКУМ с арахисом 250г ТМ Тимоша	\N	\N	1270.00	уп (12 шт)	1	56	t	2025-12-14 13:04:03.362	2025-12-14 13:04:03.362	106.00	шт	12	только уп
55119	3303	РАХАТ-ЛУКУМ с орехом фундук 250г ТМ Тимоша	\N	\N	1794.00	уп (12 шт)	1	41	t	2025-12-14 13:04:03.373	2025-12-14 13:04:03.373	150.00	шт	12	только уп
55120	3303	ХАЛВА арахисовая 250г ТМ Тимоша	\N	\N	3703.00	уп (20 шт)	1	184	t	2025-12-14 13:04:03.415	2025-12-14 13:04:03.415	185.00	шт	20	только уп
55121	3303	ХАЛВА подсолнечная 250г с арахисом ТМ Тимоша	\N	\N	1598.00	уп (20 шт)	1	203	t	2025-12-14 13:04:03.443	2025-12-14 13:04:03.443	80.00	шт	20	только уп
55122	3303	ХАЛВА подсолнечная 250г с какао ТМ Тимоша	\N	\N	1817.00	уп (20 шт)	1	279	t	2025-12-14 13:04:03.469	2025-12-14 13:04:03.469	91.00	шт	20	только уп
55123	3303	ХАЛВА подсолнечная 250г ТМ Тимоша	\N	\N	1461.00	уп (20 шт)	1	414	t	2025-12-14 13:04:03.486	2025-12-14 13:04:03.486	73.00	шт	20	только уп
55124	3303	ХАЛВА подсолнечная воздушная 200г ТМ Тимоша	\N	\N	1311.00	уп (12 шт)	1	272	t	2025-12-14 13:04:03.497	2025-12-14 13:04:03.497	109.00	шт	12	только уп
55125	3303	ЩЕРБЕТ арахисовый 200г ТМ Тимоша	\N	\N	1343.00	уп (16 шт)	1	144	t	2025-12-14 13:04:03.513	2025-12-14 13:04:03.513	84.00	шт	16	только уп
55126	3303	ЩЕРБЕТ молочно-арахисовый 200г ТМ Тимоша	\N	\N	1343.00	уп (16 шт)	1	187	t	2025-12-14 13:04:03.529	2025-12-14 13:04:03.529	84.00	шт	16	только уп
55127	3303	ЩЕРБЕТ мраморный 200г ТМ Тимоша	\N	\N	1527.00	уп (16 шт)	1	155	t	2025-12-14 13:04:03.542	2025-12-14 13:04:03.542	95.00	шт	16	только уп
55128	3303	ЩЕРБЕТ с изюмом 250г ТМ Тимоша	\N	\N	1527.00	уп (16 шт)	1	80	t	2025-12-14 13:04:03.561	2025-12-14 13:04:03.561	95.00	шт	16	только уп
55129	3303	СОЛОМКА сладкая 100г 1/18шт ТМ Тимоша	\N	\N	642.00	уп (18 шт)	1	260	t	2025-12-14 13:04:03.572	2025-12-14 13:04:03.572	36.00	шт	18	только уп
55130	3303	СОЛОМКА соленая 100г 1/18шт ТМ Тимоша	\N	\N	642.00	уп (18 шт)	1	314	t	2025-12-14 13:04:03.582	2025-12-14 13:04:03.582	36.00	шт	18	только уп
55131	3303	СОЛОМКА соленая с луком 100г 1/18шт ТМ Тимоша	\N	\N	642.00	уп (18 шт)	1	131	t	2025-12-14 13:04:03.595	2025-12-14 13:04:03.595	36.00	шт	18	только уп
55132	3303	СУШКИ ванильные 200г 1/25шт ТМ Тимоша	\N	\N	1524.00	уп (25 шт)	1	300	t	2025-12-14 13:04:03.607	2025-12-14 13:04:03.607	61.00	шт	25	только уп
55133	3303	СУШКИ простые 200г 1/25шт ТМ Тимоша	\N	\N	1524.00	уп (25 шт)	1	248	t	2025-12-14 13:04:03.623	2025-12-14 13:04:03.623	61.00	шт	25	только уп
55134	3303	СУШКИ с маком 200г 1/25шт ТМ Тимоша	\N	\N	1524.00	уп (25 шт)	1	244	t	2025-12-14 13:04:03.635	2025-12-14 13:04:03.635	61.00	шт	25	только уп
55135	3303	КОНФЕТЫ 1кг молочные Тоффи Мягкая карамель в шоколаде с мармеладом из клюквы ТМ Победа	\N	\N	2226.00	шт	1	46	t	2025-12-14 13:04:03.664	2025-12-14 13:04:03.664	1113.00	шт	2	поштучно
55136	3303	КОНФЕТЫ 200гр Курага в глазури 1/10шт ТМ Тимоша	\N	\N	1943.00	шт	1	107	t	2025-12-14 13:04:03.676	2025-12-14 13:04:03.676	194.00	шт	10	поштучно
55137	3303	КОНФЕТЫ 200гр Чернослив в глазури 1/10шт ТМ Тимоша	\N	\N	1943.00	шт	1	117	t	2025-12-14 13:04:03.765	2025-12-14 13:04:03.765	194.00	шт	10	поштучно
55138	3303	КОНФЕТЫ 45гр вафельные Мишки в лесу с шоколадной начинкой в горьком шоколаде ТМ Победа	\N	\N	1748.00	шт	1	200	t	2025-12-14 13:04:03.816	2025-12-14 13:04:03.816	87.00	шт	20	поштучно
55139	3303	КОНФЕТЫ 45гр вафельные Птица счастья с начинкой из тертого миндаля в сливочном шоколаде ТМ Победа	\N	\N	1288.00	шт	1	200	t	2025-12-14 13:04:03.874	2025-12-14 13:04:03.874	64.00	шт	20	поштучно
55140	3303	КОНФЕТЫ Нива 250гр	\N	\N	329.00	шт	1	10	t	2025-12-14 13:04:03.887	2025-12-14 13:04:03.887	329.00	шт	1	поштучно
55141	3303	ПЕЧЕНЬЕ 120гр Чоко Пай	\N	\N	1702.00	шт	1	9	t	2025-12-14 13:04:03.899	2025-12-14 13:04:03.899	85.00	шт	20	поштучно
55142	3303	ПЕЧЕНЬЕ 180гр Чоко Пай	\N	\N	2061.00	шт	1	526	t	2025-12-14 13:04:03.909	2025-12-14 13:04:03.909	129.00	шт	16	поштучно
55143	3303	ПЕЧЕНЬЕ 360гр Чоко Пай	\N	\N	1987.00	шт	1	643	t	2025-12-14 13:04:03.92	2025-12-14 13:04:03.92	248.00	шт	8	поштучно
55144	3303	КОНФЕТЫ 130гр Трюфели с ромом ТМ Победа	\N	\N	8487.00	шт	1	60	t	2025-12-14 13:04:03.932	2025-12-14 13:04:03.932	283.00	шт	30	поштучно
55145	3303	КОНФЕТЫ 150гр Мишки в лесу с начинкой и вафельной крошкой ТМ Победа	\N	\N	5658.00	шт	1	181	t	2025-12-14 13:04:03.945	2025-12-14 13:04:03.945	283.00	шт	20	поштучно
55146	3303	КОНФЕТЫ 150гр Соната с лесным орехом и ореховым кремом ТМ Победа	\N	\N	5658.00	шт	1	177	t	2025-12-14 13:04:03.959	2025-12-14 13:04:03.959	283.00	шт	20	поштучно
55147	3303	КОНФЕТЫ 180гр Трюфели каппучино с кусочками печенья ТМ Победа	\N	\N	8984.00	шт	1	171	t	2025-12-14 13:04:03.97	2025-12-14 13:04:03.97	428.00	шт	21	поштучно
55148	3303	КОНФЕТЫ 180гр Трюфели шоколадные  с ликером Айриш крем посыпанные темным какао ТМ Победа	\N	\N	8984.00	шт	1	129	t	2025-12-14 13:04:03.986	2025-12-14 13:04:03.986	428.00	шт	21	поштучно
55149	3303	КОНФЕТЫ 180гр Трюфели шоколадные посыпанные темным какао ТМ Победа	\N	\N	8984.00	шт	1	104	t	2025-12-14 13:04:04.003	2025-12-14 13:04:04.003	428.00	шт	21	поштучно
55150	3303	КОНФЕТЫ 180гр Трюфели шоколадные с кусочками абрикоса посыпанные темным какао ТМ Победа	\N	\N	8984.00	шт	1	42	t	2025-12-14 13:04:04.017	2025-12-14 13:04:04.017	428.00	шт	21	поштучно
55151	3303	КОНФЕТЫ 250гр Соната с лесным орехом и ореховым кремом ТМ Победа	\N	\N	8280.00	шт	1	40	t	2025-12-14 13:04:04.028	2025-12-14 13:04:04.028	414.00	шт	20	поштучно
55152	3303	КОНФЕТЫ  Мишки в лесу с нач в горьк шок без сахара 1,5кг ТМ Победа	\N	\N	2382.00	уп (2 шт)	1	48	t	2025-12-14 13:04:04.039	2025-12-14 13:04:04.039	1588.00	кг	2	только уп
55153	3303	КОНФЕТЫ  Мишки в лесу с нач и ваф крошкой 2кг ТМ Победа	\N	\N	2098.00	уп (2 шт)	1	80	t	2025-12-14 13:04:04.059	2025-12-14 13:04:04.059	1049.00	кг	2	только уп
55154	3303	КОНФЕТЫ AMARE с начинкой со вкусом вареной сгущенки и карамельной крошкой 2кг ТМ Победа	\N	\N	2082.00	уп (2 шт)	1	54	t	2025-12-14 13:04:04.071	2025-12-14 13:04:04.071	1041.00	кг	2	только уп
55155	3303	КОНФЕТЫ AMARE с начинкой со вкусом топленого молока 2кг ТМ Победа	\N	\N	2082.00	уп (2 шт)	1	42	t	2025-12-14 13:04:04.082	2025-12-14 13:04:04.082	1041.00	кг	2	только уп
55156	3303	КОНФЕТЫ Соната в молочном шоколаде без сахара 1,5кг ТМ Победа	\N	\N	2122.00	уп (2 шт)	1	11	t	2025-12-14 13:04:04.094	2025-12-14 13:04:04.094	1415.00	кг	2	только уп
55157	3303	КОНФЕТЫ Соната с лесным орехом и ореховым кремом 2кг ТМ Победа	\N	\N	2617.00	уп (2 шт)	1	150	t	2025-12-14 13:04:04.105	2025-12-14 13:04:04.105	1309.00	кг	2	только уп
55158	3303	КОНФЕТЫ Трюфели каппучино с кусочками печенья 2кг ТМ Победа	\N	\N	3961.00	уп (2 шт)	1	76	t	2025-12-14 13:04:04.117	2025-12-14 13:04:04.117	1980.00	кг	2	только уп
55159	3303	КОНФЕТЫ Трюфели шоколадные  в темном какао 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	20	t	2025-12-14 13:04:04.13	2025-12-14 13:04:04.13	1770.00	кг	2	только уп
55160	3303	КОНФЕТЫ Трюфели шоколадные  в темном какао без сахара 2кг ТМ Победа	\N	\N	3961.00	уп (2 шт)	1	28	t	2025-12-14 13:04:04.143	2025-12-14 13:04:04.143	1980.00	кг	2	только уп
55161	3303	КОНФЕТЫ Трюфели шоколадные с коньяком без сахара 2кг ТМ Победа	\N	\N	3961.00	уп (2 шт)	1	30	t	2025-12-14 13:04:04.162	2025-12-14 13:04:04.162	1980.00	кг	2	только уп
55162	3303	КОНФЕТЫ Трюфели шоколадные с кусочками абрикоса 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	16	t	2025-12-14 13:04:04.174	2025-12-14 13:04:04.174	1770.00	кг	2	только уп
55163	3303	КОНФЕТЫ Трюфели шоколадные с ликером айриш крем 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	14	t	2025-12-14 13:04:04.185	2025-12-14 13:04:04.185	1770.00	кг	2	только уп
55164	3303	КОНФЕТЫ Трюфели шоколадные с ликером айриш крем без сахара 2кг ТМ Победа	\N	\N	3540.00	уп (2 шт)	1	20	t	2025-12-14 13:04:04.197	2025-12-14 13:04:04.197	1770.00	кг	2	только уп
55165	3303	КОНФЕТЫ Чаржед в горьком шоколаде без сахара 1,5кг ТМ Победа	\N	\N	2622.00	уп (2 шт)	1	71	t	2025-12-14 13:04:04.208	2025-12-14 13:04:04.208	1748.00	кг	2	только уп
55166	3303	КОНФЕТЫ Чаржед в молочном шоколаде без сахара 1,5кг ТМ Победа	\N	\N	2622.00	уп (2 шт)	1	69	t	2025-12-14 13:04:04.22	2025-12-14 13:04:04.22	1748.00	кг	2	только уп
55167	3303	ПАСТА арахисовая с кусочками арахиса 250гр пл/б ТМ Империя Соусов	\N	\N	1801.00	шт	1	113	t	2025-12-14 13:04:04.235	2025-12-14 13:04:04.235	300.00	шт	6	поштучно
55168	3310	Сало Богородское в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	243.00	шт	1	116	t	2025-12-14 13:04:04.247	2025-12-14 13:04:04.247	243.00	шт	\N	поштучно
55169	3310	Сало Домашнее в/уп (1шт ~ 0,3кг) ТМ"Богородский фермер"	\N	\N	247.00	шт	1	214	t	2025-12-14 13:04:04.265	2025-12-14 13:04:04.265	247.00	шт	\N	поштучно
55170	3314	ПРОДУКТ молокосодержащий Моцарелла полутвердый с змж Original Alti (1шт~2кг) батон	\N	\N	1426.00	шт	1	300	t	2025-12-14 13:04:04.276	2025-12-14 13:04:04.276	1426.00	шт	\N	поштучно
55171	3314	ПРОДУКТ полутвердый вес Российский (1шт~2,5кг) брус 50%  ТМ Простонародный	\N	\N	1509.00	шт	1	300	t	2025-12-14 13:04:04.289	2025-12-14 13:04:04.289	1509.00	шт	\N	поштучно
55172	3314	СЫР вес "Брест-Литовск Голландский" 45% полутвердый (1шт~3,5кг) брус ТМ Савушкин продукт	\N	\N	3361.00	шт	1	300	t	2025-12-14 13:04:04.302	2025-12-14 13:04:04.302	3361.00	шт	\N	поштучно
55173	3314	СЫР вес "Брест-Литовск Мраморный" 45% полутвердый (1шт~3,5кг) брус ТМ Брест-Литовск Беларусь	\N	\N	3341.00	шт	1	127	t	2025-12-14 13:04:04.313	2025-12-14 13:04:04.313	3341.00	шт	\N	поштучно
55174	3314	СЫР вес "Брест-Литовск Пошехонский" 45% полутвердый (1шт~3,5кг) брус ТМ Савушкин продукт	\N	\N	3361.00	шт	1	183	t	2025-12-14 13:04:04.328	2025-12-14 13:04:04.328	3361.00	шт	\N	поштучно
55175	3314	СЫР вес "Брест-Литовск Российский" 50% полутвердый (1шт~3,5кг) брус ТМ Савушкин продукт	\N	\N	3361.00	шт	1	300	t	2025-12-14 13:04:04.343	2025-12-14 13:04:04.343	3361.00	шт	\N	поштучно
55176	3314	СЫР вес "Брест-Литовск Финский" 45% полутвердый (1шт~3,5кг) брус ТМ Савушкин продукт	\N	\N	3361.00	шт	1	194	t	2025-12-14 13:04:04.362	2025-12-14 13:04:04.362	3361.00	шт	\N	поштучно
55177	3314	СЫР вес Белорусское Золото 45% (1шт~2кг) кубик ТМ Воложин Беларусь	\N	\N	1851.00	шт	1	150	t	2025-12-14 13:04:04.38	2025-12-14 13:04:04.38	1851.00	шт	\N	поштучно
55178	3314	СЫР вес Большой куш 20% (1шт~7кг) круг ТМ Радость вкуса	\N	\N	5772.00	шт	1	106	t	2025-12-14 13:04:04.399	2025-12-14 13:04:04.399	5772.00	шт	\N	поштучно
55179	3314	СЫР вес Большой куш 20% (1шт~8кг) брус ТМ Радость вкуса	\N	\N	6596.00	шт	1	300	t	2025-12-14 13:04:04.411	2025-12-14 13:04:04.411	6596.00	шт	\N	поштучно
52869	3314	СЫР Сочинский рассольный копченый 100гр СибБарс	\N	\N	9545.00	шт	1	16	f	2025-12-07 13:19:19.875	2025-12-14 08:12:57.65	191.00	шт	50	поштучно
52868	3314	СЫР Сочинский рассольный 100гр СибБарс	\N	\N	9545.00	шт	1	13	f	2025-12-07 13:19:19.865	2025-12-14 08:12:58.007	191.00	шт	50	поштучно
52867	3314	СЫР Сарыбалык рассольный копченый  100гр СибБарс	\N	\N	8798.00	шт	1	6	f	2025-12-07 13:19:19.854	2025-12-14 08:12:58.349	176.00	шт	50	поштучно
52865	3314	СЫР Колосок 100гр СПК	\N	\N	8453.00	шт	1	34	f	2025-12-07 13:19:19.826	2025-12-14 08:12:58.699	169.00	шт	50	поштучно
52862	3314	СЫР вес Моцарелла Пицца 40% полутвердый (1шт-1кг) ТМ Бонфесто Туровский МК	\N	\N	6854.00	кг	1	43	f	2025-12-07 13:19:19.763	2025-12-14 08:12:59.051	857.00	кг	8	поштучно
52857	3314	СЫР вес Белорусское Золото 45% (1шт~2кг) кубик ТМ Воложин Беларусь	\N	\N	1851.00	шт	1	177	f	2025-12-07 13:19:19.686	2025-12-14 12:09:06.688	1851.00	шт	1	поштучно
52876	3314	СЫР-БРУС SVEZA Моцарелла для пиццы 200гр 40%	\N	\N	2415.00	шт	1	35	f	2025-12-07 13:19:19.958	2025-12-14 12:09:06.688	241.00	шт	10	поштучно
55180	3314	СЫР вес Великокняжеский с ароматом топленого молока 46% (1шт~3,5кг) брус ТМ Брест-Литовск Беларусь	\N	\N	3341.00	шт	1	247	t	2025-12-14 13:04:04.434	2025-12-14 13:04:04.434	3341.00	шт	\N	поштучно
24974	2755	МАСЛО "Алтай" 0,9л подсолнечное рафинированное Высший сорт *	\N	\N	1988.00	уп (15 шт)	1	42	f	2025-11-10 01:55:18.447	2025-11-22 01:30:48.533	132.50	шт	15	\N
55181	3314	СЫР вес Витязь 45% (1шт~8кг) круг ТМ Радость вкуса	\N	\N	6762.00	шт	1	187	t	2025-12-14 13:04:04.446	2025-12-14 13:04:04.446	6762.00	шт	\N	поштучно
55182	3314	СЫР вес Гауда 45% (1шт~4,6кг) брус ТМ Молодея Беларусь	\N	\N	4258.00	шт	1	13	t	2025-12-14 13:04:04.462	2025-12-14 13:04:04.462	4258.00	шт	\N	поштучно
55183	3314	СЫР вес Голландский люкс 45% (1шт~1,7кг) шар ТМ Молодея Беларусь	\N	\N	1574.00	шт	1	156	t	2025-12-14 13:04:04.474	2025-12-14 13:04:04.474	1574.00	шт	\N	поштучно
55184	3314	Сыр вес Колбасный Брест-Литовск копченый плавленый 40% Савушкин продукт	\N	\N	4841.00	кг	1	14	t	2025-12-14 13:04:04.485	2025-12-14 13:04:04.485	788.00	кг	6	поштучно
55185	3314	СЫР вес Костромской 45% (1шт~8кг) круг ТМ Радость вкуса	\N	\N	7130.00	шт	1	14	t	2025-12-14 13:04:04.496	2025-12-14 13:04:04.496	7130.00	шт	\N	поштучно
55186	3314	СЫР вес Ламберт голд 45% (1шт~1,7кг) шар ТМ Молодея Беларусь	\N	\N	1574.00	шт	1	269	t	2025-12-14 13:04:04.507	2025-12-14 13:04:04.507	1574.00	шт	\N	поштучно
55187	3314	СЫР вес Легкий 20% (1шт~8кг) круг ТМ Радость вкуса	\N	\N	6762.00	шт	1	300	t	2025-12-14 13:04:04.577	2025-12-14 13:04:04.577	6762.00	шт	\N	поштучно
55188	3314	СЫР вес Львиное сердце 40% (1шт~8кг) круг ТМ Радость вкуса	\N	\N	7084.00	шт	1	300	t	2025-12-14 13:04:04.593	2025-12-14 13:04:04.593	7084.00	шт	\N	поштучно
55189	3314	СЫР вес Моцарелла 42% (1шт~3,5кг) брус ТМ La Paulina Аргентина	\N	\N	4005.00	шт	1	300	t	2025-12-14 13:04:04.604	2025-12-14 13:04:04.604	4005.00	шт	\N	поштучно
55190	3314	СЫР вес Мраморный 45% (1шт~8кг) круг ТМ Радость вкуса	\N	\N	7130.00	шт	1	300	t	2025-12-14 13:04:04.615	2025-12-14 13:04:04.615	7130.00	шт	\N	поштучно
55191	3314	СЫР вес Пармезан  45% (1шт~4кг) круг ТМ Excelsior	\N	\N	5046.00	шт	1	111	t	2025-12-14 13:04:04.627	2025-12-14 13:04:04.627	5046.00	шт	\N	поштучно
55192	3314	СЫР вес Пармезан 42% (1шт~2,5 кг) брус ТМ Ricrem	\N	\N	4396.00	шт	1	204	t	2025-12-14 13:04:04.638	2025-12-14 13:04:04.638	4396.00	шт	\N	поштучно
55193	3314	СЫР вес Пошехонский 45% (1шт~8кг) круг ТМ Радость вкуса	\N	\N	7130.00	шт	1	300	t	2025-12-14 13:04:04.651	2025-12-14 13:04:04.651	7130.00	шт	\N	поштучно
55194	3314	СЫР вес Российский 40% классический (1шт~8 кг) брус ТМ Радость вкуса*	\N	\N	6762.00	шт	1	300	t	2025-12-14 13:04:04.663	2025-12-14 13:04:04.663	6762.00	шт	\N	поштучно
55195	3314	СЫР вес Российский 40% классический (1шт~8 кг) круг ТМ Радость вкуса*	\N	\N	6670.00	шт	1	300	t	2025-12-14 13:04:04.678	2025-12-14 13:04:04.678	6670.00	шт	\N	поштучно
55196	3314	СЫР вес Российский элит 45% (1шт~4-6кг) брус ТМ Воложин Беларусь	\N	\N	19172.00	кг	1	121	t	2025-12-14 13:04:04.689	2025-12-14 13:04:04.689	926.00	кг	21	поштучно
55197	3314	СЫР вес Сливочный 45% (1шт~5 кг) брус ТМ Радость вкуса*	\N	\N	4399.00	шт	1	300	t	2025-12-14 13:04:04.707	2025-12-14 13:04:04.707	4399.00	шт	\N	поштучно
55198	3314	СЫР вес Сметанковый 35% (1шт~8 кг) круг ТМ Радость вкуса*	\N	\N	6762.00	шт	1	300	t	2025-12-14 13:04:04.737	2025-12-14 13:04:04.737	6762.00	шт	\N	поштучно
55199	3314	СЫР вес Сметанковый 50% (1шт~3,5кг) брус ТМ Брест-Литовск Беларусь	\N	\N	3361.00	шт	1	124	t	2025-12-14 13:04:04.763	2025-12-14 13:04:04.763	3361.00	шт	\N	поштучно
55200	3314	СЫР вес Топленое молочко 45% (1шт~8кг) круг ТМ Радость вкуса*	\N	\N	6946.00	шт	1	96	t	2025-12-14 13:04:04.775	2025-12-14 13:04:04.775	6946.00	шт	\N	поштучно
55201	3314	Сыр вес Эдам 45% (1шт~ 1,6кг) шар 1/10-12кгТМ Молодея Беларусь	\N	\N	1481.00	шт	1	76	t	2025-12-14 13:04:04.786	2025-12-14 13:04:04.786	1481.00	шт	\N	поштучно
55202	3314	Сыр Колбасный Брест-Литовск копченый 40% 300гр 1/12шт Савушкин продукт	\N	\N	3064.00	шт	1	53	t	2025-12-14 13:04:04.8	2025-12-14 13:04:04.8	255.00	шт	12	поштучно
55203	3314	СЫР Колосок копченый 100гр СПК	\N	\N	8453.00	шт	1	25	t	2025-12-14 13:04:04.814	2025-12-14 13:04:04.814	169.00	шт	50	поштучно
55204	3314	СЫР Спагетти Саргуль рассольный 100гр со вкусом Васаби СибБарс	\N	\N	8798.00	шт	1	20	t	2025-12-14 13:04:04.826	2025-12-14 13:04:04.826	176.00	шт	50	поштучно
55205	3314	СЫР фас Bonfesto Сулугуни 180гр 40% 1/6шт Туровский МК	\N	\N	1497.00	шт	1	104	t	2025-12-14 13:04:04.837	2025-12-14 13:04:04.837	250.00	шт	6	поштучно
55206	3314	СЫР-БРУС Ricrem 180гр Пармезан 42% твердый Аргентина	\N	\N	3303.00	шт	1	89	t	2025-12-14 13:04:04.849	2025-12-14 13:04:04.849	413.00	шт	8	поштучно
55207	3314	СЫР-БРУС SVEZA Моцарелла для пиццы 200гр 40%	\N	\N	2415.00	шт	1	116	t	2025-12-14 13:04:04.861	2025-12-14 13:04:04.861	241.00	шт	10	поштучно
55208	3314	СЫР-БРУС SVEZA Сулугуни 200гр 40%	\N	\N	2415.00	шт	1	43	t	2025-12-14 13:04:04.873	2025-12-14 13:04:04.873	241.00	шт	10	поштучно
55209	3314	СЫР-БРУС Брест-Литовск 200гр Гауда 45% полутвердый Беларусь	\N	\N	3013.00	шт	1	221	t	2025-12-14 13:04:04.887	2025-12-14 13:04:04.887	301.00	шт	10	поштучно
55210	3314	СЫР-БРУС Брест-Литовск 200гр Голландский 45% полутвердый Беларусь	\N	\N	3013.00	шт	1	300	t	2025-12-14 13:04:04.899	2025-12-14 13:04:04.899	301.00	шт	10	поштучно
55211	3314	СЫР-БРУС Брест-Литовск 200гр Классический 45% полутвердый Беларусь	\N	\N	3013.00	шт	1	300	t	2025-12-14 13:04:04.911	2025-12-14 13:04:04.911	301.00	шт	10	поштучно
52880	3314	СЫР-БРУС Брест-Литовск 200гр Классический 45% полутвердый Беларусь	\N	\N	3013.00	шт	1	300	f	2025-12-07 13:19:20.018	2025-12-14 12:09:06.688	301.00	шт	10	поштучно
55212	3314	СЫР-БРУС Брест-Литовск 200гр Легкий 35% полутвердый	\N	\N	3013.00	шт	1	210	t	2025-12-14 13:04:04.921	2025-12-14 13:04:04.921	301.00	шт	10	поштучно
55213	3314	СЫР-БРУС Брест-Литовск 200гр Российский 50% полутвердый	\N	\N	3013.00	шт	1	300	t	2025-12-14 13:04:04.933	2025-12-14 13:04:04.933	301.00	шт	10	поштучно
57003	3395	ОБЛЕПИХА садовая 300гр ТМ 4 Сезона	\N	\N	8252.00	шт	1	32	t	2025-12-14 13:04:36.437	2025-12-14 13:04:36.437	344.00	шт	24	поштучно
55214	3314	СЫР-БРУС Брест-Литовск 200гр с аром.топл.молока 45% полутвердый	\N	\N	3013.00	шт	1	238	t	2025-12-14 13:04:04.943	2025-12-14 13:04:04.943	301.00	шт	10	поштучно
55215	3314	СЫР-БРУС Брест-Литовск 200гр Сливочный 50% полутвердый	\N	\N	3013.00	шт	1	262	t	2025-12-14 13:04:04.959	2025-12-14 13:04:04.959	301.00	шт	10	поштучно
24982	2755	МАСЛО "Я Люблю готовить" 1л подсолнечное рафинированное	\N	\N	2550.00	уп (15 шт)	1	300	f	2025-11-10 01:55:18.836	2025-11-22 01:30:48.533	170.00	шт	15	\N
24988	2755	Сахар весовой 50кг	\N	\N	4335.00	уп (50 шт)	1	500	f	2025-11-10 01:55:19.105	2025-11-22 01:30:48.533	86.70	кг	50	\N
55216	3314	СЫР-БРУС Брест-Литовск 200гр Тильзитер 45% полутвердый	\N	\N	3013.00	шт	1	254	t	2025-12-14 13:04:04.975	2025-12-14 13:04:04.975	301.00	шт	10	поштучно
55217	3314	СЫР-БРУС Брест-Литовск 200гр Финский 45% полутвердый	\N	\N	3013.00	шт	1	215	t	2025-12-14 13:04:04.988	2025-12-14 13:04:04.988	301.00	шт	10	поштучно
55218	3314	СЫР-БРУС Брест-Литовск 200гр Чеддер 45% полутвердый Беларусь	\N	\N	3289.00	шт	1	182	t	2025-12-14 13:04:04.999	2025-12-14 13:04:04.999	329.00	шт	10	поштучно
55219	3314	СЫР-БРУС Король Севера 180гр  45% твердый	\N	\N	2944.00	шт	1	49	t	2025-12-14 13:04:05.013	2025-12-14 13:04:05.013	294.00	шт	10	поштучно
55220	3314	СЫР-НАРЕЗКА Брест-Литовский Голландский полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-14 13:04:05.024	2025-12-14 13:04:05.024	230.00	шт	8	поштучно
55221	3314	СЫР-НАРЕЗКА Брест-Литовский Классический полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-14 13:04:05.037	2025-12-14 13:04:05.037	230.00	шт	8	поштучно
55222	3314	СЫР-НАРЕЗКА Брест-Литовский Легкий полутвердый 130гр 35% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-14 13:04:05.051	2025-12-14 13:04:05.051	230.00	шт	8	поштучно
55223	3314	СЫР-НАРЕЗКА Брест-Литовский Российский полутвердый 130гр 50% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-14 13:04:05.068	2025-12-14 13:04:05.068	230.00	шт	8	поштучно
55224	3314	СЫР-НАРЕЗКА Брест-Литовский Сливочный полутвердый 150гр 50% Беларусь	\N	\N	1840.00	шт	1	300	t	2025-12-14 13:04:05.109	2025-12-14 13:04:05.109	230.00	шт	8	поштучно
55225	3314	СЫР-НАРЕЗКА Брест-Литовский Тильзитер полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	263	t	2025-12-14 13:04:05.121	2025-12-14 13:04:05.121	230.00	шт	8	поштучно
55226	3314	СЫР-НАРЕЗКА Брест-Литовский Финский полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	180	t	2025-12-14 13:04:05.134	2025-12-14 13:04:05.134	230.00	шт	8	поштучно
55227	3314	СЫР-НАРЕЗКА Брест-Литовский Чеддер полутвердый 130гр 45% Беларусь	\N	\N	1840.00	шт	1	249	t	2025-12-14 13:04:05.151	2025-12-14 13:04:05.151	230.00	шт	8	поштучно
55228	3314	СЫР брынза легкая Сербская 450гр 22% с сывороткой 515гр Млекара Сербия	\N	\N	2056.00	шт	1	119	t	2025-12-14 13:04:05.162	2025-12-14 13:04:05.162	343.00	шт	6	поштучно
55229	3314	СЫР брынза Сербская 200гр 40% с сывороткой 230гр Млекара Сербия	\N	\N	2553.00	шт	1	35	t	2025-12-14 13:04:05.175	2025-12-14 13:04:05.175	213.00	шт	12	поштучно
55230	3314	СЫР мягкий Bonfesto Cream Cheese 500гр 70% МК Туровский Беларусь	\N	\N	3208.00	шт	1	220	t	2025-12-14 13:04:05.198	2025-12-14 13:04:05.198	535.00	шт	6	поштучно
55231	3314	СЫР мягкий Bonfesto Cream Cheese воздушный вяленые томаты 125гр МК Туровский Беларусь	\N	\N	1224.00	шт	1	64	t	2025-12-14 13:04:05.244	2025-12-14 13:04:05.244	153.00	шт	8	поштучно
55232	3314	СЫР мягкий Bonfesto Cream Cheese воздушный сливочный 125гр МК Туровский Беларусь	\N	\N	1155.00	шт	1	159	t	2025-12-14 13:04:05.316	2025-12-14 13:04:05.316	144.00	шт	8	поштучно
55233	3314	СЫР мягкий Bonfesto Cream Cheese классик 400гр МК Туровский Беларусь	\N	\N	2498.00	шт	1	67	t	2025-12-14 13:04:05.339	2025-12-14 13:04:05.339	416.00	шт	6	поштучно
55234	3314	СЫР мягкий Bonfesto Cream Cheese креветки и зелень140гр МК Туровский Беларусь	\N	\N	1042.00	шт	1	201	t	2025-12-14 13:04:05.409	2025-12-14 13:04:05.409	174.00	шт	6	поштучно
55235	3314	СЫР мягкий Bonfesto Cream Cheese сливочный 140гр МК Туровский Беларусь	\N	\N	959.00	шт	1	176	t	2025-12-14 13:04:05.429	2025-12-14 13:04:05.429	160.00	шт	6	поштучно
55236	3314	СЫР мягкий Bonfesto Cream Cheese экстрамягкий 400гр МК Туровский Беларусь	\N	\N	2098.00	шт	1	70	t	2025-12-14 13:04:05.442	2025-12-14 13:04:05.442	350.00	шт	6	поштучно
55237	3314	СЫР мягкий Bonfesto Cream Cheeseзелень 140гр МК Туровский Беларусь	\N	\N	1035.00	шт	1	210	t	2025-12-14 13:04:05.459	2025-12-14 13:04:05.459	173.00	шт	6	поштучно
55238	3314	СЫР мягкий Bonfesto Mascarpone 500гр 78% МК Туровский Беларусь	\N	\N	4678.00	шт	1	59	t	2025-12-14 13:04:05.47	2025-12-14 13:04:05.47	780.00	шт	6	поштучно
55239	3314	СЫР мягкий Bonfesto Ricotta Light 250гр 40% МК Туровский Беларусь	\N	\N	1056.00	шт	1	12	t	2025-12-14 13:04:05.484	2025-12-14 13:04:05.484	176.00	шт	6	поштучно
55240	3314	СЫР мягкий Bonfesto Ricotta Light 500гр 40% МК Туровский Беларусь	\N	\N	1766.00	шт	1	83	t	2025-12-14 13:04:05.497	2025-12-14 13:04:05.497	294.00	шт	6	поштучно
55241	3314	СЫР мягкий Bonfesto Мascarpone 250гр 78% МК Туровский Беларусь	\N	\N	2201.00	шт	1	224	t	2025-12-14 13:04:05.51	2025-12-14 13:04:05.51	367.00	шт	6	поштучно
55242	3314	СЫР мягкий а ла Каймак 150гр 70% стаканчик Mlekara Сербия	\N	\N	2263.00	шт	1	192	t	2025-12-14 13:04:05.527	2025-12-14 13:04:05.527	189.00	шт	12	поштучно
55243	3314	СЫР Мягкий Хохланд Профессионал Фетакса 480гр в рассоле	\N	\N	2270.00	шт	1	116	t	2025-12-14 13:04:05.538	2025-12-14 13:04:05.538	378.00	шт	6	поштучно
55244	3314	СЫР творожный Cremette Professional 10 кг 65% ведро	\N	\N	8453.00	шт	1	286	t	2025-12-14 13:04:05.559	2025-12-14 13:04:05.559	8453.00	шт	1	поштучно
52922	3314	ДОП Сыр Президент плав "MY CHEESE ВАСАБИ" 51% 125гр ТМ Президент	\N	\N	938.00	шт	1	7	f	2025-12-07 13:19:20.753	2025-12-14 08:12:53.885	156.00	шт	6	поштучно
52915	3314	СЫР Творожный Cremette Professional 2,2 кг 65%  ведро	\N	\N	5899.00	шт	1	300	f	2025-12-07 13:19:20.666	2025-12-14 08:12:54.243	1966.00	шт	3	поштучно
55245	3314	СЫР творожный SVEZA Воздушный овощи гриль 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	151	t	2025-12-14 13:04:05.574	2025-12-14 13:04:05.574	167.00	шт	6	поштучно
55246	3314	СЫР творожный SVEZA Воздушный с авокадо 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	199	t	2025-12-14 13:04:05.589	2025-12-14 13:04:05.589	167.00	шт	6	поштучно
55247	3314	СЫР творожный SVEZA Воздушный с зеленью 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	243	t	2025-12-14 13:04:05.601	2025-12-14 13:04:05.601	167.00	шт	6	поштучно
55248	3314	СЫР творожный SVEZA Воздушный сливочный 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	300	t	2025-12-14 13:04:05.612	2025-12-14 13:04:05.612	167.00	шт	6	поштучно
55249	3314	СЫР творожный SVEZA легкий 35% 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	300	t	2025-12-14 13:04:05.627	2025-12-14 13:04:05.627	167.00	шт	6	поштучно
55250	3314	СЫР творожный SVEZA с зеленью 150гр ТМ Савушкин Беларусь	\N	\N	1000.00	шт	1	240	t	2025-12-14 13:04:05.642	2025-12-14 13:04:05.642	167.00	шт	6	поштучно
55251	3314	ДОП СЫР мягкий "Маскарпоне" Гальбани 250гр 80% Президент	\N	\N	2070.00	шт	1	6	t	2025-12-14 13:04:05.663	2025-12-14 13:04:05.663	345.00	шт	6	поштучно
55252	3314	ДОП СЫР Творожный Овощи на гриле 54% 140гр	\N	\N	1334.00	шт	1	6	t	2025-12-14 13:04:05.674	2025-12-14 13:04:05.674	167.00	шт	8	поштучно
55253	3314	ДОП СЫР Творожный Сливочный "Прованс" 65% 120гр	\N	\N	1398.00	шт	1	7	t	2025-12-14 13:04:05.71	2025-12-14 13:04:05.71	175.00	шт	8	поштучно
55254	3314	СЫР Белый город плавленный 120гр Сливочный ванна	\N	\N	1811.00	шт	1	6	t	2025-12-14 13:04:05.779	2025-12-14 13:04:05.779	121.00	шт	15	поштучно
55255	3314	СЫР Белый город плавленный 380гр Сливочный ванна	\N	\N	2944.00	шт	1	12	t	2025-12-14 13:04:05.8	2025-12-14 13:04:05.8	368.00	шт	8	поштучно
55256	3314	СЫР плавленный Президент 140гр Ассорти № 1 (2 с ветчиной/4 сливочных/2 с грибами) сегменты	\N	\N	2639.00	шт	1	371	t	2025-12-14 13:04:05.849	2025-12-14 13:04:05.849	176.00	шт	15	поштучно
55257	3314	СЫР плавленный Президент 140гр Ассорти №3 (2 сыр чедр/4 сливочных/2 сыр маасдам) сегменты	\N	\N	2639.00	шт	1	217	t	2025-12-14 13:04:05.873	2025-12-14 13:04:05.873	176.00	шт	15	поштучно
55258	3314	СЫР плавленный Президент 140гр Ветчина сегменты	\N	\N	2639.00	шт	1	217	t	2025-12-14 13:04:05.891	2025-12-14 13:04:05.891	176.00	шт	15	поштучно
55259	3314	СЫР плавленный Президент 140гр Грибы сегменты	\N	\N	2639.00	шт	1	64	t	2025-12-14 13:04:05.902	2025-12-14 13:04:05.902	176.00	шт	15	поштучно
55260	3314	СЫР плавленный Президент 140гр Мааздам сегменты	\N	\N	2639.00	шт	1	182	t	2025-12-14 13:04:05.916	2025-12-14 13:04:05.916	176.00	шт	15	поштучно
55261	3314	СЫР плавленный Президент 140гр Сливочный сегменты	\N	\N	2639.00	шт	1	493	t	2025-12-14 13:04:05.934	2025-12-14 13:04:05.934	176.00	шт	15	поштучно
55262	3314	СЫР плавленный Президент 140гр Чеддер сегменты	\N	\N	2070.00	шт	1	111	t	2025-12-14 13:04:05.95	2025-12-14 13:04:05.95	138.00	шт	15	поштучно
55263	3314	СЫР плавленный Президент 150гр Ветчина тост	\N	\N	2691.00	шт	1	115	t	2025-12-14 13:04:05.962	2025-12-14 13:04:05.962	179.00	шт	15	поштучно
55264	3314	СЫР плавленный Президент 150гр Чизбургер тост	\N	\N	2691.00	шт	1	33	t	2025-12-14 13:04:05.982	2025-12-14 13:04:05.982	179.00	шт	15	поштучно
55265	3314	СЫР плавленный Президент 200гр Ветчина ванна	\N	\N	3864.00	шт	1	238	t	2025-12-14 13:04:05.996	2025-12-14 13:04:05.996	241.00	шт	16	поштучно
55266	3314	СЫР плавленный Президент 200гр Грибы ванна	\N	\N	3864.00	шт	1	63	t	2025-12-14 13:04:06.015	2025-12-14 13:04:06.015	241.00	шт	16	поштучно
55267	3314	СЫР плавленный Президент 200гр Мааздам ванна	\N	\N	3864.00	шт	1	82	t	2025-12-14 13:04:06.035	2025-12-14 13:04:06.035	241.00	шт	16	поштучно
55268	3314	СЫР плавленный Президент 200гр Сливочный ванна	\N	\N	3864.00	шт	1	500	t	2025-12-14 13:04:06.05	2025-12-14 13:04:06.05	241.00	шт	16	поштучно
55269	3314	СЫР плавленный Президент 400гр Маасдам ванна	\N	\N	3496.00	шт	1	23	t	2025-12-14 13:04:06.073	2025-12-14 13:04:06.073	437.00	шт	8	поштучно
55270	3314	СЫР плавленный Президент 50гр Сливочный брусок	\N	\N	2898.00	шт	1	350	t	2025-12-14 13:04:06.086	2025-12-14 13:04:06.086	48.00	шт	60	поштучно
55271	3314	СЫР плавленный Хохланд Профессионал Бистро Чеддар 90 ломтиков/1,107кг	\N	\N	8142.00	шт	1	30	t	2025-12-14 13:04:06.118	2025-12-14 13:04:06.118	1357.00	шт	6	поштучно
55272	3314	СЫР плавленный Хохланд Профессионал Сливочный 400гр ванна	\N	\N	2436.00	шт	1	166	t	2025-12-14 13:04:06.13	2025-12-14 13:04:06.13	406.00	шт	6	поштучно
55273	3400	МАЙОНЕЗ EFKO FOOD classic универсальный 67% ведро 10000мл	\N	\N	2358.00	шт	1	200	t	2025-12-14 13:04:06.14	2025-12-14 13:04:06.14	2358.00	шт	1	поштучно
55274	3400	МАЙОНЕЗ EFKO FOOD Special для запекания 67% ведро 10000мл	\N	\N	2703.00	шт	1	200	t	2025-12-14 13:04:06.152	2025-12-14 13:04:06.152	2703.00	шт	1	поштучно
55275	3400	МАЙОНЕЗ Мастер Gurme Оливковый 50,5% дой-пак 700мл	\N	\N	2360.00	шт	1	76	t	2025-12-14 13:04:06.173	2025-12-14 13:04:06.173	197.00	шт	12	поштучно
55276	3400	МАЙОНЕЗ Мастер Gurme Провансаль 50,5% дой-пак 700мл	\N	\N	2360.00	шт	1	200	t	2025-12-14 13:04:06.188	2025-12-14 13:04:06.188	197.00	шт	12	поштучно
55277	3400	МАЙОНЕЗ Мечта хозяйки "Классический" 50.5% дой-пак 200мл	\N	\N	2291.00	шт	1	74	t	2025-12-14 13:04:06.2	2025-12-14 13:04:06.2	95.00	шт	24	поштучно
55278	3400	МАЙОНЕЗ Мечта хозяйки "Классический" 50.5% дой-пак 350мл	\N	\N	2944.00	шт	1	200	t	2025-12-14 13:04:06.211	2025-12-14 13:04:06.211	147.00	шт	20	поштучно
55279	3400	МАЙОНЕЗ Мечта хозяйки "Классический" 50.5% дой-пак 700мл	\N	\N	3312.00	шт	1	35	t	2025-12-14 13:04:06.224	2025-12-14 13:04:06.224	276.00	шт	12	поштучно
52979	3400	СОУС Пиканта дой-пак 280гр По грузински острый	\N	\N	2079.00	шт	1	21	f	2025-12-07 13:19:21.623	2025-12-14 08:12:51.725	130.00	шт	16	поштучно
52956	3400	МАЙОНЕЗ Слобода Провансаль 67% дой-пак 800мл	\N	\N	3353.00	шт	1	200	f	2025-12-07 13:19:21.233	2025-12-14 12:09:06.688	279.00	шт	12	поштучно
52334	3398	N2	\N	\N	15.00	шт	1	\N	f	2025-12-07 08:06:31.155	2025-12-07 08:12:48.73	15.00	шт	1	поштучно
52333	3398	N1	\N	\N	10.00	л	1	\N	f	2025-12-07 08:06:31.137	2025-12-07 08:12:50.967	10.00	л	1	поштучно
55280	3400	МАЙОНЕЗ Мечта хозяйки "На перепелинных яйцах" 50.5% дой-пак 700мл	\N	\N	3326.00	шт	1	70	t	2025-12-14 13:04:06.235	2025-12-14 13:04:06.235	277.00	шт	12	поштучно
55281	3400	МАЙОНЕЗ Мечта хозяйки "Оливковый" 50.5% дой-пак 200мл	\N	\N	2429.00	шт	1	79	t	2025-12-14 13:04:06.254	2025-12-14 13:04:06.254	101.00	шт	24	поштучно
55282	3400	МАЙОНЕЗ Мечта хозяйки "Оливковый" 50.5% дой-пак 350мл	\N	\N	3082.00	шт	1	7	t	2025-12-14 13:04:06.27	2025-12-14 13:04:06.27	154.00	шт	20	поштучно
55283	3400	МАЙОНЕЗ Мечта хозяйки "Оливковый" 50.5% дой-пак 700мл	\N	\N	3505.00	шт	1	41	t	2025-12-14 13:04:06.284	2025-12-14 13:04:06.284	292.00	шт	12	поштучно
55284	3400	МАЙОНЕЗ Мечта хозяйки "Провансаль" 67% дой-пак 200мл	\N	\N	2622.00	шт	1	43	t	2025-12-14 13:04:06.296	2025-12-14 13:04:06.296	109.00	шт	24	поштучно
55285	3400	МАЙОНЕЗ Мечта хозяйки "Провансаль" 67% дой-пак 700мл	\N	\N	3505.00	шт	1	80	t	2025-12-14 13:04:06.31	2025-12-14 13:04:06.31	292.00	шт	12	поштучно
55286	3400	МАЙОНЕЗ Слобода Оливковый 67% дой-пак 200мл	\N	\N	2214.00	шт	1	140	t	2025-12-14 13:04:06.323	2025-12-14 13:04:06.323	89.00	шт	25	поштучно
55287	3400	МАЙОНЕЗ Слобода Оливковый 67% дой-пак 400мл	\N	\N	3726.00	шт	1	200	t	2025-12-14 13:04:06.333	2025-12-14 13:04:06.333	155.00	шт	24	поштучно
55288	3400	МАЙОНЕЗ Слобода Оливковый 67% дой-пак 800мл	\N	\N	3533.00	шт	1	200	t	2025-12-14 13:04:06.346	2025-12-14 13:04:06.346	294.00	шт	12	поштучно
55289	3400	МАЙОНЕЗ Слобода Провансаль 67% дой-пак 200мл	\N	\N	2214.00	шт	1	156	t	2025-12-14 13:04:06.367	2025-12-14 13:04:06.367	89.00	шт	25	поштучно
55290	3400	МАЙОНЕЗ Слобода Провансаль 67% дой-пак 400мл	\N	\N	3726.00	шт	1	200	t	2025-12-14 13:04:06.379	2025-12-14 13:04:06.379	155.00	шт	24	поштучно
55291	3400	МАЙОНЕЗ Слобода Провансаль 67% дой-пак 800мл	\N	\N	3533.00	шт	1	200	t	2025-12-14 13:04:06.403	2025-12-14 13:04:06.403	294.00	шт	12	поштучно
55292	3400	МАЙОНЕЗ Слобода Провансаль Сметанный 67% дой-пак 800мл	\N	\N	3643.00	шт	1	200	t	2025-12-14 13:04:06.414	2025-12-14 13:04:06.414	304.00	шт	12	поштучно
55293	3400	МАЙОНЕЗ Я Люблю Готовить "Домашний" 55% дой-пак 200мл	\N	\N	2208.00	шт	1	45	t	2025-12-14 13:04:06.436	2025-12-14 13:04:06.436	92.00	шт	24	поштучно
55294	3400	МАЙОНЕЗ Я Люблю Готовить "Домашний" 55% дой-пак 390мл	\N	\N	3335.00	шт	1	136	t	2025-12-14 13:04:06.449	2025-12-14 13:04:06.449	167.00	шт	20	поштучно
55295	3400	МАЙОНЕЗ Я Люблю Готовить "Домашний" 55% дой-пак 670мл	\N	\N	3091.00	шт	1	132	t	2025-12-14 13:04:06.463	2025-12-14 13:04:06.463	258.00	шт	12	поштучно
55296	3400	МАЙОНЕЗ Я Люблю Готовить "На перепелинных яйцах" 67% дой-пак 390мл	\N	\N	3749.00	шт	1	83	t	2025-12-14 13:04:06.475	2025-12-14 13:04:06.475	187.00	шт	20	поштучно
55297	3400	МАЙОНЕЗ Я Люблю Готовить "Оливковый" 67% дой-пак 390мл	\N	\N	3749.00	шт	1	113	t	2025-12-14 13:04:06.494	2025-12-14 13:04:06.494	187.00	шт	20	поштучно
55298	3400	МАЙОНЕЗ Я Люблю Готовить Провансаль "Классический" 67% дой-пак 700мл	\N	\N	3616.00	шт	1	153	t	2025-12-14 13:04:06.506	2025-12-14 13:04:06.506	301.00	шт	12	поштучно
55299	3400	МАЙОНЕЗ Я Люблю Готовить Провансаль"Классический" 67% дой-пак 390мл	\N	\N	3611.00	шт	1	88	t	2025-12-14 13:04:06.517	2025-12-14 13:04:06.517	181.00	шт	20	поштучно
55300	3400	СОУС EFKO FOOD Professional сырный 35% 1кг	\N	\N	5877.00	шт	1	28	t	2025-12-14 13:04:06.585	2025-12-14 13:04:06.585	588.00	шт	10	поштучно
55301	3400	СОУС EFKO FOOD Professional цезарь 50,5% 1кг	\N	\N	5865.00	шт	1	14	t	2025-12-14 13:04:06.608	2025-12-14 13:04:06.608	587.00	шт	10	поштучно
55302	3400	СОУС EFKO FOOD Professional чесночный 35% 1кг	\N	\N	5877.00	шт	1	99	t	2025-12-14 13:04:06.62	2025-12-14 13:04:06.62	588.00	шт	10	поштучно
55303	3400	СОУС EFKO FOOD Special барбекю 1кг	\N	\N	5877.00	шт	1	200	t	2025-12-14 13:04:06.637	2025-12-14 13:04:06.637	588.00	шт	10	поштучно
55304	3400	СОУС EFKO FOOD Special горчичный 22% 1кг	\N	\N	6060.00	шт	1	32	t	2025-12-14 13:04:06.654	2025-12-14 13:04:06.654	606.00	шт	10	поштучно
55305	3400	СОУС EFKO FOOD Special грибной 25% 1кг	\N	\N	6060.00	шт	1	20	t	2025-12-14 13:04:06.665	2025-12-14 13:04:06.665	606.00	шт	10	поштучно
55306	3400	СОУС EFKO FOOD Special гриль 30% 1кг	\N	\N	6060.00	шт	1	30	t	2025-12-14 13:04:06.677	2025-12-14 13:04:06.677	606.00	шт	10	поштучно
55307	3400	СОУС EFKO FOOD Special кисло-сладкий 1кг	\N	\N	5877.00	шт	1	53	t	2025-12-14 13:04:06.69	2025-12-14 13:04:06.69	588.00	шт	10	поштучно
55308	3400	СОУС EFKO FOOD Special терияки 1кг	\N	\N	5877.00	шт	1	6	t	2025-12-14 13:04:06.711	2025-12-14 13:04:06.711	588.00	шт	10	поштучно
55309	3400	СОУС заправка Я Люблю готовить "Азиатский микс" 250мл	\N	\N	1380.00	шт	1	7	t	2025-12-14 13:04:06.727	2025-12-14 13:04:06.727	230.00	шт	6	поштучно
55310	3400	СОУС заправка Я Люблю готовить "Итальянский букет и вяленые томаты" 250мл	\N	\N	1359.00	шт	1	19	t	2025-12-14 13:04:06.749	2025-12-14 13:04:06.749	227.00	шт	6	поштучно
55311	3400	СОУС заправка Я Люблю готовить дой-пак "Пряный базилик и пармезан" 250мл	\N	\N	1359.00	шт	1	13	t	2025-12-14 13:04:06.774	2025-12-14 13:04:06.774	227.00	шт	6	поштучно
55312	3400	СОУС Пиканта дой-пак 280гр Краснодарский	\N	\N	1288.00	шт	1	96	t	2025-12-14 13:04:06.8	2025-12-14 13:04:06.8	81.00	шт	16	поштучно
55313	3400	СОУС Пиканта дой-пак 280гр Сладкий чили	\N	\N	2079.00	шт	1	16	t	2025-12-14 13:04:06.814	2025-12-14 13:04:06.814	130.00	шт	16	поштучно
55314	3400	СОУС Пиканта ст/банка 350гр Польпа томаты резаные	\N	\N	1228.00	шт	1	66	t	2025-12-14 13:04:06.829	2025-12-14 13:04:06.829	205.00	шт	6	поштучно
55315	3400	СОУС Пиканта ст/банка 350гр Томатный с базиликом	\N	\N	1228.00	шт	1	126	t	2025-12-14 13:04:06.841	2025-12-14 13:04:06.841	205.00	шт	6	поштучно
55316	3400	СОУС Пиканта ст/банка 350гр Томатный с луком и чесноком	\N	\N	1228.00	шт	1	152	t	2025-12-14 13:04:06.871	2025-12-14 13:04:06.871	205.00	шт	6	поштучно
55317	3400	СОУС Пиканта ст/банка 360гр Томатный с перцем чили Арраббьята	\N	\N	1228.00	шт	1	138	t	2025-12-14 13:04:06.885	2025-12-14 13:04:06.885	205.00	шт	6	поштучно
55318	3400	СОУС Слобода дой-пак 200гр Горчичный 60%	\N	\N	2001.00	шт	1	126	t	2025-12-14 13:04:06.896	2025-12-14 13:04:06.896	167.00	шт	12	поштучно
55319	3400	СОУС Слобода дой-пак 200гр Грибной 60%	\N	\N	2001.00	шт	1	200	t	2025-12-14 13:04:06.939	2025-12-14 13:04:06.939	167.00	шт	12	поштучно
55320	3400	СОУС Слобода дой-пак 220гр Сырный 60%	\N	\N	2001.00	шт	1	9	t	2025-12-14 13:04:06.965	2025-12-14 13:04:06.965	167.00	шт	12	поштучно
55321	3400	СОУС Слобода дой-пак 220гр Цезарь 60%	\N	\N	2001.00	шт	1	165	t	2025-12-14 13:04:06.991	2025-12-14 13:04:06.991	167.00	шт	12	поштучно
55322	3400	СОУС Слобода дой-пак 220гр Чесночный 60%	\N	\N	2001.00	шт	1	200	t	2025-12-14 13:04:07.003	2025-12-14 13:04:07.003	167.00	шт	12	поштучно
55323	3400	СОУС Соевый 500мл классический Мастер Шифу	\N	\N	1573.00	шт	1	113	t	2025-12-14 13:04:07.019	2025-12-14 13:04:07.019	131.00	шт	12	поштучно
55324	3400	СОУС Стебель Бамбука 1л Соевый Классик	\N	\N	1242.00	шт	1	92	t	2025-12-14 13:04:07.031	2025-12-14 13:04:07.031	207.00	шт	6	поштучно
55325	3400	СОУС Стебель Бамбука 280гр Вишнёвый с перцем чили	\N	\N	1118.00	шт	1	60	t	2025-12-14 13:04:07.043	2025-12-14 13:04:07.043	93.00	шт	12	поштучно
55326	3400	СОУС Стебель Бамбука 280гр к Барбекю	\N	\N	1118.00	шт	1	200	t	2025-12-14 13:04:07.069	2025-12-14 13:04:07.069	93.00	шт	12	поштучно
55327	3400	СОУС Стебель Бамбука 280гр к Мясу	\N	\N	1118.00	шт	1	177	t	2025-12-14 13:04:07.115	2025-12-14 13:04:07.115	93.00	шт	12	поштучно
55328	3400	СОУС Стебель Бамбука 280гр к Спагетти	\N	\N	1118.00	шт	1	11	t	2025-12-14 13:04:07.133	2025-12-14 13:04:07.133	93.00	шт	12	поштучно
55329	3400	СОУС Стебель Бамбука 280гр к Шашлыку	\N	\N	1118.00	шт	1	200	t	2025-12-14 13:04:07.143	2025-12-14 13:04:07.143	93.00	шт	12	поштучно
55330	3400	СОУС Стебель Бамбука 280гр Кисло сладкий	\N	\N	1118.00	шт	1	183	t	2025-12-14 13:04:07.184	2025-12-14 13:04:07.184	93.00	шт	12	поштучно
55331	3400	СОУС Стебель Бамбука 280гр Китайский	\N	\N	1118.00	шт	1	60	t	2025-12-14 13:04:07.22	2025-12-14 13:04:07.22	93.00	шт	12	поштучно
55332	3400	СОУС Стебель Бамбука 280гр Сладкий	\N	\N	1118.00	шт	1	17	t	2025-12-14 13:04:07.231	2025-12-14 13:04:07.231	93.00	шт	12	поштучно
55333	3400	СОУС Стебель Бамбука 280гр Соевый Классик	\N	\N	1118.00	шт	1	200	t	2025-12-14 13:04:07.242	2025-12-14 13:04:07.242	93.00	шт	12	поштучно
55334	3400	СОУС Стебель Бамбука 280гр Соевый Нежный	\N	\N	1118.00	шт	1	200	t	2025-12-14 13:04:07.323	2025-12-14 13:04:07.323	93.00	шт	12	поштучно
55335	3400	СОУС Стебель Бамбука 280гр Соевый Пикантный	\N	\N	1118.00	шт	1	200	t	2025-12-14 13:04:07.335	2025-12-14 13:04:07.335	93.00	шт	12	поштучно
55336	3400	СОУС Стебель Бамбука 280гр Соевый с перцем чили	\N	\N	1118.00	шт	1	120	t	2025-12-14 13:04:07.431	2025-12-14 13:04:07.431	93.00	шт	12	поштучно
55337	3400	СОУС Стебель Бамбука 280гр Соевый с чесноком	\N	\N	1118.00	шт	1	177	t	2025-12-14 13:04:07.442	2025-12-14 13:04:07.442	93.00	шт	12	поштучно
55338	3400	СОУС Стебель Бамбука 280гр Соевый Японский	\N	\N	1118.00	шт	1	200	t	2025-12-14 13:04:07.456	2025-12-14 13:04:07.456	93.00	шт	12	поштучно
55339	3400	СОУС Стебель Бамбука 280гр Цитрусовый с перцем чили	\N	\N	1118.00	шт	1	60	t	2025-12-14 13:04:07.476	2025-12-14 13:04:07.476	93.00	шт	12	поштучно
55340	3400	СОУС Стебель Бамбука 280гр Чили Острый	\N	\N	1118.00	шт	1	200	t	2025-12-14 13:04:07.494	2025-12-14 13:04:07.494	93.00	шт	12	поштучно
55341	3400	СОУС Стебель Бамбука 280гр Чили Супер	\N	\N	1118.00	шт	1	61	t	2025-12-14 13:04:07.507	2025-12-14 13:04:07.507	93.00	шт	12	поштучно
55342	3400	СОУС Стебель Бамбука 300гр дой-пак Чили Карри	\N	\N	911.00	шт	1	114	t	2025-12-14 13:04:07.52	2025-12-14 13:04:07.52	76.00	шт	12	поштучно
55343	3400	СОУС Стебель Бамбука 300гр дой-пак Чили Острый	\N	\N	911.00	шт	1	180	t	2025-12-14 13:04:07.531	2025-12-14 13:04:07.531	76.00	шт	12	поштучно
55344	3400	СОУС Стебель Бамбука 320гр ст/б Брусничный	\N	\N	1461.00	шт	1	94	t	2025-12-14 13:04:07.543	2025-12-14 13:04:07.543	146.00	шт	10	поштучно
55345	3400	СОУС Стебель Бамбука 330гр ст/б Терияки	\N	\N	1587.00	шт	1	115	t	2025-12-14 13:04:07.556	2025-12-14 13:04:07.556	159.00	шт	10	поштучно
55346	3400	СОУС Стебель Бамбука 380гр ст/б Гранатовый Наршараб	\N	\N	1863.00	шт	1	128	t	2025-12-14 13:04:07.599	2025-12-14 13:04:07.599	186.00	шт	10	поштучно
55347	3400	СОУС Тай Со 1л Соевый Классический	\N	\N	897.00	шт	1	60	t	2025-12-14 13:04:07.614	2025-12-14 13:04:07.614	150.00	шт	6	поштучно
55348	3400	СОУС Тай Со 460мл Соевый Классический	\N	\N	862.00	шт	1	6	t	2025-12-14 13:04:07.624	2025-12-14 13:04:07.624	144.00	шт	6	поштучно
55349	3400	СОУС томатный Я Люблю готовить ст/б "Базилик" 330гр	\N	\N	1394.00	шт	1	75	t	2025-12-14 13:04:07.638	2025-12-14 13:04:07.638	232.00	шт	6	поштучно
55350	3400	СОУС томатный Я Люблю готовить ст/б "Наполетана" 330гр	\N	\N	1394.00	шт	1	75	t	2025-12-14 13:04:07.671	2025-12-14 13:04:07.671	232.00	шт	6	поштучно
55351	3400	СОУС томатный Я Люблю готовить ст/б "Прованские травы" 330гр	\N	\N	1394.00	шт	1	75	t	2025-12-14 13:04:07.766	2025-12-14 13:04:07.766	232.00	шт	6	поштучно
55352	3400	СОУС томатный Я Люблю готовить ст/б "Томатный" 330гр	\N	\N	1394.00	шт	1	78	t	2025-12-14 13:04:07.813	2025-12-14 13:04:07.813	232.00	шт	6	поштучно
55353	3400	СОУС Хохланд Профессионал Blue Cheese пакет 500гр	\N	\N	3634.00	шт	1	28	t	2025-12-14 13:04:07.864	2025-12-14 13:04:07.864	363.00	шт	10	поштучно
55354	3400	СОУС Хохланд Профессионал Чеддер пакет 1кг	\N	\N	5354.00	шт	1	23	t	2025-12-14 13:04:07.877	2025-12-14 13:04:07.877	669.00	шт	8	поштучно
55355	3400	СОУС Хреновина 360гр ст/б ТМ Славянский Дар	\N	\N	824.00	шт	1	31	t	2025-12-14 13:04:07.889	2025-12-14 13:04:07.889	103.00	шт	8	поштучно
55356	3400	СОУС Чили "Острый" 200мл ТМ "Мастер Шифу"  Вьетнам	\N	\N	1352.00	шт	1	200	t	2025-12-14 13:04:07.899	2025-12-14 13:04:07.899	56.00	шт	24	поштучно
55357	3400	СОУС Чили кисло-сладкиц 200мл ТМ Мастер Шифу	\N	\N	1463.00	шт	1	200	t	2025-12-14 13:04:07.916	2025-12-14 13:04:07.916	61.00	шт	24	поштучно
55358	3400	КЕТЧУП EFKO FOOD Special томатный 1кг	\N	\N	3507.00	шт	1	200	t	2025-12-14 13:04:07.928	2025-12-14 13:04:07.928	351.00	шт	10	поштучно
25178	2755	ЧАЙ Ява Зелёный традиционный 100пак	\N	\N	3996.00	уп (18 шт)	1	53	f	2025-11-10 01:55:28.498	2025-11-22 01:30:48.533	222.00	шт	18	\N
25193	2755	КАША овсяная клубника 35гр ТМ Мастер Дак	\N	\N	660.00	уп (30 шт)	1	200	f	2025-11-10 01:55:29.274	2025-11-22 01:30:48.533	22.00	шт	30	\N
55359	3400	КЕТЧУП МАСТЕР GURME дой-пак 300гр Томатный Первая категория	\N	\N	2346.00	шт	1	89	t	2025-12-14 13:04:07.939	2025-12-14 13:04:07.939	98.00	шт	24	поштучно
55360	3400	КЕТЧУП МЕЧТА ХОЗЯЙКИ дой-пак 350гр Острый Чили	\N	\N	3505.00	шт	1	106	t	2025-12-14 13:04:07.952	2025-12-14 13:04:07.952	146.00	шт	24	поштучно
55361	3400	КЕТЧУП МЕЧТА ХОЗЯЙКИ дой-пак 350гр Шашлычный	\N	\N	3505.00	шт	1	44	t	2025-12-14 13:04:07.969	2025-12-14 13:04:07.969	146.00	шт	24	поштучно
55362	3400	КЕТЧУП Пиканта дой-пак 280гр Острый	\N	\N	2079.00	шт	1	192	t	2025-12-14 13:04:07.98	2025-12-14 13:04:07.98	130.00	шт	16	поштучно
55363	3400	КЕТЧУП Пиканта дой-пак 280гр Томатный	\N	\N	1564.00	шт	1	147	t	2025-12-14 13:04:08.007	2025-12-14 13:04:08.007	98.00	шт	16	поштучно
55364	3400	КЕТЧУП Пиканта дой-пак 280гр Шашлычный	\N	\N	1564.00	шт	1	154	t	2025-12-14 13:04:08.02	2025-12-14 13:04:08.02	98.00	шт	16	поштучно
55365	3400	КЕТЧУП Пиканта дой-пак 480гр Шашлычный	\N	\N	1973.00	шт	1	114	t	2025-12-14 13:04:08.048	2025-12-14 13:04:08.048	164.00	шт	12	поштучно
55366	3400	КЕТЧУП Слобода дой-пак 320гр Гриль Первая категория	\N	\N	3229.00	шт	1	117	t	2025-12-14 13:04:08.064	2025-12-14 13:04:08.064	135.00	шт	24	поштучно
55367	3400	КЕТЧУП Слобода дой-пак 320гр Лечо Высшая категория	\N	\N	3229.00	шт	1	168	t	2025-12-14 13:04:08.075	2025-12-14 13:04:08.075	135.00	шт	24	поштучно
55368	3400	КЕТЧУП Слобода дой-пак 320гр Острый  Высшая категория	\N	\N	3229.00	шт	1	43	t	2025-12-14 13:04:08.086	2025-12-14 13:04:08.086	135.00	шт	24	поштучно
55369	3400	КЕТЧУП Слобода дой-пак 320гр Томатный Высшая категория	\N	\N	3229.00	шт	1	200	t	2025-12-14 13:04:08.096	2025-12-14 13:04:08.096	135.00	шт	24	поштучно
55370	3400	КЕТЧУП Слобода дой-пак 320гр Чесночный Первая категория	\N	\N	3229.00	шт	1	126	t	2025-12-14 13:04:08.108	2025-12-14 13:04:08.108	135.00	шт	24	поштучно
55371	3400	КЕТЧУП Слобода дой-пак 320гр Чили Первая категория	\N	\N	3229.00	шт	1	120	t	2025-12-14 13:04:08.119	2025-12-14 13:04:08.119	135.00	шт	24	поштучно
55372	3400	КЕТЧУП Слобода дой-пак 320гр Шашлычный Высшая категория	\N	\N	3229.00	шт	1	96	t	2025-12-14 13:04:08.129	2025-12-14 13:04:08.129	135.00	шт	24	поштучно
55373	3400	КЕТЧУП Стебель Бамбука дой-пак 300гр Сладкий	\N	\N	2015.00	шт	1	200	t	2025-12-14 13:04:08.14	2025-12-14 13:04:08.14	84.00	шт	24	поштучно
55374	3400	КЕТЧУП Стебель Бамбука дой-пак 300гр Шашлычный	\N	\N	2015.00	шт	1	68	t	2025-12-14 13:04:08.157	2025-12-14 13:04:08.157	84.00	шт	24	поштучно
55375	3400	ГОРЧИЦА Мечта хозяйки Русская жгучая 130гр туба	\N	\N	1380.00	шт	1	178	t	2025-12-14 13:04:08.182	2025-12-14 13:04:08.182	69.00	шт	20	поштучно
55376	3317	Крупа Горох колотый вес 50кг Зерносервис	\N	\N	4002.00	уп (50 шт)	1	750	t	2025-12-14 13:04:08.202	2025-12-14 13:04:08.202	80.00	кг	50	только уп
55377	3317	Крупа Гречка вес 50кг Вишневый сад	\N	\N	3151.00	уп (50 шт)	1	8150	t	2025-12-14 13:04:08.214	2025-12-14 13:04:08.214	63.00	кг	50	только уп
55378	3317	Крупа Овсяная недробленая вес 50кг	\N	\N	3737.00	уп (50 шт)	1	50	t	2025-12-14 13:04:08.243	2025-12-14 13:04:08.243	75.00	кг	50	только уп
55379	3317	Крупа Рис круглый вес 1/25кг Краснодарский	\N	\N	3335.00	уп (25 шт)	1	875	t	2025-12-14 13:04:08.278	2025-12-14 13:04:08.278	133.00	кг	25	только уп
55380	3317	РИС 1 сорт 1/25кг Китай	\N	\N	3134.00	уп (25 шт)	1	950	t	2025-12-14 13:04:08.302	2025-12-14 13:04:08.302	125.00	кг	25	только уп
55381	3317	РИС 1 сорт 10кг Китай	\N	\N	1254.00	уп (10 шт)	1	400	t	2025-12-14 13:04:08.313	2025-12-14 13:04:08.313	125.00	кг	10	только уп
55382	3317	РИС круглозерный золотой мешок 1/25кг	\N	\N	2444.00	уп (25 шт)	1	6770	t	2025-12-14 13:04:08.324	2025-12-14 13:04:08.324	98.00	кг	25	только уп
55383	3405	СМЕСЬ КОМПОТНАЯ сухофрукты Экстра 1/10 кг	\N	\N	2185.00	уп (10 шт)	1	2500	t	2025-12-14 13:04:08.34	2025-12-14 13:04:08.34	218.00	кг	10	только уп
55384	3317	МАКАРОНЫ "Алмак" Паутинка №11 1/20кг	\N	\N	1490.00	уп (20 шт)	1	860	t	2025-12-14 13:04:08.353	2025-12-14 13:04:08.353	75.00	кг	20	только уп
55385	3317	МАКАРОНЫ "Алмак" Перья рифленые №15 1/18кг	\N	\N	1393.00	уп (18 шт)	1	2286	t	2025-12-14 13:04:08.364	2025-12-14 13:04:08.364	77.00	кг	18	только уп
55386	3317	МАКАРОНЫ "Алмак" Ракушка мелкая №8 1/20кг	\N	\N	1490.00	уп (20 шт)	1	2280	t	2025-12-14 13:04:08.374	2025-12-14 13:04:08.374	75.00	кг	20	только уп
55387	3317	МАКАРОНЫ "Алмак" Рожки №6 1/20кг	\N	\N	1548.00	уп (20 шт)	1	1920	t	2025-12-14 13:04:08.398	2025-12-14 13:04:08.398	77.00	кг	20	только уп
55388	3317	МАКАРОНЫ "Алмак" Рожки витые №4 1/16кг	\N	\N	1238.00	уп (16 шт)	1	2608	t	2025-12-14 13:04:08.409	2025-12-14 13:04:08.409	77.00	кг	16	только уп
55389	3317	МАКАРОНЫ "Алмак" Рожки гладкие №16 1/20кг	\N	\N	1548.00	уп (20 шт)	1	2420	t	2025-12-14 13:04:08.419	2025-12-14 13:04:08.419	77.00	кг	20	только уп
55390	3317	МАКАРОНЫ "Алмак" Рожки с гребешком №13/16кг	\N	\N	1238.00	уп (16 шт)	1	1712	t	2025-12-14 13:04:08.438	2025-12-14 13:04:08.438	77.00	кг	16	только уп
55391	3317	МАКАРОНЫ "Алмак" Сапожок мелкий  №2 1/16кг	\N	\N	1192.00	уп (16 шт)	1	1088	t	2025-12-14 13:04:08.461	2025-12-14 13:04:08.461	75.00	кг	16	только уп
55392	3317	МАКАРОНЫ "Алмак" спиралька №27 1/13кг	\N	\N	1006.00	уп (13 шт)	1	1222	t	2025-12-14 13:04:08.474	2025-12-14 13:04:08.474	77.00	кг	13	только уп
55393	3317	МАКАРОНЫ "Монте Бьянко" 2кг Рожок полубублик №202	\N	\N	803.00	уп (4 шт)	1	23	t	2025-12-14 13:04:08.488	2025-12-14 13:04:08.488	201.00	шт	4	только уп
55394	3398	ВОДОРОСЛИ морские жареные прессованные (Нори) 1уп-100листов 1/50шт ТМ Tamaki № 8 цена за 100 листов	\N	\N	115747.00	шт	1	500	t	2025-12-14 13:04:08.5	2025-12-14 13:04:08.5	2315.00	шт	50	поштучно
55395	3398	ВОДОРОСЛИ морские жареные прессованные (Нори) 1уп-100листов ТМ Tamaki №3	\N	\N	62100.00	шт	1	29	t	2025-12-14 13:04:08.579	2025-12-14 13:04:08.579	1725.00	шт	36	поштучно
55396	3398	ВОДОРОСЛИ морские жареные прессованные (Нори) 1уп-100листов ТМ Tamaki №5	\N	\N	79258.00	шт	1	402	t	2025-12-14 13:04:08.594	2025-12-14 13:04:08.594	1981.00	шт	40	поштучно
55397	3398	ИМБИРЬ розовый маринованный 1,4кг пакет ТМ Мастер Шифу	\N	\N	1828.00	шт	1	152	t	2025-12-14 13:04:08.624	2025-12-14 13:04:08.624	183.00	шт	10	поштучно
55398	3398	ИМБИРЬ розовый маринованный вес имбиря 1кг Китай	\N	\N	2116.00	шт	1	213	t	2025-12-14 13:04:08.648	2025-12-14 13:04:08.648	212.00	шт	10	поштучно
55399	3398	ЛАПША гречневая Соба 300гр ТМ ToDoFood	\N	\N	5888.00	шт	1	451	t	2025-12-14 13:04:08.659	2025-12-14 13:04:08.659	147.00	шт	40	поштучно
55400	3398	ЛАПША Удон пшеничная 300гр ТМ ToDoFood	\N	\N	4830.00	шт	1	400	t	2025-12-14 13:04:08.67	2025-12-14 13:04:08.67	121.00	шт	40	поштучно
55401	3398	ЛАПША яичная Рамен 300гр ТМ ToDoFood	\N	\N	5566.00	шт	1	500	t	2025-12-14 13:04:08.682	2025-12-14 13:04:08.682	139.00	шт	40	поштучно
55402	3398	МУКА темпурная 1кг 1/10шт ТМ ToDoFood	\N	\N	2438.00	шт	1	109	t	2025-12-14 13:04:08.692	2025-12-14 13:04:08.692	244.00	шт	10	поштучно
55403	3398	ПАСТА Том Ям 1кг	\N	\N	10640.00	шт	1	9	t	2025-12-14 13:04:08.703	2025-12-14 13:04:08.703	887.00	шт	12	поштучно
55404	3398	ПРИПРАВА Васаби сухая на основе хрена 1кг ТМ Tamaki Pro Light	\N	\N	5704.00	шт	1	66	t	2025-12-14 13:04:08.717	2025-12-14 13:04:08.717	570.00	шт	10	поштучно
55405	3398	ПРИПРАВА Васаби сухая на основе хрена 1кг ТМ ToDoFood	\N	\N	7337.00	шт	1	9	t	2025-12-14 13:04:08.728	2025-12-14 13:04:08.728	734.00	шт	10	поштучно
55406	3398	РИС среднезерный 25кг ТМ TAMAKI	\N	\N	4686.00	уп (25 шт)	1	500	t	2025-12-14 13:04:08.739	2025-12-14 13:04:08.739	187.00	кг	25	только уп
55407	3398	СМЕСЬ Оригинальная панировочная 1кг ТМ Tamaki	\N	\N	4292.00	шт	1	96	t	2025-12-14 13:04:08.772	2025-12-14 13:04:08.772	358.00	шт	12	поштучно
55408	3398	СМЕСЬ Темпура панировочная 1кг  ТМ Tamaki Pro	\N	\N	1932.00	шт	1	79	t	2025-12-14 13:04:08.784	2025-12-14 13:04:08.784	161.00	шт	12	поштучно
55409	3398	СОУС Кимчи 1,5л ТМ Tamaki Pro	\N	\N	3898.00	шт	1	10	t	2025-12-14 13:04:08.795	2025-12-14 13:04:08.795	650.00	шт	6	поштучно
55410	3398	СОУС Ореховый на основе растительных масел 1,5л ТМ Tamaki	\N	\N	7307.00	шт	1	60	t	2025-12-14 13:04:08.806	2025-12-14 13:04:08.806	1218.00	шт	6	поштучно
55411	3398	СОУС Соевый 0,25л ТМ ToDoFood	\N	\N	1449.00	шт	1	8	t	2025-12-14 13:04:08.817	2025-12-14 13:04:08.817	97.00	шт	15	поштучно
55412	3398	СОУС Соевый 1л ТМ Tamaki	\N	\N	2412.00	шт	1	36	t	2025-12-14 13:04:08.828	2025-12-14 13:04:08.828	268.00	шт	9	поштучно
55413	3398	СОУС Соевый 20л ТМ ToDoFood	\N	\N	2887.00	шт	1	33	t	2025-12-14 13:04:08.839	2025-12-14 13:04:08.839	2887.00	шт	1	поштучно
55414	3398	СОУС Терияки 0,25л ТМ ToDoFood	\N	\N	1880.00	шт	1	171	t	2025-12-14 13:04:08.865	2025-12-14 13:04:08.865	125.00	шт	15	поштучно
55415	3398	СОУС Терияки 1,5л ТМ Tamaki	\N	\N	3277.00	шт	1	229	t	2025-12-14 13:04:08.876	2025-12-14 13:04:08.876	546.00	шт	6	поштучно
55416	3398	СОУС Томатный для пиццы с травами 2,5кг ж/б Иран	\N	\N	5279.00	шт	1	120	t	2025-12-14 13:04:08.89	2025-12-14 13:04:08.89	880.00	шт	6	поштучно
55417	3398	СОУС Унаги 0,25л ТМ ToDoFood	\N	\N	2329.00	шт	1	42	t	2025-12-14 13:04:08.906	2025-12-14 13:04:08.906	155.00	шт	15	поштучно
55418	3398	СОУС Унаги 1,8л ТМ Tamaki	\N	\N	5796.00	шт	1	30	t	2025-12-14 13:04:08.92	2025-12-14 13:04:08.92	966.00	шт	6	поштучно
55419	3398	СОУС Унаги Про 1л ТМ ToDoFood	\N	\N	4048.00	шт	1	21	t	2025-12-14 13:04:08.948	2025-12-14 13:04:08.948	506.00	шт	8	поштучно
55420	3398	СОУС Устричный 1л ТМ Tamaki	\N	\N	4802.00	шт	1	40	t	2025-12-14 13:04:08.96	2025-12-14 13:04:08.96	534.00	шт	9	поштучно
55421	3398	СОУС Чили сладкий для курицы 1,5л ТМ Tamaki	\N	\N	3843.00	шт	1	457	t	2025-12-14 13:04:08.971	2025-12-14 13:04:08.971	641.00	шт	6	поштучно
55422	3398	СУХАРИ панировочные Панко 1кг 1/10шт ТМ ToDoFood	\N	\N	3070.00	шт	1	85	t	2025-12-14 13:04:08.982	2025-12-14 13:04:08.982	307.00	шт	10	поштучно
55423	3398	СУХАРИ панировочные Панко 1кг ТМ Tamaki	\N	\N	3323.00	шт	1	105	t	2025-12-14 13:04:08.992	2025-12-14 13:04:08.992	332.00	шт	10	поштучно
55424	3398	СУХАРИ панировочные Панко G'old 1кг ТМ Tamaki	\N	\N	3427.00	шт	1	35	t	2025-12-14 13:04:09.003	2025-12-14 13:04:09.003	343.00	шт	10	поштучно
55425	3398	СУХАРИ панировочные Панко Голд 1кг 1/10шт ТМ ToDoFood	\N	\N	3427.00	шт	1	40	t	2025-12-14 13:04:09.014	2025-12-14 13:04:09.014	343.00	шт	10	поштучно
55426	3398	УКСУС Рисовый 20л Premium ТМ Marukai канистра	\N	\N	2417.00	шт	1	67	t	2025-12-14 13:04:09.027	2025-12-14 13:04:09.027	2417.00	шт	1	поштучно
55427	3402	МЕД натуральный 1000гр Гречишный ПЭТ ТМ Гордость Алтая	\N	\N	3215.00	шт	1	22	t	2025-12-14 13:04:09.04	2025-12-14 13:04:09.04	536.00	шт	6	поштучно
55428	3402	МЕД натуральный 1000гр Цветочный ПЭТ ТМ Гордость Алтая	\N	\N	3478.00	шт	1	23	t	2025-12-14 13:04:09.057	2025-12-14 13:04:09.057	580.00	шт	6	поштучно
55429	3402	МЕД натуральный 250гр Алтайское Разнотравье ст/б ТМ Гордость Алтая	\N	\N	3036.00	шт	1	13	t	2025-12-14 13:04:09.07	2025-12-14 13:04:09.07	253.00	шт	12	поштучно
55430	3402	МЕД натуральный 250гр Горный ст/б ТМ Гордость Алтая	\N	\N	3547.00	шт	1	27	t	2025-12-14 13:04:09.081	2025-12-14 13:04:09.081	296.00	шт	12	поштучно
55431	3402	МЕД натуральный 250гр Луговой ст/б ТМ Гордость Алтая	\N	\N	3547.00	шт	1	67	t	2025-12-14 13:04:09.093	2025-12-14 13:04:09.093	296.00	шт	12	поштучно
55432	3402	МЕД натуральный 250гр Таежный ст/б ТМ Гордость Алтая	\N	\N	4181.00	шт	1	24	t	2025-12-14 13:04:09.105	2025-12-14 13:04:09.105	348.00	шт	12	поштучно
55433	3402	МЕД натуральный 500гр Луговой ПЭТ ТМ Гордость Алтая	\N	\N	5410.00	шт	1	98	t	2025-12-14 13:04:09.119	2025-12-14 13:04:09.119	451.00	шт	12	поштучно
55434	3401	МАСЛО  Живой янтарь 0,9л подсолнечное рафинированное*	\N	\N	2329.00	уп (15 шт)	1	300	t	2025-12-14 13:04:09.13	2025-12-14 13:04:09.13	155.00	шт	15	только уп
55435	3401	МАСЛО  Живой янтарь 1л подсолнечное рафинированное*	\N	\N	2570.00	уп (15 шт)	1	300	t	2025-12-14 13:04:09.143	2025-12-14 13:04:09.143	171.00	шт	15	только уп
55436	3401	МАСЛО  Краснодарское Отборное 0,9л подсолнечное рафинированное*	\N	\N	2329.00	уп (15 шт)	1	30	t	2025-12-14 13:04:09.154	2025-12-14 13:04:09.154	155.00	шт	15	только уп
55437	3401	МАСЛО  Краснодарское Отборное 1,8л подсолнечное рафинированное*	\N	\N	2084.00	уп (6 шт)	1	300	t	2025-12-14 13:04:09.173	2025-12-14 13:04:09.173	347.00	шт	6	только уп
55438	3401	МАСЛО  Южный полюс 0,9л подсолнечное рафинированное*	\N	\N	2329.00	уп (15 шт)	1	300	t	2025-12-14 13:04:09.194	2025-12-14 13:04:09.194	155.00	шт	15	только уп
55439	3401	МАСЛО  Южный полюс 1,8л подсолнечное рафинированное*	\N	\N	2084.00	уп (6 шт)	1	258	t	2025-12-14 13:04:09.204	2025-12-14 13:04:09.204	347.00	шт	6	только уп
55440	3401	МАСЛО "ALTERO Original" 0,81л подсолнечное рафинированное Высший сорт *	\N	\N	3312.00	уп (15 шт)	1	300	t	2025-12-14 13:04:09.217	2025-12-14 13:04:09.217	221.00	шт	15	только уп
55441	3401	МАСЛО "ALTERO" 0,81л подсолнечное рафинированное с оливковым маслом	\N	\N	3381.00	уп (15 шт)	1	300	t	2025-12-14 13:04:09.227	2025-12-14 13:04:09.227	225.00	шт	15	только уп
55442	3401	МАСЛО "Алтай" 0,9л подсолнечное рафинированное Высший сорт *	\N	\N	2286.00	уп (15 шт)	1	9	t	2025-12-14 13:04:09.238	2025-12-14 13:04:09.238	152.00	шт	15	только уп
55443	3401	МАСЛО "Алтай" 5л подсолнечное рафинированное Высший сорт *	\N	\N	2536.00	уп (3 шт)	1	79	t	2025-12-14 13:04:09.249	2025-12-14 13:04:09.249	845.00	шт	3	только уп
55444	3401	МАСЛО "Диво Алтая" 1л подсолнечное рафинированное Высший сорт *	\N	\N	2570.00	уп (15 шт)	1	9	t	2025-12-14 13:04:09.285	2025-12-14 13:04:09.285	171.00	шт	15	только уп
55445	3401	МАСЛО "Знаток" Pomace для тушения и жарки 0,25л ОЛИВКОВОЕ ст/б	\N	\N	5216.00	уп (12 шт)	1	99	t	2025-12-14 13:04:09.329	2025-12-14 13:04:09.329	435.00	шт	12	только уп
55446	3401	МАСЛО "Слобода" 1,8л подсолнечное рафинированное Высший сорт *	\N	\N	2318.00	уп (6 шт)	1	185	t	2025-12-14 13:04:09.341	2025-12-14 13:04:09.341	386.00	шт	6	только уп
55447	3401	МАСЛО "Слобода" 1л подсолнечное рафинированное Высший сорт *	\N	\N	3174.00	уп (15 шт)	1	300	t	2025-12-14 13:04:09.407	2025-12-14 13:04:09.407	212.00	шт	15	только уп
55448	3401	МАСЛО "Слобода" 1л подсолнечное рафинированное для жарки и фритюра	\N	\N	3157.00	уп (15 шт)	1	105	t	2025-12-14 13:04:09.422	2025-12-14 13:04:09.422	210.00	шт	15	только уп
55449	3401	МАСЛО "Слобода" 5л подсолнечное рафинированное Высший сорт *	\N	\N	3171.00	уп (3 шт)	1	89	t	2025-12-14 13:04:09.433	2025-12-14 13:04:09.433	1057.00	шт	3	только уп
55450	3401	МАСЛО "Я Люблю готовить" 1л подсолнечное рафинированное	\N	\N	2933.00	уп (15 шт)	1	300	t	2025-12-14 13:04:09.445	2025-12-14 13:04:09.445	195.00	шт	15	только уп
55451	3401	МАСЛО Аверино 1л подсолнечное рафинированное*	\N	\N	2579.00	уп (15 шт)	1	300	t	2025-12-14 13:04:09.456	2025-12-14 13:04:09.456	172.00	шт	15	только уп
55452	3401	МАСЛО Для фритюра подсолнечное EFKO FOOD Professional  5л	\N	\N	3277.00	уп (3 шт)	1	300	t	2025-12-14 13:04:09.47	2025-12-14 13:04:09.47	1093.00	шт	3	только уп
55453	3401	МАСЛО Для фритюра ЮЖНЫЙ ПОЛЮС 5л	\N	\N	2905.00	уп (3 шт)	1	6	t	2025-12-14 13:04:09.481	2025-12-14 13:04:09.481	968.00	шт	3	только уп
55454	3401	МАСЛО Умные рецепты Алтая 1л подсолнечное рафинированное*	\N	\N	2579.00	уп (15 шт)	1	300	t	2025-12-14 13:04:09.491	2025-12-14 13:04:09.491	172.00	шт	15	только уп
55455	3404	МУКА 1сорт Гост вес 50кг Союзмука	\N	\N	2875.00	уп (50 шт)	1	300	t	2025-12-14 13:04:09.506	2025-12-14 13:04:09.506	57.00	кг	50	только уп
55456	3404	МУКА 1сорт Гост вес 50кг ТМ Беляевская	\N	\N	2559.00	уп (50 шт)	1	200	t	2025-12-14 13:04:09.522	2025-12-14 13:04:09.522	51.00	кг	50	только уп
55457	3404	МУКА в/с Гост 2кг ТМ Беляевская	\N	\N	702.00	уп (6 шт)	1	222	t	2025-12-14 13:04:09.533	2025-12-14 13:04:09.533	117.00	шт	6	только уп
55458	3404	МУКА в/с Гост вес 10кг ТМ Беляевская	\N	\N	551.00	уп (10 шт)	1	500	t	2025-12-14 13:04:09.545	2025-12-14 13:04:09.545	55.00	кг	10	только уп
55459	3404	МУКА в/с ГОСТ вес 50кг Союзмука	\N	\N	3019.00	уп (50 шт)	1	500	t	2025-12-14 13:04:09.556	2025-12-14 13:04:09.556	60.00	кг	50	только уп
55460	3404	МУКА в/с Гост вес 50кг ТМ Беляевская	\N	\N	2576.00	уп (50 шт)	1	500	t	2025-12-14 13:04:09.567	2025-12-14 13:04:09.567	52.00	кг	50	только уп
55461	3404	МУКА в/с Гост вес 5кг ТМ Беляевская	\N	\N	279.00	уп (5 шт)	1	500	t	2025-12-14 13:04:09.578	2025-12-14 13:04:09.578	56.00	кг	5	только уп
55462	3404	МУКА ржаная Гост вес 45кг ТМ Беляевская	\N	\N	2220.00	уп (45 шт)	1	500	t	2025-12-14 13:04:09.612	2025-12-14 13:04:09.612	49.00	кг	45	только уп
55463	3404	Сахар весовой 50кг	\N	\N	4985.00	уп (50 шт)	1	500	t	2025-12-14 13:04:09.633	2025-12-14 13:04:09.633	100.00	кг	50	только уп
55464	3404	САХАР Рафинад Русский 1кг	\N	\N	2709.00	уп (20 шт)	1	41	t	2025-12-14 13:04:09.645	2025-12-14 13:04:09.645	135.00	шт	20	только уп
55465	3404	САХАР Рафинад Чайкофский 1кг	\N	\N	2709.00	уп (20 шт)	1	500	t	2025-12-14 13:04:09.657	2025-12-14 13:04:09.657	135.00	шт	20	только уп
55466	3404	САХАР Рафинад Чайкофский 250гр	\N	\N	1670.00	уп (40 шт)	1	500	t	2025-12-14 13:04:09.667	2025-12-14 13:04:09.667	42.00	шт	40	только уп
55467	3404	САХАР Рафинад Чайкофский 500гр	\N	\N	2737.00	уп (40 шт)	1	500	t	2025-12-14 13:04:09.765	2025-12-14 13:04:09.765	68.00	шт	40	только уп
55468	3404	СОЛЬ Усольская Экстра 1кг	\N	\N	931.00	уп (20 шт)	1	500	t	2025-12-14 13:04:09.796	2025-12-14 13:04:09.796	47.00	кг	20	только уп
55469	3305	МОЛОКО сухое цельное ГОСТ 26% ВЕС мешок 25кг	\N	\N	14289.00	уп (25 шт)	1	500	t	2025-12-14 13:04:09.807	2025-12-14 13:04:09.807	572.00	кг	25	только уп
55470	3305	СЛИВКИ сухие Фрима 500г	\N	\N	10074.00	шт	1	500	t	2025-12-14 13:04:09.818	2025-12-14 13:04:09.818	420.00	шт	24	поштучно
55471	3305	ЯИЧНЫЙ ПОРОШОК (меланж сухой) ГОСТ мешок 20кг	\N	\N	15065.00	уп (20 шт)	1	500	t	2025-12-14 13:04:09.829	2025-12-14 13:04:09.829	753.00	кг	20	только уп
25315	2755	ЛЕЧО по-болгарски 680гр ст/б Сыта-Загора	\N	\N	1272.00	уп (8 шт)	1	26	f	2025-11-10 01:55:35.834	2025-11-22 01:30:48.533	159.00	шт	8	\N
55472	3317	МАКАРОНЫ "Аньези" 250гр Паппарделле яичные №216	\N	\N	3229.00	шт	1	79	t	2025-12-14 13:04:09.845	2025-12-14 13:04:09.845	269.00	шт	12	поштучно
55473	3317	МАКАРОНЫ "Аньези" 500гр Перо рифленое №019	\N	\N	4057.00	шт	1	99	t	2025-12-14 13:04:09.871	2025-12-14 13:04:09.871	169.00	шт	24	поштучно
55474	3317	МАКАРОНЫ "Мальтальяти" 450гр Бантики №106	\N	\N	1975.00	шт	1	200	t	2025-12-14 13:04:09.882	2025-12-14 13:04:09.882	132.00	шт	15	поштучно
55475	3317	МАКАРОНЫ "Мальтальяти" 450гр Букатини №008	\N	\N	2254.00	шт	1	200	t	2025-12-14 13:04:09.912	2025-12-14 13:04:09.912	113.00	шт	20	поштучно
55476	3317	МАКАРОНЫ "Мальтальяти" 450гр Вермишель №090	\N	\N	2254.00	шт	1	200	t	2025-12-14 13:04:09.925	2025-12-14 13:04:09.925	113.00	шт	20	поштучно
55477	3317	МАКАРОНЫ "Мальтальяти" 450гр Лапша №010	\N	\N	2254.00	шт	1	200	t	2025-12-14 13:04:09.937	2025-12-14 13:04:09.937	113.00	шт	20	поштучно
55478	3317	МАКАРОНЫ "Мальтальяти" 450гр Перо рифленое №074	\N	\N	2254.00	шт	1	200	t	2025-12-14 13:04:09.948	2025-12-14 13:04:09.948	113.00	шт	20	поштучно
55479	3317	МАКАРОНЫ "Мальтальяти" 450гр Радиаторе №079	\N	\N	1690.00	шт	1	200	t	2025-12-14 13:04:09.961	2025-12-14 13:04:09.961	113.00	шт	15	поштучно
55480	3317	МАКАРОНЫ "Мальтальяти" 450гр Ракушка мелкая №040	\N	\N	2254.00	шт	1	200	t	2025-12-14 13:04:09.973	2025-12-14 13:04:09.973	113.00	шт	20	поштучно
55481	3317	МАКАРОНЫ "Мальтальяти" 450гр Рожки №038	\N	\N	2254.00	шт	1	200	t	2025-12-14 13:04:09.989	2025-12-14 13:04:09.989	113.00	шт	20	поштучно
55482	3317	МАКАРОНЫ "Мальтальяти" 450гр Рожок витой №069	\N	\N	2254.00	шт	1	200	t	2025-12-14 13:04:10.005	2025-12-14 13:04:10.005	113.00	шт	20	поштучно
55483	3317	МАКАРОНЫ "Мальтальяти" 450гр Рожок крупный №096	\N	\N	2254.00	шт	1	146	t	2025-12-14 13:04:10.021	2025-12-14 13:04:10.021	113.00	шт	20	поштучно
55484	3317	МАКАРОНЫ "Мальтальяти" 450гр Спагетти классические №004	\N	\N	2705.00	шт	1	200	t	2025-12-14 13:04:10.035	2025-12-14 13:04:10.035	113.00	шт	24	поштучно
55485	3317	МАКАРОНЫ "Мальтальяти" 450гр Спагетти тонкие №002	\N	\N	2705.00	шт	1	200	t	2025-12-14 13:04:10.06	2025-12-14 13:04:10.06	113.00	шт	24	поштучно
55486	3317	МАКАРОНЫ "Мальтальяти" 450гр Спираль №078	\N	\N	2254.00	шт	1	200	t	2025-12-14 13:04:10.072	2025-12-14 13:04:10.072	113.00	шт	20	поштучно
55487	3317	МАКАРОНЫ "Мальтальяти" 450гр Спираль лигурийская №102	\N	\N	2254.00	шт	1	200	t	2025-12-14 13:04:10.084	2025-12-14 13:04:10.084	113.00	шт	20	поштучно
55488	3317	МАКАРОНЫ "Мальтальяти" 450гр Фузилоне №098	\N	\N	1690.00	шт	1	200	t	2025-12-14 13:04:10.094	2025-12-14 13:04:10.094	113.00	шт	15	поштучно
55489	3317	МАКАРОНЫ "Мальтальяти" 500гр Лазанья №087	\N	\N	4085.00	шт	1	200	t	2025-12-14 13:04:10.104	2025-12-14 13:04:10.104	340.00	шт	12	поштучно
55490	3317	МАКАРОНЫ "Паста Зара" 500гр Бантики №31	\N	\N	2760.00	шт	1	200	t	2025-12-14 13:04:10.138	2025-12-14 13:04:10.138	138.00	шт	20	поштучно
55491	3317	МАКАРОНЫ "Паста Зара" 500гр Вермишель №80	\N	\N	2461.00	шт	1	200	t	2025-12-14 13:04:10.15	2025-12-14 13:04:10.15	123.00	шт	20	поштучно
55492	3317	МАКАРОНЫ "Паста Зара" 500гр Перо №46	\N	\N	2461.00	шт	1	200	t	2025-12-14 13:04:10.163	2025-12-14 13:04:10.163	123.00	шт	20	поштучно
55493	3317	МАКАРОНЫ "Паста Зара" 500гр Перо рифленое №49	\N	\N	2461.00	шт	1	144	t	2025-12-14 13:04:10.173	2025-12-14 13:04:10.173	123.00	шт	20	поштучно
55494	3317	МАКАРОНЫ "Паста Зара" 500гр Рожки №27	\N	\N	2461.00	шт	1	200	t	2025-12-14 13:04:10.183	2025-12-14 13:04:10.183	123.00	шт	20	поштучно
55495	3317	МАКАРОНЫ "Паста Зара" 500гр Рожок витой №61	\N	\N	2461.00	шт	1	200	t	2025-12-14 13:04:10.196	2025-12-14 13:04:10.196	123.00	шт	20	поштучно
55496	3317	МАКАРОНЫ "Паста Зара" 500гр Спагетти классические №4	\N	\N	2461.00	шт	1	200	t	2025-12-14 13:04:10.212	2025-12-14 13:04:10.212	123.00	шт	20	поштучно
55497	3317	МАКАРОНЫ "Паста Зара" 500гр Спагетти тонкие №1	\N	\N	2461.00	шт	1	200	t	2025-12-14 13:04:10.223	2025-12-14 13:04:10.223	123.00	шт	20	поштучно
55498	3317	МАКАРОНЫ "Паста Зара" 500гр Спираль №57	\N	\N	2461.00	шт	1	200	t	2025-12-14 13:04:10.234	2025-12-14 13:04:10.234	123.00	шт	20	поштучно
55499	3317	МАКАРОНЫ "Паста Зара" 500гр Трубка витая №45	\N	\N	2461.00	шт	1	200	t	2025-12-14 13:04:10.246	2025-12-14 13:04:10.246	123.00	шт	20	поштучно
55500	3317	МАКАРОНЫ "Шебекинские" 350гр Бабочки №400	\N	\N	2015.00	шт	1	200	t	2025-12-14 13:04:10.258	2025-12-14 13:04:10.258	101.00	шт	20	поштучно
55501	3317	МАКАРОНЫ "Шебекинские" 350гр Букатини №007	\N	\N	3494.00	шт	1	200	t	2025-12-14 13:04:10.268	2025-12-14 13:04:10.268	97.00	шт	36	поштучно
55502	3317	МАКАРОНЫ "Шебекинские" 350гр Лагман-лапша №517	\N	\N	2718.00	шт	1	200	t	2025-12-14 13:04:10.28	2025-12-14 13:04:10.28	97.00	шт	28	поштучно
55503	3317	МАКАРОНЫ "Шебекинские" 400гр Зити №708	\N	\N	1708.00	шт	1	200	t	2025-12-14 13:04:10.291	2025-12-14 13:04:10.291	114.00	шт	15	поштучно
55504	3317	МАКАРОНЫ "Шебекинские" 450гр Вермишелька брикет (новая упаковка) №111	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.304	2025-12-14 13:04:10.304	97.00	шт	20	поштучно
55505	3317	МАКАРОНЫ "Шебекинские" 450гр Витой рожок №388	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.319	2025-12-14 13:04:10.319	97.00	шт	20	поштучно
55506	3317	МАКАРОНЫ "Шебекинские" 450гр Звездочки №190	\N	\N	1932.00	шт	1	8	t	2025-12-14 13:04:10.331	2025-12-14 13:04:10.331	97.00	шт	20	поштучно
55507	3317	МАКАРОНЫ "Шебекинские" 450гр лапша лингвини №011	\N	\N	2705.00	шт	1	200	t	2025-12-14 13:04:10.343	2025-12-14 13:04:10.343	97.00	шт	28	поштучно
55508	3317	МАКАРОНЫ "Шебекинские" 450гр Перышки №223	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.36	2025-12-14 13:04:10.36	97.00	шт	20	поштучно
57004	3395	СЛИВА без косточки 300гр ТМ 4 Сезона	\N	\N	3846.00	шт	1	117	t	2025-12-14 13:04:36.449	2025-12-14 13:04:36.449	175.00	шт	22	поштучно
55509	3317	МАКАРОНЫ "Шебекинские" 450гр Перья брикет (новая упаквока) №343	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.37	2025-12-14 13:04:10.37	97.00	шт	20	поштучно
25336	2755	ЗАКУСКА Венгерская 470гр ст/б ТМ Пиканта	\N	\N	1122.00	уп (6 шт)	1	200	f	2025-11-10 01:55:36.987	2025-11-22 01:30:48.533	187.00	шт	6	\N
55510	3317	МАКАРОНЫ "Шебекинские" 450гр Перья гладкие №340	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.399	2025-12-14 13:04:10.399	97.00	шт	20	поштучно
55511	3317	МАКАРОНЫ "Шебекинские" 450гр Ракушка брикет (новая упаковка) №393	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.413	2025-12-14 13:04:10.413	97.00	шт	20	поштучно
55512	3317	МАКАРОНЫ "Шебекинские" 450гр Ракушка маленькая №193	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.423	2025-12-14 13:04:10.423	97.00	шт	20	поштучно
55513	3317	МАКАРОНЫ "Шебекинские" 450гр Рожки №203	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.439	2025-12-14 13:04:10.439	97.00	шт	20	поштучно
55514	3317	МАКАРОНЫ "Шебекинские" 450гр Рожок полубублик брикет (новая упаковка) №202	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.452	2025-12-14 13:04:10.452	97.00	шт	20	поштучно
55515	3317	МАКАРОНЫ "Шебекинские" 450гр Русский рожок брикет (новая упаковка) №230	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.464	2025-12-14 13:04:10.464	97.00	шт	20	поштучно
55516	3317	МАКАРОНЫ "Шебекинские" 450гр Сердечки №370	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.475	2025-12-14 13:04:10.475	97.00	шт	20	поштучно
55517	3317	МАКАРОНЫ "Шебекинские" 450гр Спагетти №002	\N	\N	2718.00	шт	1	200	t	2025-12-14 13:04:10.486	2025-12-14 13:04:10.486	97.00	шт	28	поштучно
55518	3317	МАКАРОНЫ "Шебекинские" 450гр Спагеттини №001	\N	\N	2718.00	шт	1	200	t	2025-12-14 13:04:10.498	2025-12-14 13:04:10.498	97.00	шт	28	поштучно
55519	3317	МАКАРОНЫ "Шебекинские" 450гр Спирали №366	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.518	2025-12-14 13:04:10.518	97.00	шт	20	поштучно
55520	3317	МАКАРОНЫ "Шебекинские" 450гр Спирали три цвета №366.5	\N	\N	2084.00	шт	1	200	t	2025-12-14 13:04:10.575	2025-12-14 13:04:10.575	104.00	шт	20	поштучно
55521	3317	МАКАРОНЫ "Шебекинские" 450гр Трубки №353	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.589	2025-12-14 13:04:10.589	97.00	шт	20	поштучно
55522	3317	МАКАРОНЫ "Шебекинские" 450гр Улитка Мезо №390	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.601	2025-12-14 13:04:10.601	97.00	шт	20	поштучно
55523	3317	МАКАРОНЫ "Шебекинские" 450гр Улитки брикет (новая упаковка) №295	\N	\N	1941.00	шт	1	200	t	2025-12-14 13:04:10.612	2025-12-14 13:04:10.612	97.00	шт	20	поштучно
55524	3317	МАКАРОНЫ "Шебекинские" 450гр Фузили №266	\N	\N	2718.00	шт	1	200	t	2025-12-14 13:04:10.623	2025-12-14 13:04:10.623	97.00	шт	28	поштучно
55525	3317	МАКАРОНЫ Фунчоза 500гр	\N	\N	5227.00	шт	1	54	t	2025-12-14 13:04:10.635	2025-12-14 13:04:10.635	174.00	шт	30	поштучно
55526	3317	КРУПА "Агромастер" 400гр Перловая	\N	\N	344.00	шт	1	30	t	2025-12-14 13:04:10.647	2025-12-14 13:04:10.647	57.00	шт	6	поштучно
55527	3317	КРУПА "Прозапас" 600гр Пшеничная	\N	\N	621.00	шт	1	10	t	2025-12-14 13:04:10.688	2025-12-14 13:04:10.688	62.00	шт	10	поштучно
55528	3317	КРУПА "Прозапас" 600гр Ячневая	\N	\N	436.00	шт	1	40	t	2025-12-14 13:04:10.699	2025-12-14 13:04:10.699	44.00	шт	10	поштучно
55529	3317	КРУПА "Прозапас" 700гр Манная	\N	\N	730.00	шт	1	62	t	2025-12-14 13:04:10.711	2025-12-14 13:04:10.711	73.00	шт	10	поштучно
55530	3317	КРУПА "Прозапас" 800гр Геркулес	\N	\N	676.00	шт	1	200	t	2025-12-14 13:04:10.722	2025-12-14 13:04:10.722	85.00	шт	8	поштучно
55531	3317	КРУПА "Прозапас" 800гр Гречневая	\N	\N	627.00	шт	1	200	t	2025-12-14 13:04:10.732	2025-12-14 13:04:10.732	63.00	шт	10	поштучно
55532	3317	КРУПА "Прозапас" 800гр Перловая	\N	\N	580.00	шт	1	9	t	2025-12-14 13:04:10.742	2025-12-14 13:04:10.742	58.00	шт	10	поштучно
55533	3317	КРУПА "Прозапас" 800гр Пшено	\N	\N	730.00	шт	1	17	t	2025-12-14 13:04:10.77	2025-12-14 13:04:10.77	73.00	шт	10	поштучно
55534	3317	КРУПА "Прозапас" 800гр Рис для плова Камолино	\N	\N	1392.00	шт	1	138	t	2025-12-14 13:04:10.781	2025-12-14 13:04:10.781	139.00	шт	10	поштучно
55535	3317	КРУПА "Прозапас" 800гр Рис Краснодарский	\N	\N	1375.00	шт	1	137	t	2025-12-14 13:04:10.791	2025-12-14 13:04:10.791	138.00	шт	10	поштучно
55536	3317	КРУПА "Прозапас" 800гр Рис пропаренный	\N	\N	1662.00	шт	1	200	t	2025-12-14 13:04:10.803	2025-12-14 13:04:10.803	166.00	шт	10	поштучно
55537	3317	КРУПА "Шебекинская" 500гр Манная	\N	\N	1352.00	шт	1	200	t	2025-12-14 13:04:10.816	2025-12-14 13:04:10.816	97.00	шт	14	поштучно
55538	3323	КАКАО МакЧоколат Классический 20гр	\N	\N	492.00	шт	1	500	t	2025-12-14 13:04:10.829	2025-12-14 13:04:10.829	25.00	шт	20	поштучно
55539	3323	КАКАО Микс Фикс м/уп 175гр	\N	\N	5054.00	шт	1	293	t	2025-12-14 13:04:10.839	2025-12-14 13:04:10.839	168.00	шт	30	поштучно
55540	3323	КИСЕЛЬ брикет Вишня 180гр ТМ Мастер Дак	\N	\N	1693.00	шт	1	418	t	2025-12-14 13:04:10.867	2025-12-14 13:04:10.867	53.00	шт	32	поштучно
55541	3323	КИСЕЛЬ брикет Клубника 180гр ТМ Мастер Дак	\N	\N	1693.00	шт	1	176	t	2025-12-14 13:04:10.879	2025-12-14 13:04:10.879	53.00	шт	32	поштучно
55542	3323	КИСЕЛЬ брикет Малина 180гр ТМ Мастер Дак	\N	\N	1693.00	шт	1	160	t	2025-12-14 13:04:10.893	2025-12-14 13:04:10.893	53.00	шт	32	поштучно
55543	3323	КИСЕЛЬ брикет Плодово-ягодный 180гр ТМ Мастер Дак	\N	\N	1693.00	шт	1	15	t	2025-12-14 13:04:10.906	2025-12-14 13:04:10.906	53.00	шт	32	поштучно
55544	3323	Кофе BUSHIDO BLACK KATANA ст/б 100гр	\N	\N	11033.00	шт	1	49	t	2025-12-14 13:04:10.917	2025-12-14 13:04:10.917	1226.00	шт	9	поштучно
55545	3323	Кофе BUSHIDO BLACK KATANA ст/б 50гр	\N	\N	9508.00	шт	1	14	t	2025-12-14 13:04:10.93	2025-12-14 13:04:10.93	792.00	шт	12	поштучно
55546	3323	Кофе BUSHIDO ORIGINAL м/уп 75гр	\N	\N	10626.00	шт	1	189	t	2025-12-14 13:04:10.942	2025-12-14 13:04:10.942	885.00	шт	12	поштучно
55547	3323	Кофе BUSHIDO ORIGINAL ст/б 100гр	\N	\N	8963.00	шт	1	148	t	2025-12-14 13:04:10.955	2025-12-14 13:04:10.955	996.00	шт	9	поштучно
55548	3323	Кофе BUSHIDO RED KATANA м/у 75гр	\N	\N	11040.00	шт	1	47	t	2025-12-14 13:04:10.97	2025-12-14 13:04:10.97	920.00	шт	12	поштучно
55549	3323	Кофе BUSHIDO RED KATANA ст/б 100гр	\N	\N	10785.00	шт	1	81	t	2025-12-14 13:04:10.982	2025-12-14 13:04:10.982	1198.00	шт	9	поштучно
55550	3323	Кофе BUSHIDO SENSEI зерно м/у 227гр	\N	\N	9563.00	шт	1	156	t	2025-12-14 13:04:10.993	2025-12-14 13:04:10.993	797.00	шт	12	поштучно
55551	3323	КОФЕ CARTE NOIRE м/уп 150гр	\N	\N	9936.00	шт	1	48	t	2025-12-14 13:04:11.006	2025-12-14 13:04:11.006	1104.00	шт	9	поштучно
25383	2755	ФАСОЛЬ Отборная красная 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	1392.00	уп (12 шт)	1	47	f	2025-11-10 01:55:39.559	2025-11-22 01:30:48.533	116.00	шт	12	\N
25395	2755	ГОРОШЕК консервир 400гр ж/б  ТМ Знаток	\N	\N	1164.00	уп (12 шт)	1	200	f	2025-11-10 01:55:40.164	2025-11-22 01:30:48.533	97.00	шт	12	\N
25403	2755	КУКУРУЗА консервир 425мл ж/б  ТМ Знаток	\N	\N	1224.00	уп (12 шт)	1	200	f	2025-11-10 01:55:40.603	2025-11-22 01:30:48.533	102.00	шт	12	\N
55552	3323	КОФЕ CARTE NOIRE м/уп 75гр	\N	\N	7894.00	шт	1	213	t	2025-12-14 13:04:11.017	2025-12-14 13:04:11.017	658.00	шт	12	поштучно
55553	3323	КОФЕ CARTE NOIRE ст/б 190гр	\N	\N	8484.00	шт	1	45	t	2025-12-14 13:04:11.03	2025-12-14 13:04:11.03	1414.00	шт	6	поштучно
55554	3323	КОФЕ EGOISTE DOUBLE 100гр ст/б	\N	\N	9260.00	шт	1	92	t	2025-12-14 13:04:11.043	2025-12-14 13:04:11.043	772.00	шт	12	поштучно
55555	3323	КОФЕ EGOISTE NOIRE 100гр ст/б	\N	\N	9646.00	шт	1	57	t	2025-12-14 13:04:11.068	2025-12-14 13:04:11.068	804.00	шт	12	поштучно
55556	3323	КОФЕ EGOISTE PLATINUM 100гр ст/б	\N	\N	11913.00	шт	1	222	t	2025-12-14 13:04:11.078	2025-12-14 13:04:11.078	1324.00	шт	9	поштучно
55557	3323	КОФЕ EGOISTE PRIVATE 100гр ст/б	\N	\N	10754.00	шт	1	106	t	2025-12-14 13:04:11.089	2025-12-14 13:04:11.089	1195.00	шт	9	поштучно
55558	3323	КОФЕ EGOISTE SPECIAL 100гр ст/б	\N	\N	9864.00	шт	1	102	t	2025-12-14 13:04:11.101	2025-12-14 13:04:11.101	1096.00	шт	9	поштучно
55559	3323	КОФЕ EGOISTE V.S. 30% 100гр ст/б	\N	\N	9874.00	шт	1	106	t	2025-12-14 13:04:11.117	2025-12-14 13:04:11.117	1097.00	шт	9	поштучно
55560	3323	КОФЕ EGOISTE X.O. 100гр ст/б	\N	\N	11033.00	шт	1	78	t	2025-12-14 13:04:11.126	2025-12-14 13:04:11.126	1226.00	шт	9	поштучно
55561	3323	КОФЕ МакКофе Арабика 150гр м/уп	\N	\N	8181.00	шт	1	6	t	2025-12-14 13:04:11.137	2025-12-14 13:04:11.137	682.00	шт	12	поштучно
55562	3323	КОФЕ МакКофе Арабика 2гр	\N	\N	473.00	шт	1	500	t	2025-12-14 13:04:11.151	2025-12-14 13:04:11.151	16.00	шт	30	поштучно
55563	3323	КОФЕ МакКофе Голд 1,8гр	\N	\N	445.00	шт	1	500	t	2025-12-14 13:04:11.161	2025-12-14 13:04:11.161	15.00	шт	30	поштучно
55564	3323	КОФЕ МакКофе Голд 30гр м/уп	\N	\N	3574.00	шт	1	157	t	2025-12-14 13:04:11.172	2025-12-14 13:04:11.172	149.00	шт	24	поштучно
55565	3323	КОФЕ МакКофе Голд 75гр м/уп	\N	\N	4447.00	шт	1	32	t	2025-12-14 13:04:11.186	2025-12-14 13:04:11.186	371.00	шт	12	поштучно
55566	3323	КОФЕ МакКофе Капучино ди Торино 2в1 16,5гр	\N	\N	706.00	шт	1	500	t	2025-12-14 13:04:11.198	2025-12-14 13:04:11.198	35.00	шт	20	поштучно
55567	3323	КОФЕ МакКофе Капучино ди Торино с корицей 25,5гр	\N	\N	706.00	шт	1	500	t	2025-12-14 13:04:11.212	2025-12-14 13:04:11.212	35.00	шт	20	поштучно
55568	3323	КОФЕ МакКофе Капучино ди Торино с темным шоколадом 3в1 25,5гр	\N	\N	706.00	шт	1	500	t	2025-12-14 13:04:11.224	2025-12-14 13:04:11.224	35.00	шт	20	поштучно
55569	3323	КОФЕ МакКофе Капучино Дольче Вита 24гр	\N	\N	515.00	шт	1	500	t	2025-12-14 13:04:11.237	2025-12-14 13:04:11.237	26.00	шт	20	поштучно
55570	3323	КОФЕ МакКофе Карамель 3в1 18гр	\N	\N	555.00	шт	1	500	t	2025-12-14 13:04:11.249	2025-12-14 13:04:11.249	22.00	шт	25	поштучно
55571	3323	КОФЕ МакКофе Латте Карамель 22гр	\N	\N	515.00	шт	1	500	t	2025-12-14 13:04:11.325	2025-12-14 13:04:11.325	26.00	шт	20	поштучно
55572	3323	КОФЕ МакКофе Лесной орех 3в1 18гр	\N	\N	555.00	шт	1	500	t	2025-12-14 13:04:11.337	2025-12-14 13:04:11.337	22.00	шт	25	поштучно
55573	3323	КОФЕ МакКофе Макс Классик 3в1 16гр	\N	\N	373.00	шт	1	500	t	2025-12-14 13:04:11.406	2025-12-14 13:04:11.406	19.00	шт	20	поштучно
55574	3323	КОФЕ МакКофе Макс Крепкий 3в1 16гр	\N	\N	373.00	шт	1	500	t	2025-12-14 13:04:11.426	2025-12-14 13:04:11.426	19.00	шт	20	поштучно
55575	3323	КОФЕ МакКофе Оригинал 3в1 20гр	\N	\N	2220.00	шт	1	500	t	2025-12-14 13:04:11.437	2025-12-14 13:04:11.437	22.00	шт	100	поштучно
55576	3323	КОФЕ МакКофе Сгущеное молоко 3в1 20гр	\N	\N	222.00	шт	1	500	t	2025-12-14 13:04:11.45	2025-12-14 13:04:11.45	22.00	шт	10	поштучно
55577	3323	КОФЕ МакКофе Стронг 3в1 18гр	\N	\N	222.00	шт	1	500	t	2025-12-14 13:04:11.462	2025-12-14 13:04:11.462	22.00	шт	10	поштучно
55578	3323	КОФЕ Максим м/у 190гр 1/9шт	\N	\N	7587.00	шт	1	373	t	2025-12-14 13:04:11.473	2025-12-14 13:04:11.473	843.00	шт	9	поштучно
55579	3323	КОФЕ Максим м/у 300гр 1/9шт	\N	\N	12296.00	шт	1	500	t	2025-12-14 13:04:11.488	2025-12-14 13:04:11.488	1366.00	шт	9	поштучно
55580	3323	КОФЕ Максим м/у 500гр 1/6шт	\N	\N	12006.00	шт	1	500	t	2025-12-14 13:04:11.5	2025-12-14 13:04:11.5	2001.00	шт	6	поштучно
55581	3323	КОФЕ Монарх 3в1 Классик 13,5гр	\N	\N	437.00	шт	1	500	t	2025-12-14 13:04:11.512	2025-12-14 13:04:11.512	18.00	шт	24	поштучно
55582	3323	КОФЕ Монарх 3в1 Крепкий 13гр	\N	\N	437.00	шт	1	500	t	2025-12-14 13:04:11.522	2025-12-14 13:04:11.522	18.00	шт	24	поштучно
55583	3323	КОФЕ Монарх 3в1 Мягкий 13,5гр	\N	\N	437.00	шт	1	500	t	2025-12-14 13:04:11.533	2025-12-14 13:04:11.533	18.00	шт	24	поштучно
55584	3323	КОФЕ Монарх Голд ст/банка 190гр	\N	\N	5141.00	шт	1	152	t	2025-12-14 13:04:11.556	2025-12-14 13:04:11.556	857.00	шт	6	поштучно
55585	3323	КОФЕ Монарх Голд ст/банка 95гр	\N	\N	5962.00	шт	1	24	t	2025-12-14 13:04:11.567	2025-12-14 13:04:11.567	497.00	шт	12	поштучно
55586	3323	КОФЕ Монарх Милиграно ст/банка 90гр	\N	\N	2981.00	шт	1	42	t	2025-12-14 13:04:11.592	2025-12-14 13:04:11.592	497.00	шт	6	поштучно
55587	3323	КОФЕ Монарх Ориджинал м/уп 200гр	\N	\N	5472.00	шт	1	17	t	2025-12-14 13:04:11.603	2025-12-14 13:04:11.603	912.00	шт	6	поштучно
55588	3323	КОФЕ Монарх Ориджинал м/уп 500гр	\N	\N	13745.00	шт	1	448	t	2025-12-14 13:04:11.617	2025-12-14 13:04:11.617	2291.00	шт	6	поштучно
55589	3323	КОФЕ Московская Кофейная на Паяхъ Коломбо м/уп 150гр	\N	\N	8809.00	шт	1	87	t	2025-12-14 13:04:11.634	2025-12-14 13:04:11.634	881.00	шт	10	поштучно
55590	3323	КОФЕ Московская Кофейная на Паяхъ Коломбо м/уп 230гр	\N	\N	6734.00	шт	1	30	t	2025-12-14 13:04:11.648	2025-12-14 13:04:11.648	1122.00	шт	6	поштучно
55591	3323	КОФЕ Московская Кофейная на Паяхъ Коломбо м/уп 75гр	\N	\N	5762.00	шт	1	221	t	2025-12-14 13:04:11.663	2025-12-14 13:04:11.663	480.00	шт	12	поштучно
55592	3323	КОФЕ Московская Кофейная на Паяхъ Коломбо м/уп 95гр	\N	\N	6112.00	шт	1	231	t	2025-12-14 13:04:11.674	2025-12-14 13:04:11.674	509.00	шт	12	поштучно
55593	3323	КОФЕ Московская Кофейная на Паяхъ Мокко м/уп 230гр	\N	\N	6603.00	шт	1	93	t	2025-12-14 13:04:11.767	2025-12-14 13:04:11.767	1101.00	шт	6	поштучно
55594	3323	КОФЕ Московская Кофейная на Паяхъ Мокко м/уп 75гр	\N	\N	5051.00	шт	1	136	t	2025-12-14 13:04:11.778	2025-12-14 13:04:11.778	421.00	шт	12	поштучно
55595	3323	КОФЕ Московская Кофейная на Паяхъ Мокко ст/банка 95гр	\N	\N	3050.00	шт	1	163	t	2025-12-14 13:04:11.795	2025-12-14 13:04:11.795	508.00	шт	6	поштучно
55596	3323	КОФЕ Нескафе 3в1 Классик 14,5гр	\N	\N	382.00	шт	1	140	t	2025-12-14 13:04:11.806	2025-12-14 13:04:11.806	19.00	шт	20	поштучно
55597	3323	КОФЕ Нескафе 3в1 Крепкий 14,5гр	\N	\N	362.00	шт	1	500	t	2025-12-14 13:04:11.849	2025-12-14 13:04:11.849	18.00	шт	20	поштучно
55598	3323	КОФЕ Нескафе 3в1 Мягкий 14,5гр	\N	\N	382.00	шт	1	360	t	2025-12-14 13:04:11.867	2025-12-14 13:04:11.867	19.00	шт	20	поштучно
55599	3323	КОФЕ Черная Карта Exclusive Brasilia ст/б 190гр	\N	\N	4727.00	шт	1	20	t	2025-12-14 13:04:11.878	2025-12-14 13:04:11.878	788.00	шт	6	поштучно
55600	3323	КОФЕ Черная Карта Exclusive Brasilia ст/б 95гр	\N	\N	2374.00	шт	1	192	t	2025-12-14 13:04:11.89	2025-12-14 13:04:11.89	396.00	шт	6	поштучно
55601	3323	КОФЕ Черная Карта Gold м/у 75гр	\N	\N	3360.00	шт	1	97	t	2025-12-14 13:04:11.901	2025-12-14 13:04:11.901	280.00	шт	12	поштучно
55602	3323	КОФЕ Черная Карта Gold ст/б 190гр	\N	\N	4727.00	шт	1	144	t	2025-12-14 13:04:11.912	2025-12-14 13:04:11.912	788.00	шт	6	поштучно
55603	3323	КОФЕ Черная Карта Gold ст/б 95гр	\N	\N	2246.00	шт	1	151	t	2025-12-14 13:04:11.925	2025-12-14 13:04:11.925	374.00	шт	6	поштучно
55604	3323	НАПИТОК ЧАЙНЫЙ МакТи Лимон 16гр	\N	\N	294.00	шт	1	500	t	2025-12-14 13:04:11.936	2025-12-14 13:04:11.936	15.00	шт	20	поштучно
55605	3323	НАПИТОК ЧАЙНЫЙ МакТи Малина 16гр	\N	\N	294.00	шт	1	500	t	2025-12-14 13:04:11.948	2025-12-14 13:04:11.948	15.00	шт	20	поштучно
55606	3323	ЦИКОРИЙ Здоровье растворимый 100гр	\N	\N	1960.00	шт	1	118	t	2025-12-14 13:04:11.961	2025-12-14 13:04:11.961	163.00	шт	12	поштучно
55607	3323	ЧАЙ Curtic Delicate Mango Green пирамидки 20пак	\N	\N	1339.00	шт	1	11	t	2025-12-14 13:04:11.974	2025-12-14 13:04:11.974	112.00	шт	12	поштучно
55608	3323	ЧАЙ Азерчай Бергамот без конверта 25пак	\N	\N	1090.00	шт	1	24	t	2025-12-14 13:04:11.985	2025-12-14 13:04:11.985	91.00	шт	12	поштучно
55609	3323	ЧАЙ Азерчай Клубника конверт 25пак	\N	\N	2716.00	шт	1	6	t	2025-12-14 13:04:11.999	2025-12-14 13:04:11.999	113.00	шт	24	поштучно
55610	3323	ЧАЙ Акбар Лесные ягоды 100пак	\N	\N	1697.00	шт	1	201	t	2025-12-14 13:04:12.01	2025-12-14 13:04:12.01	283.00	шт	6	поштучно
55611	3323	ЧАЙ Гранд Великий Тигр 100пак	\N	\N	1831.00	шт	1	216	t	2025-12-14 13:04:12.021	2025-12-14 13:04:12.021	229.00	шт	8	поштучно
55612	3323	ЧАЙ Гранд Великий Тигр 25пак	\N	\N	1504.00	шт	1	500	t	2025-12-14 13:04:12.032	2025-12-14 13:04:12.032	63.00	шт	24	поштучно
55613	3323	ЧАЙ Гранд Семь слонов м/уп 100гр	\N	\N	2047.00	шт	1	270	t	2025-12-14 13:04:12.045	2025-12-14 13:04:12.045	102.00	шт	20	поштучно
55614	3323	ЧАЙ Гранд Семь слонов м/уп 200гр	\N	\N	2933.00	шт	1	225	t	2025-12-14 13:04:12.056	2025-12-14 13:04:12.056	195.00	шт	15	поштучно
55615	3323	ЧАЙ Гранд Суприм Гавайский мохито зеленый пирамидки 20пак	\N	\N	1125.00	шт	1	275	t	2025-12-14 13:04:12.069	2025-12-14 13:04:12.069	94.00	шт	12	поштучно
55616	3323	ЧАЙ Гранд Суприм Дикий чабрец пирамидки 20пак	\N	\N	1125.00	шт	1	138	t	2025-12-14 13:04:12.08	2025-12-14 13:04:12.08	94.00	шт	12	поштучно
55617	3323	ЧАЙ Гранд Суприм Земляничный цитрус пирамидки 20пак	\N	\N	1125.00	шт	1	186	t	2025-12-14 13:04:12.094	2025-12-14 13:04:12.094	94.00	шт	12	поштучно
55618	3323	ЧАЙ Гранд Суприм Манго маракуйя черный пирамидки 15пак	\N	\N	1104.00	шт	1	108	t	2025-12-14 13:04:12.105	2025-12-14 13:04:12.105	92.00	шт	12	поштучно
55619	3323	ЧАЙ Гранд Суприм Медовый имбирь зеленый пирамидки 20пак	\N	\N	1125.00	шт	1	115	t	2025-12-14 13:04:12.127	2025-12-14 13:04:12.127	94.00	шт	12	поштучно
55620	3323	ЧАЙ Гранд Суприм Пряный бергамот пирамидки 20пак	\N	\N	1125.00	шт	1	240	t	2025-12-14 13:04:12.139	2025-12-14 13:04:12.139	94.00	шт	12	поштучно
55621	3323	ЧАЙ Гранд Суприм Смородина апельсин пирамидки 20пак	\N	\N	1125.00	шт	1	141	t	2025-12-14 13:04:12.151	2025-12-14 13:04:12.151	94.00	шт	12	поштучно
55622	3323	ЧАЙ Гранд Суприм Таежные ягоды пирамидки 20пак	\N	\N	1125.00	шт	1	168	t	2025-12-14 13:04:12.166	2025-12-14 13:04:12.166	94.00	шт	12	поштучно
55623	3323	ЧАЙ Гринфилд Голден Цейлон 100пак	\N	\N	3664.00	шт	1	394	t	2025-12-14 13:04:12.177	2025-12-14 13:04:12.177	407.00	шт	9	поштучно
55624	3323	ЧАЙ Гринфилд Голден Цейлон 25пак	\N	\N	1288.00	шт	1	170	t	2025-12-14 13:04:12.193	2025-12-14 13:04:12.193	129.00	шт	10	поштучно
55625	3323	ЧАЙ Гринфилд Грин Мелиса 25пак	\N	\N	1213.00	шт	1	56	t	2025-12-14 13:04:12.205	2025-12-14 13:04:12.205	121.00	шт	10	поштучно
55626	3323	ЧАЙ Гринфилд Ерл Грей Фэнтази 25пак	\N	\N	1213.00	шт	1	169	t	2025-12-14 13:04:12.218	2025-12-14 13:04:12.218	121.00	шт	10	поштучно
55627	3323	ЧАЙ Гринфилд Ерл Грей Фэнтази с бергамотом 100пак	\N	\N	3664.00	шт	1	238	t	2025-12-14 13:04:12.23	2025-12-14 13:04:12.23	407.00	шт	9	поштучно
55628	3323	ЧАЙ Гринфилд Кения Санрайс 100пак	\N	\N	3674.00	шт	1	185	t	2025-12-14 13:04:12.241	2025-12-14 13:04:12.241	408.00	шт	9	поштучно
55629	3323	ЧАЙ Гринфилд Кения Санрайс 25пак	\N	\N	1265.00	шт	1	126	t	2025-12-14 13:04:12.251	2025-12-14 13:04:12.251	126.00	шт	10	поштучно
55630	3323	ЧАЙ Гринфилд Классик Бреакфаст 100пак	\N	\N	3364.00	шт	1	500	t	2025-12-14 13:04:12.267	2025-12-14 13:04:12.267	374.00	шт	9	поштучно
55631	3323	ЧАЙ Гринфилд Классик Бреакфаст 25пак	\N	\N	1213.00	шт	1	6	t	2025-12-14 13:04:12.278	2025-12-14 13:04:12.278	121.00	шт	10	поштучно
55632	3323	ЧАЙ Гринфилд Саммер Боуквит Малина 25пак	\N	\N	1213.00	шт	1	130	t	2025-12-14 13:04:12.29	2025-12-14 13:04:12.29	121.00	шт	10	поштучно
55633	3323	ЧАЙ Гринфилд Спринг Мелоди Душистые травы 25пак	\N	\N	1265.00	шт	1	137	t	2025-12-14 13:04:12.302	2025-12-14 13:04:12.302	126.00	шт	10	поштучно
55634	3323	ЧАЙ Гринфилд Спринг Мелоди с чабрецом 100пак	\N	\N	3664.00	шт	1	315	t	2025-12-14 13:04:12.316	2025-12-14 13:04:12.316	407.00	шт	9	поштучно
55635	3323	ЧАЙ Лисма Крепкий 100пак	\N	\N	1304.00	шт	1	259	t	2025-12-14 13:04:12.335	2025-12-14 13:04:12.335	217.00	шт	6	поштучно
55636	3323	ЧАЙ Лисма Крепкий 25пак	\N	\N	1025.00	шт	1	242	t	2025-12-14 13:04:12.353	2025-12-14 13:04:12.353	57.00	шт	18	поштучно
55637	3323	ЧАЙ Лисма Лимон 25пак	\N	\N	1118.00	шт	1	255	t	2025-12-14 13:04:12.372	2025-12-14 13:04:12.372	62.00	шт	18	поштучно
55638	3323	ЧАЙ Майский Ароматный бергамот 25пак	\N	\N	1511.00	шт	1	176	t	2025-12-14 13:04:12.398	2025-12-14 13:04:12.398	84.00	шт	18	поштучно
55639	3323	ЧАЙ Майский Душистый чабрец с лимоном 25пак	\N	\N	1573.00	шт	1	24	t	2025-12-14 13:04:12.409	2025-12-14 13:04:12.409	87.00	шт	18	поштучно
55640	3323	ЧАЙ Майский Корона Российской Империи 100пак	\N	\N	1704.00	шт	1	154	t	2025-12-14 13:04:12.421	2025-12-14 13:04:12.421	284.00	шт	6	поштучно
55641	3323	ЧАЙ Майский Корона Российской Империи 25пак	\N	\N	1366.00	шт	1	287	t	2025-12-14 13:04:12.438	2025-12-14 13:04:12.438	76.00	шт	18	поштучно
55642	3323	ЧАЙ Майский Лесные ягоды 25пак	\N	\N	1511.00	шт	1	192	t	2025-12-14 13:04:12.453	2025-12-14 13:04:12.453	84.00	шт	18	поштучно
55643	3323	ЧАЙ Майский Лимон 25пак	\N	\N	1511.00	шт	1	114	t	2025-12-14 13:04:12.468	2025-12-14 13:04:12.468	84.00	шт	18	поштучно
55644	3323	ЧАЙ Майский Отборный 25пак	\N	\N	1366.00	шт	1	182	t	2025-12-14 13:04:12.48	2025-12-14 13:04:12.48	76.00	шт	18	поштучно
55645	3323	ЧАЙ Майский Смородина мята 25пак	\N	\N	1511.00	шт	1	261	t	2025-12-14 13:04:12.491	2025-12-14 13:04:12.491	84.00	шт	18	поштучно
55646	3323	ЧАЙ пакетированный Акбар классический зеленый 100п*2гр	\N	\N	1366.00	шт	1	30	t	2025-12-14 13:04:12.504	2025-12-14 13:04:12.504	228.00	шт	6	поштучно
55647	3323	ЧАЙ Тэсс Брикфаст 100пак	\N	\N	3364.00	шт	1	52	t	2025-12-14 13:04:12.514	2025-12-14 13:04:12.514	374.00	шт	9	поштучно
55648	3323	ЧАЙ Тэсс Кения 100пак	\N	\N	3364.00	шт	1	127	t	2025-12-14 13:04:12.53	2025-12-14 13:04:12.53	374.00	шт	9	поштучно
55649	3323	ЧАЙ Тэсс Плэйсар Блэк 25пак	\N	\N	1023.00	шт	1	147	t	2025-12-14 13:04:12.581	2025-12-14 13:04:12.581	102.00	шт	10	поштучно
55650	3323	ЧАЙ Тэсс Плэйсар Блэк Плэжа 100пак	\N	\N	3364.00	шт	1	141	t	2025-12-14 13:04:12.606	2025-12-14 13:04:12.606	374.00	шт	9	поштучно
55651	3323	ЧАЙ Тэсс Санрайс Блэк 100пак	\N	\N	3364.00	шт	1	96	t	2025-12-14 13:04:12.617	2025-12-14 13:04:12.617	374.00	шт	9	поштучно
55652	3323	ЧАЙ Тэсс Санрайс Блэк 25пак	\N	\N	1023.00	шт	1	137	t	2025-12-14 13:04:12.629	2025-12-14 13:04:12.629	102.00	шт	10	поштучно
55653	3323	ЧАЙ Тэсс Флирт Грин 25пак	\N	\N	1023.00	шт	1	108	t	2025-12-14 13:04:12.64	2025-12-14 13:04:12.64	102.00	шт	10	поштучно
55654	3323	ЧАЙ Тэсс Хай Цейлон 25пак	\N	\N	1023.00	шт	1	137	t	2025-12-14 13:04:12.651	2025-12-14 13:04:12.651	102.00	шт	10	поштучно
55655	3323	ЧАЙ Хэйлис Английский Аристократический  круп лист 250гр	\N	\N	8746.00	шт	1	392	t	2025-12-14 13:04:12.665	2025-12-14 13:04:12.665	583.00	шт	15	поштучно
55656	3323	ЧАЙ Хэйлис Английский Аристократический 100пак	\N	\N	5423.00	шт	1	351	t	2025-12-14 13:04:12.676	2025-12-14 13:04:12.676	452.00	шт	12	поштучно
55657	3323	ЧАЙ Хэйлис Английский Аристократический 25пак	\N	\N	4858.00	шт	1	160	t	2025-12-14 13:04:12.687	2025-12-14 13:04:12.687	152.00	шт	32	поштучно
55658	3323	ЧАЙ Хэйлис Английский Аристократический 500гр	\N	\N	10063.00	шт	1	122	t	2025-12-14 13:04:12.699	2025-12-14 13:04:12.699	1006.00	шт	10	поштучно
55659	3323	ЧАЙ Чай Тэсс Банана Сплит 20пак	\N	\N	1228.00	шт	1	130	t	2025-12-14 13:04:12.71	2025-12-14 13:04:12.71	102.00	шт	12	поштучно
55660	3323	ЧАЙ Чай Тэсс Гингер Моджито Грин 20пак	\N	\N	1228.00	шт	1	126	t	2025-12-14 13:04:12.725	2025-12-14 13:04:12.725	102.00	шт	12	поштучно
55661	3323	ЧАЙ Чай Тэсс Карамель Шарм 20пак	\N	\N	1339.00	шт	1	73	t	2025-12-14 13:04:12.736	2025-12-14 13:04:12.736	112.00	шт	12	поштучно
55662	3323	ЧАЙ Чай Тэсс Пина Колада Грин 20пак	\N	\N	1187.00	шт	1	36	t	2025-12-14 13:04:12.747	2025-12-14 13:04:12.747	99.00	шт	12	поштучно
55663	3323	ЧАЙ Чай Тэсс Форест Дрим Блэк 20пак	\N	\N	1228.00	шт	1	120	t	2025-12-14 13:04:12.773	2025-12-14 13:04:12.773	102.00	шт	12	поштучно
55664	3323	ЧАЙ Ява Зелёный традиционный 100пак	\N	\N	4595.00	шт	1	250	t	2025-12-14 13:04:12.784	2025-12-14 13:04:12.784	255.00	шт	18	поштучно
55665	3303	ПОП КОРН 99гр с маслом ТМ Jolly Time США	\N	\N	2979.00	шт	1	155	t	2025-12-14 13:04:12.796	2025-12-14 13:04:12.796	165.00	шт	18	поштучно
55666	3303	ПОП КОРН 99гр сладкий ТМ Jolly Time США	\N	\N	3498.00	шт	1	13	t	2025-12-14 13:04:12.807	2025-12-14 13:04:12.807	194.00	шт	18	поштучно
55667	3303	ХЛЕБЦЫ МОЛОДЦЫ Lепешка кунжут и сыр 150гр	\N	\N	3671.00	уп (24 шт)	1	200	t	2025-12-14 13:04:12.821	2025-12-14 13:04:12.821	153.00	шт	24	только уп
55668	3303	ХЛЕБЦЫ МОЛОДЦЫ Lепешка лук и семена льна 150гр	\N	\N	3671.00	уп (24 шт)	1	200	t	2025-12-14 13:04:12.832	2025-12-14 13:04:12.832	153.00	шт	24	только уп
55669	3303	ХЛЕБЦЫ МОЛОДЦЫ Бородинские цельнозерновые 150гр	\N	\N	2450.00	уп (30 шт)	1	200	t	2025-12-14 13:04:12.844	2025-12-14 13:04:12.844	82.00	шт	30	только уп
55670	3303	ХЛЕБЦЫ МОЛОДЦЫ Гречнево-ржаные с провитамином А 110гр	\N	\N	2029.00	уп (36 шт)	1	200	t	2025-12-14 13:04:12.855	2025-12-14 13:04:12.855	56.00	шт	36	только уп
55671	3303	ХЛЕБЦЫ МОЛОДЦЫ Лайт вафельные ржаные 70гр	\N	\N	2401.00	уп (36 шт)	1	200	t	2025-12-14 13:04:12.87	2025-12-14 13:04:12.87	67.00	шт	36	только уп
55672	3303	ХЛЕБЦЫ МОЛОДЦЫ Лайт вафельные с витаминами 70гр	\N	\N	2401.00	уп (36 шт)	1	200	t	2025-12-14 13:04:12.88	2025-12-14 13:04:12.88	67.00	шт	36	только уп
56940	3395	ГРИБЫ ШАМПИНЬОНЫ резаные вес Беларусь	\N	\N	2760.00	уп (10 шт)	1	500	t	2025-12-14 13:04:35.251	2025-12-14 13:04:35.251	276.00	кг	10	только уп
55673	3303	ХЛЕБЦЫ МОЛОДЦЫ Лайт вафельные с экстрактом виноградных косточек 70гр	\N	\N	2401.00	уп (36 шт)	1	200	t	2025-12-14 13:04:12.891	2025-12-14 13:04:12.891	67.00	шт	36	только уп
55674	3303	ХЛЕБЦЫ МОЛОДЦЫ Лайт вафельные с экстрактом зеленого чая 70гр	\N	\N	2401.00	уп (36 шт)	1	200	t	2025-12-14 13:04:12.909	2025-12-14 13:04:12.909	67.00	шт	36	только уп
55675	3303	ХЛЕБЦЫ МОЛОДЦЫ Овсяные с пророщенной пшеницей 100гр	\N	\N	2029.00	уп (36 шт)	1	200	t	2025-12-14 13:04:12.922	2025-12-14 13:04:12.922	56.00	шт	36	только уп
55676	3303	ХЛЕБЦЫ МОЛОДЦЫ Пшенично-ржаные 100гр	\N	\N	2029.00	уп (36 шт)	1	200	t	2025-12-14 13:04:12.954	2025-12-14 13:04:12.954	56.00	шт	36	только уп
55677	3303	ХЛЕБЦЫ МОЛОДЦЫ Ржаные 110гр	\N	\N	1987.00	уп (36 шт)	1	75	t	2025-12-14 13:04:12.966	2025-12-14 13:04:12.966	55.00	шт	36	только уп
55678	3303	ХЛЕБЦЫ МОЛОДЦЫ ФитнесЛайн витамин плюс 100гр	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-14 13:04:12.981	2025-12-14 13:04:12.981	63.00	шт	36	только уп
55679	3303	ХЛЕБЦЫ МОЛОДЦЫ ФитнесЛайн железо плюс 100гр	\N	\N	2236.00	уп (36 шт)	1	200	t	2025-12-14 13:04:12.992	2025-12-14 13:04:12.992	62.00	шт	36	только уп
55680	3303	ХЛЕБЦЫ МОЛОДЦЫ ФитнесЛайн минерал плюс 100гр	\N	\N	2277.00	уп (36 шт)	1	200	t	2025-12-14 13:04:13.003	2025-12-14 13:04:13.003	63.00	шт	36	только уп
55681	3317	КАША овсяная клубника 35гр ТМ Мастер Дак	\N	\N	759.00	уп (30 шт)	1	200	t	2025-12-14 13:04:13.015	2025-12-14 13:04:13.015	25.00	шт	30	только уп
55682	3317	КАША овсяная малина 35гр ТМ Мастер Дак	\N	\N	759.00	уп (30 шт)	1	200	t	2025-12-14 13:04:13.026	2025-12-14 13:04:13.026	25.00	шт	30	только уп
55683	3317	КАША овсяная персик 35гр ТМ Мастер Дак	\N	\N	759.00	уп (30 шт)	1	200	t	2025-12-14 13:04:13.037	2025-12-14 13:04:13.037	25.00	шт	30	только уп
55684	3317	КАША овсяная черника 35гр ТМ Мастер Дак	\N	\N	759.00	уп (30 шт)	1	200	t	2025-12-14 13:04:13.049	2025-12-14 13:04:13.049	25.00	шт	30	только уп
55685	3403	АДЖИКА сухая 15гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	129	t	2025-12-14 13:04:13.061	2025-12-14 13:04:13.061	14.00	шт	40	только уп
55686	3403	БАЗИЛИК 500гр ТМ Мастер Дак	\N	\N	1455.00	шт	1	15	t	2025-12-14 13:04:13.079	2025-12-14 13:04:13.079	291.00	шт	5	поштучно
55687	3403	БУЛЬОН грибной 100гр ТМ Мастер Дак	\N	\N	1667.00	уп (50 шт)	1	130	t	2025-12-14 13:04:13.089	2025-12-14 13:04:13.089	33.00	шт	50	только уп
55688	3403	ВАНИЛИН 500гр ТМ Мастер Дак	\N	\N	4451.00	шт	1	52	t	2025-12-14 13:04:13.112	2025-12-14 13:04:13.112	445.00	шт	10	поштучно
55689	3403	ГОРЧИЧНЫЙ ПОРОШОК 150гр ТМ Мастер Дак	\N	\N	2668.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.123	2025-12-14 13:04:13.123	67.00	шт	40	только уп
55690	3403	ГОРЧИЧНЫЙ ПОРОШОК 500гр ТМ Мастер Дак	\N	\N	1323.00	шт	1	40	t	2025-12-14 13:04:13.134	2025-12-14 13:04:13.134	132.00	шт	10	поштучно
55691	3403	ДРОЖЖИ 8гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.159	2025-12-14 13:04:13.159	14.00	шт	40	только уп
55692	3403	КИСЕЛЬ в ассортименте 220гр	\N	\N	2087.00	уп (36 шт)	1	21	t	2025-12-14 13:04:13.171	2025-12-14 13:04:13.171	58.00	шт	36	только уп
55693	3403	КОРИЦА молотая 500гр ТМ Мастер Дак	\N	\N	4129.00	шт	1	53	t	2025-12-14 13:04:13.183	2025-12-14 13:04:13.183	413.00	шт	10	поштучно
55694	3403	КУНЖУТ 10гр ТМ Мастер Дак	\N	\N	690.00	уп (40 шт)	1	110	t	2025-12-14 13:04:13.195	2025-12-14 13:04:13.195	17.00	шт	40	только уп
55695	3403	КУНЖУТ семя с дозатором 300гр ТМ Трапеза	\N	\N	3323.00	шт	1	7	t	2025-12-14 13:04:13.207	2025-12-14 13:04:13.207	332.00	шт	10	поштучно
55696	3403	ЛАВРОВЫЙ лист целый 200гр ТМ Мастер Дак	\N	\N	1696.00	шт	1	112	t	2025-12-14 13:04:13.219	2025-12-14 13:04:13.219	339.00	шт	5	поштучно
55697	3403	ЛАПША Доширак Говядина 90гр	\N	\N	1877.00	уп (24 шт)	1	200	t	2025-12-14 13:04:13.23	2025-12-14 13:04:13.23	78.00	шт	24	только уп
55698	3403	ЛАПША Доширак Курица 90гр	\N	\N	1877.00	уп (24 шт)	1	200	t	2025-12-14 13:04:13.241	2025-12-14 13:04:13.241	78.00	шт	24	только уп
55699	3403	ЛИМОННАЯ КИСЛОТА 10гр ТМ Мастер Дак	\N	\N	414.00	уп (40 шт)	1	199	t	2025-12-14 13:04:13.254	2025-12-14 13:04:13.254	10.00	шт	40	только уп
55700	3403	ЛИМОННАЯ КИСЛОТА 20гр ТМ Capo di Gusto	\N	\N	828.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.313	2025-12-14 13:04:13.313	21.00	шт	40	только уп
55701	3403	ЛУК зеленый сушеный 5гр ТМ Мастер Дак	\N	\N	546.00	уп (25 шт)	1	200	t	2025-12-14 13:04:13.327	2025-12-14 13:04:13.327	22.00	шт	25	только уп
55702	3403	ЛУК сушеный вес Китай	\N	\N	6152.00	уп (10 шт)	1	20	t	2025-12-14 13:04:13.34	2025-12-14 13:04:13.34	615.00	кг	10	только уп
55703	3403	МАК пищевой 50гр ТМ Мастер Дак	\N	\N	5382.00	уп (60 шт)	1	200	t	2025-12-14 13:04:13.416	2025-12-14 13:04:13.416	90.00	шт	60	только уп
55704	3403	МОРКОВЬ дробленая сушеная 500гр ТМ Мастер Дак	\N	\N	3300.00	шт	1	19	t	2025-12-14 13:04:13.429	2025-12-14 13:04:13.429	330.00	шт	10	поштучно
55705	3403	ПАПРИКА молотая сладкая 500гр ТМ Мастер Дак	\N	\N	3220.00	шт	1	40	t	2025-12-14 13:04:13.444	2025-12-14 13:04:13.444	322.00	шт	10	поштучно
55706	3403	ПЕРЕЦ красный молотый 10гр ТМ Мастер Дак	\N	\N	483.00	уп (35 шт)	1	200	t	2025-12-14 13:04:13.456	2025-12-14 13:04:13.456	14.00	шт	35	только уп
55707	3403	ПЕРЕЦ черный горошек 10гр ТМ Мастер Дак	\N	\N	1311.00	уп (30 шт)	1	180	t	2025-12-14 13:04:13.467	2025-12-14 13:04:13.467	44.00	шт	30	только уп
55708	3403	ПЕРЕЦ черный горошек 500гр ТМ Мастер Дак	\N	\N	10868.00	шт	1	81	t	2025-12-14 13:04:13.479	2025-12-14 13:04:13.479	1087.00	шт	10	поштучно
55709	3403	ПЕРЕЦ черный молотый 10гр ТМ Мастер Дак	\N	\N	690.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.491	2025-12-14 13:04:13.491	17.00	шт	40	только уп
55710	3403	ПЕРЕЦ черный молотый 500гр ТМ Мастер Дак	\N	\N	3864.00	шт	1	179	t	2025-12-14 13:04:13.505	2025-12-14 13:04:13.505	386.00	шт	10	поштучно
55711	3403	ПЕТРУШКА сушеная 250гр ТМ Мастер Дак	\N	\N	1415.00	уп (10 шт)	1	200	t	2025-12-14 13:04:13.542	2025-12-14 13:04:13.542	141.00	шт	10	только уп
55712	3403	ПЕТРУШКА сушеная 5гр ТМ Мастер Дак	\N	\N	345.00	уп (30 шт)	1	200	t	2025-12-14 13:04:13.553	2025-12-14 13:04:13.553	12.00	шт	30	только уп
55713	3403	ПРИПРАВА для борща 15гр ТМ Мастер Дак	\N	\N	690.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.564	2025-12-14 13:04:13.564	17.00	шт	40	только уп
55714	3403	ПРИПРАВА для говядины 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	180	t	2025-12-14 13:04:13.576	2025-12-14 13:04:13.576	13.00	шт	40	только уп
55715	3403	ПРИПРАВА для гриля 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	180	t	2025-12-14 13:04:13.586	2025-12-14 13:04:13.586	13.00	шт	40	только уп
55716	3403	ПРИПРАВА для картофеля 15гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.596	2025-12-14 13:04:13.596	14.00	шт	40	только уп
55717	3403	ПРИПРАВА для куриных окорочков 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.607	2025-12-14 13:04:13.607	15.00	шт	40	только уп
55718	3403	ПРИПРАВА для курицы 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.617	2025-12-14 13:04:13.617	13.00	шт	40	только уп
55719	3403	ПРИПРАВА для курицы 500гр ТМ Мастер Дак	\N	\N	2243.00	шт	1	25	t	2025-12-14 13:04:13.628	2025-12-14 13:04:13.628	224.00	шт	10	поштучно
55720	3403	ПРИПРАВА для курицы с дозатором 300гр ТМ Трапеза	\N	\N	3703.00	шт	1	10	t	2025-12-14 13:04:13.64	2025-12-14 13:04:13.64	370.00	шт	10	поштучно
55721	3403	ПРИПРАВА для моркови по-корейски острая 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	60	t	2025-12-14 13:04:13.651	2025-12-14 13:04:13.651	15.00	шт	40	только уп
55722	3403	ПРИПРАВА для моркови по-корейски острая 500гр ТМ Мастер Дак	\N	\N	2530.00	шт	1	8	t	2025-12-14 13:04:13.662	2025-12-14 13:04:13.662	253.00	шт	10	поштучно
55723	3403	ПРИПРАВА для мяса 15гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	160	t	2025-12-14 13:04:13.672	2025-12-14 13:04:13.672	14.00	шт	40	только уп
55724	3403	ПРИПРАВА для мяса 500гр ТМ Мастер Дак	\N	\N	2243.00	шт	1	34	t	2025-12-14 13:04:13.767	2025-12-14 13:04:13.767	224.00	шт	10	поштучно
55725	3403	ПРИПРАВА для плова 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.794	2025-12-14 13:04:13.794	15.00	шт	40	только уп
55726	3403	ПРИПРАВА для рыбы 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	40	t	2025-12-14 13:04:13.805	2025-12-14 13:04:13.805	15.00	шт	40	только уп
55727	3403	ПРИПРАВА для свинины 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	20	t	2025-12-14 13:04:13.816	2025-12-14 13:04:13.816	13.00	шт	40	только уп
55728	3403	ПРИПРАВА для фарша 500гр ТМ Мастер Дак	\N	\N	2070.00	шт	1	43	t	2025-12-14 13:04:13.828	2025-12-14 13:04:13.828	207.00	шт	10	поштучно
55729	3403	ПРИПРАВА для цыплят табака 15гр ТМ Мастер Дак	\N	\N	506.00	уп (40 шт)	1	80	t	2025-12-14 13:04:13.871	2025-12-14 13:04:13.871	13.00	шт	40	только уп
55730	3403	ПРИПРАВА для шашлыка 15гр ТМ Мастер Дак	\N	\N	552.00	уп (40 шт)	1	119	t	2025-12-14 13:04:13.883	2025-12-14 13:04:13.883	14.00	шт	40	только уп
55731	3403	ПРИПРАВА Карри 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	155	t	2025-12-14 13:04:13.893	2025-12-14 13:04:13.893	15.00	шт	40	только уп
55732	3403	ПРИПРАВА Карри 500гр ТМ Мастер Дак	\N	\N	1702.00	шт	1	16	t	2025-12-14 13:04:13.904	2025-12-14 13:04:13.904	170.00	шт	10	поштучно
55733	3403	ПРИПРАВА Летняя с зеленью 8гр ТМ Мастер Дак	\N	\N	431.00	уп (25 шт)	1	100	t	2025-12-14 13:04:13.916	2025-12-14 13:04:13.916	17.00	шт	25	только уп
55734	3403	ПРИПРАВА Универсальная 15гр ТМ Мастер Дак	\N	\N	598.00	уп (40 шт)	1	200	t	2025-12-14 13:04:13.927	2025-12-14 13:04:13.927	15.00	шт	40	только уп
55735	3403	ПРИПРАВА Универсальная 20 трав и овощей 100гр ТМ Spice Master	\N	\N	1403.00	уп (20 шт)	1	200	t	2025-12-14 13:04:13.938	2025-12-14 13:04:13.938	70.00	шт	20	только уп
55736	3403	ПРИПРАВА Универсальная 500гр ТМ Мастер Дак	\N	\N	2243.00	шт	1	41	t	2025-12-14 13:04:13.949	2025-12-14 13:04:13.949	224.00	шт	10	поштучно
55737	3403	ПРИПРАВА Хмели-сунели 15гр ТМ Мастер Дак	\N	\N	448.00	уп (30 шт)	1	120	t	2025-12-14 13:04:13.959	2025-12-14 13:04:13.959	15.00	шт	30	только уп
55738	3403	Пюре картофельное с жареным луком 34гр ТМ Мастер Дак	\N	\N	1610.00	уп (40 шт)	1	120	t	2025-12-14 13:04:13.97	2025-12-14 13:04:13.97	40.00	шт	40	только уп
55739	3403	Пюре картофельное с курицей 34гр ТМ Мастер Дак	\N	\N	1610.00	уп (40 шт)	1	21	t	2025-12-14 13:04:13.986	2025-12-14 13:04:13.986	40.00	шт	40	только уп
55740	3403	СУХАРИ панировочные 400гр ТМ Мастер Дак	\N	\N	3162.00	шт	1	107	t	2025-12-14 13:04:13.997	2025-12-14 13:04:13.997	126.00	шт	25	поштучно
55741	3403	УКРОП сушеный 250гр ТМ Мастер Дак	\N	\N	3335.00	шт	1	100	t	2025-12-14 13:04:14.008	2025-12-14 13:04:14.008	167.00	шт	20	поштучно
55742	3403	УКРОП сушеный 5гр ТМ Мастер Дак	\N	\N	345.00	уп (30 шт)	1	200	t	2025-12-14 13:04:14.02	2025-12-14 13:04:14.02	12.00	шт	30	только уп
55743	3403	УКСУС Столовый Боген 9% 500мл	\N	\N	1004.00	шт	1	200	t	2025-12-14 13:04:14.031	2025-12-14 13:04:14.031	56.00	шт	18	поштучно
55744	3403	УКСУСНАЯ КИСЛОТА Боген 70% 160гр	\N	\N	1033.00	уп (18 шт)	1	200	t	2025-12-14 13:04:14.041	2025-12-14 13:04:14.041	57.00	шт	18	только уп
55745	3403	ЧЕСНОК гранулированный сушеный 10гр ТМ Мастер Дак	\N	\N	1006.00	уп (50 шт)	1	200	t	2025-12-14 13:04:14.052	2025-12-14 13:04:14.052	20.00	шт	50	только уп
55746	3403	ЧЕСНОК гранулированный сушеный 500гр ТМ Мастер Дак	\N	\N	5658.00	шт	1	82	t	2025-12-14 13:04:14.062	2025-12-14 13:04:14.062	566.00	шт	10	поштучно
55747	3327	МОЛОКО цельное сгущенное вареное Лакомка 8,5% 380гр ж/б  ТМ Минская Марка	\N	\N	5106.00	шт	1	200	t	2025-12-14 13:04:14.071	2025-12-14 13:04:14.071	170.00	шт	30	поштучно
55748	3327	МОЛОКО цельное сгущенное с сахаром 8,5% 380гр ж/б  ТМ Минская Марка	\N	\N	4444.00	шт	1	200	t	2025-12-14 13:04:14.082	2025-12-14 13:04:14.082	148.00	шт	30	поштучно
55749	3327	МОЛОКО цельное сгущенное с сахаром ГОСТ 8,5%  380гр ж/б МКЗ Верховский	\N	\N	2634.00	шт	1	200	t	2025-12-14 13:04:14.094	2025-12-14 13:04:14.094	132.00	шт	20	поштучно
55750	3327	СЛИВКИ сгущенные с сахаром 360гр ж/б 1/30 ТМ Минская Марка	\N	\N	6003.00	шт	1	30	t	2025-12-14 13:04:14.106	2025-12-14 13:04:14.106	200.00	шт	30	поштучно
55751	3327	ГОВЯДИНА тушеная 325гр ГОСТ ж/б  ТМ Деревня Потанино	\N	\N	3105.00	шт	1	200	t	2025-12-14 13:04:14.117	2025-12-14 13:04:14.117	259.00	шт	12	поштучно
55752	3327	ГОВЯДИНА тушеная 325гр Золотой Резерв в/с ГОСТ ж/б ключ ТМ Барс	\N	\N	7659.00	шт	1	200	t	2025-12-14 13:04:14.129	2025-12-14 13:04:14.129	425.00	шт	18	поштучно
55753	3327	ГОВЯДИНА тушеная 325гр Классическая ж/б ключ ТМ Барс	\N	\N	3008.00	шт	1	131	t	2025-12-14 13:04:14.142	2025-12-14 13:04:14.142	251.00	шт	12	поштучно
55754	3327	ГОВЯДИНА тушеная 325гр Экстра в/с ГОСТ ж/б ТМ Мясовсем	\N	\N	8239.00	шт	1	200	t	2025-12-14 13:04:14.155	2025-12-14 13:04:14.155	229.00	шт	36	поштучно
55755	3327	ГОВЯДИНА тушеная 325гр Экстра Спецзаказ Клетка в/с ГОСТ ж/б ключ ТМ Барс (Продмост)	\N	\N	6293.00	шт	1	200	t	2025-12-14 13:04:14.17	2025-12-14 13:04:14.17	350.00	шт	18	поштучно
55756	3327	ГОВЯДИНА тушеная 338гр  рубленая Камуфляж ГОСТ ж/б ключ ТМ Деревня Потанино	\N	\N	9574.00	шт	1	200	t	2025-12-14 13:04:14.18	2025-12-14 13:04:14.18	213.00	шт	45	поштучно
55757	3327	ГОВЯДИНА тушеная 338гр ж/б ТМ Мясоделов	\N	\N	4830.00	шт	1	59	t	2025-12-14 13:04:14.196	2025-12-14 13:04:14.196	322.00	шт	15	поштучно
55758	3327	СВИНИНА ветчина 325гр ГОСТ в/с ж/б ключ ТМ Деревня Потанино	\N	\N	2553.00	шт	1	66	t	2025-12-14 13:04:14.208	2025-12-14 13:04:14.208	213.00	шт	12	поштучно
55759	3327	СВИНИНА рулька копченая 540гр ж/б  ключ ТМ Знаток	\N	\N	2615.00	шт	1	114	t	2025-12-14 13:04:14.218	2025-12-14 13:04:14.218	436.00	шт	6	поштучно
55760	3327	СВИНИНА тушеная "Барс" ГОСТ в/с 325гр ключ ЭКСТРА	\N	\N	5630.00	шт	1	200	t	2025-12-14 13:04:14.234	2025-12-14 13:04:14.234	313.00	шт	18	поштучно
55761	3327	СВИНИНА тушеная 325гр ГОСТ в/с ж/б ключ ТМ Деревня Потанино	\N	\N	2995.00	шт	1	200	t	2025-12-14 13:04:14.245	2025-12-14 13:04:14.245	250.00	шт	12	поштучно
55762	3327	СВИНИНА тушеная 325гр Золотой резерв в/с ГОСТ ж/б  ключ ТМ Барс	\N	\N	5258.00	шт	1	200	t	2025-12-14 13:04:14.257	2025-12-14 13:04:14.257	292.00	шт	18	поштучно
55763	3327	СВИНИНА тушеная 325гр рубленая ГОСТ ж/б 1/36шт ТМ Деревня Потанино	\N	\N	4554.00	шт	1	200	t	2025-12-14 13:04:14.269	2025-12-14 13:04:14.269	126.00	шт	36	поштучно
55764	3327	СВИНИНА тушеная 325гр Экстра в/с ГОСТ ж/б 1/36шт ТМ Мясовсем	\N	\N	5796.00	шт	1	200	t	2025-12-14 13:04:14.282	2025-12-14 13:04:14.282	161.00	шт	36	поштучно
55765	3327	СВИНИНА тушеная 325гр Экстра Спецзаказ клетка в/с ГОСТ ж/б ключ ТМ Барс	\N	\N	4554.00	шт	1	200	t	2025-12-14 13:04:14.293	2025-12-14 13:04:14.293	253.00	шт	18	поштучно
55766	3327	СВИНИНА тушеная 338гр Экстра в/с ГОСТ ж/б 1/30шт ТМ Деревня Потанино	\N	\N	4796.00	шт	1	200	t	2025-12-14 13:04:14.304	2025-12-14 13:04:14.304	160.00	шт	30	поштучно
55767	3327	СВИНИНА тушеная 525гр Сельская ж/б 1/24шт ТМ Деревня Потанино	\N	\N	4140.00	шт	1	90	t	2025-12-14 13:04:14.319	2025-12-14 13:04:14.319	173.00	шт	24	поштучно
55768	3327	ГОЛУБЦЫ фаршированные мясом и рисом в томате 525гр ж/б ключ ТМ Барс	\N	\N	1732.00	шт	1	200	t	2025-12-14 13:04:14.33	2025-12-14 13:04:14.33	289.00	шт	6	поштучно
55769	3327	ГУЛЯШ говяжий 325гр ж/б ключ ТМ Барс	\N	\N	7038.00	шт	1	180	t	2025-12-14 13:04:14.345	2025-12-14 13:04:14.345	391.00	шт	18	поштучно
55770	3327	КАША Дворянская гречневая с говядиной 325гр ж/б ключ ТМ Барс	\N	\N	3726.00	шт	1	195	t	2025-12-14 13:04:14.355	2025-12-14 13:04:14.355	207.00	шт	18	поштучно
55771	3327	КАША Дворянская гречневая со свининой 325гр ж/б ключ ТМ Барс	\N	\N	3001.00	шт	1	90	t	2025-12-14 13:04:14.366	2025-12-14 13:04:14.366	167.00	шт	18	поштучно
55772	3327	КАША рисовая с говядиной 325гр ГОСТ в/с ж/б ТМ Деревня Потанино	\N	\N	1615.00	шт	1	9	t	2025-12-14 13:04:14.377	2025-12-14 13:04:14.377	135.00	шт	12	поштучно
55773	3327	МЯСО цыпленка филе грудки в с/с 325гр в/с ГОСТ ж/б ТМ Деревня Потанино	\N	\N	2857.00	шт	1	200	t	2025-12-14 13:04:14.397	2025-12-14 13:04:14.397	238.00	шт	12	поштучно
55774	3327	ПЕРЕЦ фаршированный мясом и рисом в томате 525гр ж/б ключ ТМ Барс	\N	\N	3436.00	шт	1	101	t	2025-12-14 13:04:14.407	2025-12-14 13:04:14.407	286.00	шт	12	поштучно
55775	3327	ПЛОВ Узбекский с говядиной 325гр ж/б ключ ТМ Барс	\N	\N	4451.00	шт	1	200	t	2025-12-14 13:04:14.417	2025-12-14 13:04:14.417	247.00	шт	18	поштучно
55776	3327	ПЛОВ Узбекский с мясов 325гр ж/б ключ ТМ Барс	\N	\N	4451.00	шт	1	21	t	2025-12-14 13:04:14.436	2025-12-14 13:04:14.436	247.00	шт	18	поштучно
55777	3327	ТЕФТЕЛИ мясные  в томате 325гр ключ ТМ Барс	\N	\N	4016.00	шт	1	10	t	2025-12-14 13:04:14.455	2025-12-14 13:04:14.455	223.00	шт	18	поштучно
55778	3327	ПАШТЕТ 100гр Печеночный со сливочным маслом  ТМ Знаток	\N	\N	1633.00	шт	1	168	t	2025-12-14 13:04:14.466	2025-12-14 13:04:14.466	82.00	шт	20	поштучно
55779	3327	ПАШТЕТ 100гр Печеночный со сливочным маслом ключ ТМ Знаток	\N	\N	1932.00	шт	1	14	t	2025-12-14 13:04:14.477	2025-12-14 13:04:14.477	81.00	шт	24	поштучно
55780	3327	ПАШТЕТ 100гр Пражский из свиной печени  ТМ Знаток	\N	\N	1552.00	шт	1	139	t	2025-12-14 13:04:14.487	2025-12-14 13:04:14.487	78.00	шт	20	поштучно
55781	3327	ПАШТЕТ 100гр Пражский из свиной печени ключ ТМ Знаток	\N	\N	1932.00	шт	1	41	t	2025-12-14 13:04:14.497	2025-12-14 13:04:14.497	81.00	шт	24	поштучно
55782	3327	ПАШТЕТ 100гр Эстонский из говяжьей печени  ТМ Знаток	\N	\N	1633.00	шт	1	80	t	2025-12-14 13:04:14.508	2025-12-14 13:04:14.508	82.00	шт	20	поштучно
55783	3327	ПАШТЕТ 200гр Печеночный Гусь ст/б ТМ Знаток	\N	\N	959.00	шт	1	87	t	2025-12-14 13:04:14.567	2025-12-14 13:04:14.567	160.00	шт	6	поштучно
55784	3327	ПАШТЕТ 200гр Печеночный Индейка ст/б ТМ Знаток	\N	\N	959.00	шт	1	40	t	2025-12-14 13:04:14.582	2025-12-14 13:04:14.582	160.00	шт	6	поштучно
55785	3327	ПАШТЕТ 200гр Печеночный Курица ст/б ТМ Знаток	\N	\N	994.00	шт	1	118	t	2025-12-14 13:04:14.597	2025-12-14 13:04:14.597	166.00	шт	6	поштучно
53455	3394	ВАРЕНЬЕ Абрикосовое ст/б 320гр ТМ Знаток	\N	\N	2318.00	уп (12 шт)	1	276	f	2025-12-07 13:19:29.789	2025-12-14 12:09:06.688	193.00	шт	12	только уп
55786	3327	ПАШТЕТ 200гр Печеночный Утка ст/б ТМ Знаток	\N	\N	959.00	шт	1	48	t	2025-12-14 13:04:14.61	2025-12-14 13:04:14.61	160.00	шт	6	поштучно
25617	2755	СЫРОК Савушкин Творобушки малина глазированный 40гр	\N	\N	828.00	уп (18 шт)	1	200	f	2025-11-10 01:55:51.411	2025-11-22 01:30:48.533	46.00	шт	18	\N
25618	2755	СЫРОК Савушкин Творобушки шоколад глазированный 40гр	\N	\N	828.00	уп (18 шт)	1	18	f	2025-11-10 01:55:51.463	2025-11-22 01:30:48.533	46.00	шт	18	\N
55787	3327	ПАШТЕТ 230гр Печеночный со сливочным маслом ключ ТМ Знаток	\N	\N	2760.00	шт	1	200	t	2025-12-14 13:04:14.621	2025-12-14 13:04:14.621	115.00	шт	24	поштучно
55788	3327	ПАШТЕТ 230гр Пражский из свиной печени ключ ТМ Знаток	\N	\N	2760.00	шт	1	196	t	2025-12-14 13:04:14.632	2025-12-14 13:04:14.632	115.00	шт	24	поштучно
55789	3327	ПАШТЕТ 230гр Эстонский из говяжьей печени ключ ТМ Знаток	\N	\N	2760.00	шт	1	53	t	2025-12-14 13:04:14.643	2025-12-14 13:04:14.643	115.00	шт	24	поштучно
55790	3327	АДЖИКА Домашняя 280гр ст/б ТМ Сава	\N	\N	787.00	уп (8 шт)	1	16	t	2025-12-14 13:04:14.662	2025-12-14 13:04:14.662	98.00	шт	8	только уп
55791	3327	ВАРЕНЬЕ Малина ст/б 300гр ТМ Сава	\N	\N	1794.00	уп (8 шт)	1	8	t	2025-12-14 13:04:14.675	2025-12-14 13:04:14.675	224.00	шт	8	только уп
55792	3327	ДЖЕМ 250гр Сава Черника вишня на яблочном мусе дойпак	\N	\N	1720.00	уп (15 шт)	1	43	t	2025-12-14 13:04:14.69	2025-12-14 13:04:14.69	115.00	шт	15	только уп
55793	3327	КОМПОТ Черешня 580мл ст/б ТМ Золотая долина	\N	\N	2287.00	уп (12 шт)	1	53	t	2025-12-14 13:04:14.702	2025-12-14 13:04:14.702	191.00	шт	12	только уп
55794	3327	ОГУРЦЫ маринованные ст/б 670гр По-Деревенски хрен смородина ТМ Лукашино	\N	\N	1266.00	уп (6 шт)	1	47	t	2025-12-14 13:04:14.715	2025-12-14 13:04:14.715	211.00	шт	6	только уп
55795	3327	ПОВИДЛО Персиковое 1кг пластиковое ведро ТМ Сава	\N	\N	1011.00	уп (4 шт)	1	16	t	2025-12-14 13:04:14.728	2025-12-14 13:04:14.728	253.00	шт	4	только уп
55796	3327	ПОВИДЛО Яблочное ведро 13кг ТМ Еврофрут	\N	\N	2377.00	уп (13 шт)	1	26	t	2025-12-14 13:04:14.74	2025-12-14 13:04:14.74	183.00	кг	13	только уп
55797	3327	ТОМАТЫ марин 680гр ст/б ТМ Принцесса вкуса	\N	\N	888.00	уп (8 шт)	1	6	t	2025-12-14 13:04:14.764	2025-12-14 13:04:14.764	111.00	шт	8	только уп
55798	3327	ГРИБЫ ШАМПИНЬОНЫ резаные 425мл ж/б  ТМ Сыта-Загора	\N	\N	1822.00	уп (24 шт)	1	125	t	2025-12-14 13:04:14.777	2025-12-14 13:04:14.777	76.00	шт	24	только уп
55799	3327	ГРИБЫ ШАМПИНЬОНЫ резаные 850мл ж/б  ТМ Сыта-Загора	\N	\N	1946.00	уп (12 шт)	1	170	t	2025-12-14 13:04:14.788	2025-12-14 13:04:14.788	162.00	шт	12	только уп
55800	3327	КОРНИШОНЫ 1500мл ст/б ТМ Сыта-Загора	\N	\N	2256.00	уп (6 шт)	1	152	t	2025-12-14 13:04:14.8	2025-12-14 13:04:14.8	376.00	шт	6	только уп
55801	3327	КОРНИШОНЫ 720мл ст/б ТМ Сыта-Загора	\N	\N	2263.00	уп (12 шт)	1	287	t	2025-12-14 13:04:14.813	2025-12-14 13:04:14.813	189.00	шт	12	только уп
55802	3327	КОРНИШОНЫ с луком 540мл ст/б ТМ Сыта-Загора	\N	\N	1918.00	уп (12 шт)	1	11	t	2025-12-14 13:04:14.823	2025-12-14 13:04:14.823	160.00	шт	12	только уп
55803	3327	КОРНИШОНЫ с перцем 540мл ст/б ТМ Сыта-Загора	\N	\N	1918.00	уп (12 шт)	1	138	t	2025-12-14 13:04:14.836	2025-12-14 13:04:14.836	160.00	шт	12	только уп
55804	3327	КОРНИШОНЫ с хреном 540мл ст/б ТМ Сыта-Загора	\N	\N	1973.00	уп (12 шт)	1	108	t	2025-12-14 13:04:14.848	2025-12-14 13:04:14.848	164.00	шт	12	только уп
55805	3327	ЛЕЧО 720гр ГОСТ ТМ Золотой Выбор	\N	\N	1187.00	уп (8 шт)	1	4000	t	2025-12-14 13:04:14.868	2025-12-14 13:04:14.868	148.00	шт	8	только уп
55806	3327	ЛЕЧО по-болгарски 680гр ст/б Сыта-Загора	\N	\N	1463.00	уп (8 шт)	1	10	t	2025-12-14 13:04:14.878	2025-12-14 13:04:14.878	183.00	шт	8	только уп
55807	3327	ЛЕЧО твист 680гр ГОСТ  ТМ Закромеево	\N	\N	1242.00	уп (8 шт)	1	22	t	2025-12-14 13:04:14.889	2025-12-14 13:04:14.889	155.00	шт	8	только уп
55808	3327	ОГУРЧИКИ 1500мл консервированные ст/б ТМ Сыта-Загора	\N	\N	1973.00	уп (6 шт)	1	371	t	2025-12-14 13:04:14.903	2025-12-14 13:04:14.903	329.00	шт	6	только уп
55809	3327	ОГУРЧИКИ 3100мл консервированные ж/б ТМ Сыта-Загора	\N	\N	3478.00	уп (6 шт)	1	437	t	2025-12-14 13:04:14.914	2025-12-14 13:04:14.914	580.00	шт	6	только уп
55810	3327	ОГУРЧИКИ 720мл консервированные ж/б ТМ Сыта-Загора	\N	\N	2070.00	уп (12 шт)	1	1363	t	2025-12-14 13:04:14.924	2025-12-14 13:04:14.924	173.00	шт	12	только уп
55811	3327	ПОМИДОРКИ 1500мл маринованые в собственном соку ст/б ТМ Сыта-Загора	\N	\N	2056.00	уп (6 шт)	1	290	t	2025-12-14 13:04:14.935	2025-12-14 13:04:14.935	343.00	шт	6	только уп
55812	3327	ПОМИДОРКИ 1500мл маринованые ст/б ТМ Сыта-Загора	\N	\N	1904.00	уп (6 шт)	1	166	t	2025-12-14 13:04:14.959	2025-12-14 13:04:14.959	317.00	шт	6	только уп
55813	3327	ПОМИДОРКИ 720мл маринованые в собственном соку ст/б ТМ Сыта-Загора	\N	\N	1932.00	уп (12 шт)	1	419	t	2025-12-14 13:04:14.972	2025-12-14 13:04:14.972	161.00	шт	12	только уп
55814	3394	ВАРЕНЬЕ Абрикосовое ст/б 320гр ТМ Знаток	\N	\N	2318.00	уп (12 шт)	1	264	t	2025-12-14 13:04:14.984	2025-12-14 13:04:14.984	193.00	шт	12	только уп
55815	3394	ВАРЕНЬЕ Клубничное ст/б 320гр ТМ Знаток	\N	\N	2318.00	уп (12 шт)	1	779	t	2025-12-14 13:04:14.996	2025-12-14 13:04:14.996	193.00	шт	12	только уп
55816	3394	ВАРЕНЬЕ Клюквенное ст/б 320гр ТМ Знаток	\N	\N	2318.00	уп (12 шт)	1	265	t	2025-12-14 13:04:15.018	2025-12-14 13:04:15.018	193.00	шт	12	только уп
53491	3327	АССОРТИ огурцы/томаты 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	2033.00	уп (8 шт)	1	99	f	2025-12-07 13:19:30.684	2025-12-14 12:09:06.688	254.00	шт	8	только уп
55817	3394	ВАРЕНЬЕ Малиновое ст/б 320гр ТМ Знаток	\N	\N	2677.00	уп (12 шт)	1	665	t	2025-12-14 13:04:15.06	2025-12-14 13:04:15.06	223.00	шт	12	только уп
55818	3394	ДЖЕМ Абрикосовый ст/б 320гр ТМ Знаток	\N	\N	3229.00	уп (12 шт)	1	37	t	2025-12-14 13:04:15.191	2025-12-14 13:04:15.191	269.00	шт	12	только уп
55819	3394	ДЖЕМ Клубничный ст/б 320гр ТМ Знаток	\N	\N	1973.00	уп (12 шт)	1	74	t	2025-12-14 13:04:15.235	2025-12-14 13:04:15.235	164.00	шт	12	только уп
55820	3327	АДЖИКА Домашняя 350гр ст/б ТМ Пиканта	\N	\N	1042.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.249	2025-12-14 13:04:15.249	174.00	шт	6	только уп
55821	3327	АППЕТИТКА с нежно-острым вкусом 360гр ст/б ТМ Пиканта	\N	\N	980.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.269	2025-12-14 13:04:15.269	163.00	шт	6	только уп
55822	3327	БАКЛАЖАНЫ в аджике 460гр ст/б ТМ Пиканта	\N	\N	1277.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.307	2025-12-14 13:04:15.307	213.00	шт	6	только уп
55823	3327	БАКЛАЖАНЫ печёные в томатном соусе 450гр ст/б ТМ Пиканта	\N	\N	1277.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.34	2025-12-14 13:04:15.34	213.00	шт	6	только уп
55824	3327	БАКЛАЖАНЫ по-Домашнему 450гр ст/б ТМ Пиканта	\N	\N	1228.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.413	2025-12-14 13:04:15.413	205.00	шт	6	только уп
55825	3327	БАКЛАЖАНЫ по-Китайски кисло-сладкий соус 360гр ст/б ТМ Пиканта	\N	\N	1394.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.431	2025-12-14 13:04:15.431	232.00	шт	6	только уп
55826	3327	ЗАКУСКА Астраханская 460гр ст/б ТМ Пиканта	\N	\N	1359.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.443	2025-12-14 13:04:15.443	227.00	шт	6	только уп
55827	3327	ЗАКУСКА Венгерская 470гр ст/б ТМ Пиканта	\N	\N	1290.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.458	2025-12-14 13:04:15.458	215.00	шт	6	только уп
55828	3327	ЗАКУСКА для зятя ст/б 460гр ТМ Пиканта	\N	\N	1359.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.474	2025-12-14 13:04:15.474	227.00	шт	6	только уп
55829	3327	ЗАКУСКА для тещи ст/б 440гр ТМ Пиканта	\N	\N	1290.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.486	2025-12-14 13:04:15.486	215.00	шт	6	только уп
55830	3327	ЗАКУСКА Закарпатская ст/б 460гр ТМ Пиканта	\N	\N	1228.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.504	2025-12-14 13:04:15.504	205.00	шт	6	только уп
55831	3327	ИКРА из баклажанов 450гр ст/б ТМ Пиканта	\N	\N	1104.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.518	2025-12-14 13:04:15.518	184.00	шт	6	только уп
55832	3327	ИКРА из кабачков 450гр ст/б ТМ Пиканта	\N	\N	987.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.531	2025-12-14 13:04:15.531	164.00	шт	6	только уп
55833	3327	ЛЕЧО 450гр ст/б Пиканта	\N	\N	1118.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.544	2025-12-14 13:04:15.544	186.00	шт	6	только уп
55834	3327	ОГУРЧИКИ корнишоны по-Баварски 3-6см 700гр ст/б ТМ Пиканта	\N	\N	1780.00	уп (6 шт)	1	14	t	2025-12-14 13:04:15.569	2025-12-14 13:04:15.569	297.00	шт	6	только уп
55835	3327	ОГУРЧИКИ маринованные ГОСТ 460гр ст/б ТМ Пиканта	\N	\N	1435.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.583	2025-12-14 13:04:15.583	239.00	шт	6	только уп
55836	3327	ОГУРЧИКИ по-Баварски 3-6см 460гр ст/б ТМ Пиканта	\N	\N	1387.00	уп (6 шт)	1	82	t	2025-12-14 13:04:15.6	2025-12-14 13:04:15.6	231.00	шт	6	только уп
55837	3327	ПАССАТА (измельченная  мякоть томатов) 340гр т/пак ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	186	t	2025-12-14 13:04:15.612	2025-12-14 13:04:15.612	152.00	шт	6	только уп
55838	3327	ТОМАТЫ Астраханские в собственном соку 690гр ст/б ТМ Пиканта	\N	\N	1277.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.622	2025-12-14 13:04:15.622	213.00	шт	6	только уп
55839	3327	ТОМАТЫ Астраханские маринованные 670гр ст/б ТМ Пиканта	\N	\N	1028.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.635	2025-12-14 13:04:15.635	171.00	шт	6	только уп
55840	3327	ТОМАТЫ протёртая мякоть 500гр тетра-пак ТМ Пиканта ИТАЛИЯ	\N	\N	1956.00	уп (9 шт)	1	9	t	2025-12-14 13:04:15.649	2025-12-14 13:04:15.649	217.00	шт	9	только уп
55841	3327	ФАСОЛЬ печёная в аджике 470гр ст/б ТМ Пиканта	\N	\N	1373.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.66	2025-12-14 13:04:15.66	229.00	шт	6	только уп
55842	3327	ФАСОЛЬ печёная в томатном соусе 470гр ст/б ТМ Пиканта	\N	\N	1235.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.757	2025-12-14 13:04:15.757	206.00	шт	6	только уп
55843	3327	ФАСОЛЬ печёная с баклажанами 470гр ст/б ТМ Пиканта	\N	\N	1373.00	уп (6 шт)	1	126	t	2025-12-14 13:04:15.802	2025-12-14 13:04:15.802	229.00	шт	6	только уп
55844	3327	ФАСОЛЬ по-Домашнему с грибами 470гр ст/б ТМ Пиканта	\N	\N	1421.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.82	2025-12-14 13:04:15.82	237.00	шт	6	только уп
55845	3327	ФАСОЛЬ по-Мексикански с кукурузой 470гр ст/б ТМ Пиканта	\N	\N	1511.00	уп (6 шт)	1	146	t	2025-12-14 13:04:15.876	2025-12-14 13:04:15.876	252.00	шт	6	только уп
55846	3327	ФАСОЛЬ по-Монастырски с овощами 470гр ТМ Пиканта	\N	\N	1283.00	уп (6 шт)	1	200	t	2025-12-14 13:04:15.89	2025-12-14 13:04:15.89	214.00	шт	6	только уп
55847	3327	ХЕ из баклажанов по-Корейски 360гр ст/б ТМ Пиканта	\N	\N	1270.00	уп (6 шт)	1	182	t	2025-12-14 13:04:15.901	2025-12-14 13:04:15.901	212.00	шт	6	только уп
55848	3327	АССОРТИ корнишон/черри 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	2401.00	уп (8 шт)	1	124	t	2025-12-14 13:04:15.912	2025-12-14 13:04:15.912	300.00	шт	8	только уп
55849	3327	АССОРТИ огурцы/томаты 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	2033.00	уп (8 шт)	1	84	t	2025-12-14 13:04:15.924	2025-12-14 13:04:15.924	254.00	шт	8	только уп
55850	3327	ГРИБЫ ГРИБНОЕ ЛУКОШКО 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	2815.00	уп (12 шт)	1	100	t	2025-12-14 13:04:15.936	2025-12-14 13:04:15.936	235.00	шт	12	только уп
55851	3327	ГРИБЫ ГРУЗДИ маринованные 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	3271.00	уп (12 шт)	1	200	t	2025-12-14 13:04:15.953	2025-12-14 13:04:15.953	273.00	шт	12	только уп
55852	3327	ГРИБЫ МАСЛЯТА маринованные 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	3685.00	уп (12 шт)	1	123	t	2025-12-14 13:04:15.97	2025-12-14 13:04:15.97	307.00	шт	12	только уп
55853	3327	ГРИБЫ ОПЯТА маринованные 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	3671.00	уп (12 шт)	1	177	t	2025-12-14 13:04:15.987	2025-12-14 13:04:15.987	306.00	шт	12	только уп
55854	3327	ГРИБЫ ОПЯТА маринованные 580мл ст/б ТМ Скатерть-Самобранка	\N	\N	4830.00	уп (12 шт)	1	104	t	2025-12-14 13:04:16.007	2025-12-14 13:04:16.007	402.00	шт	12	только уп
53556	3327	АНАНАС кусочки 565гр ж/б ТМ Знаток	\N	\N	5410.00	уп (24 шт)	1	12	f	2025-12-07 13:19:31.892	2025-12-14 08:21:45.096	225.00	шт	24	только уп
55855	3327	ИКРА из кабачков 500мл ст/б Скатерть-Самобранка	\N	\N	2208.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.025	2025-12-14 13:04:16.025	184.00	шт	12	только уп
55856	3327	ИМБИРЬ маринованный розовый 250гр ст/б ТМ Скатерть-Самобранка	\N	\N	2443.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.041	2025-12-14 13:04:16.041	204.00	шт	12	только уп
55857	3327	КОРНИШОНЫ 500мл хрустящие ст/б ТМ Скатерть-Самобранка	\N	\N	3091.00	уп (12 шт)	1	85	t	2025-12-14 13:04:16.058	2025-12-14 13:04:16.058	258.00	шт	12	только уп
25679	2755	Азу из курицы с картоф пюре 350гр ТМ Сытоедов	\N	\N	2650.00	уп (10 шт)	1	99	f	2025-11-10 01:55:54.629	2025-11-22 01:30:48.533	265.00	шт	10	\N
25703	2755	Лапша WOK Удон с говядиной и овощами 300гр ТМ Главобед	\N	\N	2244.00	уп (6 шт)	1	112	f	2025-11-10 01:55:56.009	2025-11-22 01:30:48.533	374.00	шт	6	\N
25712	2755	Паста Палермо с курицей и грибами 300гр ТМ Сытоедов	\N	\N	2304.00	уп (8 шт)	1	15	f	2025-11-10 01:55:56.455	2025-11-22 01:30:48.533	288.00	шт	8	\N
55858	3327	КОРНИШОНЫ 720мл хрустящие ст/б ТМ Скатерть-Самобранка	\N	\N	2622.00	уп (8 шт)	1	200	t	2025-12-14 13:04:16.071	2025-12-14 13:04:16.071	328.00	шт	8	только уп
55859	3327	ЛЕЧО 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	1969.00	уп (8 шт)	1	200	t	2025-12-14 13:04:16.088	2025-12-14 13:04:16.088	246.00	шт	8	только уп
55860	3327	МОРКОВЬ по-Корейски Острая 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	1877.00	уп (12 шт)	1	176	t	2025-12-14 13:04:16.099	2025-12-14 13:04:16.099	156.00	шт	12	только уп
55861	3327	ОГУРЦЫ Соленые по-Домашнему 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	2337.00	уп (8 шт)	1	200	t	2025-12-14 13:04:16.112	2025-12-14 13:04:16.112	292.00	шт	8	только уп
55862	3327	ОГУРЦЫ Соленые по-Домашнему бочковые 950мл ст/б ТМ Скатерть-Самобранка СКИДКА 20%	\N	\N	1856.00	уп (6 шт)	1	74	t	2025-12-14 13:04:16.122	2025-12-14 13:04:16.122	309.00	шт	6	только уп
55863	3327	ОГУРЧИКИ 1415мл хрустящие ст/б ТМ Скатерть-Самобранка	\N	\N	2650.00	уп (6 шт)	1	101	t	2025-12-14 13:04:16.136	2025-12-14 13:04:16.136	442.00	шт	6	только уп
55864	3327	ОГУРЧИКИ 1500мл маринованые ст/б ТМ Скатерть-Самобранка	\N	\N	2760.00	уп (6 шт)	1	200	t	2025-12-14 13:04:16.149	2025-12-14 13:04:16.149	460.00	шт	6	только уп
55865	3327	ОГУРЧИКИ 720мл хрустящие марин ст/б ТМ Скатерть-Самобранка	\N	\N	2088.00	уп (8 шт)	1	184	t	2025-12-14 13:04:16.167	2025-12-14 13:04:16.167	261.00	шт	8	только уп
55866	3327	ПАТИССОНЧИКИ маринованные 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	2760.00	уп (8 шт)	1	200	t	2025-12-14 13:04:16.184	2025-12-14 13:04:16.184	345.00	шт	8	только уп
55867	3327	ПЕРЧИК Мини острый 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	2926.00	уп (12 шт)	1	177	t	2025-12-14 13:04:16.198	2025-12-14 13:04:16.198	244.00	шт	12	только уп
55868	3327	ПЕРЧИК Халапеньо красный 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	2415.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.222	2025-12-14 13:04:16.222	201.00	шт	12	только уп
55869	3327	ПЕРЧИК Халапеньо острый 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	2277.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.233	2025-12-14 13:04:16.233	190.00	шт	12	только уп
55870	3327	ПИКУЛИ ДЕЛИКАТЕСНЫЕ 1415мл маринованые (огурчики) ст/б ТМ Скатерть-Самобранка	\N	\N	4630.00	уп (6 шт)	1	108	t	2025-12-14 13:04:16.258	2025-12-14 13:04:16.258	772.00	шт	6	только уп
55871	3327	ПИКУЛИ ДЕЛИКАТЕСНЫЕ 580мл маринованые (огурчики) ст/б ТМ Скатерть-Самобранка	\N	\N	4085.00	уп (12 шт)	1	172	t	2025-12-14 13:04:16.272	2025-12-14 13:04:16.272	340.00	шт	12	только уп
55872	3327	ПОМИДОРЧИКИ  в собственном соку 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	1748.00	уп (8 шт)	1	200	t	2025-12-14 13:04:16.284	2025-12-14 13:04:16.284	218.00	шт	8	только уп
55873	3327	ПОМИДОРЧИКИ  маринованные 1500мл ст/б ТМ Скатерть-Самобранка	\N	\N	2332.00	уп (6 шт)	1	200	t	2025-12-14 13:04:16.299	2025-12-14 13:04:16.299	389.00	шт	6	только уп
55874	3327	ПОМИДОРЧИКИ  маринованные 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	1739.00	уп (8 шт)	1	200	t	2025-12-14 13:04:16.313	2025-12-14 13:04:16.313	217.00	шт	8	только уп
55875	3327	ТОМАТЫ Желтые медовые маринованные 720мл ст/б ТМ Скатерть-Самобранка	\N	\N	1674.00	уп (8 шт)	1	200	t	2025-12-14 13:04:16.324	2025-12-14 13:04:16.324	209.00	шт	8	только уп
55876	3327	ТОМАТЫ Медовые маринованные 1500мл ст/б ТМ Скатерть-Самобранка	\N	\N	2249.00	уп (6 шт)	1	18	t	2025-12-14 13:04:16.338	2025-12-14 13:04:16.338	375.00	шт	6	только уп
55877	3327	ТОМАТЫ ЧЕРРИ маринованные 580мл ст/б ТМ Скатерть-Самобранка	\N	\N	2926.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.358	2025-12-14 13:04:16.358	244.00	шт	12	только уп
55878	3327	ТОМАТЫ ЧЕРРИ медовые 580мл ст/б ТМ Скатерть-Самобранка	\N	\N	3077.00	уп (12 шт)	1	60	t	2025-12-14 13:04:16.375	2025-12-14 13:04:16.375	256.00	шт	12	только уп
55879	3327	ФАСОЛЬ Отборная белая 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	1725.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.397	2025-12-14 13:04:16.397	144.00	шт	12	только уп
55880	3327	ФАСОЛЬ Отборная красная 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	1601.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.408	2025-12-14 13:04:16.408	133.00	шт	12	только уп
55881	3327	ЧЕРЕМША маринованная По-Восточному 370мл ст/б ТМ Скатерть-Самобранка	\N	\N	3160.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.419	2025-12-14 13:04:16.419	263.00	шт	12	только уп
55882	3327	ГРИБЫ шампиньоны резаные ж/б 850мл ст/б ТМ Знаток	\N	\N	2360.00	уп (12 шт)	1	45	t	2025-12-14 13:04:16.439	2025-12-14 13:04:16.439	197.00	шт	12	только уп
55883	3327	АССОРТИ марин 720мл ТМ Сонна Мера	\N	\N	3036.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.451	2025-12-14 13:04:16.451	253.00	шт	12	только уп
55884	3327	ОГУРЦЫ марин 720мл с луком ТМ Сонна Мера	\N	\N	3560.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.465	2025-12-14 13:04:16.465	297.00	шт	12	только уп
55885	3327	ОГУРЦЫ марин 720мл с острым перцем ТМ Сонна Мера	\N	\N	3560.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.479	2025-12-14 13:04:16.479	297.00	шт	12	только уп
55886	3327	ОГУРЦЫ марин 720мл с чесноком ТМ Сонна Мера	\N	\N	3574.00	уп (12 шт)	1	144	t	2025-12-14 13:04:16.495	2025-12-14 13:04:16.495	298.00	шт	12	только уп
55887	3327	ОГУРЦЫ марин 720мл хрустящие ТМ Сонна Мера	\N	\N	3560.00	уп (12 шт)	1	84	t	2025-12-14 13:04:16.513	2025-12-14 13:04:16.513	297.00	шт	12	только уп
25747	2755	ВАРЕНИКИ Бабушка Аня 430гр картофель и лук 1/10шт ТМ Санта Бремор	\N	\N	1360.00	уп (10 шт)	1	141	f	2025-11-10 01:55:58.127	2025-11-22 01:30:48.533	136.00	шт	10	\N
25748	2755	ВАРЕНИКИ Бабушка Аня 430гр картофель и шкварки 1/10шт ТМ Санта Бремор	\N	\N	1430.00	уп (10 шт)	1	139	f	2025-11-10 01:55:58.22	2025-11-22 01:30:48.533	143.00	шт	10	\N
55888	3327	ОГУРЦЫ марин Корнишоны 370мл 3-6мм ТМ Сонна Мера	\N	\N	2829.00	уп (12 шт)	1	107	t	2025-12-14 13:04:16.57	2025-12-14 13:04:16.57	236.00	шт	12	только уп
55889	3327	ОГУРЦЫ марин Корнишоны 370мл Мини ТМ Сонна Мера	\N	\N	3008.00	уп (12 шт)	1	71	t	2025-12-14 13:04:16.582	2025-12-14 13:04:16.582	251.00	шт	12	только уп
55890	3327	ОГУРЦЫ марин Корнишоны 500мл 3-6см ТМ Сонна Мера	\N	\N	3409.00	уп (12 шт)	1	99	t	2025-12-14 13:04:16.594	2025-12-14 13:04:16.594	284.00	шт	12	только уп
55891	3327	ОГУРЦЫ марин Корнишоны 500мл Мини ТМ Сонна Мера	\N	\N	3519.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.624	2025-12-14 13:04:16.624	293.00	шт	12	только уп
55892	3327	ГОРОШЕК консервир 400гр ж/б  ТМ Знаток	\N	\N	1339.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.671	2025-12-14 13:04:16.671	112.00	шт	12	только уп
55893	3327	ГОРОШЕК консервир 425гр ж/б ТМ Сыта-Загора	\N	\N	2788.00	уп (24 шт)	1	200	t	2025-12-14 13:04:16.685	2025-12-14 13:04:16.685	116.00	шт	24	только уп
55894	3327	ГОРОШЕК консервир 425мл ж/б  ТМ Добровита	\N	\N	952.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.718	2025-12-14 13:04:16.718	79.00	шт	12	только уп
55895	3327	ГОРОШЕК консервир 425мл ж/б  ТМ Прошу к столу	\N	\N	787.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.755	2025-12-14 13:04:16.755	66.00	шт	12	только уп
55896	3327	ГОРОШЕК консервир 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	1863.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.787	2025-12-14 13:04:16.787	155.00	шт	12	только уп
55897	3327	ГОРОШЕК консервир 450гр ст/б  ТМ Знаток	\N	\N	1086.00	уп (8 шт)	1	147	t	2025-12-14 13:04:16.841	2025-12-14 13:04:16.841	136.00	шт	8	только уп
55898	3327	ГОРОШЕК молодой консервир 425мл ж/б  ТМ Добровита	\N	\N	2153.00	уп (24 шт)	1	200	t	2025-12-14 13:04:16.852	2025-12-14 13:04:16.852	90.00	шт	24	только уп
55899	3327	КУКУРУЗА консервир 425мл ж/б  ТМ Добровита	\N	\N	2249.00	уп (24 шт)	1	200	t	2025-12-14 13:04:16.873	2025-12-14 13:04:16.873	94.00	шт	24	только уп
55900	3327	КУКУРУЗА консервир 425мл ж/б  ТМ Знаток	\N	\N	1408.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.886	2025-12-14 13:04:16.886	117.00	шт	12	только уп
55901	3327	КУКУРУЗА консервир 425мл ж/б  ТМ Скатерть-Самобранка	\N	\N	2070.00	уп (12 шт)	1	200	t	2025-12-14 13:04:16.901	2025-12-14 13:04:16.901	173.00	шт	12	только уп
55902	3327	КУКУРУЗА консервир 425мл ж/б  ТМ Сыта-Загора	\N	\N	2249.00	уп (24 шт)	1	200	t	2025-12-14 13:04:16.917	2025-12-14 13:04:16.917	94.00	шт	24	только уп
55903	3327	КАПУСТА квашеная бочковая (бочка + вкдадыш) 50кг	\N	\N	13800.00	кг	1	100	t	2025-12-14 13:04:16.957	2025-12-14 13:04:16.957	276.00	кг	50	поштучно
55904	3327	ОГУРЦЫ соленые бочковые (бочка + вкдадыш) 1/34кг	\N	\N	10987.00	кг	1	100	t	2025-12-14 13:04:16.973	2025-12-14 13:04:16.973	323.00	кг	34	поштучно
55905	3327	ТОМАТЫ соленые бочковые (бочка + вкдадыш) 1/31кг	\N	\N	10624.00	кг	1	100	t	2025-12-14 13:04:16.996	2025-12-14 13:04:16.996	343.00	кг	31	поштучно
55906	3327	ТОМАТЫ соленые бочковые (бочка + вкдадыш) 1/36кг	\N	\N	12337.00	кг	1	100	t	2025-12-14 13:04:17.014	2025-12-14 13:04:17.014	343.00	кг	36	поштучно
55907	3327	ТОМАТНАЯ ПАСТА  3000гр ведро ТМ Знаток	\N	\N	891.00	уп (1 шт)	1	200	t	2025-12-14 13:04:17.026	2025-12-14 13:04:17.026	891.00	шт	1	только уп
55920	3327	МАСЛИНЫ отборные 300мл  без косточки ж/б ТМ Скатерть-Самобранка	\N	\N	3367.00	уп (12 шт)	1	200	t	2025-12-14 13:04:17.343	2025-12-14 13:04:17.343	281.00	шт	12	только уп
55921	3327	МАСЛИНЫ отборные 330гр без косточки ст/б ТМ Знаток	\N	\N	4043.00	уп (12 шт)	1	164	t	2025-12-14 13:04:17.374	2025-12-14 13:04:17.374	337.00	шт	12	только уп
55922	3327	Маслины Халкидики б/к чёрные 340гр 1/12	\N	\N	3864.00	уп (12 шт)	1	200	t	2025-12-14 13:04:17.416	2025-12-14 13:04:17.416	322.00	шт	12	только уп
55923	3327	Оливки "Гигант" Греческие б/к  340гр 1/12	\N	\N	3864.00	уп (12 шт)	1	200	t	2025-12-14 13:04:17.438	2025-12-14 13:04:17.438	322.00	шт	12	только уп
55924	3327	ОЛИВКИ отборные 280гр без косточки ж/б ТМ Знаток	\N	\N	2111.00	уп (12 шт)	1	200	t	2025-12-14 13:04:17.45	2025-12-14 13:04:17.45	176.00	шт	12	только уп
55925	3327	ОЛИВКИ отборные 300мл  без косточки ж/б ТМ Скатерть-Самобранка	\N	\N	3215.00	уп (12 шт)	1	200	t	2025-12-14 13:04:17.462	2025-12-14 13:04:17.462	268.00	шт	12	только уп
55926	3327	ОЛИВКИ с анчоусом 280гр без косточки ж/б ТМ Знаток	\N	\N	2429.00	уп (12 шт)	1	9	t	2025-12-14 13:04:17.476	2025-12-14 13:04:17.476	202.00	шт	12	только уп
55927	3327	ОЛИВКИ с креветкой 280гр без косточки ж/б ТМ Знаток	\N	\N	2429.00	уп (12 шт)	1	37	t	2025-12-14 13:04:17.498	2025-12-14 13:04:17.498	202.00	шт	12	только уп
55928	3327	ОЛИВКИ с лимоном 280гр без косточки ж/б ТМ Знаток	\N	\N	2429.00	уп (12 шт)	1	88	t	2025-12-14 13:04:17.52	2025-12-14 13:04:17.52	202.00	шт	12	только уп
55929	3303	СИРОП 250мл апельсиновый ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-14 13:04:17.539	2025-12-14 13:04:17.539	152.00	шт	6	только уп
55930	3303	СИРОП 250мл вишневый ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-14 13:04:17.564	2025-12-14 13:04:17.564	152.00	шт	6	только уп
55931	3303	СИРОП 250мл Дюшес ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	150	t	2025-12-14 13:04:17.58	2025-12-14 13:04:17.58	152.00	шт	6	только уп
55932	3303	СИРОП 250мл кленовый ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-14 13:04:17.604	2025-12-14 13:04:17.604	152.00	шт	6	только уп
55933	3303	СИРОП 250мл клубничный ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-14 13:04:17.62	2025-12-14 13:04:17.62	152.00	шт	6	только уп
55934	3303	СИРОП 250мл клюквенный ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	187	t	2025-12-14 13:04:17.634	2025-12-14 13:04:17.634	152.00	шт	6	только уп
25781	2755	ПЕЛЬМЕНИ БУЛЬМЕНИ 400гр с говядиной и свининой  ТМ Горячая Штучка	\N	\N	2112.00	уп (16 шт)	1	300	f	2025-11-10 01:55:59.973	2025-11-22 01:30:48.533	132.00	шт	16	\N
55935	3303	СИРОП 250мл лимонный ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-14 13:04:17.649	2025-12-14 13:04:17.649	152.00	шт	6	только уп
55936	3303	СИРОП 250мл малиновый ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-14 13:04:17.662	2025-12-14 13:04:17.662	152.00	шт	6	только уп
55937	3303	СИРОП 250мл Черная смородина ТМ Пиканта	\N	\N	911.00	уп (6 шт)	1	200	t	2025-12-14 13:04:17.696	2025-12-14 13:04:17.696	152.00	шт	6	только уп
55938	3303	СИРОП 250мл шиповник ТМ Пиканта	\N	\N	1283.00	уп (6 шт)	1	179	t	2025-12-14 13:04:17.765	2025-12-14 13:04:17.765	214.00	шт	6	только уп
55939	3327	САЙРА масло 240гр Морское Содружество	\N	\N	8004.00	шт	1	200	t	2025-12-14 13:04:17.822	2025-12-14 13:04:17.822	167.00	шт	48	поштучно
55940	3327	САЙРА натуральная 240гр Морское Содружество	\N	\N	7894.00	шт	1	200	t	2025-12-14 13:04:17.864	2025-12-14 13:04:17.864	164.00	шт	48	поштучно
55941	3327	САЙРА натуральная 250гр ключ ТМ Барс	\N	\N	8418.00	шт	1	200	t	2025-12-14 13:04:17.894	2025-12-14 13:04:17.894	351.00	шт	24	поштучно
55942	3327	САЙРА с добавлением масла 250гр ключ ТМ Барс	\N	\N	8418.00	шт	1	200	t	2025-12-14 13:04:17.913	2025-12-14 13:04:17.913	351.00	шт	24	поштучно
55943	3327	САРДИНА 230гр т/о ИВАСИ 1/24шт ТМ Санта Бремор	\N	\N	3947.00	шт	1	6	t	2025-12-14 13:04:17.929	2025-12-14 13:04:17.929	164.00	шт	24	поштучно
55944	3327	САРДИНА атлантическая в томате (куски) 250гр ключ ТМ Барс	\N	\N	5354.00	шт	1	200	t	2025-12-14 13:04:17.941	2025-12-14 13:04:17.941	223.00	шт	24	поштучно
55945	3327	САРДИНА атлантическая масло (куски) 250гр ключ ТМ Барс	\N	\N	5023.00	шт	1	184	t	2025-12-14 13:04:17.952	2025-12-14 13:04:17.952	209.00	шт	24	поштучно
55946	3327	КИЛЬКА в томате Балтийская 240гр Рыбная Бухта	\N	\N	4030.00	шт	1	300	t	2025-12-14 13:04:17.966	2025-12-14 13:04:17.966	84.00	шт	48	поштучно
55947	3327	КИЛЬКА в томате Балтийская 250гр ключ ТМ Барс	\N	\N	3478.00	шт	1	300	t	2025-12-14 13:04:17.982	2025-12-14 13:04:17.982	145.00	шт	24	поштучно
55948	3327	КИЛЬКА в томате Балтийская в соусе По-болгарски с овощным гарниром 240гр ключ ТМ Барс	\N	\N	3560.00	шт	1	170	t	2025-12-14 13:04:17.995	2025-12-14 13:04:17.995	148.00	шт	24	поштучно
55949	3327	КИЛЬКА в томате Балтийская обжаренная 240гр ТМ Барс	\N	\N	3781.00	шт	1	300	t	2025-12-14 13:04:18.009	2025-12-14 13:04:18.009	158.00	шт	24	поштучно
55950	3327	КИЛЬКА в томате копченая Балтийская 250гр ключ ТМ Барс	\N	\N	3367.00	шт	1	300	t	2025-12-14 13:04:18.025	2025-12-14 13:04:18.025	140.00	шт	24	поштучно
55951	3327	ШПРОТЫ в масле 160гр ключ ТМ Барс	\N	\N	4168.00	шт	1	300	t	2025-12-14 13:04:18.043	2025-12-14 13:04:18.043	174.00	шт	24	поштучно
55952	3327	ШПРОТЫ в масле 175гр ключ  Ханса из балтийской кильки ТМ Барс Замок	\N	\N	2926.00	шт	1	300	t	2025-12-14 13:04:18.058	2025-12-14 13:04:18.058	244.00	шт	12	поштучно
55953	3327	ШПРОТЫ в масле 240гр ключ ТМ Барс	\N	\N	5713.00	шт	1	300	t	2025-12-14 13:04:18.078	2025-12-14 13:04:18.078	238.00	шт	24	поштучно
55954	3367	ГОРБУША натуральная 250гр Морепродукт	\N	\N	11316.00	шт	1	300	t	2025-12-14 13:04:18.09	2025-12-14 13:04:18.09	236.00	шт	48	поштучно
55955	3367	ИКРА трески натуральная 160гр ключТМ Барс	\N	\N	5106.00	шт	1	60	t	2025-12-14 13:04:18.116	2025-12-14 13:04:18.116	213.00	шт	24	поштучно
55956	3367	МОРСКАЯ КАПУСТА Салат Дальневосточный 220гр Морское Содружество	\N	\N	1642.00	шт	1	300	t	2025-12-14 13:04:18.149	2025-12-14 13:04:18.149	68.00	шт	24	поштучно
55957	3367	ПЕЧЕНЬ трески натуральная 115гр ключТМ Барс	\N	\N	4388.00	шт	1	171	t	2025-12-14 13:04:18.176	2025-12-14 13:04:18.176	366.00	шт	12	поштучно
55958	3367	СЕЛЬДЬ 175гр Атлантическая в томате филе 1/9шт ТМ Санта Бремор	\N	\N	2039.00	шт	1	10	t	2025-12-14 13:04:18.197	2025-12-14 13:04:18.197	227.00	шт	9	поштучно
55959	3367	СЕЛЬДЬ Атлантическая в сладком соусе Чили 175гр ключ Ханса ТМ Барс	\N	\N	2429.00	шт	1	108	t	2025-12-14 13:04:18.217	2025-12-14 13:04:18.217	202.00	шт	12	поштучно
55960	3367	СКУМБРИЯ 175гр Атлантическая в масле филе ключ ханса 1/9шт ТМ Санта Бремор	\N	\N	3043.00	шт	1	60	t	2025-12-14 13:04:18.231	2025-12-14 13:04:18.231	338.00	шт	9	поштучно
55961	3367	СКУМБРИЯ 175гр Атлантическая натуральная с добавлением масла филе ключ ханса 1/9шт ТМ Санта Бремор	\N	\N	2029.00	шт	1	6	t	2025-12-14 13:04:18.255	2025-12-14 13:04:18.255	225.00	шт	9	поштучно
55962	3367	СКУМБРИЯ с добавлением масла 250гр ключ ТМ Барс Северная Атлантика-20 North Atlantic N.A.	\N	\N	4177.00	шт	1	160	t	2025-12-14 13:04:18.282	2025-12-14 13:04:18.282	261.00	шт	16	поштучно
55963	3367	ТУНЕЦ в масле 120гр с перцем чили ТМ УЛЬТРАМАРИН	\N	\N	4744.00	шт	1	300	t	2025-12-14 13:04:18.294	2025-12-14 13:04:18.294	190.00	шт	25	поштучно
55964	3367	ТУНЕЦ в масле филе 250гр ТМ Барс	\N	\N	5189.00	шт	1	200	t	2025-12-14 13:04:18.306	2025-12-14 13:04:18.306	216.00	шт	24	поштучно
55965	3367	ТУНЕЦ натур 240гр ключ ТМ Знаток	\N	\N	10488.00	шт	1	112	t	2025-12-14 13:04:18.322	2025-12-14 13:04:18.322	218.00	шт	48	поштучно
55966	3367	ТУНЕЦ натуральный филе 185гр ТМ УЛЬТРАМАРИН	\N	\N	4278.00	шт	1	300	t	2025-12-14 13:04:18.348	2025-12-14 13:04:18.348	178.00	шт	24	поштучно
55967	3323	АЗЕРБАЙДЖАНСКИЙ ФРУКТ нектар 1л вишневый ст/бут 1/8шт ТМ Twist-Off	\N	\N	1095.00	уп (8 шт)	1	56	t	2025-12-14 13:04:18.371	2025-12-14 13:04:18.371	137.00	шт	8	только уп
55968	3323	АЗЕРБАЙДЖАНСКИЙ ФРУКТ сок 1л виноградный ст/бут 1/8шт ТМ Twist-Off	\N	\N	1095.00	уп (8 шт)	1	130	t	2025-12-14 13:04:18.404	2025-12-14 13:04:18.404	137.00	шт	8	только уп
55969	3323	АЗЕРБАЙДЖАНСКИЙ ФРУКТ сок 1л ежевика ст/бут 1/8шт ТМ Twist-Off	\N	\N	1095.00	уп (8 шт)	1	143	t	2025-12-14 13:04:18.437	2025-12-14 13:04:18.437	137.00	шт	8	только уп
55970	3323	АЗЕРБАЙДЖАНСКИЙ ФРУКТ сок 1л яблоко ст/бут 1/8шт ТМ Twist-Off	\N	\N	1095.00	уп (8 шт)	1	66	t	2025-12-14 13:04:18.454	2025-12-14 13:04:18.454	137.00	шт	8	только уп
55971	3323	ВИШ Виш микс нектар 2л мультифруктовый пэт 1/6шт	\N	\N	1125.00	уп (6 шт)	1	107	t	2025-12-14 13:04:18.474	2025-12-14 13:04:18.474	187.00	шт	6	только уп
25795	2755	ПЕЛЬМЕНИ Цезарь 450гр Мясо бычков	\N	\N	2736.00	уп (12 шт)	1	97	f	2025-11-10 01:56:00.865	2025-11-22 01:30:48.533	228.00	шт	12	\N
25827	2755	СУПОВОЙ НАБОР ИНДЕЙКА подложка (1шт~700гр) ТМ Индилайт	\N	\N	1290.00	уп (6 шт)	1	45	f	2025-11-10 01:56:02.666	2025-11-22 01:30:48.533	215.00	кг	6	\N
55972	3323	ВИШ Виш микс нектар 2л яблочный пэт 1/6шт	\N	\N	1125.00	уп (6 шт)	1	300	t	2025-12-14 13:04:18.488	2025-12-14 13:04:18.488	187.00	шт	6	только уп
55973	3323	ВИШ Виш нектар 1л гранатовый пэт 1/12шт	\N	\N	1759.00	уп (12 шт)	1	93	t	2025-12-14 13:04:18.567	2025-12-14 13:04:18.567	147.00	шт	12	только уп
55974	3323	ВИШ Виш нектар 1л персиковый пэт 1/12шт	\N	\N	1759.00	уп (12 шт)	1	12	t	2025-12-14 13:04:18.585	2025-12-14 13:04:18.585	147.00	шт	12	только уп
55975	3323	ВИШ Виш нектар 2л вишневый пэт 1/6шт	\N	\N	1125.00	уп (6 шт)	1	12	t	2025-12-14 13:04:18.598	2025-12-14 13:04:18.598	187.00	шт	6	только уп
55976	3323	ВОЛЖСКИЙ ПОСАД нектар 0,2л мультифрук пэт	\N	\N	854.00	уп (27 шт)	1	300	t	2025-12-14 13:04:18.613	2025-12-14 13:04:18.613	32.00	шт	27	только уп
55977	3323	ВОЛЖСКИЙ ПОСАД нектар 0,2л яблочно/персиковый пэт	\N	\N	854.00	уп (27 шт)	1	300	t	2025-12-14 13:04:18.627	2025-12-14 13:04:18.627	32.00	шт	27	только уп
55978	3323	ВОЛЖСКИЙ ПОСАД нектар 1л мультифрук пэт	\N	\N	1504.00	уп (12 шт)	1	9	t	2025-12-14 13:04:18.639	2025-12-14 13:04:18.639	125.00	шт	12	только уп
55979	3323	ВОЛЖСКИЙ ПОСАД нектар 1л яблочно/виноградный пэт	\N	\N	1504.00	уп (12 шт)	1	12	t	2025-12-14 13:04:18.652	2025-12-14 13:04:18.652	125.00	шт	12	только уп
55980	3323	ВОЛЖСКИЙ ПОСАД нектар 1л яблочно/персиковый пэт	\N	\N	1504.00	уп (12 шт)	1	132	t	2025-12-14 13:04:18.672	2025-12-14 13:04:18.672	125.00	шт	12	только уп
55981	3323	ВОЛЖСКИЙ ПОСАД нектар 2л мультифрук пэт	\N	\N	1290.00	уп (6 шт)	1	222	t	2025-12-14 13:04:18.715	2025-12-14 13:04:18.715	215.00	шт	6	только уп
55982	3323	ВОЛЖСКИЙ ПОСАД нектар 2л яблочно/персиковый пэт	\N	\N	1290.00	уп (6 шт)	1	244	t	2025-12-14 13:04:18.727	2025-12-14 13:04:18.727	215.00	шт	6	только уп
55983	3323	ВОЛЖСКИЙ ПОСАД сок 0,2л мультифрукт для детского питания с 6 мес пэт	\N	\N	994.00	уп (27 шт)	1	300	t	2025-12-14 13:04:18.74	2025-12-14 13:04:18.74	37.00	шт	27	только уп
55984	3323	ВОЛЖСКИЙ ПОСАД сок 0,2л яблочно/вишневый для детского питания с 5 мес пэт	\N	\N	994.00	уп (27 шт)	1	300	t	2025-12-14 13:04:18.762	2025-12-14 13:04:18.762	37.00	шт	27	только уп
55985	3323	ВОЛЖСКИЙ ПОСАД сок 0,2л яблочный осветленный для детского питания с 4 мес пэт	\N	\N	994.00	уп (27 шт)	1	27	t	2025-12-14 13:04:18.78	2025-12-14 13:04:18.78	37.00	шт	27	только уп
55986	3323	ВОЛЖСКИЙ ПОСАД сок 1л яблочный осветленный пэт	\N	\N	1504.00	уп (12 шт)	1	24	t	2025-12-14 13:04:18.794	2025-12-14 13:04:18.794	125.00	шт	12	только уп
55987	3323	ВОЛЖСКИЙ ПОСАД сок 2л томатный с мякотью пэт	\N	\N	1290.00	уп (6 шт)	1	228	t	2025-12-14 13:04:18.815	2025-12-14 13:04:18.815	215.00	шт	6	только уп
55988	3323	ВОЛЖСКИЙ ПОСАД сок 2л яблочный пэт	\N	\N	1290.00	уп (6 шт)	1	167	t	2025-12-14 13:04:18.827	2025-12-14 13:04:18.827	215.00	шт	6	только уп
55989	3323	ВОДА АЛТАЙ АКВА 0,5л природно артезианская газированная пэт	\N	\N	649.00	уп (12 шт)	1	200	t	2025-12-14 13:04:18.84	2025-12-14 13:04:18.84	54.00	шт	12	только уп
55990	3323	ВОДА АЛТАЙ АКВА 0,5л природно артезианская негазированная пэт	\N	\N	649.00	уп (12 шт)	1	24	t	2025-12-14 13:04:18.853	2025-12-14 13:04:18.853	54.00	шт	12	только уп
55991	3323	ВОДА АЛТАЙ АКВА 1,3л природная артезианская негазированная пэт	\N	\N	455.00	уп (6 шт)	1	34	t	2025-12-14 13:04:18.866	2025-12-14 13:04:18.866	76.00	шт	6	только уп
55992	3323	ВОДА АЛТАЙ АКВА 1,3л природно артезианская газированная пэт	\N	\N	455.00	уп (6 шт)	1	156	t	2025-12-14 13:04:18.878	2025-12-14 13:04:18.878	76.00	шт	6	только уп
55993	3323	ВОДА МОНАСТЫРСКАЯ 0,5л газированная пэт	\N	\N	814.00	уп (12 шт)	1	200	t	2025-12-14 13:04:18.89	2025-12-14 13:04:18.89	68.00	шт	12	только уп
55994	3323	ВОДА МОНАСТЫРСКАЯ 0,5л негазированная пэт	\N	\N	814.00	уп (12 шт)	1	200	t	2025-12-14 13:04:18.901	2025-12-14 13:04:18.901	68.00	шт	12	только уп
55995	3323	ВОДА МОНАСТЫРСКАЯ 1,5л газированная пэт	\N	\N	656.00	уп (6 шт)	1	200	t	2025-12-14 13:04:18.915	2025-12-14 13:04:18.915	109.00	шт	6	только уп
55996	3323	ВОДА ОЛЬСКАЯ 0,5л  газированная пэт Тальский завод	\N	\N	957.00	уп (16 шт)	1	160	t	2025-12-14 13:04:18.931	2025-12-14 13:04:18.931	60.00	шт	16	только уп
55997	3323	ВОДА ОЛЬСКАЯ 0,5л  Лимон газированная пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	176	t	2025-12-14 13:04:18.944	2025-12-14 13:04:18.944	67.00	шт	16	только уп
55998	3323	ВОДА ОЛЬСКАЯ 0,5л  Лимон негазированная пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	128	t	2025-12-14 13:04:18.955	2025-12-14 13:04:18.955	67.00	шт	16	только уп
55999	3323	ВОДА ОЛЬСКАЯ 0,5л  негазированная пэт Тальский завод	\N	\N	957.00	уп (16 шт)	1	119	t	2025-12-14 13:04:18.968	2025-12-14 13:04:18.968	60.00	шт	16	только уп
56000	3323	ВОДА ОЛЬСКАЯ 1,5л газированная пэт Тальский завод	\N	\N	800.00	уп (8 шт)	1	200	t	2025-12-14 13:04:18.98	2025-12-14 13:04:18.98	100.00	шт	8	только уп
56001	3323	ВОДА ОЛЬСКАЯ 1,5л Лимон газированная пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	153	t	2025-12-14 13:04:18.99	2025-12-14 13:04:18.99	109.00	шт	8	только уп
56002	3323	ВОДА ОЛЬСКАЯ 1,5л Лимон негазированная пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	96	t	2025-12-14 13:04:19.003	2025-12-14 13:04:19.003	109.00	шт	8	только уп
56003	3323	ВОДА ОЛЬСКАЯ 1,5л негазированная пэт Тальский завод	\N	\N	800.00	уп (8 шт)	1	200	t	2025-12-14 13:04:19.013	2025-12-14 13:04:19.013	100.00	шт	8	только уп
56004	3323	ВОДА ОЛЬСКАЯ 5л  негазированная пэт Тальский завод	\N	\N	736.00	уп (4 шт)	1	200	t	2025-12-14 13:04:19.023	2025-12-14 13:04:19.023	184.00	шт	4	только уп
25856	2755	ФИЛЕ ОКОРОЧКА КУР без кожи без кости лоток ТМ ДОМОСЕДКА	\N	\N	4850.00	уп (10 шт)	1	161	f	2025-11-10 01:56:04.463	2025-11-22 01:30:48.533	485.00	кг	10	\N
56005	3323	ВОДА СЛАВДА 1,5л Курортная газированная пэт	\N	\N	662.00	уп (6 шт)	1	18	t	2025-12-14 13:04:19.036	2025-12-14 13:04:19.036	110.00	шт	6	только уп
56006	3323	ВОДА ШМАКОВКА №1 0,5л газированная пэт	\N	\N	869.00	уп (12 шт)	1	200	t	2025-12-14 13:04:19.049	2025-12-14 13:04:19.049	72.00	шт	12	только уп
56007	3323	ВОДА ШМАКОВКА №1 1,5л газированная пэт	\N	\N	718.00	уп (6 шт)	1	200	t	2025-12-14 13:04:19.063	2025-12-14 13:04:19.063	120.00	шт	6	только уп
56008	3323	НАПИТОК БОЧКАРИ Капибара Банананааа вкус банана 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	59	t	2025-12-14 13:04:19.074	2025-12-14 13:04:19.074	92.00	шт	12	только уп
56009	3323	НАПИТОК БОЧКАРИ Капибара Кислый микс 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	59	t	2025-12-14 13:04:19.084	2025-12-14 13:04:19.084	92.00	шт	12	только уп
56010	3323	НАПИТОК БОЧКАРИ Капибара Кола 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	116	t	2025-12-14 13:04:19.105	2025-12-14 13:04:19.105	92.00	шт	12	только уп
56011	3323	НАПИТОК БОЧКАРИ Капибара Мятный буст 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	106	t	2025-12-14 13:04:19.118	2025-12-14 13:04:19.118	92.00	шт	12	только уп
56012	3323	НАПИТОК БОЧКАРИ Капибара Персик юзу 0.5л газированный пэт	\N	\N	1104.00	уп (12 шт)	1	107	t	2025-12-14 13:04:19.129	2025-12-14 13:04:19.129	92.00	шт	12	только уп
56013	3323	НАПИТОК БОЧКАРИ Кола 0,5л газированный пэт	\N	\N	1063.00	уп (12 шт)	1	24	t	2025-12-14 13:04:19.141	2025-12-14 13:04:19.141	89.00	шт	12	только уп
56014	3323	НАПИТОК БОЧКАРИ Кола 0,9л газированный пэт	\N	\N	780.00	уп (6 шт)	1	144	t	2025-12-14 13:04:19.156	2025-12-14 13:04:19.156	130.00	шт	6	только уп
56015	3323	НАПИТОК ДЮШЕС 0,5л газированный пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	84	t	2025-12-14 13:04:19.173	2025-12-14 13:04:19.173	67.00	шт	16	только уп
56016	3323	НАПИТОК ДЮШЕС 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	200	t	2025-12-14 13:04:19.185	2025-12-14 13:04:19.185	109.00	шт	8	только уп
56017	3323	НАПИТОК КОКА-КОЛА 0,5л газированная пэт	\N	\N	2153.00	уп (24 шт)	1	200	t	2025-12-14 13:04:19.198	2025-12-14 13:04:19.198	90.00	шт	24	только уп
56018	3323	НАПИТОК КОКА-КОЛА 0,88л газированная пэт Китай	\N	\N	1477.00	уп (12 шт)	1	200	t	2025-12-14 13:04:19.221	2025-12-14 13:04:19.221	123.00	шт	12	только уп
56019	3323	НАПИТОК КОКА-КОЛА 2л газ пэт Китай	\N	\N	1221.00	уп (6 шт)	1	200	t	2025-12-14 13:04:19.234	2025-12-14 13:04:19.234	204.00	шт	6	только уп
56020	3323	НАПИТОК КОЛА 1,5л газированный пэт Тальский завод	\N	\N	957.00	уп (8 шт)	1	104	t	2025-12-14 13:04:19.248	2025-12-14 13:04:19.248	120.00	шт	8	только уп
56021	3323	НАПИТОК КРЕМ СОДА 0,5л газированный пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	96	t	2025-12-14 13:04:19.292	2025-12-14 13:04:19.292	67.00	шт	16	только уп
56022	3323	НАПИТОК КРЕМ СОДА 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	200	t	2025-12-14 13:04:19.33	2025-12-14 13:04:19.33	109.00	шт	8	только уп
56023	3323	НАПИТОК ЛИМОНАД 0,5л газированный пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	176	t	2025-12-14 13:04:19.401	2025-12-14 13:04:19.401	67.00	шт	16	только уп
56024	3323	НАПИТОК ЛИМОНАД 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	200	t	2025-12-14 13:04:19.414	2025-12-14 13:04:19.414	109.00	шт	8	только уп
56025	3323	НАПИТОК МОНАСТЫРСКИЙ 0,5 Буратино газированный пэт	\N	\N	1021.00	уп (12 шт)	1	200	t	2025-12-14 13:04:19.433	2025-12-14 13:04:19.433	85.00	шт	12	только уп
56026	3323	НАПИТОК МОНАСТЫРСКИЙ 0,5 Дюшес газированный пэт	\N	\N	1021.00	уп (12 шт)	1	179	t	2025-12-14 13:04:19.449	2025-12-14 13:04:19.449	85.00	шт	12	только уп
56027	3323	НАПИТОК МОНАСТЫРСКИЙ 0,5 Спорт газированный пэт	\N	\N	1021.00	уп (12 шт)	1	110	t	2025-12-14 13:04:19.466	2025-12-14 13:04:19.466	85.00	шт	12	только уп
56028	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Ананас и Кокос газированный пэт	\N	\N	869.00	уп (6 шт)	1	192	t	2025-12-14 13:04:19.485	2025-12-14 13:04:19.485	145.00	шт	6	только уп
56029	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Апельсин газированный пэт	\N	\N	869.00	уп (6 шт)	1	114	t	2025-12-14 13:04:19.499	2025-12-14 13:04:19.499	145.00	шт	6	только уп
56030	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Буратино газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-14 13:04:19.513	2025-12-14 13:04:19.513	145.00	шт	6	только уп
56031	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Гуава - Цветы яблони газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-14 13:04:19.527	2025-12-14 13:04:19.527	145.00	шт	6	только уп
56032	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Дюшес газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-14 13:04:19.541	2025-12-14 13:04:19.541	145.00	шт	6	только уп
56033	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Лайм Мята газированный пэт	\N	\N	869.00	уп (6 шт)	1	180	t	2025-12-14 13:04:19.553	2025-12-14 13:04:19.553	145.00	шт	6	только уп
56034	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Спорт газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-14 13:04:19.564	2025-12-14 13:04:19.564	145.00	шт	6	только уп
56035	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Тархун газированный пэт	\N	\N	869.00	уп (6 шт)	1	200	t	2025-12-14 13:04:19.579	2025-12-14 13:04:19.579	145.00	шт	6	только уп
56036	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Фруктовый коктейль газированный пэт	\N	\N	869.00	уп (6 шт)	1	192	t	2025-12-14 13:04:19.59	2025-12-14 13:04:19.59	145.00	шт	6	только уп
56037	3323	НАПИТОК СПРАЙТ 0,5л газированная пэт Китай	\N	\N	2236.00	уп (24 шт)	1	178	t	2025-12-14 13:04:19.602	2025-12-14 13:04:19.602	93.00	шт	24	только уп
56038	3323	НАПИТОК СПРАЙТ 0,88л газированная пэт	\N	\N	1477.00	уп (12 шт)	1	200	t	2025-12-14 13:04:19.615	2025-12-14 13:04:19.615	123.00	шт	12	только уп
56039	3323	НАПИТОК СПРАЙТ 2л газированная пэт	\N	\N	1339.00	уп (6 шт)	1	18	t	2025-12-14 13:04:19.627	2025-12-14 13:04:19.627	223.00	шт	6	только уп
56040	3323	НАПИТОК ТАРХУН 0,5л газированный пэт Тальский завод	\N	\N	1067.00	уп (16 шт)	1	64	t	2025-12-14 13:04:19.638	2025-12-14 13:04:19.638	67.00	шт	16	только уп
56041	3323	НАПИТОК ТАРХУН 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	200	t	2025-12-14 13:04:19.651	2025-12-14 13:04:19.651	109.00	шт	8	только уп
56042	3323	НАПИТОК ТРОПИК 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	56	t	2025-12-14 13:04:19.668	2025-12-14 13:04:19.668	109.00	шт	8	только уп
56043	3323	НАПИТОК ФАНТА 0,5л газированная пэт Китай	\N	\N	2236.00	уп (24 шт)	1	192	t	2025-12-14 13:04:19.751	2025-12-14 13:04:19.751	93.00	шт	24	только уп
56044	3323	НАПИТОК ФАНТА 0,88л газированная пэт Китай	\N	\N	1477.00	уп (12 шт)	1	200	t	2025-12-14 13:04:19.81	2025-12-14 13:04:19.81	123.00	шт	12	только уп
56045	3323	НАПИТОК ФАНТА 2л газированная пэт	\N	\N	1339.00	уп (6 шт)	1	24	t	2025-12-14 13:04:19.861	2025-12-14 13:04:19.861	223.00	шт	6	только уп
56046	3323	НАПИТОК ЭКСТРАСИТРО 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	200	t	2025-12-14 13:04:19.88	2025-12-14 13:04:19.88	109.00	шт	8	только уп
56047	3323	НАПИТОК ЯБЛОКО 1,5л газированный пэт Тальский завод	\N	\N	874.00	уп (8 шт)	1	184	t	2025-12-14 13:04:19.894	2025-12-14 13:04:19.894	109.00	шт	8	только уп
56048	3393	МЫЛО туалетное 100гр Банное	\N	\N	777.00	шт	1	6	t	2025-12-14 13:04:19.906	2025-12-14 13:04:19.906	194.00	шт	4	поштучно
56049	3393	БУМАГА ТУАЛЕТНАЯ "Nuvola" Asia 3-х сл 29м	\N	\N	92.00	шт	1	300	t	2025-12-14 13:04:19.917	2025-12-14 13:04:19.917	92.00	шт	\N	поштучно
56050	3393	БУМАГА ТУАЛЕТНАЯ "Nuvola" БЕЛАЯ 2-х сл (4 рул)	\N	\N	1960.00	шт	1	88	t	2025-12-14 13:04:19.928	2025-12-14 13:04:19.928	163.00	шт	12	поштучно
56051	3393	БУМАГА ТУАЛЕТНАЯ "Soffione" Decor Blue ГОЛУБАЯ 2-х сл (4 рул)	\N	\N	2588.00	шт	1	166	t	2025-12-14 13:04:19.944	2025-12-14 13:04:19.944	259.00	шт	10	поштучно
56052	3393	БУМАГА ТУАЛЕТНАЯ "Tubum" БЕЛАЯ 2-х сл (4 рул)	\N	\N	2447.00	шт	1	300	t	2025-12-14 13:04:19.963	2025-12-14 13:04:19.963	153.00	шт	16	поштучно
56053	3393	БУМАГА ТУАЛЕТНАЯ "Veiro" Elit/Delicate БЕЛАЯ 3-х сл (4 рул)	\N	\N	3461.00	шт	1	98	t	2025-12-14 13:04:19.979	2025-12-14 13:04:19.979	346.00	шт	10	поштучно
56054	3393	БУМАГА ТУАЛЕТНАЯ "Veiro" Luxoria БЕЛАЯ 3-х сл (4 рул)	\N	\N	3116.00	шт	1	81	t	2025-12-14 13:04:19.991	2025-12-14 13:04:19.991	312.00	шт	10	поштучно
56055	3393	БУМАГА ТУАЛЕТНАЯ "Veiro" Standart Plus БЕЛАЯ 2-х сл (4 рул)	\N	\N	3398.00	шт	1	300	t	2025-12-14 13:04:20.002	2025-12-14 13:04:20.002	227.00	шт	15	поштучно
56056	3393	БУМАГА ТУАЛЕТНАЯ "Veiro" Домашняя БЕЛАЯ 2-х сл (4 рул)	\N	\N	2001.00	шт	1	300	t	2025-12-14 13:04:20.026	2025-12-14 13:04:20.026	167.00	шт	12	поштучно
56057	3393	БУМАГА ТУАЛЕТНАЯ "Лилия комфорт" БЕЛАЯ 2-х сл (4 рул)	\N	\N	1960.00	шт	1	6	t	2025-12-14 13:04:20.04	2025-12-14 13:04:20.04	163.00	шт	12	поштучно
56058	3393	ПОЛОТЕНЦА БУМАЖНЫЕ "Soffione"Maxi белые 2-х сл (1 рул)	\N	\N	4792.00	шт	1	54	t	2025-12-14 13:04:20.055	2025-12-14 13:04:20.055	532.00	шт	9	поштучно
56059	3393	ПОЛОТЕНЦА БУМАЖНЫЕ "Tubum"  белые 2-х сл (2 рул)	\N	\N	2742.00	шт	1	185	t	2025-12-14 13:04:20.066	2025-12-14 13:04:20.066	171.00	шт	16	поштучно
56060	3393	САЛФЕТКА ВИСКОЗНАЯ 22*23 "Paterra" (70шт) рулон	\N	\N	8441.00	шт	1	36	t	2025-12-14 13:04:20.079	2025-12-14 13:04:20.079	422.00	шт	20	поштучно
56061	3393	САЛФЕТКА ВИСКОЗНАЯ 30*38  "Paterra" (10шт)	\N	\N	4071.00	шт	1	47	t	2025-12-14 13:04:20.093	2025-12-14 13:04:20.093	204.00	шт	20	поштучно
56062	3393	САЛФЕТКА ВЛАЖНЫЕ "AMRA" 4 фруктовых аромата (15шт) лайм, мята, ягодный микс, ромашка	\N	\N	2153.00	шт	1	49	t	2025-12-14 13:04:20.107	2025-12-14 13:04:20.107	45.00	шт	48	поштучно
56063	3393	САЛФЕТКА ВЛАЖНЫЕ "NUVOLA" (120шт) 1/24шт	\N	\N	5051.00	шт	1	122	t	2025-12-14 13:04:20.131	2025-12-14 13:04:20.131	210.00	шт	24	поштучно
56064	3393	САЛФЕТКА ВЛАЖНЫЕ "NUVOLA" (15шт) 1/100шт	\N	\N	1955.00	шт	1	129	t	2025-12-14 13:04:20.159	2025-12-14 13:04:20.159	39.00	шт	50	поштучно
56065	3393	САЛФЕТКА ВЛАЖНЫЕ "NUVOLA" (80шт) 1/32шт	\N	\N	4931.00	шт	1	82	t	2025-12-14 13:04:20.179	2025-12-14 13:04:20.179	154.00	шт	32	поштучно
56066	3393	САЛФЕТКИ БУМАЖНЫЕ белые 24*24 "SOLFI" 1сл п/п (100шт)	\N	\N	2705.00	шт	1	300	t	2025-12-14 13:04:20.202	2025-12-14 13:04:20.202	56.00	шт	48	поштучно
56067	3393	САЛФЕТКИ БУМАЖНЫЕ в коробке "NUVOLA" Deluxe 2-х сл (150шт)	\N	\N	10419.00	шт	1	150	t	2025-12-14 13:04:20.221	2025-12-14 13:04:20.221	174.00	шт	60	поштучно
56068	3393	САЛФЕТКИ БУМАЖНЫЕ в коробке "NUVOLA" Design Red 2-х сл (200шт)	\N	\N	12144.00	шт	1	300	t	2025-12-14 13:04:20.235	2025-12-14 13:04:20.235	202.00	шт	60	поштучно
56069	3393	САЛФЕТКИ БУМАЖНЫЕ в мягкой упак  "ONE TIME"  2-х сл (200шт)	\N	\N	7590.00	шт	1	110	t	2025-12-14 13:04:20.249	2025-12-14 13:04:20.249	126.00	шт	60	поштучно
56070	3393	САЛФЕТКИ БУМАЖНЫЕ в тубе "NUVOLA" Clory 2-х сл (50шт)	\N	\N	7820.00	шт	1	7	t	2025-12-14 13:04:20.26	2025-12-14 13:04:20.26	98.00	шт	80	поштучно
56071	3393	ПЕРГАМЕНТ ДЛЯ ВЫПЕЧКИ 380мм х 6м силиконизированный натуральный Pattera	\N	\N	11930.00	шт	1	209	t	2025-12-14 13:04:20.274	2025-12-14 13:04:20.274	284.00	шт	42	поштучно
56072	3393	РУКАВ ДЛЯ ЗАПЕКАНИЯ Impacto 30см*3м в пленке	\N	\N	2875.00	шт	1	177	t	2025-12-14 13:04:20.291	2025-12-14 13:04:20.291	57.00	шт	50	поштучно
56073	3393	РУКАВ ДЛЯ ЗАПЕКАНИЯ Pattera 30см*3м в футляре с клипсами	\N	\N	2374.00	шт	1	11	t	2025-12-14 13:04:20.306	2025-12-14 13:04:20.306	99.00	шт	24	поштучно
53758	3305	МОЛОКО Северная долина 3,2% 950мл ультрапастеризованное 1/12шт	\N	\N	1642.00	уп (12 шт)	1	200	f	2025-12-07 13:19:36.01	2025-12-14 12:09:06.688	137.00	шт	12	только уп
56074	3393	ФОЛЬГА для выпечки и хранения 29см*10м в рулоне 11/12мк Pattera	\N	\N	17460.00	шт	1	300	t	2025-12-14 13:04:20.323	2025-12-14 13:04:20.323	277.00	шт	63	поштучно
56075	3393	ФОЛЬГА для выпечки и хранения 29см*10м в рулоне 8мк Горница	\N	\N	13476.00	шт	1	67	t	2025-12-14 13:04:20.337	2025-12-14 13:04:20.337	214.00	шт	63	поштучно
56076	3393	ФОЛЬГА для выпечки и хранения 29см*80м в рулоне 8мк Горница	\N	\N	51198.00	шт	1	141	t	2025-12-14 13:04:20.355	2025-12-14 13:04:20.355	853.00	шт	60	поштучно
56077	3393	ПАКЕТЫ под мусор "IMPACTO" 120л особо прочные (10 шт)	\N	\N	174.00	шт	1	119	t	2025-12-14 13:04:20.373	2025-12-14 13:04:20.373	174.00	шт	1	поштучно
56078	3393	ПАКЕТЫ под мусор "IMPACTO" 120л с завязками (20 шт)	\N	\N	424.00	шт	1	173	t	2025-12-14 13:04:20.403	2025-12-14 13:04:20.403	424.00	шт	1	поштучно
56079	3393	ПАКЕТЫ под мусор "IMPACTO" 30л особо прочные (25 шт)	\N	\N	98.00	шт	1	38	t	2025-12-14 13:04:20.416	2025-12-14 13:04:20.416	98.00	шт	1	поштучно
56080	3393	ПАКЕТЫ под мусор "IMPACTO" 30л с завязками  (25 шт)	\N	\N	160.00	шт	1	71	t	2025-12-14 13:04:20.447	2025-12-14 13:04:20.447	160.00	шт	1	поштучно
56081	3393	ПАКЕТЫ под мусор "IMPACTO" 60л (25 шт)	\N	\N	243.00	шт	1	96	t	2025-12-14 13:04:20.459	2025-12-14 13:04:20.459	243.00	шт	1	поштучно
56082	3393	ПАКЕТЫ с ручками майка синяя 43+18х65 40мк (1упаковка 50шт)  ЦЕНА ЗА 50 ШТУК	\N	\N	9695.00	шт	1	104	t	2025-12-14 13:04:20.473	2025-12-14 13:04:20.473	969.00	шт	10	поштучно
56083	3393	ПАКЕТЫ фасовочные "IMPACTO" 30мк 25х40 (1упаковка 200шт)	\N	\N	3663.00	шт	1	136	t	2025-12-14 13:04:20.49	2025-12-14 13:04:20.49	733.00	шт	5	поштучно
56084	3393	ПАКЕТЫ фасовочные в рулоне 10мк 24х37 (1упаковка 500шт)	\N	\N	12017.00	шт	1	253	t	2025-12-14 13:04:20.502	2025-12-14 13:04:20.502	633.00	шт	19	поштучно
56085	3393	ТЕРМОПАКЕТ ПВД 42*45см (3 часа) 85мк	\N	\N	35305.00	шт	1	87	t	2025-12-14 13:04:20.572	2025-12-14 13:04:20.572	353.00	шт	100	поштучно
56086	3393	ТЕРМОПАКЕТ ПВД 60*55см (3 часа) 40мк	\N	\N	35765.00	шт	1	28	t	2025-12-14 13:04:20.615	2025-12-14 13:04:20.615	358.00	шт	100	поштучно
56087	3393	ТЕРМОПАКЕТ ФОЛЬГИРОВАННЫЙ 42*45см (3 часа) 80мк	\N	\N	20930.00	шт	1	121	t	2025-12-14 13:04:20.629	2025-12-14 13:04:20.629	209.00	шт	100	поштучно
56088	3393	БАХИЛЫ для обуви 4гр синие компакт (50шт/25 пар) ЦЕНА ЗА УПАК 50шт	\N	\N	8280.00	упак	1	125	t	2025-12-14 13:04:20.644	2025-12-14 13:04:20.644	69.00	упак	120	поштучно
56089	3393	БАХИЛЫ для обуви 5гр синие компакт с двойной подошвой (100шт/50пар) ЦЕНА ЗА УПАК 100шт	\N	\N	18975.00	упак	1	87	t	2025-12-14 13:04:20.662	2025-12-14 13:04:20.662	190.00	упак	100	поштучно
56090	3393	ГУБКА металлическая для посуды из гнержавеющей стали 1шт Pattera	\N	\N	9660.00	шт	1	394	t	2025-12-14 13:04:20.675	2025-12-14 13:04:20.675	97.00	шт	100	поштучно
56091	3393	ГУБКИ для посуды 5шт Aktiv	\N	\N	6417.00	шт	1	144	t	2025-12-14 13:04:20.686	2025-12-14 13:04:20.686	143.00	шт	45	поштучно
56092	3393	ПЕРЧАТКИ ЛАТЕКСНЫЕ HIGH RISK синие "S" (50 пар)	\N	\N	1063.00	шт	1	20	t	2025-12-14 13:04:20.702	2025-12-14 13:04:20.702	1063.00	шт	1	поштучно
56093	3393	ПЕРЧАТКИ ЛАТЕКСНЫЕ HIGH RISK синие "М" (50 пар)	\N	\N	1063.00	шт	1	30	t	2025-12-14 13:04:20.721	2025-12-14 13:04:20.721	1063.00	шт	1	поштучно
56094	3393	ПЕРЧАТКИ ЛАТЕКСНЫЕ ЦЕРЕБРУМ "L" (50 пар)	\N	\N	6808.00	шт	1	85	t	2025-12-14 13:04:20.736	2025-12-14 13:04:20.736	681.00	шт	10	поштучно
56095	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 200гр Домашняя Буренка 15% с ЗМЖ Стакан МЗ Янино	\N	\N	1739.00	уп (24 шт)	1	100	t	2025-12-14 13:04:20.749	2025-12-14 13:04:20.749	72.00	шт	24	только уп
56096	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 200гр Домашняя Буренка 20% с ЗМЖ Стакан МЗ Янино	\N	\N	1932.00	уп (24 шт)	1	100	t	2025-12-14 13:04:20.777	2025-12-14 13:04:20.777	81.00	шт	24	только уп
56097	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 400гр Домашняя Буренка 15% с ЗМЖ Стакан МЗ Янино	\N	\N	2898.00	уп (24 шт)	1	100	t	2025-12-14 13:04:20.788	2025-12-14 13:04:20.788	121.00	шт	24	только уп
56098	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 400гр Домашняя Буренка 20% с ЗМЖ Стакан МЗ Янино	\N	\N	3091.00	уп (24 шт)	1	100	t	2025-12-14 13:04:20.799	2025-12-14 13:04:20.799	129.00	шт	24	только уп
56099	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 400гр Домашняя Буренка 30% с ЗМЖ Стакан МЗ Янино	\N	\N	4085.00	уп (24 шт)	1	100	t	2025-12-14 13:04:20.832	2025-12-14 13:04:20.832	170.00	шт	24	только уп
56100	3305	СМЕТАНОСОДЕРЖАЩИЙ ПРОДУКТ 5кг Домашняя Буренка 20% с ЗМЖ Ведро МЗ Янино	\N	\N	1380.00	уп (1 шт)	1	100	t	2025-12-14 13:04:20.847	2025-12-14 13:04:20.847	1380.00	шт	1	только уп
56101	3305	МОЛОКО Кокосовое 0.400 мл ТМ Tamaki	\N	\N	6679.00	уп (24 шт)	1	24	t	2025-12-14 13:04:20.87	2025-12-14 13:04:20.87	278.00	шт	24	только уп
56102	3305	МОЛОКО Кокосовое 1л ТМ Tamaki	\N	\N	7217.00	уп (12 шт)	1	12	t	2025-12-14 13:04:20.898	2025-12-14 13:04:20.898	601.00	шт	12	только уп
56103	3305	МОЛОКО Северная долина 1,5% 950мл ультрапастеризованное 1/12шт	\N	\N	1559.00	уп (12 шт)	1	200	t	2025-12-14 13:04:20.914	2025-12-14 13:04:20.914	130.00	шт	12	только уп
56104	3305	МОЛОКО Северная долина 2,5% 950мл ультрапастеризованное 1/12шт	\N	\N	1587.00	уп (12 шт)	1	200	t	2025-12-14 13:04:20.928	2025-12-14 13:04:20.928	132.00	шт	12	только уп
56105	3305	МОЛОКО Северная долина 3,2% 950мл ультрапастеризованное 1/12шт	\N	\N	1642.00	уп (12 шт)	1	200	t	2025-12-14 13:04:20.954	2025-12-14 13:04:20.954	137.00	шт	12	только уп
56106	3305	МОЛОКО Северная долина для капучино 3,2% 950мл ультрапастеризованное 1/12шт	\N	\N	1739.00	уп (12 шт)	1	200	t	2025-12-14 13:04:20.969	2025-12-14 13:04:20.969	145.00	шт	12	только уп
56107	3305	СЛИВКИ (крем сливочный) МИНСКАЯ МАРКА 33% 1л ультрапастеризованное тетрапак с крышкой,  Беларусь	\N	\N	7907.00	уп (12 шт)	1	200	t	2025-12-14 13:04:20.986	2025-12-14 13:04:20.986	659.00	шт	12	только уп
56108	3305	СЛИВКИ питьевые Молочный мир 10% 500мл стерилизованные	\N	\N	1725.00	уп (12 шт)	1	18	t	2025-12-14 13:04:21.005	2025-12-14 13:04:21.005	144.00	шт	12	только уп
56109	3305	СЛИВКИ питьевые Молочный мир 20% 500мл стерилизованные	\N	\N	2732.00	уп (12 шт)	1	12	t	2025-12-14 13:04:21.024	2025-12-14 13:04:21.024	228.00	шт	12	только уп
56110	3305	Сливки питьевые Молочный мир 33% 980гр стерилизованный	\N	\N	8404.00	уп (12 шт)	1	74	t	2025-12-14 13:04:21.04	2025-12-14 13:04:21.04	700.00	шт	12	только уп
42046	2755	ОКОРОЧОК КУР Вес 15кг БРАЗИЛИЯ	\N	\N	4640.00	уп (15 шт)	1	300	f	2025-11-30 11:02:30.822	2025-12-06 02:48:51.249	269.00	кг	15	\N
56111	3401	МАРГАРИН 170гр Домашнее утро 30% 1/40шт Фабрика Фаворит	\N	\N	1748.00	шт	1	10	t	2025-12-14 13:04:21.065	2025-12-14 13:04:21.065	44.00	шт	40	поштучно
56112	3401	МАРГАРИН 200 Хозяюшка для выпечки 75%	\N	\N	1932.00	шт	1	11	t	2025-12-14 13:04:21.076	2025-12-14 13:04:21.076	97.00	шт	20	поштучно
56113	3401	МАРГАРИН 500 Щедрое лето 72%	\N	\N	4623.00	шт	1	7	t	2025-12-14 13:04:21.089	2025-12-14 13:04:21.089	231.00	шт	20	поштучно
56114	3401	МАСЛО 120гр 82,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	2841.00	шт	1	19	t	2025-12-14 13:04:21.105	2025-12-14 13:04:21.105	284.00	шт	10	поштучно
56115	3401	МАСЛО 180гр 62% Продукты из Елани Шоколадное Еланский СК	\N	\N	3809.00	шт	1	37	t	2025-12-14 13:04:21.117	2025-12-14 13:04:21.117	317.00	шт	12	поштучно
56116	3401	МАСЛО 180гр 72,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	3783.00	шт	1	300	t	2025-12-14 13:04:21.13	2025-12-14 13:04:21.13	378.00	шт	10	поштучно
56117	3401	МАСЛО 180гр 72,5% Минская марка Крестьянское Беларусь	\N	\N	4830.00	шт	1	300	t	2025-12-14 13:04:21.142	2025-12-14 13:04:21.142	241.00	шт	20	поштучно
56118	3401	МАСЛО 180гр 72,5% Радость Вкуса Крестьянское Еланский СК	\N	\N	4292.00	шт	1	157	t	2025-12-14 13:04:21.157	2025-12-14 13:04:21.157	358.00	шт	12	поштучно
56119	3401	МАСЛО 180гр 72,5% Чулымское Крестьянское слив Фабрика Фаворит	\N	\N	7618.00	шт	1	6	t	2025-12-14 13:04:21.167	2025-12-14 13:04:21.167	317.00	шт	24	поштучно
56120	3401	МАСЛО 180гр 82,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	4082.00	шт	1	25	t	2025-12-14 13:04:21.182	2025-12-14 13:04:21.182	408.00	шт	10	поштучно
56121	3401	МАСЛО 180гр 82,5% Доярушка Традиционное	\N	\N	6624.00	шт	1	300	t	2025-12-14 13:04:21.212	2025-12-14 13:04:21.212	331.00	шт	20	поштучно
56122	3401	МАСЛО 180гр 82,5% Минская марка Беларусь	\N	\N	5035.00	шт	1	300	t	2025-12-14 13:04:21.225	2025-12-14 13:04:21.225	252.00	шт	20	поштучно
56123	3401	МАСЛО 180гр 82,5% Радость Вкуса Традиционное Еланский СК	\N	\N	4554.00	шт	1	92	t	2025-12-14 13:04:21.243	2025-12-14 13:04:21.243	379.00	шт	12	поштучно
56124	3401	МАСЛО 180гр 84%  сладкосливочное несоленое ТМ Zealandia	\N	\N	7107.00	шт	1	242	t	2025-12-14 13:04:21.256	2025-12-14 13:04:21.256	355.00	шт	20	поштучно
56125	3401	МАСЛО 360гр 82,5% Брест-Литовск сливочное ТМ Савушкин продукт	\N	\N	7820.00	шт	1	300	t	2025-12-14 13:04:21.326	2025-12-14 13:04:21.326	782.00	шт	10	поштучно
56126	3401	МАСЛО 400гр 72,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	8038.00	шт	1	300	t	2025-12-14 13:04:21.375	2025-12-14 13:04:21.375	804.00	шт	10	поштучно
56127	3401	МАСЛО 400гр 72,5% Радость Вкуса Крестьянское Еланский СК	\N	\N	4561.00	шт	1	100	t	2025-12-14 13:04:21.419	2025-12-14 13:04:21.419	760.00	шт	6	поштучно
56128	3401	МАСЛО 400гр 82,5% Брест-Литовск сладко-сливочное несоленое ТМ Савушкин продукт	\N	\N	8694.00	шт	1	300	t	2025-12-14 13:04:21.439	2025-12-14 13:04:21.439	869.00	шт	10	поштучно
56129	3401	МАСЛО 400гр 82,5% Радость Вкуса Традиционное Еланский СК	\N	\N	4761.00	шт	1	106	t	2025-12-14 13:04:21.469	2025-12-14 13:04:21.469	793.00	шт	6	поштучно
56130	3401	МАСЛО 500гр 72,5% Крестьянское Курск	\N	\N	3852.00	шт	1	294	t	2025-12-14 13:04:21.481	2025-12-14 13:04:21.481	385.00	шт	10	поштучно
56131	3401	МАСЛО 500гр 72,5%Чулымское Крестьянское слив Фабрика Фаворит	\N	\N	13984.00	шт	1	43	t	2025-12-14 13:04:21.503	2025-12-14 13:04:21.503	874.00	шт	16	поштучно
56132	3401	МАСЛО 500гр 82,5% Белорусское село Традиционное слив Фабрика Фаворит	\N	\N	15548.00	шт	1	109	t	2025-12-14 13:04:21.526	2025-12-14 13:04:21.526	972.00	шт	16	поштучно
56133	3401	МАСЛО 500гр 82,5% Традиционное Курск	\N	\N	4082.00	шт	1	300	t	2025-12-14 13:04:21.539	2025-12-14 13:04:21.539	408.00	шт	10	поштучно
53834	3305	СЫРОК Советские традиции Ваниль глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	f	2025-12-07 13:19:37.713	2025-12-14 08:12:42.416	91.00	шт	10	только уп
53833	3305	СЫРОК Советские традиции Барбарис глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	f	2025-12-07 13:19:37.701	2025-12-14 08:12:42.733	91.00	шт	10	только уп
53832	3305	СЫРОК Советские традиции  Крем-брюле глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	f	2025-12-07 13:19:37.598	2025-12-14 08:12:43.02	91.00	шт	10	только уп
53828	3305	СЫРОК Савушкин Творобушки клубника глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	18	f	2025-12-07 13:19:37.526	2025-12-14 08:12:44.512	53.00	шт	18	только уп
53827	3305	СЫРОК Савушкин Творобушки ваниль глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-12-07 13:19:37.509	2025-12-14 08:12:45.364	53.00	шт	18	только уп
53815	3305	СЫРОК А.РОСТАГРОЭКСПОРТ с Вар. сгущенкой 45гр флоупак	\N	\N	4036.00	уп (60 шт)	1	200	f	2025-12-07 13:19:37.262	2025-12-14 08:12:45.66	67.00	шт	60	только уп
53814	3305	СЫРОК А.РОСТАГРОЭКСПОРТ с Вар. сгущенкой 45гр	\N	\N	1346.00	уп (20 шт)	1	200	f	2025-12-07 13:19:37.245	2025-12-14 08:12:45.979	67.00	шт	20	только уп
53830	3305	СЫРОК Савушкин Творобушки манго глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-12-07 13:19:37.56	2025-12-14 08:21:43.18	53.00	шт	18	только уп
53829	3305	СЫРОК Савушкин Творобушки малина глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	200	f	2025-12-07 13:19:37.542	2025-12-14 08:21:43.534	53.00	шт	18	только уп
53823	3305	СЫРОК Пингвиненок Понго Картошка вареная сгущенка  глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	40	f	2025-12-07 13:19:37.418	2025-12-14 12:09:06.688	36.00	шт	20	только уп
56134	3401	МАСЛО вес 10кг 72,5% Крестьянское ГОСТ Чулымское	\N	\N	10465.00	уп (10 шт)	1	500	t	2025-12-14 13:04:21.552	2025-12-14 13:04:21.552	1047.00	кг	10	только уп
56972	3395	АБРИКОСЫ половинки вес Россия	\N	\N	3346.00	уп (10 шт)	1	500	f	2025-12-14 13:04:35.921	2025-12-15 03:13:40.234	335.00	кг	10	только уп
56135	3401	МАСЛО вес 5кг 72,5% Крестьянское ГОСТ Нижрезерв	\N	\N	4715.00	уп (5 шт)	1	500	t	2025-12-14 13:04:21.564	2025-12-14 13:04:21.564	943.00	кг	5	только уп
26008	2755	СЕЛЬДЬ ТИХООКЕАНСКАЯ мороженая 27+ 1/13кг Тихрыбком*	\N	\N	1269.00	уп (13 шт)	1	1000	f	2025-11-10 01:56:12.586	2025-11-22 01:30:48.533	97.60	кг	13	\N
56136	3401	МАСЛО вес 5кг 72,5% Крестьянское Курск ГОСТ	\N	\N	3967.00	уп (5 шт)	1	500	t	2025-12-14 13:04:21.576	2025-12-14 13:04:21.576	793.00	кг	5	только уп
56137	3401	МАСЛО вес 5кг 82,5% Традиционное ГОСТ Нижрезерв	\N	\N	5290.00	уп (5 шт)	1	110	t	2025-12-14 13:04:21.589	2025-12-14 13:04:21.589	1058.00	кг	5	только уп
56138	3401	МАСЛО вес 5кг 82,5% Традиционное Курск ГОСТ	\N	\N	4255.00	уп (5 шт)	1	500	t	2025-12-14 13:04:21.615	2025-12-14 13:04:21.615	851.00	кг	5	только уп
56139	3305	СЫРОК 36 копеек Вар сгущенка глазированный в фольге 40гр	\N	\N	652.00	уп (10 шт)	1	200	t	2025-12-14 13:04:21.66	2025-12-14 13:04:21.66	65.00	шт	10	только уп
56140	3305	СЫРОК 36 копеек Картошка вар сгущенка глазированный 40гр	\N	\N	391.00	уп (6 шт)	1	200	t	2025-12-14 13:04:21.687	2025-12-14 13:04:21.687	65.00	шт	6	только уп
56141	3305	СЫРОК 36 копеек Картошка глазированный 40гр	\N	\N	391.00	уп (6 шт)	1	200	t	2025-12-14 13:04:21.768	2025-12-14 13:04:21.768	65.00	шт	6	только уп
56142	3305	СЫРОК 36 копеек Кокосовая стружка глазированный в фольге 40гр	\N	\N	652.00	уп (10 шт)	1	140	t	2025-12-14 13:04:21.801	2025-12-14 13:04:21.801	65.00	шт	10	только уп
56143	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС  Клубника-Земляника в молочном шоколаде 50гр	\N	\N	773.00	уп (6 шт)	1	12	t	2025-12-14 13:04:21.812	2025-12-14 13:04:21.812	129.00	шт	6	только уп
56144	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с  Малиной  и фисташкой в белом шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	114	t	2025-12-14 13:04:21.865	2025-12-14 13:04:21.865	178.00	шт	6	только уп
56145	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Вишней и миндалем в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	138	t	2025-12-14 13:04:21.878	2025-12-14 13:04:21.878	178.00	шт	6	только уп
56146	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Земляникой и фисташкой в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	132	t	2025-12-14 13:04:21.891	2025-12-14 13:04:21.891	178.00	шт	6	только уп
56147	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Кленовым сиропом и грецким орехом в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	114	t	2025-12-14 13:04:21.904	2025-12-14 13:04:21.904	178.00	шт	6	только уп
56148	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Манго и семенами чиа фундук в молочном шоколаде 45гр	\N	\N	1070.00	уп (6 шт)	1	54	t	2025-12-14 13:04:21.926	2025-12-14 13:04:21.926	178.00	шт	6	только уп
56149	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Мандарином и фундуком в молочном шоколаде 45гр	\N	\N	1070.00	уп (6 шт)	1	132	t	2025-12-14 13:04:21.938	2025-12-14 13:04:21.938	178.00	шт	6	только уп
56150	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Фисташкой в белом шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	96	t	2025-12-14 13:04:21.951	2025-12-14 13:04:21.951	178.00	шт	6	только уп
56151	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Фисташкой в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	108	t	2025-12-14 13:04:21.962	2025-12-14 13:04:21.962	178.00	шт	6	только уп
56152	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС STATUS с Черешней и фисташкой в молочном шоколаде 50гр	\N	\N	1070.00	уп (6 шт)	1	90	t	2025-12-14 13:04:21.98	2025-12-14 13:04:21.98	178.00	шт	6	только уп
56153	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Ваниль в белом шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-14 13:04:22.001	2025-12-14 13:04:22.001	126.00	шт	12	только уп
56154	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Ваниль в молочном шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-14 13:04:22.014	2025-12-14 13:04:22.014	126.00	шт	12	только уп
56155	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Ваниль в темном шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	96	t	2025-12-14 13:04:22.031	2025-12-14 13:04:22.031	126.00	шт	12	только уп
56156	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Земляника в молочном шоколаде 50гр	\N	\N	1546.00	уп (12 шт)	1	108	t	2025-12-14 13:04:22.043	2025-12-14 13:04:22.043	129.00	шт	12	только уп
56157	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Картошка в молочном шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-14 13:04:22.057	2025-12-14 13:04:22.057	126.00	шт	12	только уп
56158	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Кокос в молочном шоколаде 50гр	\N	\N	773.00	уп (6 шт)	1	6	t	2025-12-14 13:04:22.073	2025-12-14 13:04:22.073	129.00	шт	6	только уп
56159	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Красный апельсин в молочном шоколаде 50гр	\N	\N	773.00	уп (6 шт)	1	12	t	2025-12-14 13:04:22.089	2025-12-14 13:04:22.089	129.00	шт	6	только уп
56160	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Малина в молочном шоколаде 50гр	\N	\N	773.00	уп (6 шт)	1	6	t	2025-12-14 13:04:22.102	2025-12-14 13:04:22.102	129.00	шт	6	только уп
56161	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Манго-Клубника в молочном шоколаде 50гр	\N	\N	773.00	уп (6 шт)	1	72	t	2025-12-14 13:04:22.117	2025-12-14 13:04:22.117	129.00	шт	6	только уп
56162	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС с Вар. сгущенкой в молочном шоколаде 50гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-14 13:04:22.129	2025-12-14 13:04:22.129	126.00	шт	12	только уп
56163	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Суфле ваниль в молочном шоколаде 40гр	\N	\N	1518.00	уп (12 шт)	1	200	t	2025-12-14 13:04:22.139	2025-12-14 13:04:22.139	126.00	шт	12	только уп
56164	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Суфле ваниль в темном шоколаде 40гр	\N	\N	1518.00	уп (12 шт)	1	168	t	2025-12-14 13:04:22.154	2025-12-14 13:04:22.154	126.00	шт	12	только уп
56165	3305	СЫРОК А.РОСТАГРОКОМПЛЕКС Суфле с вар. сгущенкой в молочном шоколаде 40гр	\N	\N	1394.00	уп (12 шт)	1	192	t	2025-12-14 13:04:22.174	2025-12-14 13:04:22.174	116.00	шт	12	только уп
53840	3305	ТВОРОГ вес 5кг 5% ТМ Заснеженная Русь	\N	\N	2478.00	уп (5 шт)	1	200	f	2025-12-07 13:19:37.836	2025-12-14 12:09:06.688	496.00	кг	5	только уп
42115	2755	СВИНИНА ШЕЯ с/м б/к вес (1кусок~1-2,5кг) ТМ Полянское	\N	\N	9712.00	уп (15 шт)	1	300	f	2025-11-30 11:02:34.294	2025-12-06 02:48:51.249	563.00	кг	15	\N
26059	2755	КРЕВЕТКА Тигровая 1кг с/м 16/20 очищенная с хвостиком Бангладеш	\N	\N	12100.00	уп (10 шт)	1	457	f	2025-11-10 01:56:15.355	2025-11-22 01:30:48.533	1210.00	шт	10	\N
56166	3305	СЫРОК Божья Коровка Ваниль глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.207	2025-12-14 13:04:22.207	36.00	шт	20	только уп
56167	3305	СЫРОК Божья Коровка Вареная сгущенка глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.225	2025-12-14 13:04:22.225	36.00	шт	20	только уп
56168	3305	СЫРОК Божья Коровка Картошка вареная сгущенка глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.238	2025-12-14 13:04:22.238	36.00	шт	20	только уп
56169	3305	СЫРОК Божья Коровка Картошка Крем-брюле глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.257	2025-12-14 13:04:22.257	36.00	шт	20	только уп
56170	3305	СЫРОК Божья Коровка Картошка с грецким орехом и сгущенкой глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.271	2025-12-14 13:04:22.271	36.00	шт	20	только уп
56171	3305	СЫРОК Божья Коровка Клубника глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.284	2025-12-14 13:04:22.284	36.00	шт	20	только уп
56172	3305	СЫРОК Божья Коровка Рожок Ваниль глазированный 40гр	\N	\N	1090.00	уп (30 шт)	1	200	t	2025-12-14 13:04:22.294	2025-12-14 13:04:22.294	36.00	шт	30	только уп
56173	3305	СЫРОК Божья Коровка Рожок Вареная сгущенка глазированный 40гр	\N	\N	1090.00	уп (30 шт)	1	200	t	2025-12-14 13:04:22.306	2025-12-14 13:04:22.306	36.00	шт	30	только уп
56174	3305	СЫРОК Божья Коровка Рожок Малина глазированный 40гр	\N	\N	1090.00	уп (30 шт)	1	200	t	2025-12-14 13:04:22.316	2025-12-14 13:04:22.316	36.00	шт	30	только уп
56175	3305	СЫРОК Пастухов Ваниль в молочном шоколаде глазированный 40гр	\N	\N	927.00	уп (9 шт)	1	189	t	2025-12-14 13:04:22.329	2025-12-14 13:04:22.329	103.00	шт	9	только уп
56176	3305	СЫРОК Пастухов Вар сгущенка в молочном шоколаде глазированный 40гр	\N	\N	927.00	уп (9 шт)	1	198	t	2025-12-14 13:04:22.341	2025-12-14 13:04:22.341	103.00	шт	9	только уп
56177	3305	СЫРОК Пингвиненок Понго Ваниль глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.358	2025-12-14 13:04:22.358	36.00	шт	20	только уп
56178	3305	СЫРОК Пингвиненок Понго Вареная сгущенка глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.373	2025-12-14 13:04:22.373	36.00	шт	20	только уп
56179	3305	СЫРОК Пингвиненок Понго Картошка вареная сгущенка  глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.398	2025-12-14 13:04:22.398	36.00	шт	20	только уп
56180	3305	СЫРОК Пингвиненок Понго Картошка крем брюле глазированный 40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.412	2025-12-14 13:04:22.412	36.00	шт	20	только уп
56181	3305	СЫРОК Пингвиненок Понго Картошка с грецким орехом со сгущенным молоком глазированный  40гр	\N	\N	727.00	уп (20 шт)	1	200	t	2025-12-14 13:04:22.439	2025-12-14 13:04:22.439	36.00	шт	20	только уп
56182	3305	СЫРОК Савушкин кокос-миндаль глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	90	t	2025-12-14 13:04:22.45	2025-12-14 13:04:22.45	53.00	шт	18	только уп
56183	3305	СЫРОК Савушкин фисташка глазированный 40гр	\N	\N	952.00	уп (18 шт)	1	126	t	2025-12-14 13:04:22.463	2025-12-14 13:04:22.463	53.00	шт	18	только уп
56184	3305	ТВОРОГ 1кг 9% м/у ТМ Савушкин	\N	\N	2815.00	уп (4 шт)	1	23	t	2025-12-14 13:04:22.48	2025-12-14 13:04:22.48	704.00	шт	4	только уп
56185	3305	ТВОРОГ вес 5кг 5% ТМ Заснеженная Русь	\N	\N	2478.00	уп (5 шт)	1	200	t	2025-12-14 13:04:22.494	2025-12-14 13:04:22.494	496.00	кг	5	только уп
56186	3305	ТВОРОГ вес 5кг Традиционный рассыпчатый 9% (крем продукт с творогм с змж) ТМ Заснеженная Русь	\N	\N	1754.00	уп (5 шт)	1	200	t	2025-12-14 13:04:22.513	2025-12-14 13:04:22.513	351.00	кг	5	только уп
56187	3305	ТВОРОГ вес 5кг Традиционный термостабильный 18% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	1811.00	уп (5 шт)	1	200	t	2025-12-14 13:04:22.576	2025-12-14 13:04:22.576	362.00	кг	5	только уп
56188	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная ваниль 23% (крем продукт термостабильный с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	200	t	2025-12-14 13:04:22.593	2025-12-14 13:04:22.593	423.00	кг	5	только уп
56189	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная изюм 23% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	160	t	2025-12-14 13:04:22.605	2025-12-14 13:04:22.605	423.00	кг	5	только уп
56190	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная клубника 23% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	135	t	2025-12-14 13:04:22.618	2025-12-14 13:04:22.618	423.00	кг	5	только уп
56191	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная курага 23% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	15	t	2025-12-14 13:04:22.633	2025-12-14 13:04:22.633	423.00	кг	5	только уп
56192	3305	ТВОРОЖНАЯ МАССА вес 5кг Традиционная шоколадная крошка 23% (крем продукт с творогом с змж) ТМ Заснеженная Русь	\N	\N	2116.00	уп (5 шт)	1	35	t	2025-12-14 13:04:22.647	2025-12-14 13:04:22.647	423.00	кг	5	только уп
56193	3391	ЗАРЕЧЕНСКИЕ Наггетсы кур Хрустящие 230гр ТМ Стародворье	\N	\N	1753.00	шт	1	8	t	2025-12-14 13:04:22.665	2025-12-14 13:04:22.665	146.00	шт	12	поштучно
56194	3391	ЗАРЕЧЕНСКИЕ Наггетсы кур Хрустящие 300гр ТМ Зареченские	\N	\N	1283.00	шт	1	245	t	2025-12-14 13:04:22.678	2025-12-14 13:04:22.678	143.00	шт	9	поштучно
56195	3391	НАГГЕТСЫ куриные запеченные с сыром 250гр ТМ ТМ Вязанка	\N	\N	2084.00	шт	1	300	t	2025-12-14 13:04:22.694	2025-12-14 13:04:22.694	174.00	шт	12	поштучно
56196	3391	НАГГЕТСЫ куриные растительные 200гр ТМ Foodgital	\N	\N	966.00	шт	1	16	t	2025-12-14 13:04:22.712	2025-12-14 13:04:22.712	161.00	шт	6	поштучно
56197	3391	НАГГЕТСЫ куриные Сливушки Из Печи 250гр ТМ ТМ Вязанка	\N	\N	2084.00	шт	1	300	t	2025-12-14 13:04:22.725	2025-12-14 13:04:22.725	174.00	шт	12	поштучно
26063	2755	КРЕВЕТКА Северная 800гр в/м 70/90 неразделанная Китай	\N	\N	8640.00	уп (12 шт)	1	390	f	2025-11-10 01:56:15.565	2025-11-22 01:30:48.533	720.00	шт	12	\N
26099	2755	ИКРА МОЙВЫ 165гр деликатесная с лососем ТМ Русское Море	\N	\N	1056.00	уп (6 шт)	1	46	f	2025-11-10 01:56:17.379	2025-11-22 01:30:48.533	176.00	шт	6	\N
56198	3391	НАГГЕТСЫ НАГЕТОСЫ куриные Сочная курочка 250гр ТМ Горячаяя штучка	\N	\N	793.00	шт	1	136	t	2025-12-14 13:04:22.738	2025-12-14 13:04:22.738	132.00	шт	6	поштучно
56199	3391	НАГГЕТСЫ НАГЕТОСЫ куриные Сочная курочка в хрустящей панировке со сметаной и зеленью 250гр ТМ Горячаяя штучка	\N	\N	925.00	шт	1	245	t	2025-12-14 13:04:22.752	2025-12-14 13:04:22.752	154.00	шт	6	поштучно
56200	3391	НАГГЕТСЫ с индейкой Сливушки Из Печи 250гр ТМ ТМ Вязанка	\N	\N	2084.00	шт	1	300	t	2025-12-14 13:04:22.776	2025-12-14 13:04:22.776	174.00	шт	12	поштучно
56201	3391	ОСНОВА для пиццы 350гр (2 штуки в коробке) ТМ Морозко	\N	\N	719.00	уп (5 шт)	1	300	t	2025-12-14 13:04:22.791	2025-12-14 13:04:22.791	144.00	шт	5	только уп
56202	3391	ОСНОВА для пиццы 450гр  (2 штуки в пакете) ТМ Цезарь	\N	\N	1187.00	уп (8 шт)	1	137	t	2025-12-14 13:04:22.805	2025-12-14 13:04:22.805	148.00	шт	8	только уп
56203	3391	ПИЦЦА Цезарь 390гр С моцареллой	\N	\N	1357.00	уп (4 шт)	1	26	t	2025-12-14 13:04:22.819	2025-12-14 13:04:22.819	339.00	шт	4	только уп
56204	3391	ПИЦЦА Цезарь 390гр Четыре сыра	\N	\N	1219.00	уп (4 шт)	1	10	t	2025-12-14 13:04:22.83	2025-12-14 13:04:22.83	305.00	шт	4	только уп
56205	3391	ПИЦЦА Цезарь 420гр С ветчиной	\N	\N	1357.00	уп (4 шт)	1	159	t	2025-12-14 13:04:22.843	2025-12-14 13:04:22.843	339.00	шт	4	только уп
56206	3391	ПИЦЦА Цезарь 420гр С ветчиной и грибами	\N	\N	1385.00	уп (4 шт)	1	49	t	2025-12-14 13:04:22.88	2025-12-14 13:04:22.88	346.00	шт	4	только уп
56207	3391	ГОРЯЧАЯ ШТУЧКА Мини- сосиска в тесте 1кг ТМ Зареченские	\N	\N	1613.00	кг	1	56	t	2025-12-14 13:04:22.894	2025-12-14 13:04:22.894	436.00	кг	4	поштучно
56208	3391	ГОРЯЧАЯ ШТУЧКА бельмеши Сочные с мясом 300гр	\N	\N	2001.00	шт	1	300	t	2025-12-14 13:04:22.906	2025-12-14 13:04:22.906	167.00	шт	12	поштучно
56209	3391	ГОРЯЧАЯ ШТУЧКА Бульмени хрустящие с мясом 220гр	\N	\N	1559.00	шт	1	300	t	2025-12-14 13:04:22.917	2025-12-14 13:04:22.917	130.00	шт	12	поштучно
56210	3391	ГОРЯЧАЯ ШТУЧКА Круггетсы из мяса птицы с сырным соусом 200гр ТМ Горячая Штучка	\N	\N	2056.00	шт	1	300	t	2025-12-14 13:04:22.944	2025-12-14 13:04:22.944	171.00	шт	12	поштучно
56211	3391	ГОРЯЧАЯ ШТУЧКА Круггетсы Сочные из мяса птицы 200гр ТМ Горячая Штучка	\N	\N	2001.00	шт	1	300	t	2025-12-14 13:04:22.968	2025-12-14 13:04:22.968	167.00	шт	12	поштучно
56212	3391	ГОРЯЧАЯ ШТУЧКА крылышки острые к пиву в панировке 300гр ТМ Горячая Штучка	\N	\N	2705.00	шт	1	300	t	2025-12-14 13:04:22.979	2025-12-14 13:04:22.979	225.00	шт	12	поштучно
56213	3391	ГОРЯЧАЯ ШТУЧКА крылышки хрустящие в панировке 300гр ТМ Горячая Штучка	\N	\N	2967.00	шт	1	300	t	2025-12-14 13:04:22.992	2025-12-14 13:04:22.992	247.00	шт	12	поштучно
56214	3391	ГОРЯЧАЯ ШТУЧКА Пекерсы с индейкой в сливочном соусе 250гр ТМ Горячая Штучка	\N	\N	1987.00	шт	1	300	t	2025-12-14 13:04:23.008	2025-12-14 13:04:23.008	166.00	шт	12	поштучно
56215	3391	ГОРЯЧАЯ ШТУЧКА пельмени Супермени куриные со сливочным маслом 200гр ТМ Горячая Штучка	\N	\N	957.00	шт	1	48	t	2025-12-14 13:04:23.023	2025-12-14 13:04:23.023	120.00	шт	8	поштучно
56216	3391	ГОРЯЧАЯ ШТУЧКА Хот-догстер 90гр ТМ Горячая Штучка	\N	\N	1897.00	шт	1	300	t	2025-12-14 13:04:23.051	2025-12-14 13:04:23.051	63.00	шт	30	поштучно
56217	3391	ГОРЯЧАЯ ШТУЧКА Хотстеры сосиска в тесте 250гр ТМ Горячая Штучка	\N	\N	2208.00	шт	1	300	t	2025-12-14 13:04:23.071	2025-12-14 13:04:23.071	184.00	шт	12	поштучно
56218	3391	ГОРЯЧАЯ ШТУЧКА Хотстеры сосиска в тесте с сыром 250гр ТМ Горячая Штучка	\N	\N	2332.00	шт	1	300	t	2025-12-14 13:04:23.085	2025-12-14 13:04:23.085	194.00	шт	12	поштучно
56219	3391	ГОРЯЧАЯ ШТУЧКА Чебуманы с говядиной 280г ТМ Горячая Штучка	\N	\N	1070.00	шт	1	300	t	2025-12-14 13:04:23.097	2025-12-14 13:04:23.097	178.00	шт	6	поштучно
56220	3391	ГОРЯЧАЯ ШТУЧКА Чебупели ветчина и сыр 240гр 1/12шт ТМ Горячая Штучка	\N	\N	1946.00	шт	1	176	t	2025-12-14 13:04:23.111	2025-12-14 13:04:23.111	162.00	шт	12	поштучно
56221	3391	ГОРЯЧАЯ ШТУЧКА Чебупели Курочка гриль 300гр ТМ Горячая Штучка	\N	\N	1900.00	шт	1	300	t	2025-12-14 13:04:23.126	2025-12-14 13:04:23.126	136.00	шт	14	поштучно
56222	3391	ГОРЯЧАЯ ШТУЧКА Чебупели острые с мясом 240гр ТМ Горячая Штучка	\N	\N	2015.00	шт	1	300	t	2025-12-14 13:04:23.157	2025-12-14 13:04:23.157	168.00	шт	12	поштучно
56223	3391	ГОРЯЧАЯ ШТУЧКА Чебупели растительные 200гр 1/6шт ТМ Горячая Штучка	\N	\N	849.00	шт	1	79	t	2025-12-14 13:04:23.171	2025-12-14 13:04:23.171	141.00	шт	6	поштучно
56224	3391	ГОРЯЧАЯ ШТУЧКА Чебупели с мясом 240гр ТМ Горячая Штучка	\N	\N	1766.00	шт	1	300	t	2025-12-14 13:04:23.193	2025-12-14 13:04:23.193	147.00	шт	12	поштучно
56225	3391	ГОРЯЧАЯ ШТУЧКА Чебупели с мясом XXL 480гр ТМ Горячая Штучка	\N	\N	2042.00	шт	1	300	t	2025-12-14 13:04:23.206	2025-12-14 13:04:23.206	255.00	шт	8	поштучно
56226	3391	ГОРЯЧАЯ ШТУЧКА Чебупели Сочные с мясом 240гр ТМ Горячая Штучка	\N	\N	1822.00	шт	1	271	t	2025-12-14 13:04:23.224	2025-12-14 13:04:23.224	152.00	шт	12	поштучно
56227	3391	ГОРЯЧАЯ ШТУЧКА Чебупицца 4 сыра 200гр ТМ Foodgital	\N	\N	1014.00	шт	1	300	t	2025-12-14 13:04:23.242	2025-12-14 13:04:23.242	169.00	шт	6	поштучно
53934	3391	БЛИНЫ Цезарь 450гр с телятиной конверт ванночка	\N	\N	5534.00	шт	1	279	f	2025-12-07 13:19:39.372	2025-12-14 12:09:06.688	461.00	шт	12	поштучно
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
56228	3391	ГОРЯЧАЯ ШТУЧКА Чебупицца Курочка по-итальянски 250гр ТМ Горячая Штучка	\N	\N	2139.00	шт	1	300	t	2025-12-14 13:04:23.279	2025-12-14 13:04:23.279	178.00	шт	12	поштучно
56229	3391	ГОРЯЧАЯ ШТУЧКА Чебупицца Маргарита 200гр ТМ Foodgital	\N	\N	1014.00	шт	1	300	t	2025-12-14 13:04:23.325	2025-12-14 13:04:23.325	169.00	шт	6	поштучно
56230	3391	ГОРЯЧАЯ ШТУЧКА Чебупицца Пепперони 250гр ТМ Горячая Штучка	\N	\N	2139.00	шт	1	300	t	2025-12-14 13:04:23.34	2025-12-14 13:04:23.34	178.00	шт	12	поштучно
56231	3391	ГОРЯЧАЯ ШТУЧКА Чебурек с мясом 90гр ТМ Горячая Штучка	\N	\N	1021.00	шт	1	300	t	2025-12-14 13:04:23.354	2025-12-14 13:04:23.354	43.00	шт	24	поштучно
56232	3391	ГОРЯЧАЯ ШТУЧКА Чебуреки растительные 360гр ТМ Foodgital	\N	\N	897.00	шт	1	82	t	2025-12-14 13:04:23.365	2025-12-14 13:04:23.365	224.00	шт	4	поштучно
56233	3391	ГОРЯЧАЯ ШТУЧКА Чебуреки растительные 90гр ТМ Foodgital	\N	\N	1352.00	шт	1	300	t	2025-12-14 13:04:23.38	2025-12-14 13:04:23.38	56.00	шт	24	поштучно
56234	3391	ГОРЯЧАЯ ШТУЧКА Чебуреки свинина и говядина 360гр ТМ Горячая Штучка	\N	\N	1644.00	шт	1	300	t	2025-12-14 13:04:23.435	2025-12-14 13:04:23.435	164.00	шт	10	поштучно
56235	3391	ЖАРЕНКИ колобки с мясом мини 300гр ТМ Морозко	\N	\N	2470.00	шт	1	210	t	2025-12-14 13:04:23.456	2025-12-14 13:04:23.456	206.00	шт	12	поштучно
56236	3391	ЖАРЕНКИ пицца мини 300гр ТМ Морозко	\N	\N	2387.00	шт	1	54	t	2025-12-14 13:04:23.469	2025-12-14 13:04:23.469	199.00	шт	12	поштучно
56237	3391	ЖАРЕНКИ самса с мясом мини 300гр ТМ Морозко	\N	\N	2305.00	шт	1	163	t	2025-12-14 13:04:23.482	2025-12-14 13:04:23.482	192.00	шт	12	поштучно
56238	3391	ЖАРЕНКИ чебурек с бараниной 125гр ТМ Морозко	\N	\N	1495.00	шт	1	300	t	2025-12-14 13:04:23.496	2025-12-14 13:04:23.496	75.00	шт	20	поштучно
56239	3391	ЖАРЕНКИ чебурек с картофелем и грибами 125гр ТМ Морозко	\N	\N	1288.00	шт	1	156	t	2025-12-14 13:04:23.531	2025-12-14 13:04:23.531	64.00	шт	20	поштучно
56240	3391	ЖАРЕНКИ чебурек с мясом Богатырь 180гр ТМ Морозко	\N	\N	1635.00	шт	1	300	t	2025-12-14 13:04:23.551	2025-12-14 13:04:23.551	91.00	шт	18	поштучно
56241	3391	ЖАРЕНКИ чебурек с мясом Вкусный 85гр ТМ Морозко	\N	\N	1840.00	шт	1	300	t	2025-12-14 13:04:23.564	2025-12-14 13:04:23.564	46.00	шт	40	поштучно
56242	3391	ЖАРЕНКИ чебурек с мясом Сочный 125гр ТМ Морозко	\N	\N	1357.00	шт	1	112	t	2025-12-14 13:04:23.574	2025-12-14 13:04:23.574	68.00	шт	20	поштучно
56243	3391	ЖАРЕНКИ чебурешки с ветчиной и сыром мини 300гр ТМ Морозко	\N	\N	2305.00	шт	1	254	t	2025-12-14 13:04:23.593	2025-12-14 13:04:23.593	192.00	шт	12	поштучно
56244	3391	ЖАРЕНКИ чебурешки с мясом мини 300гр ТМ Морозко	\N	\N	2180.00	шт	1	300	t	2025-12-14 13:04:23.605	2025-12-14 13:04:23.605	182.00	шт	12	поштучно
56245	3391	ЗАРЕЧЕНСКИЕ МЕГАЧЕБУРЕК  сочный вес 2,24кг ТМ Зареченские	\N	\N	850.00	кг	1	83	t	2025-12-14 13:04:23.62	2025-12-14 13:04:23.62	379.00	кг	2	поштучно
56246	3391	ЗАРЕЧЕНСКИЕ МИНИ-ЧЕБУРЕЧКИ  с мясом вес 5,5кг ТМ Зареченские	\N	\N	1885.00	кг	1	94	t	2025-12-14 13:04:23.63	2025-12-14 13:04:23.63	343.00	кг	6	поштучно
56247	3391	ЗАРЕЧЕНСКИЕ Мини-шарики с курочкой и сыром вес 3кг  ТМ Зареченские	\N	\N	1242.00	кг	1	12	t	2025-12-14 13:04:23.642	2025-12-14 13:04:23.642	414.00	кг	3	поштучно
56248	3391	ЗАРЕЧЕНСКИЕ Пирожки с яблоком и грушей 300гр ТМ Зареченские	\N	\N	931.00	шт	1	16	t	2025-12-14 13:04:23.653	2025-12-14 13:04:23.653	103.00	шт	9	поштучно
56249	3391	ЗАРЕЧЕНСКИЕ Чебуреки сочные вес 5кг ТМ Зареченские	\N	\N	1771.00	кг	1	175	t	2025-12-14 13:04:23.67	2025-12-14 13:04:23.67	354.00	кг	5	поштучно
56250	3391	ЗАРЕЧЕНСКИЕ Чебуречки мини с мясом 300гр ТМ Зареченские	\N	\N	1056.00	шт	1	136	t	2025-12-14 13:04:23.767	2025-12-14 13:04:23.767	117.00	шт	9	поштучно
56251	3391	ЗАРЕЧЕНСКИЕ Чебуречки мини с сыром и ветчисной 300гр ТМ Зареченские	\N	\N	931.00	шт	1	18	t	2025-12-14 13:04:23.808	2025-12-14 13:04:23.808	103.00	шт	9	поштучно
56252	3391	СТАРОДВОРЬЕ Биточки в кляре с сырным соусом 220гр ТМ Стародворье	\N	\N	1753.00	шт	1	220	t	2025-12-14 13:04:23.86	2025-12-14 13:04:23.86	146.00	шт	12	поштучно
56253	3391	СТАРОДВОРЬЕ ВАРЕНИКИ жареные с картофелем и беконом 200гр ТМ Стародворье	\N	\N	1808.00	шт	1	300	t	2025-12-14 13:04:23.88	2025-12-14 13:04:23.88	151.00	шт	12	поштучно
56254	3391	СТАРОДВОРЬЕ Жар-ладушки с  клубникой и вишней  200гр  ТМ Стародворье	\N	\N	1656.00	шт	1	130	t	2025-12-14 13:04:23.891	2025-12-14 13:04:23.891	138.00	шт	12	поштучно
56255	3391	СТАРОДВОРЬЕ Жар-ладушки яблоком и грушей  200гр  ТМ Стародворье	\N	\N	1656.00	шт	1	168	t	2025-12-14 13:04:23.904	2025-12-14 13:04:23.904	138.00	шт	12	поштучно
56256	3391	СТАРОДВОРЬЕ ПЕЛЬМЕНИ жареные с мясом 200гр ТМ Стародворье	\N	\N	1697.00	шт	1	247	t	2025-12-14 13:04:23.917	2025-12-14 13:04:23.917	141.00	шт	12	поштучно
56257	3391	СТАРОДВОРЬЕ ПЕЛЬМЕНИ жареные с мясом и сыром 200гр ТМ Стародворье	\N	\N	1808.00	шт	1	129	t	2025-12-14 13:04:23.93	2025-12-14 13:04:23.93	151.00	шт	12	поштучно
56258	3391	БЛИНЫ "Царское подворье" вес 5кг с мясом	\N	\N	1719.00	уп (5 шт)	1	50	t	2025-12-14 13:04:23.943	2025-12-14 13:04:23.943	344.00	кг	5	только уп
56259	3391	БЛИНЫ Масленица с мясом курицы вес трубочка	\N	\N	2022.00	уп (6 шт)	1	144	t	2025-12-14 13:04:23.958	2025-12-14 13:04:23.958	337.00	кг	6	только уп
56260	3391	БЛИНЫ Бабушка Аня 420г мясо 1/12шт ТМ Санта Бремор	\N	\N	2443.00	шт	1	39	t	2025-12-14 13:04:23.967	2025-12-14 13:04:23.967	204.00	шт	12	поштучно
56261	3391	БЛИНЫ Морозко 210гр с ветчиной и сыром конверт пакет	\N	\N	3317.00	шт	1	300	t	2025-12-14 13:04:23.983	2025-12-14 13:04:23.983	118.00	шт	28	поштучно
56262	3391	БЛИНЫ Морозко 210гр с мясом конверт пакет	\N	\N	2415.00	шт	1	300	t	2025-12-14 13:04:24.004	2025-12-14 13:04:24.004	86.00	шт	28	поштучно
56263	3391	БЛИНЫ Морозко 210гр с мясом кур конверт  пакет	\N	\N	2447.00	шт	1	300	t	2025-12-14 13:04:24.017	2025-12-14 13:04:24.017	87.00	шт	28	поштучно
56264	3391	БЛИНЫ Морозко 210гр с творогом конверт пакет	\N	\N	2512.00	шт	1	300	t	2025-12-14 13:04:24.034	2025-12-14 13:04:24.034	90.00	шт	28	поштучно
56265	3391	БЛИНЫ Морозко 370гр с ветчиной и сыром трубочки лоток	\N	\N	3043.00	шт	1	87	t	2025-12-14 13:04:24.046	2025-12-14 13:04:24.046	217.00	шт	14	поштучно
56266	3391	БЛИНЫ Морозко 370гр с вишней трубочки лоток	\N	\N	2399.00	шт	1	300	t	2025-12-14 13:04:24.057	2025-12-14 13:04:24.057	171.00	шт	14	поштучно
56267	3391	БЛИНЫ Морозко 370гр с клубникой трубочки лоток	\N	\N	2657.00	шт	1	280	t	2025-12-14 13:04:24.067	2025-12-14 13:04:24.067	190.00	шт	14	поштучно
56268	3391	БЛИНЫ Морозко 370гр с мясом трубочки лоток	\N	\N	2463.00	шт	1	275	t	2025-12-14 13:04:24.083	2025-12-14 13:04:24.083	176.00	шт	14	поштучно
56269	3391	БЛИНЫ Морозко 370гр с творогом трубочки лоток	\N	\N	2689.00	шт	1	253	t	2025-12-14 13:04:24.104	2025-12-14 13:04:24.104	192.00	шт	14	поштучно
56270	3391	БЛИНЫ Морозко 420гр  с мясом конверт коробка	\N	\N	2732.00	шт	1	300	t	2025-12-14 13:04:24.115	2025-12-14 13:04:24.115	228.00	шт	12	поштучно
56271	3391	БЛИНЫ Морозко 420гр с вареной сгущенкой конверт коробка	\N	\N	2291.00	шт	1	300	t	2025-12-14 13:04:24.135	2025-12-14 13:04:24.135	191.00	шт	12	поштучно
56272	3391	БЛИНЫ Морозко 420гр с ветчиной и сыром конверт коробка	\N	\N	3478.00	шт	1	300	t	2025-12-14 13:04:24.152	2025-12-14 13:04:24.152	290.00	шт	12	поштучно
56273	3391	БЛИНЫ Морозко 420гр с клубничным повидлом конверт коробка	\N	\N	2374.00	шт	1	300	t	2025-12-14 13:04:24.165	2025-12-14 13:04:24.165	198.00	шт	12	поштучно
56274	3391	БЛИНЫ Морозко 420гр с мясом кур конверт коробка	\N	\N	2567.00	шт	1	300	t	2025-12-14 13:04:24.184	2025-12-14 13:04:24.184	214.00	шт	12	поштучно
56275	3391	БЛИНЫ Морозко 420гр с мясом молодых бычков конверт коробка	\N	\N	2829.00	шт	1	300	t	2025-12-14 13:04:24.195	2025-12-14 13:04:24.195	236.00	шт	12	поштучно
56276	3391	БЛИНЫ Морозко 420гр с творогом конверт коробка	\N	\N	2429.00	шт	1	300	t	2025-12-14 13:04:24.208	2025-12-14 13:04:24.208	202.00	шт	12	поштучно
56277	3391	БЛИНЫ Царское подворье 420гр с мясом конверт ванночка	\N	\N	2111.00	шт	1	300	t	2025-12-14 13:04:24.218	2025-12-14 13:04:24.218	176.00	шт	12	поштучно
56278	3391	БЛИНЫ Царское подворье 420гр с творогом конверт ванночка	\N	\N	2236.00	шт	1	300	t	2025-12-14 13:04:24.23	2025-12-14 13:04:24.23	186.00	шт	12	поштучно
56279	3391	БЛИНЫ Цезарь 450гр с отборной ветчиной и сыром конверт ванночка	\N	\N	4858.00	шт	1	242	t	2025-12-14 13:04:24.239	2025-12-14 13:04:24.239	405.00	шт	12	поштучно
56280	3391	БЛИНЫ Цезарь 450гр с творогом деревенским конверт ванночка	\N	\N	3698.00	шт	1	250	t	2025-12-14 13:04:24.25	2025-12-14 13:04:24.25	308.00	шт	12	поштучно
56281	3391	БЛИНЫ Цезарь 450гр с телятиной конверт ванночка	\N	\N	5534.00	шт	1	267	t	2025-12-14 13:04:24.261	2025-12-14 13:04:24.261	461.00	шт	12	поштучно
56282	3391	Азу из курицы с картоф пюре 350гр ТМ Сытоедов	\N	\N	3047.00	шт	1	120	t	2025-12-14 13:04:24.272	2025-12-14 13:04:24.272	305.00	шт	10	поштучно
56283	3391	Азу с рисом из отборной говядины 350гр ТМ Сытоедов	\N	\N	4784.00	шт	1	132	t	2025-12-14 13:04:24.283	2025-12-14 13:04:24.283	478.00	шт	10	поштучно
56284	3391	Бефстроганов из говядины с карт/пюре 320гр ТМ Сытоедов	\N	\N	4209.00	шт	1	154	t	2025-12-14 13:04:24.295	2025-12-14 13:04:24.295	421.00	шт	10	поштучно
56285	3391	Бифштекс из говядины с карт/пюре 350гр  ТМ Сытоедов	\N	\N	3185.00	шт	1	207	t	2025-12-14 13:04:24.307	2025-12-14 13:04:24.307	319.00	шт	10	поштучно
56286	3391	Горбушка по царски с картофельным пюре 300гр ТМ Главобед	\N	\N	3045.00	шт	1	60	t	2025-12-14 13:04:24.317	2025-12-14 13:04:24.317	381.00	шт	8	поштучно
56287	3391	Горбушка по царски с рисом 300гр ТМ Главобед	\N	\N	3045.00	шт	1	77	t	2025-12-14 13:04:24.329	2025-12-14 13:04:24.329	381.00	шт	8	поштучно
56288	3391	Грудка куриная в тесте в соусе Сюпрем и карт пюре 350гр ТМ Сытоедов	\N	\N	3392.00	шт	1	169	t	2025-12-14 13:04:24.344	2025-12-14 13:04:24.344	339.00	шт	10	поштучно
56289	3391	Гуляш из говядины с лапшой 300гр ТМ Главобед	\N	\N	3275.00	шт	1	175	t	2025-12-14 13:04:24.356	2025-12-14 13:04:24.356	409.00	шт	8	поштучно
56290	3391	Гуляш из говядины с рисом 300гр ТМ Главобед	\N	\N	3487.00	шт	1	145	t	2025-12-14 13:04:24.369	2025-12-14 13:04:24.369	436.00	шт	8	поштучно
56291	3391	Гуляш из свинины с гречкой 300гр ТМ Сытоедов	\N	\N	2174.00	шт	1	174	t	2025-12-14 13:04:24.394	2025-12-14 13:04:24.394	217.00	шт	10	поштучно
56292	3391	Гуляш из свинины с карт/пюре 300гр ТМ Сытоедов	\N	\N	2369.00	шт	1	208	t	2025-12-14 13:04:24.405	2025-12-14 13:04:24.405	237.00	шт	10	поштучно
56293	3391	Гуляш с макаронами 350гр ТМ Сытоедов	\N	\N	4807.00	шт	1	39	t	2025-12-14 13:04:24.416	2025-12-14 13:04:24.416	481.00	шт	10	поштучно
56294	3391	Жюльен из курицы с грибами 2*125гр ТМ Сытоедов	\N	\N	4099.00	шт	1	118	t	2025-12-14 13:04:24.43	2025-12-14 13:04:24.43	342.00	шт	12	поштучно
56295	3391	Жюльен с белыми грибами и шампиньонами 2*125гр ТМ Сытоедов	\N	\N	4513.00	шт	1	104	t	2025-12-14 13:04:24.442	2025-12-14 13:04:24.442	376.00	шт	12	поштучно
56296	3391	Запеканка творожная ванильная 240гр ТМ Главсуп	\N	\N	3321.00	шт	1	13	t	2025-12-14 13:04:24.46	2025-12-14 13:04:24.46	415.00	шт	8	поштучно
56297	3391	Запеканка творожная с шоколадом и кокосом 240гр ТМ Главобед	\N	\N	3717.00	шт	1	23	t	2025-12-14 13:04:24.474	2025-12-14 13:04:24.474	465.00	шт	8	поштучно
56298	3391	Запеканка творожно-тыквенная с лимоном и корицей 240гр ТМ Главобед	\N	\N	2990.00	шт	1	14	t	2025-12-14 13:04:24.484	2025-12-14 13:04:24.484	374.00	шт	8	поштучно
56299	3391	Зраза куриная фаршированная сыром с рисом 300гр ТМ Сытоедов	\N	\N	3036.00	шт	1	145	t	2025-12-14 13:04:24.495	2025-12-14 13:04:24.495	304.00	шт	10	поштучно
56300	3391	Каша из зеленой гречки на кокосовом молоке с ананасом 250гр ТМ Главобед	\N	\N	2484.00	шт	1	22	t	2025-12-14 13:04:24.507	2025-12-14 13:04:24.507	311.00	шт	8	поштучно
56301	3391	Колбаска куриная с феттучини под сливочным соусом 300гр ТМ Сытоедов	\N	\N	3852.00	шт	1	44	t	2025-12-14 13:04:24.573	2025-12-14 13:04:24.573	385.00	шт	10	поштучно
56302	3391	Колбаска Мюнхенская с карт пюре под соусом Барбекю 300гр ТМ Сытоедов	\N	\N	3093.00	шт	1	151	t	2025-12-14 13:04:24.591	2025-12-14 13:04:24.591	309.00	шт	10	поштучно
56303	3391	Котлета Кокетка с картофельным пюре под красным соусом Бешамель 350гр ТМ Сытоедов	\N	\N	3312.00	шт	1	259	t	2025-12-14 13:04:24.602	2025-12-14 13:04:24.602	331.00	шт	10	поштучно
56304	3391	Котлета куриная с гречкой 300гр ТМ Главобед	\N	\N	2217.00	шт	1	128	t	2025-12-14 13:04:24.615	2025-12-14 13:04:24.615	277.00	шт	8	поштучно
56305	3391	Котлета куриная с карт пюре под белым грибным соусом 350гр ТМ Сытоедов	\N	\N	3381.00	шт	1	151	t	2025-12-14 13:04:24.627	2025-12-14 13:04:24.627	338.00	шт	10	поштучно
56306	3391	Котлета по-домашнему с гречкой и гриб соус 300гр ТМ Сытоедов	\N	\N	2082.00	шт	1	157	t	2025-12-14 13:04:24.639	2025-12-14 13:04:24.639	208.00	шт	10	поштучно
56307	3391	Котлета по-Киевски с рисом 300гр ТМ Сытоедов	\N	\N	3657.00	шт	1	186	t	2025-12-14 13:04:24.65	2025-12-14 13:04:24.65	366.00	шт	10	поштучно
56308	3391	Котлета с картофельным пюре 300гр ТМ Главобед	\N	\N	2364.00	шт	1	160	t	2025-12-14 13:04:24.661	2025-12-14 13:04:24.661	296.00	шт	8	поштучно
56309	3391	Котлета с макаронами и томатным соусо 300гр ТМ Сытоедов	\N	\N	2415.00	шт	1	236	t	2025-12-14 13:04:24.672	2025-12-14 13:04:24.672	241.00	шт	10	поштучно
56310	3391	Курица в соусе Терияки с рисом 300гр ТМ Главобед	\N	\N	3183.00	шт	1	121	t	2025-12-14 13:04:24.687	2025-12-14 13:04:24.687	398.00	шт	8	поштучно
56311	3391	Лапша WOK Удон с говядиной и овощами 300гр ТМ Главобед	\N	\N	2581.00	шт	1	109	t	2025-12-14 13:04:24.699	2025-12-14 13:04:24.699	430.00	шт	6	поштучно
56312	3391	Лапша WOK Удон с курицей и овощами 300гр ТМ Главобед	\N	\N	2091.00	шт	1	115	t	2025-12-14 13:04:24.709	2025-12-14 13:04:24.709	348.00	шт	6	поштучно
56313	3391	Лапша по-китайски с курицей 300гр ТМ Главобед	\N	\N	2834.00	шт	1	78	t	2025-12-14 13:04:24.72	2025-12-14 13:04:24.72	354.00	шт	8	поштучно
56314	3391	Лапша с курицей в соусе Хойсин 300гр ТМ Главобед	\N	\N	2972.00	шт	1	77	t	2025-12-14 13:04:24.732	2025-12-14 13:04:24.732	371.00	шт	8	поштучно
56315	3391	Люля-Кебаб с рисом и соусом Ткемали 300гр ТМ Сытоедов	\N	\N	3887.00	шт	1	134	t	2025-12-14 13:04:24.742	2025-12-14 13:04:24.742	389.00	шт	10	поштучно
56316	3391	Макароны по-флотски 300гр ТМ Главобед	\N	\N	2640.00	шт	1	156	t	2025-12-14 13:04:24.769	2025-12-14 13:04:24.769	330.00	шт	8	поштучно
56317	3391	Макароны по-флотски 300гр ТМ Сытоедов	\N	\N	3093.00	шт	1	164	t	2025-12-14 13:04:24.781	2025-12-14 13:04:24.781	309.00	шт	10	поштучно
56318	3391	Паста Болоньезе 300гр ТМ Сытоедов	\N	\N	2512.00	шт	1	146	t	2025-12-14 13:04:24.792	2025-12-14 13:04:24.792	314.00	шт	8	поштучно
56319	3391	Паста Болоньезе с мясным фаршем 300гр ТМ Главобед	\N	\N	2254.00	шт	1	40	t	2025-12-14 13:04:24.805	2025-12-14 13:04:24.805	282.00	шт	8	поштучно
56320	3391	Паста Карбонара 300гр ТМ Главобед	\N	\N	1690.00	шт	1	88	t	2025-12-14 13:04:24.816	2025-12-14 13:04:24.816	282.00	шт	6	поштучно
56321	3391	Паста Палермо с курицей и грибами 300гр ТМ Сытоедов	\N	\N	2650.00	шт	1	155	t	2025-12-14 13:04:24.828	2025-12-14 13:04:24.828	331.00	шт	8	поштучно
56322	3391	Паста с ветчиной и сыром в соусе Бешамель 300гр ТМ Главобед	\N	\N	2870.00	шт	1	87	t	2025-12-14 13:04:24.841	2025-12-14 13:04:24.841	359.00	шт	8	поштучно
56323	3391	Паста с курицей в соусе Том ям 300гр ТМ Главобед	\N	\N	3211.00	шт	1	108	t	2025-12-14 13:04:24.869	2025-12-14 13:04:24.869	401.00	шт	8	поштучно
56324	3391	Печень по-Строгановски с карт пюре 350гр ТМ Сытоедов	\N	\N	3956.00	шт	1	164	t	2025-12-14 13:04:24.881	2025-12-14 13:04:24.881	396.00	шт	10	поштучно
54017	3356	ВАРЕНИКИ Бабушка Аня 430гр клубника 1/10шт ТМ Санта Бремор	\N	\N	2254.00	шт	1	11	f	2025-12-07 13:19:40.796	2025-12-14 08:12:39.162	225.00	шт	10	поштучно
54015	3356	ВАРЕНИКИ Бабушка Аня 430гр картофель и лук 1/10шт ТМ Санта Бремор	\N	\N	1564.00	шт	1	16	f	2025-12-07 13:19:40.761	2025-12-14 08:12:39.536	156.00	шт	10	поштучно
54031	3356	МАНТЫ Южные 800гр ТМ 4 сочных порции	\N	\N	4260.00	шт	1	300	f	2025-12-07 13:19:40.967	2025-12-14 12:09:06.688	532.00	шт	8	поштучно
56325	3391	Плов с курицей 300гр ТМ Главобед	\N	\N	2880.00	шт	1	146	t	2025-12-14 13:04:24.895	2025-12-14 13:04:24.895	360.00	шт	8	поштучно
56326	3391	Плов с курицей 300гр ТМ Сытоедов	\N	\N	2990.00	шт	1	281	t	2025-12-14 13:04:24.91	2025-12-14 13:04:24.91	299.00	шт	10	поштучно
56327	3391	Плов со свининой и пряностями  300гр ТМ Сытоедов	\N	\N	3427.00	шт	1	115	t	2025-12-14 13:04:24.92	2025-12-14 13:04:24.92	343.00	шт	10	поштучно
56328	3391	Поджарка из свинины с картофельным пюре 300гр ТМ Главобед	\N	\N	3386.00	шт	1	106	t	2025-12-14 13:04:24.95	2025-12-14 13:04:24.95	423.00	шт	8	поштучно
56329	3391	Суп Борщ оригинальный 250гр ТМ Главсуп	\N	\N	2512.00	шт	1	214	t	2025-12-14 13:04:24.963	2025-12-14 13:04:24.963	209.00	шт	12	поштучно
56330	3391	Суп Борщ с курицей 250гр ТМ Главсуп	\N	\N	2098.00	шт	1	148	t	2025-12-14 13:04:24.974	2025-12-14 13:04:24.974	175.00	шт	12	поштучно
56331	3391	Суп Борщ с курицей XL 360гр ТМ Главсуп	\N	\N	1297.00	шт	1	89	t	2025-12-14 13:04:24.987	2025-12-14 13:04:24.987	216.00	шт	6	поштучно
56332	3391	Суп Борщ Черниговский 300гр ТМ Сытоедов	\N	\N	3047.00	шт	1	253	t	2025-12-14 13:04:24.999	2025-12-14 13:04:24.999	305.00	шт	10	поштучно
56333	3391	Суп Гороховый с копченостями 250гр ТМ Главсуп	\N	\N	2015.00	шт	1	286	t	2025-12-14 13:04:25.012	2025-12-14 13:04:25.012	168.00	шт	12	поштучно
56334	3391	Суп Гороховый с копченостями 250гр ТМ Сытоедов	\N	\N	1646.00	шт	1	232	t	2025-12-14 13:04:25.027	2025-12-14 13:04:25.027	183.00	шт	9	поштучно
56335	3391	Суп Лагман с говядиной 250гр ТМ Главсуп	\N	\N	3105.00	шт	1	289	t	2025-12-14 13:04:25.039	2025-12-14 13:04:25.039	259.00	шт	12	поштучно
56336	3391	Суп Лапша Домашняя с курицей 300гр тарелка ТМ Сытоедов	\N	\N	2668.00	шт	1	165	t	2025-12-14 13:04:25.065	2025-12-14 13:04:25.065	267.00	шт	10	поштучно
56337	3391	Суп Лапша с курицей 250гр ТМ Главсуп	\N	\N	2180.00	шт	1	100	t	2025-12-14 13:04:25.079	2025-12-14 13:04:25.079	182.00	шт	12	поштучно
56338	3391	Суп Лапша с фрикадельками 250гр ТМ Главсуп	\N	\N	2070.00	шт	1	300	t	2025-12-14 13:04:25.092	2025-12-14 13:04:25.092	173.00	шт	12	поштучно
56339	3391	Суп Рассольник Галицкий 300гр тарелка ТМ Сытоедов	\N	\N	2622.00	шт	1	117	t	2025-12-14 13:04:25.103	2025-12-14 13:04:25.103	262.00	шт	10	поштучно
56340	3391	Суп Рассольник с курицей 250гр ТМ Главсуп	\N	\N	2029.00	шт	1	132	t	2025-12-14 13:04:25.117	2025-12-14 13:04:25.117	169.00	шт	12	поштучно
56341	3391	Суп Солянка мясная по-Новгородски 300гр тарелка ТМ Сытоедов	\N	\N	2933.00	шт	1	129	t	2025-12-14 13:04:25.129	2025-12-14 13:04:25.129	293.00	шт	10	поштучно
56342	3391	Суп Солянка по-домашнему XL 360гр ТМ Главсуп	\N	\N	1325.00	шт	1	92	t	2025-12-14 13:04:25.142	2025-12-14 13:04:25.142	221.00	шт	6	поштучно
56343	3391	Суп Сычуаньский китайский 250гр 250гр ТМ Главсуп	\N	\N	2981.00	шт	1	39	t	2025-12-14 13:04:25.155	2025-12-14 13:04:25.155	248.00	шт	12	поштучно
56344	3391	Суп Том Ям 360гр ТМ Главсуп премиум	\N	\N	2760.00	шт	1	67	t	2025-12-14 13:04:25.166	2025-12-14 13:04:25.166	460.00	шт	6	поштучно
56345	3391	Суп Уха финская из лосося 360гр ТМ Главсуп	\N	\N	2463.00	шт	1	17	t	2025-12-14 13:04:25.184	2025-12-14 13:04:25.184	411.00	шт	6	поштучно
56346	3391	Суп Уха янтарная 250гр ТМ Главсуп	\N	\N	2098.00	шт	1	99	t	2025-12-14 13:04:25.194	2025-12-14 13:04:25.194	175.00	шт	12	поштучно
56347	3391	Суп Фо Бо 360гр ТМ Главсуп премиум	\N	\N	2629.00	шт	1	212	t	2025-12-14 13:04:25.231	2025-12-14 13:04:25.231	438.00	шт	6	поштучно
56348	3391	Суп Харчо с бараниной 300гр ТМ Сытоедов	\N	\N	3312.00	шт	1	159	t	2025-12-14 13:04:25.249	2025-12-14 13:04:25.249	331.00	шт	10	поштучно
56349	3391	Суп Щи по-деревенский 250гр ТМ Главсуп	\N	\N	2029.00	шт	1	40	t	2025-12-14 13:04:25.262	2025-12-14 13:04:25.262	169.00	шт	12	поштучно
56350	3391	Суп-Крем сырный 360гр ТМ Главсуп Премиум	\N	\N	2305.00	шт	1	16	t	2025-12-14 13:04:25.32	2025-12-14 13:04:25.32	384.00	шт	6	поштучно
56351	3391	Суп-пюре из шампиньонов со сливками 250гр ТМ Главсуп	\N	\N	3077.00	шт	1	42	t	2025-12-14 13:04:25.331	2025-12-14 13:04:25.331	256.00	шт	12	поштучно
56352	3391	Тефтели с гречкой под овощным соусом 350гр ТМ Сытоедов	\N	\N	3266.00	шт	1	106	t	2025-12-14 13:04:25.344	2025-12-14 13:04:25.344	327.00	шт	10	поштучно
56353	3391	Феттучини с мясом цыпленка под соусом Морней 350гр ТМ Сытоедов	\N	\N	3990.00	шт	1	19	t	2025-12-14 13:04:25.404	2025-12-14 13:04:25.404	399.00	шт	10	поштучно
56354	3391	Шницель с картофельным пюре под красным соусом 350гр ТМ Сытоедов	\N	\N	3266.00	шт	1	185	t	2025-12-14 13:04:25.416	2025-12-14 13:04:25.416	327.00	шт	10	поштучно
54443	3367	САЛАТ 500гр из Морской капусты с корейской морковью ТМ Рыбный День	\N	\N	1615.00	шт	1	23	f	2025-12-07 13:19:47.975	2025-12-14 08:12:25.754	269.00	шт	6	поштучно
54439	3367	САЛАТ 500гр из Моркови "По-Корейски"  пл/лотокТМ Рыбный День	\N	\N	1884.00	шт	1	139	f	2025-12-07 13:19:47.925	2025-12-14 08:12:26.684	314.00	шт	6	поштучно
54452	3367	ПЕЛЬМЕНИ Премиум рыбные с кальмаром 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	4554.00	шт	1	27	f	2025-12-07 13:19:48.079	2025-12-14 08:20:30.111	304.00	шт	15	поштучно
56355	3391	ПЕЛЬМЕНИ "Морозко" вес 6кг Особые	\N	\N	2056.00	уп (6 шт)	1	228	t	2025-12-14 13:04:25.428	2025-12-14 13:04:25.428	343.00	кг	6	только уп
56356	3391	ПЕЛЬМЕНИ "Пельменный Мастер" вес 6кг Классические (класс1шт- 26мм)	\N	\N	2277.00	уп (6 шт)	1	174	t	2025-12-14 13:04:25.445	2025-12-14 13:04:25.445	379.00	кг	6	только уп
56357	3391	ПЕЛЬМЕНИ БУЛЬМЕНИ вес 5кг с говядиной и свининой  ТМ Горячая Штучка	\N	\N	1351.00	уп (5 шт)	1	240	t	2025-12-14 13:04:25.459	2025-12-14 13:04:25.459	270.00	кг	5	только уп
56358	3391	ХИНКАЛИ мини вес ТМ Морозко	\N	\N	2190.00	уп (7 шт)	1	14	t	2025-12-14 13:04:25.472	2025-12-14 13:04:25.472	313.00	кг	7	только уп
56359	3356	ВАРЕНИКИ 4 сочных порции 800гр картофель шкварки	\N	\N	2144.00	шт	1	300	t	2025-12-14 13:04:25.484	2025-12-14 13:04:25.484	268.00	шт	8	поштучно
56360	3356	ВАРЕНИКИ Бабушка Аня 430гр картофель и грибы 1/10шт ТМ Санта Бремор	\N	\N	1644.00	шт	1	37	t	2025-12-14 13:04:25.502	2025-12-14 13:04:25.502	164.00	шт	10	поштучно
56361	3356	ВАРЕНИКИ Бабушка Аня 430гр картофель и шкварки 1/10шт ТМ Санта Бремор	\N	\N	1644.00	шт	1	50	t	2025-12-14 13:04:25.515	2025-12-14 13:04:25.515	164.00	шт	10	поштучно
56362	3356	ВАРЕНИКИ Большая кастрюля Экспресс с картофелем 200гр стакан ЗАЛЕЙ КИПЯТКОМ и ВАРИ 4 МИН В СВЧ	\N	\N	3001.00	шт	1	73	t	2025-12-14 13:04:25.527	2025-12-14 13:04:25.527	167.00	шт	18	поштучно
56363	3356	ВАРЕНИКИ Вари вареники 450гр вишня	\N	\N	2585.00	шт	1	95	t	2025-12-14 13:04:25.537	2025-12-14 13:04:25.537	323.00	шт	8	поштучно
56364	3356	ВАРЕНИКИ Вари вареники 450гр клубника	\N	\N	1978.00	шт	1	145	t	2025-12-14 13:04:25.548	2025-12-14 13:04:25.548	247.00	шт	8	поштучно
56365	3356	ВАРЕНИКИ Вари вареники 800гр картофель грибы	\N	\N	1501.00	шт	1	300	t	2025-12-14 13:04:25.563	2025-12-14 13:04:25.563	300.00	шт	5	поштучно
56366	3356	ВАРЕНИКИ Вари вареники 800гр Картофель и сыр	\N	\N	2703.00	шт	1	300	t	2025-12-14 13:04:25.58	2025-12-14 13:04:25.58	270.00	шт	10	поштучно
56367	3356	ВАРЕНИКИ Вари вареники 800гр свежая капуста	\N	\N	3254.00	шт	1	300	t	2025-12-14 13:04:25.592	2025-12-14 13:04:25.592	325.00	шт	10	поштучно
56368	3356	ВАРЕНИКИ Морозко 350гр Домашние с картофелем	\N	\N	1725.00	шт	1	222	t	2025-12-14 13:04:25.604	2025-12-14 13:04:25.604	115.00	шт	15	поштучно
56369	3356	ВАРЕНИКИ Морозко 350гр Домашние с творогом	\N	\N	2432.00	шт	1	58	t	2025-12-14 13:04:25.621	2025-12-14 13:04:25.621	162.00	шт	15	поштучно
56370	3356	ВАРЕНИКИ Морозко 900гр Домашние с картофелем	\N	\N	2199.00	шт	1	35	t	2025-12-14 13:04:25.637	2025-12-14 13:04:25.637	275.00	шт	8	поштучно
56371	3356	БУУЗЫ Бурятские 825гр	\N	\N	8542.00	шт	1	12	t	2025-12-14 13:04:25.649	2025-12-14 13:04:25.649	712.00	шт	12	поштучно
56372	3356	МАНТЫ Южные 800гр ТМ 4 сочных порции	\N	\N	4260.00	шт	1	300	t	2025-12-14 13:04:25.66	2025-12-14 13:04:25.66	532.00	шт	8	поштучно
56373	3356	ПЕЛЬМЕНИ  4 сочных порции 800гр С говядиной и свининой	\N	\N	4950.00	шт	1	300	t	2025-12-14 13:04:25.671	2025-12-14 13:04:25.671	619.00	шт	8	поштучно
56374	3356	ПЕЛЬМЕНИ  4 сочных порции Комбо 2пак пельмени+2пак вареники 800гр	\N	\N	3220.00	шт	1	300	t	2025-12-14 13:04:25.767	2025-12-14 13:04:25.767	402.00	шт	8	поштучно
56375	3356	ПЕЛЬМЕНИ  Зареченские Домашние говядина и свинина 700гр	\N	\N	2012.00	шт	1	300	t	2025-12-14 13:04:25.796	2025-12-14 13:04:25.796	201.00	шт	10	поштучно
56376	3356	ПЕЛЬМЕНИ  Зареченские Домашние со сливочным маслом 700гр	\N	\N	2012.00	шт	1	300	t	2025-12-14 13:04:25.808	2025-12-14 13:04:25.808	201.00	шт	10	поштучно
56377	3356	ПЕЛЬМЕНИ  Стародворье Мясные с говядиной 1кг	\N	\N	1570.00	шт	1	162	t	2025-12-14 13:04:25.823	2025-12-14 13:04:25.823	314.00	шт	5	поштучно
56378	3356	ПЕЛЬМЕНИ  Стародворье Отборные Медвежье ушко говядина 430гр	\N	\N	2558.00	шт	1	96	t	2025-12-14 13:04:25.869	2025-12-14 13:04:25.869	160.00	шт	16	поштучно
56379	3356	ПЕЛЬМЕНИ  Стародворье Отборные Медвежье ушко говядина 900гр	\N	\N	2539.00	шт	1	40	t	2025-12-14 13:04:25.887	2025-12-14 13:04:25.887	317.00	шт	8	поштучно
56380	3356	ПЕЛЬМЕНИ  Стародворье Отборные Медвежье ушко свинина/говядина 430гр	\N	\N	2484.00	шт	1	164	t	2025-12-14 13:04:25.9	2025-12-14 13:04:25.9	155.00	шт	16	поштучно
56381	3356	ПЕЛЬМЕНИ  Стародворье Отборные Медвежье ушко свинина/говядина 900гр	\N	\N	2539.00	шт	1	115	t	2025-12-14 13:04:25.914	2025-12-14 13:04:25.914	317.00	шт	8	поштучно
56382	3356	ПЕЛЬМЕНИ Большая кастрюлька 800гр  Для самых главных (детские)	\N	\N	2639.00	шт	1	17	t	2025-12-14 13:04:25.926	2025-12-14 13:04:25.926	528.00	шт	5	поштучно
56383	3356	ПЕЛЬМЕНИ Большая кастрюля 400гр Классические с говядиной и свининой	\N	\N	3974.00	шт	1	300	t	2025-12-14 13:04:25.94	2025-12-14 13:04:25.94	331.00	шт	12	поштучно
56384	3356	ПЕЛЬМЕНИ Большая кастрюля 750гр Классические Фирменные с говядиной и свининой	\N	\N	4393.00	шт	1	239	t	2025-12-14 13:04:25.952	2025-12-14 13:04:25.952	439.00	шт	10	поштучно
56385	3356	ПЕЛЬМЕНИ Большая кастрюля 800гр Классические с говядиной и свининой	\N	\N	7190.00	шт	1	300	t	2025-12-14 13:04:25.966	2025-12-14 13:04:25.966	599.00	шт	12	поштучно
56386	3356	ПЕЛЬМЕНИ Большая кастрюля 800гр По-особому	\N	\N	7190.00	шт	1	300	t	2025-12-14 13:04:25.98	2025-12-14 13:04:25.98	599.00	шт	12	поштучно
56387	3356	ПЕЛЬМЕНИ Большая кастрюля 800гр Сливочные	\N	\N	7190.00	шт	1	300	t	2025-12-14 13:04:25.992	2025-12-14 13:04:25.992	599.00	шт	12	поштучно
56388	3356	ПЕЛЬМЕНИ Большая кастрюля 800гр Сочные	\N	\N	7259.00	шт	1	275	t	2025-12-14 13:04:26.002	2025-12-14 13:04:26.002	605.00	шт	12	поштучно
56389	3356	ПЕЛЬМЕНИ Большая кастрюля MAX 800гр Классические с говядиной и свининой	\N	\N	5762.00	шт	1	300	t	2025-12-14 13:04:26.014	2025-12-14 13:04:26.014	576.00	шт	10	поштучно
56390	3356	ПЕЛЬМЕНИ Большая кастрюля Экспресс по-домашнему 200гр стакан ЗАЛЕЙ КИПЯТКОМ и ВАРИ 4 МИН В СВЧ	\N	\N	4637.00	шт	1	179	t	2025-12-14 13:04:26.027	2025-12-14 13:04:26.027	258.00	шт	18	поштучно
56391	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 400гр с говядиной и свининой  ТМ Горячая Штучка	\N	\N	2429.00	шт	1	300	t	2025-12-14 13:04:26.04	2025-12-14 13:04:26.04	152.00	шт	16	поштучно
56392	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 400гр с говядиной и свининой БИГБУЛИ ТМ Горячая Штучка	\N	\N	2650.00	шт	1	300	t	2025-12-14 13:04:26.052	2025-12-14 13:04:26.052	166.00	шт	16	поштучно
56393	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 400гр со сливочным маслом  ТМ Горячая Штучка	\N	\N	2447.00	шт	1	300	t	2025-12-14 13:04:26.062	2025-12-14 13:04:26.062	153.00	шт	16	поштучно
56394	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр с говядиной и свининой  ТМ Горячая Штучка	\N	\N	2565.00	шт	1	300	t	2025-12-14 13:04:26.072	2025-12-14 13:04:26.072	256.00	шт	10	поштучно
56395	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр с говядиной и свининой БИГБУЛИ ТМ Горячая Штучка	\N	\N	2714.00	шт	1	300	t	2025-12-14 13:04:26.083	2025-12-14 13:04:26.083	271.00	шт	10	поштучно
56396	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр с говядиной и свининой с оливковым маслом ТМ Горячая Штучка	\N	\N	3588.00	шт	1	300	t	2025-12-14 13:04:26.095	2025-12-14 13:04:26.095	359.00	шт	10	поштучно
56397	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр с сочной грудинкой Мегавкусище БИГБУЛИ ТМ Горячая Штучка	\N	\N	2852.00	шт	1	300	t	2025-12-14 13:04:26.11	2025-12-14 13:04:26.11	285.00	шт	10	поштучно
56398	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр со сливочным маслом  ТМ Горячая Штучка	\N	\N	2588.00	шт	1	300	t	2025-12-14 13:04:26.121	2025-12-14 13:04:26.121	259.00	шт	10	поштучно
56399	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ 700гр со сливочным маслом БИГБУЛИ ТМ Горячая Штучка	\N	\N	2645.00	шт	1	300	t	2025-12-14 13:04:26.137	2025-12-14 13:04:26.137	265.00	шт	10	поштучно
56400	3356	ПЕЛЬМЕНИ БУЛЬМЕНИ НЕЙРОБУСТ 600гр с говядиной и свининой  ТМ Горячая Штучка	\N	\N	3312.00	шт	1	300	t	2025-12-14 13:04:26.149	2025-12-14 13:04:26.149	331.00	шт	10	поштучно
56401	3356	ПЕЛЬМЕНИ ГРАНДМЕНИ 700гр с говядиной ТМ Горячая Штучка ЦЕНА НИЖЕ - старая цена 437	\N	\N	2806.00	шт	1	175	t	2025-12-14 13:04:26.163	2025-12-14 13:04:26.163	351.00	шт	8	поштучно
56402	3356	ПЕЛЬМЕНИ ГРАНДМЕНИ 700гр со сливочным маслом ТМ Горячая Штучка	\N	\N	2640.00	шт	1	162	t	2025-12-14 13:04:26.174	2025-12-14 13:04:26.174	330.00	шт	8	поштучно
56403	3356	ПЕЛЬМЕНИ Малышок 500гр Особые	\N	\N	4002.00	шт	1	100	t	2025-12-14 13:04:26.186	2025-12-14 13:04:26.186	200.00	шт	20	поштучно
56404	3356	ПЕЛЬМЕНИ Растительные Foodgital 430гр ТМ Горячая Штучка	\N	\N	1886.00	шт	1	51	t	2025-12-14 13:04:26.2	2025-12-14 13:04:26.2	236.00	шт	8	поштучно
56405	3356	ПЕЛЬМЕНИ Цезарь 450гр Гордость Сибири	\N	\N	5106.00	шт	1	296	t	2025-12-14 13:04:26.214	2025-12-14 13:04:26.214	255.00	шт	20	поштучно
56406	3356	ПЕЛЬМЕНИ Цезарь 450гр Мясо бычков	\N	\N	3146.00	шт	1	63	t	2025-12-14 13:04:26.23	2025-12-14 13:04:26.23	262.00	шт	12	поштучно
56407	3356	ПЕЛЬМЕНИ Цезарь 450гр Царское застолье	\N	\N	5221.00	шт	1	43	t	2025-12-14 13:04:26.24	2025-12-14 13:04:26.24	261.00	шт	20	поштучно
56408	3356	ПЕЛЬМЕНИ Цезарь 600гр Классика	\N	\N	4934.00	шт	1	300	t	2025-12-14 13:04:26.257	2025-12-14 13:04:26.257	329.00	шт	15	поштучно
56409	3356	ПЕЛЬМЕНИ Цезарь 750гр Мясо бычков	\N	\N	5230.00	шт	1	96	t	2025-12-14 13:04:26.267	2025-12-14 13:04:26.267	436.00	шт	12	поштучно
56410	3356	ПЕЛЬМЕНИ Цезарь 750гр Царское застолье	\N	\N	3413.00	шт	1	154	t	2025-12-14 13:04:26.28	2025-12-14 13:04:26.28	427.00	шт	8	поштучно
56411	3356	ПЕЛЬМЕНИ Цезарь 800гр Гордость Сибири	\N	\N	5285.00	шт	1	300	t	2025-12-14 13:04:26.291	2025-12-14 13:04:26.291	440.00	шт	12	поштучно
56412	3356	ПЕЛЬМЕНИ Цезарь 800гр Император	\N	\N	6238.00	шт	1	300	t	2025-12-14 13:04:26.305	2025-12-14 13:04:26.305	520.00	шт	12	поштучно
56413	3356	ПЕЛЬМЕНИ Цезарь 800гр Иркутские	\N	\N	5410.00	шт	1	300	t	2025-12-14 13:04:26.318	2025-12-14 13:04:26.318	451.00	шт	12	поштучно
56414	3356	ПЕЛЬМЕНИ Цезарь 800гр Классика	\N	\N	5189.00	шт	1	300	t	2025-12-14 13:04:26.336	2025-12-14 13:04:26.336	432.00	шт	12	поштучно
56415	3356	ПЕЛЬМЕНИ Цезарь 800гр Куриные	\N	\N	2953.00	шт	1	222	t	2025-12-14 13:04:26.349	2025-12-14 13:04:26.349	369.00	шт	8	поштучно
56416	3356	ПЕЛЬМЕНИ Цезарь 800гр Фирменные мини	\N	\N	4913.00	шт	1	300	t	2025-12-14 13:04:26.363	2025-12-14 13:04:26.363	409.00	шт	12	поштучно
56417	3356	ПЕЛЬМЕНИ Цезарь 900гр Классические	\N	\N	3947.00	шт	1	300	t	2025-12-14 13:04:26.376	2025-12-14 13:04:26.376	493.00	шт	8	поштучно
56418	3356	ХИНКАЛИ Цезарь 800гр	\N	\N	6601.00	шт	1	104	t	2025-12-14 13:04:26.389	2025-12-14 13:04:26.389	660.00	шт	10	поштучно
56419	3391	КОТЛЕТЫ растительные 180гр ТМ Foodgital	\N	\N	1014.00	шт	1	29	t	2025-12-14 13:04:26.401	2025-12-14 13:04:26.401	169.00	шт	6	поштучно
56420	3391	ТЕСТО 1кг слоеное бездрожжевое (пласт) ТМ Морозко	\N	\N	3027.00	шт	1	300	t	2025-12-14 13:04:26.414	2025-12-14 13:04:26.414	378.00	шт	8	поштучно
56421	3391	ТЕСТО 1кг слоеное дрожжевое (пласт) ТМ Морозко	\N	\N	3027.00	шт	1	300	t	2025-12-14 13:04:26.436	2025-12-14 13:04:26.436	378.00	шт	8	поштучно
56422	3391	ТЕСТО 400гр слоеное бездрожжевое (пласт) ТМ Морозко	\N	\N	2836.00	шт	1	300	t	2025-12-14 13:04:26.447	2025-12-14 13:04:26.447	158.00	шт	18	поштучно
56423	3391	ТЕСТО 400гр слоеное дрожжевое (пласт) ТМ Морозко	\N	\N	2836.00	шт	1	300	t	2025-12-14 13:04:26.458	2025-12-14 13:04:26.458	158.00	шт	18	поштучно
54101	3310	ПЛЕЧЕВАЯ ЧАСТЬ КРЫЛА ИНДЕЙКА вес Казахстан	\N	\N	4437.00	уп (16 шт)	1	7	f	2025-12-07 13:19:42.052	2025-12-14 08:12:35.366	270.00	кг	16	только уп
54099	3310	БЕДРО ИНДЕЙКА вес ТМ Индилайт	\N	\N	7998.00	уп (13 шт)	1	15	f	2025-12-07 13:19:42.006	2025-12-14 08:12:35.704	615.00	кг	13	только уп
54093	3323	ХЛЕБ Итальянский деревенский зерновой (чиабатта) 300гр замороженный п/ф высокой степени готовности ТМ Владхлеб	\N	\N	876.00	уп (6 шт)	1	200	f	2025-12-07 13:19:41.875	2025-12-14 08:12:36.025	146.00	шт	6	только уп
54106	3310	ГОЛЕНЬ ИНДЕЙКА индивидуальная упаковка (1шт~500гр)ТМ Индилайт	\N	\N	2192.00	кг	1	5	f	2025-12-07 13:19:42.117	2025-12-14 08:21:42.845	362.00	кг	6	поштучно
54103	3310	ФИЛЕ ГРУДКИ ИНДЕЙКА вес Агро-плюс	\N	\N	5949.00	уп (10 шт)	1	20	f	2025-12-07 13:19:42.08	2025-12-14 12:09:06.688	610.00	кг	10	только уп
54119	3310	ГРУДКА КУР (цыплят-бройлеров) с кожей вес Межениновская ПФ	\N	\N	4428.00	уп (10 шт)	1	300	f	2025-12-07 13:19:42.348	2025-12-14 12:09:06.688	443.00	кг	10	только уп
56424	3397	САМСА с мясом из слоеного бездрожжевого теста 150гр замороженный п/ф ТМ Владхлеб	\N	\N	6670.00	уп (50 шт)	1	150	t	2025-12-14 13:04:26.469	2025-12-14 13:04:26.469	133.00	шт	50	только уп
56425	3397	СДОБА с брусникой из сдобного дрожжевого теста 115гр замороженный п/ф ТМ Владхлеб	\N	\N	5290.00	уп (50 шт)	1	200	t	2025-12-14 13:04:26.481	2025-12-14 13:04:26.481	106.00	шт	50	только уп
56426	3397	СДОБА с маком из сдобного дрожжевого теста 145гр замороженный п/ф ТМ Владхлеб	\N	\N	2156.00	уп (25 шт)	1	200	t	2025-12-14 13:04:26.492	2025-12-14 13:04:26.492	86.00	шт	25	только уп
26347	2755	КЛУБНИКА вес  Египет	\N	\N	2800.00	уп (10 шт)	1	500	f	2025-11-10 01:56:29.743	2025-11-22 01:30:48.533	280.00	кг	10	\N
26356	2755	СМЕСЬ КОМПОТНАЯ ((абрикос,яблоко,слива) вес	\N	\N	2200.00	уп (10 шт)	1	500	f	2025-11-10 01:56:30.175	2025-11-22 01:30:48.533	220.00	кг	10	\N
56427	3397	СДОБА Сосиска в тесте из сдобного дрожжевого теста 110гр замороженный п/ф ТМ Владхлеб	\N	\N	3933.00	уп (30 шт)	1	180	t	2025-12-14 13:04:26.502	2025-12-14 13:04:26.502	131.00	шт	30	только уп
56428	3397	СЛОЙКА Азовская с Сосиской 95гр пф заморож сл дрож тесто ТМ"ВЛАДХЛЕБ"	\N	\N	5520.00	уп (50 шт)	1	200	t	2025-12-14 13:04:26.564	2025-12-14 13:04:26.564	110.00	шт	50	только уп
56429	3397	СЛОЙКА ветчина и сыр из слоеного дрожжевого теста 65гр замороженный п/ф Аппетитные вкусняшки ТМ Владхлеб	\N	\N	3852.00	уп (50 шт)	1	100	t	2025-12-14 13:04:26.588	2025-12-14 13:04:26.588	77.00	шт	50	только уп
56430	3397	СЛОЙКА с вишней из слоеного дрожжевого теста 100гр замороженный п/ф Аппетитные вкусняшки ТМ Владхлеб	\N	\N	3622.00	уп (50 шт)	1	200	t	2025-12-14 13:04:26.603	2025-12-14 13:04:26.603	72.00	шт	50	только уп
56431	3397	СЛОЙКА с курицей из слоеного дрожжевого теста 90гр замороженный п/ф Аппетитные вкусняшки ТМ Владхлеб	\N	\N	4600.00	уп (50 шт)	1	150	t	2025-12-14 13:04:26.616	2025-12-14 13:04:26.616	92.00	шт	50	только уп
56432	3397	ХАЧАПУРИ с сыром слоеного бездрожжевого теста 100гр замороженный п/ф ТМ Владхлеб	\N	\N	3076.00	уп (25 шт)	1	200	t	2025-12-14 13:04:26.64	2025-12-14 13:04:26.64	123.00	шт	25	только уп
56433	3310	ГОЛЕНЬ ИНДЕЙКА вес Агро-плюс	\N	\N	2661.00	уп (10 шт)	1	154	t	2025-12-14 13:04:26.657	2025-12-14 13:04:26.657	276.00	кг	10	только уп
56434	3310	ПЛЕЧЕВАЯ ЧАСТЬ КРЫЛА ИНДЕЙКА вес ТМ Индилайт	\N	\N	4170.00	уп (14 шт)	1	38	t	2025-12-14 13:04:26.667	2025-12-14 13:04:26.667	298.00	кг	14	только уп
56435	3310	ФИЛЕ БЕДРА ИНДЕЙКА вес ТМ Индилайт	\N	\N	9807.00	уп (13 шт)	1	25	t	2025-12-14 13:04:26.682	2025-12-14 13:04:26.682	754.00	кг	13	только уп
56436	3310	ФИЛЕ ГРУДКИ ИНДЕЙКА вес Агро-плюс	\N	\N	5949.00	уп (10 шт)	1	10	t	2025-12-14 13:04:26.701	2025-12-14 13:04:26.701	610.00	кг	10	только уп
56437	3310	ФИЛЕ ГРУДКИ ИНДЕЙКА вес ТМ Индилайт	\N	\N	8708.00	уп (12 шт)	1	13	t	2025-12-14 13:04:26.715	2025-12-14 13:04:26.715	725.00	кг	12	только уп
56438	3310	ГОЛЕНЬ ИНДЕЙКА БЕСКОСТНАЯ подложка (1шт~750гр)ТМ Индилайт	\N	\N	507.00	шт	1	300	t	2025-12-14 13:04:26.726	2025-12-14 13:04:26.726	507.00	шт	\N	поштучно
56439	3310	ГОЛЕНЬ ИНДЕЙКА подложка (1шт~900гр)ТМ Индилайт	\N	\N	326.00	шт	1	292	t	2025-12-14 13:04:26.737	2025-12-14 13:04:26.737	326.00	шт	\N	поштучно
56440	3310	КРЫЛО ПЛЕЧЕВАЯ ЧАСТЬ ИНДЕЙКА подложка (1шт~800гр) ТМ Индилайт	\N	\N	262.00	шт	1	162	t	2025-12-14 13:04:26.749	2025-12-14 13:04:26.749	262.00	шт	\N	поштучно
56441	3310	КРЫЛО ЦЕЛОЕ ИНДЕЙКА резаное подложка (1шт~800гр) ТМ Индилайт	\N	\N	299.00	шт	1	300	t	2025-12-14 13:04:26.775	2025-12-14 13:04:26.775	299.00	шт	\N	поштучно
56442	3310	ПЕЧЕНЬ ИНДЕЙКА в/у (1шт~1кг) Казахстан	\N	\N	431.00	шт	1	45	t	2025-12-14 13:04:26.787	2025-12-14 13:04:26.787	431.00	шт	\N	поштучно
56443	3310	УТЕНОК Окорочок скин лоток (1шт~0,5кг) ВЕС ТМ Улыбино	\N	\N	394.00	шт	1	115	t	2025-12-14 13:04:26.798	2025-12-14 13:04:26.798	394.00	шт	\N	поштучно
56444	3310	УТЕНОК Тушка 1 сорт потрошен в/у пакет (1шт~1,2кг) ТМ Озерка	\N	\N	399.00	шт	1	300	t	2025-12-14 13:04:26.808	2025-12-14 13:04:26.808	399.00	шт	\N	поштучно
56445	3310	УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	624.00	шт	1	81	t	2025-12-14 13:04:26.819	2025-12-14 13:04:26.819	624.00	шт	\N	поштучно
56446	3310	БЕДРО КУР на кости с кожей вес Межениновская ПФ	\N	\N	2978.00	уп (10 шт)	1	300	t	2025-12-14 13:04:26.831	2025-12-14 13:04:26.831	298.00	кг	10	только уп
56447	3310	БЕДРО КУР на кости с кожей вес ТМ Благояр	\N	\N	3312.00	уп (12 шт)	1	300	t	2025-12-14 13:04:26.846	2025-12-14 13:04:26.846	276.00	кг	12	только уп
56448	3310	ГОЛЕНЬ КУР вес Межениновскаф ПФ	\N	\N	3772.00	уп (10 шт)	1	175	t	2025-12-14 13:04:26.871	2025-12-14 13:04:26.871	377.00	кг	10	только уп
56449	3310	ГОЛЕНЬ КУР вес ТМ Благояр	\N	\N	3850.00	уп (12 шт)	1	300	t	2025-12-14 13:04:26.892	2025-12-14 13:04:26.892	321.00	кг	12	только уп
56450	3310	ГРУДКА КУР (цыплят-бройлеров) с кожей вес Межениновская ПФ	\N	\N	4428.00	уп (10 шт)	1	300	t	2025-12-14 13:04:26.903	2025-12-14 13:04:26.903	443.00	кг	10	только уп
56451	3310	КРЫЛО КУР (3 фаланги) укладка ёлочкой ГОСТ вес ТМ Домоседка	\N	\N	8165.00	уп (20 шт)	1	180	t	2025-12-14 13:04:26.913	2025-12-14 13:04:26.913	408.00	кг	20	только уп
56452	3310	КРЫЛО КУР вес Межениновская ПФ	\N	\N	4025.00	уп (10 шт)	1	300	t	2025-12-14 13:04:26.923	2025-12-14 13:04:26.923	402.00	кг	10	только уп
56453	3310	КРЫЛО КУР вес ТМ Благояр	\N	\N	4761.00	уп (12 шт)	1	300	t	2025-12-14 13:04:26.952	2025-12-14 13:04:26.952	397.00	кг	12	только уп
56454	3310	ОКОРОЧОК КУР Вес 15кг БРАЗИЛИЯ	\N	\N	4640.00	уп (15 шт)	1	300	t	2025-12-14 13:04:26.963	2025-12-14 13:04:26.963	309.00	кг	15	только уп
54152	3310	ЦЫПЛЕНОК-КОРНИШОН Ярославль белый 700гр ЦЕНА ЗА ШТ	\N	\N	7825.00	шт	1	177	f	2025-12-07 13:19:42.914	2025-12-14 08:12:33.045	435.00	шт	18	поштучно
54151	3310	ЦЫПЛЕНОК-КОРНИШОН СУДАНСКИЙ БРОЙЛЕР (1шт-350-400гр) ЦЕНА ЗА ШТ	\N	\N	5750.00	шт	1	6	f	2025-12-07 13:19:42.904	2025-12-14 08:21:42.139	288.00	шт	20	поштучно
54145	3310	ФИЛЕ ОКОРОЧКА КУР без кожи без кости лоток ТМ ДОМОСЕДКА	\N	\N	5578.00	уп (10 шт)	1	27	f	2025-12-07 13:19:42.835	2025-12-14 08:21:42.499	558.00	кг	10	только уп
54124	3310	ОКОРОЧОК КУР Вес 15кг БРАЗИЛИЯ	\N	\N	4640.00	уп (15 шт)	1	300	f	2025-12-07 13:19:42.569	2025-12-14 12:09:06.688	309.00	кг	15	только уп
54125	3310	ОКОРОЧОК КУР вес для жарки Халяль ТМ Благояр	\N	\N	3767.00	уп (13 шт)	1	300	f	2025-12-07 13:19:42.587	2025-12-14 12:09:06.688	290.00	кг	13	только уп
56455	3310	ОКОРОЧОК КУР вес для жарки Халяль ТМ Благояр	\N	\N	3767.00	уп (13 шт)	1	300	t	2025-12-14 13:04:26.985	2025-12-14 13:04:26.985	290.00	кг	13	только уп
56456	3310	ОКОРОЧОК КУР Деликатесный сухой заморозки вес В/Уп ТМ Домоседка КРАСНЫЙ СКОТЧ	\N	\N	307.00	кг	1	36	t	2025-12-14 13:04:26.996	2025-12-14 13:04:26.996	307.00	кг	\N	только уп
56457	3310	ФИЛЕ БЕДРА КУР бескостное без кожи вес ТД ДОМОСЕДКА	\N	\N	9488.00	уп (15 шт)	1	15	t	2025-12-14 13:04:27.007	2025-12-14 13:04:27.007	633.00	кг	15	только уп
56458	3310	ФИЛЕ ГРУДКИ КУР без кости без кожи вес Межениновская ПФ	\N	\N	5624.00	уп (10 шт)	1	300	t	2025-12-14 13:04:27.021	2025-12-14 13:04:27.021	562.00	кг	10	только уп
56459	3310	ФИЛЕ ГРУДКИ КУР без кости без кожи вес ТМ Благояр	\N	\N	8849.00	уп (15 шт)	1	300	t	2025-12-14 13:04:27.032	2025-12-14 13:04:27.032	590.00	кг	15	только уп
56460	3310	БЕДРО КУР на кости с кожей  подложка (1шт-1кг)  МЕЖЕНИНОВСКАЯ ПФ	\N	\N	2990.00	шт	1	211	t	2025-12-14 13:04:27.042	2025-12-14 13:04:27.042	299.00	шт	10	поштучно
56461	3310	ГОЛЕНЬ КУР подложка (1шт~900гр) ТМ КУРИНОЕ ЦАРСТВО	\N	\N	346.00	шт	1	8	t	2025-12-14 13:04:27.053	2025-12-14 13:04:27.053	346.00	шт	\N	поштучно
56462	3310	ГОЛЕНЬ КУР подложка (1шт~950гр) ТМ БЛАГОЯР	\N	\N	349.00	шт	1	300	t	2025-12-14 13:04:27.065	2025-12-14 13:04:27.065	349.00	шт	\N	поштучно
56463	3310	ГОЛЕНЬ КУР подложка (1шт~950гр) ТМ БЛАГОЯР Халяль	\N	\N	344.00	шт	1	53	t	2025-12-14 13:04:27.076	2025-12-14 13:04:27.076	344.00	шт	\N	поштучно
56464	3310	ГОЛЕНЬ КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	3806.00	шт	1	300	t	2025-12-14 13:04:27.088	2025-12-14 13:04:27.088	381.00	шт	10	поштучно
56465	3310	ГРУДКА КУР с кожей подложка (1шт~950гр)  МЕЖЕНИНОВСКАЯ ПФ	\N	\N	4543.00	шт	1	11	t	2025-12-14 13:04:27.099	2025-12-14 13:04:27.099	454.00	шт	10	поштучно
56466	3310	ЖЕЛУДКИ КУР подложка (1шт~900гр) ТМ БЛАГОЯР	\N	\N	206.00	шт	1	300	t	2025-12-14 13:04:27.111	2025-12-14 13:04:27.111	206.00	шт	\N	поштучно
56467	3310	ЖЕЛУДКИ КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	3059.00	шт	1	300	t	2025-12-14 13:04:27.123	2025-12-14 13:04:27.123	306.00	шт	10	поштучно
56468	3310	КРЫЛО КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	4198.00	шт	1	300	t	2025-12-14 13:04:27.136	2025-12-14 13:04:27.136	420.00	шт	10	поштучно
56469	3310	ОКОРОЧОК КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	3335.00	шт	1	124	t	2025-12-14 13:04:27.148	2025-12-14 13:04:27.148	334.00	шт	10	поштучно
56470	3310	ПЕЧЕНЬ КУР подложка (1шт~900гр) ТМ БЛАГОЯР	\N	\N	304.00	шт	1	300	t	2025-12-14 13:04:27.159	2025-12-14 13:04:27.159	304.00	шт	\N	поштучно
56471	3310	ПЕЧЕНЬ КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	3369.00	шт	1	183	t	2025-12-14 13:04:27.175	2025-12-14 13:04:27.175	337.00	шт	10	поштучно
56472	3310	СЕРДЦЕ КУР подложка (1шт~900гр) ТМ БЛАГОЯР	\N	\N	487.00	шт	1	300	t	2025-12-14 13:04:27.188	2025-12-14 13:04:27.188	487.00	шт	\N	поштучно
56473	3310	ФИЛЕ БЕДРА КУР без кости без кожи (1шт~900гр) ТМ БЛАГОЯР	\N	\N	569.00	шт	1	277	t	2025-12-14 13:04:27.2	2025-12-14 13:04:27.2	569.00	шт	\N	поштучно
56474	3310	ФИЛЕ БЕДРО КУР без кожи бескостное подложка (1шт~950гр) ТМ ДОМОСЕДКА	\N	\N	601.00	шт	1	25	t	2025-12-14 13:04:27.212	2025-12-14 13:04:27.212	601.00	шт	\N	поштучно
56475	3310	ФИЛЕ ГРУДКИ КУР без кожи без кости подложка (1шт~900гр) ТМ БЛАГОЯР Халяль	\N	\N	602.00	шт	1	272	t	2025-12-14 13:04:27.225	2025-12-14 13:04:27.225	602.00	шт	\N	поштучно
56476	3310	ФИЛЕ ГРУДКИ КУР без кожи без кости подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	5716.00	шт	1	300	t	2025-12-14 13:04:27.236	2025-12-14 13:04:27.236	572.00	шт	10	поштучно
56477	3310	ЦЫПЛЕНОК-БРОЙЛЕР "Межениновская ПФ"	\N	\N	3567.00	уп (12 шт)	1	886	t	2025-12-14 13:04:27.252	2025-12-14 13:04:27.252	297.00	кг	12	только уп
56478	3310	ЦЫПЛЕНОК-БРОЙЛЕР Дружба Халяль 1 сорт (1шт~1,9кг) с/м БЕЛАРУСЬ	\N	\N	610.00	шт	1	163	t	2025-12-14 13:04:27.316	2025-12-14 13:04:27.316	610.00	шт	\N	поштучно
56479	3310	ГОВЯДИНА ГЛАЗНОЙ МУСКУЛ (Полусухожильная мышца бедра)  с/м без кости Беларусь	\N	\N	32687.00	уп (27 шт)	1	300	t	2025-12-14 13:04:27.332	2025-12-14 13:04:27.332	1208.00	кг	27	только уп
56480	3310	ГОВЯДИНА ЛОПАТКА без кости вес с/м Алтай	\N	\N	18490.00	уп (19 шт)	1	300	t	2025-12-14 13:04:27.343	2025-12-14 13:04:27.343	975.00	кг	19	только уп
56481	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Алтай	\N	\N	17508.00	уп (18 шт)	1	300	t	2025-12-14 13:04:27.401	2025-12-14 13:04:27.401	997.00	кг	18	только уп
56482	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Р Алтай ЖЕЛТЫЙ СКОТЧ	\N	\N	17508.00	уп (18 шт)	1	17	t	2025-12-14 13:04:27.415	2025-12-14 13:04:27.415	997.00	кг	18	только уп
56483	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Р Солти ЖЕЛТЫЙ СКОТЧ	\N	\N	22414.00	уп (22 шт)	1	55	t	2025-12-14 13:04:27.432	2025-12-14 13:04:27.432	997.00	кг	22	только уп
56484	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Р ТимашевскМясоПродукт	\N	\N	17595.00	уп (20 шт)	1	164	t	2025-12-14 13:04:27.444	2025-12-14 13:04:27.444	880.00	кг	20	только уп
56485	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Р/ву Алтай КРАСНЫЙ СКОТЧ	\N	\N	17811.00	уп (18 шт)	1	69	t	2025-12-14 13:04:27.458	2025-12-14 13:04:27.458	1014.00	кг	18	только уп
56486	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Р/ву Солти КРАСНЫЙ СКОТЧ	\N	\N	22801.00	уп (22 шт)	1	87	t	2025-12-14 13:04:27.472	2025-12-14 13:04:27.472	1014.00	кг	22	только уп
56487	3310	ГОВЯДИНА ОКОРОК (тазобедреный отруб) вес с/м Солти	\N	\N	22414.00	уп (22 шт)	1	300	t	2025-12-14 13:04:27.483	2025-12-14 13:04:27.483	997.00	кг	22	только уп
56488	3310	ГОВЯДИНА ОКОРОК БЕЗ ГОЛЯШКИ ГОСТ 31797-2012 (тазобедреный отруб)  вес с/м б/к б/г ТимашевскМясоПродукт №2	\N	\N	17643.00	уп (20 шт)	1	300	t	2025-12-14 13:04:27.495	2025-12-14 13:04:27.495	880.00	кг	20	только уп
54176	3310	ГОВЯДИНА ЯЗЫК вес с/м 1/12-17кг Бразилия	\N	\N	1030.00	уп (1 шт)	1	25	f	2025-12-07 13:19:43.248	2025-12-14 12:09:06.688	1030.00	кг	1	только уп
56489	3310	ГОВЯДИНА ПЕЧЕНЬ вес с/м 1/16-19кг Аргентина	\N	\N	7643.00	уп (16 шт)	1	300	t	2025-12-14 13:04:27.506	2025-12-14 13:04:27.506	470.00	кг	16	только уп
56490	3310	ГОВЯДИНА Печень вес с/м Бразилия	\N	\N	470.00	уп (1 шт)	1	300	t	2025-12-14 13:04:27.518	2025-12-14 13:04:27.518	470.00	кг	1	только уп
56491	3310	ГОВЯДИНА СЕРДЦЕ вес с/м 1/10-12кг Беларусь	\N	\N	6540.00	уп (11 шт)	1	300	t	2025-12-14 13:04:27.529	2025-12-14 13:04:27.529	569.00	кг	11	только уп
56492	3310	ГОВЯДИНА СЕРДЦЕ вес с/м 1/20-25кг Уругвай	\N	\N	13949.00	уп (25 шт)	1	300	t	2025-12-14 13:04:27.541	2025-12-14 13:04:27.541	569.00	кг	25	только уп
56493	3310	ГОВЯДИНА СЕРДЦЕ вес с/м Р/ву 1/20-25кг Уругвай КРАСНЫЙ СКОТЧ	\N	\N	14372.00	уп (25 шт)	1	81	t	2025-12-14 13:04:27.555	2025-12-14 13:04:27.555	587.00	кг	25	только уп
56494	3310	ГОВЯДИНА СЕРДЦЕ вес с/м разилия	\N	\N	524.00	уп (1 шт)	1	15	t	2025-12-14 13:04:27.566	2025-12-14 13:04:27.566	524.00	кг	1	только уп
56495	3310	ГОВЯДИНА Шейно-лопаточный отруб без голяшки без кости с/м Алтай	\N	\N	17252.00	уп (19 шт)	1	300	t	2025-12-14 13:04:27.579	2025-12-14 13:04:27.579	903.00	кг	19	только уп
56496	3310	ГОВЯДИНА Шейно-лопаточный отруб без голяшки без кости с/м Солти	\N	\N	21016.00	уп (23 шт)	1	300	t	2025-12-14 13:04:27.591	2025-12-14 13:04:27.591	903.00	кг	23	только уп
56497	3310	ГОВЯДИНА шея  б/к  Алтай	\N	\N	880.00	кг	1	81	t	2025-12-14 13:04:27.612	2025-12-14 13:04:27.612	880.00	кг	\N	только уп
56498	3310	ГОВЯДИНА ШЕЯ (Шейный отруб) без кости с/м Алтай	\N	\N	16944.00	уп (19 шт)	1	300	t	2025-12-14 13:04:27.624	2025-12-14 13:04:27.624	880.00	кг	19	только уп
56499	3310	ГОВЯДИНА ШЕЯ (Шейный отруб) без кости с/м Р/ву Алтай	\N	\N	17276.00	уп (19 шт)	1	55	t	2025-12-14 13:04:27.636	2025-12-14 13:04:27.636	897.00	кг	19	только уп
56500	3310	ГОВЯДИНА ЩЕКИ вес с/м 1/24-25кг Уругвай	\N	\N	17468.00	уп (25 шт)	1	237	t	2025-12-14 13:04:27.65	2025-12-14 13:04:27.65	704.00	кг	25	только уп
56501	3310	ГОВЯДИНА ЯЗЫК вес с/м 1/12-17кг Бразилия	\N	\N	1030.00	уп (1 шт)	1	20	t	2025-12-14 13:04:27.663	2025-12-14 13:04:27.663	1030.00	кг	1	только уп
56502	3310	ГОВЯДИНА КОТЛЕТНОЕ МЯСО триминг 70/30 б/к с/м ВЕС ТМ Праймбиф	\N	\N	21992.00	уп (20 шт)	1	300	t	2025-12-14 13:04:27.677	2025-12-14 13:04:27.677	1093.00	кг	20	только уп
56503	3310	ГОВЯДИНА МРАМОРНАЯ ВЫРЕЗКА "Экстра" б/к Чойс (1кусок~2кг) ВЕС ТМ Праймбиф	\N	\N	101775.00	кг	1	108	t	2025-12-14 13:04:27.767	2025-12-14 13:04:27.767	6785.00	кг	15	поштучно
56504	3310	ГОВЯДИНА мраморная ОТРУБ спинной Рибай Топ Чойс (1кусок~5кг) ВЕС ТМ Праймбиф	\N	\N	103258.00	кг	1	87	t	2025-12-14 13:04:27.796	2025-12-14 13:04:27.796	6296.00	кг	16	поштучно
56505	3310	СВИНИНА ВЫРЕЗКА без кости в/уп (1шт~2,5кг) ТМ Агроэко	\N	\N	1581.00	шт (~2,5кг)	1	300	t	2025-12-14 13:04:27.811	2025-12-14 13:04:27.811	1581.00	шт	\N	только уп
56506	3310	СВИНИНА ВЫРЕЗКА вес (1кусок~1кг) с/м ТМ Полянское	\N	\N	10199.00	уп (17 шт)	1	300	t	2025-12-14 13:04:27.867	2025-12-14 13:04:27.867	592.00	кг	17	только уп
56507	3310	СВИНИНА ВЫРЕЗКА на кости в/уп (1шт~4,5кг) ТМ Агроэко	\N	\N	2158.00	шт (~4,5кг)	1	300	t	2025-12-14 13:04:27.879	2025-12-14 13:04:27.879	2158.00	шт	\N	только уп
56508	3310	СВИНИНА ВЫРЕЗКА с/м без кости  НПЗ Нейма	\N	\N	11514.00	уп (19 шт)	1	300	t	2025-12-14 13:04:27.889	2025-12-14 13:04:27.889	612.00	кг	19	только уп
56509	3310	СВИНИНА ГРУДИНКА без кости в/уп (1шт~3,5кг) ТМ Агроэко	\N	\N	1453.00	шт (~3,5кг)	1	300	t	2025-12-14 13:04:27.909	2025-12-14 13:04:27.909	1453.00	шт	\N	только уп
56510	3310	СВИНИНА ГРУДИНКА с/м без кости вес Р ТМ Агроэко ЖЕЛТЫЙ СКОТЧ	\N	\N	6483.00	уп (17 шт)	1	25	t	2025-12-14 13:04:27.928	2025-12-14 13:04:27.928	391.00	кг	17	только уп
56511	3310	СВИНИНА ГРУДИНКА с/м без кости вес Р/ву ТМ Агроэко КРАСНЫЙ СКОТЧ	\N	\N	6769.00	уп (17 шт)	1	29	t	2025-12-14 13:04:27.939	2025-12-14 13:04:27.939	408.00	кг	17	только уп
56512	3310	СВИНИНА ГРУДИНКА с/м без кости вес ТМ Агроэко	\N	\N	6483.00	уп (17 шт)	1	153	t	2025-12-14 13:04:27.952	2025-12-14 13:04:27.952	391.00	кг	17	только уп
56513	3310	СВИНИНА ГУДИНКА с/м без кости на шкуре НПЗ Нейма	\N	\N	7549.00	уп (15 шт)	1	300	t	2025-12-14 13:04:27.964	2025-12-14 13:04:27.964	518.00	кг	15	только уп
56514	3310	СВИНИНА КАРБОНАД без кости вес (1кусок~1кг) с/м ТМ Полянское	\N	\N	9393.00	уп (18 шт)	1	12	t	2025-12-14 13:04:27.976	2025-12-14 13:04:27.976	519.00	кг	18	только уп
56515	3310	СВИНИНА КАРБОНАД без кости вес ТМ Агроэко	\N	\N	5584.00	уп (11 шт)	1	160	t	2025-12-14 13:04:27.988	2025-12-14 13:04:27.988	518.00	кг	11	только уп
56516	3310	СВИНИНА ЛОПАТКА без кости без голяшки вес с/м ТМ Полянское	\N	\N	7543.00	уп (16 шт)	1	300	t	2025-12-14 13:04:27.998	2025-12-14 13:04:27.998	480.00	кг	16	только уп
56517	3310	СВИНИНА ЛОПАТКА с/м б/к вес Р/ву ТМ Агроэко КРАСНЫЙ СКОТЧ	\N	\N	9896.00	уп (20 шт)	1	20	t	2025-12-14 13:04:28.012	2025-12-14 13:04:28.012	497.00	кг	20	только уп
54201	3310	СВИНИНА РЁБРА Деликатесные с/м МПЗ Нейма	\N	\N	6410.00	уп (12 шт)	1	300	f	2025-12-07 13:19:43.741	2025-12-14 08:12:30.969	530.00	кг	12	только уп
54197	3310	СВИНИНА ОКОРОК с/м б/к вес Р/ву ТМ Агроэко КРАСНЫЙ СКОТЧ	\N	\N	10452.00	уп (21 шт)	1	43	f	2025-12-07 13:19:43.627	2025-12-14 08:12:31.356	504.00	кг	21	только уп
54210	3310	УТЕНОК Полутушка пряные травы маринад пакет (1шт~1кг) 1/3-4кг ТМ Улыбино	\N	\N	1725.00	кг	1	38	f	2025-12-07 13:19:43.888	2025-12-14 08:21:41.8	431.00	кг	4	поштучно
54206	3310	СВИНИНА ШЕЯ с/м б/к вес (1кусок~1-2,5кг) ТМ Полянское	\N	\N	9712.00	уп (15 шт)	1	300	f	2025-12-07 13:19:43.823	2025-12-14 12:09:06.688	647.00	кг	15	только уп
56518	3310	СВИНИНА ЛОПАТКА с/м б/к вес ТМ Агроэко	\N	\N	9553.00	уп (20 шт)	1	300	t	2025-12-14 13:04:28.039	2025-12-14 13:04:28.039	480.00	кг	20	только уп
56519	3310	СВИНИНА ЛОПАТКА с/м без кости 1/18-19кг МПЗ Нейма	\N	\N	9015.00	уп (19 шт)	1	300	t	2025-12-14 13:04:28.052	2025-12-14 13:04:28.052	484.00	кг	19	только уп
56520	3310	СВИНИНА МЯСО НА ХРЯЩАХ вес с/м ТМ Полянское	\N	\N	7231.00	уп (18 шт)	1	300	t	2025-12-14 13:04:28.065	2025-12-14 13:04:28.065	391.00	кг	18	только уп
56521	3310	СВИНИНА НОГИ задние вес с/м ТК Викинг	\N	\N	1879.00	уп (16 шт)	1	300	t	2025-12-14 13:04:28.076	2025-12-14 13:04:28.076	121.00	кг	16	только уп
56522	3310	СВИНИНА НОГИ передние вес с/м ТМ Коралл	\N	\N	2875.00	уп (20 шт)	1	202	t	2025-12-14 13:04:28.087	2025-12-14 13:04:28.087	144.00	кг	20	только уп
56523	3310	СВИНИНА ОКОРОК с/м б/к без голяшки вес ТимашевскМясоПродукт	\N	\N	9515.00	уп (20 шт)	1	300	t	2025-12-14 13:04:28.1	2025-12-14 13:04:28.1	466.00	кг	20	только уп
56524	3310	СВИНИНА ОКОРОК с/м б/к без голяшки вес ТМ Полянское	\N	\N	7297.00	уп (15 шт)	1	80	t	2025-12-14 13:04:28.112	2025-12-14 13:04:28.112	486.00	кг	15	только уп
56525	3310	СВИНИНА ОКОРОК с/м б/к вес Р ТМ Агроэко ЖЕЛТЫЙ СКОТЧ	\N	\N	10094.00	уп (21 шт)	1	34	t	2025-12-14 13:04:28.124	2025-12-14 13:04:28.124	486.00	кг	21	только уп
56526	3310	СВИНИНА ОКОРОК с/м б/к вес ТМ Агроэко	\N	\N	10094.00	уп (21 шт)	1	300	t	2025-12-14 13:04:28.134	2025-12-14 13:04:28.134	486.00	кг	21	только уп
56527	3310	СВИНИНА ОКОРОК с/м б/к МПЗ Нейма	\N	\N	8326.00	уп (17 шт)	1	300	t	2025-12-14 13:04:28.145	2025-12-14 13:04:28.145	497.00	кг	17	только уп
56528	3310	СВИНИНА ПЕЧЕНЬ вес с/м  ТМ Полянское	\N	\N	3502.00	уп (20 шт)	1	101	t	2025-12-14 13:04:28.155	2025-12-14 13:04:28.155	173.00	кг	20	только уп
56529	3310	СВИНИНА РАГУ суповой набор на кости вес с/м ТМ Полянское	\N	\N	2371.00	уп (15 шт)	1	300	t	2025-12-14 13:04:28.17	2025-12-14 13:04:28.17	162.00	кг	15	только уп
56530	3310	СВИНИНА РЁБРА Деликатесные с/м инд уп (1шт~1,3кг) МПЗ Нейма	\N	\N	689.00	шт (~1,3кг)	1	300	t	2025-12-14 13:04:28.181	2025-12-14 13:04:28.181	689.00	шт	\N	только уп
56531	3310	СВИНИНА РЁБРА для копчения треугольник вес (50% мяса) с/м ТМ Полянское	\N	\N	4756.00	уп (18 шт)	1	300	t	2025-12-14 13:04:28.193	2025-12-14 13:04:28.193	270.00	кг	18	только уп
56532	3310	СВИНИНА РЁБРА лента ПРЕМИУМ (50% мяса) вес с/м ТМ Полянское	\N	\N	9201.00	уп (18 шт)	1	300	t	2025-12-14 13:04:28.204	2025-12-14 13:04:28.204	501.00	кг	18	только уп
56533	3310	СВИНИНА РУЛЬКА (голяшка) передняя на кости с/м ТМ Коралл	\N	\N	5369.00	уп (20 шт)	1	21	t	2025-12-14 13:04:28.215	2025-12-14 13:04:28.215	270.00	кг	20	только уп
56534	3310	СВИНИНА ТРИММИНГ 80/20  с/м б/к 1/21-23кг ТК Викинг	\N	\N	10173.00	уп (19 шт)	1	300	t	2025-12-14 13:04:28.229	2025-12-14 13:04:28.229	547.00	кг	19	только уп
56535	3310	СВИНИНА ШЕЯ с/м б/к вес (1кусок~1-2,5кг) ТМ Полянское	\N	\N	9056.00	уп (15 шт)	1	300	t	2025-12-14 13:04:28.239	2025-12-14 13:04:28.239	604.00	кг	15	только уп
56536	3310	СВИНИНА ШЕЙКА с/м б/к в/уп (1шт~2,5кг) ТМ Агроэко	\N	\N	2007.00	шт	1	15	t	2025-12-14 13:04:28.249	2025-12-14 13:04:28.249	2007.00	шт	\N	поштучно
56537	3310	БАРАНИНА ОКОРОК СТЕЙКАМИ  н/к в классическом маринаде с/м в/уп  (1уп~1кг) Хакасская	\N	\N	25003.00	кг	1	33	t	2025-12-14 13:04:28.259	2025-12-14 13:04:28.259	1586.00	кг	16	поштучно
56538	3310	БАРАНИНА ОКОРОК СТЕЙКАМИ  н/к в соусе по-грузински с/м в/уп (1уп~1кг) Хакасская	\N	\N	24118.00	кг	1	14	t	2025-12-14 13:04:28.27	2025-12-14 13:04:28.27	1586.00	кг	15	поштучно
56539	3310	БАРАНИНА ШЕЙКА кольцами в пряном соусе с/м в/уп  (1уп~1кг) Хакасская	\N	\N	1144.00	кг	1	16	t	2025-12-14 13:04:28.281	2025-12-14 13:04:28.281	1144.00	кг	1	поштучно
56540	3310	ЯГНЯТИНА РЕБРЫШКИ в пряном соусе с/м в/уп (1уп~900гр) Хакасская	\N	\N	1372.00	кг	1	27	t	2025-12-14 13:04:28.291	2025-12-14 13:04:28.291	1372.00	кг	1	поштучно
56541	3310	ЯГНЯТИНА РЕБРЫШКИ в соусе по-грузински с/м в/уп  (1уп~1кг) Хакасская	\N	\N	16041.00	кг	1	17	t	2025-12-14 13:04:28.301	2025-12-14 13:04:28.301	1372.00	кг	12	поштучно
56542	3310	ЯГНЯТИНА РЕБРЫШКИ в соусе ткемали с/м в/уп  (1уп~1кг) Хакасская	\N	\N	1372.00	кг	1	35	t	2025-12-14 13:04:28.315	2025-12-14 13:04:28.315	1372.00	кг	1	поштучно
56543	3310	ЯГНЯТИНА РЕБРЫШКИ в цитрусовом соусе с/м в/уп (1уп~900гр) Хакасская	\N	\N	1372.00	кг	1	30	t	2025-12-14 13:04:28.332	2025-12-14 13:04:28.332	1372.00	кг	1	поштучно
56544	3396	САРДЕЛЬКИ 1кг Прибалтийские традиции натур оболочка замороженные ТМ Анком	\N	\N	14007.00	кг	1	51	t	2025-12-14 13:04:28.349	2025-12-14 13:04:28.349	700.00	кг	20	поштучно
56545	3396	САРДЕЛЬКИ 600гр Мусульманские ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2674.00	шт	1	100	t	2025-12-14 13:04:28.359	2025-12-14 13:04:28.359	178.00	шт	15	поштучно
56546	3396	САРДЕЛЬКИ Вес 10кг Аппетитные полиамид замороженные Обнинский МПК	\N	\N	2668.00	уп (10 шт)	1	100	t	2025-12-14 13:04:28.37	2025-12-14 13:04:28.37	267.00	кг	10	только уп
56547	3396	САРДЕЛЬКИ Вес 10кг Мусульманские ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2588.00	уп (10 шт)	1	100	t	2025-12-14 13:04:28.397	2025-12-14 13:04:28.397	259.00	кг	10	только уп
56548	3396	САРДЕЛЬКИ Вес 5кг Чернышевские Гриль замороженные Обнинский МПК	\N	\N	1541.00	уп (5 шт)	1	65	t	2025-12-14 13:04:28.408	2025-12-14 13:04:28.408	308.00	кг	5	только уп
56549	3396	СОСИСКИ 400гр Мусульманские с бараниной ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2953.00	шт	1	100	t	2025-12-14 13:04:28.419	2025-12-14 13:04:28.419	123.00	шт	24	поштучно
56550	3396	СОСИСКИ 400гр Мусульманские с говядиной ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2953.00	шт	1	100	t	2025-12-14 13:04:28.433	2025-12-14 13:04:28.433	123.00	шт	24	поштучно
56551	3396	СОСИСКИ 400гр Подкопченые ХАЛЯЛЬ полиамид замороженные Обнинский МПК	\N	\N	2953.00	шт	1	100	t	2025-12-14 13:04:28.445	2025-12-14 13:04:28.445	123.00	шт	24	поштучно
56552	3396	СОСИСКИ 480гр Мусульманские полиамид замороженные Обнинский МПК	\N	\N	3367.00	шт	1	100	t	2025-12-14 13:04:28.456	2025-12-14 13:04:28.456	140.00	шт	24	поштучно
56553	3396	СОСИСКИ 500гр Молочные полиамид замороженные Обнинский МПК	\N	\N	1323.00	шт	1	100	t	2025-12-14 13:04:28.469	2025-12-14 13:04:28.469	132.00	шт	10	поштучно
56554	3396	СОСИСКИ Вес 10кг Дачные 13см замороженные Обнинский МПК	\N	\N	2484.00	уп (10 шт)	1	100	t	2025-12-14 13:04:28.482	2025-12-14 13:04:28.482	248.00	кг	10	только уп
56555	3396	СОСИСКИ Вес 10кг Молочные замороженные Обнинский МПК	\N	\N	2530.00	уп (10 шт)	1	100	t	2025-12-14 13:04:28.492	2025-12-14 13:04:28.492	253.00	кг	10	только уп
56556	3396	СОСИСКИ д/хот-догов с Говядиной Халяль 600гр ТМ Рамай Обнинский МПК	\N	\N	2502.00	шт	1	100	t	2025-12-14 13:04:28.503	2025-12-14 13:04:28.503	313.00	шт	8	поштучно
56557	3396	СОСИСКИ д/хот-догов Филейные Халяль 600гр 1/8шт ТМ Рамай Обнинский МПК	\N	\N	2502.00	шт	1	100	t	2025-12-14 13:04:28.57	2025-12-14 13:04:28.57	313.00	шт	8	поштучно
56558	3396	СОСИСКИ с сыром Вес ~9кг замороженные ТМ Вязанка	\N	\N	4896.00	кг	1	76	t	2025-12-14 13:04:28.587	2025-12-14 13:04:28.587	544.00	кг	9	поштучно
56559	3396	ШПИКАЧКИ Вес 5кг Чернышевские с сыром замороженные Обнинский МПК	\N	\N	1935.00	уп (5 шт)	1	100	t	2025-12-14 13:04:28.601	2025-12-14 13:04:28.601	387.00	кг	5	только уп
56560	3310	КОЛБАСКИ д/жарки Баварские Халяль 600гр 1/10шт ТМ Рамай Обнинский МПК	\N	\N	5382.00	шт	1	100	t	2025-12-14 13:04:28.613	2025-12-14 13:04:28.613	538.00	шт	10	поштучно
56561	3310	КОЛБАСКИ д/жарки Гриль говяжьи Халяль 600гр 1/10шт ТМ Рамай Обнинский МПК	\N	\N	5877.00	шт	1	100	t	2025-12-14 13:04:28.624	2025-12-14 13:04:28.624	588.00	шт	10	поштучно
56562	3310	КОЛБАСКИ д/жарки Гриль с бараниной Халяль 600гр 1/10шт ТМ Рамай Обнинский МПК	\N	\N	5877.00	шт	1	100	t	2025-12-14 13:04:28.638	2025-12-14 13:04:28.638	588.00	шт	10	поштучно
56563	3310	КОЛБАСКИ д/жарки Гриль с курицей Халяль 600гр 1/10шт ТМ Рамай Обнинский МПК	\N	\N	5382.00	шт	1	100	t	2025-12-14 13:04:28.659	2025-12-14 13:04:28.659	538.00	шт	10	поштучно
56564	3310	ШАШЛЫК БАРАНИЙ н/к в классическом маринаде (1уп~1кг) Хакасская	\N	\N	12079.00	кг	1	24	t	2025-12-14 13:04:28.67	2025-12-14 13:04:28.67	1144.00	кг	11	поштучно
56565	3310	ШАШЛЫК БАРАНИЙ н/к в пикантном соусе (1уп~1кг) Хакасская	\N	\N	14168.00	кг	1	11	t	2025-12-14 13:04:28.68	2025-12-14 13:04:28.68	1144.00	кг	12	поштучно
56566	3310	ШАШЛЫК БАРАНИЙ н/к в пряном соусе (1уп~1кг) Хакасская	\N	\N	11443.00	кг	1	26	t	2025-12-14 13:04:28.692	2025-12-14 13:04:28.692	1144.00	кг	10	поштучно
56567	3310	ЯЙЦО пищевое С1  ПФ Бердская ТОЛЬКО МЕСТАМИ *	\N	\N	4347.00	уп (360 шт)	1	360	t	2025-12-14 13:04:28.704	2025-12-14 13:04:28.704	12.00	шт	360	только уп
56568	3367	*УГОЛЬНАЯ рыба  (аналог палтуса) мороженая потрошенная без головы 1/18кг СРТМ Антей	\N	\N	23495.00	уп (18 шт)	1	378	t	2025-12-14 13:04:28.718	2025-12-14 13:04:28.718	1305.00	кг	18	только уп
56569	3367	*ФАРШ МИНТАЯ мороженый 1кг коробка ООО Русский минтай ЦЕНА ЗА ШТУКУ	\N	\N	5506.00	шт	1	461	t	2025-12-14 13:04:28.729	2025-12-14 13:04:28.729	262.00	шт	21	поштучно
56570	3367	*ФИЛЕ МИНТАЯ мороженое без кожи без кости 1кг коробка 1/21кг ООО Русский минтай ЦЕНА ЗА ШТУКУ	\N	\N	11833.00	шт	1	498	t	2025-12-14 13:04:28.743	2025-12-14 13:04:28.743	564.00	шт	21	поштучно
56571	3367	ГОРБУША мороженая потрошенная без головы Вылов 2025*	\N	\N	8804.00	уп (22 шт)	1	210	t	2025-12-14 13:04:28.772	2025-12-14 13:04:28.772	400.00	кг	22	только уп
56572	3367	ГОРБУША мороженая потрошенная с головой  Вылов 2025*	\N	\N	8804.00	уп (22 шт)	1	638	t	2025-12-14 13:04:28.783	2025-12-14 13:04:28.783	400.00	кг	22	только уп
56573	3367	ГОРБУША мороженая потрошенная с головой 1/22кг Вылов 2025г*	\N	\N	8804.00	уп (22 шт)	1	1000	t	2025-12-14 13:04:28.794	2025-12-14 13:04:28.794	400.00	кг	22	только уп
56574	3367	ДОРАДО мороженая 400/600гр 1/5кг Турция	\N	\N	6037.00	уп (5 шт)	1	65	t	2025-12-14 13:04:28.812	2025-12-14 13:04:28.812	1208.00	кг	5	только уп
56575	3367	ЗУБАТКА пестрая мороженая потрошеная б/г 2*16кг М-0138 Капитан Рогозин	\N	\N	20203.00	уп (32 шт)	1	300	t	2025-12-14 13:04:28.825	2025-12-14 13:04:28.825	631.00	кг	32	только уп
56576	3367	КАМБАЛА мороженая неразделанная 21+  ИП Курбатов Л.Д.	\N	\N	3668.00	уп (22 шт)	1	726	t	2025-12-14 13:04:28.838	2025-12-14 13:04:28.838	167.00	кг	22	только уп
56577	3367	КЕТА потрошенная без головы с/м 1/22кг Вылов 2025 - *	\N	\N	13662.00	уп (22 шт)	1	286	t	2025-12-14 13:04:28.866	2025-12-14 13:04:28.866	621.00	кг	22	только уп
56578	3367	КЕТА потрошенная без головы с/м 1/22кг Вылов 2025 - 2*	\N	\N	13662.00	уп (22 шт)	1	188	t	2025-12-14 13:04:28.879	2025-12-14 13:04:28.879	621.00	кг	22	только уп
56579	3367	КИЖУЧ мороженая потрошенная с головой ВЕС 1/20-23кг ВЫЛОВ 2025 Мотыклейский Залив*	\N	\N	12770.00	уп (20 шт)	1	636	t	2025-12-14 13:04:28.89	2025-12-14 13:04:28.89	633.00	кг	20	только уп
56580	3367	КОРЮШКА азиатская мороженая неразделанная М БРЗК Колхоз Октябрь	\N	\N	31625.00	уп (22 шт)	1	110	t	2025-12-14 13:04:28.902	2025-12-14 13:04:28.902	1438.00	кг	22	только уп
56581	3367	МИНТАЙ мороженый без головы 25+ вес 1/14кг Вылов 2025г*	\N	\N	2391.00	уп (14 шт)	1	1000	t	2025-12-14 13:04:28.92	2025-12-14 13:04:28.92	171.00	кг	14	только уп
56582	3367	НАВАГА мороженая блочная б/г морская заморозка 1/24кг РКЗ Командор-Инвест	\N	\N	4554.00	уп (24 шт)	1	1000	t	2025-12-14 13:04:28.931	2025-12-14 13:04:28.931	190.00	кг	24	только уп
56583	3367	НЕРКА мороженая потрошенная без головы L 1/20кг ООО Зюйд	\N	\N	29670.00	уп (20 шт)	1	1000	t	2025-12-14 13:04:28.94	2025-12-14 13:04:28.94	1483.00	кг	20	только уп
56584	3367	НЕРКА мороженая потрошенная без головы М 1/20кг ООО Зюйд	\N	\N	27370.00	уп (20 шт)	1	1000	t	2025-12-14 13:04:28.952	2025-12-14 13:04:28.952	1369.00	кг	20	только уп
56585	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый  "М" 1/22-24кг	\N	\N	44908.00	уп (23 шт)	1	902	t	2025-12-14 13:04:28.963	2025-12-14 13:04:28.963	1972.00	кг	23	только уп
56586	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый  "М" Р 1/22-24кг	\N	\N	44243.00	уп (23 шт)	1	56	t	2025-12-14 13:04:28.974	2025-12-14 13:04:28.974	1932.00	кг	23	только уп
54263	3367	СКУМБРИЯ мороженая неразделанная 500-800гр вес Китай	\N	\N	3806.00	уп (10 шт)	1	1000	f	2025-12-07 13:19:44.741	2025-12-14 12:09:06.688	381.00	кг	10	только уп
56587	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый "S" (1-2кг) 1/22-23кг	\N	\N	34957.00	уп (23 шт)	1	355	t	2025-12-14 13:04:28.987	2025-12-14 13:04:28.987	1547.00	кг	23	только уп
56588	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый "S" 1/20-24кг	\N	\N	36349.00	уп (24 шт)	1	168	t	2025-12-14 13:04:28.998	2025-12-14 13:04:28.998	1547.00	кг	24	только уп
56589	3367	ПАЛТУС СИНЕКОРЫЙ тушка б/хвоста б/головы мороженый "М" Р/ву 1/22-24кг	\N	\N	45165.00	уп (23 шт)	1	32	t	2025-12-14 13:04:29.013	2025-12-14 13:04:29.013	1972.00	кг	23	только уп
56590	3367	СЕЛЬДЬ ОЛЮТОРСКАЯ мороженая КРУПНАЯ 2L 400-500гр 1/20кг Океанрыбфлот	\N	\N	5750.00	уп (20 шт)	1	280	t	2025-12-14 13:04:29.026	2025-12-14 13:04:29.026	288.00	кг	20	только уп
56591	3367	СЕЛЬДЬ ТИХООКЕАНСКАЯ мороженая 1/20кг с/м*	\N	\N	2047.00	уп (20 шт)	1	933	t	2025-12-14 13:04:29.036	2025-12-14 13:04:29.036	102.00	кг	20	только уп
56592	3367	СЕЛЬДЬ ТИХООКЕАНСКАЯ мороженая 27+ 1/13кг Тихрыбком*	\N	\N	1459.00	уп (13 шт)	1	1000	t	2025-12-14 13:04:29.047	2025-12-14 13:04:29.047	112.00	кг	13	только уп
56593	3367	СКУМБРИЯ мороженая неразделанная 500-800гр вес Китай	\N	\N	3806.00	уп (10 шт)	1	1000	t	2025-12-14 13:04:29.064	2025-12-14 13:04:29.064	381.00	кг	10	только уп
56594	3367	ТЕРПУГ мороженый H/P 2L СРТМ АПОЛЛОН	\N	\N	7597.00	уп (18 шт)	1	162	t	2025-12-14 13:04:29.074	2025-12-14 13:04:29.074	422.00	кг	18	только уп
56595	3367	ТЕРПУГ мороженый H/P L  1/18кг СРТМ Феникс	\N	\N	7245.00	уп (18 шт)	1	1000	t	2025-12-14 13:04:29.085	2025-12-14 13:04:29.085	402.00	кг	18	только уп
56596	3367	ТЕРПУГ мороженый H/P L  СРТМ АПОЛЛОН	\N	\N	7597.00	уп (18 шт)	1	1000	t	2025-12-14 13:04:29.116	2025-12-14 13:04:29.116	422.00	кг	18	только уп
56597	3367	ФАРШ МИНТАЯ Восточный вес с/м Россия	\N	\N	5216.00	уп (22 шт)	1	337	t	2025-12-14 13:04:29.136	2025-12-14 13:04:29.136	232.00	кг	22	только уп
56598	3367	ФАРШ МИНТАЯ Восточный вес с/м Россия Р ЖЕЛТЫЙ СКОТЧ	\N	\N	5216.00	уп (22 шт)	1	112	t	2025-12-14 13:04:29.147	2025-12-14 13:04:29.147	232.00	кг	22	только уп
56599	3367	ФИЛЕ МИНТАЯ мороженое без кожи без кости Мыс Меньшикова	\N	\N	10324.00	уп (23 шт)	1	1000	t	2025-12-14 13:04:29.157	2025-12-14 13:04:29.157	459.00	кг	23	только уп
56600	3367	ФИЛЕ МИНТАЯ мороженое без кожи без кости Р Мыс Меньшикова ЖЕЛТЫЙ СКОТЧ	\N	\N	10324.00	уп (23 шт)	1	68	t	2025-12-14 13:04:29.168	2025-12-14 13:04:29.168	459.00	кг	23	только уп
56601	3367	ФИЛЕ МИНТАЯ мороженое без кожи без кости Р Россия ЖЕЛТЫЙ СКОТЧ	\N	\N	10302.00	уп (22 шт)	1	90	t	2025-12-14 13:04:29.178	2025-12-14 13:04:29.178	459.00	кг	22	только уп
56602	3367	ФИЛЕ ОКУНЯ КРАСНОГО мороженое с/м 1/10кг Китай	\N	\N	7532.00	уп (10 шт)	1	310	t	2025-12-14 13:04:29.189	2025-12-14 13:04:29.189	753.00	кг	10	только уп
56603	3367	ФИЛЕ ПАЛТУСА с/м в/у 400гр Китай	\N	\N	7314.00	шт	1	621	t	2025-12-14 13:04:29.199	2025-12-14 13:04:29.199	244.00	шт	30	поштучно
56604	3367	ФИЛЕ ПАЛТУСА с/м Китай	\N	\N	6095.00	уп (10 шт)	1	1000	t	2025-12-14 13:04:29.209	2025-12-14 13:04:29.209	610.00	кг	10	только уп
56605	3367	ФИЛЕ ПАНГАСИУСА с/м Вьетнам	\N	\N	3220.00	уп (10 шт)	1	1000	t	2025-12-14 13:04:29.223	2025-12-14 13:04:29.223	322.00	кг	10	только уп
56606	3367	ФИЛЕ ТИЛАПИИ мороженое 5-7 КНР	\N	\N	9085.00	уп (10 шт)	1	730	t	2025-12-14 13:04:29.234	2025-12-14 13:04:29.234	908.00	кг	10	только уп
56607	3367	ФИЛЕ ТУНЦА желтоперого  в/уп 500гр (стейки по 100+) с/м	\N	\N	12190.00	уп (20 шт)	1	735	t	2025-12-14 13:04:29.246	2025-12-14 13:04:29.246	610.00	шт	20	только уп
56608	3367	ФИЛЕ УГРЯ Унаги жареное замороженное (300-400гр) 10% соуса 1/10кг	\N	\N	24437.00	уп (10 шт)	1	220	t	2025-12-14 13:04:29.278	2025-12-14 13:04:29.278	2444.00	кг	10	только уп
56609	3367	ФИЛЕ ФОРЕЛИ мороженое на шкуре Trim B Premium (1,0-1,4 кг) в/уп 1/8-9кг	\N	\N	21822.00	уп (9 шт)	1	1000	t	2025-12-14 13:04:29.328	2025-12-14 13:04:29.328	2473.00	кг	9	только уп
56610	3367	ФИЛЕ ХЕКА мороженное с кожей без кости Китай	\N	\N	5865.00	уп (10 шт)	1	200	t	2025-12-14 13:04:29.34	2025-12-14 13:04:29.34	587.00	кг	10	только уп
56611	3367	ГРЕБЕШОК 1кг на половинке ракушки 8-9 с/м (пакет)	\N	\N	13926.00	уп (10 шт)	1	91	t	2025-12-14 13:04:29.353	2025-12-14 13:04:29.353	1393.00	кг	10	только уп
56612	3367	ГРЕБЕШОК вес 10кг 10/20 филе морской мороженый глазированный Китай	\N	\N	30475.00	уп (10 шт)	1	310	t	2025-12-14 13:04:29.414	2025-12-14 13:04:29.414	3047.00	кг	10	только уп
56613	3367	ГРЕБЕШОК вес 12кг Курильский филе морской мороженый глазированный  "L"	\N	\N	45140.00	уп (12 шт)	1	96	t	2025-12-14 13:04:29.426	2025-12-14 13:04:29.426	3762.00	кг	12	только уп
56614	3367	ГРЕБЕШОК вес 12кг Курильский филе морской мороженый глазированный  "М"	\N	\N	39606.00	уп (12 шт)	1	360	t	2025-12-14 13:04:29.437	2025-12-14 13:04:29.437	3300.00	кг	12	только уп
56615	3367	ГРЕБЕШОК Золотой 1кг на половинке ракушки 7-8 с/м (пакет)	\N	\N	12075.00	кг	1	85	t	2025-12-14 13:04:29.45	2025-12-14 13:04:29.45	1208.00	кг	10	поштучно
56616	3367	ГРЕБЕШОК ФИЛЕ 500гр 40/60 с/м ТМ Тихая Бухта	\N	\N	9085.00	шт	1	391	t	2025-12-14 13:04:29.461	2025-12-14 13:04:29.461	454.00	шт	20	поштучно
56617	3367	КАЛЬМАР ЁЖИКИ  500гр с/м Китай	\N	\N	7245.00	шт	1	16	t	2025-12-14 13:04:29.473	2025-12-14 13:04:29.473	362.00	шт	20	поштучно
56618	3367	КАЛЬМАР КОЛЬЦА 500гр с/м Китай	\N	\N	6969.00	шт	1	148	t	2025-12-14 13:04:29.487	2025-12-14 13:04:29.487	348.00	шт	20	поштучно
56619	3367	КАЛЬМАР мороженый Тушка с пластинкой	\N	\N	8510.00	уп (20 шт)	1	1000	t	2025-12-14 13:04:29.498	2025-12-14 13:04:29.498	425.00	кг	20	только уп
56620	3367	КАЛЬМАР мороженый Тушка с пластинкой блок лайнер (3*7,5кг) Коробка СРТМ Виктория1	\N	\N	9626.00	уп (23 шт)	1	1000	t	2025-12-14 13:04:29.511	2025-12-14 13:04:29.511	428.00	кг	23	только уп
56621	3367	КАЛЬМАР мороженый Тушка с пластинкой мешок СРТМ ГРАНИТ	\N	\N	11914.00	уп (28 шт)	1	28	t	2025-12-14 13:04:29.521	2025-12-14 13:04:29.521	425.00	кг	28	только уп
56941	3395	ГРИБЫ ШАМПИНЬОНЫ резаные вес Россия	\N	\N	2875.00	уп (10 шт)	1	500	t	2025-12-14 13:04:35.317	2025-12-14 13:04:35.317	288.00	кг	10	только уп
56622	3367	КАЛЬМАР мороженый Филе очищенный с пластинкой без кожи без плавника  СРТМ Виктория1	\N	\N	19665.00	уп (23 шт)	1	135	t	2025-12-14 13:04:29.532	2025-12-14 13:04:29.532	874.00	кг	23	только уп
56623	3367	КАЛЬМАР ФИЛЕ 1кг очищенный без кожи без плавника коробка с/м БМРТ Бутовск	\N	\N	19079.00	шт	1	1000	t	2025-12-14 13:04:29.542	2025-12-14 13:04:29.542	908.00	шт	21	поштучно
56624	3367	КАЛЬМАР ФИЛЕ 600гр очищенный без кожи без плавника коробка с/м АО ОКЕАНРЫБФЛОТ	\N	\N	19624.00	шт	1	1000	t	2025-12-14 13:04:29.555	2025-12-14 13:04:29.555	545.00	шт	36	поштучно
56625	3367	КАЛЬМАР ФИЛЕ ВЕС очищенный без кожи без плавника коробка с/м БМРТ Бутовск	\N	\N	18354.00	уп (21 шт)	1	935	t	2025-12-14 13:04:29.752	2025-12-14 13:04:29.752	874.00	кг	21	только уп
56626	3367	КАЛЬМАР Щупальца с головой с/м 1/22кг	\N	\N	11132.00	уп (22 шт)	1	1000	t	2025-12-14 13:04:29.814	2025-12-14 13:04:29.814	506.00	кг	22	только уп
56627	3367	КАЛЬМАР Щупальца с головой с/м 1/24кг	\N	\N	12144.00	уп (24 шт)	1	1000	t	2025-12-14 13:04:29.864	2025-12-14 13:04:29.864	506.00	кг	24	только уп
56628	3367	КОКТЕЙЛЬ 500гр морской, ассорти из морепродуктов с/м ТМ Тихая бухта	\N	\N	4577.00	шт	1	1000	t	2025-12-14 13:04:29.877	2025-12-14 13:04:29.877	229.00	шт	20	поштучно
56629	3367	КРАБ камчатский Конечности варено-мороженые размер 2L (~г) 1/10кг	\N	\N	66700.00	уп (10 шт)	1	20	t	2025-12-14 13:04:29.888	2025-12-14 13:04:29.888	6670.00	кг	10	только уп
56630	3367	МИДИИ 1кг 30/45 "М" синии в половинке раковины коробочка с/м Китай	\N	\N	6095.00	шт	1	106	t	2025-12-14 13:04:29.898	2025-12-14 13:04:29.898	610.00	шт	10	поштучно
56631	3367	МИДИИ 200/300 очищенные в/м пакет 500гр ТМ Тихая Бухта	\N	\N	5060.00	шт	1	608	t	2025-12-14 13:04:29.909	2025-12-14 13:04:29.909	253.00	шт	20	поштучно
56632	3367	МИДИИ 907гр 30/45 "М" зеленые в половинке раковины коробочка с/м НовЗеландия КНР	\N	\N	21666.00	шт	1	15	t	2025-12-14 13:04:29.92	2025-12-14 13:04:29.92	1805.00	шт	12	поштучно
56633	3367	МОРСКАЯ КАПУСТА 1/20кг ламинария японская шинкованная с/м	\N	\N	2254.00	уп (20 шт)	1	1000	t	2025-12-14 13:04:29.931	2025-12-14 13:04:29.931	113.00	кг	20	только уп
56634	3367	САЛАТ 150гр из морских водорослей Чука с/м Китай	\N	\N	5428.00	шт	1	250	t	2025-12-14 13:04:29.943	2025-12-14 13:04:29.943	68.00	шт	80	поштучно
56635	3367	САЛАТ 500гр из морских водорослей Чука красная имбирная с/м Китай	\N	\N	4664.00	шт	1	385	t	2025-12-14 13:04:29.954	2025-12-14 13:04:29.954	194.00	шт	24	поштучно
56636	3367	САЛАТ 500гр из морских водорослей Чука красная классическая с/м Китай	\N	\N	4664.00	шт	1	257	t	2025-12-14 13:04:29.966	2025-12-14 13:04:29.966	194.00	шт	24	поштучно
56637	3367	САЛАТ 500гр из морских водорослей Чука с/м Китай	\N	\N	4002.00	шт	1	704	t	2025-12-14 13:04:29.978	2025-12-14 13:04:29.978	167.00	шт	24	поштучно
56638	3367	САЛАТ 500гр из морских водорослей Чука со вкусом васаби с/м Китай	\N	\N	4664.00	шт	1	277	t	2025-12-14 13:04:29.99	2025-12-14 13:04:29.99	194.00	шт	24	поштучно
56639	3367	САЛАТ 500гр из морских водорослей Чука со вкусом ротангового перца с/м Китай	\N	\N	4664.00	шт	1	388	t	2025-12-14 13:04:30	2025-12-14 13:04:30	194.00	шт	24	поштучно
56640	3367	ТРУБАЧ МЯСО 1/11кг мороженое неочищенное мешок ООО Маг-Си	\N	\N	24667.00	уп (11 шт)	1	1000	t	2025-12-14 13:04:30.085	2025-12-14 13:04:30.085	2243.00	кг	11	только уп
56641	3367	КРЕВЕТКА Аргентинская 2кг с/м 10/20 красная в панцире с головой ТМ Вичи	\N	\N	19534.00	шт	1	21	t	2025-12-14 13:04:30.101	2025-12-14 13:04:30.101	3256.00	шт	6	поштучно
56642	3367	КРЕВЕТКА Аргентинская 450гр с/м 41/50 красная в панцире без головы ТМ Вичи Luxury	\N	\N	5444.00	шт	1	236	t	2025-12-14 13:04:30.117	2025-12-14 13:04:30.117	907.00	шт	6	поштучно
56643	3367	КРЕВЕТКА Аргентинская 4кг вес с/м 41/50 красная в панцире без головы ТМ Вичи Приорити	\N	\N	7889.00	кг	1	500	t	2025-12-14 13:04:30.14	2025-12-14 13:04:30.14	1972.00	кг	4	поштучно
56644	3367	КРЕВЕТКА Тигровая 1кг с/м 16/20 в панцире без головы с хвостиком Бангладеш	\N	\N	13915.00	шт	1	500	t	2025-12-14 13:04:30.159	2025-12-14 13:04:30.159	1392.00	шт	10	поштучно
56645	3367	КРЕВЕТКА  Ваннамей 1кг в/м 30/50 очищенная с хвостиком Китай	\N	\N	12926.00	шт	1	36	t	2025-12-14 13:04:30.174	2025-12-14 13:04:30.174	1293.00	шт	10	поштучно
56646	3367	КРЕВЕТКА Белоногие 500гр в/м 31/40 очищенная с хвостиком в соусе по-азиатски ТМ Вичи	\N	\N	11362.00	шт	1	43	t	2025-12-14 13:04:30.191	2025-12-14 13:04:30.191	1420.00	шт	8	поштучно
56647	3367	КРЕВЕТКА Белоногие 500гр в/м 31/40 очищенная с хвостиком в соусе по-средиземноморски ТМ Вичи	\N	\N	11362.00	шт	1	43	t	2025-12-14 13:04:30.212	2025-12-14 13:04:30.212	1420.00	шт	8	поштучно
56648	3367	КРЕВЕТКА Коктейльная 500гр в/м 100/200 очищенная ошпаренная ТМ Тихая Бухта	\N	\N	11086.00	шт	1	500	t	2025-12-14 13:04:30.238	2025-12-14 13:04:30.238	554.00	шт	20	поштучно
56649	3367	КРЕВЕТКА Королевская 500гр в/м 30/40 в панцире с головой ТМ Вичи Приорити	\N	\N	6090.00	шт	1	437	t	2025-12-14 13:04:30.263	2025-12-14 13:04:30.263	761.00	шт	8	поштучно
56650	3367	КРЕВЕТКА Северная 5кг в/м 70-90 Китай	\N	\N	7676.00	уп (5 шт)	1	500	t	2025-12-14 13:04:30.276	2025-12-14 13:04:30.276	1535.00	кг	5	только уп
56651	3367	Крабовые палочки 5кг вес ТМ VICI Columbus	\N	\N	1897.00	уп (5 шт)	1	10	t	2025-12-14 13:04:30.3	2025-12-14 13:04:30.3	379.00	кг	5	только уп
56652	3367	Крабовое мясо 180гр ТМ VICI Краб ОК	\N	\N	2559.00	шт	1	625	t	2025-12-14 13:04:30.319	2025-12-14 13:04:30.319	102.00	шт	25	поштучно
56653	3367	Крабовое мясо 200гр ТМ VICI	\N	\N	5319.00	шт	1	1000	t	2025-12-14 13:04:30.334	2025-12-14 13:04:30.334	213.00	шт	25	поштучно
56654	3367	Крабовое мясо 200гр ТМ VICI Columbus	\N	\N	2358.00	шт	1	134	t	2025-12-14 13:04:30.347	2025-12-14 13:04:30.347	94.00	шт	25	поштучно
56655	3367	Крабовое мясо 200гр ТМ VICI Краб ОК	\N	\N	2864.00	шт	1	397	t	2025-12-14 13:04:30.361	2025-12-14 13:04:30.361	115.00	шт	25	поштучно
56656	3367	Крабовое мясо 200гр ТМ Бремор	\N	\N	4313.00	шт	1	199	t	2025-12-14 13:04:30.375	2025-12-14 13:04:30.375	144.00	шт	30	поштучно
56657	3367	Крабовое мясо 200гр ТМ Крабия	\N	\N	2415.00	шт	1	150	t	2025-12-14 13:04:30.399	2025-12-14 13:04:30.399	81.00	шт	30	поштучно
56658	3367	Крабовое мясо 200гр ТМ Русское Море	\N	\N	1047.00	шт	1	417	t	2025-12-14 13:04:30.415	2025-12-14 13:04:30.415	150.00	шт	7	поштучно
56659	3367	Крабовое палочки экономные вес 5кг ТМ Бремор	\N	\N	322.00	кг	1	1000	t	2025-12-14 13:04:30.438	2025-12-14 13:04:30.438	322.00	кг	\N	поштучно
56660	3367	Крабовые палочки 100гр ТМ VICI	\N	\N	2933.00	шт	1	1000	t	2025-12-14 13:04:30.453	2025-12-14 13:04:30.453	98.00	шт	30	поштучно
56661	3367	Крабовые палочки 100гр ТМ VICI Columbus	\N	\N	2415.00	шт	1	251	t	2025-12-14 13:04:30.469	2025-12-14 13:04:30.469	43.00	шт	56	поштучно
56662	3367	Крабовые палочки 100гр ТМ VICI Краб ОК	\N	\N	3529.00	шт	1	1000	t	2025-12-14 13:04:30.481	2025-12-14 13:04:30.481	63.00	шт	56	поштучно
56663	3367	Крабовые палочки 100гр ТМ Крабия	\N	\N	2553.00	шт	1	75	t	2025-12-14 13:04:30.495	2025-12-14 13:04:30.495	43.00	шт	60	поштучно
56664	3367	Крабовые палочки 100гр ТМ Русское Море	\N	\N	4554.00	шт	1	739	t	2025-12-14 13:04:30.507	2025-12-14 13:04:30.507	76.00	шт	60	поштучно
56665	3367	Крабовые палочки 200гр с мясом натурального краба ТМ VICI	\N	\N	4637.00	шт	1	1000	t	2025-12-14 13:04:30.575	2025-12-14 13:04:30.575	258.00	шт	18	поштучно
56666	3367	Крабовые палочки 200гр ТМ VICI	\N	\N	6745.00	шт	1	1000	t	2025-12-14 13:04:30.593	2025-12-14 13:04:30.593	225.00	шт	30	поштучно
56667	3367	Крабовые палочки 200гр ТМ VICI Columbus	\N	\N	2691.00	шт	1	227	t	2025-12-14 13:04:30.614	2025-12-14 13:04:30.614	90.00	шт	30	поштучно
56668	3367	Крабовые палочки 200гр ТМ VICI Краб ОК	\N	\N	3933.00	шт	1	1000	t	2025-12-14 13:04:30.626	2025-12-14 13:04:30.626	131.00	шт	30	поштучно
56669	3367	Крабовые палочки 200гр ТМ Бремор	\N	\N	4313.00	шт	1	230	t	2025-12-14 13:04:30.643	2025-12-14 13:04:30.643	144.00	шт	30	поштучно
56670	3367	Крабовые палочки 200гр ТМ Крабия	\N	\N	2346.00	шт	1	337	t	2025-12-14 13:04:30.667	2025-12-14 13:04:30.667	78.00	шт	30	поштучно
56671	3367	Крабовые палочки 200гр ТМ Русское Море	\N	\N	1150.00	шт	1	1000	t	2025-12-14 13:04:30.679	2025-12-14 13:04:30.679	144.00	шт	8	поштучно
56672	3367	Крабовые палочки 240гр ТМ VICI Columbus	\N	\N	2703.00	шт	1	503	t	2025-12-14 13:04:30.691	2025-12-14 13:04:30.691	108.00	шт	25	поштучно
56673	3367	Крабовые палочки 240гр ТМ VICI Краб ОК	\N	\N	4347.00	шт	1	794	t	2025-12-14 13:04:30.702	2025-12-14 13:04:30.702	161.00	шт	27	поштучно
56674	3367	Крабовые палочки 300гр для рулетиков ТМ VICI	\N	\N	2404.00	шт	1	1000	t	2025-12-14 13:04:30.715	2025-12-14 13:04:30.715	218.00	шт	11	поштучно
56675	3367	Крабовые палочки 300гр ТМ VICI	\N	\N	2574.00	шт	1	431	t	2025-12-14 13:04:30.731	2025-12-14 13:04:30.731	184.00	шт	14	поштучно
56676	3367	Крабовые палочки 4*200гр ТМ VICI	\N	\N	4717.00	шт	1	228	t	2025-12-14 13:04:30.744	2025-12-14 13:04:30.744	674.00	шт	7	поштучно
56677	3367	Крабовые палочки 400гр ТМ Бремор	\N	\N	3243.00	шт	1	393	t	2025-12-14 13:04:30.772	2025-12-14 13:04:30.772	270.00	шт	12	поштучно
56678	3367	Крабовые палочки 400гр ТМ Русское Море	\N	\N	4244.00	шт	1	139	t	2025-12-14 13:04:30.786	2025-12-14 13:04:30.786	283.00	шт	15	поштучно
56679	3367	Крабовые палочки 500гр Снежный краб красный 1/12шт ТМ Санта Бремор	\N	\N	4858.00	шт	1	609	t	2025-12-14 13:04:30.8	2025-12-14 13:04:30.8	405.00	шт	12	поштучно
56680	3367	Крабовые палочки 500гр ТМ Бремор	\N	\N	3505.00	шт	1	6	t	2025-12-14 13:04:30.819	2025-12-14 13:04:30.819	292.00	шт	12	поштучно
56681	3398	ИКРА Масаго Энко Люкс зеленая 500гр 1/6шт	\N	\N	5175.00	шт	1	77	t	2025-12-14 13:04:30.838	2025-12-14 13:04:30.838	862.00	шт	6	поштучно
56682	3398	ИКРА Масаго Энко Люкс красная 500гр 1/6шт	\N	\N	5865.00	шт	1	104	t	2025-12-14 13:04:30.864	2025-12-14 13:04:30.864	977.00	шт	6	поштучно
56683	3398	ИКРА Масаго Энко Люкс оранжевая 500гр 1/6шт	\N	\N	5865.00	шт	1	152	t	2025-12-14 13:04:30.877	2025-12-14 13:04:30.877	977.00	шт	6	поштучно
56684	3367	ИКОРКА СЕЛЬДИ 160гр в сливочном соусе ст/б ТМ Меридиан	\N	\N	1610.00	шт	1	118	t	2025-12-14 13:04:30.889	2025-12-14 13:04:30.889	201.00	шт	8	поштучно
56685	3367	ИКОРКА СЕЛЬДИ 160гр подкопченая в соусе ст/б ТМ Меридиан	\N	\N	1610.00	шт	1	250	t	2025-12-14 13:04:30.912	2025-12-14 13:04:30.912	201.00	шт	8	поштучно
56686	3367	ИКОРКА СЕЛЬДИ 160гр с красной рыбкой ст/б ТМ Меридиан	\N	\N	1610.00	шт	1	143	t	2025-12-14 13:04:30.929	2025-12-14 13:04:30.929	201.00	шт	8	поштучно
56687	3367	ИКРА МОЙВЫ 165гр деликатесная с лососем ТМ Русское Море	\N	\N	1214.00	шт	1	132	t	2025-12-14 13:04:30.955	2025-12-14 13:04:30.955	202.00	шт	6	поштучно
56688	3367	ИКРА МОЙВЫ 180гр деликатесная классическая "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	300	t	2025-12-14 13:04:30.967	2025-12-14 13:04:30.967	259.00	шт	6	поштучно
56689	3367	ИКРА МОЙВЫ 180гр деликатесная подкопченая "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	228	t	2025-12-14 13:04:30.979	2025-12-14 13:04:30.979	259.00	шт	6	поштучно
56690	3367	ИКРА МОЙВЫ 180гр деликатесная с копчёным лососем "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	300	t	2025-12-14 13:04:30.992	2025-12-14 13:04:30.992	259.00	шт	6	поштучно
56691	3367	ИКРА МОЙВЫ 180гр деликатесная с креветкой "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	300	t	2025-12-14 13:04:31.005	2025-12-14 13:04:31.005	259.00	шт	6	поштучно
56692	3367	ИКРА МОЙВЫ 180гр деликатесная с лососем и авокадо "Икра №1" ТМ Санта Бремор	\N	\N	1552.00	шт	1	167	t	2025-12-14 13:04:31.018	2025-12-14 13:04:31.018	259.00	шт	6	поштучно
56693	3367	ИКРА МОЙВЫ 270гр деликатесная с копчёным лососем 1/6шт ТМ Санта Бремор	\N	\N	2084.00	шт	1	76	t	2025-12-14 13:04:31.033	2025-12-14 13:04:31.033	347.00	шт	6	поштучно
56694	3367	ИКРА мойвы деликатесная подкопченая 165гр ст/бан	\N	\N	1214.00	шт	1	237	t	2025-12-14 13:04:31.05	2025-12-14 13:04:31.05	202.00	шт	6	поштучно
56942	3395	ГРИБЫ ШАМПИНЬОНЫ целые  вес РОССИЯ	\N	\N	2935.00	уп (8 шт)	1	288	t	2025-12-14 13:04:35.331	2025-12-14 13:04:35.331	367.00	кг	8	только уп
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
56695	3367	ИКРА МОЙВЫ и СЕЛЬДИ 160гр деликатесная подкопченая "Икринка" ст/б ТМ Санта Бремор	\N	\N	1173.00	шт	1	70	t	2025-12-14 13:04:31.063	2025-12-14 13:04:31.063	195.00	шт	6	поштучно
56696	3367	ИКРА МОЙВЫ и СЕЛЬДИ 160гр деликатесная с копчёным лососем "Икринка" ст/б ТМ Санта Бремор	\N	\N	1173.00	шт	1	147	t	2025-12-14 13:04:31.078	2025-12-14 13:04:31.078	195.00	шт	6	поштучно
56697	3367	ИКРА МОЙВЫ и СЕЛЬДИ 160гр деликатесная с креветкой "Икринка" ст/б ТМ Санта Бремор	\N	\N	1173.00	шт	1	80	t	2025-12-14 13:04:31.089	2025-12-14 13:04:31.089	195.00	шт	6	поштучно
56698	3367	ИКРА мойвы с креветкой 165гр ст/бан	\N	\N	1214.00	шт	1	170	t	2025-12-14 13:04:31.1	2025-12-14 13:04:31.1	202.00	шт	6	поштучно
56699	3367	ИКРА Осетровая Черная 230гр имитированная Стольная ст/б 1/6шт ТМ Русское Море	\N	\N	911.00	шт	1	300	t	2025-12-14 13:04:31.113	2025-12-14 13:04:31.113	152.00	шт	6	поштучно
56700	3367	КАЛЬМАР 180гр командорский щупальца в заливке пл/лоток ТМ Русское Море	\N	\N	1808.00	шт	1	200	t	2025-12-14 13:04:31.125	2025-12-14 13:04:31.125	301.00	шт	6	поштучно
56701	3367	КАЛЬМАР 180гр соломка в заливке 1/6шт ТМ Русское Море	\N	\N	1656.00	шт	1	117	t	2025-12-14 13:04:31.139	2025-12-14 13:04:31.139	276.00	шт	6	поштучно
56702	3367	КАЛЬМАР 415гр щупальца и соломка  в рассоле стакан ТМ Milegrin	\N	\N	3843.00	шт	1	11	t	2025-12-14 13:04:31.165	2025-12-14 13:04:31.165	641.00	шт	6	поштучно
56703	3367	Кальмаровые палочки 180гр имитация с сыром ТМ Русское море	\N	\N	1249.00	шт	1	114	t	2025-12-14 13:04:31.177	2025-12-14 13:04:31.177	208.00	шт	6	поштучно
56704	3367	КОКТЕЙЛЬ 180гр из морепродуктов в масле "Оригинал" пл/лоток ТМ Русское Море	\N	\N	1746.00	шт	1	169	t	2025-12-14 13:04:31.191	2025-12-14 13:04:31.191	291.00	шт	6	поштучно
56705	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле  пл/лоток ТМ Меридиан	\N	\N	2870.00	шт	1	86	t	2025-12-14 13:04:31.203	2025-12-14 13:04:31.203	359.00	шт	8	поштучно
56706	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле с зеленью  пл/лоток ТМ Меридиан	\N	\N	2870.00	шт	1	288	t	2025-12-14 13:04:31.215	2025-12-14 13:04:31.215	359.00	шт	8	поштучно
56707	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле с зеленью "По-Мароккански" пл/лоток  Мирамар ТМ Меридиан	\N	\N	2631.00	шт	1	191	t	2025-12-14 13:04:31.227	2025-12-14 13:04:31.227	329.00	шт	8	поштучно
56708	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле с пряностями "По-Мексикански" пл/лоток Мирамар ТМ Меридиан	\N	\N	2631.00	шт	1	164	t	2025-12-14 13:04:31.239	2025-12-14 13:04:31.239	329.00	шт	8	поштучно
56709	3367	КОКТЕЙЛЬ 200гр из морепродуктов в масле с пряностями Мехико  пл/лоток ТМ Меридиан	\N	\N	2870.00	шт	1	243	t	2025-12-14 13:04:31.253	2025-12-14 13:04:31.253	359.00	шт	8	поштучно
56710	3367	КОКТЕЙЛЬ 415гр из морепродуктов в масле  стакан  ТМ Меридиан	\N	\N	4112.00	шт	1	7	t	2025-12-14 13:04:31.325	2025-12-14 13:04:31.325	685.00	шт	6	поштучно
54410	3367	СЕМГА 200гр п/копч филе-кусок ТМ Русское море	\N	\N	6313.00	ШТ	1	25	f	2025-12-07 13:19:47.408	2025-12-14 08:12:28.218	1052.00	ШТ	6	поштучно
56711	3367	Крабовые палочки 180гр с мясом натурального краба и сыром ТМ Русское море	\N	\N	1249.00	шт	1	300	t	2025-12-14 13:04:31.339	2025-12-14 13:04:31.339	208.00	шт	6	поштучно
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
56712	3367	Крабовые палочки 180гр с мясом натурального краба с сыром и зеленью ТМ Русское море	\N	\N	1249.00	шт	1	300	t	2025-12-14 13:04:31.406	2025-12-14 13:04:31.406	208.00	шт	6	поштучно
56713	3367	КРЕВЕТКИ 180гр в заливке пл/лоток ТМ Русское море	\N	\N	2132.00	шт	1	260	t	2025-12-14 13:04:31.425	2025-12-14 13:04:31.425	355.00	шт	6	поштучно
56714	3367	КРЕВЕТКИ 180гр с хвостиком в заливке "Королевские" 1/6шт ТМ Русское Море	\N	\N	2546.00	шт	1	148	t	2025-12-14 13:04:31.468	2025-12-14 13:04:31.468	424.00	шт	6	поштучно
56715	3367	Лососевые палочки 180гр имитация с сыром ТМ Русское море	\N	\N	1249.00	шт	1	168	t	2025-12-14 13:04:31.479	2025-12-14 13:04:31.479	208.00	шт	6	поштучно
56716	3367	М Икра Сельди ястычная 150гр с/с " К картошке" традиционная в масле 1/6шт ТМ Русское Море	\N	\N	1573.00	шт	1	6	t	2025-12-14 13:04:31.49	2025-12-14 13:04:31.49	262.00	шт	6	поштучно
56717	3367	МИДИИ 150гр в майонезно-горчичной заливке  пл/лоток ТМ Меридиан	\N	\N	2404.00	шт	1	279	t	2025-12-14 13:04:31.503	2025-12-14 13:04:31.503	240.00	шт	10	поштучно
56718	3367	МИДИИ 150гр в масле "По-Гречески" пл/лоток Мирамар ТМ Меридиан	\N	\N	1923.00	шт	1	245	t	2025-12-14 13:04:31.515	2025-12-14 13:04:31.515	240.00	шт	8	поштучно
56719	3367	МИДИИ 150гр в масле Брушетта  пл/лоток ТМ Меридиан	\N	\N	2404.00	шт	1	288	t	2025-12-14 13:04:31.526	2025-12-14 13:04:31.526	240.00	шт	10	поштучно
56720	3367	МИДИИ 150гр в масле пл/лоток ТМ Меридиан	\N	\N	2404.00	шт	1	227	t	2025-12-14 13:04:31.537	2025-12-14 13:04:31.537	240.00	шт	10	поштучно
56721	3367	МИДИИ 150гр в масле с зеленью "По-Итальянски" пл/лоток Мирамар ТМ Меридиан	\N	\N	1923.00	шт	1	235	t	2025-12-14 13:04:31.549	2025-12-14 13:04:31.549	240.00	шт	8	поштучно
56722	3367	МИДИИ 180гр в масле "Классик" пл/лоток ТМ Русское море	\N	\N	1594.00	шт	1	173	t	2025-12-14 13:04:31.561	2025-12-14 13:04:31.561	266.00	шт	6	поштучно
56723	3367	МИДИИ 180гр чилийские  в заливке пл/лоток ТМ Русское Море	\N	\N	1318.00	шт	1	126	t	2025-12-14 13:04:31.573	2025-12-14 13:04:31.573	220.00	шт	6	поштучно
56724	3367	МИДИИ 270гр в масле с вялеными томатами, чесноком и зеленью ТМ Меридиан	\N	\N	2208.00	шт	1	16	t	2025-12-14 13:04:31.587	2025-12-14 13:04:31.587	368.00	шт	6	поштучно
56725	3367	МИДИИ 415гр отборные в масле с перцем чили стакан ТМ Milegrin	\N	\N	3284.00	шт	1	10	t	2025-12-14 13:04:31.633	2025-12-14 13:04:31.633	547.00	шт	6	поштучно
56726	3367	МИДИИ 415гр отборные в масле с прованскими травами стакан ТМ Milegrin	\N	\N	3284.00	шт	1	21	t	2025-12-14 13:04:31.651	2025-12-14 13:04:31.651	547.00	шт	6	поштучно
56727	3367	МОРСКОЙ МИКС 180гр в заливке пл/лоток ТМ Русское Море	\N	\N	1580.00	шт	1	240	t	2025-12-14 13:04:31.665	2025-12-14 13:04:31.665	263.00	шт	6	поштучно
56728	3367	ПАСТА из морепродуктов 150гр Кальмар рубленый в слив.соусе с авокадо ТМ Санта Бремор	\N	\N	1014.00	шт	1	142	t	2025-12-14 13:04:31.677	2025-12-14 13:04:31.677	169.00	шт	6	поштучно
56729	3367	ПАСТА из морепродуктов 150гр Кальмар рубленый в слив.соусе с креветкой ТМ Санта Бремор	\N	\N	1014.00	шт	1	255	t	2025-12-14 13:04:31.769	2025-12-14 13:04:31.769	169.00	шт	6	поштучно
56730	3367	ПАСТА из морепродуктов 150гр классическая "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	300	t	2025-12-14 13:04:31.789	2025-12-14 13:04:31.789	198.00	шт	6	поштучно
56731	3367	ПАСТА из морепродуктов 150гр Краб в сливочном соусе с имитацией крабового мяса ТМ Санта Бремор	\N	\N	1187.00	шт	1	300	t	2025-12-14 13:04:31.853	2025-12-14 13:04:31.853	198.00	шт	6	поштучно
56732	3367	ПАСТА из морепродуктов 150гр подкопченная "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	300	t	2025-12-14 13:04:31.872	2025-12-14 13:04:31.872	198.00	шт	6	поштучно
56733	3367	ПАСТА из морепродуктов 150гр с Авокадо "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	204	t	2025-12-14 13:04:31.889	2025-12-14 13:04:31.889	198.00	шт	6	поштучно
56734	3367	ПАСТА из морепродуктов 150гр сладкий чили "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	165	t	2025-12-14 13:04:31.901	2025-12-14 13:04:31.901	198.00	шт	6	поштучно
56735	3367	ПАСТА из морепродуктов 150гр Сливочно/Чесночная "Антарктик Криль" ТМ Санта Бремор	\N	\N	1187.00	шт	1	276	t	2025-12-14 13:04:31.915	2025-12-14 13:04:31.915	198.00	шт	6	поштучно
56736	3367	ПАСТА из мяса мидии 150гр Сальса ТМ Санта Бремор	\N	\N	966.00	шт	1	82	t	2025-12-14 13:04:31.932	2025-12-14 13:04:31.932	161.00	шт	6	поштучно
56737	3367	ПАСТА из филе тресковых рыб 140гр с кальмаром и креветкой "Фиш-мусс" ТМ Санта Бремор	\N	\N	862.00	шт	1	83	t	2025-12-14 13:04:31.956	2025-12-14 13:04:31.956	144.00	шт	6	поштучно
56738	3367	ПАСТА из филе тресковых рыб 140гр с лососем "Фиш-мусс" ТМ Санта Бремор	\N	\N	862.00	шт	1	75	t	2025-12-14 13:04:31.967	2025-12-14 13:04:31.967	144.00	шт	6	поштучно
56739	3367	РИЕТ из лосося 100гр с каперсами и укропом ТМ Меридиан	\N	\N	1803.00	шт	1	44	t	2025-12-14 13:04:31.977	2025-12-14 13:04:31.977	225.00	шт	8	поштучно
56740	3367	РИЕТ из лосося 100гр с миндалем ТМ Меридиан	\N	\N	1803.00	шт	1	67	t	2025-12-14 13:04:31.99	2025-12-14 13:04:31.99	225.00	шт	8	поштучно
56741	3367	РИЕТ из лосося 100гр с мягким творогом ТМ Меридиан	\N	\N	1803.00	шт	1	50	t	2025-12-14 13:04:32.002	2025-12-14 13:04:32.002	225.00	шт	8	поштучно
56742	3367	РИЕТ из тунца 100гр с луком и васаби ТМ Меридиан	\N	\N	1711.00	шт	1	48	t	2025-12-14 13:04:32.014	2025-12-14 13:04:32.014	214.00	шт	8	поштучно
56743	3367	РИЕТ из тунца 100гр с оливками и огурцами ТМ Меридиан	\N	\N	1711.00	шт	1	50	t	2025-12-14 13:04:32.031	2025-12-14 13:04:32.031	214.00	шт	8	поштучно
56744	3367	РИЕТ из тунца 100гр ТМ Меридиан	\N	\N	1711.00	шт	1	49	t	2025-12-14 13:04:32.042	2025-12-14 13:04:32.042	214.00	шт	8	поштучно
56943	3395	ГРИБЫ ШАМПИНЬОНЫ целые вес Россия	\N	\N	2875.00	уп (10 шт)	1	500	t	2025-12-14 13:04:35.351	2025-12-14 13:04:35.351	288.00	кг	10	только уп
56944	3395	КАБАЧКИ кубик резаные вес Россия	\N	\N	1656.00	уп (10 шт)	1	10	t	2025-12-14 13:04:35.363	2025-12-14 13:04:35.363	166.00	кг	10	только уп
56945	3395	КАПУСТА БРОККОЛИ вес Египет	\N	\N	2519.00	уп (10 шт)	1	180	t	2025-12-14 13:04:35.384	2025-12-14 13:04:35.384	252.00	кг	10	только уп
56946	3395	КАПУСТА БРОККОЛИ вес Китай	\N	\N	2519.00	уп (10 шт)	1	500	t	2025-12-14 13:04:35.418	2025-12-14 13:04:35.418	252.00	кг	10	только уп
56947	3395	КАПУСТА БРОККОЛИ вес Россия	\N	\N	1759.00	уп (9 шт)	1	500	t	2025-12-14 13:04:35.434	2025-12-14 13:04:35.434	207.00	кг	9	только уп
56948	3395	КАПУСТА БРЮССЕЛЬСКАЯ  вес	\N	\N	3749.00	уп (10 шт)	1	70	t	2025-12-14 13:04:35.446	2025-12-14 13:04:35.446	375.00	кг	10	только уп
56949	3395	КАПУСТА Романеско вес Россия	\N	\N	2571.00	уп (9 шт)	1	60	t	2025-12-14 13:04:35.46	2025-12-14 13:04:35.46	302.00	кг	9	только уп
56950	3395	КАПУСТА ЦВЕТНАЯ  вес Узбекистан	\N	\N	2818.00	уп (10 шт)	1	30	t	2025-12-14 13:04:35.475	2025-12-14 13:04:35.475	282.00	кг	10	только уп
56951	3395	КАПУСТА ЦВЕТНАЯ вес Россия	\N	\N	2519.00	уп (10 шт)	1	500	t	2025-12-14 13:04:35.488	2025-12-14 13:04:35.488	252.00	кг	10	только уп
56952	3395	КУКУРУЗА зерно вес Россия	\N	\N	3852.00	уп (10 шт)	1	30	t	2025-12-14 13:04:35.506	2025-12-14 13:04:35.506	385.00	кг	10	только уп
56953	3395	КУКУРУЗА зерно вес Сербия	\N	\N	3795.00	уп (10 шт)	1	90	t	2025-12-14 13:04:35.517	2025-12-14 13:04:35.517	379.00	кг	10	только уп
56954	3395	КУКУРУЗА початки вес Индия	\N	\N	5046.00	уп (14 шт)	1	500	t	2025-12-14 13:04:35.529	2025-12-14 13:04:35.529	374.00	кг	14	только уп
56955	3395	КУКУРУЗА початки вес Россия	\N	\N	1801.00	уп (9 шт)	1	135	t	2025-12-14 13:04:35.54	2025-12-14 13:04:35.54	200.00	кг	9	только уп
56956	3395	МОРКОВЬ кубики вес Россия	\N	\N	2251.00	уп (14 шт)	1	27	t	2025-12-14 13:04:35.557	2025-12-14 13:04:35.557	167.00	кг	14	только уп
56957	3395	МОРКОВЬ мини вес	\N	\N	3795.00	уп (10 шт)	1	160	t	2025-12-14 13:04:35.569	2025-12-14 13:04:35.569	379.00	кг	10	только уп
56958	3395	МОРКОВЬ мини вес Китай	\N	\N	3795.00	уп (10 шт)	1	50	t	2025-12-14 13:04:35.582	2025-12-14 13:04:35.582	379.00	кг	10	только уп
56959	3395	ОВОЩИ ДЛЯ ЖАРКИ с картошкой и грибами вес Россия	\N	\N	2519.00	уп (10 шт)	1	40	t	2025-12-14 13:04:35.595	2025-12-14 13:04:35.595	252.00	кг	10	только уп
54471	3367	СЕЛЬДЬ вес ароматная жирная (в/уп) РПЗ ТАНДЕМ	\N	\N	3723.00	кг	1	65	f	2025-12-07 13:19:48.443	2025-12-14 08:12:23.827	286.00	кг	13	поштучно
54455	3367	ФИЛЕ ГОРБУШИ св/морож 1кг (в/уп) РПЗ ТАНДЕМ	\N	\N	13156.00	шт	1	113	f	2025-12-07 13:19:48.111	2025-12-14 08:12:24.152	822.00	шт	16	поштучно
56960	3395	ОВОЩИ ДЛЯ ЖАРКИ с шампиньонами  вес Россия	\N	\N	2473.00	уп (10 шт)	1	360	t	2025-12-14 13:04:35.607	2025-12-14 13:04:35.607	247.00	кг	10	только уп
56745	3367	САЛАТ 150гр из Морских водорослей "Чука" лоток ТМ Русское Море	\N	\N	959.00	шт	1	154	t	2025-12-14 13:04:32.057	2025-12-14 13:04:32.057	160.00	шт	6	поштучно
56746	3367	САЛАТ 150гр из Морских водорослей "Чука" с ореховым соусом лоток 1/6шт ТМ Русское Море	\N	\N	1083.00	шт	1	119	t	2025-12-14 13:04:32.073	2025-12-14 13:04:32.073	181.00	шт	6	поштучно
56747	3367	САЛАТ 200гр из Морской Капусты классическая лоток ТМ Русское Море	\N	\N	614.00	шт	1	122	t	2025-12-14 13:04:32.086	2025-12-14 13:04:32.086	102.00	шт	6	поштучно
56748	3367	САЛАТ 200гр из Морской Капусты классическая лоток ТМ Санта Бремор	\N	\N	1228.00	шт	1	18	t	2025-12-14 13:04:32.097	2025-12-14 13:04:32.097	102.00	шт	12	поштучно
56749	3367	САЛАТ 200гр из Морской Капусты по корейски с баклажанами лоток ТМ Русское Море	\N	\N	711.00	шт	1	108	t	2025-12-14 13:04:32.112	2025-12-14 13:04:32.112	118.00	шт	6	поштучно
56750	3367	САЛАТ 200гр из Морской Капусты по корейски с грибами лоток ТМ Русское Море	\N	\N	711.00	шт	1	143	t	2025-12-14 13:04:32.128	2025-12-14 13:04:32.128	118.00	шт	6	поштучно
56751	3367	САЛАТ 200гр из Морской Капусты по корейски с морковью лоток ТМ Русское Море	\N	\N	711.00	шт	1	265	t	2025-12-14 13:04:32.139	2025-12-14 13:04:32.139	118.00	шт	6	поштучно
56752	3367	САЛАТ 200гр из Морской Капусты с кальмаром лоток ТМ Русское Море	\N	\N	1780.00	шт	1	237	t	2025-12-14 13:04:32.154	2025-12-14 13:04:32.154	148.00	шт	12	поштучно
56753	3367	САЛАТ 200гр из Морской Капусты с луком и сладким перцем лоток ТМ Русское Море	\N	\N	642.00	шт	1	77	t	2025-12-14 13:04:32.167	2025-12-14 13:04:32.167	107.00	шт	6	поштучно
56754	3367	САЛАТ 200гр МК маринованный Витаминный с овощами 1/6шт ТМ Русское Море	\N	\N	738.00	шт	1	125	t	2025-12-14 13:04:32.179	2025-12-14 13:04:32.179	123.00	шт	6	поштучно
56755	3367	СЕЛЬДЬ 230гр Тихоокеанская слабосоленая Традиционный посол в масле 1/6шт ТМ Русское Море	\N	\N	1366.00	шт	1	247	t	2025-12-14 13:04:32.194	2025-12-14 13:04:32.194	228.00	шт	6	поштучно
56756	3367	СЕЛЬДЬ 230гр филе с кожей тихоокеанская слабосоленая Традиционный посол в масле ТМ Русское Море	\N	\N	1822.00	шт	1	67	t	2025-12-14 13:04:32.208	2025-12-14 13:04:32.208	228.00	шт	8	поштучно
56757	3367	СЕЛЬДЬ 230гр филе тихоокеанская слабосоленая Селедочка аппетитная в масле ТМ Русское Море	\N	\N	1366.00	шт	1	226	t	2025-12-14 13:04:32.219	2025-12-14 13:04:32.219	228.00	шт	6	поштучно
56758	3367	СЕЛЬДЬ 250гр филе деликатесное Матиас с приправами 1/6шт ТМ Санта Бремор	\N	\N	1822.00	шт	1	119	t	2025-12-14 13:04:32.23	2025-12-14 13:04:32.23	304.00	шт	6	поштучно
56759	3367	СЕЛЬДЬ 250гр филе Матиас Оригинальная в масле в/у ТМ Санта Бремор	\N	\N	1822.00	шт	1	167	t	2025-12-14 13:04:32.242	2025-12-14 13:04:32.242	304.00	шт	6	поштучно
56760	3367	СЕЛЬДЬ 250гр филе Матиас с ароматом дыма в/у ТМ Санта Бремор	\N	\N	1822.00	шт	1	113	t	2025-12-14 13:04:32.253	2025-12-14 13:04:32.253	304.00	шт	6	поштучно
56761	3367	СЕЛЬДЬ 250гр филе Матиас свежая зелень в/у ТМ Санта Бремор	\N	\N	3036.00	шт	1	177	t	2025-12-14 13:04:32.264	2025-12-14 13:04:32.264	304.00	шт	10	поштучно
56762	3367	СЕЛЬДЬ 300гр филе деликатесное Матиас XXL отборный в масле 1/6шт ТМ Санта Бремор	\N	\N	2291.00	шт	1	46	t	2025-12-14 13:04:32.276	2025-12-14 13:04:32.276	382.00	шт	6	поштучно
56763	3367	СЕЛЬДЬ 300гр филе деликатесное Матиас XXL отборный Оливковый в масле с добавлением оливкового 1/6шт ТМ Санта Бремор	\N	\N	2291.00	шт	1	66	t	2025-12-14 13:04:32.288	2025-12-14 13:04:32.288	382.00	шт	6	поштучно
56764	3367	СЕЛЬДЬ 500гр филе деликатесное Матиас Оригинал 1/6шт ТМ Санта Бремор	\N	\N	3346.00	шт	1	52	t	2025-12-14 13:04:32.3	2025-12-14 13:04:32.3	558.00	шт	6	поштучно
56765	3367	СЕЛЬДЬ ф/кусочки 150гр в масле Селедочка на перекус 1/10шт ТМ Русское Море	\N	\N	1461.00	шт	1	67	t	2025-12-14 13:04:32.316	2025-12-14 13:04:32.316	146.00	шт	10	поштучно
56766	3367	СЕЛЬДЬ ф/кусочки 240гр слабосоленые А-ля лосось в масле 1/8шт ТМ Русское Море	\N	\N	1840.00	шт	1	80	t	2025-12-14 13:04:32.332	2025-12-14 13:04:32.332	230.00	шт	8	поштучно
56767	3367	СЕЛЬДЬ ф/кусочки 240гр слабосоленые Традиционный посол в масле 1/8шт ТМ Русское Море	\N	\N	1840.00	шт	1	71	t	2025-12-14 13:04:32.343	2025-12-14 13:04:32.343	230.00	шт	8	поштучно
56768	3367	СЕЛЬДЬ ф/кусочки 400гр слабосоленые атлант К картошке в масле 1/6шт ТМ Русское Море	\N	\N	2084.00	шт	1	104	t	2025-12-14 13:04:32.354	2025-12-14 13:04:32.354	347.00	шт	6	поштучно
56769	3367	СЕЛЬДЬ ф/кусочки 400гр слабосоленые атлант К картошке с пряностями в масле 1/6шт ТМ Русское Море	\N	\N	2084.00	шт	1	56	t	2025-12-14 13:04:32.366	2025-12-14 13:04:32.366	347.00	шт	6	поштучно
56770	3367	СЕЛЬДЬ ф/кусочки 400гр слабосоленые тихоокеанские Селедочка аппетитная в масле ТМ Русское Море	\N	\N	2470.00	шт	1	28	t	2025-12-14 13:04:32.38	2025-12-14 13:04:32.38	412.00	шт	6	поштучно
56771	3367	СЕМГА 300гр п/копч филе-кусок ТМ Русское море	\N	\N	9212.00	шт	1	10	t	2025-12-14 13:04:32.407	2025-12-14 13:04:32.407	1535.00	шт	6	поштучно
56772	3367	ФОРЕЛЬ 300гр п/копч филе-кусок ТМ Русское море	\N	\N	9212.00	шт	1	13	t	2025-12-14 13:04:32.419	2025-12-14 13:04:32.419	1535.00	шт	6	поштучно
56773	3367	КИЛЬКА балтийская пряного посола 220гр пл/бан	\N	\N	3133.00	шт	1	41	t	2025-12-14 13:04:32.44	2025-12-14 13:04:32.44	261.00	шт	12	поштучно
56774	3367	САЛАТ 100гр из Баклажанов с капустой "По-Корейски" в/уп ТМ Рыбный День	\N	\N	4175.00	шт	1	96	t	2025-12-14 13:04:32.455	2025-12-14 13:04:32.455	139.00	шт	30	поштучно
56775	3367	САЛАТ 100гр из Кальмара с морковью "По-Корейски" в/уп ТМ Рыбный День	\N	\N	6210.00	шт	1	84	t	2025-12-14 13:04:32.474	2025-12-14 13:04:32.474	207.00	шт	30	поштучно
56776	3367	САЛАТ 100гр из Моркови "По-Корейски"  в/уп ТМ Рыбный День	\N	\N	2346.00	шт	1	172	t	2025-12-14 13:04:32.489	2025-12-14 13:04:32.489	78.00	шт	30	поштучно
56777	3367	САЛАТ 100гр из Морских водорослей "Чука" пл/лоток ТМ Рыбный День	\N	\N	4278.00	шт	1	98	t	2025-12-14 13:04:32.502	2025-12-14 13:04:32.502	143.00	шт	30	поштучно
56778	3367	САЛАТ 100гр из Папоротника "По-Корейски " пл/лоток ТМ Рыбный День	\N	\N	4865.00	шт	1	177	t	2025-12-14 13:04:32.578	2025-12-14 13:04:32.578	162.00	шт	30	поштучно
56779	3367	САЛАТ 150гр из Баклажанов "По-Корейски" пл/лоток ТМ Рыбный День	\N	\N	5060.00	шт	1	88	t	2025-12-14 13:04:32.624	2025-12-14 13:04:32.624	253.00	шт	20	поштучно
56780	3367	САЛАТ 150гр из Кальмара "По-Восточному" пл/лоток ТМ Рыбный День	\N	\N	8188.00	шт	1	136	t	2025-12-14 13:04:32.642	2025-12-14 13:04:32.642	409.00	шт	20	поштучно
56781	3367	САЛАТ 150гр из Кальмара "По-Корейски"  пл/лоток ТМ Рыбный День	\N	\N	9407.00	шт	1	155	t	2025-12-14 13:04:32.657	2025-12-14 13:04:32.657	470.00	шт	20	поштучно
56782	3367	САЛАТ 150гр из Мидии по-Корейски ТМ Рыбный День	\N	\N	8878.00	шт	1	45	t	2025-12-14 13:04:32.669	2025-12-14 13:04:32.669	444.00	шт	20	поштучно
56783	3367	САЛАТ 150гр из Моркови "По-Корейски"  пл/лоток ТМ Рыбный День	\N	\N	2369.00	шт	1	200	t	2025-12-14 13:04:32.682	2025-12-14 13:04:32.682	118.00	шт	20	поштучно
56784	3367	САЛАТ 150гр из Моркови с Грибами "По-Корейски"  пл/лоток ТМ Рыбный День	\N	\N	3082.00	шт	1	200	t	2025-12-14 13:04:32.694	2025-12-14 13:04:32.694	154.00	шт	20	поштучно
56785	3367	САЛАТ 150гр из Морской Капусты  "По-Восточному"  пл/лоток ТМ Рыбный День	\N	\N	2070.00	шт	1	101	t	2025-12-14 13:04:32.706	2025-12-14 13:04:32.706	103.00	шт	20	поштучно
56786	3367	САЛАТ 150гр из Морской Капусты  пл/лоток ТМ Рыбный День	\N	\N	2093.00	шт	1	161	t	2025-12-14 13:04:32.721	2025-12-14 13:04:32.721	105.00	шт	20	поштучно
56787	3367	САЛАТ 150гр из Морской Капусты "По-Восточному" с кальмаром пл/лоток ТМ Рыбный День	\N	\N	3818.00	шт	1	200	t	2025-12-14 13:04:32.737	2025-12-14 13:04:32.737	191.00	шт	20	поштучно
56788	3367	САЛАТ 150гр из Морской Капусты" Юбилейный " с кальмаром  пл/лоток ТМ Рыбный День	\N	\N	3956.00	шт	1	200	t	2025-12-14 13:04:32.754	2025-12-14 13:04:32.754	198.00	шт	20	поштучно
56789	3367	САЛАТ 150гр из Папоротника "По-Корейски " пл/лоток ТМ Рыбный День	\N	\N	5037.00	шт	1	129	t	2025-12-14 13:04:32.779	2025-12-14 13:04:32.779	252.00	шт	20	поштучно
56790	3367	САЛАТ 150гр из Сельди "По-Корейски" "ХЕ"  пл/лоток ТМ Рыбный День	\N	\N	3703.00	шт	1	97	t	2025-12-14 13:04:32.793	2025-12-14 13:04:32.793	185.00	шт	20	поштучно
56791	3367	САЛАТ 180гр из Грибов "По-Корейски" пл/лоток ТМ Рыбный День	\N	\N	7383.00	шт	1	167	t	2025-12-14 13:04:32.804	2025-12-14 13:04:32.804	369.00	шт	20	поштучно
56792	3367	САЛАТ 180гр МК с кальмаром в майонезе пл/лоток ТМ Рыбный День	\N	\N	5014.00	шт	1	200	t	2025-12-14 13:04:32.822	2025-12-14 13:04:32.822	251.00	шт	20	поштучно
56793	3367	САЛАТ 180гр МК с мидией в майонезе пл/лоток ТМ Рыбный День	\N	\N	5037.00	шт	1	198	t	2025-12-14 13:04:32.835	2025-12-14 13:04:32.835	252.00	шт	20	поштучно
56794	3367	САЛАТ 180гр МК с овощами в майонезно-горчичном соусе пл/лоток ТМ Рыбный День	\N	\N	2599.00	шт	1	63	t	2025-12-14 13:04:32.846	2025-12-14 13:04:32.846	130.00	шт	20	поштучно
56795	3367	САЛАТ 180гр Солянка из Морской Капусты с грибами  пл/лоток ТМ Рыбный День	\N	\N	2944.00	шт	1	200	t	2025-12-14 13:04:32.871	2025-12-14 13:04:32.871	147.00	шт	20	поштучно
56796	3367	САЛАТ 180гр Солянка из Морской Капусты с кальмаром  пл/лоток ТМ Рыбный День	\N	\N	2967.00	шт	1	200	t	2025-12-14 13:04:32.883	2025-12-14 13:04:32.883	148.00	шт	20	поштучно
56797	3367	САЛАТ 180гр Солянка из Морской Капусты с папоротником пл/лоток ТМ Рыбный День	\N	\N	4255.00	шт	1	144	t	2025-12-14 13:04:32.895	2025-12-14 13:04:32.895	213.00	шт	20	поштучно
56798	3367	САЛАТ 500гр из Морской Капусты "по-Восточному" пл/конт ТМ Рыбный День	\N	\N	1677.00	шт	1	8	t	2025-12-14 13:04:32.906	2025-12-14 13:04:32.906	279.00	шт	6	поштучно
56799	3367	САЛАТ 500гр из Морской Капусты "Юбилейный" с кальмаром пл/конт ТМ Рыбный День	\N	\N	3429.00	шт	1	86	t	2025-12-14 13:04:32.919	2025-12-14 13:04:32.919	572.00	шт	6	поштучно
56800	3367	САЛАТ 500гр из Морской Капусты пл/конт ТМ Рыбный День	\N	\N	1649.00	шт	1	102	t	2025-12-14 13:04:32.95	2025-12-14 13:04:32.95	275.00	шт	6	поштучно
56801	3367	САЛАТ 500гр из Папоротника "По-Корейски " пл/лоток ТМ Рыбный День	\N	\N	4464.00	шт	1	7	t	2025-12-14 13:04:32.962	2025-12-14 13:04:32.962	744.00	шт	6	поштучно
56802	3367	ИКРА МИНТАЯ Деликатесная 180гр (пл/банка) РПЗ ТАНДЕМ	\N	\N	8642.00	шт	1	300	t	2025-12-14 13:04:32.974	2025-12-14 13:04:32.974	192.00	шт	45	поштучно
56803	3367	ПАЛОЧКИ Рыбные 310гр для жарки (скин/уп) РПЗ ТАНДЕМ	\N	\N	12282.00	шт	1	61	t	2025-12-14 13:04:32.985	2025-12-14 13:04:32.985	307.00	шт	40	поштучно
56804	3367	ПЕЛЬМЕНИ Адмиральские рыбные с палтусом 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	4554.00	шт	1	6	t	2025-12-14 13:04:32.998	2025-12-14 13:04:32.998	304.00	шт	15	поштучно
56805	3367	ПЕЛЬМЕНИ Деликатесные рыбные с морской капустой 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	3312.00	шт	1	18	t	2025-12-14 13:04:33.009	2025-12-14 13:04:33.009	221.00	шт	15	поштучно
56806	3367	ПЕЛЬМЕНИ Особые рыбные горбуша минтай 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	4388.00	шт	1	23	t	2025-12-14 13:04:33.022	2025-12-14 13:04:33.022	244.00	шт	18	поштучно
56807	3367	ПЕЛЬМЕНИ По-капитански рыбные с трубачом 400гр п/пак коробка РПЗ ТАНДЕМ	\N	\N	7072.00	шт	1	24	t	2025-12-14 13:04:33.035	2025-12-14 13:04:33.035	471.00	шт	15	поштучно
56808	3367	ТРУБАЧ филе мороженый очищенный  500гр в/уп коробка РПЗ ТАНДЕМ	\N	\N	1518.00	шт	1	300	t	2025-12-14 13:04:33.046	2025-12-14 13:04:33.046	1518.00	шт	1	поштучно
56809	3367	ФАРШ Лосось мороженый 500гр (в/уп) РПЗ ТАНДЕМ	\N	\N	9729.00	шт	1	300	t	2025-12-14 13:04:33.061	2025-12-14 13:04:33.061	270.00	шт	36	поштучно
56810	3367	ФИЛЕ КЕТЫ  св/морож вес (1шт~300-500гр) (скин/уп) РПЗ ТАНДЕМ	\N	\N	994.00	кг	1	48	t	2025-12-14 13:04:33.074	2025-12-14 13:04:33.074	994.00	кг	1	поштучно
56811	3399	НАБОР к пиву Лососевый закусочный (Горбуша, Кета) 100гр в/уп РПЗ ТАНДЕМ	\N	\N	8211.00	шт	1	261	t	2025-12-14 13:04:33.085	2025-12-14 13:04:33.085	117.00	шт	70	поштучно
56812	3399	СОЛОМКА Лососевая Ассорти п/к вес 5кг РПЗ ТАНДЕМ	\N	\N	8913.00	кг	1	25	t	2025-12-14 13:04:33.098	2025-12-14 13:04:33.098	1782.00	кг	5	поштучно
56813	3399	СОЛОМКА Лосось суш/вяленая ароматная 70гр пакет в/у	\N	\N	31050.00	шт	1	300	t	2025-12-14 13:04:33.113	2025-12-14 13:04:33.113	155.00	шт	200	поштучно
56814	3399	СОЛОМКА Минтай суш/вяленая 100гр пакет РПЗ ТАНДЕМ	\N	\N	5681.00	шт	1	300	t	2025-12-14 13:04:33.124	2025-12-14 13:04:33.124	284.00	шт	20	поштучно
56815	3367	ГОРБУША боковник п/к 250гр (в/уп) РПЗ ТАНДЕМ	\N	\N	9706.00	шт	1	278	t	2025-12-14 13:04:33.135	2025-12-14 13:04:33.135	243.00	шт	40	поштучно
56816	3367	ГОРБУША тушка п/к ВЕС (в/уп)  РПЗ ТАНДЕМ	\N	\N	531.00	кг	1	54	t	2025-12-14 13:04:33.148	2025-12-14 13:04:33.148	531.00	кг	\N	поштучно
56817	3367	ГОРБУША ф/кусочки 230гр (пл/банка) в масле м/с РПЗ ТАНДЕМ	\N	\N	14904.00	шт	1	135	t	2025-12-14 13:04:33.162	2025-12-14 13:04:33.162	331.00	шт	45	поштучно
56818	3367	КЕТА брюшки м/с 300гр (в/уп) РПЗ ТАНДЕМ	\N	\N	28462.00	шт	1	244	t	2025-12-14 13:04:33.173	2025-12-14 13:04:33.173	569.00	шт	50	поштучно
56819	3367	КЕТА ф/кусок 100гр (в/уп) Юкола суш/вял с пряностью РПЗ ТАНДЕМ	\N	\N	20355.00	шт	1	72	t	2025-12-14 13:04:33.185	2025-12-14 13:04:33.185	339.00	шт	60	поштучно
56820	3367	КЕТА ф/кусок п/к 250гр (в/уп) РПЗ ТАНДЕМ	\N	\N	19320.00	шт	1	56	t	2025-12-14 13:04:33.198	2025-12-14 13:04:33.198	483.00	шт	40	поштучно
56821	3367	КЕТА ф/кусочки 170гр (пл/банка) п/к м/с в масле	\N	\N	523.00	шт	1	34	t	2025-12-14 13:04:33.208	2025-12-14 13:04:33.208	523.00	шт	1	поштучно
56822	3367	КЕТА ф/кусочки 230гр (пл/банка) Закусочные в масле с чесноком м/сол РПЗ ТАНДЕМ	\N	\N	17336.00	шт	1	178	t	2025-12-14 13:04:33.222	2025-12-14 13:04:33.222	385.00	шт	45	поштучно
56823	3367	КЕТА ф/ломтики 100гр (подложка) м/сол РПЗ ТАНДЕМ	\N	\N	17469.00	шт	1	300	t	2025-12-14 13:04:33.234	2025-12-14 13:04:33.234	250.00	шт	70	поштучно
56824	3367	КЕТА ф/ломтики 100гр (подложка) подкопченная ДВ РПЗ ТАНДЕМ	\N	\N	17469.00	шт	1	300	t	2025-12-14 13:04:33.245	2025-12-14 13:04:33.245	250.00	шт	70	поштучно
56825	3367	КЕТА ф/ломтики 230гр (пл/банка) м/сол в горчичном соусе РПЗ ТАНДЕМ	\N	\N	20183.00	шт	1	110	t	2025-12-14 13:04:33.254	2025-12-14 13:04:33.254	448.00	шт	45	поштучно
56826	3367	КЕТА ф/ломтики 230гр (пл/банка) м/сол в масле РПЗ ТАНДЕМ	\N	\N	20183.00	шт	1	90	t	2025-12-14 13:04:33.319	2025-12-14 13:04:33.319	448.00	шт	45	поштучно
56827	3367	КЕТА ф/ломтики 230гр (пл/банка) м/сол в масле с пряностями РПЗ ТАНДЕМ	\N	\N	26910.00	шт	1	155	t	2025-12-14 13:04:33.338	2025-12-14 13:04:33.338	448.00	шт	60	поштучно
56828	3367	КЕТА ф/ломтики 230гр (пл/банка) подкопченная в масле РПЗ ТАНДЕМ	\N	\N	20183.00	шт	1	186	t	2025-12-14 13:04:33.395	2025-12-14 13:04:33.395	448.00	шт	45	поштучно
56829	3367	СЕЛЬДЬ вес малосоленая жирная (в/уп) РПЗ ТАНДЕМ	\N	\N	3220.00	кг	1	220	t	2025-12-14 13:04:33.418	2025-12-14 13:04:33.418	230.00	кг	14	поштучно
56831	3367	СЕЛЬДЬ вес малосоленая ОЛЮТОРКА (в/уп) РПЗ ТАНДЕМ	\N	\N	7567.00	кг	1	6	t	2025-12-14 13:04:33.443	2025-12-14 13:04:33.443	541.00	кг	14	поштучно
56832	3367	СЕЛЬДЬ вес с Пряностью "По-Голландски" тушка потрошен без головы (в/уп)  РПЗ ТАНДЕМ	\N	\N	4605.00	кг	1	214	t	2025-12-14 13:04:33.456	2025-12-14 13:04:33.456	329.00	кг	14	поштучно
56833	3367	СЕЛЬДЬ вес с Пряностью "По-Голландски" тушка потрошен без головы в ведре 5кг РПЗ ТАНДЕМ	\N	\N	1644.00	кг	1	33	t	2025-12-14 13:04:33.467	2025-12-14 13:04:33.467	329.00	кг	5	поштучно
56834	3367	СЕЛЬДЬ вес с Пряностью "По-Шведски" (в/уп)  РПЗ ТАНДЕМ	\N	\N	3188.00	кг	1	113	t	2025-12-14 13:04:33.48	2025-12-14 13:04:33.48	228.00	кг	14	поштучно
56835	3367	СЕЛЬДЬ ф/кусочки 200гр (т/ф) в горчичном соусе РПЗ ТАНДЕМ	\N	\N	11077.00	шт	1	284	t	2025-12-14 13:04:33.492	2025-12-14 13:04:33.492	198.00	шт	56	поштучно
56836	3367	СЕЛЬДЬ ф/кусочки 200гр (т/ф) в масле РПЗ ТАНДЕМ	\N	\N	11077.00	шт	1	300	t	2025-12-14 13:04:33.503	2025-12-14 13:04:33.503	198.00	шт	56	поштучно
56837	3367	СЕЛЬДЬ ф/кусочки 200гр (т/ф) в томате РПЗ ТАНДЕМ	\N	\N	11077.00	шт	1	300	t	2025-12-14 13:04:33.516	2025-12-14 13:04:33.516	198.00	шт	56	поштучно
56838	3367	СЕЛЬДЬ ф/кусочки 200гр (т/ф) в укропном соусе РПЗ ТАНДЕМ	\N	\N	11077.00	шт	1	300	t	2025-12-14 13:04:33.53	2025-12-14 13:04:33.53	198.00	шт	56	поштучно
56839	3367	СЕЛЬДЬ ф/кусочки 230гр (пл/бан) в горчичном соусе  РПЗ ТАНДЕМ	\N	\N	11644.00	шт	1	264	t	2025-12-14 13:04:33.542	2025-12-14 13:04:33.542	259.00	шт	45	поштучно
56840	3367	СЕЛЬДЬ ф/кусочки 230гр (пл/бан) в масле РПЗ ТАНДЕМ	\N	\N	11644.00	шт	1	300	t	2025-12-14 13:04:33.557	2025-12-14 13:04:33.557	259.00	шт	45	поштучно
56841	3367	СЕЛЬДЬ ф/кусочки 230гр (пл/бан) в томатном соусе РПЗ ТАНДЕМ	\N	\N	11644.00	шт	1	300	t	2025-12-14 13:04:33.568	2025-12-14 13:04:33.568	259.00	шт	45	поштучно
56842	3367	СЕЛЬДЬ ф/кусочки 230гр (пл/бан) в укропном соусе РПЗ ТАНДЕМ	\N	\N	11644.00	шт	1	300	t	2025-12-14 13:04:33.578	2025-12-14 13:04:33.578	259.00	шт	45	поштучно
56843	3367	СЕЛЬДЬ филе Жирная Малосоленая 200гр (в/уп) РПЗ ТАНДЕМ	\N	\N	8901.00	шт	1	300	t	2025-12-14 13:04:33.589	2025-12-14 13:04:33.589	148.00	шт	60	поштучно
56844	3367	САЛАТ из морской капусты 150гр в/уп Здоровье с брусникой РПЗ ТАНДЕМ	\N	\N	9660.00	шт	1	300	t	2025-12-14 13:04:33.605	2025-12-14 13:04:33.605	121.00	шт	80	поштучно
56845	3367	САЛАТ из морской капусты 150гр в/уп РПЗ ТАНДЕМ	\N	\N	9844.00	шт	1	300	t	2025-12-14 13:04:33.616	2025-12-14 13:04:33.616	123.00	шт	80	поштучно
56846	3367	САЛАТ из морской капусты 150гр в/уп с икрой сельди РПЗ ТАНДЕМ	\N	\N	11960.00	шт	1	300	t	2025-12-14 13:04:33.628	2025-12-14 13:04:33.628	150.00	шт	80	поштучно
56847	3367	САЛАТ из морской капусты 150гр в/уп с мясом краба РПЗ ТАНДЕМ	\N	\N	19688.00	шт	1	103	t	2025-12-14 13:04:33.64	2025-12-14 13:04:33.64	246.00	шт	80	поштучно
56848	3367	САЛАТ из морской капусты 150гр в/уп с трубачом РПЗ ТАНДЕМ	\N	\N	13156.00	шт	1	274	t	2025-12-14 13:04:33.651	2025-12-14 13:04:33.651	164.00	шт	80	поштучно
56849	3367	САЛАТ из морской капусты 150гр в/уп Юбилейный с кальмаром РПЗ ТАНДЕМ	\N	\N	19412.00	шт	1	300	t	2025-12-14 13:04:33.688	2025-12-14 13:04:33.688	243.00	шт	80	поштучно
56850	3367	САЛАТ из морской капусты 200гр пл/банка Любимый с кальмаром в томате РПЗ ТАНДЕМ	\N	\N	13196.00	шт	1	118	t	2025-12-14 13:04:33.762	2025-12-14 13:04:33.762	293.00	шт	45	поштучно
56851	3367	САЛАТ из морской капусты 200гр пл/банка Солянка с кальмаром РПЗ ТАНДЕМ	\N	\N	13196.00	шт	1	300	t	2025-12-14 13:04:33.814	2025-12-14 13:04:33.814	293.00	шт	45	поштучно
56852	3367	САЛАТ из морской капусты 200гр т/форма Восточный РПЗ ТАНДЕМ	\N	\N	7535.00	шт	1	73	t	2025-12-14 13:04:33.826	2025-12-14 13:04:33.826	135.00	шт	56	поштучно
56853	3367	САЛАТ из морской капусты 200гр т/форма Острая Закуска РПЗ ТАНДЕМ	\N	\N	7857.00	шт	1	300	t	2025-12-14 13:04:33.873	2025-12-14 13:04:33.873	140.00	шт	56	поштучно
56854	3367	САЛАТ из морской капусты 200гр т/форма с сельдью в морковно-томат соусе РПЗ ТАНДЕМ	\N	\N	7857.00	шт	1	300	t	2025-12-14 13:04:33.886	2025-12-14 13:04:33.886	140.00	шт	56	поштучно
56855	3395	ИНДЕЙКА ПО-БУРГУНСКИ 600гр пакет ТМ 4 Сезона	\N	\N	5327.00	шт	1	20	t	2025-12-14 13:04:33.897	2025-12-14 13:04:33.897	444.00	шт	12	поштучно
56856	3395	КУРОЧКА по-ПЕКИНСКИ китайское блюдо (рис, грудка кур, морковь, чёрный китайский гриб, бамбук, ростки маш, зел горошек, приправы) 600гр пакет ТМ 4 Сезона	\N	\N	5203.00	шт	1	110	t	2025-12-14 13:04:33.909	2025-12-14 13:04:33.909	434.00	шт	12	поштучно
56857	3395	ПАЭЛЬЯ испанское блюдо (рис, грудка кур, креветки, мидии, кальмар) 600гр пакет ТМ 4 Сезона СНИЖЕНИЕ ЦЕНЫ	\N	\N	7204.00	шт	1	55	t	2025-12-14 13:04:33.923	2025-12-14 13:04:33.923	600.00	шт	12	поштучно
56858	3395	ПЕННЕ КАРБОНАРА итальянское блюдо (макароны, ветчина, шампиньоны, горошек, сыр) 600гр пакет ТМ 4 Сезона СНИЖЕНИЕ ЦЕНЫ	\N	\N	5672.00	шт	1	42	t	2025-12-14 13:04:33.935	2025-12-14 13:04:33.935	473.00	шт	12	поштучно
56859	3395	ПРИМА ВЕРДЕ итальянское  блюдо (макароны, грудка кур, шпинат, цукини, томаты, сыр, специи) 600гр пакет ТМ 4 Сезона СНИЖЕНИЕ ЦЕНЫ	\N	\N	6486.00	шт	1	118	t	2025-12-14 13:04:33.95	2025-12-14 13:04:33.95	541.00	шт	12	поштучно
56860	3395	РИЗОТТО с МОРЕПРОДУКТАМИ итальянское блюдо (рис,  кальмары, мясо мидий, осьминоги, креветки, лук, приправы) 600гр пакет ТМ 4 Сезона СНИЖЕНИЕ ЦЕНЫ	\N	\N	8970.00	шт	1	58	t	2025-12-14 13:04:33.962	2025-12-14 13:04:33.962	747.00	шт	12	поштучно
56861	3395	ФОНДЮ ЭМЕНТАЛЬ швейцарское блюдо (макароны, грудка, грибы, броколи, сыр) 600гр пакет ТМ 4 Сезона	\N	\N	7673.00	шт	1	110	t	2025-12-14 13:04:33.973	2025-12-14 13:04:33.973	639.00	шт	12	поштучно
56862	3395	ЦЫПЛЕНОК ПО-МЕКСИКАНСКИ латиноамериканское блюдо (картофель, грудка кур, красная фасоль, зелёная стручковая фасоль, зёрна кукурузы, сладкий перец, лук) 600гр пакет ТМ 4 Сезона	\N	\N	5272.00	шт	1	80	t	2025-12-14 13:04:33.992	2025-12-14 13:04:33.992	439.00	шт	12	поштучно
56863	3395	ШАМПИНЬОНЫ де ПАРИ французское блюдо (картофель, грудка кур, шампиньоны, зелёная стручковая фасоль, томаты, лук) 600гр пакет ТМ 4 Сезона	\N	\N	5272.00	шт	1	70	t	2025-12-14 13:04:34.004	2025-12-14 13:04:34.004	439.00	шт	12	поштучно
56864	3395	Якисоба 600гр пакет ТМ 4 Сезона	\N	\N	5368.00	шт	1	40	t	2025-12-14 13:04:34.015	2025-12-14 13:04:34.015	447.00	шт	12	поштучно
56865	3395	КАРТОФЕЛЬ для жарки 450гр ТМ Морозко Green	\N	\N	2061.00	шт	1	128	t	2025-12-14 13:04:34.029	2025-12-14 13:04:34.029	129.00	шт	16	поштучно
56866	3395	КАРТОФЕЛЬ По-Деревенски 700гр ТМ 4 Сезона	\N	\N	3864.00	шт	1	161	t	2025-12-14 13:04:34.042	2025-12-14 13:04:34.042	322.00	шт	12	поштучно
56867	3395	КАРТОФЕЛЬ Фри 2,5кг 10мм Прямой 1/4шт ТМ Вичи	\N	\N	3565.00	шт	1	200	t	2025-12-14 13:04:34.057	2025-12-14 13:04:34.057	891.00	шт	4	поштучно
56868	3395	КАРТОФЕЛЬ Фри 2,5кг 6мм с панировкой Фрай Ми ТМ Ви Фрай	\N	\N	5020.00	шт	1	75	t	2025-12-14 13:04:34.069	2025-12-14 13:04:34.069	1004.00	шт	5	поштучно
56869	3395	КАРТОФЕЛЬ Фри 2,5кг 6мм Триумф ТМ Ви Фрай	\N	\N	5020.00	шт	1	200	t	2025-12-14 13:04:34.08	2025-12-14 13:04:34.08	1004.00	шт	5	поштучно
56870	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм  обжаренный ТМ ООО БИЛД	\N	\N	3179.00	шт	1	179	t	2025-12-14 13:04:34.097	2025-12-14 13:04:34.097	795.00	шт	4	поштучно
56871	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм  ТМ Fine Food	\N	\N	7666.00	шт	1	94	t	2025-12-14 13:04:34.107	2025-12-14 13:04:34.107	1278.00	шт	6	поштучно
56872	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм с панировкой ТМ Lamb Weston	\N	\N	4842.00	шт	1	200	t	2025-12-14 13:04:34.123	2025-12-14 13:04:34.123	968.00	шт	5	поштучно
56873	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм Сладкий Батат в панировке ТМ ТМ Ви Фрай	\N	\N	9355.00	шт	1	61	t	2025-12-14 13:04:34.137	2025-12-14 13:04:34.137	1871.00	шт	5	поштучно
56874	3395	КАРТОФЕЛЬ Фри 2,5кг 9мм Триумф ТМ Ви Фрай	\N	\N	5221.00	шт	1	200	t	2025-12-14 13:04:34.148	2025-12-14 13:04:34.148	1044.00	шт	5	поштучно
56875	3395	КАРТОФЕЛЬ Фри 450гр ТМ 4 Сезона	\N	\N	3887.00	шт	1	173	t	2025-12-14 13:04:34.165	2025-12-14 13:04:34.165	194.00	шт	20	поштучно
56876	3395	КАРТОФЕЛЬ Фри 450гр ТМ Морозко Green	\N	\N	2852.00	шт	1	163	t	2025-12-14 13:04:34.18	2025-12-14 13:04:34.18	178.00	шт	16	поштучно
56877	3395	КАРТОФЕЛЬ Фри 700гр ТМ Морозко Green	\N	\N	3312.00	шт	1	152	t	2025-12-14 13:04:34.193	2025-12-14 13:04:34.193	276.00	шт	12	поштучно
56878	3395	КАРТОФЕЛЬ Фри 900гр ТМ 4 Сезона	\N	\N	3887.00	шт	1	140	t	2025-12-14 13:04:34.207	2025-12-14 13:04:34.207	389.00	шт	10	поштучно
56879	3395	КАРТОФЕЛЬ фри волнистый 2,5кг ТМ Ozgorkey Feast	\N	\N	6886.00	шт	1	200	t	2025-12-14 13:04:34.217	2025-12-14 13:04:34.217	1148.00	шт	6	поштучно
56880	3395	КАРТОФЕЛЬНЫЕ Cтрипсы 2,5кг с луком и черным перцем ТМ Ви Фрай	\N	\N	5894.00	шт	1	50	t	2025-12-14 13:04:34.23	2025-12-14 13:04:34.23	1179.00	шт	5	поштучно
56881	3395	КАРТОФЕЛЬНЫЕ Бруски вес	\N	\N	2766.00	кг	1	200	t	2025-12-14 13:04:34.242	2025-12-14 13:04:34.242	213.00	кг	13	поштучно
56882	3395	КАРТОФЕЛЬНЫЕ Дольки 2,5кг в кожуре Astrafray ТМ ООО БИЛД	\N	\N	3179.00	шт	1	9	t	2025-12-14 13:04:34.255	2025-12-14 13:04:34.255	795.00	шт	4	поштучно
56883	3395	КАРТОФЕЛЬНЫЕ Дольки 2,5кг в кожуре со специями ТМ Ви Фрай	\N	\N	6290.00	шт	1	200	t	2025-12-14 13:04:34.269	2025-12-14 13:04:34.269	1258.00	шт	5	поштучно
56884	3395	КАРТОФЕЛЬНЫЕ Дольки 2,5кг в кожуре ТМ Ви Фрай	\N	\N	5503.00	шт	1	200	t	2025-12-14 13:04:34.283	2025-12-14 13:04:34.283	1101.00	шт	5	поштучно
56885	3395	КАРТОФЕЛЬНЫЕ Дольки в кожуре вес	\N	\N	3381.00	кг	1	84	t	2025-12-14 13:04:34.305	2025-12-14 13:04:34.305	241.00	кг	14	поштучно
56886	3395	ЛУКОВЫЕ Луковые кольца 1,5кг в панировке ТМ Ozgorkey Feast	\N	\N	5313.00	шт	1	154	t	2025-12-14 13:04:34.316	2025-12-14 13:04:34.316	885.00	шт	6	поштучно
56887	3395	Сырные палочки Моцарелла в панировке 1кг ТМ Фрост-А	\N	\N	9867.00	шт	1	200	t	2025-12-14 13:04:34.333	2025-12-14 13:04:34.333	987.00	шт	10	поштучно
56888	3395	ГОРОХ зеленый 400гр ТМ 4 Сезона	\N	\N	2806.00	шт	1	200	t	2025-12-14 13:04:34.347	2025-12-14 13:04:34.347	140.00	шт	20	поштучно
56889	3395	ГОРОХ зеленый 400гр ТМ Бондюэль	\N	\N	2153.00	шт	1	56	t	2025-12-14 13:04:34.358	2025-12-14 13:04:34.358	179.00	шт	12	поштучно
56890	3395	ГРИБЫ ГРИБНОЕ ассорти (лесные грибы, шампиньоны) 400гр ТМ 4 Сезона	\N	\N	8050.00	шт	1	200	t	2025-12-14 13:04:34.374	2025-12-14 13:04:34.374	402.00	шт	20	поштучно
56891	3395	ГРИБЫ шампиньоны резаные 400гр ТМ 4 Сезона	\N	\N	3220.00	шт	1	200	t	2025-12-14 13:04:34.401	2025-12-14 13:04:34.401	161.00	шт	20	поштучно
56892	3395	ГРИБЫ шампиньоны резаные 400гр ТМ ТМ Морозко Green	\N	\N	2208.00	шт	1	138	t	2025-12-14 13:04:34.412	2025-12-14 13:04:34.412	138.00	шт	16	поштучно
56893	3395	КАПУСТА брокколи 400гр ТМ 4 Сезона	\N	\N	5428.00	шт	1	200	t	2025-12-14 13:04:34.435	2025-12-14 13:04:34.435	271.00	шт	20	поштучно
56894	3395	КАПУСТА брокколи 400гр ТМ Морозко Green	\N	\N	3588.00	шт	1	92	t	2025-12-14 13:04:34.447	2025-12-14 13:04:34.447	224.00	шт	16	поштучно
54666	4594	ДИСКОНТ ГОЛЕНЬ ИНДЕЙКА БЕСКОСТНАЯ подложка (1шт~750гр)ТМ Индилайт	\N	\N	338.00	шт	1	100	f	2025-12-11 09:35:41.666	2025-12-11 09:36:17.136	338.00	шт	1	поштучно
54655	3305	ДИСКОНТ МАСЛО 500гр 82,5% Традиционное Курск	\N	\N	3450.00	шт	1	520	f	2025-12-07 13:19:51.518	2025-12-11 09:44:24.409	345.00	шт	10	поштучно
54654	3305	ДИСКОНТ МАСЛО 500гр 72,5% Крестьянское Курск	\N	\N	3277.00	шт	1	279	f	2025-12-07 13:19:51.508	2025-12-11 09:44:27.962	328.00	шт	10	поштучно
56895	3395	КАПУСТА брюссельская 400гр ТМ 4 Сезона	\N	\N	5428.00	шт	1	200	t	2025-12-14 13:04:34.464	2025-12-14 13:04:34.464	271.00	шт	20	поштучно
56896	3395	КАПУСТА цветная 30-60мм 400гр ТМ Бондюэль	\N	\N	2318.00	шт	1	100	t	2025-12-14 13:04:34.494	2025-12-14 13:04:34.494	193.00	шт	12	поштучно
54670	4594	ДИСКОНТ ГОЛЕНЬ ИНДЕЙКА подложка (1шт~900гр)ТМ Индилайт	Упаковка - 5шт(1346р)	\N	234.00	шт	1	100	f	2025-12-11 09:58:10.674	2025-12-11 09:59:07.279	234.00	шт	1	поштучно
54667	4594	ДИСКОНТ ГОЛЕНЬ ИНДЕЙКА БЕСКОСТНАЯ подложка (1шт~750гр)ТМ Индилайт	Упаковка - 8 шт( ~3100)	\N	337.00	шт	1	100	f	2025-12-11 09:42:37.34	2025-12-11 09:59:11.129	337.00	шт	1	поштучно
54671	4594	ДИСКОНТ ГОЛЕНЬ ИНДЕЙКА БЕСКОСТНАЯ подложка (1шт~750гр)ТМ Индилайт	\N	\N	337.00	шт	1	100	f	2025-12-11 10:01:56.47	2025-12-11 10:02:11.668	337.00	шт	1	поштучно
56897	3395	КАПУСТА цветная 400гр ТМ 4 Сезона	\N	\N	3703.00	шт	1	200	t	2025-12-14 13:04:34.511	2025-12-14 13:04:34.511	185.00	шт	20	поштучно
56898	3395	КАПУСТА цветная 400гр ТМ Морозко Green	\N	\N	2760.00	шт	1	62	t	2025-12-14 13:04:34.528	2025-12-14 13:04:34.528	173.00	шт	16	поштучно
56899	3395	КАПУСТА цветная мини 10-20мм 300гр ТМ Бондюэль	\N	\N	2167.00	шт	1	117	t	2025-12-14 13:04:34.578	2025-12-14 13:04:34.578	181.00	шт	12	поштучно
56900	3395	ЛЕЧО 400гр ТМ 4 Сезона	\N	\N	3243.00	шт	1	200	t	2025-12-14 13:04:34.588	2025-12-14 13:04:34.588	162.00	шт	20	поштучно
56901	3395	ОВОЩИ Весенние 400гр ТМ 4 Сезона	\N	\N	3013.00	шт	1	200	t	2025-12-14 13:04:34.611	2025-12-14 13:04:34.611	151.00	шт	20	поштучно
56902	3395	ОВОЩИ для жарки с шампиньонами 400гр ТМ 4 Сезона	\N	\N	3588.00	шт	1	200	t	2025-12-14 13:04:34.625	2025-12-14 13:04:34.625	179.00	шт	20	поштучно
54678	4594	ДИСКОНТ УТЕНОК Тушка в горчично-пряном маринаде пакет (1шт~1.6кг) 1/11,5кг ТМ Улыбино	\N	\N	250.00	шт	1	8	f	2025-12-12 01:42:50.803	2025-12-12 01:44:35.291	250.00	шт	1	поштучно
54677	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	5118.00	кг	1	20	f	2025-12-12 01:23:16.36	2025-12-12 01:44:39.086	793.00	кг	6	поштучно
56903	3395	ОВОЩИ Летние 400гр ТМ 4 Сезона	\N	\N	3312.00	шт	1	200	t	2025-12-14 13:04:34.641	2025-12-14 13:04:34.641	166.00	шт	20	поштучно
56904	3395	ОВОЩИ по-азиатски Вок  (Перец сл. капуста цв. фасоль стр. шамп рез) 400гр ТМ Бондюэль	\N	\N	3188.00	шт	1	200	t	2025-12-14 13:04:34.659	2025-12-14 13:04:34.659	266.00	шт	12	поштучно
54663	3367	КОКТЕЙЛЬ 500гр морской с гребешком Китай	\N	\N	5405.00	шт	1	13	f	2025-12-08 02:23:31.812	2025-12-14 08:12:22.106	270.00	шт	20	поштучно
54659	3367	КАЛЬМАР КОЛЬЦА 500гр с/м Китай	\N	\N	6969.00	шт	1	158	f	2025-12-08 02:23:31.706	2025-12-14 12:09:06.688	348.00	шт	20	поштучно
54679	4594	ДИСКОНТ УТЕНОК Тушка пряные травы маринад пакет (1шт~1.6кг) 1/4,8кг ТМ Улыбино	\N	\N	2015.00	уп (5 шт)	1	13	f	2025-12-12 01:42:50.816	2025-12-12 01:44:31.224	420.00	кг	5	только уп
54680	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	476.00	шт (~0,6кг)	1	20	f	2025-12-14 01:47:32.666	2025-12-14 01:49:02.092	476.00	шт	6	только уп
54681	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	476.00	шт	1	20	f	2025-12-14 01:52:59	2025-12-14 01:55:45.793	476.00	шт	6	поштучно
54682	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	476.00	шт (~0,6кг)	1	20	f	2025-12-14 01:55:56.401	2025-12-14 02:24:47.197	476.00	шт	6	только уп
54683	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	476.00	шт	1	20	f	2025-12-14 02:25:30.803	2025-12-14 02:26:26.616	476.00	шт	\N	поштучно
54684	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	ывагрывагрошваышо	\N	476.00	шт (~0,6кг)	1	20	f	2025-12-14 02:26:46.333	2025-12-14 02:28:01.864	476.00	шт (~0,6кг)	1	поштучно
54685	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	476.00	шт	1	20	f	2025-12-14 02:28:12.29	2025-12-14 02:28:28.873	476.00	шт	\N	поштучно
54686	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	476.00	шт	1	20	f	2025-12-14 02:31:39.031	2025-12-14 02:31:46.902	476.00	шт	\N	поштучно
54687	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	ывывваы	\N	476.00	шт	1	20	f	2025-12-14 02:32:00.047	2025-12-14 07:25:07.773	476.00	шт	\N	поштучно
54688	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	\N	\N	476.00	шт	1	20	f	2025-12-14 07:28:19.846	2025-12-14 07:28:56.817	476.00	шт	\N	поштучно
54475	3367	СЕЛЬДЬ вес малосоленая ОЛЮТОРКА (в/уп)	\N	\N	493.00	кг	1	228	f	2025-12-07 13:19:48.57	2025-12-14 08:12:22.419	493.00	кг	1	поштучно
54472	3367	СЕЛЬДЬ вес ароматная ОЛЮТОРКА (в/уп)	\N	\N	493.00	кг	1	93	f	2025-12-07 13:19:48.473	2025-12-14 08:12:22.81	493.00	кг	1	поштучно
54444	3367	САЛАТ 500гр из Морской Капусты с овощами в майонезно-горчичном соусе  пл/конт ТМ Рыбный День	\N	\N	1863.00	шт	1	9	f	2025-12-07 13:19:47.986	2025-12-14 08:12:24.809	311.00	шт	6	поштучно
54412	3367	ФОРЕЛЬ 200гр п/копч филе-кусок ТМ Русское море	\N	\N	6313.00	шт	1	17	f	2025-12-07 13:19:47.434	2025-12-14 08:12:26.992	1052.00	шт	6	поштучно
54393	3367	САЛАТ 500гр МК маринованная классическая 1/12шт ТМ Русское Море	\N	\N	2277.00	шт	1	13	f	2025-12-07 13:19:47.057	2025-12-14 08:12:28.566	190.00	шт	12	поштучно
54290	3367	КРЕВЕТКА Тигровая 1кг с/м 16/20 очищенная с хвостиком Бангладеш	\N	\N	15985.00	шт	1	9	f	2025-12-07 13:19:45.163	2025-12-14 08:12:28.932	1598.00	шт	10	поштучно
54224	3396	СОСИСКИ Вес 10кг Мусульманские ХАЛЯЛЬ замороженные Обнинский МПК	\N	\N	2530.00	уп (10 шт)	1	100	f	2025-12-07 13:19:44.056	2025-12-14 08:12:29.884	253.00	кг	10	только уп
54205	3310	СВИНИНА ШЕЯ (шейный отруб) без кости вес (1кусок~1кг) с/м Р/ву ТМ Полянское	\N	\N	9971.00	уп (15 шт)	1	15	f	2025-12-07 13:19:43.813	2025-12-14 08:12:30.593	665.00	кг	15	только уп
54187	3310	СВИНИНА ГУДИНКА с/м без кости на шкуре Р НПЗ Нейма ЖЕЛТЫЙ СКОТЧ	\N	\N	7549.00	уп (15 шт)	1	16	f	2025-12-07 13:19:43.495	2025-12-14 08:12:31.702	518.00	кг	15	только уп
54168	3310	ГОВЯДИНА СЕРДЦЕ вес с/м Р 1/20-25кг Уругвай ЖЕЛТЫЙ СКОТЧ	\N	\N	13949.00	уп (25 шт)	1	109	f	2025-12-07 13:19:43.144	2025-12-14 08:12:32.066	569.00	кг	25	только уп
54165	3310	ГОВЯДИНА ПЕЧЕНЬ вес с/м Р/ву 1/16-19кг Аргентина	\N	\N	7923.00	уп (16 шт)	1	5	f	2025-12-07 13:19:43.1	2025-12-14 08:12:32.386	488.00	кг	16	только уп
54155	3310	ГОВЯДИНА ЛОПАТКА без кости вес с/м Р/ву Алтай КРАСНЫЙ СКОТЧ	\N	\N	18817.00	уп (19 шт)	1	20	f	2025-12-07 13:19:42.944	2025-12-14 08:12:32.683	992.00	кг	19	только уп
54150	3310	ЦЫПЛЕНОК-КОРНИШОН жёлтый кукурузного откорма 500гр с/м Воронеж ЦЕНА ЗА ШТ	\N	\N	9775.00	шт	1	207	f	2025-12-07 13:19:42.894	2025-12-14 08:12:33.743	489.00	шт	20	поштучно
54121	3310	КРЫЛО КУР (плечевая часть) вес	\N	\N	6469.00	уп (15 шт)	1	33	f	2025-12-07 13:19:42.429	2025-12-14 08:12:34.388	431.00	кг	15	только уп
56905	3395	ОВОЩИ По-Деревенски 400гр ТМ 4 Сезона	\N	\N	3220.00	шт	1	200	t	2025-12-14 13:04:34.673	2025-12-14 13:04:34.673	161.00	шт	20	поштучно
56906	3395	ОВОЩИ по-индийски Сабджи (Брокколи. брюссельская. картофель. морковь) 400гр ТМ Бондюэль	\N	\N	3188.00	шт	1	200	t	2025-12-14 13:04:34.686	2025-12-14 13:04:34.686	266.00	шт	12	поштучно
56907	3395	ОВОЩИ по-итальянски Орзотто (Крупа перл. брокколи. томаты. перец сл) 400гр ТМ Бондюэль	\N	\N	3409.00	шт	1	166	t	2025-12-14 13:04:34.699	2025-12-14 13:04:34.699	284.00	шт	12	поштучно
56908	3395	ОВОЩИ по-китайски Мунг (Бобы мунг. перец сл. грибы шамп. шиитаке) 400гр ТМ Бондюэль	\N	\N	3409.00	шт	1	124	t	2025-12-14 13:04:34.72	2025-12-14 13:04:34.72	284.00	шт	12	поштучно
56909	3395	ОВОЩИ по-мароккански Тажин (Нут. кабачок. шампиньоны. томаты) 400гр ТМ Бондюэль	\N	\N	3409.00	шт	1	125	t	2025-12-14 13:04:34.736	2025-12-14 13:04:34.736	284.00	шт	12	поштучно
56910	3395	ОВОЩИ по-турецки Фасулье (Капуста цветная. брокколи. фасоль струч) 400гр ТМ Бондюэль	\N	\N	3215.00	шт	1	6	t	2025-12-14 13:04:34.747	2025-12-14 13:04:34.747	268.00	шт	12	поштучно
56911	3395	ПЕРЕЦ сладкий резаный 400гр ТМ 4 Сезона	\N	\N	2737.00	шт	1	200	t	2025-12-14 13:04:34.783	2025-12-14 13:04:34.783	137.00	шт	20	поштучно
56912	3395	РАГУ ОВОЩНОЕ 400гр ТМ 4 Сезона	\N	\N	2852.00	шт	1	200	t	2025-12-14 13:04:34.798	2025-12-14 13:04:34.798	143.00	шт	20	поштучно
56913	3395	СМЕСЬ Восточная 400гр ТМ 4 Сезона	\N	\N	3450.00	шт	1	153	t	2025-12-14 13:04:34.81	2025-12-14 13:04:34.81	173.00	шт	20	поштучно
56914	3395	СМЕСЬ Гавайская 400гр ТМ 4 Сезона	\N	\N	3427.00	шт	1	200	t	2025-12-14 13:04:34.824	2025-12-14 13:04:34.824	171.00	шт	20	поштучно
54112	3310	УТЕНОК Тушка 1 сорт потрошен в/у (1шт~2кг) ТМ Озерка	\N	\N	3155.00	кг	1	300	f	2025-12-07 13:19:42.192	2025-12-14 08:12:34.753	401.00	кг	8	поштучно
54075	3356	ПЕЛЬМЕНИ Цезарь 800гр Семейные	\N	\N	5644.00	шт	1	269	f	2025-12-07 13:19:41.601	2025-12-14 08:12:36.899	470.00	шт	12	поштучно
54059	3356	ПЕЛЬМЕНИ ГРАНДМЕНИ 700гр с говядиной и свининой ТМ Горячая Штучка	\N	\N	2806.00	шт	1	160	f	2025-12-07 13:19:41.417	2025-12-14 08:12:37.246	351.00	шт	8	поштучно
54023	3356	ВАРЕНИКИ Вари вареники 800гр картофель	\N	\N	2501.00	шт	1	196	f	2025-12-07 13:19:40.868	2025-12-14 08:12:38.136	250.00	шт	10	поштучно
54022	3356	ВАРЕНИКИ Вари вареники 450гр творог	\N	\N	1739.00	шт	1	28	f	2025-12-07 13:19:40.855	2025-12-14 08:12:38.498	217.00	шт	8	поштучно
54018	3356	ВАРЕНИКИ Бабушка Аня 430гр творог 1/10шт ТМ Санта Бремор	\N	\N	2070.00	шт	1	10	f	2025-12-07 13:19:40.807	2025-12-14 08:12:38.819	207.00	шт	10	поштучно
53995	3391	Суп Солянка по-домашнему 250гр ТМ Главсуп	\N	\N	2194.00	шт	1	14	f	2025-12-07 13:19:40.439	2025-12-14 08:12:39.856	183.00	шт	12	поштучно
53912	3391	БЛИНЫ Масленица с творогом вес трубочка	\N	\N	1856.00	уп (6 шт)	1	102	f	2025-12-07 13:19:38.969	2025-12-14 08:12:40.17	309.00	кг	6	только уп
53910	3391	БЛИНЫ Масленица с мясом вес трубочка	\N	\N	1891.00	уп (6 шт)	1	6	f	2025-12-07 13:19:38.942	2025-12-14 08:12:40.482	315.00	кг	6	только уп
53848	3391	ГОРЯЧАЯ ШТУЧКА Наггетсы кур Хрустящие вес куриные 6кг ТМ Зареченские	\N	\N	2525.00	уп (6 шт)	1	114	f	2025-12-07 13:19:37.954	2025-12-14 08:12:40.804	421.00	кг	6	только уп
53838	3305	СЫРОК Советские традиции Карамель глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	f	2025-12-07 13:19:37.807	2025-12-14 08:12:41.142	91.00	шт	10	только уп
53837	3305	СЫРОК Советские традиции Какао глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	f	2025-12-07 13:19:37.795	2025-12-14 08:12:41.481	91.00	шт	10	только уп
53836	3305	СЫРОК Советские традиции Вишня глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	f	2025-12-07 13:19:37.783	2025-12-14 08:12:41.796	91.00	шт	10	только уп
53835	3305	СЫРОК Советские традиции Вар Сгущенка глазированный 45гр	\N	\N	908.00	уп (10 шт)	1	200	f	2025-12-07 13:19:37.735	2025-12-14 08:12:42.114	91.00	шт	10	только уп
53739	3393	ГУБКИ для посуды эко макси Авикомп 5шт	\N	\N	56.00	шт	1	9	f	2025-12-07 13:19:35.577	2025-12-14 08:12:46.582	56.00	шт	1	поштучно
53680	3323	НАПИТОК МОНАСТЫРСКИЙ 1,5 Лимонад газированный пэт	\N	\N	869.00	уп (6 шт)	1	42	f	2025-12-07 13:19:34.258	2025-12-14 08:12:46.882	145.00	шт	6	только уп
53631	3323	ВОЛЖСКИЙ ПОСАД сок 0,2л яблочный осветленный пэт	\N	\N	994.00	уп (27 шт)	1	17	f	2025-12-07 13:19:33.395	2025-12-14 08:12:47.202	37.00	шт	27	только уп
53602	3367	СЕЛЬДЬ 175гр Атлантическая в масле филе 1/9шт ТМ Санта Бремор	\N	\N	2039.00	шт	1	9	f	2025-12-07 13:19:32.858	2025-12-14 08:12:47.525	227.00	шт	9	поштучно
53534	3327	ОГУРЦЫ марин Корнишоны 720мл ТМ Сонна Мера	\N	\N	3905.00	уп (12 шт)	1	99	f	2025-12-07 13:19:31.486	2025-12-14 08:12:48.224	325.00	шт	12	только уп
53499	3327	КОРНИШОНЫ 370мл хрустящие ст/б ТМ Скатерть-Самобранка	\N	\N	2346.00	уп (12 шт)	1	111	f	2025-12-07 13:19:30.839	2025-12-14 08:12:49.112	195.00	шт	12	только уп
53477	3327	ОГУРЧИКИ маринованные отборные в томатном соусе 700гр ст/б ТМ Пиканта	\N	\N	1511.00	уп (6 шт)	1	9	f	2025-12-07 13:19:30.245	2025-12-14 08:12:49.404	252.00	шт	6	только уп
53251	3323	ЧАЙ Curtic Sunny Lemon пирамидки 20пак	\N	\N	1339.00	шт	1	8	f	2025-12-07 13:19:26.61	2025-12-14 08:12:49.711	112.00	шт	12	поштучно
53250	3323	ЧАЙ Curtic Summer Berries пирамидки 20пак	\N	\N	1339.00	шт	1	13	f	2025-12-07 13:19:26.599	2025-12-14 08:12:50.012	112.00	шт	12	поштучно
53025	3317	Крупа Ячневая вес 45кг Ларица	\N	\N	2065.00	уп (45 шт)	1	45	f	2025-12-07 13:19:22.531	2025-12-14 08:12:50.359	46.00	кг	45	только уп
53020	3317	Крупа Геркулес вес 30кг Горлов	\N	\N	2018.00	уп (30 шт)	1	60	f	2025-12-07 13:19:22.415	2025-12-14 08:12:50.72	67.00	кг	30	только уп
53017	3400	КЕТЧУП Стебель Бамбука дой-пак 300гр Томатный	\N	\N	2015.00	шт	1	6	f	2025-12-07 13:19:22.331	2025-12-14 08:12:51.054	84.00	шт	24	поштучно
52981	3400	СОУС Пиканта дой-пак 280гр Терияки	\N	\N	1564.00	шт	1	48	f	2025-12-07 13:19:21.666	2025-12-14 08:12:51.376	98.00	шт	16	поштучно
52977	3400	СОУС заправка Я Люблю готовить дой-пак "Французские пряности и чеснок" 250мл	\N	\N	1380.00	шт	1	12	f	2025-12-07 13:19:21.586	2025-12-14 08:12:52.069	230.00	шт	6	поштучно
52953	3400	МАЙОНЕЗ Мечта хозяйки "Провансаль" 67% дой-пак 350мл	\N	\N	3174.00	шт	1	30	f	2025-12-07 13:19:21.198	2025-12-14 08:12:52.423	159.00	шт	20	поштучно
52944	3400	МАЙОНЕЗ Мастер Gurme Оливковый 50,5% дой-пак 350мл	\N	\N	3036.00	шт	1	17	f	2025-12-07 13:19:21.059	2025-12-14 08:12:53.266	126.00	шт	24	поштучно
52941	3314	Сыр Президент плав 200 шоколад 1/16шт  ванна	\N	\N	3864.00	шт	1	21	f	2025-12-07 13:19:21.017	2025-12-14 08:12:53.583	241.00	шт	16	поштучно
52912	3314	СЫР мягкий а ла Каймак 250гр 70% стаканчик Mlekara Сербия	\N	\N	2732.00	шт	1	48	f	2025-12-07 13:19:20.626	2025-12-14 08:12:54.662	228.00	шт	12	поштучно
52899	3314	СЫР брынза Сербская 450гр 40% с сывороткой 515гр Млекара Сербия	\N	\N	2898.00	шт	1	7	f	2025-12-07 13:19:20.29	2025-12-14 08:12:55.532	483.00	шт	6	поштучно
52873	3314	СЫР фас Bonfesto Моцарелла Пицца 250гр 40% 1/6шт Туровский МК	\N	\N	1566.00	шт	1	24	f	2025-12-07 13:19:19.926	2025-12-14 08:12:55.902	261.00	шт	6	поштучно
52872	3314	СЫР Спагетти Саргуль рассольный копченый 100гр СибБарс	\N	\N	8798.00	шт	1	18	f	2025-12-07 13:19:19.914	2025-12-14 08:12:56.241	176.00	шт	50	поштучно
52870	3314	СЫР Спагетти Саргуль рассольный 100гр вкус Маринованые огурцы	\N	\N	8798.00	шт	1	39	f	2025-12-07 13:19:19.887	2025-12-14 08:12:56.699	176.00	шт	50	поштучно
52841	3310	РЕБРЫШКИ свиные фас в/к с/м в/уп (1шт ~ 0,3кг) 1/10-13кг ТМ БАРС	\N	\N	8395.00	уп (10 шт)	1	8	f	2025-12-07 13:19:19.453	2025-12-14 08:12:59.406	839.00	кг	10	только уп
52812	3303	КОНФЕТЫ 250гр Мишки в лесу с начинкой и вафельной крошкой ТМ Победа	\N	\N	8280.00	шт	1	11	f	2025-12-07 13:19:19.007	2025-12-14 08:12:59.869	414.00	шт	20	поштучно
52780	3303	КОЗИНАК ТимМикс Энергия фруктов 40гр батончик ТМ Тимоша	\N	\N	3767.00	уп (84 шт)	1	315	f	2025-12-07 13:19:18.539	2025-12-14 08:13:00.589	45.00	шт	84	только уп
52774	3303	КОЗИНАК кунжутный 40гр батончик ТМ Тимоша	\N	\N	2995.00	уп (84 шт)	1	252	f	2025-12-07 13:19:18.41	2025-12-14 08:13:03.6	36.00	шт	84	только уп
52772	3303	КОЗИНАК воздушный рис 50гр  ТМ Тимоша	\N	\N	897.00	уп (20 шт)	1	170	f	2025-12-07 13:19:18.329	2025-12-14 08:13:03.948	45.00	шт	20	только уп
52771	3303	КОЗИНАК арахисовый 40гр батончик ТМ Тимоша	\N	\N	2995.00	уп (84 шт)	1	336	f	2025-12-07 13:19:18.266	2025-12-14 08:13:04.267	36.00	шт	84	только уп
52732	3303	КОНФЕТЫ Мон Шер Ами со вкусом трюфеля 2кг ТМ Сладонеж	\N	\N	2024.00	уп (2 шт)	1	12	f	2025-12-07 13:19:17.757	2025-12-14 08:13:04.681	1012.00	кг	2	только уп
52720	3303	ВАФЛИ Сладонеж Сиропные Вареная сгущенка 120гр	\N	\N	1677.00	уп (18 шт)	1	6	f	2025-12-07 13:19:17.479	2025-12-14 08:13:05.094	93.00	шт	18	только уп
52675	3396	КОЛБАСА СПК с/к Юбилейная 235гр	\N	\N	30015.00	шт	1	8	f	2025-12-07 13:19:16.782	2025-12-14 08:13:05.439	334.00	шт	90	поштучно
52674	3396	КОЛБАСА СПК с/к Фестивальная пора срез 180гр	\N	\N	23495.00	шт	1	7	f	2025-12-07 13:19:16.769	2025-12-14 08:13:05.805	261.00	шт	90	поштучно
52671	3396	КОЛБАСА СПК с/к Праздничная 235гр	\N	\N	44091.00	шт	1	12	f	2025-12-07 13:19:16.737	2025-12-14 08:13:06.169	490.00	шт	90	поштучно
52665	3396	КОЛБАСА СПК с/к Колбаски ПодПивасики с сыром  в/уп 100гр цена за шт	\N	\N	22770.00	шт	1	38	f	2025-12-07 13:19:16.644	2025-12-14 08:13:07.265	228.00	шт	100	поштучно
52660	3396	КОЛБАСА СПК Нарезка с/к Коньячная Высокий вкус 100гр в/уп	\N	\N	23495.00	шт	1	22	f	2025-12-07 13:19:16.563	2025-12-14 08:13:08.2	261.00	шт	90	поштучно
52657	3396	КОЛБАСА СПК  с/к Салями Русская Просто выгодно в/уп  260гр	\N	\N	27945.00	шт	1	13	f	2025-12-07 13:19:16.469	2025-12-14 08:13:09.356	311.00	шт	90	поштучно
52639	3396	КОЛБАСА Черкизово с/к Сальчичон с розовым перцем срез 300гр	\N	\N	4140.00	шт	1	16	f	2025-12-07 13:19:16.048	2025-12-14 08:13:10.302	690.00	шт	6	поштучно
52628	3396	КОЛБАСА Останкино с/к Свиная ГОСТ 220гр	\N	\N	3036.00	шт	1	16	f	2025-12-07 13:19:15.852	2025-12-14 08:13:11.685	379.00	шт	8	поштучно
52623	3396	КОЛБАСА СПК Сервелат Европейский в/к 380гр цена за шт	\N	\N	11615.00	шт	1	11	f	2025-12-07 13:19:15.736	2025-12-14 08:13:12.028	232.00	шт	50	поштучно
52602	3396	НАРЕЗКА БЕКОН 360гр 1/5шт с/к в/у ТМ Черкизово	\N	\N	3421.00	шт	1	9	f	2025-12-07 13:19:15.212	2025-12-14 08:13:12.368	684.00	шт	5	поштучно
52600	3396	СОСИСКИ СПК С чесночком 360гр в/уп	\N	\N	14777.00	шт	1	14	f	2025-12-07 13:19:15.159	2025-12-14 08:13:12.72	296.00	шт	50	поштучно
52590	3396	КОЛБАСА вар СПК 400гр Классическая п/а	\N	\N	9718.00	шт	1	30	f	2025-12-07 13:19:14.898	2025-12-14 08:13:15.283	194.00	шт	50	поштучно
52589	3396	КОЛБАСА вар СПК 400гр Докторская в обвязке	\N	\N	16848.00	шт	1	39	f	2025-12-07 13:19:14.876	2025-12-14 08:13:15.649	337.00	шт	50	поштучно
52574	3396	ВЕТЧИНА вар Папа может 400гр Мясная	\N	\N	2374.00	шт	1	17	f	2025-12-07 13:19:14.699	2025-12-14 08:13:16.655	297.00	шт	8	поштучно
52542	3392	ПЛ/КОНТ Фейерверк пломбир клубничный бабл-гам карамель 1000г 1/1шт ТМ Чистая Линия	\N	\N	1288.00	шт	1	28	f	2025-12-07 13:19:14.18	2025-12-14 08:13:17.701	1288.00	шт	1	поштучно
52435	3392	РОЖОК Soletto Апельсин Юдзу молочное 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	72	f	2025-12-07 13:19:12.317	2025-12-14 08:13:18.069	90.00	шт	24	только уп
52434	3392	РОЖОК Soletto Classico Сладкая Малина сливочное фруктовое 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	24	f	2025-12-07 13:19:12.306	2025-12-14 08:13:18.635	90.00	шт	24	только уп
52433	3392	РОЖОК Soletto Classico Гранат Лимон 75гр 1/24шт ТМ Санта Бремор	\N	\N	2153.00	уп (24 шт)	1	72	f	2025-12-07 13:19:12.282	2025-12-14 08:13:18.952	90.00	шт	24	только уп
52336	3303	ДОНАТ в глазури Ваниль 58гр в индивидуальной упаковке ТМ Bakerton, Mirel ТОЛЬКО МЕСТАМИ	\N	\N	2153.00	уп (32 шт)	1	27	f	2025-12-07 13:19:10.766	2025-12-14 08:13:20.245	67.00	шт	32	только уп
53762	3305	СЛИВКИ питьевые Молочный мир 33% 500мл стерилизованные	\N	\N	4071.00	уп (12 шт)	1	138	f	2025-12-07 13:19:36.118	2025-12-14 08:21:44.696	339.00	шт	12	только уп
52447	3392	ВАФ СТАКАНЧИК Пломбир фисташковый 15% 70гр ТМ Село Зелёное	\N	\N	2870.00	уп (24 шт)	1	200	f	2025-12-07 13:19:12.646	2025-12-14 12:09:06.688	120.00	шт	24	только уп
52517	3392	ЭСКИМО Пломбир ванильный в шок. глазури с миндалем 12% 80гр ТМ Чистая Линия	\N	\N	3309.00	уп (21 шт)	1	200	f	2025-12-07 13:19:13.821	2025-12-14 12:09:06.688	158.00	шт	21	только уп
53086	3401	МАСЛО "Алтай" 5л подсолнечное рафинированное Высший сорт *	\N	\N	2536.00	уп (3 шт)	1	124	f	2025-12-07 13:19:23.58	2025-12-14 12:09:06.688	845.00	шт	3	только уп
53091	3401	МАСЛО "Слобода" 1л подсолнечное рафинированное для жарки и фритюра	\N	\N	3157.00	уп (15 шт)	1	120	f	2025-12-07 13:19:23.704	2025-12-14 12:09:06.688	210.00	шт	15	только уп
53113	3305	СЛИВКИ сухие Фрима 500г	\N	\N	10074.00	шт	1	500	f	2025-12-07 13:19:24.008	2025-12-14 12:09:06.688	420.00	шт	24	поштучно
53221	3323	КОФЕ Максим м/у 190гр 1/9шт	\N	\N	7587.00	шт	1	383	f	2025-12-07 13:19:26.038	2025-12-14 12:09:06.688	843.00	шт	9	поштучно
53441	3327	ГРИБЫ ШАМПИНЬОНЫ резаные 850мл ж/б  ТМ Сыта-Загора	\N	\N	1946.00	уп (12 шт)	1	206	f	2025-12-07 13:19:29.538	2025-12-14 12:09:06.688	162.00	шт	12	только уп
53778	3401	МАСЛО 360гр 82,5% Брест-Литовск сливочное ТМ Савушкин продукт	\N	\N	7820.00	шт	1	300	f	2025-12-07 13:19:36.646	2025-12-14 12:09:06.688	782.00	шт	10	поштучно
54133	3310	ГОЛЕНЬ КУР подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	3806.00	шт	1	300	f	2025-12-07 13:19:42.708	2025-12-14 12:09:06.688	381.00	шт	10	поштучно
54144	3310	ФИЛЕ ГРУДКИ КУР без кожи без кости подложка (1шт-1кг) МЕЖЕНИНОВСКАЯ ПФ	\N	\N	5716.00	шт	1	300	f	2025-12-07 13:19:42.825	2025-12-14 12:09:06.688	572.00	шт	10	поштучно
54235	3310	ЯЙЦО пищевое С1  ПФ Бердская ТОЛЬКО МЕСТАМИ *	\N	\N	4347.00	уп (360 шт)	1	500	f	2025-12-07 13:19:44.207	2025-12-14 12:09:06.688	12.00	шт	360	только уп
54239	3367	ГОРБУША мороженая потрошенная без головы Вылов 2025*	\N	\N	8804.00	уп (22 шт)	1	298	f	2025-12-07 13:19:44.25	2025-12-14 12:09:06.688	400.00	кг	22	только уп
54245	3367	КЕТА потрошенная без головы с/м 1/22кг Вылов 2025 - *	\N	\N	13662.00	уп (22 шт)	1	352	f	2025-12-07 13:19:44.522	2025-12-14 12:09:06.688	621.00	кг	22	только уп
54258	3367	СЕЛЬДЬ ОЛЮТОРСКАЯ мороженая КРУПНАЯ 2L 400-500гр 1/20кг Океанрыбфлот	\N	\N	5750.00	уп (20 шт)	1	1000	f	2025-12-07 13:19:44.682	2025-12-14 12:09:06.688	288.00	кг	20	только уп
54299	3367	Крабовое мясо 200гр ТМ VICI	\N	\N	5319.00	шт	1	1000	f	2025-12-07 13:19:45.43	2025-12-14 12:09:06.688	213.00	шт	25	поштучно
54535	3395	ГРИБЫ ГРИБНОЕ ассорти (лесные грибы, шампиньоны) 400гр ТМ 4 Сезона	\N	\N	8050.00	шт	1	200	f	2025-12-07 13:19:49.409	2025-12-14 12:09:06.688	402.00	шт	20	поштучно
54540	3395	КАПУСТА брюссельская 400гр ТМ 4 Сезона	\N	\N	5428.00	шт	1	200	f	2025-12-07 13:19:49.474	2025-12-14 12:09:06.688	271.00	шт	20	поштучно
54549	3395	ОВОЩИ по-азиатски Вок  (Перец сл. капуста цв. фасоль стр. шамп рез) 400гр ТМ Бондюэль	\N	\N	3188.00	шт	1	200	f	2025-12-07 13:19:49.577	2025-12-14 12:09:06.688	266.00	шт	12	поштучно
54556	3395	ПЕРЕЦ сладкий резаный 400гр ТМ 4 Сезона	\N	\N	2737.00	шт	1	200	f	2025-12-07 13:19:49.733	2025-12-14 12:09:06.688	137.00	шт	20	поштучно
54661	3367	КАЛЬМАР ФИЛЕ 1кг очищенный без кожи без плавника коробка с/м БМРТ Бутовск	\N	\N	19079.00	шт	1	1000	f	2025-12-08 02:23:31.736	2025-12-14 12:09:06.688	908.00	шт	21	поштучно
56915	3395	СМЕСЬ Гавайский микс (Рис, горошек, кукуруза. перец сладкий) 400гр ТМ Бондюэль	\N	\N	2291.00	шт	1	200	t	2025-12-14 13:04:34.838	2025-12-14 13:04:34.838	191.00	шт	12	поштучно
56916	3395	СМЕСЬ Калифорния 400гр ТМ 4 Сезона	\N	\N	3519.00	шт	1	200	t	2025-12-14 13:04:34.87	2025-12-14 13:04:34.87	176.00	шт	20	поштучно
56917	3395	СМЕСЬ Китайская 400гр ТМ 4 Сезона	\N	\N	4002.00	шт	1	200	t	2025-12-14 13:04:34.897	2025-12-14 13:04:34.897	200.00	шт	20	поштучно
56918	3395	СМЕСЬ Мексиканская 400гр ТМ 4 Сезона	\N	\N	3427.00	шт	1	200	t	2025-12-14 13:04:34.909	2025-12-14 13:04:34.909	171.00	шт	20	поштучно
56919	3395	СМЕСЬ Мексиканский микс (Рис. кукуруза. горошек. фасоль струч.) 400гр ТМ Бондюэль	\N	\N	2167.00	шт	1	200	t	2025-12-14 13:04:34.924	2025-12-14 13:04:34.924	181.00	шт	12	поштучно
56920	3395	СМЕСЬ Овощная рис из цветной капусты с грибами и травами 400гр ТМ Бондюэль	\N	\N	3119.00	шт	1	200	t	2025-12-14 13:04:34.955	2025-12-14 13:04:34.955	260.00	шт	12	поштучно
56921	3395	СМЕСЬ Овощная рис из цветной капусты с летними овощами и травами 400гр ТМ Бондюэль	\N	\N	3119.00	шт	1	200	t	2025-12-14 13:04:34.974	2025-12-14 13:04:34.974	260.00	шт	12	поштучно
56922	3395	СМЕСЬ Овощной микс с кабачком завтрак 200гр ТМ Бондюэль	\N	\N	3091.00	шт	1	200	t	2025-12-14 13:04:34.985	2025-12-14 13:04:34.985	129.00	шт	24	поштучно
56923	3395	СМЕСЬ Овощной микс с томатами завтрак 200гр ТМ Бондюэль	\N	\N	3091.00	шт	1	200	t	2025-12-14 13:04:34.999	2025-12-14 13:04:34.999	129.00	шт	24	поштучно
56924	3395	СМЕСЬ Сибирская 400гр ТМ 4 Сезона	\N	\N	4209.00	шт	1	200	t	2025-12-14 13:04:35.015	2025-12-14 13:04:35.015	210.00	шт	20	поштучно
56925	3395	СМЕСЬ Скандинавская 400гр ТМ 4 Сезона	\N	\N	3795.00	шт	1	200	t	2025-12-14 13:04:35.026	2025-12-14 13:04:35.026	190.00	шт	20	поштучно
56926	3395	СУП БОРЩ Московский (свёкла, белокочанная капуста, перец, томаты, картофель, морковь, лук) 400гр ТМ 4 Сезона	\N	\N	2760.00	шт	1	200	t	2025-12-14 13:04:35.041	2025-12-14 13:04:35.041	138.00	шт	20	поштучно
56927	3395	СУП ГРИБНОЙ (картофель, шампиньоны, морковь, лук) 400гр ТМ 4 Сезона	\N	\N	2944.00	шт	1	182	t	2025-12-14 13:04:35.054	2025-12-14 13:04:35.054	147.00	шт	20	поштучно
56928	3395	СУП ЩАВЕЛЬНЫЙ (щавель, картофель, морковь, лук) 400гр ТМ 4 Сезона	\N	\N	4094.00	шт	1	200	t	2025-12-14 13:04:35.066	2025-12-14 13:04:35.066	205.00	шт	20	поштучно
56929	3395	СУП-КРЕМ с цветной капустой 350гр ТМ Бондюэль	\N	\N	2829.00	шт	1	160	t	2025-12-14 13:04:35.079	2025-12-14 13:04:35.079	236.00	шт	12	поштучно
56930	3395	СУП-КРЕМ с шампиньонами 350гр ТМ Бондюэль	\N	\N	2829.00	шт	1	200	t	2025-12-14 13:04:35.098	2025-12-14 13:04:35.098	236.00	шт	12	поштучно
56931	3395	ТЫКВА нарезанная 400гр ТМ 4 Сезона	\N	\N	2323.00	шт	1	200	t	2025-12-14 13:04:35.108	2025-12-14 13:04:35.108	116.00	шт	20	поштучно
56932	3395	ФАСОЛЬ стручковая зеленая 400гр ТМ 4 Сезона	\N	\N	2806.00	шт	1	200	t	2025-12-14 13:04:35.122	2025-12-14 13:04:35.122	140.00	шт	20	поштучно
56933	3395	ФАСОЛЬ стручковаяи 400гр ТМ Морозко Green	\N	\N	2208.00	шт	1	161	t	2025-12-14 13:04:35.137	2025-12-14 13:04:35.137	138.00	шт	16	поштучно
56934	3395	ФАСОЛЬ тонкая зеленая целая 400гр ТМ Бондюэль	\N	\N	1656.00	шт	1	200	t	2025-12-14 13:04:35.149	2025-12-14 13:04:35.149	138.00	шт	12	поштучно
56935	3395	ФАСОЛЬ экстра-тонкая зеленая целая 400гр ТМ Бондюэль	\N	\N	1656.00	шт	1	159	t	2025-12-14 13:04:35.183	2025-12-14 13:04:35.183	138.00	шт	12	поштучно
56936	3395	ШПИНАТ резан 400гр ТМ 4 Сезона	\N	\N	5175.00	шт	1	200	t	2025-12-14 13:04:35.194	2025-12-14 13:04:35.194	259.00	шт	20	поштучно
56937	3395	ГОРОШЕК зелёный вес Россия	\N	\N	4054.00	уп (15 шт)	1	35	t	2025-12-14 13:04:35.211	2025-12-14 13:04:35.211	270.00	кг	15	только уп
56938	3395	ГРИБЫ АССОРТИ Сказки Лукоморья резанные вес Россия	\N	\N	5049.00	уп (10 шт)	1	20	t	2025-12-14 13:04:35.223	2025-12-14 13:04:35.223	505.00	кг	10	только уп
56939	3395	ГРИБЫ ОПЯТА вес Китай	\N	\N	4025.00	уп (10 шт)	1	500	t	2025-12-14 13:04:35.237	2025-12-14 13:04:35.237	402.00	кг	10	только уп
57002	3395	МАЛИНА 300гр ТМ Морозко Green	\N	\N	7130.00	шт	1	143	t	2025-12-14 13:04:36.413	2025-12-14 13:04:36.413	357.00	шт	20	поштучно
56961	3395	ОВОЩИ ЛЕТНИЕ вес  (горошек,морковь,фасоль, цветная капуста) Россия	\N	\N	2369.00	уп (10 шт)	1	200	t	2025-12-14 13:04:35.619	2025-12-14 13:04:35.619	237.00	кг	10	только уп
56962	3395	ПЕРЕЦ ПОЛОСКИ микс (красный,зелёный,жёлтый) вес Россия	\N	\N	2277.00	уп (9 шт)	1	500	t	2025-12-14 13:04:35.634	2025-12-14 13:04:35.634	253.00	кг	9	только уп
56963	3395	ПЕРЕЦ ЦЕЛЫЙ микс (красный,зелёный,жёлтый)  вес Россия	\N	\N	1811.00	уп (7 шт)	1	138	t	2025-12-14 13:04:35.66	2025-12-14 13:04:35.66	259.00	кг	7	только уп
56964	3395	СМЕСЬ ГАВАЙСКАЯ (рис,горошек,кукуруза,перец зеленый и красный) вес Россия	\N	\N	2128.00	уп (10 шт)	1	160	t	2025-12-14 13:04:35.676	2025-12-14 13:04:35.676	213.00	кг	10	только уп
56965	3395	СМЕСЬ ЛЕЧО ( перец,помидор,лку,морковь,кабачок) вес Россия	\N	\N	2012.00	уп (10 шт)	1	200	t	2025-12-14 13:04:35.76	2025-12-14 13:04:35.76	201.00	кг	10	только уп
56966	3395	СМЕСЬ МЕКСИКАНСКАЯ (перец, морковь, фасоль, горошек, кукуруза, сельдерей, лук) вес Россия	\N	\N	2128.00	уп (10 шт)	1	500	t	2025-12-14 13:04:35.79	2025-12-14 13:04:35.79	213.00	кг	10	только уп
56967	3395	СМЕСЬ РАТАТУЙ ( баклажан,перец,кабачок) вес Россия	\N	\N	2220.00	уп (10 шт)	1	350	t	2025-12-14 13:04:35.806	2025-12-14 13:04:35.806	222.00	кг	10	только уп
56968	3395	СМЕСЬ ЦАРСКАЯ ( морковь,цветная капуста,брокколи) вес Россия	\N	\N	2737.00	уп (10 шт)	1	450	t	2025-12-14 13:04:35.861	2025-12-14 13:04:35.861	274.00	кг	10	только уп
56969	3395	ТЫКВА кубик вес Россия	\N	\N	2415.00	уп (10 шт)	1	490	t	2025-12-14 13:04:35.876	2025-12-14 13:04:35.876	241.00	кг	10	только уп
56970	3395	ФАСОЛЬ красная бланшированная вес Россия	\N	\N	5921.00	уп (19 шт)	1	57	t	2025-12-14 13:04:35.89	2025-12-14 13:04:35.89	312.00	кг	19	только уп
56971	3395	ФАСОЛЬ стручковая рез вес Египет	\N	\N	2116.00	уп (10 шт)	1	500	t	2025-12-14 13:04:35.903	2025-12-14 13:04:35.903	212.00	кг	10	только уп
56973	3395	БРУСНИКА вес КНР	\N	\N	6037.00	уп (10 шт)	1	330	t	2025-12-14 13:04:35.941	2025-12-14 13:04:35.941	604.00	кг	10	только уп
56974	3395	ВИШНЯ без косточки вес Киргизия	\N	\N	8257.00	уп (10 шт)	1	400	t	2025-12-14 13:04:35.954	2025-12-14 13:04:35.954	826.00	кг	10	только уп
56975	3395	ВИШНЯ без косточки вес Россия	\N	\N	8257.00	уп (10 шт)	1	60	t	2025-12-14 13:04:35.965	2025-12-14 13:04:35.965	826.00	кг	10	только уп
56976	3395	ГОЛУБИКА вес  Россия	\N	\N	8844.00	уп (10 шт)	1	300	t	2025-12-14 13:04:35.985	2025-12-14 13:04:35.985	884.00	кг	10	только уп
56977	3395	ГОЛУБИКА вес Китай	\N	\N	5980.00	уп (10 шт)	1	30	t	2025-12-14 13:04:36.018	2025-12-14 13:04:36.018	598.00	кг	10	только уп
56978	3395	ЕЖЕВИКА вес Россия	\N	\N	4543.00	уп (10 шт)	1	340	t	2025-12-14 13:04:36.031	2025-12-14 13:04:36.031	454.00	кг	10	только уп
56979	3395	ЕЖЕВИКА вес Сербия	\N	\N	5566.00	уп (10 шт)	1	50	t	2025-12-14 13:04:36.045	2025-12-14 13:04:36.045	557.00	кг	10	только уп
56980	3395	ЖИМОЛОСТЬ вес Китай	\N	\N	8349.00	уп (10 шт)	1	500	t	2025-12-14 13:04:36.083	2025-12-14 13:04:36.083	835.00	кг	10	только уп
56981	3395	КЛУБНИКА вес  Египет	\N	\N	3220.00	уп (10 шт)	1	350	t	2025-12-14 13:04:36.098	2025-12-14 13:04:36.098	322.00	кг	10	только уп
56982	3395	КЛЮКВА САДОВАЯ вес Россия	\N	\N	5394.00	уп (10 шт)	1	250	t	2025-12-14 13:04:36.113	2025-12-14 13:04:36.113	539.00	кг	10	только уп
56983	3395	КРЫЖОВНИК  вес Китай	\N	\N	3277.00	уп (10 шт)	1	30	t	2025-12-14 13:04:36.126	2025-12-14 13:04:36.126	328.00	кг	10	только уп
56984	3395	МАЛИНА Экстра вес 1/10кг Россия	\N	\N	8038.00	уп (10 шт)	1	500	t	2025-12-14 13:04:36.137	2025-12-14 13:04:36.137	804.00	кг	10	только уп
56985	3395	МАЛИНА ЭКСТРА вес 4*2,5кг Китай	\N	\N	7935.00	уп (10 шт)	1	463	t	2025-12-14 13:04:36.148	2025-12-14 13:04:36.148	793.00	кг	10	только уп
56986	3395	МАНГО вес  Китай	\N	\N	4025.00	уп (10 шт)	1	20	t	2025-12-14 13:04:36.159	2025-12-14 13:04:36.159	402.00	кг	10	только уп
56987	3395	ОБЛЕПИХА вес Китай	\N	\N	3392.00	уп (10 шт)	1	150	t	2025-12-14 13:04:36.18	2025-12-14 13:04:36.18	339.00	кг	10	только уп
56988	3395	ПЕРСИК половинки вес Китай	\N	\N	4876.00	уп (10 шт)	1	150	t	2025-12-14 13:04:36.199	2025-12-14 13:04:36.199	488.00	кг	10	только уп
56989	3395	СЛИВА половинки  вес Россия	\N	\N	3220.00	уп (10 шт)	1	360	t	2025-12-14 13:04:36.211	2025-12-14 13:04:36.211	322.00	кг	10	только уп
56990	3395	СМЕСЬ КОМПОТНАЯ ((абрикос,яблоко,слива) вес	\N	\N	2530.00	уп (10 шт)	1	500	t	2025-12-14 13:04:36.222	2025-12-14 13:04:36.222	253.00	кг	10	только уп
56991	3395	СМЕСЬ КОМПОТНАЯ Фруктово-Ягодная вес	\N	\N	2530.00	уп (10 шт)	1	500	t	2025-12-14 13:04:36.239	2025-12-14 13:04:36.239	253.00	кг	10	только уп
56992	3395	ЧЕРЕШНЯ без косточки вес Молдова	\N	\N	7739.00	уп (10 шт)	1	180	t	2025-12-14 13:04:36.267	2025-12-14 13:04:36.267	774.00	кг	10	только уп
56993	3395	ЧЕРНАЯ СМОРОДИНА  вес Россия	\N	\N	7820.00	уп (10 шт)	1	90	t	2025-12-14 13:04:36.278	2025-12-14 13:04:36.278	782.00	кг	10	только уп
56994	3395	ЧЕРНАЯ СМОРОДИНА вес Китай	\N	\N	7302.00	уп (10 шт)	1	500	t	2025-12-14 13:04:36.289	2025-12-14 13:04:36.289	730.00	кг	10	только уп
56995	3395	БРУСНИКА 300гр ТМ 4 Сезона	\N	\N	7705.00	шт	1	200	t	2025-12-14 13:04:36.308	2025-12-14 13:04:36.308	385.00	шт	20	поштучно
56996	3395	ВИШНЯ без косточки 300гр ТМ 4 Сезона	\N	\N	14297.00	шт	1	200	t	2025-12-14 13:04:36.323	2025-12-14 13:04:36.323	596.00	шт	24	поштучно
56997	3395	ВИШНЯ без косточки 300гр ТМ Морозко Green	\N	\N	7015.00	шт	1	49	t	2025-12-14 13:04:36.338	2025-12-14 13:04:36.338	351.00	шт	20	поштучно
56998	3395	КЛУБНИКА 300гр ТМ 4 Сезона	\N	\N	4453.00	шт	1	200	t	2025-12-14 13:04:36.348	2025-12-14 13:04:36.348	202.00	шт	22	поштучно
56999	3395	КЛУБНИКА 300гр ТМ Морозко Green	\N	\N	3841.00	шт	1	47	t	2025-12-14 13:04:36.374	2025-12-14 13:04:36.374	192.00	шт	20	поштучно
57000	3395	КЛЮКВА садовая 300гр ТМ 4 Сезона	\N	\N	10373.00	шт	1	64	t	2025-12-14 13:04:36.388	2025-12-14 13:04:36.388	471.00	шт	22	поштучно
57001	3395	МАЛИНА 300гр ТМ 4 Сезона	\N	\N	7291.00	шт	1	200	t	2025-12-14 13:04:36.401	2025-12-14 13:04:36.401	365.00	шт	20	поштучно
57005	3395	СМЕСЬ Фруктовая Компотная 300гр ТМ 4 Сезона	\N	\N	6044.00	шт	1	200	t	2025-12-14 13:04:36.46	2025-12-14 13:04:36.46	252.00	шт	24	поштучно
57006	3395	СМОРОДИНА черная 300гр ТМ 4 Сезона	\N	\N	10856.00	шт	1	19	t	2025-12-14 13:04:36.473	2025-12-14 13:04:36.473	543.00	шт	20	поштучно
57007	3395	СМОРОДИНА черная 300гр ТМ Морозко Green	\N	\N	6555.00	шт	1	200	t	2025-12-14 13:04:36.483	2025-12-14 13:04:36.483	328.00	шт	20	поштучно
57008	3395	ЧЕРНИКА 300гр ТМ 4 Сезона	\N	\N	7958.00	шт	1	153	t	2025-12-14 13:04:36.494	2025-12-14 13:04:36.494	398.00	шт	20	поштучно
57009	3310	БАРАНИНА ДЛЯ ПЛОВА н/к с/м в/уп (1уп~1кг) Хакасская	\N	\N	11639.00	кг	1	36	t	2025-12-14 13:09:52.731	2025-12-14 13:09:52.731	968.00	кг	12	поштучно
57010	3310	БАРАНИНА н/к в разрубе вес Алтай	\N	\N	795.00	кг	1	29	t	2025-12-14 13:09:52.752	2025-12-14 13:09:52.752	795.00	кг	1	поштучно
57011	3310	БАРАНИНА ШЕЙКА в кольцах в/у (1уп~900гр) Хакасская	\N	\N	1030.00	шт	1	29	t	2025-12-14 13:09:52.765	2025-12-14 13:09:52.765	1030.00	шт	1	поштучно
57012	3310	КОРЕЙКА ЯГНЕНКА 8 ребер н/к в/у (1уп~700гр) Хакасская	\N	\N	3728.00	кг	1	31	t	2025-12-14 13:09:52.789	2025-12-14 13:09:52.789	3728.00	кг	1	поштучно
57013	3310	ЯГНЯТИНА ГОЛЯШКА ЗАДНЯЯ н/к в/у (1уп~1,1кг) Хакасская	\N	\N	14205.00	кг	1	38	t	2025-12-14 13:09:52.801	2025-12-14 13:09:52.801	1052.00	кг	14	поштучно
57014	3310	ЯГНЯТИНА ЛОПАТКА н/к в/у  (1уп~1кг) Хакасская	\N	\N	33820.00	кг	1	103	t	2025-12-14 13:09:52.827	2025-12-14 13:09:52.827	2086.00	кг	16	поштучно
57015	3310	ЯГНЯТИНА ОКОРОК н/к без голяшки в/у (1уп~2кг) Хакасская	\N	\N	2958.00	шт	1	60	t	2025-12-14 13:09:52.841	2025-12-14 13:09:52.841	2958.00	шт	1	поштучно
57016	3310	ЯГНЯТИНА ОКОРОК н/к стейками в/у (1уп~1кг) Хакасская	\N	\N	16637.00	кг	1	55	t	2025-12-14 13:09:52.888	2025-12-14 13:09:52.888	1441.00	кг	12	поштучно
57017	3310	ЯГНЯТИНА Ребрышки в/у (1уп ~ 1кг) Хакасская	\N	\N	12681.00	кг	1	119	t	2025-12-14 13:09:52.9	2025-12-14 13:09:52.9	1144.00	кг	11	поштучно
57018	3310	РЕБРЫШКИ свиные Пикантные в/к с/м в/уп (1шт~0,4кг) 1/10-12кг ТМ Алтайский купец	\N	\N	327.00	шт (~0,4кг)	1	6	f	2025-12-14 13:11:42.04	2025-12-14 13:12:03.139	327.00	шт	\N	только уп
57019	3310	РЕБРЫШКИ свиные Пикантные в/к с/м в/уп (1шт~0,4кг) 1/10-12кг ТМ Алтайский купец	\N	\N	5985.00	шт	1	6	t	2025-12-14 13:13:33.082	2025-12-14 13:13:33.082	5985.00	шт	\N	только уп
57020	3310	САЛО Народное в/к с/м в/уп 1/10-12кг ТМ Алтайский купец	\N	\N	6785.00	уп (12 шт)	1	8	t	2025-12-14 13:16:53.927	2025-12-14 13:16:53.927	575.00	кг	12	только уп
57022	3310	САЛО Шпик соленый Домашний Премиум в/к с/м в/уп (1шт~0,3кг) 1/10-13кг ТМ Алтайский купец	\N	\N	12313.00	шт	1	13	f	2025-12-14 13:16:53.955	2025-12-14 13:18:08.942	12313.00	шт	\N	только уп
57021	3310	САЛО Шпик соленый Домашний Премиум в/к с/м в/уп (1шт ~ 1,5кг) 1/10-13кг ТМ Алтайский купец	\N	\N	11740.00	шт	1	7	f	2025-12-14 13:16:53.941	2025-12-14 13:18:21.535	11740.00	шт	\N	только уп
57023	3310	САЛО Шпик соленый Копченый Закусочный в/к с/м в/уп (1шт~0,3кг) 1/5-7кг ТМ Алтайский купец	\N	\N	4523.00	шт	1	30	t	2025-12-14 13:22:34.222	2025-12-14 13:22:34.222	4523.00	шт	\N	только уп
57024	3310	ГРУДИНКА свиная фас в/к Пикантная с/м в/уп (1шт~0,4кг) ТМ Алтайский купец	\N	\N	5548.00	шт	1	9	t	2025-12-14 13:22:34.24	2025-12-14 13:22:34.24	5548.00	шт	\N	только уп
57025	3310	ГРУДИНКА свиная фас соленая с паприкой с/м в/уп (1шт-150гр) ТМ Алтайский купец	\N	\N	4278.00	уп (24 шт)	1	44	t	2025-12-14 13:22:34.254	2025-12-14 13:22:34.254	178.00	шт	24	только уп
57026	3310	ГРУДИНКА свиная фас соленая с черным перцем с/м в/уп (1шт-150гр) ТМ Алтайский купец	\N	\N	4278.00	уп (24 шт)	1	27	t	2025-12-14 13:22:34.266	2025-12-14 13:22:34.266	178.00	шт	24	только уп
57027	3310	ЦЫПЛЕНОК-БРОЙЛЕР Благояр ~2кг (калиброванная тушка) с/м*	\N	\N	660.00	шт	1	1000	t	2025-12-14 13:35:37.862	2025-12-14 13:35:37.862	660.00	шт	1	поштучно
57028	3310	ЦЫПЛЕНОК-БРОЙЛЕР Благояр 1,8кг (калиброванная тушка) с/м*	\N	\N	625.00	шт	1	1000	t	2025-12-14 13:35:37.878	2025-12-14 13:35:37.878	625.00	шт	1	поштучно
57029	4594	ДИСКОНТ МАСЛО 500гр 72,5% Крестьянское Курск	\N	\N	3277.00	шт	1	264	t	2025-12-14 13:35:37.894	2025-12-14 13:35:37.894	328.00	шт	10	поштучно
57030	4594	ДИСКОНТ МАСЛО 500гр 82,5% Традиционное Курск	\N	\N	3450.00	шт	1	473	t	2025-12-14 13:35:37.91	2025-12-14 13:35:37.91	345.00	шт	10	поштучно
57031	4594	ДИСКОНТ ГОЛЕНЬ ИНДЕЙКА БЕСКОСТНАЯ подложка (1шт~750гр)ТМ Индилайт	уп (6шт -2676р)	\N	388.00	шт	1	74	t	2025-12-14 13:35:37.922	2025-12-14 13:35:37.922	388.00	шт	\N	поштучно
57032	4594	ДИСКОНТ ГОЛЕНЬ ИНДЕЙКА подложка (1шт~900гр)ТМ Индилайт	уп (5шт -1545р)	\N	269.00	шт	1	73	t	2025-12-14 13:35:37.933	2025-12-14 13:35:37.933	269.00	шт	\N	поштучно
57033	4594	ДИСКОНТ КРЫЛО ПЛЕЧЕВАЯ ЧАСТЬ ИНДЕЙКА подложка (1шт~800гр) ТМ Индилайт	уп (7шт -1855р)	\N	230.00	шт	1	67	t	2025-12-14 13:35:37.954	2025-12-14 13:35:37.954	230.00	шт	\N	поштучно
57034	4594	ДИСКОНТ КРЫЛО ЦЕЛОЕ ИНДЕЙКА резаное подложка (1шт~800гр) ТМ Индилайт	уп (6шт -1710р)	\N	248.00	шт	1	68	t	2025-12-14 13:35:37.967	2025-12-14 13:35:37.967	248.00	шт	\N	поштучно
57035	4594	ДИСКОНТ УТЕНОК Крыло 2 фаланги в горчично-пряном маринаде пакет (1шт~1.2кг) ВЕС 1/9,6кг ТМ Улыбино	уп (7шт -2625р)	\N	324.00	шт	1	17	t	2025-12-14 13:35:37.978	2025-12-14 13:35:37.978	324.00	шт	\N	поштучно
57036	4594	ДИСКОНТ УТЕНОК Окорочок скин лоток (1шт~0,5кг) ВЕС ТМ Улыбино	уп (5шт -2135р)	\N	371.00	шт	1	9	t	2025-12-14 13:35:37.989	2025-12-14 13:35:37.989	371.00	шт	\N	поштучно
57037	4594	ДИСКОНТ УТЕНОК Табака в маринаде пакет д/запекания  (1шт~2,5кг) ТМ Озерка	уп (2шт -2620р)	\N	1139.00	шт	1	72	t	2025-12-14 13:35:38.001	2025-12-14 13:35:38.001	1139.00	шт	\N	поштучно
57038	4594	ДИСКОНТ УТЕНОК Тушка 1 сорт потрошен в/у пакет (1шт~1,2кг) ТМ Озерка	уп (5шт -1905р)	\N	331.00	шт	1	50	t	2025-12-14 13:35:38.012	2025-12-14 13:35:38.012	331.00	шт	\N	поштучно
57039	4594	ДИСКОНТ УТЕНОК Филе Грудки б/к подложка  (1шт~0,6кг) 1/6-7кг ТМ Озерка	уп (8шт -4376р)	\N	476.00	шт	1	19	t	2025-12-14 13:35:38.024	2025-12-14 13:35:38.024	476.00	шт	\N	поштучно
56830	3367	СЕЛЬДЬ вес малосоленая жирная в ведре 10кг РПЗ ТАНДЕМ	\N	\N	2277.00	уп (10 шт)	1	80	t	2025-12-14 13:04:33.432	2025-12-14 16:58:12.453	228.00	кг	10	только уп
54932	3396	ВЕТЧИНА вар Анком ВЕС Элитная Анкомовская в/с замороженая п/а	\N	\N	15318.00	кг	1	102	f	2025-12-14 13:03:58.985	2025-12-14 17:04:48.674	766.00	кг	20	поштучно
55912	3327	Абрикосовый компот 680гр ст/б ТМ Знаток	\N	\N	1766.00	уп (8 шт)	1	19	f	2025-12-14 13:04:17.143	2025-12-15 02:51:27.375	221.00	шт	8	только уп
57040	3327	Абрикосовый компот 680гр ст/б ТМ Знаток	\N	\N	1766.00	уп (8 шт)	1	19	t	2025-12-15 03:14:26.058	2025-12-15 03:14:26.058	221.00	шт	8	только уп
57041	3395	АБРИКОСЫ половинки вес Россия	\N	\N	3346.00	уп (10 шт)	1	500	t	2025-12-15 03:14:26.072	2025-12-15 03:14:26.072	335.00	кг	10	только уп
\.


--
-- Data for Name: supplier_category_mappings; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.supplier_category_mappings (id, "supplierCategory", "targetCategoryId", confidence, "timesUsed", "createdAt", "updatedAt", "saleType") FROM stdin;
1461	- Сухофрукты, орехи	3405	auto	0	2025-11-22 11:52:07.049	2025-12-11 09:25:52.634	только уп
1514	КОНСЕРВЫ ПЛОДООВОЩНЫЕ	3327	auto	0	2025-11-22 11:52:08.144	2025-12-11 09:25:53.386	поштучно
1515	КОНСЕРВЫ РЫБНЫЕ (C)	3327	auto	0	2025-11-22 11:52:08.159	2025-12-11 09:25:53.408	поштучно
1516	МАЙОНЕЗЫ, КЕТЧУПЫ, СОУСЫ	3400	auto	0	2025-11-22 11:52:08.174	2025-12-11 09:25:53.417	поштучно
1517	МОЛОЧНЫЕ ПРОДУКТЫ	3305	auto	0	2025-11-22 11:52:08.191	2025-12-11 09:25:53.427	поштучно
1518	МОРОЖЕНОЕ "САНТА БРЕМОР" БЕЛАРУСЬ (R)	3392	auto	0	2025-11-22 11:52:08.206	2025-12-11 09:25:53.459	поштучно
2194	Молочные Продукты	4594	manual	0	2025-12-11 09:25:53.817	2025-12-11 09:25:53.817	поштучно
2195	Мясо,Птица	4594	manual	0	2025-12-11 09:25:53.825	2025-12-11 09:25:53.825	поштучно
1343	- Дой-пак	3392	manual	0	2025-11-22 11:52:04.588	2025-12-11 09:25:50.419	поштучно
1345	- Зефир	3303	auto	0	2025-11-22 11:52:04.642	2025-12-11 09:25:50.452	поштучно
1346	- Зефир, мармелад  весовые	3303	auto	0	2025-11-22 11:52:04.675	2025-12-11 09:25:50.463	поштучно
1348	- Изделия из гольца	3367	manual	0	2025-11-22 11:52:04.713	2025-12-11 09:25:50.486	поштучно
1349	- Изделия из горбуши	3367	auto	0	2025-11-22 11:52:04.731	2025-12-11 09:25:50.498	поштучно
1350	- Изделия из кальмара и трубача	3367	auto	0	2025-11-22 11:52:04.745	2025-12-11 09:25:50.509	поштучно
1351	- Изделия из кеты	3367	manual	0	2025-11-22 11:52:04.789	2025-12-11 09:25:50.52	поштучно
1352	- Изделия из кеты ДАЛЬРЫБФЛОТПРОДУКТ	3367	manual	0	2025-11-22 11:52:04.816	2025-12-11 09:25:50.531	поштучно
1353	- Изделия из кильки, мойвы	3367	manual	0	2025-11-22 11:52:04.836	2025-12-11 09:25:50.54	поштучно
1366	- Картофель фри, изделия из картофеля	3395	auto	0	2025-11-22 11:52:05.049	2025-12-11 09:25:50.699	поштучно
1354	- Изделия из минтая	3367	manual	0	2025-11-22 11:52:04.85	2025-12-11 09:25:50.559	поштучно
1355	- Изделия из палтуса, кижуча, нерки	3367	auto	0	2025-11-22 11:52:04.869	2025-12-11 09:25:50.569	поштучно
1356	- Изделия из сельди	3367	manual	0	2025-11-22 11:52:04.889	2025-12-11 09:25:50.588	поштучно
1357	- Изделия из скумбрии	3367	manual	0	2025-11-22 11:52:04.905	2025-12-11 09:25:50.6	поштучно
1358	- Изделия из слоеного и сдобного теста	3397	manual	0	2025-11-22 11:52:04.922	2025-12-11 09:25:50.612	только уп
1359	- Икра	3367	auto	0	2025-11-22 11:52:04.938	2025-12-11 09:25:50.625	поштучно
1360	- Икра замороженная для суши	3398	manual	0	2025-11-22 11:52:04.954	2025-12-11 09:25:50.634	поштучно
1361	- Индейка разделка весовая	3310	auto	0	2025-11-22 11:52:04.969	2025-12-11 09:25:50.648	только уп
1362	- Индейка разделка фасованная	3310	auto	0	2025-11-22 11:52:04.988	2025-12-11 09:25:50.658	поштучно
1363	- К пиву	3399	manual	0	2025-11-22 11:52:05.004	2025-12-11 09:25:50.67	поштучно
1364	- Карамель весовая	3303	auto	0	2025-11-22 11:52:05.019	2025-12-11 09:25:50.679	поштучно
1365	- Карамель фасованная	3303	auto	0	2025-11-22 11:52:05.034	2025-12-11 09:25:50.689	поштучно
1367	- Кетчуп (B)	3400	auto	0	2025-11-22 11:52:05.066	2025-12-11 09:25:50.713	поштучно
1368	- Килька консервированная	3327	auto	0	2025-11-22 11:52:05.082	2025-12-11 09:25:50.723	поштучно
1369	- Колбаса ВИК	3396	manual	0	2025-11-22 11:52:05.117	2025-12-11 09:25:50.735	поштучно
1370	- Колбаса ТМ Анком Санкт-Питербург замороженая (срок 360 суток при -18)	3396	auto	0	2025-11-22 11:52:05.14	2025-12-11 09:25:50.771	поштучно
1371	- Колбаса ТМ ВИК	3396	auto	0	2025-11-22 11:52:05.154	2025-12-11 09:25:50.798	поштучно
1471	- Творог, творожная масса (T)	3305	auto	0	2025-11-22 11:52:07.254	2025-12-11 09:25:52.776	только уп
1472	- Телятина молодая	3310	auto	0	2025-11-22 11:52:07.283	2025-12-11 09:25:52.787	поштучно
1473	- Тесто  (R)	3391	auto	0	2025-11-22 11:52:07.304	2025-12-11 09:25:52.797	поштучно
1474	- Томатная паста	3327	auto	0	2025-11-22 11:52:07.321	2025-12-11 09:25:52.806	только уп
1475	- Торт	3392	manual	0	2025-11-22 11:52:07.385	2025-12-11 09:25:52.818	поштучно
1476	- Торт вафельный	3303	manual	0	2025-11-22 11:52:07.415	2025-12-11 09:25:52.827	только уп
1477	- Торты, рулеты, чизкейки	3303	auto	0	2025-11-22 11:52:07.43	2025-12-11 09:25:52.836	поштучно
1478	- Упаковка и одноразовая посуда	3393	manual	0	2025-11-22 11:52:07.445	2025-12-11 09:25:52.845	поштучно
1479	- УТКА разделка с/м  Россия	3310	auto	0	2025-11-22 11:52:07.461	2025-12-11 09:25:52.853	поштучно
1480	- Фарш	3310	auto	0	2025-11-22 11:52:07.477	2025-12-11 09:25:52.894	поштучно
1481	- Фруктовые снеки сушеные	3303	auto	0	2025-11-22 11:52:07.497	2025-12-11 09:25:52.908	поштучно
1482	- Фруктовый лед	3392	manual	0	2025-11-22 11:52:07.516	2025-12-11 09:25:52.918	только уп
1483	- Халва, козинак	3303	auto	0	2025-11-22 11:52:07.536	2025-12-11 09:25:52.928	только уп
2196	СКОТЧ прозрачный 5,5см*66м	3393	manual	0	2025-12-13 10:56:11.423	2025-12-13 10:56:11.423	поштучно
1376	- Консервы и закуски овощные  пр-ва "СПАССКИЙ КЗ"	3327	manual	0	2025-11-22 11:52:05.258	2025-12-11 09:25:50.89	поштучно
1378	- Консервы и закуски овощные  ТМ "ПИКАНТА"	3327	manual	0	2025-11-22 11:52:05.313	2025-12-11 09:25:50.913	только уп
1379	- Консервы и закуски овощные  ТМ "РЕСТОРАЦИЯ ОБЛОМОВ"	3327	manual	0	2025-11-22 11:52:05.333	2025-12-11 09:25:50.922	поштучно
1380	- Консервы и закуски овощные  ТМ "СКАТЕРТЬ-САМОБРАНКА"	3327	manual	0	2025-11-22 11:52:05.389	2025-12-11 09:25:50.933	только уп
1381	- Консервы и закуски овощные  ТМ "СЫТА-ЗАГОРА"	3327	manual	0	2025-11-22 11:52:05.424	2025-12-11 09:25:50.947	только уп
1382	- Консервы овощные горошек, кукуруза	3327	auto	0	2025-11-22 11:52:05.438	2025-12-11 09:25:50.962	только уп
1383	- Консервы овощные ТМ "СОННА МЕРА"  Индия	3327	auto	0	2025-11-22 11:52:05.453	2025-12-11 09:25:50.984	только уп
1415	- Оливки маслины	3327	auto	0	2025-11-22 11:52:06.066	2025-12-11 09:25:51.717	только уп
1416	- Пакеты	3393	manual	0	2025-11-22 11:52:06.083	2025-12-11 09:25:51.734	поштучно
1417	- Паста арахисовая, шоколадная	3303	auto	0	2025-11-22 11:52:06.101	2025-12-11 09:25:51.782	поштучно
1418	- Паштеты	3327	auto	0	2025-11-22 11:52:06.12	2025-12-11 09:25:51.806	поштучно
1419	- Пельмени, манты, хинкали фасованные (S)	3356	auto	0	2025-11-22 11:52:06.133	2025-12-11 09:25:51.82	поштучно
1420	- Перчатки.губки для посуды. халаты. чехлы для обуви	3393	manual	0	2025-11-22 11:52:06.148	2025-12-11 09:25:51.837	поштучно
1421	- Печенье весовое	3303	auto	0	2025-11-22 11:52:06.169	2025-12-11 09:25:51.931	поштучно
1422	- Печенье фасованное	3303	auto	0	2025-11-22 11:52:06.202	2025-12-11 09:25:51.964	поштучно
1423	- Печенье,крекер	3303	auto	0	2025-11-22 11:52:06.219	2025-12-11 09:25:52.008	только уп
1424	- Печенье,сушки,пряники	3303	auto	0	2025-11-22 11:52:06.233	2025-12-11 09:25:52.022	только уп
1425	- Пирожные, десерты, пончики	3303	auto	0	2025-11-22 11:52:06.25	2025-12-11 09:25:52.034	поштучно
1426	- Пицца, основа для пиццы	3391	auto	0	2025-11-22 11:52:06.266	2025-12-11 09:25:52.052	только уп
1427	- Полуфабрикаты весовые (S)	3391	manual	0	2025-11-22 11:52:06.281	2025-12-11 09:25:52.067	только уп
1428	- Полуфабрикаты для разогрева	3391	auto	0	2025-11-22 11:52:06.344	2025-12-11 09:25:52.079	поштучно
1429	- Полуфабрикаты и деликатесы мороженые	3367	auto	0	2025-11-22 11:52:06.364	2025-12-11 09:25:52.093	поштучно
1430	- Полуфабрикаты фасованные (S)	3391	manual	0	2025-11-22 11:52:06.381	2025-12-11 09:25:52.111	поштучно
1431	- Попкорн	3303	manual	0	2025-11-22 11:52:06.397	2025-12-11 09:25:52.126	поштучно
1528	РЫБА И МОРЕПРОДУКТЫ СВЕЖЕМОРОЖЕННЫЕ  (L)	3367	auto	0	2025-11-22 11:52:08.432	2025-12-11 09:25:53.645	поштучно
1529	САЛО, ШПИК, ГРУДИНКА СОЛЕНЫЕ и В/К замороженные (P)	3310	auto	0	2025-11-22 11:52:08.448	2025-12-11 09:25:53.721	поштучно
1530	СНЕКИ	3303	auto	0	2025-11-22 11:52:08.468	2025-12-11 09:25:53.736	поштучно
1531	Сыры	3314	auto	0	2025-11-22 11:52:08.488	2025-12-11 09:25:53.747	поштучно
1979	    Молочные Продукты	4594	manual	0	2025-12-11 09:09:27.603	2025-12-11 09:09:27.603	поштучно
1980	    Мясо,Птица	4594	manual	0	2025-12-11 09:09:27.616	2025-12-11 09:09:27.616	поштучно
1466	- Сыры плавленые	3314	auto	0	2025-11-22 11:52:07.172	2025-12-11 09:25:52.719	поштучно
1467	- Сыры творожные, мягкие, брынза	3314	auto	0	2025-11-22 11:52:07.189	2025-12-11 09:25:52.732	поштучно
1468	- Сыры фасованные	3314	auto	0	2025-11-22 11:52:07.203	2025-12-11 09:25:52.744	поштучно
1469	- Сэндвич	3392	manual	0	2025-11-22 11:52:07.225	2025-12-11 09:25:52.755	только уп
1484	- Хлеб п/ф заморож высокой степени готовности	3323	auto	0	2025-11-22 11:52:07.552	2025-12-11 09:25:52.936	только уп
1487	- Хлебцы, батончики, мюсли	3303	auto	0	2025-11-22 11:52:07.624	2025-12-11 09:25:52.952	только уп
1488	- Хлопья, каши, семена (C)	3317	manual	0	2025-11-22 11:52:07.65	2025-12-11 09:25:52.968	только уп
1489	- Хрен, горчица, аджика (B)	3400	auto	0	2025-11-22 11:52:07.665	2025-12-11 09:25:52.977	поштучно
1490	- Чипсы и снеки (D)	3303	auto	0	2025-11-22 11:52:07.685	2025-12-11 09:25:52.986	поштучно
1491	- Чистящие средства	3393	manual	0	2025-11-22 11:52:07.7	2025-12-11 09:25:52.994	поштучно
1494	- Шоколадные батончики	3303	auto	0	2025-11-22 11:52:07.756	2025-12-11 09:25:53.022	поштучно
1499	- Яичный меланж	3310	auto	0	2025-11-22 11:52:07.837	2025-12-11 09:25:53.189	поштучно
1500	- Яйцо куриное (А)	3310	auto	0	2025-11-22 11:52:07.851	2025-12-11 09:25:53.198	только уп
1501	-Крупы весовые  (C)	3317	auto	0	2025-11-22 11:52:07.892	2025-12-11 09:25:53.209	только уп
1502	БАКАЛЕЯ (C)	3317	manual	0	2025-11-22 11:52:07.908	2025-12-11 09:25:53.229	поштучно
1520	МОРОЖЕНОЕ ТМ "ПРОЧЕЕ" (R)	3392	auto	0	2025-11-22 11:52:08.248	2025-12-11 09:25:53.489	поштучно
1521	МОРОЖЕНОЕ ТМ "СЕЛО ЗЕЛЕНОЕ"  (R)	3392	auto	0	2025-11-22 11:52:08.263	2025-12-11 09:25:53.501	поштучно
1522	МОРОЖЕНОЕ ТМ "ЧИСТАЯ ЛИНИЯ"  (R)	3392	auto	0	2025-11-22 11:52:08.282	2025-12-11 09:25:53.51	поштучно
1523	МЯСО, ПТИЦА, ЯЙЦО  (P)	3310	auto	0	2025-11-22 11:52:08.351	2025-12-11 09:25:53.519	поштучно
1524	НАПИТКИ	3323	auto	0	2025-11-22 11:52:08.372	2025-12-11 09:25:53.532	поштучно
1525	ОВОЩИ, ФРУКТЫ, ГРИБЫ ЗАМОРОЖЕННЫЕ  (T)	3395	auto	0	2025-11-22 11:52:08.387	2025-12-11 09:25:53.541	поштучно
1526	ПОЛУФАБРИКАТЫ ГОТОВЫЕ  (S)	3391	manual	0	2025-11-22 11:52:08.403	2025-12-11 09:25:53.583	поштучно
1527	ПОЛУФАБРИКАТЫ ДЛЯ ПРИГОТОВЛЕНИЯ	3391	auto	0	2025-11-22 11:52:08.418	2025-12-11 09:25:53.595	поштучно
1532	СЫРЫ (B)	3314	auto	0	2025-11-22 11:52:08.503	2025-12-11 09:25:53.785	поштучно
1533	ТОРТЫ и ПИРОЖНЫЕ ЗАМОРОЖЕННЫЕ (R)	3303	auto	0	2025-11-22 11:52:08.518	2025-12-11 09:25:53.795	поштучно
1978	ТОВАРЫ С ДИСКОНТОМ	4594	manual	0	2025-12-11 09:09:27.592	2025-12-11 09:25:53.806	поштучно
1393	- Креветка сыромороженая	3367	auto	0	2025-11-22 11:52:05.622	2025-12-11 09:25:51.18	поштучно
1394	- Крупы фасованные (C)	3317	auto	0	2025-11-22 11:52:05.64	2025-12-11 09:25:51.194	поштучно
1395	- Курица разделка весовая	3310	auto	0	2025-11-22 11:52:05.666	2025-12-11 09:25:51.204	только уп
1396	- Курица разделка фасованная	3310	auto	0	2025-11-22 11:52:05.688	2025-12-11 09:25:51.228	поштучно
1397	- Курица тушка	3310	auto	0	2025-11-22 11:52:05.708	2025-12-11 09:25:51.238	поштучно
1398	- Майонез (C)	3400	auto	0	2025-11-22 11:52:05.724	2025-12-11 09:25:51.283	поштучно
1399	- Макаронные изделия весовые (C)	3317	auto	0	2025-11-22 11:52:05.739	2025-12-11 09:25:51.314	только уп
1400	- Макаронные изделия фасованные (C)	3317	auto	0	2025-11-22 11:52:05.754	2025-12-11 09:25:51.326	поштучно
1401	- Масло растительное	3401	auto	0	2025-11-22 11:52:05.77	2025-12-11 09:25:51.346	только уп
1403	- Масло сливочное фасованное	3401	auto	0	2025-11-22 11:52:05.822	2025-12-11 09:25:51.459	поштучно
1404	- Мед	3402	manual	0	2025-11-22 11:52:05.84	2025-12-11 09:25:51.479	поштучно
1405	- Молоко сгущеное консервированное	3327	auto	0	2025-11-22 11:52:05.864	2025-12-11 09:25:51.498	поштучно
1406	- Молоко, сливки (D)	3305	auto	0	2025-11-22 11:52:05.881	2025-12-11 09:25:51.507	только уп
1407	- Морепродукты мороженые	3367	auto	0	2025-11-22 11:52:05.898	2025-12-11 09:25:51.516	поштучно
1408	- Мороженое ТМ "Брест-Литовск", "Солетто", "ЮККИ"	3392	auto	0	2025-11-22 11:52:05.914	2025-12-11 09:25:51.525	только уп
1409	- Мясо и птица в Маринадах	3310	auto	0	2025-11-22 11:52:05.931	2025-12-11 09:25:51.533	поштучно
1410	- Наггетсы	3391	auto	0	2025-11-22 11:52:05.946	2025-12-11 09:25:51.543	поштучно
1438	- Продукция ТМ Барс, Новосибирск	3310	manual	0	2025-11-22 11:52:06.545	2025-12-11 09:25:52.262	только уп
1323	- Ассорти	3367	manual	0	2025-11-22 11:52:04.192	2025-12-11 09:25:49.836	поштучно
1327	- Брикет	3392	manual	0	2025-11-22 11:52:04.285	2025-12-11 09:25:50.148	только уп
1329	- Бытовая химия	3393	manual	0	2025-11-22 11:52:04.334	2025-12-11 09:25:50.205	поштучно
1331	- Варенье, джем, повидло	3394	auto	0	2025-11-22 11:52:04.363	2025-12-11 09:25:50.231	только уп
1332	- Вафли	3303	auto	0	2025-11-22 11:52:04.38	2025-12-11 09:25:50.241	только уп
1333	- Вафли весовые	3303	auto	0	2025-11-22 11:52:04.4	2025-12-11 09:25:50.264	поштучно
1334	- Вафли фасованные	3303	auto	0	2025-11-22 11:52:04.415	2025-12-11 09:25:50.286	поштучно
1335	- Ведерко, контейнер, пакет	3392	manual	0	2025-11-22 11:52:04.433	2025-12-11 09:25:50.307	поштучно
1336	- Говядина весовая	3310	auto	0	2025-11-22 11:52:04.449	2025-12-11 09:25:50.316	только уп
1341	- Деликатессы по-корейски (B)	3396	auto	0	2025-11-22 11:52:04.548	2025-12-11 09:25:50.376	поштучно
1372	- Колбаса ТМ Останкино	3396	auto	0	2025-11-22 11:52:05.17	2025-12-11 09:25:50.824	поштучно
1373	- Колбаса ТМ СПК	3396	auto	0	2025-11-22 11:52:05.207	2025-12-11 09:25:50.839	поштучно
1374	- Колбаса ТМ Черкизово	3396	auto	0	2025-11-22 11:52:05.224	2025-12-11 09:25:50.851	поштучно
1375	- Компоты  фруктовые	3327	auto	0	2025-11-22 11:52:05.24	2025-12-11 09:25:50.867	только уп
1377	- Консервы и закуски овощные  ТМ "ЗНАТОК"	3327	manual	0	2025-11-22 11:52:05.273	2025-12-11 09:25:50.899	только уп
1384	- Консервы под заказ	3327	manual	0	2025-11-22 11:52:05.472	2025-12-11 09:25:50.999	поштучно
1385	- Консервы томатные Италия	3327	auto	0	2025-11-22 11:52:05.487	2025-12-11 09:25:51.015	поштучно
1386	- Конфеты	3303	auto	0	2025-11-22 11:52:05.501	2025-12-11 09:25:51.032	только уп
1387	- Конфеты в коробках	3303	auto	0	2025-11-22 11:52:05.516	2025-12-11 09:25:51.046	поштучно
1388	- Конфеты шоколадные весовые	3303	auto	0	2025-11-22 11:52:05.531	2025-12-11 09:25:51.071	только уп
1389	- Конфеты шоколадные фасованные	3303	auto	0	2025-11-22 11:52:05.551	2025-12-11 09:25:51.094	поштучно
1390	- Кофе, чай  (C)	3323	auto	0	2025-11-22 11:52:05.565	2025-12-11 09:25:51.121	поштучно
1391	- Крабовые палочки , крабовое мясо	3367	auto	0	2025-11-22 11:52:05.58	2025-12-11 09:25:51.134	поштучно
1392	- Креветка варёно-мороженая	3367	auto	0	2025-11-22 11:52:05.597	2025-12-11 09:25:51.155	поштучно
1503	БЫТОВАЯ ХИМИЯ И ХОЗ ТОВАРЫ (C)	3393	manual	0	2025-11-22 11:52:07.922	2025-12-11 09:25:53.239	поштучно
1504	ИЗДЕЛИЯ ИЗ РЫБЫ И МОРЕПРОДУКТОВ ВЛАДИВОСТОК, МОСКВА (А)	3367	auto	0	2025-11-22 11:52:07.939	2025-12-11 09:25:53.26	поштучно
1505	ИЗДЕЛИЯ ИЗ РЫБЫ И МОРЕПРОДУКТОВ МЕСТНЫХ ПРОИЗВОДИТЕЛЕЙ (А)	3367	auto	0	2025-11-22 11:52:07.955	2025-12-11 09:25:53.273	поштучно
1506	КОЛБАСА ВАР, ВЕТЧИНА, СОСИСКИ (B)	3396	auto	0	2025-11-22 11:52:07.97	2025-12-11 09:25:53.286	поштучно
1507	КОЛБАСА ПОЛУКОПЧЕНАЯ, ВАРЕНОКОПЧЕНАЯ, ДЕЛИКАТЕСЫ (B)	3396	auto	0	2025-11-22 11:52:08.008	2025-12-11 09:25:53.296	поштучно
1432	- Пресервы и салаты из рыбы и морепродуктов пр-во Дальпико Фиш, Владивосток	3367	auto	0	2025-11-22 11:52:06.412	2025-12-11 09:25:52.14	поштучно
1433	- Пресервы и салаты из рыбы и морепродуктов ТМ ВРК, Владивосток	3367	auto	0	2025-11-22 11:52:06.426	2025-12-11 09:25:52.156	поштучно
1434	- Пресервы и салаты из рыбы и морепродуктов ТМ Русское Море, Санта Бремор, Меридиан	3367	auto	0	2025-11-22 11:52:06.444	2025-12-11 09:25:52.206	поштучно
1435	- Приправы, супы, пюре картофельное, лапша быстрого приготовления (C)	3403	auto	0	2025-11-22 11:52:06.474	2025-12-11 09:25:52.229	поштучно
1436	- Продукция для приготовления суши и ролл (A)	3398	manual	0	2025-11-22 11:52:06.498	2025-12-11 09:25:52.24	поштучно
1437	- Продукция ТМ Алтайский купец, Новосибирск	3310	manual	0	2025-11-22 11:52:06.531	2025-12-11 09:25:52.252	только уп
1439	- Продукция ТМ Богородский фермер	3310	manual	0	2025-11-22 11:52:06.573	2025-12-11 09:25:52.276	поштучно
1440	- Прочие консервы из рыбы и морепродуктов	3367	auto	0	2025-11-22 11:52:06.638	2025-12-11 09:25:52.309	поштучно
1442	- Пряники весовые	3303	auto	0	2025-11-22 11:52:06.675	2025-12-11 09:25:52.345	только уп
1443	- Пряники фасованные	3303	auto	0	2025-11-22 11:52:06.69	2025-12-11 09:25:52.375	поштучно
1445	- Рулеты, пирожные, кексы фасованные	3303	auto	0	2025-11-22 11:52:06.722	2025-12-11 09:25:52.406	поштучно
1447	- Сайра, сардина консервированные	3327	auto	0	2025-11-22 11:52:06.749	2025-12-11 09:25:52.429	поштучно
1448	- Салаты из морской капусты	3367	manual	0	2025-11-22 11:52:06.769	2025-12-11 09:25:52.438	поштучно
1456	- Сосиски рыбные охлаженые	3396	auto	0	2025-11-22 11:52:06.922	2025-12-11 09:25:52.559	поштучно
1460	- Сухое молоко, яичный порошок (C)	3305	auto	0	2025-11-22 11:52:07.033	2025-12-11 09:25:52.624	поштучно
1462	- Сушки,баранки,соломка, сухари весовые	3303	auto	0	2025-11-22 11:52:07.073	2025-12-11 09:25:52.647	поштучно
1463	- Сушки,баранки,соломка, сухари фасованные	3303	auto	0	2025-11-22 11:52:07.102	2025-12-11 09:25:52.664	поштучно
1464	- Сырки, рожки творожные (R)	3305	auto	0	2025-11-22 11:52:07.117	2025-12-11 09:25:52.698	только уп
1465	- Сыры весовые	3314	auto	0	2025-11-22 11:52:07.133	2025-12-11 09:25:52.708	поштучно
1470	- Сэндвич, лакомка	3392	manual	0	2025-11-22 11:52:07.24	2025-12-11 09:25:52.766	только уп
1508	КОЛБАСА СЫРОКОПЧЕНАЯ, НАРЕЗКИ (B)	3396	auto	0	2025-11-22 11:52:08.025	2025-12-11 09:25:53.304	поштучно
1509	КОНДИТЕРСКИЕ ИЗДЕЛИЯ (D)	3303	auto	0	2025-11-22 11:52:08.04	2025-12-11 09:25:53.322	поштучно
1510	КОНДИТЕРСКИЕ ИЗДЕЛИЯ ТМ "КОЛОМЕНСКОЕ" (D)	3303	auto	0	2025-11-22 11:52:08.066	2025-12-11 09:25:53.333	поштучно
1347	- Зефир, мармелад фасованные	3303	auto	0	2025-11-22 11:52:04.696	2025-12-11 09:25:50.474	только уп
1402	- Масло сливочное весовое	3401	auto	0	2025-11-22 11:52:05.799	2025-12-11 09:25:51.409	только уп
1411	- Напитки газированные, вода, чай (D)	3323	auto	0	2025-11-22 11:52:05.974	2025-12-11 09:25:51.586	только уп
1412	- Напитки негазированные, соки, нектары (C)	3323	auto	0	2025-11-22 11:52:05.996	2025-12-11 09:25:51.602	только уп
1413	- Овощи и грибы  весовые	3395	auto	0	2025-11-22 11:52:06.014	2025-12-11 09:25:51.623	только уп
1414	- Овощи и грибы фасованные	3395	auto	0	2025-11-22 11:52:06.046	2025-12-11 09:25:51.658	поштучно
1441	- Прочие консервы мясные, каши	3327	auto	0	2025-11-22 11:52:06.66	2025-12-11 09:25:52.327	поштучно
1444	- Рожок	3392	manual	0	2025-11-22 11:52:06.706	2025-12-11 09:25:52.395	только уп
1446	- Рыба мороженая	3367	auto	0	2025-11-22 11:52:06.735	2025-12-11 09:25:52.417	только уп
1449	- Свинина весовая	3310	auto	0	2025-11-22 11:52:06.785	2025-12-11 09:25:52.457	только уп
1452	- Сиропы и десерты	3303	auto	0	2025-11-22 11:52:06.848	2025-12-11 09:25:52.508	только уп
1453	- Сметанные продукты и десерты (B)	3305	auto	0	2025-11-22 11:52:06.87	2025-12-11 09:25:52.52	только уп
1454	- Соленья овощные  (А)	3327	auto	0	2025-11-22 11:52:06.888	2025-12-11 09:25:52.528	поштучно
1455	- Соль, сахар, мука (C)	3404	manual	0	2025-11-22 11:52:06.903	2025-12-11 09:25:52.537	только уп
1457	- Сосиски, сардельки мороженые	3396	auto	0	2025-11-22 11:52:06.951	2025-12-11 09:25:52.582	поштучно
1458	- Соусы  (B)	3400	auto	0	2025-11-22 11:52:06.971	2025-12-11 09:25:52.599	поштучно
1459	- Стаканчик	3392	manual	0	2025-11-22 11:52:07.013	2025-12-11 09:25:52.612	только уп
1492	- Шашлыки и колбаски замороженные для жарки	3310	auto	0	2025-11-22 11:52:07.714	2025-12-11 09:25:53.003	поштучно
1493	- Шоколад плиточный	3303	auto	0	2025-11-22 11:52:07.738	2025-12-11 09:25:53.013	только уп
1495	- Шпроты консервированные	3327	auto	0	2025-11-22 11:52:07.769	2025-12-11 09:25:53.072	поштучно
1519	МОРОЖЕНОЕ ТМ "НЕСТЛЕ" АКЦИЯ от ПРОИЗВОДИТЕЛЯ -"Летний ЦеноПад" (R)	3392	auto	0	2025-11-22 11:52:08.221	2025-12-11 09:25:53.479	поштучно
1324	- Баранина весовая	3310	auto	0	2025-11-22 11:52:04.224	2025-12-11 09:25:50.113	поштучно
1325	- Блинчики весовые	3391	auto	0	2025-11-22 11:52:04.239	2025-12-11 09:25:50.124	только уп
1326	- Блинчики фасованые	3391	auto	0	2025-11-22 11:52:04.253	2025-12-11 09:25:50.136	поштучно
1328	- Бумага туалетная, салфетки, полотенца бумажные	3393	manual	0	2025-11-22 11:52:04.31	2025-12-11 09:25:50.189	поштучно
1330	- Вареники фасованные  (S)	3356	auto	0	2025-11-22 11:52:04.349	2025-12-11 09:25:50.218	поштучно
1337	- Говядина консервированная	3327	auto	0	2025-11-22 11:52:04.466	2025-12-11 09:25:50.326	поштучно
1338	- Говядина мраморная	3310	auto	0	2025-11-22 11:52:04.494	2025-12-11 09:25:50.338	поштучно
1339	- Готовые блюда замороженные для разогрева	3391	auto	0	2025-11-22 11:52:04.517	2025-12-11 09:25:50.349	поштучно
1340	- Готовые блюда из овощей	3395	manual	0	2025-11-22 11:52:04.533	2025-12-11 09:25:50.364	поштучно
1342	- Для запекания	3393	manual	0	2025-11-22 11:52:04.563	2025-12-11 09:25:50.388	поштучно
1344	- Замороженные фруктовые чаи из натуральных ягод и трав (просто положи в кипяток)	3392	manual	0	2025-11-22 11:52:04.626	2025-12-11 09:25:50.433	только уп
1450	- Свинина консервированная	3327	auto	0	2025-11-22 11:52:06.811	2025-12-11 09:25:52.486	поштучно
1451	- Свинина фасованная	3310	auto	0	2025-11-22 11:52:06.833	2025-12-11 09:25:52.498	поштучно
1496	- Эскимо	3392	manual	0	2025-11-22 11:52:07.784	2025-12-11 09:25:53.081	только уп
1497	- Ягоды и фрукты весовые	3395	auto	0	2025-11-22 11:52:07.805	2025-12-11 09:25:53.132	только уп
1498	- Ягоды и фрукты фасованные	3395	auto	0	2025-11-22 11:52:07.821	2025-12-11 09:25:53.163	поштучно
1511	КОНДИТЕРСКИЕ ИЗДЕЛИЯ ТМ "СЛАДОНЕЖ" (D)	3303	auto	0	2025-11-22 11:52:08.082	2025-12-11 09:25:53.342	поштучно
1512	КОНСЕРВЫ МОЛОЧНЫЕ  (D)	3327	auto	0	2025-11-22 11:52:08.101	2025-12-11 09:25:53.354	поштучно
1513	КОНСЕРВЫ МЯСНЫЕ (C)	3327	auto	0	2025-11-22 11:52:08.118	2025-12-11 09:25:53.363	поштучно
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.system_settings (id, key, value, description, "updatedAt") FROM stdin;
3	payment_mode	test	Режим платежей: test или production	2025-09-06 13:10:15.944
4	enable_test_cards	false	Разрешить тестовые карты в боевом режиме	2025-09-07 03:33:21.658
1	default_margin_percent	15	Маржа по умолчанию для новых партий (%)	2025-11-22 01:25:16.858
11	checkout_enabled	true	Разрешить пользователям оформлять заказы	2025-12-14 13:05:07.298
24	maintenance_mode	false	Режим технического обслуживания	2025-12-14 13:41:34.811
25	maintenance_message	Проводятся технические работы	Сообщение при техническом обслуживании	2025-12-14 13:41:34.832
26	maintenance_end_time	2 Часа	Планируемое время окончания обслуживания	2025-12-14 13:41:34.842
23	allowed_phones	["+79148291630"]	Телефоны с доступом во время обслуживания	2025-12-14 13:41:34.854
2	vat_code	6	Код НДС: 1=20%, 2=10%, 3=20/120, 4=10/110, 5=0%, 6=без НДС	2025-10-02 12:17:11.988
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: superadmin
--

COPY public.users (id, phone, "firstName", "lastName", email, "isActive", "createdAt", "updatedAt", "acceptedTerms", "acceptedTermsAt", "acceptedTermsIp") FROM stdin;
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
470	79142254719	Алексей	\N	yarikalex83@mail.ru	t	2025-12-10 03:53:52.906	2025-12-10 03:53:52.906	f	\N	\N
471	79142880332	Светлана	\N	\N	t	2025-12-11 01:08:34.053	2025-12-11 01:08:34.053	f	\N	\N
472	79142311674	Олеся	\N	\N	t	2025-12-11 06:22:37.001	2025-12-11 06:22:37.001	f	\N	\N
473	79142871499	Галина	Дикусарэ	ddikusare@list.ru	t	2025-12-11 07:39:53.465	2025-12-11 07:39:53.465	f	\N	\N
475	79141030067	Мила	\N	\N	t	2025-12-11 23:02:16.898	2025-12-11 23:02:16.898	f	\N	\N
476	79142347093	Светлана	Семенова	Svetlana-romanov@mail.ru	t	2025-12-14 06:47:08.899	2025-12-14 06:47:08.899	f	\N	\N
477	79142915198	Наталья	Рыбалко	Natasha20071967@yandex.ru	t	2025-12-14 09:09:52.416	2025-12-14 09:09:52.416	f	\N	\N
478	79142775756	Раиса	Прищепа	prisheparaisa90@msil.ru	t	2025-12-14 23:03:17.053	2025-12-14 23:03:17.053	f	\N	\N
\.


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.addresses_id_seq', 141, true);


--
-- Name: batch_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.batch_items_id_seq', 73, true);


--
-- Name: batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.batches_id_seq', 249, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.categories_id_seq', 4594, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.order_items_id_seq', 1107, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.orders_id_seq', 606, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.payments_id_seq', 284, true);


--
-- Name: product_snapshots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.product_snapshots_id_seq', 14436, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.products_id_seq', 57041, true);


--
-- Name: supplier_category_mappings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.supplier_category_mappings_id_seq', 2196, true);


--
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 638, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: superadmin
--

SELECT pg_catalog.setval('public.users_id_seq', 478, true);


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

\unrestrict AOwvaVfRG9RWLjc42XgealxgxhQItwm5PBcHNlXN5vL4liBvNCU2o8SP25P76EL

