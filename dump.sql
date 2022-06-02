--
-- PostgreSQL database dump
--

-- Dumped from database version 12.10 (Debian 12.10-1.pgdg110+1)
-- Dumped by pg_dump version 12.10 (Debian 12.10-1.pgdg110+1)

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
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO postgres;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: hdb_action_log; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_action_log (
    id uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    action_name text,
    input_payload jsonb NOT NULL,
    request_headers jsonb NOT NULL,
    session_variables jsonb NOT NULL,
    response_payload jsonb,
    errors jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    response_received_at timestamp with time zone,
    status text NOT NULL,
    CONSTRAINT hdb_action_log_status_check CHECK ((status = ANY (ARRAY['created'::text, 'processing'::text, 'completed'::text, 'error'::text])))
);


ALTER TABLE hdb_catalog.hdb_action_log OWNER TO postgres;

--
-- Name: hdb_cron_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_cron_event_invocation_logs OWNER TO postgres;

--
-- Name: hdb_cron_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_cron_events OWNER TO postgres;

--
-- Name: hdb_metadata; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_metadata (
    id integer NOT NULL,
    metadata json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL
);


ALTER TABLE hdb_catalog.hdb_metadata OWNER TO postgres;

--
-- Name: hdb_scheduled_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_scheduled_event_invocation_logs OWNER TO postgres;

--
-- Name: hdb_scheduled_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    webhook_conf json NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    retry_conf json,
    payload json,
    header_conf json,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    comment text,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_scheduled_events OWNER TO postgres;

--
-- Name: hdb_schema_notifications; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_schema_notifications (
    id integer NOT NULL,
    notification json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL,
    instance_id uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT hdb_schema_notifications_id_check CHECK ((id = 1))
);


ALTER TABLE hdb_catalog.hdb_schema_notifications OWNER TO postgres;

--
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO postgres;

--
-- Name: cargos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cargos (
    id uuid NOT NULL,
    nome text NOT NULL
);


ALTER TABLE public.cargos OWNER TO postgres;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    nome text NOT NULL,
    cpf text NOT NULL,
    cidade text NOT NULL,
    bairro text NOT NULL,
    estado text NOT NULL,
    nascimento date NOT NULL
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: colaboradores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.colaboradores (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    nome text NOT NULL,
    cpf text NOT NULL,
    cargo uuid NOT NULL,
    status boolean DEFAULT true NOT NULL,
    admissao date DEFAULT now() NOT NULL,
    demissao date
);


ALTER TABLE public.colaboradores OWNER TO postgres;

--
-- Name: fornecedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fornecedores (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    nome text NOT NULL,
    cnpj text NOT NULL
);


ALTER TABLE public.fornecedores OWNER TO postgres;

--
-- Name: fornecedores_produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fornecedores_produtos (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    produto uuid NOT NULL,
    quantidade integer NOT NULL,
    preco numeric NOT NULL,
    nota_fiscal text
);


ALTER TABLE public.fornecedores_produtos OWNER TO postgres;

--
-- Name: notas_fiscais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notas_fiscais (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    codigo text NOT NULL
);


ALTER TABLE public.notas_fiscais OWNER TO postgres;

--
-- Name: pedido_produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido_produtos (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    produto uuid NOT NULL,
    quantidade integer NOT NULL,
    pedido uuid NOT NULL,
    nota_fiscal text
);


ALTER TABLE public.pedido_produtos OWNER TO postgres;

--
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    colaborador uuid NOT NULL,
    cliente uuid NOT NULL,
    data date DEFAULT now() NOT NULL,
    forma_de_pagamento text NOT NULL
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- Name: produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    nome text NOT NULL,
    preco numeric NOT NULL,
    quantidade integer NOT NULL
);


ALTER TABLE public.produtos OWNER TO postgres;

--
-- Data for Name: hdb_action_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_action_log (id, action_name, input_payload, request_headers, session_variables, response_payload, errors, created_at, response_received_at, status) FROM stdin;
\.


--
-- Data for Name: hdb_cron_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: hdb_cron_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_events (id, trigger_name, scheduled_time, status, tries, created_at, next_retry_at) FROM stdin;
\.


--
-- Data for Name: hdb_metadata; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_metadata (id, metadata, resource_version) FROM stdin;
1	{"sources":[{"kind":"postgres","name":"datawarehouse","tables":[{"table":{"schema":"public","name":"cargos"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"cargo","table":{"schema":"public","name":"colaboradores"}}},"name":"colaboradores"}]},{"table":{"schema":"public","name":"clientes"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"cliente","table":{"schema":"public","name":"pedidos"}}},"name":"pedidos"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"cargo"},"name":"cargoByCargo"}],"table":{"schema":"public","name":"colaboradores"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"colaborador","table":{"schema":"public","name":"pedidos"}}},"name":"pedidos"}]},{"table":{"schema":"public","name":"fornecedores"}},{"object_relationships":[{"using":{"foreign_key_constraint_on":"produto"},"name":"produtoByProduto"}],"table":{"schema":"public","name":"fornecedores_produtos"}},{"table":{"schema":"public","name":"notas_fiscais"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"nota_fiscal","table":{"schema":"public","name":"pedido_produtos"}}},"name":"pedido_produtos"}]},{"object_relationships":[{"using":{"foreign_key_constraint_on":"nota_fiscal"},"name":"notas_fiscal"},{"using":{"foreign_key_constraint_on":"pedido"},"name":"pedidoByPedido"},{"using":{"foreign_key_constraint_on":"produto"},"name":"produtoByProduto"}],"table":{"schema":"public","name":"pedido_produtos"}},{"object_relationships":[{"using":{"foreign_key_constraint_on":"cliente"},"name":"clienteByCliente"},{"using":{"foreign_key_constraint_on":"colaborador"},"name":"colaboradore"}],"table":{"schema":"public","name":"pedidos"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"pedido","table":{"schema":"public","name":"pedido_produtos"}}},"name":"pedidoProdutosByPedido"}]},{"table":{"schema":"public","name":"produtos"},"array_relationships":[{"using":{"foreign_key_constraint_on":{"column":"produto","table":{"schema":"public","name":"fornecedores_produtos"}}},"name":"fornecedores_produtos"},{"using":{"foreign_key_constraint_on":{"column":"produto","table":{"schema":"public","name":"pedido_produtos"}}},"name":"pedido_produtos"}]}],"configuration":{"connection_info":{"use_prepared_statements":false,"database_url":"postgresql://postgres:postgrespassword@postgres:5432/postgres","isolation_level":"read-committed"}}}],"version":3}	25
\.


--
-- Data for Name: hdb_scheduled_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: hdb_scheduled_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_events (id, webhook_conf, scheduled_time, retry_conf, payload, header_conf, status, tries, created_at, next_retry_at, comment) FROM stdin;
\.


--
-- Data for Name: hdb_schema_notifications; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_schema_notifications (id, notification, resource_version, instance_id, updated_at) FROM stdin;
1	{"metadata":false,"remote_schemas":[],"sources":[]}	25	7315b324-55dd-4756-974b-d53b139c67f4	2022-06-02 13:23:46.086406+00
\.


--
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state) FROM stdin;
a388fd8a-3c98-45aa-861d-f554262216a0	47	2022-06-02 13:22:51.982111+00	{}	{"console_notifications": {"admin": {"date": null, "read": [], "showBadge": true}}, "telemetryNotificationShown": true}
\.


--
-- Data for Name: cargos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cargos (id, nome) FROM stdin;
28ac32da-25a2-4b07-9aef-a0e6a74ef833	junior
84ce6a17-d6d9-4607-9651-91619dc462a0	prime
d4ae6c0f-af77-4469-b4a8-05a7fa8aa2b3	frequent
fadf5a72-11d0-4035-9004-7dd32d0b40b0	proud
6411ef6f-4857-4573-bf11-88b14fd0986d	grumpy
2cc6ce45-9ec6-412b-8297-d6a525489ade	upright
53ac6481-f275-498f-a694-f886aa259e60	shabby
d68523cd-57a6-4b5c-8e53-b028f07ac8cf	adored
ecb2f8d5-818f-403a-ad5e-2569d100e285	querulous
498ec746-d278-4202-9e44-3b4a17dd7161	somber
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id, nome, cpf, cidade, bairro, estado, nascimento) FROM stdin;
17b251a0-60c5-4266-9a74-758ec7456b76	Roberto Silva	98724969663	North Little Rock	Arábia Saudita	Distrito Federal	2018-05-02
47120db6-cd69-42dd-bd8d-9156edc5fce2	Mariana Carvalho	02289979551	Macon-Bibb County	Senegal	Goiás	2020-05-25
ad6a7a16-bbba-4f37-aed9-0007f8d65a30	Manuela Martins	82380711948	Waterbury	Granada	Ceará	1990-02-11
61cc8c91-1b13-49c3-9e60-1fe958d56046	Srta. Liz Macedo	76740857815	Asheville	Argentina	Ceará	2002-02-23
6b805a6a-c6c9-44bd-b3bc-fad0c57b40df	Joaquim Carvalho Jr.	99873527469	Glendora	Jersey	Goiás	1981-03-11
10c00a71-9722-41ba-9741-8e2ce313e694	Lucas Franco	12240411623	North Port	Ilha do Natal	Sergipe	1996-08-06
4c83370d-801e-4365-bf6a-6eb41f9f59b7	Nataniel Silva	47366513019	Delano	Azerbaijão	Sergipe	1998-11-26
80e0596e-c1be-46f7-a98f-82cedc30603c	Noah Reis	62096850186	National City	Haiti	Alagoas	2014-06-03
621eb458-a25a-4d13-b0c4-d9a6638f423f	Pablo Carvalho	70276767050	Huntington	Moçambique	Mato Grosso do Sul	1998-08-20
ab0dde2c-cb73-4f53-841c-05e6e2cfd7a8	Maria Eduarda Moreira	88978841471	Gastonia	Serra Leoa	Roraima	2000-08-10
2d27e551-1806-41c5-b6a2-a3cd2c95a7a2	Caio Braga	35276903187	Oshkosh	Islândia	Santa Catarina	2004-07-01
5f34f2ab-b66c-4d8b-b76a-d02ae292f3ed	Ofélia Oliveira	20725437741	Decatur	Honduras	Rondônia	2010-01-10
9ff2e1ad-d2aa-45c3-873b-4f558ecbf005	Giovanna Silva	27565275992	Joliet	Maldives	Mato Grosso do Sul	1983-01-15
b7f80e32-29c4-496d-8e53-ee01487a2baf	Melissa Moreira	39397746544	Potomac	Ruanda	Rondônia	1984-05-25
5a282a32-305c-4c6e-a5e3-a50a0ebdd044	Dra. Marcela Melo	39680843328	Elgin	Turcomenistão	Maranhão	2007-12-19
7872f67e-6a7a-4e3a-a51f-e80a6e23e62e	Sra. Fábio Saraiva	10724121658	La Crosse	Libéria	Mato Grosso do Sul	1994-05-28
9313e117-e925-4bdc-9e74-0909527acd7b	Calebe Martins	60294294637	Smyrna	Sérvia	Pernambuco	2011-07-06
6c3a8abe-f442-4f61-acc1-11c8b17c0bbb	Vitória Moreira	63582562073	Missoula	Suécia	Rio Grande do Norte	1970-11-03
20b3431d-c933-4df3-839a-68f6aaa34698	Isabel Xavier	46262134266	Wheaton	Quênia	São Paulo	1978-09-08
051c2458-8d63-4a77-b278-7c73a3f6a6e4	Dr. Roberto Santos	54918645694	Kenosha	Groelândia	Piauí	2014-01-27
247b6086-7cee-45b8-9437-04425a53aabe	Hugo Souza	67427891611	Torrance	Quirguistão	Mato Grosso	1984-02-15
954ba6a3-c092-42ca-99e4-18fda4ae3fe8	Mariana Silva	55187998199	Grand Island	Vanuatu	Alagoas	2002-11-10
bc94d5cc-e04a-492f-a5d6-978a52fd9924	Srta. Ofélia Silva	47961666241	Southaven	Afeganistão	São Paulo	2000-07-04
085aefdc-91dc-496e-8fd7-71ef2405c8dd	Alessandra Costa Neto	04111202504	Irvine	Território da Palestina	Minas Gerais	2017-05-01
10bc058c-7383-4ce2-9d09-748efc2b1200	Dra. Beatriz Carvalho	90225823766	Tigard	República Tcheca	Pará	2013-03-22
c6e1fb74-b946-4fdf-81ea-f5c30992a4ed	Joana Albuquerque Neto	06178303011	Waterloo	Anguila	Goiás	2014-02-11
5dbf08b2-f814-44a4-b62d-efdfbaf373c4	Ígor Saraiva	12224256559	Somerville	Reino Unido	Bahia	1991-06-01
72a5325b-3a95-4274-a759-4c474826d7da	Deneval Costa	16139504575	Manchester	Barém	Minas Gerais	1993-01-13
bc50edf9-6c9f-4de7-9c06-226ca8b952c3	Maria Luiza Martins	84070042600	Plainfield	Burkina Faso	Alagoas	1997-09-21
da792bc4-f4d5-420d-8c43-a1368a622cc8	Dr. Benício Souza	89633427710	Middletown	Trinidad e Tobago	Tocantins	2003-08-09
e352f0c4-ca98-4948-94fd-3b2bde4f58a4	Roberta Carvalho	58155839375	Brookline	Benin	Rondônia	1994-04-04
01b9b889-899e-462e-9627-025de4a0771f	Leonardo Pereira	13939142147	Grand Prairie	Botsuana	Rio Grande do Norte	2021-03-18
e19172bc-741f-489d-89f0-2f3be153aa33	Clara Albuquerque	35008691649	Wilson	Eslováquia	Paraíba	2011-03-29
3032ffc1-409a-4df4-bdad-cd806298be4e	Rebeca Braga	39173043386	Thousand Oaks	Marianas Setentrionais	Sergipe	2017-04-03
d2105620-93fc-4fd5-8d24-10c0b35b96ca	Vicente Barros	91342461479	Lawrence	Costa do Marfim	Paraná	2010-01-04
a6d877b7-e401-4abe-aa9d-f1f19b1806c3	Alícia Albuquerque	96005231037	Jackson	Ilha Bouvet	Rio Grande do Norte	2009-12-11
8bb811f8-a04a-47b3-ab5f-544f32c1e5fb	Márcia Carvalho	43349107610	Margate	Fiji	Sergipe	2001-10-22
1f34bf0a-0dcc-4d4c-a736-f850c7115ead	Murilo Franco	31742691850	Glen Burnie	México	Santa Catarina	2016-08-04
0bf35bb3-3f57-4f28-af1f-a23c60cb6d69	Hélio Moraes Filho	45149677457	Hicksville	Quirguistão	Distrito Federal	2008-03-23
52942ddd-8146-4a38-9126-e9f2e0bcca09	Tertuliano Albuquerque	92555055922	Fort Worth	Sérvia	Espírito Santo	2015-11-04
c99cfb92-8f6a-49ec-9eab-3d4eb901e1f1	Mariana Pereira	38300977172	Danville	São Bartolomeu	Pernambuco	2006-09-06
c6a75c9b-f5ce-4989-96ef-a0fde789da0c	Isaac Carvalho	54487274098	Antelope	Finlândia	Rio de Janeiro	2014-06-29
5ec7f900-4706-4cb0-8349-440c8b19c53f	Carla Souza	72500588636	Victorville	Nova Caledonia	Santa Catarina	2013-08-09
4c3aba82-67fb-46af-9fdc-b2949afd7346	Heloísa Carvalho	36606606357	Urbana	Uruguai	Roraima	2003-03-11
4f234a08-e9b4-41f0-b261-8c3bf8644e56	Júlio César Pereira	70310113929	Kearny	Mongólia	Bahia	1988-02-05
9c891b87-8ffd-4cf1-9b5d-73ec0bec351e	Enzo Gabriel Braga	78166573364	Elkhart	Cuba	Amapá	1984-05-15
0e68db40-5208-4c58-8562-450cacb77889	Dra. Enzo Gabriel Albuquerque	27337174854	Hanford	Chade	Amapá	1980-11-25
5622c27b-11c7-4c75-9fe9-1e31c189e08d	Paulo Carvalho	38188639121	Appleton	Armênia	Santa Catarina	1984-03-09
46e06ee9-3ebf-470b-a240-a1d2c8d683e9	Márcia Martins	62899653196	Monroe	Turcomenistão	Paraná	2017-05-30
48545604-5198-473a-b4e4-46ff370ce639	Sophia Carvalho	30377860453	Lawton	Ruanda	São Paulo	2012-09-25
931f40d5-1249-4e2a-9089-9b85a9bf45a4	Sra. Rafael Franco	99476585175	Westfield	Maldives	Roraima	2017-12-01
b9821dc9-b7e2-496b-96d4-1691c60504c5	Ana Clara Macedo Neto	97346175781	Altadena	Nigéria	Alagoas	2005-01-08
d324f829-082c-4038-8c6e-132c793a4304	Frederico Nogueira	14231561777	Colton	Hungria	Rio de Janeiro	1993-11-29
5001c241-3842-4535-a04d-6c3fec3baa9c	Pedro Reis	63359442575	Mesquite	Ilhas Cook	Paraná	1983-10-24
fd34ac46-51e6-4c4b-a984-a0d7e6f21621	Heloísa Barros	38662680731	Orlando	Ilhas Cocos	Alagoas	2000-01-08
dcb03a64-a9f5-496b-a0ec-86d566a71864	Vitor Macedo Filho	90782230791	Pembroke Pines	Fiji	Pará	2012-01-16
264d6c24-f6c9-4acb-af2d-da879ece7f1a	Pablo Costa	77444461438	Gary	Bahamas	Distrito Federal	1983-10-01
7fc2da37-83b9-437b-8e25-a51cdc79172e	Yago Nogueira	02367386823	Reno	Ilha do Natal	Piauí	1998-10-23
f8bc69c1-8d7b-47ea-af2d-8a0f893147dd	Srta. Kléber Batista	30640441489	Tyler	Austrália	Pará	1992-06-13
6b4fe4bb-78fd-4684-8333-0cc8969cb590	Murilo Oliveira	74502930892	Buckeye	Groelândia	Mato Grosso	2013-03-18
ef36e0b6-c6be-4867-8aee-7ab42b70fded	Norberto Carvalho Filho	12184918098	Aliso Viejo	Mauritânia	Bahia	2012-09-08
e96920f8-5146-4e99-9969-67cbadcacb60	Murilo Albuquerque	49526517402	New York	Camboja	Mato Grosso	2014-09-05
9b4ca654-1be6-461a-919d-bfec1e6cd57b	Deneval Silva	35002341171	Santa Barbara	Chile	Pará	2015-07-07
ce97865f-ac8f-4287-a81b-c1b026502a19	Sra. Miguel Macedo	47731815301	Laredo	Wallis e Futuna	Santa Catarina	2001-04-29
1b831e5d-c546-402b-a211-6e9d81decd7a	Marcos Carvalho Filho	88490782327	Springfield	Ruanda	Mato Grosso	1973-11-10
4815e1fa-e036-4fe2-9452-002bd30d8974	Suélen Reis	87167871301	Idaho Falls	Papua-Nova Guiné	Sergipe	1985-09-27
9dda8b30-cf1d-4d9d-86b3-b6d16e560795	Ana Clara Costa	83936133923	Wesley Chapel	Suécia	Alagoas	1999-09-02
c9e0f823-b956-4105-abb4-ef6cf0103384	Fabrício Martins Jr.	92490411276	Pico Rivera	Trinidad e Tobago	Rio de Janeiro	1995-12-01
310bc8aa-a3bd-43bc-b82e-c75a1ae49d0e	Bernardo Martins	00290393031	South Valley	Burkina Faso	Alagoas	2015-05-15
7ad3af01-a266-4e3f-a40c-f17edb0a73fa	Meire Oliveira	28317281006	Salinas	Colômbia	Alagoas	2012-12-20
7a09fda7-8394-40be-b6ec-7394fb618e1c	Aline Martins	64797711316	Gardena	Nepal	Minas Gerais	1988-02-08
b33bc7a1-f27b-4e33-b869-4b6887ac47e2	Sra. Noah Pereira	12887033328	Passaic	Niue	Maranhão	2004-11-15
27092f21-6b3a-4d2d-9da9-88c1a247cc3f	Pedro Henrique Moraes	17393231622	Port St. Lucie	Iraque	Minas Gerais	2006-07-29
cf6264de-30ac-4d6e-b374-a3c845e48fcf	Cecília Silva	99527558690	Lauderhill	Colômbia	Pernambuco	1994-06-20
6d971123-cbe8-4a89-abd8-4a46e72179b7	Isabel Saraiva	20752105652	Newton	Panamá	Goiás	2010-09-19
730780ad-2e2b-4232-b3b8-ce460e709b53	Meire Barros	57360223513	Lubbock	Estados Unidos das Ilhas Virgens	Distrito Federal	2000-07-28
a6352d87-de80-4cee-9819-75645122d110	Dr. Maria Helena Macedo	94079862917	Colton	Suécia	Rio Grande do Sul	2013-11-17
db70e291-234a-46ca-86d7-1bbaebe0e917	Víctor Nogueira	17103648934	Westminster	Lesoto	Amapá	2020-01-10
ff317258-14af-4c15-8977-f7a8e042722d	Alícia Costa	54663122587	Suffolk	Santa Lúcia	São Paulo	2008-12-27
d9ff1e25-adc7-4755-89fa-6b96b5349260	Enzo Moreira	29572118242	Midwest City	Zâmbia	Sergipe	2012-04-27
6d595c01-c94b-4190-b6cc-1f27f94d896c	Enzo Moreira	28009562922	Sacramento	Venezuela	São Paulo	2021-12-28
0e2c389f-03cf-45be-b8d6-a60a09b04d5b	Deneval Carvalho	46819885571	Chino Hills	Bangladesh	Piauí	2011-12-04
a12fcbeb-e4bb-4b6b-b811-74242c0ef680	Pietro Batista	94661877639	Roanoke	Niue	Paraná	2008-03-14
95ee393c-f317-4747-a4d3-8739e0bf7ad3	Manuela Nogueira Jr.	11518252648	El Paso	Índia	Pará	2010-02-12
b0bd253e-359a-4c68-9a07-a63e04ed45e9	Maria Saraiva	40029170596	Commerce City	Coreia do Norte	Amazonas	1999-10-14
f899744c-5a1d-4248-8ff0-2b015beebc44	Suélen Santos	97217216821	Mesa	Antigua and Barbada	Mato Grosso do Sul	2000-10-31
68b4def4-ad4f-49ee-b5b1-7555cff37ead	Helena Moraes	49488852663	Milford	Bélgica	Ceará	2005-10-21
956ba841-cd3d-40e1-a532-a3e067804a8a	Lívia Braga	29606395799	Modesto	Costa do Marfim	Santa Catarina	2004-11-10
689b4278-71f4-4150-9fa6-08ea91d0f89a	Alícia Albuquerque	93550268514	Centreville	Panamá	Paraná	2014-01-09
3047eea0-8c8e-45c0-a30f-f1a6a4f63f92	Bernardo Braga	92291140328	Cary	Camarões	Sergipe	1987-09-13
752bbf72-bfae-40e1-90cc-5dd4092fcb85	Srta. Marcela Silva	91100378840	Beaverton	Antilhas Holandesas	Amapá	2018-07-01
78374a7a-f58c-4883-9999-c4416235c469	Raul Barros	52696620637	Mansfield	Ilha de Man	Rio Grande do Norte	2017-02-17
729c44ff-7a2a-4812-b051-dec4353feef2	Suélen Franco	76803361721	Cutler Bay	Papua-Nova Guiné	Rio de Janeiro	2022-05-24
6859e602-94fa-4723-82c3-aa6e3e59304b	Marcelo Carvalho	22083113791	Lawrence	Reino Unido	Alagoas	1970-03-02
3f15e143-64c9-46b9-94c2-d8d6ee0ae30f	Ladislau Macedo	83870963671	Sterling Heights	Líbia	Acre	2019-12-20
a102394d-feaa-4649-9f13-f6437b889498	Joaquim Batista	40205966202	Bell Gardens	Mali	Roraima	1992-03-24
781f4834-fdea-4801-bd5d-450ed3b674dd	Sarah Reis	85217685973	Appleton	Botsuana	Mato Grosso	1992-07-04
602c1616-8434-4932-b11e-c15b095de294	Elísio Macedo	27453696941	El Centro	São Martinho	Roraima	2019-11-14
a13e1f68-126d-4c0c-8229-14154cdbb732	Sarah Franco Neto	58771024451	Gardena	Dominica	São Paulo	1999-01-09
135c49f9-0217-40fa-b293-5d023a86883e	César Batista	74145025584	Costa Mesa	Albânia	Minas Gerais	2004-07-17
\.


