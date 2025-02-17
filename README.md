# Retail_orders_python_sql
# Retail Orders Data Processing and SQL Analysis

## Project Overview
This project focuses on downloading, cleaning, and transforming a retail orders dataset from Kaggle. The processed data is then loaded into a PostgreSQL database, where various SQL queries are executed for analytical insights.

## Dataset Information
- **Source**: Kaggle Dataset - [Retail Orders](https://www.kaggle.com/datasets/ankitbansal06/retail-orders)
- **License**: CC0-1.0
- **File Format**: CSV
- **Key Columns**: Order ID, Order Date, Ship Mode, Segment, Country, State, Region, Product ID, Cost Price, List Price, Quantity, Discount Percent, etc.

## Data Processing Steps
1. **Downloading the Dataset**: The dataset was retrieved from Kaggle using the Kaggle API.
2. **Handling Missing Values**:
   - The 'Ship Mode' column contained missing and inconsistent values (e.g., 'Not Available', 'unknown'), which were replaced with `NaN` for better processing.
3. **Column Formatting**:
   - Column names were standardized by converting them to lowercase and replacing spaces with underscores.
4. **Feature Engineering**:
   - `sales_price` was calculated using the formula:
     ```
     sales_price = (list_price * (100 - discount_percent)) / 100
     ```
   - `profit` was derived as:
     ```
     profit = sales_price - cost_price
     ```
5. **Data Type Conversion**:
   - The 'order_date' column was converted to the `datetime` format.

## Data Transfer to PostgreSQL
1. **Database Connection**:
   - Established a connection with PostgreSQL using SQLAlchemy.
2. **Data Insertion**:
   - The cleaned DataFrame was inserted into a table named `orders` within the PostgreSQL database.

## SQL Analysis
Various SQL queries were executed to derive business insights from the dataset. These include:

1. **Top 10 Highest Revenue-Generating Products**:
   - Identifies products that contributed the most to sales revenue.
2. **Top 5 Best-Selling Products in Each Region**:
   - Uses a common table expression (CTE) and ranking function to determine the top products by region.
3. **Month-over-Month Sales Growth Comparison (2022 vs 2023)**:
   - Compares monthly sales figures across the two years.
4. **Best Sales Month for Each Category**:
   - Determines which month had the highest sales for each product category.
5. **Sub-Category with the Highest Profit Growth (2023 vs 2022)**:
   - Identifies the sub-category that experienced the highest increase in profit between 2022 and 2023.

## Files Included
- **retail_orders_analysis.ipynb**: Jupyter Notebook containing the data processing, transformations, and SQL execution steps.
- **orders.csv**: The original dataset downloaded from Kaggle.
- **cleaned_orders.csv**: Processed dataset ready for database insertion.

## Conclusion
This project demonstrates a complete data pipeline, from data extraction and cleaning to database insertion and SQL-based analysis. The insights derived from the SQL queries provide valuable business intelligence on sales trends and product performance.

