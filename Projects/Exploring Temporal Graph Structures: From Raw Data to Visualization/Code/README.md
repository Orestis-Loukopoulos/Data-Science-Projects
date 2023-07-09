# Project Instructions

This project involves working with a dataset and performing various tasks using different coding files. The following is the recommended order in which the coding files should be opened and read:

## 1) UNIX_Code.txt

This file contains the code for filtering the dataset. It is recommended to open and read this file first. The code in this file will help filter the dataset based on specific criteria, such as conference name and publication year. The output of this code will be a filtered dataset that will be used in the subsequent steps.

## 2) Cleaning-Dataset.R

Next, open and read the file named "Cleaning-Dataset.R". This file contains code for reading the filtered dataset obtained from the previous step. It also includes code for cleaning any problematic observations and extracting a new cleaned filtered dataset. By running this code, you will obtain a refined dataset that is ready for further analysis.

## 3) Create_CSV_files.ipynb

After obtaining the cleaned filtered dataset, open and read the file "Create_CSV_files.ipynb". This file contains code written in Jupyter Notebook for transforming the cleaned dataset into a weighted edge list for each year. The code in this file will generate five CSV files, each representing the weighted co-authorship graph for a specific year.

## 4) igraph_Code.R

Finally, open and read the file named "igraph_Code.R". This file contains code that covers tasks 1 to 4 of the project. It uses the filtered and cleaned dataset, as well as the CSV files created in the previous steps, to perform various analyses and visualizations using the igraph package in R.

By following the above order and reading the coding files sequentially, you will be able to understand and execute the tasks involved in the project effectively.

Please note that each coding file may contain additional comments and explanations to guide you through the code implementation and its purpose within the project.

Feel free to explore and modify the code as needed to suit your requirements and understand the project in-depth.
