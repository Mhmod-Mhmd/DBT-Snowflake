select lower(current_account()), current_user(), lower(current_region());


-- create user for dbt
create user dbt_user
password = 'dbt_pass'
login_name = 'dbt_user'
DEFAULT_ROLE = ACCOUNTADMIN
MUST_CHANGE_PASSWORD = False
COMMENT = 'User for Data Engineering tasks';

-- alter user dbt_user set DEFAULT_ROLE = PUBLIC;

-- grant ACCOUNTADMIN role to dbt_user 
grant role ACCOUNTADMIN TO USER dbt_user;

-- list all users in snowflake
show users

-- list details about a specific user
describe user dbt_user;

-- grant warehouse access to role
grant usage on warehouse finance_wh to ROLE ACCOUNTADMIN;

-- grant database access to role 
grant usage on database finance_db to ROLE ACCOUNTADMIN;
grant usage on schema finance_db.raw to ROLE ACCOUNTADMIN;
grant usage on schema finance_db.dwh to ROLE ACCOUNTADMIN;

-- grant table access to role 
grant update, delete, select, insert on all tables in schema finance_db.raw to role ACCOUNTADMIN;

grant update, delete, select, insert on all tables in schema finance_db.dwh to role ACCOUNTADMIN;


-- Create database
create or replace warehouse finance_wh
with
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;


-- create database
CREATE OR REPLACE DATABASE finance_db;

-- create schema
CREATE OR REPLACE SCHEMA raw;
CREATE OR REPLACE SCHEMA dwh;

-- create tables [customers, orders, order_items, products]
CREATE OR REPLACE TABLE raw.customers(
    id int primary key,
    name varchar(50),
    email varchar(50),
    country varchar(70)
);

CREATE OR REPLACE TABLE raw.order_items(
    id int primary key,
    order_id int,
    product_id int,
    quantity int,
    unit_price int
);

CREATE OR REPLACE TABLE raw.orders(
    id int primary key,
    customer_id int,
    order_date date,
    total_amount int,
    status varchar(20)
);

CREATE OR REPLACE TABLE raw.products(
    id int primary key,
    name string(50),
    category string(20),
    price int
);


-- create stage for uploading data 
CREATE OR REPLACE stage finance_stage
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);

COPY INTO raw.customers
from @finance_stage/customers
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);


COPY INTO raw.orders
from @finance_stage/orders
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);

COPY INTO raw.products
from @finance_stage/products
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);

COPY INTO raw.order_items
from @finance_stage/order_items
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);
