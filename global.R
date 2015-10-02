library(shiny)
library(ggplot2)
library(reshape2)
library(plyr)
library(lubridate)
library(xts)
library(shinydashboard)
library(scales)
library(devtools)
library(dygraphs)
library(lme4)
library(data.table)

### Ajay Pillarisetti, University of California, Berkeley, 2015
### V1.0N

# install missing packages.
# list.of.packages <- c("shiny","reshape2","plyr","lubridate","data.table","dygraphs","xts","devtools","shinydashboard","shinyBS","scales")
# 	new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages))(print(paste("The following packages are not installed: ", new.packages, sep="")))else(print("All packages installed"))
# if(length(new.packages)) install.packages(new.packages)
# lapply(list.of.packages,function(x){library(x,character.only=TRUE)}) 

#global functions
alt.diff <- function (x, n = 1, na.pad = TRUE) {
  NAs <- NULL
  if (na.pad) {NAs <- rep(NA, n)}
  diffs <- c(NAs, diff(x, n))
}

round.minutes <- function(x, noOfMinutes=5){
	tz <- tz(x[1])
	class <- class(x[1])
	structure((noOfMinutes*60) * (as.numeric(x + (noOfMinutes*60*0.5)) %/% (noOfMinutes*60)), class=class,tz=tz)
}

read.squid <-  function(x, skip=2){

	#import
	dta <- fread(x,header=F,skip=skip, colClasses=c('character','character','character','character','character','character','character'))

	#name columns
	setnames(dta,1:ncol(dta),c('dt','batt','degC','ppm1','ppm2','ppm3','ppm4'))

	#convert to time, add appropriate timezlone
	dta[,datetime:=ymd_hms(dt, tz="Asia/Kathmandu")]

	#add squidid
	dta[,sqd_id:=strsplit(x,'-')[[1]][2]]

	#get hhid -- lots of ways to do this
	dta[,hhid:=strsplit(strsplit(x,'-')[[1]][1],'/')[[1]][6]]

	#conform all columns to double (otherwise get warning from data.table)
	#this also catches any sensors that are malfunctioning or not available and sets them to NA, as opposed to HEX
	dta[,ppm1:=suppressWarnings(as.double(ppm1))]
	dta[,ppm2:=suppressWarnings(as.double(ppm2))]
	dta[,ppm3:=suppressWarnings(as.double(ppm3))]
	dta[,ppm4:=suppressWarnings(as.double(ppm4))]
	dta[,degC:=suppressWarnings(as.double(degC))]

	as.xts.data.table(dta[,c('datetime','ppm1','ppm2','ppm3','ppm4'),with=F])
}

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
