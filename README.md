# Cumulative Revenue Achievement Analysis

This SQL query computes the **daily cumulative revenue achievement percentage** by comparing the actual accumulated revenue against accumulated predicted targets.

## Objective

To calculate the **percentage of actual cumulative revenue achieved** relative to cumulative predicted revenue (`predict`) per day.

## Approach

The query performs the following steps:

1. **Combine actual revenue and predictions** using the `UNION ALL` operator:
   - Predicted data (with `revenue` set to `0`)
   - Actual revenue data (with `predict` set to `0`), calculated by joining the `order`, `product`, and `session` tables

2. **Aggregate data by date** to calculate daily totals of revenue and predicted values.

3. **Compute cumulative values** for both revenue and predictions using a window function (`SUM(...) OVER (ORDER BY date)`).

4. **Calculate the achievement percentage** using the formula:

       achievement_percentage = (acc_revenue / acc_predict) * 100