--
-- Data for Name: colaboradores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.colaboradores (id, nome, cpf, cargo, status, admissao, demissao) FROM stdin;
790cc03c-b604-4434-a557-4067e629ddcb	João Lucas Santos Neto	08925228448	84ce6a17-d6d9-4607-9651-91619dc462a0	t	2021-09-07	\N
6459a1c7-3597-4913-b609-78a486cc6eaf	Caio Macedo	91221692587	2cc6ce45-9ec6-412b-8297-d6a525489ade	t	2021-09-20	\N
f7c5a0e6-2119-4384-ad53-05ce575fbb8e	Sarah Braga Jr.	92798849069	d68523cd-57a6-4b5c-8e53-b028f07ac8cf	f	2021-10-11	\N
0a7fc057-6228-48e5-b8b6-0ab506e95daf	Maria Júlia Albuquerque	17415182804	d68523cd-57a6-4b5c-8e53-b028f07ac8cf	f	2022-01-13	\N
dbe13d81-9406-4366-8393-e4231f5cf0ee	Maitê Braga	23602455842	2cc6ce45-9ec6-412b-8297-d6a525489ade	t	2022-04-03	2022-06-03
4469a8ac-0571-43c6-848c-79a80a7bce54	Fabrícia Macedo	16714674618	ecb2f8d5-818f-403a-ad5e-2569d100e285	f	2022-04-01	2022-06-03
65a174cb-85ac-4bc0-814c-949d25dbc102	Maria Helena Santos	88339249352	2cc6ce45-9ec6-412b-8297-d6a525489ade	t	2022-01-26	\N
4ee6da58-4efe-45d6-baf6-8c2dc9694198	Marcela Carvalho	25149371909	84ce6a17-d6d9-4607-9651-91619dc462a0	t	2021-10-02	\N
64759455-3541-4724-8a45-0bc0375127d2	Júlio César Pereira Neto	10235562721	498ec746-d278-4202-9e44-3b4a17dd7161	f	2022-03-09	\N
335ba014-e0bd-4de8-991f-d30508bd11f0	Aline Oliveira Neto	10577773331	53ac6481-f275-498f-a694-f886aa259e60	f	2021-08-14	2022-06-03
\.


--
-- Data for Name: fornecedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fornecedores (id, nome, cnpj) FROM stdin;
c89ac0c4-17cf-439b-9684-ee6b52f0c2de	Batista - Franco	671851510001
12fbb69f-e1a6-424a-b006-29a7d1f9df9a	Moreira, Moraes and Batista	319055750001
06e1dbea-cb85-4615-908f-d072fc198c88	Saraiva e Associados	180958650001
200859e8-5cc6-4e01-81ec-8d0f65427503	Oliveira, Albuquerque and Moreira	363787590001
605ca755-98c2-4e68-a654-eb5bed5e7450	Carvalho, Macedo and Nogueira	401858550001
\.


