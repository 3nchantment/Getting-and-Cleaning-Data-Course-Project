# Code book for Coursera *Getting and Cleaning Data* course project

The data set that this code book pertains to is located in the `Final_Data_Table.txt` file of this repository.

See the `README.md` file of this repository for background information on this data set.

This project will do the following:

1) Download the data and unzip it to a local directory

2) Extract the data to two data tables, assign column names and merge the training and the test sets to create one data set.

3) Extract only the measurements on the mean and standard deviation for each measurement from the data set.

4) Merge activity names to Id's to be more descriptiv and use pattern matching and replacing to rename variables with more descriptive variable names.

5) Group the data by activity and subject and then take the mean at that level of detail for each variable.

6) Store the data to the "Final_Data_Table.txt" file.

You can download the run_analysis.R script and run it with R or Rstudio to create the Final_Data_Table.txt file.
