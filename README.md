# Analysis and visualization of Covid-19 Infections & Death data

## Dataset:

The Data for this project has been collected from [ourworldindata.org](https://ourworldindata.org/coronavirus) [1]

> [1] Hannah Ritchie, Edouard Mathieu, Lucas Rodés-Guirao, Cameron Appel, Charlie Giattino, Esteban Ortiz-Ospina, Joe Hasell, Bobbie Macdonald, Diana Beltekian and Max Roser (2020) - "Coronavirus Pandemic (COVID-19)". Published online at OurWorldInData.org. Retrieved from: 'https://ourworldindata.org/coronavirus' [Online Resource]

## Data Preperation:

* Downloaded the csv file for the dataset from the [source](https://ourworldindata.org/coronavirus)
* The dataset was split into two separate subsets for Analysis and stored into the following two xlsx files:
    * CovidDeaths.xlsx
    * CovidVaccination.xlsx
* The *.xlsx files were imported to Microsoft SQL Server to create two separate Databases

## Data Exploration:

Data Exploration was performed using SQL Queries in Microsoft SQL Server. The SQL Queries for data exploration are included in the file **SQL_DATA_EXploration.sql**

The following Explorations were performed on the Data: 

* Selecting Relevant Data
* Show likelihood of death by country
* Percentage of population that contracted Covid
* Identify countries with high infection rates
* Identify countries with highest death count
* Analyze Data by Continent
* Calculate Global numbers
* Joining of Population + Vaccination Data
* Analyze Death w.r.t Population & Vaccination using CTE/TEMP Table
* Create views for visualization
* Stored procedure (for later)

## Data Visualization in Tableau: 

We have perfomed the Data Visualization using Tableau. A Tableau Dashboard has been created with the data from the previous step. A Snapshot of the Dashboard is as follows: 

![Tableau Dashboard](https://raw.githubusercontent.com/sadiatanjim/Exploration-and-Visualization-for-Analysis/main/Covid-19%20Dashboard.png)

For a more detailed view of the Dashboard, you can follow the following link: [COVID 19 Dashboard by Sadia](https://public.tableau.com/views/Covid-19Dashboard_16397615770080/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)
