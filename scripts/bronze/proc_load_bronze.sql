/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

DELIMITER //

DROP PROCEDURE IF EXISTS bronze.load_bronze; 

CREATE PROCEDURE bronze.load_bronze()
BEGIN
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE batch_start_time DATETIME;
    DECLARE batch_end_time DATETIME;

    SET batch_start_time = NOW();

    -- CRM Tables
    SET start_time = NOW();
    TRUNCATE TABLE bronze.crm_cust_info;
    LOAD DATA LOCAL INFILE '/home/vitoria/Área de Trabalho/Projetos/DataWarehouseProject/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
    INTO TABLE bronze.crm_cust_info
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para crm_cust_info: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;

    SET start_time = NOW();
    TRUNCATE TABLE bronze.crm_prd_info;
    LOAD DATA LOCAL INFILE '/home/vitoria/Área de Trabalho/Projetos/DataWarehouseProject/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
    INTO TABLE bronze.crm_prd_info
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para crm_prd_info: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para crm_sales_details: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;

    -- ERP Tables
    SET start_time = NOW();
    TRUNCATE TABLE bronze.erp_loc_a101;
    LOAD DATA LOCAL INFILE '/home/vitoria/Área de Trabalho/Projetos/DataWarehouseProject/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
    INTO TABLE bronze.erp_loc_a101
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para erp_loc_a101: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;

    SET start_time = NOW();
    TRUNCATE TABLE bronze.erp_cust_az12;
    LOAD DATA LOCAL INFILE '/home/vitoria/Área de Trabalho/Projetos/DataWarehouseProject/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
    INTO TABLE bronze.erp_cust_az12
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para erp_cust_az12: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;

    SET start_time = NOW();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    LOAD DATA LOCAL INFILE '/home/vitoria/Área de Trabalho/Projetos/DataWarehouseProject/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
    INTO TABLE bronze.erp_px_cat_g1v2
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para erp_px_cat_g1v2: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;

    SET batch_end_time = NOW();
    SELECT CONCAT('Tempo total de carga: ', TIMESTAMPDIFF(SECOND, batch_start_time, batch_end_time), ' segundos') AS status;

END //

DELIMITER ;

    SET start_time = NOW();
    TRUNCATE TABLE bronze.crm_sales_details;
    LOAD DATA LOCAL INFILE '/home/vitoria/Área de Trabalho/Projetos/DataWarehouseProject/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
    INTO TABLE bronze.crm_sales_details
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para crm_sales_details: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;

    -- ERP Tables
    SET start_time = NOW();
    TRUNCATE TABLE bronze.erp_loc_a101;
    LOAD DATA LOCAL INFILE '/home/vitoria/Área de Trabalho/Projetos/DataWarehouseProject/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
    INTO TABLE bronze.erp_loc_a101
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para erp_loc_a101: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;

    SET start_time = NOW();
    TRUNCATE TABLE bronze.erp_cust_az12;
    LOAD DATA LOCAL INFILE '/home/vitoria/Área de Trabalho/Projetos/DataWarehouseProject/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
    INTO TABLE bronze.erp_cust_az12
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para erp_cust_az12: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;

    SET start_time = NOW();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    LOAD DATA LOCAL INFILE '/home/vitoria/Área de Trabalho/Projetos/DataWarehouseProject/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
    INTO TABLE bronze.erp_px_cat_g1v2
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    SET end_time = NOW();
    SELECT CONCAT('Tempo de carga para erp_px_cat_g1v2: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' segundos') AS status;

    SET batch_end_time = NOW();
    SELECT CONCAT('Tempo total de carga: ', TIMESTAMPDIFF(SECOND, batch_start_time, batch_end_time), ' segundos') AS status;

END //

DELIMITER ;
