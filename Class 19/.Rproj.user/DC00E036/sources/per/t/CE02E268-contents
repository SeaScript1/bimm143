---
title: "Pertussis Mini Project"
format: pdf
---

# Investigating Pertussis cases by Year

> Q1. With the help of the R “addin” package datapasta assign the CDC pertussis case number data to a data frame called cdc and use ggplot to make a plot of cases numbers over time.

```{r}
cdc <- data.frame(
                          Year = c(1922L,
                                   1923L,1924L,1925L,1926L,1927L,1928L,
                                   1929L,1930L,1931L,1932L,1933L,1934L,1935L,
                                   1936L,1937L,1938L,1939L,1940L,1941L,
                                   1942L,1943L,1944L,1945L,1946L,1947L,1948L,
                                   1949L,1950L,1951L,1952L,1953L,1954L,
                                   1955L,1956L,1957L,1958L,1959L,1960L,
                                   1961L,1962L,1963L,1964L,1965L,1966L,1967L,
                                   1968L,1969L,1970L,1971L,1972L,1973L,
                                   1974L,1975L,1976L,1977L,1978L,1979L,1980L,
                                   1981L,1982L,1983L,1984L,1985L,1986L,
                                   1987L,1988L,1989L,1990L,1991L,1992L,1993L,
                                   1994L,1995L,1996L,1997L,1998L,1999L,
                                   2000L,2001L,2002L,2003L,2004L,2005L,
                                   2006L,2007L,2008L,2009L,2010L,2011L,2012L,
                                   2013L,2014L,2015L,2016L,2017L,2018L,
                                   2019L),
  No..Reported.Pertussis.Cases = c(107473,
                                   164191,165418,152003,202210,181411,
                                   161799,197371,166914,172559,215343,179135,
                                   265269,180518,147237,214652,227319,103188,
                                   183866,222202,191383,191890,109873,
                                   133792,109860,156517,74715,69479,120718,
                                   68687,45030,37129,60886,62786,31732,28295,
                                   32148,40005,14809,11468,17749,17135,
                                   13005,6799,7717,9718,4810,3285,4249,
                                   3036,3287,1759,2402,1738,1010,2177,2063,
                                   1623,1730,1248,1895,2463,2276,3589,
                                   4195,2823,3450,4157,4570,2719,4083,6586,
                                   4617,5137,7796,6564,7405,7298,7867,
                                   7580,9771,11647,25827,25616,15632,10454,
                                   13278,16858,27550,18719,48277,28639,
                                   32971,20762,17972,18975,15609,18617)
)
```

```{r}
library(ggplot2)
plot <- ggplot(cdc, aes(Year, No..Reported.Pertussis.Cases)) +
  geom_point() + 
  geom_line() + 
  ylab("Number of Cases")
plot
```

# A Tale of Two Vaccines

> Q2. Using the ggplot geom_vline() function add lines to your previous plot for the 1946 introduction of the wP vaccine and the 1996 switch to aP vaccine (see example in the hint below). What do you notice?

```{r}
vector <- c(1946, 1996)
plot +
  geom_vline(xintercept = vector, color = "blue", linetype = 2)
```

> Q3. Describe what happened after the introduction of the aP vaccine? Do you have a possible explanation for the observed trend?

The number of cases reported seems to rise after the introduction of the aP vaccine. A possible explanation for the trend is the increase in vaccine hesitancy proliferated by the internet in the 2010s with the rise of the Internet. 

# Exploring CMI-PB data

```{r}
library("jsonlite")
subject <- read_json("https://www.cmi-pb.org/api/subject", simplifyVector = TRUE) 
head(subject, 3)
```

> Q4. How may aP and wP infancy vaccinated subjects are in the dataset?

```{r}
sum(subject$infancy_vac == "wP")
sum(subject$infancy_vac == "aP")
```

There are 49 wP infancy vaccinated subjects and 47 aP infacy vaccinated subjects

> Q5. How many Male and Female subjects/patients are in the dataset?

```{r}
table(subject$biological_sex)
```
There are 66 females and 30 males

> Q6. What is the breakdown of race and biological sex (e.g. number of Asian females, White males etc…)?

```{r}
table(subject$biological_sex, subject$race)
```

# Working with Dates

> Q7. Using this approach determine (i) the average age of wP individuals, (ii) the average age of aP individuals; and (iii) are they significantly different?

```{r}
library(lubridate)
library(dplyr)
subject$age <- today() - ymd(subject$year_of_birth)

ap <- subject %>% filter(infancy_vac == "aP")

round( summary( time_length( ap$age, "years" ) ) )

wp <- subject %>% filter(infancy_vac == "wP")
round( summary( time_length( wp$age, "years" ) ) )
```
i) The average age of wP individuals is 36 years
ii) The average age of aP individuals is 25 years
iii) Yes, it is statistically significant

> Q8. Determine the age of all individuals at time of boost?

```{r}
int <- ymd(subject$date_of_boost) - ymd(subject$year_of_birth)
age_at_boost <- time_length(int, "year")
head(age_at_boost)
```

