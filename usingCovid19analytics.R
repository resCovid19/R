#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Script File: usingCovid19analytics.R  
# Date of creation: 06 April 2030
# Date of last modification: 06 April 2020
# Author: Seraya Maouche <seraya.maouche@tbiscientific.com>
# Short Description: This script provides examples on using the using covid19.analytics R Package
# This script is based on the covid19.analytics documentation.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# === Delete all object in R
rm(list = ls())

# Installing depending packages
requiredPackages <- c("dplyr","knitr","tidyr","devtools","gganimate","utils","sp","rgdal","ggplot2",
                        "ggthemes","reshape2","ape","plotly","deSolve","htmlwidgets","roxygen2")
                      
# installed.packages(requiredPackages)
install.packages(requiredPackages)

#**********************  Installing covid19.analytics from CRAN
install.packages("covid19.analytics")
   

#********************** Installing development version from GitHub
#if (!require("devtools")) install.packages("devtools")
# devtools::install_github("mponce0/covid19.analytics")

#********************** Load COVID19 library
library(covid19.analytics)
library(ggplot2)
library(dplyr)

# ============================ Load data
# covid19.data () function will download time series worldwide COVID-19 data of reported cases
# from the Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE) data repository

# The parameter "case" is a string indicating the category of the data.
# possible values are: "aggregated" : latest number of cases *aggregated* by country, 
# "ts-confirmed" : time data of confirmed cases, 
# "ts-deaths" : time series data of fatal cases, 
# "ts-recovered" :  time series data of recovered cases, 
# "ts-ALL" : all time series data combined,
# "ts-dep-confirmed" : time series data of confirmed cases as originally reported (depricated), 
# "ts-dep-deaths" : time series data of deaths as originally reported (depricated), 
# "ts-dep-recovered" : time series data of recovered cases as originally reported (depricated), 
#  "ALL": all of the above

covid19data <- covid19.data(case = "ALL", local.data = FALSE, debrief = FALSE)

# ====== Save Covid-19 data as an R object 
fileName <- paste ("covid19data","5April2020",sep="_")
saveRDS(covid19data, file = paste(fileName, ".rds", sep=""))
# The file can be read using data <- readRDS(file = "covid19data_5April2020.rds")

# === Get the latest aggregated COVID-19 data
covid19.ALL.agg.cases <- covid19.data("aggregated")

# === Reading time series data for casualities
covid19.TS.deaths <- covid19.data("ts-deaths")

# === Get time series data for "confirmed" cases
covid19.confirmed.cases <- covid19.data("ts-confirmed")

# ==== Read the latest aggregated data
covid19.ALL.agg.cases <- covid19.data("aggregated")

# =====  Summary Report
par(mar=c(1,1,1,1))
report.summary(cases.to.process = "ALL", Nentries = 10,
               graphical.output = TRUE,saveReport = TRUE)

# totals for confirmed cases for "France"
# function to compute totals per location
tots.per.location(covid19.confirmed.cases, geo.loc="France",confBnd = TRUE, 
                  nbr.plts = 1,info = "")

# Total for death cases for "ALL" the regions
tots.per.location(covid19.TS.deaths)

# Total for confirmed cases for "All" regions
tots.per.location(covid19.data("ts-confirmed"))


# Read time series data for confirmed cases
TS.data <- covid19.data("ts-confirmed")

# Compute changes and growth rates per location for all the countries
growth.rate(TS.data)

# Retrieve time series data
TS.data <- covid19.data("ts-ALL")

# ==== Static and interactive plot 
totals.plt(TS.data)
growth.rate(TS.data,geo.loc="France")

#==== compute changes and growth rates per location for 'Italy' and 'Germany'
growth.rate(TS.data,geo.loc=c("Italy","Germany"))


# retrieve aggregated data
data <- covid19.data("aggregated")

# ==== Interactive map of aggregated cases -- with more spatial resolution
live.map(data)
live.map()

# ========= simmulation
# read time series data for confirmed cases
data <- covid19.data("ts-confirmed")

# ===  A SIR model for a given geographical location
generate.SIR.model(data,"Hubei", t0=1,t1=15)
generate.SIR.model(data,"France",tot.population=65239906)

# ==== Modelling (SIR Model)
world.SIR.model <- generate.SIR.model(data,"ALL", t0=1,t1=15, tot.population=7.8e9, staticPlt=FALSE)

# === Visualizing the model
plot.SIR.model(world.SIR.model,"World",interactiveFig=TRUE,fileName="world.SIR.model")
