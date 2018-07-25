# Data Science Specilization: Getting and Cleaning Data Project

This project's goal is to create a TidyData.txt file that contains the results of a experiment that collects data from a Samsung Galaxy S smartphone wich can be used in future analysis. 

This Repo contains the following files:

  1. `README.dm` file: You are reading it. Contains the explanation of ech file in the Repo.
  2. `run_analysis.R` file: This is the main script for our procedure and does the following:
      - Dowloads and unzip the experiment raw data from:    `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`
      - Read and Loads the main tables in R:
          - Activity Labels
          - Activities
          - Subjects
          - Features
          - Training Data
          - Testing Data
      - Merges all previus tables in a single table called `Data`
      - Extract only meassures that contains Means and Standart Deviations
      - Rewrite variable names for easier comprehention
      - Creates a file called `TidyData.txt` that summarizes the variables in means for each Subject/Activity
  3. `CodeBook.md` file: contains the variable names.
  4. `TidyData.txt` file: contains the final result data with no labels on it.
