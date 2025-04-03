/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_customers;

-- Creating a view for the customer dimension
CREATE VIEW gold.dim_customers AS
SELECT
    ci.cst_id                          AS customer_id,  -- Unique identifier for the customer
    ci.cst_key                         AS customer_number,  -- Business key for the customer
    ci.cst_firstname                   AS first_name,  -- Customer's first name
    ci.cst_lastname                    AS last_name,  -- Customer's last name
    la.cntry                           AS country,  -- Country of residence
    ci.cst_marital_status              AS marital_status,  -- Marital status of the customer
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  -- Use gender from CRM if available
        ELSE COALESCE(ca.gen, 'n/a')  			   -- Otherwise, use ERP data
    END                                AS gender,
    ca.bdate                           AS birthdate,  -- Customer's date of birth
    ci.cst_create_date                 AS create_date  -- Date when the customer was created in the system
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid  -- Joining with ERP customer data
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;  -- Joining with location data

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_products;

-- Creating a view for the product dimension
CREATE VIEW gold.dim_products AS
SELECT
    pn.prd_id       AS product_id,  -- Unique identifier for the product
    pn.prd_key      AS product_number,  -- Business key for the product
    pn.prd_nm       AS product_name,  -- Name of the product
    pn.cat_id       AS category_id,  -- Category identifier
    pc.cat          AS category,  -- Product category
    pc.subcat       AS subcategory,  -- Product subcategory
    pc.maintenance  AS maintenance,  -- Maintenance status of the product
    pn.prd_cost     AS cost,  -- Cost of the product
    pn.prd_line     AS product_line,  -- Product line identifier
    pn.prd_start_dt AS start_date  -- Date when the product became active
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id  -- Joining with category data
WHERE pn.prd_end_dt IS NULL;  -- Excluding historical (inactive) products

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
DROP VIEW IF EXISTS gold.fact_sales;

-- Creating a view for the sales fact table
CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,  -- Unique order identifier
    pr.product_key  AS product_key,  -- Foreign key to the product dimension
    cu.customer_key AS customer_key,  -- Foreign key to the customer dimension
    sd.sls_order_dt AS order_date,  -- Date when the order was placed
    sd.sls_ship_dt  AS shipping_date,  -- Date when the order was shipped
    sd.sls_due_dt   AS due_date,  -- Expected delivery date
    sd.sls_sales    AS sales_amount,  -- Total sales amount for the order
    sd.sls_quantity AS quantity,  -- Quantity of products sold
    sd.sls_price    AS price  -- Price per unit of product
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number  -- Linking sales to products
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;  -- Linking sales to customers
