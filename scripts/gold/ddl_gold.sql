-- CREATING the gold object Product  information (Dimension table)

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pif.prd_start_dt, pif.prd_key) AS product_key,
	pif.prd_id AS product_id,
	pif.prd_key AS product_number,
	pif.prd_name AS product_name,
	pif.cat_id AS category_id,
	pdf.cat AS category,
	pdf.subcat AS subcategory,
	pdf.maintenance,
	pif.prd_cost AS cost,
	pif.prd_line AS product_line,
	pif.prd_start_dt AS start_date

FROM silver.crm_prd_info pif
LEFT JOIN silver.erp_px_cat_g1v2 pdf
ON pif.cat_id = pdf.id

WHERE pif.prd_end_dt IS NULL -- Filtering out all historical data

-- CREATING the gold object customer information (Dimension table)


CREATE VIEW gold.dim_customers AS  -- Gold layer creation of view. dimension table
SELECT
		ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS first_name,
		ci.cst_lastname AS last_name,
		la.cntry AS country,
		ci.cst_marital_status AS marital_status,
		CASE WHEN ci.cst_gender !='n/a' THEN ci.cst_gender -- CRM is the master for Gender info
		ELSE COALESCE(ca.gen , 'n/a')
		END AS gender,
		ca.bdate AS birthdate,
		ci.cst_create_date AS create_date
		
		
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid

-- Creating the gold object Fact Table for Sales

CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM SILVER.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prod_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id
