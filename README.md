# Maryland-Data-Pull

This project involved gathering unofficial statewide precinct results after the Maryland statewide primary election. It's important to note that many counties are omitted, due to the absence of unofficial statewide primary election results.

## Data Pull

All the R scripts used to pull information can be found in this folder. There are three scripts--one for each data pull. The first is for Maryland Congressional District 4, the second is for Maryland Congressional District 8, and the final is for Maryland Statewide. These scripts pull the information from the tables provided on the website and then rebuild tables with the desired information. Once the tables are produced, the results are exported into CSV files.

## Precinct List

This folder includes a list of the precincts desired for analysis. These precinct numbers were then cleaned and converted into the lists used in the R scripts.

## Raw CSV

These CSVs are the direct exports of the tables produced by the R scripts.

## Cleaned CSV

These CSVs are the cleaned versions of the table exports. These versions have a more specific Precinct Name and the County Name of the precincts. These CSVs were used primarily for mapping.

## Potential Improvements to the Code

The most significant improvement would come in the automation in downloading precinct information. Instead of several excel files including the precinct lists for each region, there would be one CSV file including the County ID, County Name, Precinct ID, and Precinct Name. This would reduce two steps: (1) The process of manually converting the precinct ids into R-friendly lines of code, and (2) The process of cleaning CSV files to add County Name and Precinct Name.

Additionally, it would be important to automate the process of the CSVs export into the correct folder, which would just require a simple change in the code.
