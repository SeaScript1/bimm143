---
title: "Unsupervised Learning Analysis of Human Breast Cancer Cells"
author: "Varun Durai"
format: pdf
---

## 1. Exploratory Data Analysis:

```{r}
fna.data <- "https://bioboot.github.io/bimm143_S20/class-material/WisconsinCancer.csv"
wisc.df <- read.csv(fna.data, row.names = 1)
head(wisc.df)
```

We will need to omit the diagnosis column from our data frame and set it up as a vector for later. 

```{r}
wisc.data <- wisc.df[,-1]
diagnosis  <- wisc.df$diagnosis
```

> 
    Q1. How many observations are in this dataset? 

We can use `nrow()` to find the number of rows in our data frame, which will tell us the number of observations in the data set. 

```{r}
nrow(wisc.data)
```

This shows us that there are `569` rows, and thus **569 observations in the data set.**

> Q2. How many of the observations have a malignant diagnosis? 

We can use the `grep()` function to create a new list containing the indices of the elements of `diagnosis` that have the value `"M"`. Calling the `length()` function on this new list will give us the number of observations with a malignant diagnosis. 

```{r}
Mcount <- grep("M", diagnosis)
length(Mcount)
```

The length of `Mcount` is 212, so **the number of observations that have a malignant diagnosis is 212**

>  Q3. How many variables/features in the data are suffixed with _mean?

```{r}
grep("mean", colnames(wisc.data))
```

Using the `grep()` functions on `colnames(wisc.data)` returns a list with 10 elements. Thus, the number of columns with the suffix _mean is **10**. 

## 2. Principal Component Analysis:

```{r}
# Check column means and standard deviations
colMeans(wisc.data)

apply(wisc.data,2,sd)
```

```{r}
# Perform PCA on wisc.data by completing the following code
wisc.pr <- prcomp( wisc.data, scale = TRUE )
summary(wisc.pr)
```

> Q4. From your results, what proportion of the original variance is captured by the first principal components (PC1)?

From the output above, we can see that the proportion of the original variance captured by PC1 is **0.4427 or 44.27%**. 

> Q5. How many principal components (PCs) are required to describe at least 70% of the original variance in the data?

**3** principal components (PC3) are required to descrive at least 70% of the original variance in the data. 

> Q6. How many principal components (PCs) are required to describe at least 90% of the original variance in the data?

**7** principal components (PC7) are required to descrive at least 70% of the original variance in the data. 

# *Interpreting PCA results*

```{r}
biplot(wisc.pr)
```
> Q7. What stands out to you about this plot? Is it easy or difficult to understand? Why?

This plot is impossible to understand since it all of the information is clustered together and it does not give us a clear understanding of the data that we have produced
```{r}
plot( wisc.pr$x[,1], wisc.pr$x[,2], 
      col = factor(diagnosis), 
      xlab = "PC1", ylab = "PC2")
```

> Q8.Generate a similar plot for principal components 1 and 3. What do you notice about these plots?

```{r}
plot( wisc.pr$x[,1], wisc.pr$x[,3], 
      col = factor(diagnosis), 
      xlab = "PC1", ylab = "PC3")
```

While the plots are very similar, there seems to be more overlap between the malignant and non-malignant data points in the comparison with PC3 when compared to the comparison with PC2. 

```{r}
# Create a data.frame for ggplot
df <- as.data.frame(wisc.pr$x)
df$diagnosis <- diagnosis

# Load the ggplot2 package
library(ggplot2)

# Make a scatter plot colored by diagnosis
ggplot(df) + 
  aes(PC1, PC2, col=factor(diagnosis)) + 
  geom_point()
```

## *Variance Explained*

```{r}
# Calculate variance of each component
pr.var <- wisc.pr$sdev ^ 2
head(pr.var)
```

```{r}
# Variance explained by each principal component: pve
pve <- pr.var / sum(pr.var)

# Plot variance explained for each principal component
plot(pve, xlab = "Principal Component", 
     ylab = "Proportion of Variance Explained", 
     ylim = c(0, 1), type = "o")
```

```{r}
# Alternative scree plot of the same data, note data driven y-axis
barplot(pve, ylab = "Precent of Variance Explained",
     names.arg=paste0("PC",1:length(pve)), las=2, axes = FALSE)
axis(2, at=pve, labels=round(pve,2)*100 )
```

## *Communicating PCA results* 

> Q9. For the first principal component, what is the component of the loading vector (i.e. wisc.pr$rotation[,1]) for the feature concave.points_mean?

