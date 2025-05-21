-- Combine actual revenue and predicted targets into one dataset
WITH revenue_and_predict AS (
  -- Select daily prediction (with revenue as 0)
  SELECT
    rp.date,
    0 AS revenue,
    rp.predict
  FROM
    `data-analytics-mate.DA.revenue_predict` rp

  UNION ALL

  -- Select actual revenue (with prediction as 0)
  SELECT
    s.date,
    SUM(p.price) AS revenue,
    0 AS predict
  FROM
    `data-analytics-mate.DA.order` o
  JOIN
    `data-analytics-mate.DA.product` p
  USING (item_id)
  JOIN
    `data-analytics-mate.DA.session` s
  USING (ga_session_id)
  GROUP BY
    s.date
),

-- Aggregate revenue and predictions per day
daily AS (
  SELECT
    date,
    SUM(revenue) AS daily_revenue,
    SUM(predict) AS daily_predict
  FROM
    revenue_and_predict
  GROUP BY
    date
),

-- Calculate cumulative (accumulated) revenue and predictions
acc AS (
  SELECT
    date,
    SUM(daily_revenue) OVER (ORDER BY date) AS acc_revenue,
    SUM(daily_predict) OVER (ORDER BY date) AS acc_predict
  FROM
    daily
)

-- Final result: daily cumulative revenue, prediction, and achievement %
SELECT
  date,
  acc_revenue,
  acc_predict,
  acc_revenue / acc_predict * 100 AS achievement_percentage
FROM
  acc
ORDER BY
  1
