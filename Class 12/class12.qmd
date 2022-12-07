---
title: "Class 12"
format: pdf
---

1. Bioconductor and DESeq2 setup

The required packages are installed and setup using the following commands:

```{r}
#install.packages("BiocManager")
#BiocManager::install()
#BiocManager::install("DESeq2")
```

2. Import countData and colData:

The required csv files are imported using the following commands:

```{r}
counts <- read.csv("https://bioboot.github.io/bimm143_W18/class-material/airway_scaledcounts.csv")

metadata <- read.csv("https://bioboot.github.io/bimm143_W18/class-material/airway_metadata.csv")
```

The following commands show the head of each imported csv:

```{r}
head(counts)
head(metadata)
```



> Q1. How many genes are in this dataset? 

```{r}
nrow(counts)
```

There are 38694 rows in the dataset. 

> Q2. How many 'control' cell lines do we have? 

```{r}
sum(metadata$dex == "control")
```

There are 4 'control' cell lines

3. Toy differential gene expression

```{r}
control <- metadata[metadata$dex=="control",]
control.counts <- counts[ ,control$id]
control.mean <- rowSums( control.counts )/4 
head(control.mean)
```

> Q3. How would you make the above code in either approach more robust?

Currently, the mean is calculated by dividing with the known number of controll cell lines. However, if extra lines are added, the mean iwll become incorrect since the denominator is hard coded to be 4, so it only finds the mean as if there were 5 elements. 

> Q4. Follow the same procedure for the `treated` samples. 

```{r}
treated <- metadata[metadata$dex=="treated",]
treated.mean <- rowSums( counts[ ,treated$id] )/4 
names(treated.mean) <- counts$ensgene
```


```{r}
meancounts <- data.frame(control.mean, treated.mean)
```

> Q5(a) Create a scatter plot showing the mean of the treated samples against the mean of the control samples. Your plot should look something like the following.

```{r}
plot(meancounts[,1], meancounts[,2], xlab = "Control", ylab = "Treated")
```

> Q5(b) You could also use the ggplot2 package to make this figure producing the plot below. What geom_?() function would you use for this plot?

```{r}
library(ggplot2)
ggplot(meancounts, aes(control.mean, treated.mean)) +
  geom_point() +
  xlab("Control") +
  ylab("Treated")
```

geom_point() is used for this plot.

> Q6. Try plotting both axes on a log scale. What is the argument to plot() that allows you to do this? 

```{r}
plot(meancounts[,1], meancounts[,2], xlab = "Control", ylab = "Treated", log="xy")
```

The argument is log = "xy"

```{r}
meancounts$log2fc <- log2(meancounts[,"treated.mean"]/meancounts[,"control.mean"])
head(meancounts)
```

```{r}
zero.vals <- which(meancounts[,1:2]==0, arr.ind=TRUE)

to.rm <- unique(zero.vals[,1])
mycounts <- meancounts[-to.rm,]
head(mycounts)
```


> Q7. What is the purpose of the arr.ind argument in the which() function call above? Why would we then take the first column of the output and need to call the unique() function?

The `arr.ind = TRUE` argument ensures that the which() function returns both row and comun indices with TRUE values. This shows us the genes and samples with their count as 0. The `unique()` funciton makes sures that we dont duplicate any of our data. 

```{r}
up.ind <- mycounts$log2fc > 2
down.ind <- mycounts$log2fc < (-2)
```

> Q8. Using the up.ind vector above can you determine how many up regulated genes we have at the greater than 2 fc level?

```{r}
sum(up.ind)
```

250 up regulated genes

> Q9. Using the down.ind vector above can you determine how many down regulated genes we have at the greater than 2 fc level? 

```{r}
sum(down.ind)
```

367 down regulated genes

> Q10. Do you trust these results? Why or why not?

The results can't be trusted since we don't know whether they are statistically significant or not.

4. DeSeq2 Analysis:

```{r}
library(DESeq2)
```

```{r}
counts <- read.csv("https://bioboot.github.io/bimm143_W18/class-material/airway_scaledcounts.csv", row.names = 1)

metadata <- read.csv("https://bioboot.github.io/bimm143_W18/class-material/airway_metadata.csv", row.names = 1)
dds <- DESeqDataSetFromMatrix(countData=counts, 
                              colData=metadata, 
                              design=~dex)
dds
```

```{r}
dds <- DESeq(dds)
```

```{r}
res <- results(dds)
res
```

```{r}
summary(res)
```

```{r}
res05 <- results(dds, alpha=0.05)
summary(res05)
```


