/*
==================================================================================================================
DDL Script : Create Gold Views.
==================================================================================================================
script Purpose : This script creates views for the gold layer in the data warehouse. The gold layer represents the 
final dimension and fact tables.
===================================================================================================================
*/

===================================================================================================================
-- Create Dimension: gold.dim_customers
====================================================================================================================

if OBJECT_ID('gold.dim_customers' , 'v') is not null
		drop view gold.dim_customers;
go

create view gold.dim_customers as
select 
ROW_NUMBER() over(order by cst_id) customer_key,
ci.cst_id customer_id,
ci.cst_key customer_number,
ci.cst_firstname firstname,
ci.cst_lastname lastname,
la.cntry country,
ci.cst_marital_status marital_status,
case when ci.cst_gndr != null then ci.cst_gndr
		 else coalesce(ca.gndr,'n/a')
		 end gender,
ca.bdate birthdate,
ci.cst_create_date create_dt
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid
go


===================================================================================================================
-- Create Dimension: gold.dim_products
====================================================================================================================

if OBJECT_ID('gold.dim_products' , 'v') is not null
		drop view gold.dim_products;
go

create view gold.dim_products as
select 
ROW_NUMBER() over (order by pn.prd_start_dt, pn.prd_key ) product_key,
pn.prd_id product_id,
pn.prd_key product_number,
pn.prd_nm product_name,
pn.cat_id category_id,
pc.cat category,
pc.subcat subcategory,
pc.maintenance,
pn.prd_cost cost,
pn.prd_line product_line,
pn.prd_start_dt start_dt
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id
where prd_end_dt is null
go


===================================================================================================================
-- Create Dimension: gold.fact_sales
====================================================================================================================

if OBJECT_ID('gold.fact_sales' , 'v') is not null
		drop view gold.fact_sales;
go

create view gold.fact_sales as
select sls_ord_num,
pr.product_key,
cu.customer_key,
sd.sls_order_dt order_date,
sd.sls_ship_dt shipping_date,
sd.sls_due_dt due_date,
sd.sls_sales sales_amount,
sd.sls_quantity quantity,
sd.sls_price price
from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id 
