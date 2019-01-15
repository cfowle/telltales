###############################################################################
##  Project: Regatta Results
##  File Purpose: Master file telltales data sourcing
##  Owner: Carrie Fowle
##  Last Updated: January 15, 2018
###############################################################################

library(dplyr)
library(ggplot2)
library(magrittr)
library(readr)
library(stringdist)
library(stringr)
library(tidyr)

setwd("~/code/telltales/scripts")

##pull data from the web
source("scrape_data.R")