> Q9. With the help of a faceted boxplot (see below), do you think these two groups are significantly different?

```{r}
ggplot(subject) +
  aes(time_length(age, "year"),
      fill=as.factor(infancy_vac)) +
  geom_histogram(show.legend=FALSE) +
  facet_wrap(vars(infancy_vac), nrow=2) 

x <- t.test(time_length( wp$age, "years" ),
       time_length( ap$age, "years" ))

x$p.value
```
From both the graph and the p-value, we can tell the results are significantly different. 

# Join multiple tables

```{r}
specimen <- read_json("https://www.cmi-pb.org/api/specimen", simplifyVector = TRUE) 
titer <- read_json("https://www.cmi-pb.org/api/ab_titer", simplifyVector = TRUE)
```


> Q9b. Complete the code to join specimen and subject tables to make a new merged data frame containing all specimen records along with their associated subject details:

```{r}
meta <- full_join(specimen, subject)
dim(meta)
head(meta)
```

> Q10. Now using the same procedure join meta with titer data so we can further analyze this data in terms of time of visit aP/wP, male/female etc.

```{r}
abdata <- inner_join(titer, meta)
dim(abdata)
```

> Q11. How many specimens (i.e. entries in abdata) do we have for each isotype?

```{r}
table(abdata$isotype)
```

The table above shows us the number of specimens for each isotype

> Q12. What do you notice about the number of visit 8 specimens compared to other visits?

```{r}
table(abdata$visit)
```
From the above tabel we can see that there are significantly fewer visit 8 specimens when compared to the other visits. 

# Examine IgG1 titer Ab titer levels

```{r}
ig1 <- abdata %>% filter(isotype == "IgG1", visit!=8)
head(ig1)
```

> Q13. Complete the following code to make a summary boxplot of Ab titer levels for all antigens:

```{r}
ggplot(ig1) +
  aes(MFI, antigen) +
  geom_boxplot() + 
  facet_wrap(vars(visit), nrow=2)
```

> Q14. What antigens show differences in the level of IgG1 antibody titers recognizing them over time? Why these and not others?

TT, PRN, FIM2/3, FHA and DT seem to show differences in the level of IgG1 antibody titers recognizing them over time. This is likely due to an increased presence of these antigens in the body, resulting in more antibodies being produced, thus resulting in them being recognized over time.

```{r}
ggplot(ig1) +
  aes(MFI, antigen, col=infancy_vac ) +
  geom_boxplot(show.legend = FALSE) + 
  facet_wrap(vars(visit), nrow=2) +
  theme_bw()
```

```{r}
ggplot(ig1) +
  aes(MFI, antigen, col=infancy_vac ) +
  geom_boxplot(show.legend = FALSE) + 
  facet_wrap(vars(infancy_vac, visit), nrow=2)
```

> Q15. Filter to pull out only two specific antigens for analysis and create a boxplot for each. You can chose any you like. Below I picked a “control” antigen (“Measles”, that is not in our vaccines) and a clear antigen of interest (“FIM2/3”, extra-cellular fimbriae proteins from B. pertussis that participate in substrate attachment).

```{r}
filter(ig1, antigen=="Measles") %>%
  ggplot() +
  aes(MFI, col=infancy_vac) +
  geom_boxplot(show.legend = TRUE) +
  facet_wrap(vars(visit)) +
  theme_bw()
```


```{r}
filter(ig1, antigen=="FIM2/3") %>%
  ggplot() +
  aes(MFI, col=infancy_vac) +
  geom_boxplot(show.legend = TRUE) +
  facet_wrap(vars(visit)) +
  theme_bw()
```

> Q16. What do you notice about these two antigens time course and the FIM2/3 data in particular?

Antigen levels for aP and wP both regress to similar quantities by te 7th visit in Measles, however for FIM2/3 antigen levels, the antigen levels increase over visit and decrease slightly in wP, but remained significantly increased in aP.

> Q17. Do you see any clear difference in aP vs. wP responses?

There does seem to be a visible difference in aP and wP resonses, though it is arguable whether they are statstically significant. 

# Obtaining CMI-PB RNASeq data

```{r}
url <- "https://www.cmi-pb.org/api/v2/rnaseq?versioned_ensembl_gene_id=eq.ENSG00000211896.7"

rna <- read_json(url, simplifyVector = TRUE) 
```

```{r}
ssrna <- inner_join(rna, meta)
```

> Q18. Make a plot of the time course of gene expression for IGHG1 gene (i.e. a plot of visit vs tpm)

```{r}
ggplot(ssrna) +
  aes(visit, tpm, group=subject_id) +
  geom_point() +
  geom_line(alpha=0.2)
```

```{r}
ggplot(ssrna) +
  aes(visit, tpm, group=subject_id) +
  geom_point() +
  geom_line(alpha=0.2)
```

> Q19. What do you notice about the expression of this gene (i.e. when is it at it’s maximum level)?

The expression of this gene is at its maximum level at visit 4 in most cases. 



