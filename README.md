# Nashville Housing Data Cleaning

## Overview
This project aims to prepare the NashvilleHousing dataset for analysis by cleaning and preprocessing the data using SQL queries. The dataset comprises various attributes related to housing, including property addresses, sale dates, owner details, and other relevant information.

## Objectives
- Standardize date formats: Ensure consistency in the representation of sale dates by standardizing the format across the dataset.
- Populate missing values: Address null or missing values in crucial fields such as property addresses, utilizing available information like ParcelId.
- Split address fields: Separate the combined address field into individual components such as street address, city, and state for better analysis and filtering.
- Parse owner details: Extract relevant information from the owner address field, such as street address, city, and state, to enhance data granularity.
- Update field values: Modify specific field values, such as converting 'Y' and 'N' to 'Yes' and 'No' in the 'Sold as Vacant' field for clarity and consistency.
- Remove duplicates: Identify and remove duplicate records based on predefined criteria to ensure data integrity and accuracy.

## Approach
The project employs SQL queries to perform each data cleaning task systematically. Each query addresses a specific aspect of data cleaning, following a structured approach to prepare the dataset for subsequent analysis or modeling.

## Usage
To utilize the provided SQL queries for data cleaning, users can execute them against the NashvilleHousing dataset within their SQL database environment. The queries are designed to be modular, allowing users to execute them individually or in sequence based on their specific data cleaning requirements.

## Conclusion
By completing the data cleaning process outlined in this project, users can expect a clean, standardized dataset ready for further analysis or modeling. The SQL queries provided serve as a foundation for preparing the NashvilleHousing dataset, enabling users to derive valuable insights and make informed decisions in the realm of real estate analysis or related fields.
