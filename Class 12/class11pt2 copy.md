---
title: "Class 11 pt2"
format: pdf
---

> Q13. Read this file into R and determine the sample size for each genotype and their corresponding median expression levels for each of these genotypes. 

```{r}
req <- read.table("https://bioboot.github.io/bimm143_F22/class-material/rs8067378_ENSG00000172057.6.txt")
head(req)

table(req$geno)
```

The table function shows us the sample size for each pheontype in the dataset. The median value for A/A is 30, A/G is 25 and G/G is 20 as we will see in the boxplot generated in the next question. 

> Q14. Generate a boxplot with a box per genotype, what could you infer from the relative expression value between A/A and G/G displayed in this plot? Does the SNP effect the expression of ORMDL3?

```{r}
library(ggplot2)
ggplot(req, aes(geno, exp, fill = geno)) +
  geom_boxplot(notch = TRUE)
```

While the boxplots do not overlap between A/A and G/G, their error bars do. This suggests that they may have different distributions that are somewhat similar. It is likely that the SNP affects the expression of ORMDL3.
