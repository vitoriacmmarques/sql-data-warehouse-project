/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.

Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.
===============================================================================
*/

DELIMITER $$
CREATE PROCEDURE silver.load_silver()
BEGIN
    DECLARE batch_start_time DATETIME;
    DECLARE batch_end_time DATETIME;

    -- Start batch process
    SET batch_start_time = NOW();
    
    -- Loading silver.crm_cust_info
    DELETE FROM silver.crm_cust_info;
    INSERT INTO silver.crm_cust_info (
        cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END AS cst_marital_status,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END AS cst_gndr,
        cst_create_date
    FROM bronze.crm_cust_info;
    
    -- Loading silver.crm_prd_info
    DELETE FROM silver.crm_prd_info;
    INSERT INTO silver.crm_prd_info (
        prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
        SUBSTRING(prd_key, 7) AS prd_key,
        prd_nm,
        IFNULL(prd_cost, 0) AS prd_cost,
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,
        prd_start_dt,
        NULL AS prd_end_dt -- End date logic needs adaptation for MySQL
    FROM bronze.crm_prd_info;
    
    -- Loading silver.crm_sales_details
    DELETE FROM silver.crm_sales_details;
    INSERT INTO silver.crm_sales_details (
        sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        STR_TO_DATE(sls_order_dt, '%Y%m%d') AS sls_order_dt,
        STR_TO_DATE(sls_ship_dt, '%Y%m%d') AS sls_ship_dt,
        STR_TO_DATE(sls_due_dt, '%Y%m%d') AS sls_due_dt,
        IF(sls_sales IS NULL OR sls_sales <= 0, sls_quantity * ABS(sls_price), sls_sales) AS sls_sales,
        sls_quantity,
        IF(sls_price IS NULL OR sls_price <= 0, sls_sales / NULLIF(sls_quantity, 0), sls_price) AS sls_price
    FROM bronze.crm_sales_details;
    
    -- Loading silver.erp_cust_az12
    DELETE FROM silver.erp_cust_az12;
    INSERT INTO silver.erp_cust_az12 (
        cid, bdate, gen
    )
    SELECT
        IF(cid LIKE 'NAS%', SUBSTRING(cid, 4), cid) AS cid,
        IF(bdate > NOW(), NULL, bdate) AS bdate,
        CASE 
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END AS gen
    FROM bronze.erp_cust_az12;
    
    -- Loading silver.erp_loc_a101
    DELETE FROM silver.erp_loc_a101;
    INSERT INTO silver.erp_loc_a101 (
        cid, cntry
    )
    SELECT
        REPLACE(cid, '-', '') AS cid,
        CASE 
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END AS cntry
    FROM bronze.erp_loc_a101;
    
    -- Loading silver.erp_px_cat_g1v2
    DELETE FROM silver.erp_px_cat_g1v2;
    INSERT INTO silver.erp_px_cat_g1v2 (
        id, cat, subcat, maintenance
    )
    SELECT id, cat, subcat, maintenance FROM bronze.erp_px_cat_g1v2;
    
    -- End batch process
    SET batch_end_time = NOW();
END $$
DELIMITER ;
