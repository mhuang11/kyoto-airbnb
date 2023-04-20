# Kyoto AirBnB Analysis
Analyzing which listing for a week stay in Kyoto, Japan has the best value.
The purpose of this project was to practice Python, R, Tableau, and SQL.

## Step 1: Data Scraping Using Python
2 Key packages used: BeautifulSoup and Selenium WebDriver.
BeautifulSoup is a package for parsing and extracting data from HTML, which is useful for web scraping.
Selenium WebDriver allows us to create test scripts to make sure we extract the information we want.

Using these packages, I created a function called `get_pages_urls()` which returns the URL of every listing on a single search page. The next step would be to create a list of each listing and extract the information you want. This is done by defining the variables you want in a list, which I put in a list called `RULES_SEARCH_PAGE`. Using these two functions, I extracted the necessary variables of every listing on every page in my search on AirBnB.

Note: I noticed that Python will not be able to recognize a list as a URL without "https://" at the front, so I added that to my list of URLs (use function `add_https()`). 

This is an example one listing and their variables after successfully extracting information:
![image](https://user-images.githubusercontent.com/78035136/231946247-598e145d-7838-4ac4-95b6-1175b4332b26.png)

The full list was exported as a .csv file and imported into R for cleaning.

## Step 2: Cleaning Data Using Python and (mostly) R
Before I exported the .csv file, there were a few things I needed to do in Python:
- The listings didn't have their URLs as part of their variables, so I added URLs to each listing.
- The first listing had their name cut off, manually corrected the name (minor tweak).

To put it simply, this is what I did in R:
- Filled in blanks with "N/A"
- Split values and created new columns (ex. Check-in and check-out times, number of bedrooms/beds/baths, etc.)
- Added a Yes/No column for Carbon Monoxide alarm
- Added Cancellation flexibility column which values are either "Within 48 Hrs" or "Flexible"
- Simplified the property types to Entire Homes, Apartments/Condos, and Private Rooms.
- Minor tweaks (ex. Listing 1 was the only listing that was "Entire Home" instead of "Entire home")

After cleaning up the data, the dataset is ready for analysis.

## Step 3: Data Analysis Using R

Exploratory Data Analysis:

Created 3 graphs that visualizes the data set by listing price, location, and accomodation type.
![image](https://user-images.githubusercontent.com/78035136/233415278-e660b4a7-d335-4652-b420-d9c526b55190.png)

![image](https://user-images.githubusercontent.com/78035136/233415344-1f7dee2a-61b6-41b8-abad-86536d768c44.png)

![image](https://user-images.githubusercontent.com/78035136/233415492-33585445-98c8-4a36-b97e-15c359780374.png)

Linear Regression Model

![image](https://user-images.githubusercontent.com/78035136/233415867-9eb7ccf5-bc9a-42b6-85a8-7e3e79e6840d.png)

(Observations are in RMarkdown PDF file.)

The purpose was to analyze the Kyoto AirBnB data set and find interesting insights related to the factors thtat affect the prices of listings in Kyoto area. The linear regression method was used to create a model that would help predict prices of a listing based on relevent factors. The dataset was split between training and testing data sets in the ratio of 70:30 and used in-sample validation, out-sample prediction, and cross-validation techniques. Upon validation, the MSPE of the test data i.e. 22176 was almost similar to the MSPSE of the full data i.e. 20416. Hence, it's concluded that the model used for analysis predicts the variable a good fit. 

## Step 4: Data Visualization using Tableau

I created a simple interactive dashboard on Tableau using the data cleaned in R.
You can select a property type (entire homes, condo/apt., or private rooms).
The dashboard will display what city in Kyoto has how many reviews (popularity) and its' rating (value) under "Top Region Ratings", the number of guests that property type can accommodate in a city, and the total prices of those property types on a map. 

![image](https://user-images.githubusercontent.com/78035136/232318225-ba5a1d35-60b7-4b97-bf55-c9cf34092c42.png)

## Step 5 (Extra): Writing Queries in SQL