--
-- Data for Name: fornecedores_produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fornecedores_produtos (id, produto, quantidade, preco, nota_fiscal) FROM stdin;
39b6abb9-4789-4a07-8032-e2dc2915162c	338a32a1-4c5b-4c6b-8372-85666ac4e146	307	821.7100000000000	4068
4a619072-211f-45dc-a2fb-efe1e480b7f7	217e2dc3-3bb1-467c-bbac-f3ab12d34643	73	166.4300000000000	4068
5568033b-8bed-4766-bb43-1f03eed03c0a	2d921a66-c936-4378-a449-8f140236dabb	674	705.2800000000000	4068
a5108cb6-0245-431b-bdfb-d7d7238a701e	1786adb7-0937-42f1-86ae-c75470bd3a40	396	727.4700000000000	391
bc44926f-51d1-41ee-85b4-ae784ab38980	8e109261-0912-45cd-b8a6-98061c64184b	161	914.1500000000000	391
a6ed89f4-3b33-4869-9226-d2880fb3bc7a	338a32a1-4c5b-4c6b-8372-85666ac4e146	535	915.5400000000000	391
924cd924-3e4d-4fe2-acae-faebdf3b57cf	7b7fa4d8-0f93-4fa3-931b-0c2ce415efba	466	957.9200000000000	4764
c009e4c1-f3c7-4631-9e7e-853ac1986227	9d3079ab-898c-4c42-9dd7-68fda1765d59	454	194.2200000000000	4764
27fb10e8-d207-42f6-8eee-70b2eb35b906	967903cf-d027-4b6d-b6fd-86d37641be3a	748	58.47000000000000	4764
f77fb280-fc27-46fe-a3a5-070c6051961b	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	250	326.2300000000000	2307
73e28b40-2b5b-4a81-ba53-d2b6dea7478b	1786adb7-0937-42f1-86ae-c75470bd3a40	853	183.2500000000000	2307
695284e6-9c88-46e6-966d-315614d4ca6b	83468d4e-43e9-4437-8834-db7aa5018b9b	629	573.3500000000000	2307
a7ccef78-aa69-44db-920a-c6642aec8138	294b0fda-5fed-4231-80ca-dfba0a571b98	420	308.4100000000000	4758
35888de9-ad17-413b-8eb4-7bdc2336ac14	21a71512-a944-4f15-aa7c-d7ac03cfba07	293	569.3500000000000	4758
4792c869-9376-4563-959b-a6a3977e3338	29c9fe62-4313-4803-88bf-baa4c3316e54	167	16.35000000000000	4758
2d42dac7-52aa-4457-92f3-fc7feca2efff	7b7fa4d8-0f93-4fa3-931b-0c2ce415efba	682	988.8700000000000	3938
ca6d35a7-06b4-4330-8832-8c270875c59f	0083efd3-7ca7-4e9a-b111-a409df5007e8	696	304.5000000000000	3938
5c4ba3d9-5c7c-4480-9a4c-e573cf3e1c4c	29c9fe62-4313-4803-88bf-baa4c3316e54	400	770.1600000000000	3938
49d926c2-d7e5-4b44-8bfb-876b6b96a86d	338a32a1-4c5b-4c6b-8372-85666ac4e146	930	396.7300000000000	1041
3b50fdc1-3594-430e-b6ff-62da2a60b220	6c80eb2e-d281-4e9d-b72a-79c0a53dd8ee	970	404.0400000000000	1041
863cdc08-81a8-44d6-ae5b-e0f4c9dbe4e1	517756e6-eaf3-4114-b615-655bc62ea1ec	613	673.0500000000000	1041
a3132c6d-1ea3-4fb3-9a10-fb7f96bc8fed	21a71512-a944-4f15-aa7c-d7ac03cfba07	569	652.9900000000000	1396
4c6de89c-421e-4b00-afe6-e99a8d93ef4c	863b0cce-cfdf-4560-b3ff-8e64b149a404	756	421.7700000000000	1396
804784dc-f7e4-47e9-b48b-251dcbe8512d	780163c4-f3e7-41c6-a057-7f9196397564	609	611.6300000000000	1396
2d24c0a1-5fc9-4109-8cb3-24b1283d6d95	7b7fa4d8-0f93-4fa3-931b-0c2ce415efba	82	895	3629
b50e9252-1cd3-4b79-badf-ea02daade3d0	23890f27-e1cf-46ee-9ce0-f99166bb1223	156	589.7900000000000	3629
1e48fcb2-ef77-4b33-946b-67e0c6ea3481	967903cf-d027-4b6d-b6fd-86d37641be3a	105	201.5400000000000	3629
4d659223-6e36-42cd-b141-3e2a152fc7cb	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	332	456.7400000000000	1415
0bbb853a-900c-4778-9293-f9fb20731dc0	f07720ad-c599-4de8-bb25-bf77751077bd	589	407.9600000000000	1415
90685a1d-0ee7-4e9a-9dc1-bc5564a5565b	23890f27-e1cf-46ee-9ce0-f99166bb1223	106	114.8200000000000	1415
2057b0ab-3847-4b44-a698-25806783bf83	4606aa38-17e9-4e73-a59a-6e4a844addd4	247	842.7800000000000	3696
68c080aa-f69d-4fce-8b19-07dbf57cb9d9	29c9fe62-4313-4803-88bf-baa4c3316e54	653	25.18000000000000	3696
47896792-8a6a-4900-bad3-1bcfeb46d6ee	863b0cce-cfdf-4560-b3ff-8e64b149a404	319	528.4900000000000	3696
68cbc3ca-dc04-4954-a555-aba00f38badb	217e2dc3-3bb1-467c-bbac-f3ab12d34643	544	856.6000000000000	854
d71e9097-617f-47a5-8a40-b0b1402ea6ee	d4481b4a-13af-4937-8dc3-37665c13923f	501	895.7600000000000	854
b84f1f7a-1f85-4970-833e-dbce31f62c6e	7f29cbf3-81c8-4d3a-afa1-6ac7ec06a8cf	691	714.8900000000000	854
d45c50c8-d80e-4b88-8039-2c581f3e0006	d20b3701-e48f-481a-a997-6d3aade8c37a	416	435.2900000000000	815
6fcf7b40-152c-4e55-9d4e-2661a82793a7	338a32a1-4c5b-4c6b-8372-85666ac4e146	795	576.0900000000000	815
08a1bf90-179f-4acf-9038-376e0620b7b3	29c9fe62-4313-4803-88bf-baa4c3316e54	174	589.0300000000000	815
9420d1df-acd1-43a1-9a3e-60079d232535	21a71512-a944-4f15-aa7c-d7ac03cfba07	86	279.6000000000000	1873
365f93c6-d8d8-4742-b1fa-b37a39afb92b	2a6d46d7-40e8-4f85-9a37-16b20c130a65	296	107.7700000000000	1873
69b93a4b-a3ba-4b24-b910-896a0a3c32fe	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	586	125.6500000000000	1873
8b92757a-482d-4428-8062-474f97ed1d86	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	418	51.49000000000000	3548
b69f95cb-ab47-4b4a-be94-d5ed3f16fd83	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	6	785.9500000000000	3548
6b245e57-26be-4da9-ad67-a09030339ac7	a5d284fd-5782-49a0-8b40-a9f3921deb5a	101	432.9100000000000	3548
0c535f2d-d0b7-4980-9e5d-93f52e0863b8	780163c4-f3e7-41c6-a057-7f9196397564	598	445.6500000000000	2184
0259ab85-dc76-4ec6-9f65-4605e4305879	780163c4-f3e7-41c6-a057-7f9196397564	920	335.1600000000000	2184
dabbe5e6-483d-4486-9b08-8e3fbad3482a	967903cf-d027-4b6d-b6fd-86d37641be3a	279	23.67000000000000	2184
5d045041-148f-4ef4-8976-17e7cba2c212	3c2d8349-210b-457d-a192-6eb1c1db51b9	923	257.6500000000000	872
1541d22f-f702-4295-b296-b1e2fc9277ad	72b4e40c-51b3-4659-9b2c-eb83e441f894	145	154.0600000000000	872
3b1a6c6a-51e0-405d-92b3-99da67b36706	6c80eb2e-d281-4e9d-b72a-79c0a53dd8ee	368	160.6600000000000	872
a723fef2-64c2-42ca-a704-64a48b335d64	7a27d612-f785-43f2-89cc-8fa890bea08c	837	79.50000000000000	2467
9c75217d-04e3-4fd9-8bf2-af333d30c659	3c2d8349-210b-457d-a192-6eb1c1db51b9	920	616.5100000000000	2467
19840d7f-26bd-49bc-9509-ba2a988b27bc	2a6d46d7-40e8-4f85-9a37-16b20c130a65	660	940.7200000000000	2467
5402274a-0e11-40b2-9d18-e4822b22a0a0	967903cf-d027-4b6d-b6fd-86d37641be3a	25	110.9000000000000	4991
c3674e71-6ac8-437d-91dd-567e8d80aeef	4fd3230c-d3a4-429c-9957-d7c84e1f3292	401	638.2400000000000	4991
9adf4a08-ee9f-496d-9375-9afb45a96fd4	0083efd3-7ca7-4e9a-b111-a409df5007e8	882	55.67000000000000	4991
e1114c86-13c0-4cb8-aee4-893139359b82	4fd3230c-d3a4-429c-9957-d7c84e1f3292	835	43.73000000000000	1213
f035f3f0-2ae6-4a87-b924-ac96bd1ba847	3c2d8349-210b-457d-a192-6eb1c1db51b9	894	760.7000000000000	1213
f846337d-518a-4614-8d27-f44500a0f694	4bff65e1-8efe-4108-8d02-3a1eab053da6	990	779.9800000000000	1213
22980b5b-91ed-48bb-9f9c-b82168eea419	9a4048f4-aac4-45b1-9240-124f1f7b94e7	996	754.3000000000000	57
4ce6f900-94e9-4ba4-bda0-ec552705737f	4606aa38-17e9-4e73-a59a-6e4a844addd4	503	225.0300000000000	57
9ea2ae58-1554-4b30-ad79-fd9641b3ff60	7369d544-ddfb-4421-b82b-6ea75aebf40a	984	91.04000000000001	57
4045e450-1e9c-48f3-afdc-7973170aa847	0571223e-25ab-4d0b-afbd-011301ae7689	337	818.7900000000000	1569
f2406098-3a99-42d0-a682-217207bcf4b4	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	520	181.1100000000000	1569
78604361-89c9-4e2b-8862-50049605f813	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	737	345.5500000000000	1569
f7d7c0be-383b-48af-92af-0fb5953154e6	517756e6-eaf3-4114-b615-655bc62ea1ec	522	62.42000000000000	2870
ff84e21d-496b-48cb-b491-8b0075b00c53	262f548f-7607-4aec-9b98-eee3abce9fc7	46	760.3400000000000	2870
42c3c50c-c4dd-47b9-a611-dc59f2f9dbc2	a5d284fd-5782-49a0-8b40-a9f3921deb5a	946	958.9299999999999	2870
f0175caf-9df8-4b38-8bee-7bd067c0f97e	4b42afce-78f5-4000-a2e7-6fc1c6528ddc	942	743.8500000000000	2746
1dcb9863-4d63-4c30-b452-b6e338931c85	2d921a66-c936-4378-a449-8f140236dabb	3	29.72000000000000	2746
4db4032a-26ab-4afb-a0e8-eaf49a155aa1	2d921a66-c936-4378-a449-8f140236dabb	436	584.6000000000000	2746
f838f12b-e00f-4ba8-b581-c21e9e978e9c	9a4048f4-aac4-45b1-9240-124f1f7b94e7	75	258.6400000000000	4595
0d2cce74-f61f-4596-a08e-7dce2c33cdab	1786adb7-0937-42f1-86ae-c75470bd3a40	449	977.0300000000000	4595
f5797fe1-f5fe-4f4c-9f84-38ee956c5e1e	8cad58dc-1590-4149-8cdc-7edb7ac72fff	223	859.6900000000001	4595
27bc1426-278e-4e20-a7e0-7922e93e8a1f	8e109261-0912-45cd-b8a6-98061c64184b	845	11.39000000000000	3039
90383c3e-8c95-4ed4-b733-3f258be65a42	3c2d8349-210b-457d-a192-6eb1c1db51b9	817	167.8200000000000	3039
ef43fdd2-44a1-4787-9d53-2036969329d9	0571223e-25ab-4d0b-afbd-011301ae7689	169	814.3500000000000	3039
07f0532b-9504-411e-ba69-7a4c1559afe0	3c2d8349-210b-457d-a192-6eb1c1db51b9	162	474.5900000000000	747
ed19a6d0-dad6-4475-bcdb-961fe060ff5c	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	891	323.5600000000000	747
446e1c64-3278-4deb-90da-72d7988e76ee	4fd3230c-d3a4-429c-9957-d7c84e1f3292	129	239.4900000000000	747
87dd582b-5c56-4de0-9389-97407fb50d61	1786adb7-0937-42f1-86ae-c75470bd3a40	582	776.7100000000000	2375
4474d9df-1177-4e58-b900-c1ff06b24f55	294b0fda-5fed-4231-80ca-dfba0a571b98	465	854.4800000000000	2375
dc7f001b-d9a0-4aee-876c-7eeb1eddb9dc	b07fe039-7ef2-4298-be2c-312e5c2deb47	378	976.2700000000000	2375
85a494d6-0b12-4879-ac69-3c24971f6737	b07fe039-7ef2-4298-be2c-312e5c2deb47	396	645.4800000000000	4702
79dd697e-6dea-4662-a866-4772a0685838	294b0fda-5fed-4231-80ca-dfba0a571b98	828	913.6700000000000	4702
08f7cce1-6076-475c-a847-9c1929cd35c0	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	427	270.5900000000000	4702
ab1595e7-2034-419f-a687-f467d5e71c74	0083efd3-7ca7-4e9a-b111-a409df5007e8	31	886.2300000000000	1334
fdfb7c93-94fa-4dab-9e23-b6cdd6e1f503	23890f27-e1cf-46ee-9ce0-f99166bb1223	454	531.6799999999999	1334
c615095d-977a-4914-b4bd-5fa8399c06eb	5fce77eb-e8a9-4bed-9aa8-108078b3ab99	514	697.6900000000001	1334
b697dd5a-a971-4b56-ae82-4051bccaefac	3c2d8349-210b-457d-a192-6eb1c1db51b9	117	872.2900000000000	3198
a6c4e127-0348-4cbe-9412-aadcc8997044	338a32a1-4c5b-4c6b-8372-85666ac4e146	459	816.5599999999999	3198
4a27bbb6-e44e-45b5-9d26-469bc015b20a	1786adb7-0937-42f1-86ae-c75470bd3a40	202	401.1700000000000	3198
043555b2-088a-4ca3-8497-f931ff80daee	967903cf-d027-4b6d-b6fd-86d37641be3a	49	322.5800000000000	3529
ffbe5647-cb0d-4eee-aa09-5555c0a06beb	1786adb7-0937-42f1-86ae-c75470bd3a40	404	269.9800000000000	3529
d4a364fd-19a2-4bc9-ad62-8fa7a0fc9c04	0083efd3-7ca7-4e9a-b111-a409df5007e8	821	194.7200000000000	3529
0dfb3ff2-660f-44be-8315-79e3bfa0d063	0083efd3-7ca7-4e9a-b111-a409df5007e8	444	780.1600000000000	3450
16809305-1e55-425c-9ec0-88507c9dd687	863b0cce-cfdf-4560-b3ff-8e64b149a404	466	430.1500000000000	3450
3788fc0b-a583-475f-a3f7-7e0328cf2cf9	5fce77eb-e8a9-4bed-9aa8-108078b3ab99	856	303.9700000000000	3450
3e0129f1-81d0-46e2-b90e-fa94a2cfe27c	4606aa38-17e9-4e73-a59a-6e4a844addd4	760	882.2500000000000	3921
1623a0fa-f962-43eb-843f-e6f3489b4aa0	68a96b57-b52d-4739-8535-be3bb3231ee4	404	222.9600000000000	3921
96b4b57f-8474-47b0-930c-14bb5215799b	5fce77eb-e8a9-4bed-9aa8-108078b3ab99	502	259.8300000000000	3921
4a3e6330-32ad-40ce-9c85-9ee3449e384e	e2206d16-994a-4daa-a3c1-9d12d6314518	200	857.3000000000000	4726
24440c32-3b92-414d-babc-71e9e075acc9	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	665	80.95000000000000	4726
d7bc2d78-0495-4581-8f71-5b79a08822e8	21a71512-a944-4f15-aa7c-d7ac03cfba07	319	298.2700000000000	4726
420aab64-d4f4-4755-810f-d4068a1f6199	3c2d8349-210b-457d-a192-6eb1c1db51b9	506	502.0600000000000	3026
3a3cc194-ef20-4a15-98ca-72d64b056d75	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	254	163.2700000000000	3026
d28aed0d-b136-4bf7-afd4-65da68111f4d	2d921a66-c936-4378-a449-8f140236dabb	155	980.6500000000000	3026
65717b2f-b38e-44fa-a0d7-76cb54937867	4fd3230c-d3a4-429c-9957-d7c84e1f3292	339	318.1700000000000	2051
c546a862-81cf-4a97-bb87-9d7b45d474fe	8cad58dc-1590-4149-8cdc-7edb7ac72fff	521	247.2700000000000	2051
d325a97b-8f0d-4d91-bdd8-e83e4aba2325	7a27d612-f785-43f2-89cc-8fa890bea08c	857	502.5100000000000	2051
39c11804-bf0e-4bc2-a40f-65ccfb2d0a9e	f07720ad-c599-4de8-bb25-bf77751077bd	666	855.2700000000000	1124
e216add6-0b98-4136-be01-ab753030e2d6	68a96b57-b52d-4739-8535-be3bb3231ee4	441	876	1124
2e636db5-56e8-45d7-958d-e34ab8129737	338a32a1-4c5b-4c6b-8372-85666ac4e146	293	266.9400000000000	1124
f866df07-34d0-4ba7-b348-cf717af6894c	68a96b57-b52d-4739-8535-be3bb3231ee4	354	499.4600000000000	4404
8aa8d17b-f093-41f3-aa90-e6660821ca31	d4481b4a-13af-4937-8dc3-37665c13923f	99	772.7300000000000	4404
912496ca-dc79-4ad2-9dca-75326d1941f5	967903cf-d027-4b6d-b6fd-86d37641be3a	160	267.0600000000000	4404
7c5b56da-7267-403a-a9fb-dce70068b278	8cad58dc-1590-4149-8cdc-7edb7ac72fff	978	814.7500000000000	1859
838b840a-cf28-429a-a151-0399122e37c8	29c9fe62-4313-4803-88bf-baa4c3316e54	380	618.3099999999999	1859
a09d25f1-6ea2-4c5d-b28d-d3c7af034aea	9ccdb12c-2200-47d0-af16-13b54bce9914	1	722.1000000000000	1859
3c8abbbf-98b4-4d76-aea0-dde8d1927102	2a6d46d7-40e8-4f85-9a37-16b20c130a65	687	339.3300000000000	1979
d5865d6f-1f18-4fbc-8569-36d38872274b	7a27d612-f785-43f2-89cc-8fa890bea08c	619	372.9400000000000	1979
fc04647d-44dd-4197-b7ec-95a90a88f503	7f29cbf3-81c8-4d3a-afa1-6ac7ec06a8cf	990	401.4300000000000	1979
9cf73390-9c3b-4303-b5dd-e934faf9c495	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	995	995.5200000000000	3734
10d19c1f-80b0-4878-90ed-844c9c0a5c8b	23890f27-e1cf-46ee-9ce0-f99166bb1223	179	155.3900000000000	3734
e0e3c313-05fe-4ea9-87f0-5f18973ff295	863b0cce-cfdf-4560-b3ff-8e64b149a404	68	780.9800000000000	3734
b984a5c9-5518-4f45-bb0a-02c308eb65c1	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	465	161.2300000000000	1897
a5e6e16d-a78a-45f4-91dc-0b124c8abd2c	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	110	112.0400000000000	1897
862a035d-3da8-4e9f-85d8-4bf8f3a705e8	a5d284fd-5782-49a0-8b40-a9f3921deb5a	958	533.5800000000000	1897
a34fe0d4-1962-418f-b881-0b1f5d2b0eb7	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	285	169.2500000000000	1152
2f527d40-de1b-4a49-8ea0-0a8afe8e234a	9d3079ab-898c-4c42-9dd7-68fda1765d59	560	102.6500000000000	1152
d7e4775e-2879-48cb-92ff-73f623b7e4ce	2a6d46d7-40e8-4f85-9a37-16b20c130a65	2	42.57000000000000	1152
0a3426cd-1d7e-4f64-bf2b-946ab4eb41e8	68a96b57-b52d-4739-8535-be3bb3231ee4	804	134.7400000000000	1477
50fc35c1-6af4-4f73-999b-69497d745c28	217e2dc3-3bb1-467c-bbac-f3ab12d34643	493	986.2500000000000	1477
d4ffd4ea-7732-45db-ab8d-f6761e7b26e8	7a27d612-f785-43f2-89cc-8fa890bea08c	794	884.5500000000000	1477
5b4c8d60-65dd-46aa-9aba-7efcc6c7f74b	2d921a66-c936-4378-a449-8f140236dabb	838	413.1000000000000	13
fa87bef1-5478-49d5-912b-17173d88e15e	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	177	228.4000000000000	13
e5703112-77b1-4465-ba35-997665b0e223	338a32a1-4c5b-4c6b-8372-85666ac4e146	634	144.9700000000000	13
2f7ac749-81b9-4188-954a-c4e5950cc951	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	429	483.4100000000000	3353
a3538fb5-4e0a-4113-807f-87f43e18113e	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	115	116.9000000000000	3353
1da02289-8e0c-48b9-8962-eda409a0eb01	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	73	752.0100000000000	3353
693ee987-2405-40dd-b957-095c87800819	68a96b57-b52d-4739-8535-be3bb3231ee4	515	703.5300000000000	3724
18197ce8-12de-4aa7-8003-fb2951afc717	0083efd3-7ca7-4e9a-b111-a409df5007e8	630	835.6900000000001	3724
af213fb5-3287-4536-9a16-5eddba973085	d20b3701-e48f-481a-a997-6d3aade8c37a	970	999.2500000000000	3724
42c5cd77-0401-4c00-a8c1-ecb07f2877db	4bff65e1-8efe-4108-8d02-3a1eab053da6	665	811.4000000000000	3499
3d61a085-de84-4be2-bfe5-9bafbbeee220	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	794	460.7700000000000	3499
ff909ce3-7594-46ed-ba17-f0f056f34425	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	394	422.8600000000000	3499
e1920694-4a58-45fd-81ed-734f90a983e7	517756e6-eaf3-4114-b615-655bc62ea1ec	592	858.6799999999999	3675
748cbfde-d887-4688-81cc-9da93b647b8a	21a71512-a944-4f15-aa7c-d7ac03cfba07	299	927.5000000000000	3675
12ba7dcc-9a95-4f3c-8a64-5762cc73edb1	9d3079ab-898c-4c42-9dd7-68fda1765d59	21	591.8000000000000	3675
\.


