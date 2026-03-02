# 🐾 PawPal Pet Supplies — Relational Database System

**Data Management Project** | MSc Data Science & Advanced Analytics | NOVA IMS

## Overview

Designed and implemented a complete **relational database system** for a fictional pet supplies e-commerce business. The project covers the full lifecycle: schema design, data modeling, business analytics queries, automated triggers, and invoice generation via SQL views and Excel VBA.

## Database Schema

**10+ tables** with full referential integrity:

`customers` · `orders` · `order_details` · `products` · `categories` · `suppliers` · `payment_transactions` · `ratings` · `shipping_methods` · `log_table`

Plus 2 SQL Views: `vw_invoice_header` and `vw_invoice_details`

## Key Components

### Schema Design
- Normalized relational model (3NF) with proper foreign keys, indexes, and constraints
- ENUM types for order status and payment methods
- Audit logging via `log_table`

### Business Analytics (SQL Queries)
Five business-oriented queries answering real CEO-level questions:
1. **Top 5 Best-Selling Products** — Multi-table JOINs, GROUP BY, aggregations
2. **Monthly Revenue Trend** — Date functions, YoY comparison
3. **Top 5 Customers by Spending** — Customer lifetime value analysis
4. **Satisfaction by Category** — AVG ratings, HAVING filters
5. **Stock Reorder Alerts** — Inventory management with calculated margins

### Triggers
- `trg_validate_stock_before_sale` — Validates stock availability before order insertion
- `trg_update_stock_after_sale` — Automatically decrements stock on sale
- `trg_log_product_update` — Audit trail for price, stock, and status changes

### Invoice System
- SQL Views generate invoices dynamically from order data (not stored separately)
- Excel VBA macro for formatted invoice output (PT and EN versions)
- Calculated fields: subtotals, discounts, VAT (23%), grand totals

## Tech Stack

`MySQL` · `SQL` · `MySQL Workbench` · `Excel VBA`

## Project Structure

```
├── pawpal_database.sql      # Full database schema (DDL)
├── loading_data.sql         # Sample data insertion (DML)
├── invoice.sql              # Invoice views
├── triggers.sql             # Stock & audit triggers
├── Question_1.sql           # Top selling products
├── Question_2.sql           # Monthly revenue trends
├── Question_3.sql           # VIP customer analysis
├── Question_4.sql           # Category satisfaction ratings
├── Question_5.sql           # Stock reorder alerts
├── PawPal_Invoice_Generator.xlsm  # Excel VBA invoice tool
├── schema.mwb               # MySQL Workbench model
└── schema.png               # ER diagram
```
