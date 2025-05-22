import pandas as pd

# Load all necessary CSVs
orders = pd.read_csv("olist_orders_dataset.csv")
order_items = pd.read_csv("olist_order_items_dataset.csv")
customers = pd.read_csv("olist_customers_dataset.csv")
payments = pd.read_csv("olist_order_payments_dataset.csv")

# --------------------------
# STEP 1: CLEANING
# --------------------------

# Filter only 'delivered' orders
orders = orders[orders['order_status'] == 'delivered']

# Convert date columns to datetime
orders['order_purchase_timestamp'] = pd.to_datetime(orders['order_purchase_timestamp'])
orders['order_delivered_customer_date'] = pd.to_datetime(orders['order_delivered_customer_date'])

# Drop rows with null customer_id or missing delivery date
orders = orders.dropna(subset=['customer_id', 'order_delivered_customer_date'])

# Drop duplicates across datasets
orders.drop_duplicates(inplace=True)
order_items.drop_duplicates(inplace=True)
customers.drop_duplicates(inplace=True)
payments.drop_duplicates(inplace=True)

# --------------------------
# STEP 2: NORMALIZATION
# --------------------------

# Normalize payments: one row per order_id (aggregated)
payments_cleaned = payments.groupby("order_id").agg({
    "payment_type": lambda x: ', '.join(set(x)),  # concatenate payment types
    "payment_value": "sum"
}).reset_index()

# Normalize order_items: aggregate total price per order
order_items_cleaned = order_items.groupby("order_id").agg({
    "price": "sum",
    "freight_value": "sum"
}).reset_index()

# --------------------------
# STEP 3: FINAL CLEANED TABLES
# --------------------------

#  Clean Customers Table
customers_cleaned = customers[['customer_id', 'customer_unique_id', 'customer_zip_code_prefix', 'customer_city', 'customer_state']]

#  Clean Orders Table (remove unused columns)
orders_cleaned = orders[['order_id', 'customer_id', 'order_status', 'order_purchase_timestamp', 'order_delivered_customer_date']]

#  Merge Order Summary (orders + payments + items)
order_summary = orders_cleaned \
    .merge(order_items_cleaned, on='order_id', how='left') \
    .merge(payments_cleaned, on='order_id', how='left')

# --------------------------
# STEP 4: EXPORT TO CSV
# --------------------------

customers_cleaned.to_csv("cleaned_customers.csv", index=False)
orders_cleaned.to_csv("cleaned_orders.csv", index=False)
order_items_cleaned.to_csv("cleaned_order_items.csv", index=False)
payments_cleaned.to_csv("cleaned_payments.csv", index=False)
order_summary.to_csv("order_summary.csv", index=False)  # optional for Power BI or MySQL

print(" Data cleaned and saved as CSVs!")