--
-- Data for Name: notas_fiscais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notas_fiscais (id, codigo) FROM stdin;
591ffb47-dcfb-49e4-8c6c-02be3adbe3b4	1061
8188b38a-2825-4146-b65a-85d315ac0016	3285
08970cc8-756c-456b-b098-e02aa5b66662	3288
027c3f2e-d5fa-4216-9c81-922d67e9f49a	4161
4b5961b4-8116-43ee-9aef-ad2ac509b60f	1859
b8cdfa5f-f94f-4838-b86e-d8c7d3aea2db	1243
3d2fe070-3d1e-4fa2-a986-23259e41b9d5	2751
092b5f98-d74e-4dc0-911d-2ec335374582	854
f0accea2-ea19-43bb-b245-9a8696ac431e	4916
4e202da9-1587-49b6-a115-7131cd650f3c	1415
0fd6a3fe-458c-4981-93d2-b7decf092b4f	3811
69e5e0fc-8a52-422c-a2b5-ff9fd0f20374	751
e8a5d6ac-04b8-4d4d-990e-397fe30afa7f	1573
b1abae03-ca74-412a-8abe-5fb98dcf7748	3734
ce3cb8b7-ba0d-4be0-996e-a1adf7b15600	4758
c7a40471-424c-472e-a165-ac3ed52cea44	57
5c3c3b6c-33a5-4136-883e-2317352fb02e	953
9bb69869-911e-4cdd-a343-924bb89a726c	31
8894899d-4d22-490e-b3b9-eeec2f2f7cce	2730
eba331d9-1976-4616-b75f-023575e808b2	2331
da42d0ca-4ea1-4dc9-94d7-7505b2132650	1897
f21d54fe-6095-41b4-bd65-d2e0f91a89ca	4991
bf668a5d-03a2-4d48-83a6-639a17d4131e	3499
44f596c6-f253-433a-b823-0a1701b794b4	1152
46bd741e-7a38-4056-bcba-12d0df0faf64	1041
b9438692-0185-4435-a18b-564a6979e165	348
5a292f71-a2f8-42b4-a5b0-6807075b0767	3921
f1ed6841-32ad-47e6-977d-05fa71efd555	4311
ad896ef3-d6b8-4b1f-bf02-29a1ded4647c	4404
3cd3adde-0785-4ca9-bf63-79b0bda16075	4390
287ed721-67e9-463a-a652-2b05e6e50822	4773
040e86a3-c34a-4047-8112-60e8a6cfc9a2	2887
cf83bb44-1fc5-4166-8193-d2c8519aafa1	1979
74176072-2e03-439f-a149-45bf82c62263	1948
a6510142-eea6-405c-a858-35cbfcfc6e72	4380
00682b9a-eed6-4a82-acd9-5ce156ee55ec	1213
5eb74723-7023-4849-804f-f755514cb8cd	2308
37f3e9f6-1efa-4793-9c3f-3ade3e5f5b59	695
6c694b1f-b77c-49ed-948c-6bf9f5f46bcb	4123
9aa4b810-e0e4-49b3-a191-e5d456934dac	726
f3d502d0-3725-4096-b9f5-4c306069455b	3724
fde11348-02e9-4992-acc2-4e17939e79e1	2632
c54f179c-49e9-4987-a93e-fac33082befb	3729
85184a80-23c0-4e65-9203-bdd57d17ef32	3041
c4e83f25-6df0-44f0-91c8-5dc2bbfa8c3a	1396
b9f0c1e9-8f3c-454f-a0fa-d21317ebe3f2	4907
221d0e4b-a800-49dc-9c4e-c06dc119d964	3246
b51702d0-b72d-472f-9f7c-cc1ce836f557	2538
bb9446dd-f304-4c8c-b12a-d14f6b8a3b90	267
f7a9d971-ddf5-4ac6-9314-c179aa2fff22	2103
36b7a65e-0ba1-4edb-b797-ac524dc11c61	2738
a666560e-df2f-4065-9ba7-4a0edeab9313	1304
ce7b72a4-dfca-463d-931c-5965edcccb9f	13
f0647a58-2721-47d8-b4ab-6e8d34141d73	4726
cca7abe3-de77-4f24-a084-8225bd12badf	4583
583c8f7d-50ee-478a-aba1-e7387db74ce6	2467
cbccc70c-a080-41c5-bd61-aae3555ae6e7	1334
90b5f2be-5656-4606-918b-90db3878dc25	2329
cc6b4645-a0c8-480a-9b76-49208cdd2569	3859
c4f195bf-2367-4b90-ad7a-926a4bfbe42c	4576
77428424-498f-45db-a791-dc5bc2dc90f6	1060
f8cc97d9-97e8-4617-bf49-3bf81b6bbf66	3198
54b6aff9-a740-4ff4-ad31-b72b29174805	2678
722e3d85-bfe5-4f6a-8c06-f82befc91ff4	3717
e895554a-abbe-45a2-a659-3168ea8682c8	2224
9e841704-abf8-4c65-a231-0c841d397d1f	993
02443a12-049b-4b8d-8bf8-77eab7fd7cb5	3026
92c86cd7-5d6e-43fa-8ae2-a9599838621e	4016
02a4ef8b-7c7d-4922-8b84-38ea2191ad77	4068
648f3fad-07fc-4cda-beef-ad0e358c806b	2051
a0bd0cc6-76b1-4871-8361-9de626e74a78	3018
3d4d4628-f696-4897-a7d9-87f79f836853	3675
1fbebeae-492c-4a4d-9582-22896c1168da	1703
e14daaa8-4b92-4db5-bca2-a923d30d54d6	3361
ffff672e-8a31-42d8-b3ce-a7459022c228	3670
0c506981-dc43-4cfb-9efd-ce3776df3ae7	2870
e28dca49-44ba-49cc-8d25-5c29b00072df	1312
e3d1cbad-7a9f-49f2-bdc9-6173e8e96f63	815
7354fbd4-9120-497b-b785-03df9dd1f18e	391
0bc7510c-9c60-49b5-84cd-0fa3240366ca	2700
5ef9e898-b1af-4085-905d-e29e6ccb5170	3938
d00c3ed3-3b71-4ab2-a2e9-9a8fdcefee21	1771
d4a16932-e773-470c-a40a-80c20da8212f	3273
040458b5-0a57-4667-8527-6c6a015eac5a	2311
c46d6c2b-8448-4c8a-a485-5e808150525e	2184
7051b664-09c2-4fcb-b094-896c61d7b569	708
a21b4384-e99b-47f1-9b98-e624ae0fedda	2328
2b542795-6468-43cb-a24c-3a8fca58f2e3	1217
f55e3cb5-cb7a-4f8d-8c7e-3e55e8c1d953	4310
7f80329a-55f4-4d79-b91a-52a419404801	2794
5b6f6f94-62a8-4905-be93-6d40035ac008	1623
38c6ff00-cf93-48fb-9bc0-3fde1d16c4a9	3529
ff13c31b-52f2-4477-a10b-90da2e83486d	2233
5cca2cac-f25e-49d1-b5fd-4a6984f9a420	2679
d6cdadd9-f911-4d7b-9a94-b6024b47cebe	3696
50401bca-e23d-4986-bd17-4b3269b8fd97	3353
c5c4e480-70bf-47a8-93d7-e0458557ae47	3949
0dc92e2f-1625-4e0b-84e4-2eb414d568c2	2307
5f07956c-a621-4e81-a8d6-2f3f32a13e9f	4473
5d3a038b-3690-42ed-8586-8b38a6412cf6	2746
eb368e2c-68ae-4fa8-8765-867eaee92a24	1452
2ad3bd10-1401-436c-ba44-122298b79a5e	4702
fc5c42fd-cd6a-48bc-8269-35adef0879d4	3442
c39be7b0-c777-4c27-b561-8cd5d6af84da	3548
e7cde359-8439-4d92-b38e-cf910830704e	1665
f65a503c-8b10-426a-84b3-3949be757ac3	2156
c876f7e4-7662-40ec-8294-181932e14c1e	2795
416d72c0-238d-454b-937f-29a9bfc1ee9e	1520
f49573a2-931f-4403-92ce-f39ec92275d6	1873
711d1492-77e9-4485-9091-a476c63ab94c	123
f3a340ed-8356-4411-9a56-6f0abc9855e7	697
1939ac67-f14c-49a4-a49b-d029e37faae2	3196
a8c12bdf-6e28-477e-9d6a-9e50ca6646dd	1762
8b245b51-e25a-4549-bad7-998e39055333	2375
c6348628-5ff7-4837-bd79-4f5170e7ad4e	1477
48aefc1b-7ac4-43f8-ad08-561e5a42ffdc	1302
c4ddc45b-0600-4a8d-a938-40e0c56513de	37
b1889e15-b924-483b-ad5a-36d87b0bd5a8	1655
6e54281a-8980-43c7-b3a6-47742cba4a00	2235
a7023a1b-ad4c-44d9-aa45-c2b2bfd5d191	3233
937d2cdf-acd6-46dd-b9aa-4ad2ac33456a	2789
484111da-5296-4d6e-80c3-f936e6d63ec1	1124
518b5351-5762-4b23-91aa-13e44daa7b71	3039
0717bff7-b18d-478a-8095-78402b6674ef	3701
33a5c432-cbc8-442a-a6fd-d45e30b7afe3	1276
0b877aa1-aeaf-4079-8ace-29ce4f9e3bc9	1569
b4b74afa-2de6-4701-aac2-2662b22febc5	4673
100044f9-3382-4d23-8c69-0ca7d7ceb117	3450
2bf32d29-049a-4143-a9ba-6c42ab5dd2e2	2605
ad9e9410-a574-497d-9c4d-8d2855b73001	872
a79d8dde-6e3a-4559-abcf-48f724ba5db7	4595
defa8e06-c75b-481d-83a3-1502dfe3ddf2	3643
d86d981a-d09c-45c6-9817-500fd106e430	1540
a58d47fd-82b9-4421-b08e-3f59abab1063	747
8b22ab1c-e981-4ec6-987e-6fbcb3dceb67	3629
48ffe37e-55df-409a-ac3f-4bcc1b6c4104	4764
3a75e3f8-3053-4393-8bb6-4f4fb9e623a7	662
e007c244-aeb8-4be8-a4ed-a4f2d59b856f	4994
ddf85d5b-75dd-47a5-9e33-bc1b90b88091	671
9e358999-385c-48f8-afd7-5d9cf8064a86	878
\.