```{r}
wisc.pr$rotation[8,1]
```

> Q10. What is the minimum number of principal components required to explain 80% of the variance of the data?

**5** principal components (PC5) are required to explain 90% of the variance of the data. 

# 3. Heirarchical clustering

```{r}
data.scaled <- scale(wisc.data)
data.dist <- dist(data.scaled)
wisc.hclust <- hclust(data.dist, method = "complete")
```

> Q11. Using the plot() and abline() functions, what is the height at which the clustering model has 4 clusters?

```{r}
plot(wisc.hclust)
abline(h = 20, col="red", lty=2)
```

The height at which the clustering model has 4 clusters is **20**. 

## *Selecting number of clusters*

```{r}
wisc.hclust.clusters <- cutree(wisc.hclust, k = 4)
table(wisc.hclust.clusters, diagnosis)
```

> Q12. Can you find a better cluster vs diagnoses match by cutting into a different number of clusters between 2 and 10?

```{r}
wisc.hclust.clusters <- cutree(wisc.hclust, k = 8)
table(wisc.hclust.clusters, diagnosis)
```

While 4 clusters seems to split the diagnoses into malignant and non-malignant optimally, 8 clusters creats what seems to be another significant cluster of malignant tumors. This cluster could possibly be better. 

## *Using different methods*

> Q13. Which method gives your favorite results for the same data.dist dataset? Explain your reasoning.

Complete produces my favorite results since the graphical data is easily readable. It produces clusters with clear groups, so I am confident that the method is reliable. 

## K-means

```{r}
wisc.km <- kmeans(wisc.data, centers= 2, nstart= 20)
table(wisc.km$cluster, diagnosis)
```

> Q14. How well does k-means separate the two diagnoses? How does it compare to your hclust results?

Some minor overlap exists between the two clusters, which seems to be greater than the overlap present in the hclust results. 

## 5. Combining Methods

```{r}
wisc.pr.hclust <-hclust(dist(wisc.pr$x[,1:7]), method = "ward.D2")
plot(wisc.pr.hclust)
grps <- cutree(wisc.pr.hclust, k=2)
table(grps)
```

```{r}
table(grps, diagnosis)
```

```{r}
plot(wisc.pr$x[,1:2], col=grps)
plot(wisc.pr$x[,1:2], col=factor(diagnosis))
g <- as.factor(grps)
levels(g)
g <- relevel(g,2)
levels(g)
# Plot using our re-ordered factor 
plot(wisc.pr$x[,1:2], col=g)
wisc.pr.hclust.clusters <- cutree(wisc.pr.hclust, k=2)
```

> Q15. How well does the newly created model with four clusters separate out the two diagnoses?

```{r}
table(wisc.pr.hclust.clusters, diagnosis)
```
The two diagnoses are seperated from each other with minor overlap between the clusters as observalbe from the table. 

> Q16. How well do the k-means and hierarchical clustering models you created in previous sections (i.e. before PCA) do in terms of separating the diagnoses? Again, use the table() function to compare the output of each model (wisc.km$cluster and wisc.hclust.clusters) with the vector containing the actual diagnoses.

```{r}
wisc.hclust.clusters <- cutree(wisc.hclust, k = 4)
table(wisc.hclust.clusters, diagnosis)
table(wisc.km$cluster, diagnosis)
```

The hierarchical clustering model contains lower overlap between the two diagnoses in its clusters and contains a higher number of clusters while the K-means cluster has higher overlap, but this could be a result of a lower number of clusters. 

## 6. Sensitivity/Specificity

> Q17. Which of your analysis procedures resulted in a clustering model with the best specificity? How about sensitivity?

The combining models has higher sensitivity since it contains the highest number of malignant tumors in a single cluster. On the other hand, the K-means clustering model will have the highest specificity since it countains the highest number of benign tumors in a cluster. 

## 7. Prediction

```{r}
#url <- "new_samples.csv"
url <- "https://tinyurl.com/new-samples-CSV"
new <- read.csv(url)
npc <- predict(wisc.pr, newdata=new)
npc
```
```{r}
plot(wisc.pr$x[,1:2], col=g)
points(npc[,1], npc[,2], col="blue", pch=16, cex=3)
text(npc[,1], npc[,2], c(1,2), col="white")
```

> Q18. Which of these new patients should we prioritize for follow up based on your results?

Based on our results, individuals in cluster 2 should be prioritized. 




