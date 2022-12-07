---
title: "Class 17 Lab"
format: pdf
---

# Getting Started

```{r}
file <- "covid.csv"
vax <- read.csv(file)
head(vax)
```

> Q1. What column details the total number of people fully vaccinated?

persons_fully_vaccinated

> Q2. What column details the Zip code tabulation area? 

zip_code_tabulation_area

> Q3. What is the earliest date in this dataset? 

2021-01-05

> Q4. What is the latest date in this dataset?

2022-11-29

```{r}
skimr::skim(vax)
```

> Q5. How many numeric columns are in this dataset

13 numeric columns

> Q6. Note that there are “missing values” in the dataset. How many NA values there in the persons_fully_vaccinated column? 

15048 NA values

> Q7. What percent of persons_fully_vaccinated values are missing (to 2 significant figures)? 

0.09

# Working with Dates

```{r}
library(lubridate)
today()
vax$as_of_date <- ymd(vax$as_of_date)
today() - vax$as_of_date[1]
vax$as_of_date[nrow(vax)] - vax$as_of_date[1]
```

> Q9. How many days have passed since the last update of the dataset?

6 days

> Q10.  How many unique dates are in the dataset (i.e.how many different dates are detailed)?

```{r}
date <- vax$as_of_date
date_unique <- unique(date)
length(date_unique)
```

100 unique days

# Working with Zip Codes

```{r}
library(zipcodeR)
geocode_zip('92037')
zip_distance('92037','92109')
reverse_zipcode(c('92037', "92109") )
```

# Focus on the San Diego Area

```{r}
library(dplyr)

sd <- filter(vax, county == "San Diego")

nrow(sd)

sd.10 <- filter(vax, county == "San Diego" &
                age5_plus_population > 10000)
```

> Q11. How many distinct zip codes are listed for San Diego County?

```{r}
zip <- sd$zip_code_tabulation_area
zip_unique <- unique(zip)
length(zip_unique)
```

There are 107 distinct zip codes in SD county.

> Q12. What San Diego County Zip code area has the largest 12 + Population in this dataset?

```{r}
age12 <- sd$age12_plus_population
which.max(age12)
sd[77,2]
```

92154 has the largest 12+ population in the dataset