--
-- Data for Name: pedido_produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido_produtos (id, produto, quantidade, pedido, nota_fiscal) FROM stdin;
9351c8c2-0b99-466c-909b-bf7ec96f047a	c17431d5-ccf5-4fbc-9dd2-850d3d9f6460	3	e9af0eb8-a4c3-42ee-b649-2f3b682e6408	3450
015239ea-ca42-4407-8862-6dfe5e527872	c17431d5-ccf5-4fbc-9dd2-850d3d9f6460	3	e9af0eb8-a4c3-42ee-b649-2f3b682e6408	3450
e1f7176d-704a-4b5a-b7f8-3ca8dfa8f144	c17431d5-ccf5-4fbc-9dd2-850d3d9f6460	2	e9af0eb8-a4c3-42ee-b649-2f3b682e6408	3450
d27bd756-6018-48a5-a170-5105f84976d5	863b0cce-cfdf-4560-b3ff-8e64b149a404	3	6079fcce-6792-42fe-b1df-5406df4e008e	878
1b86a369-9e29-454f-afb7-9dc79a0f96e3	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	2	15fede92-98f5-428e-890b-9218cbba615c	3670
e17c4080-7fb6-4ad2-87b1-ad3ce87e5f90	0571223e-25ab-4d0b-afbd-011301ae7689	1	2d5af421-e39c-4eca-b262-d9b05cca8572	3734
63a8d8f7-cb2a-49c2-9721-213cb575f154	0571223e-25ab-4d0b-afbd-011301ae7689	2	2d5af421-e39c-4eca-b262-d9b05cca8572	3734
7c7a9409-8681-44fa-a910-80dd4417c10c	0571223e-25ab-4d0b-afbd-011301ae7689	2	2d5af421-e39c-4eca-b262-d9b05cca8572	3734
cb00a170-2577-4903-b74c-ce64a1ea1f1a	d4481b4a-13af-4937-8dc3-37665c13923f	1	d9a54e92-1dc4-44bb-ab6b-fa4a59880fa2	872
747b9321-a9c9-42f5-ad83-a7ac620be668	8e109261-0912-45cd-b8a6-98061c64184b	1	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	4576
fb36fca4-b44d-49cd-8afa-fba7dc5afcdc	8e109261-0912-45cd-b8a6-98061c64184b	1	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	4576
4311c05f-878d-4386-88c2-8537f8fc330b	8e109261-0912-45cd-b8a6-98061c64184b	2	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	4576
81425265-83b1-461a-94a9-042d855d1d0c	8e109261-0912-45cd-b8a6-98061c64184b	3	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	4576
0383dcf4-42a5-4900-90c1-1549afd3aec9	8e109261-0912-45cd-b8a6-98061c64184b	2	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	4576
5d2980b2-0294-49b6-9a09-5bb49c93aac1	8e109261-0912-45cd-b8a6-98061c64184b	3	732cb9c0-c86a-44e8-91cc-6dd73eb07081	2308
0dfb2f2a-3cb4-4339-b276-db0bf813920f	8e109261-0912-45cd-b8a6-98061c64184b	1	732cb9c0-c86a-44e8-91cc-6dd73eb07081	2308
7025e466-7417-47c1-8f28-966e26b76deb	8e109261-0912-45cd-b8a6-98061c64184b	3	732cb9c0-c86a-44e8-91cc-6dd73eb07081	2308
39a8b8b6-228e-4bc8-b75a-732390193824	8e109261-0912-45cd-b8a6-98061c64184b	2	732cb9c0-c86a-44e8-91cc-6dd73eb07081	2308
2d7e4326-e633-4753-9fa3-81322e7a503c	83468d4e-43e9-4437-8834-db7aa5018b9b	3	38ce7776-d71d-4195-85a7-6d9af5164163	2887
54711c12-3364-469b-82be-7375ab657d3d	83468d4e-43e9-4437-8834-db7aa5018b9b	1	38ce7776-d71d-4195-85a7-6d9af5164163	2887
12639c0b-4474-427e-84b8-5971126bfe2d	83468d4e-43e9-4437-8834-db7aa5018b9b	1	38ce7776-d71d-4195-85a7-6d9af5164163	2887
9526515e-edba-49aa-9449-4afcc040f17d	4606aa38-17e9-4e73-a59a-6e4a844addd4	3	0da0fc76-3035-4ce5-8611-2d0a36efe561	3288
c3019738-d276-4175-92be-29ca9e6480f5	4606aa38-17e9-4e73-a59a-6e4a844addd4	1	0da0fc76-3035-4ce5-8611-2d0a36efe561	3288
42851cdc-ae2e-407f-9614-b0baf78d5f7e	4606aa38-17e9-4e73-a59a-6e4a844addd4	3	0da0fc76-3035-4ce5-8611-2d0a36efe561	3288
d27bd4af-d366-4c01-bb94-a35dc8c4ee51	4606aa38-17e9-4e73-a59a-6e4a844addd4	1	0da0fc76-3035-4ce5-8611-2d0a36efe561	3288
5a0f6741-42db-4152-8edc-d33dbaf614e3	23890f27-e1cf-46ee-9ce0-f99166bb1223	2	2d536b65-26a6-4e9e-8e1d-521cc1eb32c5	3938
f981174a-3b04-40dd-a207-902b7c4f89b6	23890f27-e1cf-46ee-9ce0-f99166bb1223	1	2d536b65-26a6-4e9e-8e1d-521cc1eb32c5	3938
92cdd7e6-282d-419b-b5bc-f894b1174bb8	7369d544-ddfb-4421-b82b-6ea75aebf40a	1	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	4907
d3b9f580-e114-43d0-8255-752b884927d7	7369d544-ddfb-4421-b82b-6ea75aebf40a	2	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	4907
200ae9f7-0414-41f9-af33-341fcab79c47	7369d544-ddfb-4421-b82b-6ea75aebf40a	1	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	4907
af8d54a0-7ab9-46fc-a373-e1e5822a0846	0083efd3-7ca7-4e9a-b111-a409df5007e8	1	e8ddc468-c169-4152-bf6a-f637dd91abb5	3442
1b701254-1547-453f-881b-09cec98956f8	0083efd3-7ca7-4e9a-b111-a409df5007e8	2	e8ddc468-c169-4152-bf6a-f637dd91abb5	3442
08c74fc4-7dba-4fde-933a-8db1ed2d93ab	262f548f-7607-4aec-9b98-eee3abce9fc7	2	ab4cc207-5791-4439-a176-97d0dc50ad39	2605
e790bee3-e2e2-45d4-9f03-d39cc8d2ba22	262f548f-7607-4aec-9b98-eee3abce9fc7	1	ab4cc207-5791-4439-a176-97d0dc50ad39	2605
549fd509-205f-4c52-817a-a4b3a66ca7a4	3c2d8349-210b-457d-a192-6eb1c1db51b9	1	38ce7776-d71d-4195-85a7-6d9af5164163	4764
87199592-b8be-44b3-964d-33315f8b0d35	3c2d8349-210b-457d-a192-6eb1c1db51b9	2	38ce7776-d71d-4195-85a7-6d9af5164163	4764
067a09a2-35c7-468c-80de-7e8554c53533	3c2d8349-210b-457d-a192-6eb1c1db51b9	2	38ce7776-d71d-4195-85a7-6d9af5164163	4764
c4a6d134-4856-4f53-bcc1-e8a6b0c7637c	3c2d8349-210b-457d-a192-6eb1c1db51b9	3	38ce7776-d71d-4195-85a7-6d9af5164163	4764
ef0a7eeb-8e57-4945-87c6-6a06999c9c63	4606aa38-17e9-4e73-a59a-6e4a844addd4	2	84b11e03-0631-4022-8214-c4de91a6f6df	878
86e352eb-af0a-455e-96ca-39a2e4660986	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	3	62ff389f-84e9-4b7e-9a65-b0867a2e999f	4726
53d803be-7b58-4e93-a593-8308a3a11159	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	2	62ff389f-84e9-4b7e-9a65-b0867a2e999f	4726
f64b9003-3af1-4093-bc39-62b926db9d03	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	1	22df80ea-1a9d-4811-9ea7-39b451ffa12c	1520
52a2bb61-0290-4fa2-879a-86fbe87a082b	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	1	22df80ea-1a9d-4811-9ea7-39b451ffa12c	1520
b0ac9ff1-df00-473f-932f-bcc919b24291	9ccdb12c-2200-47d0-af16-13b54bce9914	2	4382342b-0335-4d7f-b865-eefd746e3cfb	2467
bad4d298-fee3-4e05-9389-bf55607909dc	9ccdb12c-2200-47d0-af16-13b54bce9914	2	4382342b-0335-4d7f-b865-eefd746e3cfb	2467
b1f0169f-58d6-408d-9057-07ce9350bf69	9ccdb12c-2200-47d0-af16-13b54bce9914	3	4382342b-0335-4d7f-b865-eefd746e3cfb	2467
af858d9c-65e2-4eca-bc4f-a7d102c9bc8a	9ccdb12c-2200-47d0-af16-13b54bce9914	3	4382342b-0335-4d7f-b865-eefd746e3cfb	2467
1aa55dd3-64ba-4812-82bd-a3e259f9116b	23890f27-e1cf-46ee-9ce0-f99166bb1223	3	0c53a6ae-1f4f-483b-a555-90ce28f49fdc	2156
3afa2a7c-1f42-4a70-9d8b-0bd0e19780c5	fd7c1190-18d5-4403-b1d7-b4f6b206d33f	2	3ec59e86-108a-4b42-96bb-95917c26e878	2632
f7167ffb-6d68-433d-a65e-6b204a11379c	fd7c1190-18d5-4403-b1d7-b4f6b206d33f	2	3ec59e86-108a-4b42-96bb-95917c26e878	2632
c66b791f-9631-4cd6-93d6-47fd8a4f822e	fd7c1190-18d5-4403-b1d7-b4f6b206d33f	1	3ec59e86-108a-4b42-96bb-95917c26e878	2632
3c356df7-4df1-4eec-b939-587d8eb88678	a5d284fd-5782-49a0-8b40-a9f3921deb5a	3	498d6db9-730c-41f2-b87e-107ced127d94	4576
76057c5b-182e-48de-b7c4-ffeffe30c3d1	a5d284fd-5782-49a0-8b40-a9f3921deb5a	1	498d6db9-730c-41f2-b87e-107ced127d94	4576
2a44d04a-62c0-499d-b5cc-acc9f335efc2	8cad58dc-1590-4149-8cdc-7edb7ac72fff	2	637b787f-24e5-4381-86a9-9174ebd286a5	3499
f984131b-d1af-4fdb-b5e5-748d0a62770f	8cad58dc-1590-4149-8cdc-7edb7ac72fff	1	637b787f-24e5-4381-86a9-9174ebd286a5	3499
98f99b54-2465-4f37-954d-9c44ecfc4f30	8cad58dc-1590-4149-8cdc-7edb7ac72fff	1	637b787f-24e5-4381-86a9-9174ebd286a5	3499
24f2f225-2085-4e40-b17c-f93326d8496a	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	1	a70cfc7d-6892-4a31-8e08-ed5d53022ff8	3026
425fe715-cecc-47a1-80da-0fa6e8f94484	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	1	a70cfc7d-6892-4a31-8e08-ed5d53022ff8	3026
257828ee-dd63-4e45-aef3-33ed266d4924	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	1	a70cfc7d-6892-4a31-8e08-ed5d53022ff8	3026
601af1fd-cd5a-4303-96b4-adbf0a9aa163	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	1	a70cfc7d-6892-4a31-8e08-ed5d53022ff8	3026
435c84bb-7463-4c10-9f71-18d529d0b904	780163c4-f3e7-41c6-a057-7f9196397564	3	9aa4c2d4-8e42-4fe9-b133-578e2e9eedf6	1304
ffd1c34b-2c24-43e6-8a6a-b67b84ea3a21	780163c4-f3e7-41c6-a057-7f9196397564	3	9aa4c2d4-8e42-4fe9-b133-578e2e9eedf6	1304
a5512deb-ca65-482b-b925-c58699ba64a5	780163c4-f3e7-41c6-a057-7f9196397564	1	9aa4c2d4-8e42-4fe9-b133-578e2e9eedf6	1304
75864642-fad2-4a25-94ad-a5cc318b8357	5fce77eb-e8a9-4bed-9aa8-108078b3ab99	3	4adc8216-9ba7-4cc0-b034-a6ac609df197	4773
cc2ab837-0d98-4565-adda-f198f2f0bb22	5fce77eb-e8a9-4bed-9aa8-108078b3ab99	2	4adc8216-9ba7-4cc0-b034-a6ac609df197	4773
5a317534-57c2-4494-bb16-8e440124d866	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	3	f54c76bd-b810-4599-bdf2-7ad80d9ba68b	2887
20f6fcca-f3ea-4a50-896a-15d5f9d679ca	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	2	f54c76bd-b810-4599-bdf2-7ad80d9ba68b	2887
d35e72ea-6087-44b3-bc51-89d72404c012	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	3	f54c76bd-b810-4599-bdf2-7ad80d9ba68b	2887
71e87443-9b3c-4643-b0bf-407471f4d524	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	1	f54c76bd-b810-4599-bdf2-7ad80d9ba68b	2887
1422e869-9e97-4a24-813e-ddd459071de7	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	3	f54c76bd-b810-4599-bdf2-7ad80d9ba68b	2887
0fdf7ff5-fbdc-4678-8798-d7fd5e9deba2	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	2	f54c76bd-b810-4599-bdf2-7ad80d9ba68b	2887
c962f3d3-396c-4643-803c-63c1ba257c0c	8e109261-0912-45cd-b8a6-98061c64184b	2	0c53a6ae-1f4f-483b-a555-90ce28f49fdc	3949
0c23c9c5-e70a-4b84-af5c-d7fdfbe2c472	8e109261-0912-45cd-b8a6-98061c64184b	1	0c53a6ae-1f4f-483b-a555-90ce28f49fdc	3949
ede03fdf-b35d-4e83-a89e-ae45752b2ec1	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	1	d7523b4c-b5d3-41ac-9eea-73fde70adfee	1520
4777a4a6-345f-41cd-a303-2b9b4b10022e	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	3	d7523b4c-b5d3-41ac-9eea-73fde70adfee	1520
37a209fe-9ac1-4793-83e7-9dac0b6fe13f	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	3	d7523b4c-b5d3-41ac-9eea-73fde70adfee	1520
e1ec9c58-c876-410a-a852-b1c0c2f26b18	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	1	d7523b4c-b5d3-41ac-9eea-73fde70adfee	1520
8cd9bc7d-3580-4c50-be5a-9c08bc9dde23	7369d544-ddfb-4421-b82b-6ea75aebf40a	3	e8ddc468-c169-4152-bf6a-f637dd91abb5	854
68eae50f-48a2-4e37-ba71-b2b5f136d58d	7369d544-ddfb-4421-b82b-6ea75aebf40a	2	e8ddc468-c169-4152-bf6a-f637dd91abb5	854
8e248de9-8fc3-41ae-9334-036328e05a47	7369d544-ddfb-4421-b82b-6ea75aebf40a	1	e8ddc468-c169-4152-bf6a-f637dd91abb5	854
0120c8fa-24ee-4015-9731-d513cb9dccb5	3c2d8349-210b-457d-a192-6eb1c1db51b9	3	339d10ec-ad88-456b-8964-febd0dd00347	1243
49ffa423-4857-4c8e-8410-240bb2033f09	3c2d8349-210b-457d-a192-6eb1c1db51b9	2	339d10ec-ad88-456b-8964-febd0dd00347	1243
fd4c9e4f-f014-42cc-84d9-d92f86d49655	3c2d8349-210b-457d-a192-6eb1c1db51b9	3	339d10ec-ad88-456b-8964-febd0dd00347	1243
2452825a-5048-4c94-b4e9-568d138b61a1	863b0cce-cfdf-4560-b3ff-8e64b149a404	2	088bd61b-9385-4934-99c0-5e20c671d6b8	1771
9da131b6-94f1-41e2-8bb3-cf7b770c93e0	863b0cce-cfdf-4560-b3ff-8e64b149a404	2	088bd61b-9385-4934-99c0-5e20c671d6b8	1771
d3002bc9-5d5e-4ddb-8b48-46154582c2b3	217e2dc3-3bb1-467c-bbac-f3ab12d34643	3	637b787f-24e5-4381-86a9-9174ebd286a5	1302
4c9381fb-bbaf-4569-87ed-bd4a35953854	217e2dc3-3bb1-467c-bbac-f3ab12d34643	1	637b787f-24e5-4381-86a9-9174ebd286a5	1302
c11d9b8a-9175-4336-a8d8-ff800a9a3317	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	3	51d85b61-0483-4ac1-885c-886f7d6b8db9	3717
66fa9f13-c6fa-4872-9ab2-3eb002545e9c	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	2	51d85b61-0483-4ac1-885c-886f7d6b8db9	3717
bf4c3a1e-5c2d-4d07-bfd2-f86f7f4dd697	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	1	51d85b61-0483-4ac1-885c-886f7d6b8db9	3717
9d679855-7e30-4668-bfb7-06763e8f351a	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	3	51d85b61-0483-4ac1-885c-886f7d6b8db9	3717
f9afd809-ab54-45df-ad9a-837f389665f1	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	2	51d85b61-0483-4ac1-885c-886f7d6b8db9	3717
ee79794f-6a12-4c8a-b1ff-66cf3a39bfe5	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	3	82a75dfd-96a6-47c1-b4b6-2536a1a0ada5	3643
73309ed5-52f1-4fe1-bc36-5f643c61cbf4	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	3	82a75dfd-96a6-47c1-b4b6-2536a1a0ada5	3643
ab40187d-9e30-4eeb-9c9e-319709d60847	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	2	82a75dfd-96a6-47c1-b4b6-2536a1a0ada5	3643
45d44a3f-be54-454e-906e-499cead2f39e	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	3	51fae887-3942-40f9-b6ad-8c1c28dd7083	4404
9b64e7b8-baf5-4fad-987b-72606321dea2	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	3	51fae887-3942-40f9-b6ad-8c1c28dd7083	4404
1d23c90e-08b1-4a5d-864d-705f16370d6a	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	2	51fae887-3942-40f9-b6ad-8c1c28dd7083	4404
696dde9c-c909-45fd-88b1-5ee5dc50b3e1	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	3	8a1487fb-934a-4e85-a61f-207f7f6dc41e	4161
5b583c82-692a-42cd-80a3-8c62cbaab64a	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	1	8a1487fb-934a-4e85-a61f-207f7f6dc41e	4161
d8051886-6b5d-4fd4-b601-c62f5c5ea607	4606aa38-17e9-4e73-a59a-6e4a844addd4	2	07605358-8e0f-46a7-9dfe-d944035a71bb	1979
3d5e7a70-0ec9-4811-b423-cb823b773552	4606aa38-17e9-4e73-a59a-6e4a844addd4	1	07605358-8e0f-46a7-9dfe-d944035a71bb	1979
a18427ca-7c73-4e98-8d73-ed0d7e731caa	4606aa38-17e9-4e73-a59a-6e4a844addd4	3	07605358-8e0f-46a7-9dfe-d944035a71bb	1979
feaf2a56-e4ec-48de-80f4-83da990a0a8d	9d3079ab-898c-4c42-9dd7-68fda1765d59	2	22df80ea-1a9d-4811-9ea7-39b451ffa12c	2307
b8afd19e-6233-4433-a21f-9f4785160ddd	9d3079ab-898c-4c42-9dd7-68fda1765d59	2	22df80ea-1a9d-4811-9ea7-39b451ffa12c	2307
52e222b5-511e-4680-b176-5776698d33ba	9d3079ab-898c-4c42-9dd7-68fda1765d59	2	22df80ea-1a9d-4811-9ea7-39b451ffa12c	2307
3d8b1645-dfd7-4cb6-bd8e-a27a16afa494	9d3079ab-898c-4c42-9dd7-68fda1765d59	1	22df80ea-1a9d-4811-9ea7-39b451ffa12c	2307
1ed904d1-b53d-46a4-956d-cb2913539883	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	1	84b11e03-0631-4022-8214-c4de91a6f6df	1859
9db0328b-aa44-4b10-b835-1e45cac1274b	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	1	84b11e03-0631-4022-8214-c4de91a6f6df	1859
09eb3e5b-2b43-4841-b5d6-ad1b33ef613c	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	1	84b11e03-0631-4022-8214-c4de91a6f6df	1859
df302991-633e-4ebb-b1c7-3be3a6578cc9	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	3	578800b0-cb09-477f-8323-fef6b05143dd	3629
8660d245-5dde-4a4b-9e71-aefea8d9e186	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	1	578800b0-cb09-477f-8323-fef6b05143dd	3629
1cd5a744-377c-490f-b480-5fdfd381cfad	9a4048f4-aac4-45b1-9240-124f1f7b94e7	3	eeb57a8b-f1a6-4dd9-a448-b91ab239937a	3859
881da716-b7f3-46b9-8e1c-7122ed798a46	9a4048f4-aac4-45b1-9240-124f1f7b94e7	2	eeb57a8b-f1a6-4dd9-a448-b91ab239937a	3859
7a2721cc-4594-4143-a0fe-6f2a6448e8c9	9a4048f4-aac4-45b1-9240-124f1f7b94e7	2	eeb57a8b-f1a6-4dd9-a448-b91ab239937a	3859
40531bcb-289b-4f01-a54d-4ae0bed4ee81	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	1	70021723-990f-47ee-8463-72476f996faa	2184
23091617-cf45-4b7a-8baf-6e91a5a36493	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	1	70021723-990f-47ee-8463-72476f996faa	2184
511b9813-1b04-480f-a5b8-b03296afff01	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	1	70021723-990f-47ee-8463-72476f996faa	2184
e241ed71-8492-4f18-9630-d1807b9402fa	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	2	70021723-990f-47ee-8463-72476f996faa	2184
caca93bb-0c9a-4bd6-9c57-f00c356a50e2	fd7c1190-18d5-4403-b1d7-b4f6b206d33f	2	82a75dfd-96a6-47c1-b4b6-2536a1a0ada5	1243
bf121ce5-b280-415e-bc47-d4845eef990b	fd7c1190-18d5-4403-b1d7-b4f6b206d33f	3	82a75dfd-96a6-47c1-b4b6-2536a1a0ada5	1243
4ae69cf6-7f53-42be-86b9-bd4d48a59e98	7f29cbf3-81c8-4d3a-afa1-6ac7ec06a8cf	3	20054b77-cd6e-4d16-9bc7-5cd827603eec	1041
6ad2df7c-fd07-4fbe-9959-01f043e43e02	7f29cbf3-81c8-4d3a-afa1-6ac7ec06a8cf	1	20054b77-cd6e-4d16-9bc7-5cd827603eec	1041
120ade9b-410f-4fe9-904b-aef9f43f36ba	9ccdb12c-2200-47d0-af16-13b54bce9914	2	2d5af421-e39c-4eca-b262-d9b05cca8572	13
6df879a5-441b-44cf-b4be-40e097115cfa	9ccdb12c-2200-47d0-af16-13b54bce9914	3	2d5af421-e39c-4eca-b262-d9b05cca8572	13
90d579d4-f10f-477b-afa9-458d47b4a0f1	9ccdb12c-2200-47d0-af16-13b54bce9914	3	2d5af421-e39c-4eca-b262-d9b05cca8572	13
0de5bd42-52e1-4c14-9fd4-4b76568edc6d	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	1	d432e2a9-76ea-4cad-83f7-098a3705c818	1948
6e924285-de3d-4194-afe5-0d08c826ee06	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	3	d432e2a9-76ea-4cad-83f7-098a3705c818	1948
b986ebcc-b3db-462f-a530-ff2f8b39d440	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	2	d432e2a9-76ea-4cad-83f7-098a3705c818	1948
7a1d6243-6984-49d6-85cc-14ce7a0dccc0	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	1	d432e2a9-76ea-4cad-83f7-098a3705c818	1948
7ae1e8ad-7d0a-42af-8ab0-1aaecbf7db1a	8cad58dc-1590-4149-8cdc-7edb7ac72fff	1	38ce7776-d71d-4195-85a7-6d9af5164163	3696
43dff96d-6ba7-43cd-9dcd-d22440bafe0d	8cad58dc-1590-4149-8cdc-7edb7ac72fff	1	38ce7776-d71d-4195-85a7-6d9af5164163	3696
18b60992-2bb9-4dc9-999f-a92cd087e346	262f548f-7607-4aec-9b98-eee3abce9fc7	1	ab4cc207-5791-4439-a176-97d0dc50ad39	1623
e7bdd134-977a-4995-8daa-740fa16dfe88	7369d544-ddfb-4421-b82b-6ea75aebf40a	3	0862bf90-665a-4e65-bf09-472fffd90836	4583
ceb424b5-6cec-4075-8c79-d8af28890af6	7369d544-ddfb-4421-b82b-6ea75aebf40a	1	0862bf90-665a-4e65-bf09-472fffd90836	4583
559f424d-2c6c-4fe7-9a5b-77016e13f0d6	7369d544-ddfb-4421-b82b-6ea75aebf40a	1	0862bf90-665a-4e65-bf09-472fffd90836	4583
e5ff7c78-9650-4221-9fb7-04b0ca1030af	7369d544-ddfb-4421-b82b-6ea75aebf40a	1	0862bf90-665a-4e65-bf09-472fffd90836	4583
9f7ed2d0-6c7a-4810-a564-c0826bcba6c7	7369d544-ddfb-4421-b82b-6ea75aebf40a	1	0862bf90-665a-4e65-bf09-472fffd90836	4583
f295e179-c975-4857-8fb7-9ce07f82e17e	7369d544-ddfb-4421-b82b-6ea75aebf40a	3	0862bf90-665a-4e65-bf09-472fffd90836	4583
48d6e8cc-3f61-44e5-a99c-5e48152c159f	338a32a1-4c5b-4c6b-8372-85666ac4e146	1	d8d84893-d075-4eb8-960d-ca6c779f8269	1540
dfa4fd0e-1db4-45d6-b48a-6797f43c9495	338a32a1-4c5b-4c6b-8372-85666ac4e146	3	d8d84893-d075-4eb8-960d-ca6c779f8269	1540
41b42782-a0d1-4dbb-a15d-51f42ac85586	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	1	3d30e031-da7b-448b-824a-87c232ac2003	1703
3bdd1be1-faaf-495c-88ba-397f6b2a8834	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	3	3d30e031-da7b-448b-824a-87c232ac2003	1703
28cfb889-b342-47fb-ab6e-23ae450278f8	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	3	3d30e031-da7b-448b-824a-87c232ac2003	1703
d7002d9d-c598-44d6-82e1-861c63ba385e	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	3	3d30e031-da7b-448b-824a-87c232ac2003	1703
320ee959-2d9c-44e5-ae49-e93ee76b140b	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	1	3d30e031-da7b-448b-824a-87c232ac2003	1703
83a7479a-d878-4e27-a89f-cdd05dc46412	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	3	70021723-990f-47ee-8463-72476f996faa	3701
7e32cc57-d0e7-405d-859c-df094bd699f1	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	2	70021723-990f-47ee-8463-72476f996faa	3701
f7e88600-6cbe-48be-9e6b-053637df9dd3	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	2	70021723-990f-47ee-8463-72476f996faa	3701
75f56aa5-7b44-4dbd-9d77-80d7b3bdee36	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	3	70021723-990f-47ee-8463-72476f996faa	3701
20e65fb8-6b46-4332-a29b-b75296171943	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	2	70021723-990f-47ee-8463-72476f996faa	3701
b968a52c-4f08-4649-8900-1ff167ef4dfe	0083efd3-7ca7-4e9a-b111-a409df5007e8	3	64d07fb2-5694-48c8-af59-d8a03f7b1893	1623
628187e4-7586-4b68-a2f9-65cd437db35e	68a96b57-b52d-4739-8535-be3bb3231ee4	3	84b11e03-0631-4022-8214-c4de91a6f6df	3717
90411883-c718-45bc-95d7-faf44f75b88a	68a96b57-b52d-4739-8535-be3bb3231ee4	2	84b11e03-0631-4022-8214-c4de91a6f6df	3717
f01d01dd-d645-4031-bb53-1914abf39bbf	68a96b57-b52d-4739-8535-be3bb3231ee4	1	84b11e03-0631-4022-8214-c4de91a6f6df	3717
10da9bce-321e-467e-ad60-2952ce6359d2	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	1	70021723-990f-47ee-8463-72476f996faa	2051
9d112e3a-c5a9-46ab-a234-7cb93f1a3ef8	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	2	70021723-990f-47ee-8463-72476f996faa	2051
03bcd45b-f742-4356-80ba-f1f2e05382f2	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	3	70021723-990f-47ee-8463-72476f996faa	2051
13c56903-2bd1-47f9-841f-154cc9eacd06	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	3	70021723-990f-47ee-8463-72476f996faa	2051
edd4870b-b75e-4b1f-aaaf-caed7f7b52be	2d921a66-c936-4378-a449-8f140236dabb	3	d7523b4c-b5d3-41ac-9eea-73fde70adfee	2311
cce84cc9-3a48-431d-b050-6a56d4b8b847	e2206d16-994a-4daa-a3c1-9d12d6314518	3	5b42ab57-1a63-4871-99bb-3ccdba882a00	37
b15fb72b-f017-4e5f-b2c8-2414d3d202e0	e2206d16-994a-4daa-a3c1-9d12d6314518	3	5b42ab57-1a63-4871-99bb-3ccdba882a00	37
f62e313a-07ed-4a76-8674-03231a0ea839	517756e6-eaf3-4114-b615-655bc62ea1ec	1	faa9138f-94f8-4175-bf6a-9a2cf8574915	2233
cae8e6ff-3f98-4bff-93b8-556ca6cf0766	517756e6-eaf3-4114-b615-655bc62ea1ec	2	faa9138f-94f8-4175-bf6a-9a2cf8574915	2233
7cb549e5-981e-40ed-93bb-8b7ea0a253cb	517756e6-eaf3-4114-b615-655bc62ea1ec	1	faa9138f-94f8-4175-bf6a-9a2cf8574915	2233
cf5ea303-e57d-4336-a6b1-6e524d4404f0	2a6d46d7-40e8-4f85-9a37-16b20c130a65	1	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	3285
3d17ed50-b356-44d9-93e9-d0198a9b6ecd	2a6d46d7-40e8-4f85-9a37-16b20c130a65	3	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	3285
ab66c265-29ce-4e81-a609-75513a5245ec	2a6d46d7-40e8-4f85-9a37-16b20c130a65	2	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	3285
a7cc96f5-ace9-499d-8340-4c9638f70bed	2a6d46d7-40e8-4f85-9a37-16b20c130a65	1	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	3285
47b9c0fe-920f-477f-a2c7-91399d9e36d4	2a6d46d7-40e8-4f85-9a37-16b20c130a65	1	ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	3285
358b3bdd-3229-4bd8-a392-3e43aeaf9f2a	9d3079ab-898c-4c42-9dd7-68fda1765d59	1	32e7b03d-f863-4f1c-b0ee-0d55fe1baae4	3643
696a7d83-ef8b-49f4-affc-8f594b6addc0	9d3079ab-898c-4c42-9dd7-68fda1765d59	2	32e7b03d-f863-4f1c-b0ee-0d55fe1baae4	3643
5a8c156c-5478-441a-bb91-4a583a287a35	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	1	d8d326bc-ed78-4bc3-a2f2-4897b2abd68b	3246
cd017615-c070-431b-8012-f87eed6eef1d	b219b6e4-13a0-4e71-8cda-bd5ae60c819f	2	d8d326bc-ed78-4bc3-a2f2-4897b2abd68b	3246
d26fde25-6077-4967-8322-4f35e7d95b2e	517756e6-eaf3-4114-b615-655bc62ea1ec	3	7f415f6b-6355-4057-a63f-aee748d13289	3246
55b67020-ea39-4acf-9116-882dffe4dcd9	517756e6-eaf3-4114-b615-655bc62ea1ec	1	7f415f6b-6355-4057-a63f-aee748d13289	3246
83ed9ba7-ceff-499c-8e0e-f1787110182f	517756e6-eaf3-4114-b615-655bc62ea1ec	2	7f415f6b-6355-4057-a63f-aee748d13289	3246
97249c03-b44f-424b-bfe4-5a024ce7ed12	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	3	8cfb1e2e-1fc9-4267-bf96-96dc022b7aac	3246
9294b800-b4eb-4890-9fe5-813ecda177f8	bd943247-1fe7-4c1b-ac08-de5eb4c5f126	1	8cfb1e2e-1fc9-4267-bf96-96dc022b7aac	3246
a3856f52-b312-4290-8f0c-17823f86ce03	2d921a66-c936-4378-a449-8f140236dabb	1	4adc8216-9ba7-4cc0-b034-a6ac609df197	2538
c759c786-bf22-4328-af8d-51d17bcf051d	2d921a66-c936-4378-a449-8f140236dabb	1	4adc8216-9ba7-4cc0-b034-a6ac609df197	2538
f9bbd6cf-bba2-4977-89f7-81eeaa62c652	2d921a66-c936-4378-a449-8f140236dabb	1	4adc8216-9ba7-4cc0-b034-a6ac609df197	2538
f1677ed4-6abe-46c3-95c8-ac250d7e55b7	2d921a66-c936-4378-a449-8f140236dabb	3	4adc8216-9ba7-4cc0-b034-a6ac609df197	2538
5052e314-7958-487d-bb27-0c3f06ca136c	0571223e-25ab-4d0b-afbd-011301ae7689	2	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	3018
e966c8f5-0e25-487d-ae48-460526ab4cc7	0571223e-25ab-4d0b-afbd-011301ae7689	2	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	3018
ea183c3d-1943-4a80-995d-add6cf3f0089	0571223e-25ab-4d0b-afbd-011301ae7689	2	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	3018
f899b892-fd61-4665-8031-374c5b5b8177	0571223e-25ab-4d0b-afbd-011301ae7689	1	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	3018
82b1b3dd-3c03-4116-abaa-171c8edf20d0	0571223e-25ab-4d0b-afbd-011301ae7689	3	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	3018
7c4dc2fd-dac3-43dc-a4dd-3d91ab0441a1	41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	2	1d90489c-0058-4f3f-8da7-60107e250265	1771
11914412-f2a0-47ad-8210-6de8ef26feca	2d921a66-c936-4378-a449-8f140236dabb	3	e9af0eb8-a4c3-42ee-b649-2f3b682e6408	4576
a0d521d3-1452-4e35-8873-0e8b557ef592	2d921a66-c936-4378-a449-8f140236dabb	2	e9af0eb8-a4c3-42ee-b649-2f3b682e6408	4576
246873cd-8ace-40e0-bd77-18f469b5cb72	2d921a66-c936-4378-a449-8f140236dabb	1	e9af0eb8-a4c3-42ee-b649-2f3b682e6408	4576
3df58abf-24a7-4bd9-9c99-499457a99a7c	4606aa38-17e9-4e73-a59a-6e4a844addd4	1	1f5b18ea-c819-4376-af83-9d46ab113ac9	1655
49b11724-7a0d-4108-8790-4846519ac0d7	4606aa38-17e9-4e73-a59a-6e4a844addd4	1	1f5b18ea-c819-4376-af83-9d46ab113ac9	1655
874a29e0-a27b-438b-8e4f-08532b956d7f	23890f27-e1cf-46ee-9ce0-f99166bb1223	1	ab4cc207-5791-4439-a176-97d0dc50ad39	4595
c98b309e-e8da-43ce-bac6-689a5e783c46	4606aa38-17e9-4e73-a59a-6e4a844addd4	1	61f6151d-f8a0-4752-a0f9-9732f478040c	1276
6d601050-c06f-4da9-96a5-0b1efebe6c63	9ccdb12c-2200-47d0-af16-13b54bce9914	3	51d85b61-0483-4ac1-885c-886f7d6b8db9	3288
89caccba-0118-448c-a4fb-d563549e384e	9ccdb12c-2200-47d0-af16-13b54bce9914	2	51d85b61-0483-4ac1-885c-886f7d6b8db9	3288
e7a93888-c9f5-4f08-9ffb-f79e6a0b60c2	9ccdb12c-2200-47d0-af16-13b54bce9914	2	51d85b61-0483-4ac1-885c-886f7d6b8db9	3288
2e3bcd93-4cd1-4542-b19c-be99fc900121	9ccdb12c-2200-47d0-af16-13b54bce9914	1	51d85b61-0483-4ac1-885c-886f7d6b8db9	3288
5e7a6a05-c178-41ca-8c9f-04c39e02f1e6	5fce77eb-e8a9-4bed-9aa8-108078b3ab99	2	0862bf90-665a-4e65-bf09-472fffd90836	3529
e6dc1c6f-f31f-4f54-880f-598076aec6d0	5fce77eb-e8a9-4bed-9aa8-108078b3ab99	1	0862bf90-665a-4e65-bf09-472fffd90836	3529
bf6af8ac-bd39-4d2e-a5f7-3aad31da1112	5fce77eb-e8a9-4bed-9aa8-108078b3ab99	1	0862bf90-665a-4e65-bf09-472fffd90836	3529
f198de7b-a60b-4ac4-83e8-ec5172786a19	bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	3	e8ddc468-c169-4152-bf6a-f637dd91abb5	2156
69210814-6269-4fae-b12b-bc62982c06dc	8cad58dc-1590-4149-8cdc-7edb7ac72fff	1	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	2795
b207bf3a-a987-4c84-b5f2-6df942ba16c9	8cad58dc-1590-4149-8cdc-7edb7ac72fff	3	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	2795
a5c4ea51-6dcb-4c27-97a4-c7b50a5bf4b8	8cad58dc-1590-4149-8cdc-7edb7ac72fff	3	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	2795
1c9b8d0a-9cbf-40a5-96f1-276790d7b1b6	8cad58dc-1590-4149-8cdc-7edb7ac72fff	1	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	2795
5f6d81d0-193c-4068-a318-b423d14c0e0f	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	1	5b42ab57-1a63-4871-99bb-3ccdba882a00	2794
24227fa4-db97-49d1-abc6-9c91963508f7	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	2	5b42ab57-1a63-4871-99bb-3ccdba882a00	2794
d11ef155-75a9-4100-934d-3ffe47c534c0	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	2	5b42ab57-1a63-4871-99bb-3ccdba882a00	2794
ddc56029-eed3-413e-838f-999212910b0b	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	1	5b42ab57-1a63-4871-99bb-3ccdba882a00	2794
2d6e8050-993a-45df-bbb3-7fe1ae3e2dde	96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	3	5b42ab57-1a63-4871-99bb-3ccdba882a00	2794
40015aac-76ec-4ae9-9031-0067d10ebcc5	9a4048f4-aac4-45b1-9240-124f1f7b94e7	3	1f5b18ea-c819-4376-af83-9d46ab113ac9	1665
7846e1b3-31e0-418e-b214-6bc849100a46	967903cf-d027-4b6d-b6fd-86d37641be3a	1	61f6151d-f8a0-4752-a0f9-9732f478040c	2730
047a0afa-e1ed-4a55-ae4f-827b81f45b2d	967903cf-d027-4b6d-b6fd-86d37641be3a	2	61f6151d-f8a0-4752-a0f9-9732f478040c	2730
ec57a54d-a2da-4bd4-a205-5566d6d1be33	967903cf-d027-4b6d-b6fd-86d37641be3a	1	61f6151d-f8a0-4752-a0f9-9732f478040c	2730
67eef08f-2eb4-45da-adad-1772e4c7ff96	967903cf-d027-4b6d-b6fd-86d37641be3a	3	61f6151d-f8a0-4752-a0f9-9732f478040c	2730
2437a9cf-2aaa-43d3-a1c2-4cb319fa0bff	967903cf-d027-4b6d-b6fd-86d37641be3a	3	61f6151d-f8a0-4752-a0f9-9732f478040c	2730
62d59ef2-c3dc-4d87-8d62-c47c6975f26d	83468d4e-43e9-4437-8834-db7aa5018b9b	2	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	2311
3d9b4308-6c6c-4e40-8533-cb86ae8ab7cc	83468d4e-43e9-4437-8834-db7aa5018b9b	2	9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	2311
1c55a3cf-a1a8-490a-8f71-2a13991abbb2	294b0fda-5fed-4231-80ca-dfba0a571b98	2	c566dd3b-860f-4e96-b86d-a8b12b06303f	267
661464c8-bbcd-4f92-943c-4b19273fd74f	294b0fda-5fed-4231-80ca-dfba0a571b98	1	c566dd3b-860f-4e96-b86d-a8b12b06303f	267
a3ee61e0-a39b-4549-87bf-ebd92c361a25	294b0fda-5fed-4231-80ca-dfba0a571b98	2	c566dd3b-860f-4e96-b86d-a8b12b06303f	267
f5e1744a-ebec-422d-99f8-db7ee0532e96	d4481b4a-13af-4937-8dc3-37665c13923f	1	2d536b65-26a6-4e9e-8e1d-521cc1eb32c5	3921
c59103fc-c53c-485e-84e0-0532c8320596	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	1	d4f44d1e-0d6a-4705-806d-bbbc22dbff43	2794
8413e599-0bcf-4b01-8594-f96307530096	5fb1466e-9c47-4e6e-ae18-82443af3fc0f	2	d4f44d1e-0d6a-4705-806d-bbbc22dbff43	2794
7fd347c9-03ce-4052-ae3f-5922ad45f361	2d921a66-c936-4378-a449-8f140236dabb	1	74d3988b-0c6b-4161-943d-43b0d35f5275	1771
dc476576-4bfe-4195-81ec-d8149b5e1a13	2d921a66-c936-4378-a449-8f140236dabb	1	74d3988b-0c6b-4161-943d-43b0d35f5275	1771
e1e85715-2dfc-4797-88e1-00930037c472	d4481b4a-13af-4937-8dc3-37665c13923f	2	3363539a-6ebe-4a5c-9bdd-bd167a637957	1873
6001baea-8027-46bc-9c03-57c03f50ee71	d4481b4a-13af-4937-8dc3-37665c13923f	1	3363539a-6ebe-4a5c-9bdd-bd167a637957	1873
7c3a9153-1cb1-4fdf-b60f-b594f7303b46	d4481b4a-13af-4937-8dc3-37665c13923f	1	3363539a-6ebe-4a5c-9bdd-bd167a637957	1873
8b63a726-3a41-474b-9e94-f0c9993e8e17	d4481b4a-13af-4937-8dc3-37665c13923f	1	3363539a-6ebe-4a5c-9bdd-bd167a637957	1873
df5f3597-3f11-4e9d-8f28-37081a390831	d4481b4a-13af-4937-8dc3-37665c13923f	2	3363539a-6ebe-4a5c-9bdd-bd167a637957	1873
47eb40bf-fbb8-4ac7-b5b5-5393c9fa4775	8e109261-0912-45cd-b8a6-98061c64184b	2	7726d9e3-a854-413e-a13e-3d0b0938edb5	2538
3793909a-988d-46ce-809a-dcad999c9b77	8e109261-0912-45cd-b8a6-98061c64184b	2	7726d9e3-a854-413e-a13e-3d0b0938edb5	2538
cd12ca37-f996-407a-a5f1-f1e50070d24d	8e109261-0912-45cd-b8a6-98061c64184b	2	7726d9e3-a854-413e-a13e-3d0b0938edb5	2538
dd34b465-3d89-45db-9c0c-ac609ec25fbb	8e109261-0912-45cd-b8a6-98061c64184b	3	7726d9e3-a854-413e-a13e-3d0b0938edb5	2538
140e8b71-c003-4d5d-a1f5-23c53918452c	8e109261-0912-45cd-b8a6-98061c64184b	1	7726d9e3-a854-413e-a13e-3d0b0938edb5	2538
504cef43-0087-4907-b42d-e9c0dc3d431e	a5d284fd-5782-49a0-8b40-a9f3921deb5a	1	20a45684-3b12-4dfd-9f8e-eab81cd571e1	4994
f72a37c1-21e2-4419-9ac3-33c9fca6ca39	a5d284fd-5782-49a0-8b40-a9f3921deb5a	2	20a45684-3b12-4dfd-9f8e-eab81cd571e1	4994
da3f2946-9cb4-47d1-97c6-d231afb20277	294b0fda-5fed-4231-80ca-dfba0a571b98	1	e8ddc468-c169-4152-bf6a-f637dd91abb5	2795
3ec072ba-85a4-4314-92ea-122d9f7092c4	294b0fda-5fed-4231-80ca-dfba0a571b98	1	e8ddc468-c169-4152-bf6a-f637dd91abb5	2795
aae91ba1-29e9-43ad-b888-df34ba4db44f	294b0fda-5fed-4231-80ca-dfba0a571b98	2	e8ddc468-c169-4152-bf6a-f637dd91abb5	2795
a39683ba-8631-4014-9d80-f6d4c81c563b	217e2dc3-3bb1-467c-bbac-f3ab12d34643	3	1753f006-f7c7-4447-86c1-c36ea5fceb07	751
64193c2c-729e-407b-a37f-38c65f4569c1	217e2dc3-3bb1-467c-bbac-f3ab12d34643	3	1753f006-f7c7-4447-86c1-c36ea5fceb07	751
03011329-d49a-455c-a03a-bb37dc63f409	72b4e40c-51b3-4659-9b2c-eb83e441f894	3	374a0dc0-f11c-468f-b128-a7fa2ad8fb85	3246
cd4c4d5f-aaee-4e6f-969f-2eee78a986ef	72b4e40c-51b3-4659-9b2c-eb83e441f894	2	374a0dc0-f11c-468f-b128-a7fa2ad8fb85	3246
d77f1b45-392b-45a5-95a5-b46947504bd1	72b4e40c-51b3-4659-9b2c-eb83e441f894	2	374a0dc0-f11c-468f-b128-a7fa2ad8fb85	3246
247272dd-b8cb-44b5-9e1e-92d8b2f277ca	72b4e40c-51b3-4659-9b2c-eb83e441f894	3	374a0dc0-f11c-468f-b128-a7fa2ad8fb85	3246
3ce04abd-af97-4010-a8a7-0c1dd884b588	23890f27-e1cf-46ee-9ce0-f99166bb1223	1	a70cfc7d-6892-4a31-8e08-ed5d53022ff8	726
c0389685-de8e-44e9-94bf-c84d10299310	23890f27-e1cf-46ee-9ce0-f99166bb1223	2	a70cfc7d-6892-4a31-8e08-ed5d53022ff8	726
52910c09-5a38-4cb7-add9-5230d21e0fff	23890f27-e1cf-46ee-9ce0-f99166bb1223	1	a70cfc7d-6892-4a31-8e08-ed5d53022ff8	726
41db51e2-8d2e-4847-a25e-b977ab34f169	23890f27-e1cf-46ee-9ce0-f99166bb1223	1	a70cfc7d-6892-4a31-8e08-ed5d53022ff8	726
5d288aed-0f8e-470d-b694-5c34dfed5ba2	23890f27-e1cf-46ee-9ce0-f99166bb1223	1	a70cfc7d-6892-4a31-8e08-ed5d53022ff8	726
8309ba6a-2cf3-4b2f-9428-6b4142b8ae93	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	1	9aa4c2d4-8e42-4fe9-b133-578e2e9eedf6	878
ad6db374-3582-4d9c-9dec-9255be2edcf1	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	3	9aa4c2d4-8e42-4fe9-b133-578e2e9eedf6	878
6126655c-f906-4cae-b5be-433381864e4e	f7bf70dc-63c1-45d2-a607-e88dcb68eef6	3	9aa4c2d4-8e42-4fe9-b133-578e2e9eedf6	878
\.


