-- PROJECT QUESTION. 
-- Does showing a discount banner on the PlayStation Store homepage increase conversion and revenue, 
-- and does the effect vary by player segment (new vs returning, mobile vs console vs PC)?
-- Variant A is the control group with no banner. Varaint B has the banner
-- Key: Variant A = control (no banner), Variant B = banner.

-- 1. Amount of users who tested each variant and the amount of users that made a purchase

WITH purchases_and_variant AS(
SELECT 
    se.session_id, exp.user_id, exp.variant, pu.purchase_id
FROM
    sessions se
        JOIN
    exposures exp ON exp.user_id = se.user_id
		LEFT JOIN
	purchases pu ON se.session_id = pu.session_id)
    SELECT
		variant, COUNT(DISTINCT user_id) AS amount_of_users , COUNT(DISTINCT purchase_id) AS amount_of_purchases
	FROM
		purchases_and_variant
	GROUP BY
		variant;

-- 2. Percentage amount of purchases made in each variant
WITH purchases_and_variant AS(
SELECT 
    se.session_id, exp.user_id, exp.variant, pu.purchase_id
FROM
    sessions se
        JOIN
    exposures exp ON exp.user_id = se.user_id
		LEFT JOIN
	purchases pu ON se.session_id = pu.session_id)
SELECT
	variant, 100*COUNT(purchase_id) / COUNT(*) AS percentage_of_purchases_by_variant
FROM
	purchases_and_variant
GROUP BY variant;

-- 3. percentage of users who made a purchase via region in each variant
WITH region_and_variant AS(
SELECT 
    se.session_id, exp.user_id, exp.variant, pu.purchase_id, us.region
FROM
    sessions se
        JOIN
    exposures exp ON exp.user_id = se.user_id
		LEFT JOIN
	purchases pu ON se.session_id = pu.session_id
		JOIN
	users us ON us.user_id = exp.user_id)
SELECT
	variant,
	region,
    100*COUNT(purchase_id) / COUNT(*) AS percentage_of_purchases_by_variant_and_region
FROM
	region_and_variant
GROUP BY
	variant, region
ORDER BY percentage_of_purchases_by_variant_and_region DESC;

-- 4. percentage of users who made a purchase by variant and user type

WITH user_type_and_variant AS(
SELECT 
    se.session_id, exp.user_id, exp.variant, pu.purchase_id, us.user_type
FROM
    sessions se
        JOIN
    exposures exp ON exp.user_id = se.user_id
		LEFT JOIN
	purchases pu ON se.session_id = pu.session_id
		JOIN
	users us ON us.user_id = exp.user_id)
SELECT
	variant,
	user_type,
    100*COUNT(purchase_id) / COUNT(*) AS percentage_of_purchases_by_variant_and_user_type
FROM
	user_type_and_variant
GROUP BY
	variant, user_type
ORDER BY percentage_of_purchases_by_variant_and_user_type DESC;

-- 5. percentage of users who made a purchase via each device in each variant

WITH device_and_variant AS(
SELECT 
    se.session_id, exp.user_id, exp.variant, pu.purchase_id, us.device
FROM
    sessions se
        JOIN
    exposures exp ON exp.user_id = se.user_id
		LEFT JOIN
	purchases pu ON se.session_id = pu.session_id
		JOIN
	users us ON us.user_id = exp.user_id)
SELECT
	variant,
	device,
    100*COUNT(purchase_id) / COUNT(*) AS percentage_of_purchases_by_variant_and_device
FROM
	device_and_variant
GROUP BY
	variant, device
ORDER BY percentage_of_purchases_by_variant_and_device DESC;

-- 6. Did the banner increase or decrease revenue?

WITH banner_revenue AS(
SELECT
	p.*, exp.variant, (p.price_gbp-p.discount_gbp) AS revenue
FROM
	purchases p
		JOIN
	sessions s ON p.session_id = s.session_id
		JOIN
	exposures exp ON s.user_id = exp.user_id)
SELECT
	variant, SUM(revenue) AS total_revenue
FROM
	banner_revenue
GROUP BY
	variant;
    
-- 7 Are users with the banner returning more often?

WITH user_sessions AS (
  SELECT
    exp.user_id,
    exp.variant,
    se.session_id,
    se.session_ts,
    exp.exposure_ts
  FROM exposures exp
  JOIN sessions  se ON se.user_id = exp.user_id
  -- keep only sessions that occurred after the user was exposed
  WHERE se.session_ts >= exp.exposure_ts
),
per_user AS (
  SELECT
    user_id,
    variant,
    COUNT(DISTINCT session_id) AS session_count
  FROM user_sessions
  GROUP BY user_id, variant
)
SELECT
  variant,
  ROUND(AVG(session_count), 2) AS avg_sessions_per_user,
  ROUND(100.0 * SUM(session_count > 1) / COUNT(*), 2) AS pct_users_with_2plus_sessions
FROM per_user
GROUP BY variant
ORDER BY variant;
-- 8 Are users adding to cart more often in Variant B, and are they completing the purchase?
    
SELECT 
    exp.variant,
    COUNT(DISTINCT CASE
            WHEN ac.action_type = 'add_to_cart' THEN se.session_id
        END) AS sessions_with_atc,
    COUNT(DISTINCT CASE
            WHEN ac.action_type = 'purchase' THEN se.session_id
        END) AS sessions_with_purchase
FROM
    sessions se
        JOIN
    exposures exp ON se.user_id = exp.user_id
        LEFT JOIN
    actions ac ON se.session_id = ac.session_id
GROUP BY exp.variant;

	
	
