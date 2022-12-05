---
title: "Class 5 Data Visualization GGPLOT"
author: "Varun Durai"
format: pdf
---

# Our first ggplot

To use the ggplot2 package, I first need to have it installed on my computer

To install any package we use the `install.package()` command.

Now can I use it? NO! First we need to call `library(ggplot2)`

```{r}
library(ggplot2)
ggplot()
```

```{r}
mpg
```

Our first plot of displ vs hwy
All ggplot() graphs are made in the same way: 
data + aes + geoms
```{r}
ggplot(mpg) +
  aes(x = displ, y = hwy) +
  geom_point()
```


```{r}
ggplot(mpg) +
  aes(x = displ, y = hwy) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE)
```

# Plot of gene expression data

First read the data from online 

```{r}
url <- "https://bioboot.github.io/bimm143_S20/class-material/up_down_expression.txt"
genes <- read.delim(url)
head(genes)
```

> Q. How may genes are in this dataset?

```{r}
nrow(genes)
```

What are the column names? 

```{r}
colnames(genes)
```

```{r}
ncol(genes)
table(genes$State)
127/5196 * 100
```

A first version plot of this data Condition1 vs Condition2

```{r}
p <- ggplot(genes) + 
    aes(x=Condition1, y=Condition2, col = State) +
    geom_point(alpha = 0.3)
p
```

> Q. How many genes are up regulated and down regulated?

```{r}
head(genes)
```
```{r}
table(genes$State)
```


```{r}
p <- p + scale_colour_manual( values=c("blue","gray","red") )
p
p + labs(title="Gene Expresion Changes Upon Drug Treatment",
         x="Control (no drug) ",
         y="Drug Treatment")
```

# Going Further

```{r}
url <- "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/extdata/gapminder.tsv"

gapminder <- read.delim(url)
library(dplyr)
gapminder_2007 <- gapminder %>% filter(year==2007)

ggplot(gapminder_2007) +
  aes(x = gdpPercap, y = lifeExp, color = continent, size = pop) +
  geom_point(alpha = 0.5)
```

