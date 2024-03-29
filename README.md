# Ecommerce Invoice Analysis
## :scroll: Summary

The objective of this project is to explore the invoice data of an e-commerce business in 2010-2011 to generate actionable insights for the business. A variety of SQL techniques such as window functions, CTEs, joins, and subqueries are applied throughout this project. After cleaning and modelling the dataset using SQL, insights will be visualised in dashboards and summary reports using Tableau. 

Lack of context is the biggest challenge for this project because there were not any types of data dictionaries to explain the data contained in each field. Therefore, incorrect interpretations of data in this project are inevitable and open to feedback.


##  :bookmark_tabs: Repository directory
#### [01. Source](https://github.com/phuongtk/Ecommerce-Invoice-Analysis/tree/b5495ddf4d5b229c9be2bb3cc5c1391c97abcf01/01.%20Source)
This directory consists of 2 CSV files:
- The **original dataset** retrieved from DataDNA Dataset Challenges of Onyx Data (August 2021 challenge) titled Ecommerce Business Dataset. This data was made available by Dr Daqing Chen, Director: Public Analytics group. chend ‘@’ lsbu.ac.uk, School of Engineering, London South Bank University, London SE1 0AA, UK.
- The **clean dataset** which will be used for analysis.

#### [02. Data cleaning](https://github.com/phuongtk/Ecommerce-Invoice-Analysis/tree/b5495ddf4d5b229c9be2bb3cc5c1391c97abcf01/02.%20Data%20cleaning)
This directory contains the SQL text file that transforms the original dataset into a clean dataset for analysing and exploration. This file has been thoroughly annotated, making it easy to follow my thought process. The SQL script is written with PostgreSQL.

#### [03. Data exploration](https://github.com/phuongtk/Ecommerce-Invoice-Analysis/tree/b5495ddf4d5b229c9be2bb3cc5c1391c97abcf01/03.%20Data%20exloration)
This directory contains the SQL text file that explores the clean dataset to generate insights. This file has been thoroughly annotated, making it easy to follow my thought process. I explored 3 topics using this dataset: distribution of quantity purchased per product, discounts, and sales associated with Christmas. The SQL script is written with PostgreSQL.

#### [04. Dashboard_Invoice analytics](https://github.com/phuongtk/Ecommerce-Invoice-Analysis/tree/b5495ddf4d5b229c9be2bb3cc5c1391c97abcf01/04.%20Dashboard_Invoice%20analytics)
This directory contains a link to a Tableau dashboard titled _Ecommerce Business Invoice Analytics_ along with a short description explaining the applications of this dashboard. The data source for this dashboard is the cleaned dataset.

#### [05. Report_Christmas sales trend](https://github.com/phuongtk/Ecommerce-Invoice-Analysis/tree/b5495ddf4d5b229c9be2bb3cc5c1391c97abcf01/05.%20Report_Christmas%20sales%20trend)
This directory contains a link to a Tableau report titled _Christmas Sales Trends - Ecommerce Business_ along with a short description explaining the applications of this report. The data source for this report is tables modelled using SQL queries in [directory 03](https://github.com/phuongtk/Ecommerce-Invoice-Analysis/tree/b5495ddf4d5b229c9be2bb3cc5c1391c97abcf01/03.%20Data%20exloration).

#### [06. RFM analysis](https://github.com/phuongtk/Ecommerce-Invoice-Analysis/tree/22083d3dfaa5fc28935b98cf1e482951e360cc7e/06.%20RFM%20analysis)
This directory contains an SQL text file that models the clean dataset for RFM analysis and a Markdown file that explain the modelling process, and conclusions of the RFM analysis along with the link to a dashboard and how to use it for analysis. The SQL script is written with MySQL.

## ✅ Contact
I would appreciate any feedback to improve my data analysis skills.
Feel free to reach out to me through my email phuongtk.work@gmail.com or my [Linkedin](https://www.linkedin.com/in/khanhphuongtran/).
