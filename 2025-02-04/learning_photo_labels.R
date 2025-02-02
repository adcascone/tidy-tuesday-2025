library(png)
library(ggtext)
library(tidyverse)
lincoln <- readPNG("test.png") # replace with whatever
labels <- c(virginica = "<img src='test.png' width='100' /><br>*virginica*") # replace with whatever


df <- iris %>% 
  filter(Species == "virginica")

ggplot(df, aes(Species, Sepal.Length)) +
  geom_col() +
  scale_x_discrete(labels = labels) +
  theme(axis.text.x = ggtext::element_markdown())