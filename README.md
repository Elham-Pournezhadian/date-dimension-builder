# Date Dimension Builder (DimDate for Multiple Calendars)

* Author: Ella (Elham) Pournezhadian
* Contact Links:  
    linkedin.com/in/elham-pournezhadian-2b57b3157  
    stackoverflow.com/users/6876710/el-hum
--------------------------------------------------
Current supported calendars:
- Gregorian
- Persian (Solar)

  
This repository contains a small, production-friendly implementation for generating a DimDate table or dataframe that supports both Gregorian and Persian (Jalali) calendars. It originally began as a utility for resolving persistent Persian date issues in operational systems, but has since been expanded and refined into a reusable data-engineering asset.

A well-designed DimDate is a core component of analytical and reporting environments. Although this project includes full Persian calendar support, that is only one example of the many date-level features a DimDate can provide. The structure is entirely extensible, allowing you to add any form of temporal attribute your environment requires — from fiscal periods and holiday markers to custom business rules or derived logic.

As mentioned in my Medium article, a DimDate is not just a data-warehouse concept. It can be just as valuable in production databases, where pre-computed date logic helps reduce repeated calculations, improves consistency across services, and supports clearer data modelling throughout the wider platform.


This project automates the creation of a complete date dimension for any given period, enriched with a wide range of attributes commonly required in:

* Data warehouses
* ETL / ELT pipelines
* Business intelligence models
* Time-based partitioning or aggregations
* Production databases that benefit from pre-computed date logic

---

## What This Repository Provides

### ✔ **A Date Dimension Table (SQL Server)**

SQL scripts generate a fully populated DimDate table containing:

* All Gregorian dates within a defined range
* Their equivalent Persian (Jalali) dates
* Day, month, year components (both calendars)
* Weekday number and names
* Flags and attributes useful for reporting (e.g., weekend/weekday)

The SQL implementation includes a Persian date conversion **function** plus the main **DimDate** population script.

---

### ✔ **A Python DataFrame Version**

For Python-based pipelines or notebook workflows, a script generates an equivalent dataframe using the `persiantools` library.

Attributes include:

* Gregorian & Persian components
* Calendar metadata
* Derived fields for analytics and modelling

This is suitable for ingestion into ETL pipelines, cloud data platforms, or feeding directly into model features.

---

## When You Might Use This

* Designing a warehouse or data mart from scratch
* Standardising date logic across multiple services
* Handling mixed-calendar datasets in production
* Ensuring consistent holiday or period calculations
* Avoiding repeated date logic in downstream systems

It’s particularly helpful in environments where Persian dates appear in transactional systems or logs, yet analysis and reporting are aligned to the Gregorian calendar.

---

## Usage

### **SQL Server**

1. Run the **`Function`** script first (Persian-to-Gregorian conversion logic).
2. Run the **`DimDate`** script to generate and populate the table.

---

### **Python**

Install the dependency:

```bash
python -m pip install persiantools
```

Then run the Python script to produce a fully populated dataframe.

---

## Notes

* Scripts are designed to be easily plugged into ETL workflows.
* The date range can be customised to suit your project requirements.
* The implementation is simple, deterministic, and suitable for production environments.

---

Please feel free to contribute.
Whether it’s improving the scripts, adding new date attributes, optimising performance, or extending support to other systems, all suggestions and pull requests are warmly welcomed.
If you spot something that can be refined or expanded, do jump in — it would be brilliant to see this grow into a more versatile resource for anyone working with mixed-calendar datasets.
