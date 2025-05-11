# My SQL Project: U.S. Baby Names Analysis

📌 Summary Business Case

This project delves into over a century of U.S. baby naming trends using SQL. By analyzing data from the U.S. Social Security Administration, the study aims to uncover patterns in name popularity, gender-based preferences, and the evolution of naming conventions over time. Such insights are invaluable for marketers, sociologists, and businesses aiming to understand cultural shifts and consumer behavior.

🛠️ Key Steps & Technical Highlights

* Data Preparation:

Utilized SQL scripts to create and populate the baby_names database.

Data spans from 1980 to 2020, encompassing names, birth counts, gender, and year.

* Data Cleaning & Transformation:

Standardized name formats and ensured data consistency.

Handled missing values and anomalies in the dataset.

* Exploratory Data Analysis (EDA):

Identified top names per decade and their longevity.

Analyzed gender-based naming trends and shifts over time.

Examined the rise and fall of specific names.

* Advanced SQL Techniques:

Employed window functions (ROW_NUMBER, RANK) to determine name rankings.

Used CASE WHEN statements for categorizing names based on popularity.

Implemented subqueries and common table expressions (CTEs) for complex analyses.

🔍 Key Insights

Timeless Names: Names like "James" and "Mary" have consistently ranked in the top 10 over multiple decades, indicating enduring popularity.

Gender Trends: There's a noticeable shift in gender-neutral names gaining popularity in recent years.
DataCamp

Cultural Influences: Significant events and popular culture heavily influence naming trends, evident from spikes in certain names correlating with celebrity fame or fictional characters.

📁 Repository Structure

create_baby_names_db.sql: Script to create the database schema.

insert_baby_names_1.sql to insert_baby_names_3.sql: Scripts to populate the database with data.

My script _ US Baby Names MY SQL Project.sql: Main analysis script containing all queries and insights.
Maven Analytics

📈 Future Enhancements

Visualization: Integrate with tools like Power BI or Tableau for graphical representations of trends.

Web Application: Develop a user-friendly interface allowing users to explore naming trends interactively.

Predictive Analysis: Implement machine learning models to predict future naming trends based on historical data.