--
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedidos (id, colaborador, cliente, data, forma_de_pagamento) FROM stdin;
1d90489c-0058-4f3f-8da7-60107e250265	790cc03c-b604-4434-a557-4067e629ddcb	310bc8aa-a3bd-43bc-b82e-c75a1ae49d0e	2022-05-02	cartão de crédito
339d10ec-ad88-456b-8964-febd0dd00347	335ba014-e0bd-4de8-991f-d30508bd11f0	e352f0c4-ca98-4948-94fd-3b2bde4f58a4	2022-05-06	cartão de crédito
6fefbc86-4a4a-4554-81a5-d0ed719b5431	4469a8ac-0571-43c6-848c-79a80a7bce54	17b251a0-60c5-4266-9a74-758ec7456b76	2022-05-24	cartão de débito
84b11e03-0631-4022-8214-c4de91a6f6df	4469a8ac-0571-43c6-848c-79a80a7bce54	e352f0c4-ca98-4948-94fd-3b2bde4f58a4	2022-05-15	dinheiro
374a0dc0-f11c-468f-b128-a7fa2ad8fb85	0a7fc057-6228-48e5-b8b6-0ab506e95daf	264d6c24-f6c9-4acb-af2d-da879ece7f1a	2022-06-01	cartão de crédito
61f6151d-f8a0-4752-a0f9-9732f478040c	dbe13d81-9406-4366-8393-e4231f5cf0ee	6859e602-94fa-4723-82c3-aa6e3e59304b	2022-05-30	cartão de débito
e8ddc468-c169-4152-bf6a-f637dd91abb5	65a174cb-85ac-4bc0-814c-949d25dbc102	6c3a8abe-f442-4f61-acc1-11c8b17c0bbb	2022-05-01	dinheiro
4de0a01e-1443-4c8b-8309-3b95d189cbad	0a7fc057-6228-48e5-b8b6-0ab506e95daf	78374a7a-f58c-4883-9999-c4416235c469	2022-04-17	cartão de débito
07605358-8e0f-46a7-9dfe-d944035a71bb	4ee6da58-4efe-45d6-baf6-8c2dc9694198	264d6c24-f6c9-4acb-af2d-da879ece7f1a	2022-06-01	dinheiro
ad2564f9-2e7d-4464-b1a1-2a4ba4352368	64759455-3541-4724-8a45-0bc0375127d2	729c44ff-7a2a-4812-b051-dec4353feef2	2022-03-23	cartão de débito
d4f44d1e-0d6a-4705-806d-bbbc22dbff43	4469a8ac-0571-43c6-848c-79a80a7bce54	b9821dc9-b7e2-496b-96d4-1691c60504c5	2022-05-12	dinheiro
70021723-990f-47ee-8463-72476f996faa	dbe13d81-9406-4366-8393-e4231f5cf0ee	b7f80e32-29c4-496d-8e53-ee01487a2baf	2022-04-25	cartão de crédito
51d85b61-0483-4ac1-885c-886f7d6b8db9	790cc03c-b604-4434-a557-4067e629ddcb	135c49f9-0217-40fa-b293-5d023a86883e	2022-05-29	dinheiro
2d5af421-e39c-4eca-b262-d9b05cca8572	790cc03c-b604-4434-a557-4067e629ddcb	72a5325b-3a95-4274-a759-4c474826d7da	2022-06-01	dinheiro
52492ee8-5e87-4f1b-af28-5271024ccfc1	64759455-3541-4724-8a45-0bc0375127d2	bc50edf9-6c9f-4de7-9c06-226ca8b952c3	2022-05-10	cartão de crédito
265eb80f-26a5-4f4f-89d0-3a099ebc7b2a	0a7fc057-6228-48e5-b8b6-0ab506e95daf	e96920f8-5146-4e99-9969-67cbadcacb60	2022-05-21	cartão de débito
b4de1810-81ec-452d-b3ac-1c85ac519aa4	0a7fc057-6228-48e5-b8b6-0ab506e95daf	da792bc4-f4d5-420d-8c43-a1368a622cc8	2022-04-29	cartão de débito
578800b0-cb09-477f-8323-fef6b05143dd	790cc03c-b604-4434-a557-4067e629ddcb	9b4ca654-1be6-461a-919d-bfec1e6cd57b	2022-04-14	dinheiro
a5b6341c-cd45-4e04-a5b7-c35828f929ca	64759455-3541-4724-8a45-0bc0375127d2	264d6c24-f6c9-4acb-af2d-da879ece7f1a	2022-05-05	dinheiro
a70cfc7d-6892-4a31-8e08-ed5d53022ff8	64759455-3541-4724-8a45-0bc0375127d2	10c00a71-9722-41ba-9741-8e2ce313e694	2022-06-02	cartão de débito
d9a54e92-1dc4-44bb-ab6b-fa4a59880fa2	0a7fc057-6228-48e5-b8b6-0ab506e95daf	cf6264de-30ac-4d6e-b374-a3c845e48fcf	2022-05-09	cartão de crédito
eeb57a8b-f1a6-4dd9-a448-b91ab239937a	f7c5a0e6-2119-4384-ad53-05ce575fbb8e	931f40d5-1249-4e2a-9089-9b85a9bf45a4	2022-03-24	cartão de crédito
d8d326bc-ed78-4bc3-a2f2-4897b2abd68b	0a7fc057-6228-48e5-b8b6-0ab506e95daf	c99cfb92-8f6a-49ec-9eab-3d4eb901e1f1	2022-04-30	cartão de débito
55a6006c-9466-42e1-be55-ff36c1c9adfe	335ba014-e0bd-4de8-991f-d30508bd11f0	264d6c24-f6c9-4acb-af2d-da879ece7f1a	2022-04-30	cartão de débito
32e7b03d-f863-4f1c-b0ee-0d55fe1baae4	0a7fc057-6228-48e5-b8b6-0ab506e95daf	da792bc4-f4d5-420d-8c43-a1368a622cc8	2022-05-25	dinheiro
732cb9c0-c86a-44e8-91cc-6dd73eb07081	65a174cb-85ac-4bc0-814c-949d25dbc102	6b805a6a-c6c9-44bd-b3bc-fad0c57b40df	2022-05-10	cartão de crédito
637b787f-24e5-4381-86a9-9174ebd286a5	790cc03c-b604-4434-a557-4067e629ddcb	085aefdc-91dc-496e-8fd7-71ef2405c8dd	2022-04-05	dinheiro
8a1487fb-934a-4e85-a61f-207f7f6dc41e	6459a1c7-3597-4913-b609-78a486cc6eaf	ad6a7a16-bbba-4f37-aed9-0007f8d65a30	2022-05-30	cartão de débito
7726d9e3-a854-413e-a13e-3d0b0938edb5	64759455-3541-4724-8a45-0bc0375127d2	310bc8aa-a3bd-43bc-b82e-c75a1ae49d0e	2022-03-22	cartão de crédito
ad4f11df-c632-469b-a80b-eeef68ae2208	790cc03c-b604-4434-a557-4067e629ddcb	ab0dde2c-cb73-4f53-841c-05e6e2cfd7a8	2022-05-20	cartão de crédito
6079fcce-6792-42fe-b1df-5406df4e008e	64759455-3541-4724-8a45-0bc0375127d2	f899744c-5a1d-4248-8ff0-2b015beebc44	2022-04-29	dinheiro
20054b77-cd6e-4d16-9bc7-5cd827603eec	0a7fc057-6228-48e5-b8b6-0ab506e95daf	7872f67e-6a7a-4e3a-a51f-e80a6e23e62e	2022-05-25	dinheiro
d7523b4c-b5d3-41ac-9eea-73fde70adfee	64759455-3541-4724-8a45-0bc0375127d2	5dbf08b2-f814-44a4-b62d-efdfbaf373c4	2022-05-30	cartão de débito
4382342b-0335-4d7f-b865-eefd746e3cfb	790cc03c-b604-4434-a557-4067e629ddcb	5622c27b-11c7-4c75-9fe9-1e31c189e08d	2022-05-15	cartão de débito
498d6db9-730c-41f2-b87e-107ced127d94	6459a1c7-3597-4913-b609-78a486cc6eaf	bc50edf9-6c9f-4de7-9c06-226ca8b952c3	2022-05-20	cartão de crédito
d432e2a9-76ea-4cad-83f7-098a3705c818	f7c5a0e6-2119-4384-ad53-05ce575fbb8e	4c3aba82-67fb-46af-9fdc-b2949afd7346	2022-04-03	dinheiro
7f415f6b-6355-4057-a63f-aee748d13289	790cc03c-b604-4434-a557-4067e629ddcb	689b4278-71f4-4150-9fa6-08ea91d0f89a	2022-04-11	dinheiro
4ddd767b-15f1-480f-aa29-05817000969f	0a7fc057-6228-48e5-b8b6-0ab506e95daf	20b3431d-c933-4df3-839a-68f6aaa34698	2022-05-30	cartão de crédito
5b42ab57-1a63-4871-99bb-3ccdba882a00	0a7fc057-6228-48e5-b8b6-0ab506e95daf	6859e602-94fa-4723-82c3-aa6e3e59304b	2022-04-30	dinheiro
74d3988b-0c6b-4161-943d-43b0d35f5275	64759455-3541-4724-8a45-0bc0375127d2	6d971123-cbe8-4a89-abd8-4a46e72179b7	2022-05-22	cartão de débito
9778e676-e4fb-4bd2-bb4f-9ffc27d810e4	4ee6da58-4efe-45d6-baf6-8c2dc9694198	e96920f8-5146-4e99-9969-67cbadcacb60	2022-04-22	dinheiro
20a45684-3b12-4dfd-9f8e-eab81cd571e1	65a174cb-85ac-4bc0-814c-949d25dbc102	c6e1fb74-b946-4fdf-81ea-f5c30992a4ed	2022-04-24	dinheiro
9aa4c2d4-8e42-4fe9-b133-578e2e9eedf6	f7c5a0e6-2119-4384-ad53-05ce575fbb8e	6b805a6a-c6c9-44bd-b3bc-fad0c57b40df	2022-05-30	cartão de crédito
dbafa19d-1c22-4cbc-ac2a-bc2d183cb45f	65a174cb-85ac-4bc0-814c-949d25dbc102	78374a7a-f58c-4883-9999-c4416235c469	2022-04-20	dinheiro
faa9138f-94f8-4175-bf6a-9a2cf8574915	dbe13d81-9406-4366-8393-e4231f5cf0ee	6d971123-cbe8-4a89-abd8-4a46e72179b7	2022-05-28	cartão de crédito
c566dd3b-860f-4e96-b86d-a8b12b06303f	f7c5a0e6-2119-4384-ad53-05ce575fbb8e	c9e0f823-b956-4105-abb4-ef6cf0103384	2022-05-02	dinheiro
08b76d11-57a2-45fa-9ac8-9b85b67c97bf	f7c5a0e6-2119-4384-ad53-05ce575fbb8e	6859e602-94fa-4723-82c3-aa6e3e59304b	2022-06-01	cartão de crédito
ca8e71c0-3a21-469d-9cc2-0f6d0a4009cc	65a174cb-85ac-4bc0-814c-949d25dbc102	7872f67e-6a7a-4e3a-a51f-e80a6e23e62e	2022-04-02	cartão de crédito
afc8827f-ae82-410a-b534-045f3bce5f5c	dbe13d81-9406-4366-8393-e4231f5cf0ee	3047eea0-8c8e-45c0-a30f-f1a6a4f63f92	2022-05-14	cartão de crédito
0862bf90-665a-4e65-bf09-472fffd90836	790cc03c-b604-4434-a557-4067e629ddcb	7a09fda7-8394-40be-b6ec-7394fb618e1c	2022-04-09	dinheiro
62ff389f-84e9-4b7e-9a65-b0867a2e999f	64759455-3541-4724-8a45-0bc0375127d2	730780ad-2e2b-4232-b3b8-ce460e709b53	2022-05-18	cartão de crédito
33c26d59-074d-45ec-97de-440e21bda74d	0a7fc057-6228-48e5-b8b6-0ab506e95daf	781f4834-fdea-4801-bd5d-450ed3b674dd	2022-04-15	cartão de débito
0c53a6ae-1f4f-483b-a555-90ce28f49fdc	790cc03c-b604-4434-a557-4067e629ddcb	7fc2da37-83b9-437b-8e25-a51cdc79172e	2022-03-31	dinheiro
30a0727f-2ffa-4228-86a7-76e741f979d9	0a7fc057-6228-48e5-b8b6-0ab506e95daf	2d27e551-1806-41c5-b6a2-a3cd2c95a7a2	2022-05-30	dinheiro
d8d84893-d075-4eb8-960d-ca6c779f8269	4469a8ac-0571-43c6-848c-79a80a7bce54	f899744c-5a1d-4248-8ff0-2b015beebc44	2022-06-01	cartão de débito
64d07fb2-5694-48c8-af59-d8a03f7b1893	65a174cb-85ac-4bc0-814c-949d25dbc102	f8bc69c1-8d7b-47ea-af2d-8a0f893147dd	2022-05-07	dinheiro
22df80ea-1a9d-4811-9ea7-39b451ffa12c	f7c5a0e6-2119-4384-ad53-05ce575fbb8e	a6352d87-de80-4cee-9819-75645122d110	2022-06-01	cartão de débito
1f5b18ea-c819-4376-af83-9d46ab113ac9	0a7fc057-6228-48e5-b8b6-0ab506e95daf	9dda8b30-cf1d-4d9d-86b3-b6d16e560795	2022-05-20	cartão de crédito
2d536b65-26a6-4e9e-8e1d-521cc1eb32c5	dbe13d81-9406-4366-8393-e4231f5cf0ee	95ee393c-f317-4747-a4d3-8739e0bf7ad3	2022-05-04	dinheiro
51fae887-3942-40f9-b6ad-8c1c28dd7083	64759455-3541-4724-8a45-0bc0375127d2	931f40d5-1249-4e2a-9089-9b85a9bf45a4	2022-06-01	cartão de débito
3d30e031-da7b-448b-824a-87c232ac2003	65a174cb-85ac-4bc0-814c-949d25dbc102	730780ad-2e2b-4232-b3b8-ce460e709b53	2022-05-23	dinheiro
ed779c90-3c32-4124-882b-ff871765659d	4ee6da58-4efe-45d6-baf6-8c2dc9694198	9c891b87-8ffd-4cf1-9b5d-73ec0bec351e	2022-04-24	cartão de crédito
872c9398-c62e-4c06-b25a-dc12e8676949	65a174cb-85ac-4bc0-814c-949d25dbc102	fd34ac46-51e6-4c4b-a984-a0d7e6f21621	2022-04-07	dinheiro
e9af0eb8-a4c3-42ee-b649-2f3b682e6408	f7c5a0e6-2119-4384-ad53-05ce575fbb8e	6d595c01-c94b-4190-b6cc-1f27f94d896c	2022-05-14	cartão de débito
34ef779d-9acc-42af-a350-52ddf17015a3	4469a8ac-0571-43c6-848c-79a80a7bce54	db70e291-234a-46ca-86d7-1bbaebe0e917	2022-05-04	dinheiro
38ce7776-d71d-4195-85a7-6d9af5164163	64759455-3541-4724-8a45-0bc0375127d2	cf6264de-30ac-4d6e-b374-a3c845e48fcf	2022-05-12	cartão de débito
4d6c87ed-e2d1-4e90-b091-00ecf3741681	0a7fc057-6228-48e5-b8b6-0ab506e95daf	9ff2e1ad-d2aa-45c3-873b-4f558ecbf005	2022-03-20	cartão de crédito
3ec59e86-108a-4b42-96bb-95917c26e878	4469a8ac-0571-43c6-848c-79a80a7bce54	01b9b889-899e-462e-9627-025de4a0771f	2022-05-28	dinheiro
82a75dfd-96a6-47c1-b4b6-2536a1a0ada5	4ee6da58-4efe-45d6-baf6-8c2dc9694198	4c83370d-801e-4365-bf6a-6eb41f9f59b7	2022-05-13	cartão de crédito
b178bcd8-15fc-4fc9-b6a1-df30e4abcbec	0a7fc057-6228-48e5-b8b6-0ab506e95daf	ce97865f-ac8f-4287-a81b-c1b026502a19	2022-05-24	cartão de débito
39705879-5a18-4835-9441-d71910d79a98	790cc03c-b604-4434-a557-4067e629ddcb	730780ad-2e2b-4232-b3b8-ce460e709b53	2022-05-23	dinheiro
ca118abf-e251-4a0a-9432-d81120657ba2	790cc03c-b604-4434-a557-4067e629ddcb	ce97865f-ac8f-4287-a81b-c1b026502a19	2022-04-21	cartão de crédito
c0990edf-6e63-4569-a6f2-f2c5b1da2cc5	4469a8ac-0571-43c6-848c-79a80a7bce54	48545604-5198-473a-b4e4-46ff370ce639	2022-05-31	dinheiro
08c2e5d0-45fa-438c-bcbe-b455e2549ef5	6459a1c7-3597-4913-b609-78a486cc6eaf	e352f0c4-ca98-4948-94fd-3b2bde4f58a4	2022-05-28	cartão de débito
cc6b0fdc-f076-4224-ab47-3c4224d3f8d8	4469a8ac-0571-43c6-848c-79a80a7bce54	68b4def4-ad4f-49ee-b5b1-7555cff37ead	2022-05-22	cartão de débito
f54c76bd-b810-4599-bdf2-7ad80d9ba68b	6459a1c7-3597-4913-b609-78a486cc6eaf	7872f67e-6a7a-4e3a-a51f-e80a6e23e62e	2022-04-16	dinheiro
6e242dc4-d7db-4a76-8fb1-a1acc2585966	0a7fc057-6228-48e5-b8b6-0ab506e95daf	a6352d87-de80-4cee-9819-75645122d110	2022-05-26	cartão de crédito
e64f912b-7ebc-452a-80b3-5774f6506b0b	64759455-3541-4724-8a45-0bc0375127d2	c6a75c9b-f5ce-4989-96ef-a0fde789da0c	2022-03-10	cartão de crédito
4adc8216-9ba7-4cc0-b034-a6ac609df197	dbe13d81-9406-4366-8393-e4231f5cf0ee	781f4834-fdea-4801-bd5d-450ed3b674dd	2022-05-09	dinheiro
1753f006-f7c7-4447-86c1-c36ea5fceb07	dbe13d81-9406-4366-8393-e4231f5cf0ee	c99cfb92-8f6a-49ec-9eab-3d4eb901e1f1	2022-05-31	cartão de débito
3858cf90-35c9-4816-b891-6837b5bbb6d6	6459a1c7-3597-4913-b609-78a486cc6eaf	72a5325b-3a95-4274-a759-4c474826d7da	2022-03-27	cartão de crédito
e9e80cd6-1f0f-4738-b494-6279e1840766	4469a8ac-0571-43c6-848c-79a80a7bce54	68b4def4-ad4f-49ee-b5b1-7555cff37ead	2022-04-21	dinheiro
3363539a-6ebe-4a5c-9bdd-bd167a637957	6459a1c7-3597-4913-b609-78a486cc6eaf	61cc8c91-1b13-49c3-9e60-1fe958d56046	2022-05-31	dinheiro
0da0fc76-3035-4ce5-8611-2d0a36efe561	790cc03c-b604-4434-a557-4067e629ddcb	264d6c24-f6c9-4acb-af2d-da879ece7f1a	2022-05-31	dinheiro
ab4cc207-5791-4439-a176-97d0dc50ad39	0a7fc057-6228-48e5-b8b6-0ab506e95daf	9c891b87-8ffd-4cf1-9b5d-73ec0bec351e	2022-03-22	cartão de débito
15fede92-98f5-428e-890b-9218cbba615c	335ba014-e0bd-4de8-991f-d30508bd11f0	135c49f9-0217-40fa-b293-5d023a86883e	2022-04-08	cartão de crédito
c9cf8e81-35a8-4bcf-85c4-3ab8033b657b	6459a1c7-3597-4913-b609-78a486cc6eaf	6d595c01-c94b-4190-b6cc-1f27f94d896c	2022-03-07	cartão de crédito
088bd61b-9385-4934-99c0-5e20c671d6b8	6459a1c7-3597-4913-b609-78a486cc6eaf	a13e1f68-126d-4c0c-8229-14154cdbb732	2022-06-02	cartão de débito
8cfb1e2e-1fc9-4267-bf96-96dc022b7aac	4ee6da58-4efe-45d6-baf6-8c2dc9694198	d9ff1e25-adc7-4755-89fa-6b96b5349260	2022-05-31	cartão de débito
47f1cf10-34e2-43bd-90e3-dee1dd7f718c	4ee6da58-4efe-45d6-baf6-8c2dc9694198	730780ad-2e2b-4232-b3b8-ce460e709b53	2022-05-02	cartão de débito
\.


