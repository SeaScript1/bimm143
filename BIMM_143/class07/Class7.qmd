---
title: "Class 07"
author: "Varun Durai"
format: pdf
---

# K-means clustering 

First we will test how this method works in R with some made up data. 

```{r}
x <- rnorm(10000)
hist(x)
```

Let's make some numbers centered on -3

```{r}
m <- c("a","b","c")
rev(m)
```

```{r}
tmp <- c(rnorm(30, -3),rnorm(30, 3))
x <- cbind(tmp, rev(tmp))
plot(x)
```

Now let's see how `kmeans()` works with this data... 

```{r}
km <- kmeans(x, centers = 2, nstart = 20)
km
```

```{r}
km$centers
```


>Q. How many points are in each cluster?

```{r}
km$size
```

>Q. What ‘component’ of your result object details
  - cluster assignment/membership?
  - cluster center?
  
 Cluster assignment/membership: 
 
```{r}
km$cluster
```
 
 Cluster center:
 
```{r}
km$centers
```
 
 >Q. Plot x colored by the kmeans cluster assignment and add cluster centers as blue points
 
```{r}
plot(x, col = km$cluster)
points(km$centers, col = "blue", pch = 15, cex = 2)
```
 
 # Hierarchichal Clustering
 
 The `hclust()` function in R performs Hierarchical clustering.
 
 The `hclus()` function requires an input distance matrix, whcihc I can get from the `dist()` function. 
 
```{r}
hc <- hclust( dist(x) )
hc
```
 
Here is a plot() method for hclust objects...

```{r}
plot(hc)
```

Now to get my cluster membership vector I need to "cut" the tree to yield separate "branches" with the leaves on each branch being our cluster. To do this we sue the `cutree()` function. 

```{r}
cutree(hc, h = 8)
```

Use `cutree()` with a k = 2

```{r}
grps <- cutree(hc, k = 2)
```

A plot of our data colored by our hclust grps 

```{r}
plot(x, col = grps)
```

# Principal Component Analysis (PCA)

```{r}
url <- "https://tinyurl.com/UK-foods"
ukFood <- read.csv(url)
ukFood
```

> Q1. How many rows and columns are in your new data frame named x? What R functions could you use to answer this questions?

```{r}
dim(ukFood)
```

Running the code block above using the `dim()` function shows us that there are 17 rows and 5 columns

> Q2. Which approach to solving the ‘row-names problem’ mentioned above do you prefer and why? Is one approach more robust than another under certain circumstances?

```{r}
rownames(ukFood) <- ukFood[,1]
ukFood
```

The above method is one way of ensuring that the first column is set to the name of the rows of the dataframe. Another method is setting the row name while reading the csv file, shown below:

```{r}
ukFood2 <- read.csv(url, row.names = 1)
ukFood2
```

As we can see, the structure of ukFood and ukFood are the same, as both methods work to ensure that the first column is set to the name of the rows. 

Specifying an argument in the `read.csv()` function saves time while trying to set a certain column as the names column, and so it is generally preferred. However, if there were a scenario where we would want a numbered column for our data, the first method would be useful for removing it later. 

> Q3. Changing what optional argument in the above barplot() function results in the following plot?

The code below is the original `barplot()` function:

```{r}
barplot(as.matrix(ukFood2), beside=T, col=rainbow(nrow(ukFood2)))
```

Setting the `beside` argument to false or leaving it out will result in our required stacked plot. 

```{r}
barplot(as.matrix(ukFood2), col=rainbow(nrow(ukFood2)))
```

> Q5: Generating all pairwise plots may help somewhat. Can you make sense of the following code and resulting figure? What does it mean if a given point lies on the diagonal for a given plot?

The following code generates a pairwise plot for our data:

```{r}
pairs(ukFood2, col=rainbow(10), pch=16)
```

## PCA to the rescue:

The following is the main PCA function in base R, called `prcomp()`. `t()` creates the transpose of the data frame. 

```{r}
pca <- prcomp( t(ukFood2) )
summary(pca)
```

The above results show that PCA captures 67% of total variance in the original data in one PC and 96.5% in two PCs. 

```{r}
attributes(pca)
```

```{r}
head(pca$x)
```

> Q7. Complete the code below to generate a plot of PC1 vs PC2. The second line adds text labels over the data points.

```{r}
plot(pca$x[,1], pca$x[,2], xlab="PC1", ylab="PC2", xlim=c(-270,500))
text(pca$x[,1], pca$x[,2], colnames(ukFood2))
```

>Q8. Customize your plot so that the colors of the country names match the colors in our UK and Ireland map and table at start of this document.

```{r}
plot(pca$x[,1], pca$x[,2], xlab="PC1", ylab="PC2", xlim=c(-270,500))
text(pca$x[,1], pca$x[,2], colnames(ukFood2), col = c("orange", "red", "blue", "green"))
```

## 2. PCA of RNA Seq Data

```{r}
url2 <- "https://tinyurl.com/expression-CSV"
rna.data <- read.csv(url2, row.names=1)
head(rna.data)
```

```{r}
dim(rna.data)
```

> Q10: How many genes and samples are in this data set?

There are 100 rows (genes) and 10 columns (samples) in the data set. 

```{r}
## Again we have to take the transpose of our data 
pca <- prcomp(t(rna.data), scale=TRUE)
 
## Simple un polished plot of pc1 and pc2
plot(pca$x[,1], pca$x[,2], xlab="PC1", ylab="PC2")
summary(pca)
plot(pca, main="Quick scree plot")
```
```{r}
## Variance captured per PC 
pca.var <- pca$sdev^2

## Percent variance is often more informative to look at 
pca.var.per <- round(pca.var/sum(pca.var)*100, 1)
pca.var.per
barplot(pca.var.per, main="Scree Plot", 
        names.arg = paste0("PC", 1:10),
        xlab="Principal Component", ylab="Percent Variation")

## A vector of colors for wt and ko samples
colvec <- colnames(rna.data)
colvec[grep("wt", colvec)] <- "red"
colvec[grep("ko", colvec)] <- "blue"

plot(pca$x[,1], pca$x[,2], col=colvec, pch=16,
     xlab=paste0("PC1 (", pca.var.per[1], "%)"),
     ylab=paste0("PC2 (", pca.var.per[2], "%)"))

text(pca$x[,1], pca$x[,2], labels = colnames(rna.data), pos=c(rep(4,5), rep(2,5)))
```

# Using ggplot
```{r}
library(ggplot2)

df <- as.data.frame(pca$x)

# Our first basic plot
ggplot(df) + 
  aes(PC1, PC2) + 
  geom_point()

# Add a 'wt' and 'ko' "condition" column
df$samples <- colnames(rna.data) 
df$condition <- substr(colnames(rna.data),1,2)

p <- ggplot(df) + 
        aes(PC1, PC2, label=samples, col=condition) + 
        geom_label(show.legend = FALSE)
p

p + labs(title="PCA of RNASeq Data",
       subtitle = "PC1 clealy seperates wild-type from knock-out samples",
       x=paste0("PC1 (", pca.var.per[1], "%)"),
       y=paste0("PC2 (", pca.var.per[2], "%)"),
       caption="Class example data") +
     theme_bw()
```

