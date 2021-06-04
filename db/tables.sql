CREATE SCHEMA import_data;

--create sequences

CREATE SEQUENCE import_data.customer_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE import_data.order_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE import_data.category_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE import_data.city_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE import_data.subcategory_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE import_data.product_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE import_data.state_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE import_data.order_product_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

-- create tables
--CREATE TYPE segment_enum as ENUM('Consumer', 'Corporate', 'Home Office');
CREATE TABLE import_data.customers(
    id INTEGER DEFAULT nextval('import_data.customer_id_seq'::regclass) NOT NULL,
    code VARCHAR(40) NOT NULL,
    name VARCHAR(50) NOT NULL,
    segment TEXT NOT NULL
);

CREATE TABLE import_data.categories(
    id INTEGER DEFAULT nextval('import_data.category_id_seq'::regclass) NOT NULL,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE import_data.subcategories(
    id INTEGER DEFAULT nextval('import_data.subcategory_id_seq'::regclass) NOT NULL,
    category_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE import_data.products(
    id INTEGER DEFAULT nextval('import_data.product_id_seq'::regclass) NOT NULL,
    code VARCHAR(40) NOT NULL,
    category_id INTEGER NOT NULL,
    subcategory_id INTEGER NOT NULL,
    name VARCHAR(150) NOT NULL
);

--CREATE TYPE region_enum as ENUM('South', 'West', 'Central', 'East');
CREATE TABLE import_data.states(
    id INTEGER DEFAULT nextval('import_data.state_id_seq'::regclass) NOT NULL,
    name VARCHAR(50) NOT NULL,
    region TEXT NOT NULL
);

CREATE TABLE import_data.cities(
    id INTEGER DEFAULT nextval('import_data.city_id_seq'::regclass) NOT NULL,
    state_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    postal_code INTEGER NOT NULL
);

--CREATE TYPE ship_mode_enum AS ENUM('Standard Class','Second Class','First Class','Same Day');
CREATE TABLE import_data.orders(
    id INTEGER DEFAULT nextval('import_data.order_id_seq'::regclass) NOT NULL,
    code VARCHAR(40) NOT NULL,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    ship_date DATE NOT NULL,
    ship_mode TEXT NOT NULL,
    state_id INTEGER NOT NULL,
    city_id INTEGER NOT NULL
);

CREATE TABLE import_data.order_products(
    id INTEGER DEFAULT nextval('import_data.order_product_id_seq'::regclass) NOT NULL,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    sales NUMERIC NOT NULL,
    discount NUMERIC NOT NULL,
    quantity INTEGER NOT NULL,
    profit NUMERIC NOT NULL
);


-- add constraints--
--add PK

ALTER TABLE ONLY import_data.customers
	ADD CONSTRAINT customer_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY import_data.categories
	ADD CONSTRAINT category_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY import_data.subcategories
	ADD CONSTRAINT subcategory_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY import_data.states
	ADD CONSTRAINT state_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY import_data.cities
	ADD CONSTRAINT city_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY import_data.products
	ADD CONSTRAINT product_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY import_data.orders
	ADD CONSTRAINT order_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY import_data.order_products
	ADD CONSTRAINT order_product_id_pk PRIMARY KEY (id);


-- ADD fk in the tables

ALTER TABLE ONLY import_data.subcategories
    ADD CONSTRAINT subcategory_cat_id_fk FOREIGN KEY (category_id)
    REFERENCES import_data.categories(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY import_data.products
    ADD CONSTRAINT product_category_id_fk FOREIGN KEY (category_id)
    REFERENCES import_data.categories(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY import_data.products
    ADD CONSTRAINT product_subcategory_id_fk FOREIGN KEY (subcategory_id)
    REFERENCES import_data.subcategories(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY import_data.cities
    ADD CONSTRAINT city_state_id_fk FOREIGN KEY (state_id)
    REFERENCES import_data.states(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY import_data.orders
    ADD CONSTRAINT order_customer_id_fk FOREIGN KEY (customer_id)
    REFERENCES import_data.customers(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY import_data.orders
    ADD CONSTRAINT order_state_id_fk FOREIGN KEY (state_id)
    REFERENCES import_data.states(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY import_data.orders
    ADD CONSTRAINT order_city_id_fk FOREIGN KEY (city_id)
    REFERENCES import_data.cities(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY import_data.order_products
    ADD CONSTRAINT order_product_id_fk FOREIGN KEY (order_id)
    REFERENCES import_data.orders(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY import_data.order_products
    ADD CONSTRAINT product_order_id_fk FOREIGN KEY (product_id)
    REFERENCES import_data.products(id) ON UPDATE CASCADE ON DELETE CASCADE;