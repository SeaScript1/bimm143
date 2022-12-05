---
title: "Halloween Mini-Project"
author: Varun Durai
format: pdf
---

1. Importing candy data:

```{r}
candy_file <- "https://raw.githubusercontent.com/fivethirtyeight/data/master/candy-power-ranking/candy-data.csv"

candy = read.csv(candy_file, row.names = 1)
head(candy)
```

> Q1. How many different candy types are in this dataset?

```{r}
dim(candy)
```
 
By observing the dimensions of the dataset, we can see that there are 85 rows, and thus 85 different types of candy. 

> Q2. How many fruity candy types are in the dataset?

```{r}
sum(candy$fruity == 1)
```

By summing all the instances of the fruity column when it is equal to 1, we can find that there are 38 fruity candy types.

2. What is your favorite candy?

> Q3. What is your favorite candy in the dataset and what is its winpercent value?

```{r}
candy["Almond Joy", ]$winpercent
```

The favorite candy is Almond Joy, and the function above tells us that its winpercent value is 50.34755

> Q4. What is the winpercent value for “Kit Kat”?

```{r}
candy["Kit Kat", ]$winpercent
```

76.7686 is the winpercent of Kit Kat

> Q5. What is the winpercent value for “Tootsie Roll Snack Bars”?

```{r}
candy["Tootsie Roll Snack Bars", ]$winpercent
```

49.6535 is the winpercent of Tootsie Roll Snack Bars

```{r}
library("skimr")
skim(candy)
```

> Q6. Is there any variable/column that looks to be on a different scale to the majority of the other columns in the dataset?

From the skim results, winpercent seems to be on a different scale from the other variables since it displays advanced stats with values between 0-100 while the advanced stats of the other variables range from 0-1. 

> Q7. What do you think a zero and one represent for the candy$chocolate column?

A zero indicates that the candy does not contain chocolate, while a one indicates that it does. 

> Q8. Plot a histogram of winpercent values

```{r}
library(ggplot2)

ggplot(candy, aes(x = winpercent)) +
  geom_histogram(bins = 20)
```

> Q9. Is the distribution of winpercent values symmetrical? 

The distribution of the winpercent values is not symmetrical. 

> Q10. Is the center of the distribution above or below 50%?

The center of the distribution seems to be slightly below 50%

> Q11. On average is chocolate candy higher or lower ranked than fruit candy?

```{r}
mean(candy$winpercent[as.logical(candy$fruit)])
mean(candy$winpercent[as.logical(candy$chocolate)])
```

On average, chocolate candy is higher ranked. 

> Q12. Is this difference statistically significant?

```{r}
t.test(candy$winpercent[as.logical(candy$fruit)])
t.test(candy$winpercent[as.logical(candy$chocolate)])
```
 
 Both have extremely small p-values so the data is likely statistically significant. 
 
3. Overall Candy Ranking

> Q13. What are the five least liked candy types in this set?

```{r}
library(dplyr)
candy %>% arrange(winpercent) %>% head(5)
```

Nik L Nip, Boston Baked Beans, Chiclets, Super Bubble and Jawbusters are the least liked types in the set. 

> Q14. What are the top 5 all time favorite candy types out of this set?

```{r}
candy %>% arrange(desc(winpercent)) %>% head(5)
```

The top 5 all time favorite candy types out of this set are Reese's Peanut Butter cup, Reese's Miniatures, Twix, Kit Kat and Snickers. 

> Q15. Make a first barplot of candy ranking based on winpercent values. 

```{r}
library(ggplot2)

ggplot(candy) + 
  aes(winpercent, rownames(candy)) +
  geom_bar(stat = 'identity')
```

> Q16. This is quite ugly, use the reorder() function to get the bars sorted by winpercent?

```{r}
ggplot(candy) + 
  aes(winpercent, reorder(rownames(candy),winpercent)) +
  geom_bar(stat = 'identity')

#Adding Color,

my_cols=rep("black", nrow(candy))
my_cols[as.logical(candy$chocolate)] = "chocolate"
my_cols[as.logical(candy$bar)] = "brown"
my_cols[as.logical(candy$fruity)] = "pink"

ggplot(candy) + 
  aes(winpercent, reorder(rownames(candy),winpercent)) +
  geom_col(fill=my_cols)
```

>  Q17. What is the worst ranked chocolate candy?

Sixlet is the worst ranked chocolate candy.

> Q18. What is the best ranked fruity candy?

Starburst is the best ranked fruity candy. 

4. Taking a look at pricepercent

```{r}
library(ggrepel)

ggplot(candy) +
  aes(winpercent, pricepercent, label=rownames(candy)) +
  geom_point(col=my_cols) + 
  geom_text_repel(col=my_cols, size=3.3, max.overlaps = 5)
```

> Q19. Which candy type is the highest ranked in terms of winpercent for the least money - i.e. offers the most bang for your buck?

Reese's Minatures probably offer the best bang for you buck.

> Q20. What are the top 5 most expensive candy types in the dataset and of these which is the least popular?

```{r}
ord <- order(candy$pricepercent, decreasing = TRUE)
head( candy[ord,c(11,12)], n=5 )
```

So, Nik L Nip, Nestle Smarties, Ring pop, Hershey's Krackel and Hershey's Milk Chocolate are the most expensive. 


