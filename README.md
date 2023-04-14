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
- Minor tweaks (ex. Listing 1 was the only listing that was "Entire Home" instead of "Entire home")

After cleaning up the data, I exported the file to Tableau for visualization practice.

## Step 3: Data Analysis using Python and R


## Step 4: Data Visualization Using R and Tableau


## Step 5 (Extra): Writing Queries in SQL
