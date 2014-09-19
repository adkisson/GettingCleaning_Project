GettingCleaning_Project
=======================

Course Project for Getting and Cleaning Data

In this repository, you will find:

1. CodeBook.md - information about the datasets
2. README.md - this README file
3. run_analysis.R - the R code to transform the data from the original to the tidy set proscribed by the course project



How to use the run_analysis.R file:

1. download the script file
2. download the data per the course project guidelines
3. unzip the data
4. open Rconsole and change the working directory to the data source
5. run the script -- you must have the dplyr package on your system
6. the tidy data set required for the course project will be in the file "summarized_data.txt" in the
working directory.


The script reads the raw data and combines the testing and training data, including header (column) information
and pre-pending subject and activity information (per the project instructions).   The script further subsets
the data including only the mean and standard deviation data for each variable.  It also renames the headers
from the source information to be more easily understandable.