--
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos (id, nome, preco, quantidade) FROM stdin;
3c2d8349-210b-457d-a192-6eb1c1db51b9	Carro	30.65	640
4bff65e1-8efe-4108-8d02-3a1eab053da6	Sabonete	423.93	201
262f548f-7607-4aec-9b98-eee3abce9fc7	Bacon	166.26	565
f07720ad-c599-4de8-bb25-bf77751077bd	Bicicleta	11.49	309
68a96b57-b52d-4739-8535-be3bb3231ee4	Salsicha	107.04	47
9a4048f4-aac4-45b1-9240-124f1f7b94e7	Bicicleta	105.94	303
2d921a66-c936-4378-a449-8f140236dabb	Chapéu	317.59	390
d4481b4a-13af-4937-8dc3-37665c13923f	Sabonete	156.53	400
a5d284fd-5782-49a0-8b40-a9f3921deb5a	Mesa	428.53	883
c17431d5-ccf5-4fbc-9dd2-850d3d9f6460	Salada	187.73	607
bfd499ec-8ad1-42f2-bfae-ee8e332fca3a	Peixe	440.83	459
5fce77eb-e8a9-4bed-9aa8-108078b3ab99	Camiseta	118.09	945
e2206d16-994a-4daa-a3c1-9d12d6314518	Bicicleta	451.26	378
967903cf-d027-4b6d-b6fd-86d37641be3a	Peixe	396.87	17
7a27d612-f785-43f2-89cc-8fa890bea08c	Bicicleta	421.32	451
780163c4-f3e7-41c6-a057-7f9196397564	Calças	386.06	232
217e2dc3-3bb1-467c-bbac-f3ab12d34643	Salada	52.70	917
0571223e-25ab-4d0b-afbd-011301ae7689	Frango	495.43	881
f7bf70dc-63c1-45d2-a607-e88dcb68eef6	Peixe	14.81	902
23890f27-e1cf-46ee-9ce0-f99166bb1223	Sabonete	114.24	963
2a6d46d7-40e8-4f85-9a37-16b20c130a65	Luvas	149.08	209
29c9fe62-4313-4803-88bf-baa4c3316e54	Bola	307.54	870
0083efd3-7ca7-4e9a-b111-a409df5007e8	Salada	478.28	936
41a8eec6-2b9e-4a35-9cf0-e3cbe0fd14f6	Mouse	192.52	13
7f29cbf3-81c8-4d3a-afa1-6ac7ec06a8cf	Teclado	342.43	693
6c80eb2e-d281-4e9d-b72a-79c0a53dd8ee	Pizza	466.84	783
863b0cce-cfdf-4560-b3ff-8e64b149a404	Cadeira	96.43	888
21a71512-a944-4f15-aa7c-d7ac03cfba07	Bicicleta	492.92	594
8cad58dc-1590-4149-8cdc-7edb7ac72fff	Salada	340.07	93
4b42afce-78f5-4000-a2e7-6fc1c6528ddc	Salsicha	479.17	749
4fd3230c-d3a4-429c-9957-d7c84e1f3292	Chapéu	227.25	213
bd943247-1fe7-4c1b-ac08-de5eb4c5f126	Atum	442.46	243
b07fe039-7ef2-4298-be2c-312e5c2deb47	Sapatos	225.80	140
517756e6-eaf3-4114-b615-655bc62ea1ec	Carro	162.56	192
8e109261-0912-45cd-b8a6-98061c64184b	Atum	379.82	135
fd7c1190-18d5-4403-b1d7-b4f6b206d33f	Sapatos	155.72	607
1786adb7-0937-42f1-86ae-c75470bd3a40	Bicicleta	12.05	558
9ccdb12c-2200-47d0-af16-13b54bce9914	Queijo	494.45	478
338a32a1-4c5b-4c6b-8372-85666ac4e146	Mouse	426.65	270
5fb1466e-9c47-4e6e-ae18-82443af3fc0f	Computador	49.94	758
b219b6e4-13a0-4e71-8cda-bd5ae60c819f	Frango	368.23	949
72b4e40c-51b3-4659-9b2c-eb83e441f894	Peixe	33.36	261
d20b3701-e48f-481a-a997-6d3aade8c37a	Frango	177.86	997
4606aa38-17e9-4e73-a59a-6e4a844addd4	Peixe	121.72	112
7369d544-ddfb-4421-b82b-6ea75aebf40a	Luvas	196.85	969
83468d4e-43e9-4437-8834-db7aa5018b9b	Camiseta	175.37	492
9d3079ab-898c-4c42-9dd7-68fda1765d59	Peixe	34.60	388
96a3f4f2-bb8d-4e7a-9b9f-f2b374c82e25	Chapéu	153.26	274
294b0fda-5fed-4231-80ca-dfba0a571b98	Teclado	151.42	825
7b7fa4d8-0f93-4fa3-931b-0c2ce415efba	Salsicha	322.35	667
\.


