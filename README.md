# Nashville Housing Data Cleaning 🏡

A comprehensive project dedicated to cleaning and transforming the Nashville Housing dataset using SQL, preparing it for robust analysis and reporting.

## ✨ Features

*   **🧹 Data Standardization:** Converts and standardizes various fields like `SaleDate` and `SoldAsVacant` for consistency.
*   **🗑️ Duplicate Removal:** Identifies and eliminates duplicate rows to ensure data integrity.
*   **🏠 Address Parsing:** Breaks down complex address strings into individual components (Address, City, State) for easier analysis.
*   **🎯 Null Value Handling:** Populates missing `PropertyAddress` values using self-joins where a corresponding `ParcelID` exists.
*   **🏷️ Column Renaming:** Renames ambiguous columns to more descriptive and user-friendly names.


## 🚀 Installation Guide

To get started with this project, you'll need a SQL database (e.g., SQL Server, MySQL, PostgreSQL) and a client to run SQL queries.

### Prerequisites

*   A SQL Database Management System (DBMS)
*   A SQL client or IDE (e.g., SSMS, DBeaver, MySQL Workbench)

### Step-by-Step Installation

1.  **Clone the Repository:**
    First, clone this repository to your local machine using Git:

    ```bash
    git clone https://github.com/teresathuduong/nashville-housing-data-cleaning.git
    cd nashville-housing-data-cleaning
    ```

2.  **Import the Dataset:**
    Load the `Nashville Housing Data for Data Cleaning (csv).csv` file into your SQL database. Create a new table (e.g., `NashvilleHousing`) and import the CSV data into it. Ensure column data types are appropriate (e.g., `NVARCHAR` for text, `DATE` for dates, `FLOAT` for numerical values).

    *Example for SQL Server (using SSMS Import/Export Wizard):*
    1.  Right-click on your database -> Tasks -> Import Flat File...
    2.  Browse to `Nashville Housing Data for Data Cleaning (csv).csv`.
    3.  Follow the wizard to create a new table (e.g., `NashvilleHousing`) and import the data.

3.  **Execute the SQL Script:**
    Open the `Data Cleaning - Nashville Housing Data.sql` file in your SQL client. Connect to the database where you imported the CSV data and execute the entire script. The script will perform all the data cleaning and transformation steps.

    ```sql
    -- Open Data Cleaning - Nashville Housing Data.sql in your SQL client
    -- Ensure you are connected to the correct database
    -- Execute all queries in the script sequentially
    ```


## 💡 Usage Examples

After successfully executing the SQL script, your `NashvilleHousing` table (or a newly created cleaned table, depending on the script's final steps) will contain the transformed data.

### Basic Data Exploration

You can now query the cleaned data for analysis. For instance, to see the first few rows of the cleaned data:

```sql
SELECT TOP 10 *
FROM NashvilleHousing;
```

### Checking for Duplicates (After Cleaning)

The script includes steps to remove duplicates. You can verify this by running a query to count remaining duplicates:

```sql
SELECT ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference, COUNT(*)
FROM NashvilleHousing
GROUP BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
HAVING COUNT(*) > 1;
-- This query should ideally return an empty result set after cleaning.
```

### Examining Standardized `SoldAsVacant` Field

To see the standardized `SoldAsVacant` column with 'Yes' and 'No' values:

```sql
SELECT DISTINCT SoldAsVacant, COUNT(*) AS Count
FROM NashvilleHousing
GROUP BY SoldAsVacant;
```


