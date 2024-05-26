# Shopping Mall Sales Data Analysis

## Overview
This project involves analyzing sales data from a shopping mall using SQL queries. The dataset used can be found [here](https://www.kaggle.com/datasets/sartazansari/sales-and-customer-data). The dataset has been formatted to utilize the secure file priv.

***Note:** The original dataset is provided by [DataCEO](https://www.kaggle.com/dataceo) in Kaggle and can be found [here](https://www.kaggle.com/datasets/dataceo/sales-and-customer-data). Credit goes to the dataset provider for making it available.*

## Dataset
The dataset consists of two CSVs:

* `sales_data`: Contains information about sales transactions, including invoice number, customer ID, category, quantity, price, invoice date, and shopping mall.
* `customer_data`: Contains demographic information about customers, including customer ID, gender, age, and payment method.

## Prerequisites
1. MySQL Server: Download and install from [mysql.com](https://dev.mysql.com/downloads/mysql/).
2. Any MySQL client or Code editor that supports MySQL through plugins or extensions.

## Setup Instructions
1. Ensure you have MySQL Server 8.3 or higher installed on your system.
2. Open MySQL Workbench or any MySQL client tool.
3. **[Optional]** If you are using VSCode
    * If you are using VSCode with [MySQL by Jun Han](https://marketplace.visualstudio.com/items?itemName=formulahendry.vscode-mysql) extension then create a new user with old authentication type as the extension does't support new authentication type as of now.
        ```bash
        CREATE USER 'user'@'localhost' IDENTIFIED with mysql_native_password by 'password';
        GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';
        FLUSH PRIVILEGES;
        ```
    * If you are using VSCode with any other extension that supports new authentication type then you can proceed using new authentication type.
        ```bash
        CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';
        GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';
        FLUSH PRIVILEGES;
        ```
5. Download the [dataset](https://www.kaggle.com/datasets/sartazansari/sales-and-customer-data) from Kaggle.
4. Place it in the location specified by your MySQL server's secure file privilege setting. You can find the path by executing
    ```bash
    SHOW VARIABLES LIKE 'secure_file_priv';
    ```

***Note:** Make sure to adjust file paths in the `LOAD DATA INFILE` statements according to your local file system.*

## SQL Queries
The SQL queries provided below perform various analyses on the sales data:

* **Creating Database and Tables:** Defines the database schema and creates tables for storing sales and customer data.
* **Loading Data into Tables:** Loads data from CSV files into the respective tables in the database.
* **Exploratory Data Analysis:** Performs exploratory analysis on the sales data.
* **Analytical Queries:** Performs various analytical queries to gain insights into sales trends, customer demographics, and more.

## Example Queries
Here are some example SQL queries included in the project:

* Total revenue of shopping malls
* Total revenue by shopping malls
* Total revenue by category
* Total revenue by gender
* Total revenue by age
* Total revenue by payment methods
* Average sales of shopping malls
* Average sales by shopping malls
* Average sales by category
* Average sales by gender
* Average sales by age
* Average sales by payment method
* Yearly and monthly sales trends
* Weekly sales by shopping malls, category, gender, and payment method
* Total number of customers
* Top 5 and bottom 5 customers based on total purchases
* Customer demographics with their spendings

Feel free to modify and extend the queries based on your analysis requirements.