--
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);


--
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- Name: cargos cargos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY (id);


--
-- Name: clientes clientes_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_cpf_key UNIQUE (cpf);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: colaboradores colaboradores_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.colaboradores
    ADD CONSTRAINT colaboradores_cpf_key UNIQUE (cpf);


--
-- Name: colaboradores colaboradores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.colaboradores
    ADD CONSTRAINT colaboradores_pkey PRIMARY KEY (id);


--
-- Name: fornecedores fornecedores_cnpj_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedores_cnpj_key UNIQUE (cnpj);


--
-- Name: fornecedores fornecedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedores_pkey PRIMARY KEY (id);


--
-- Name: fornecedores_produtos fornecedores_produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores_produtos
    ADD CONSTRAINT fornecedores_produtos_pkey PRIMARY KEY (id);


--
-- Name: notas_fiscais notas_fiscais_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notas_fiscais
    ADD CONSTRAINT notas_fiscais_codigo_key UNIQUE (codigo);


--
-- Name: notas_fiscais notas_fiscais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notas_fiscais
    ADD CONSTRAINT notas_fiscais_pkey PRIMARY KEY (id);


--
-- Name: pedido_produtos pedido_produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_produtos
    ADD CONSTRAINT pedido_produtos_pkey PRIMARY KEY (id);


--
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);


--
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);


--
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);


--
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);


--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: colaboradores colaboradores_cargo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.colaboradores
    ADD CONSTRAINT colaboradores_cargo_fkey FOREIGN KEY (cargo) REFERENCES public.cargos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fornecedores_produtos fornecedores_produtos_nota_fiscal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores_produtos
    ADD CONSTRAINT fornecedores_produtos_nota_fiscal_fkey FOREIGN KEY (nota_fiscal) REFERENCES public.notas_fiscais(codigo) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fornecedores_produtos fornecedores_produtos_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores_produtos
    ADD CONSTRAINT fornecedores_produtos_produto_fkey FOREIGN KEY (produto) REFERENCES public.produtos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pedido_produtos pedido_produtos_nota_fiscal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_produtos
    ADD CONSTRAINT pedido_produtos_nota_fiscal_fkey FOREIGN KEY (nota_fiscal) REFERENCES public.notas_fiscais(codigo) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pedido_produtos pedido_produtos_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_produtos
    ADD CONSTRAINT pedido_produtos_pedido_fkey FOREIGN KEY (pedido) REFERENCES public.pedidos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pedido_produtos pedido_produtos_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_produtos
    ADD CONSTRAINT pedido_produtos_produto_fkey FOREIGN KEY (produto) REFERENCES public.produtos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pedidos pedidos_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_cliente_fkey FOREIGN KEY (cliente) REFERENCES public.clientes(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: pedidos pedidos_colaborador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_colaborador_fkey FOREIGN KEY (colaborador) REFERENCES public.colaboradores(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

