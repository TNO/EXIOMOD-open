# File:   variables.R
# Author: Trond Husby
# Date:   29/09/2015
#
# This script generates a Sankey plot in html showing the modules where
# the variables in the base model show up, showing how the modules are linked.
#
# Input parameters:
#   modules            A vector of modules
#   df                 A data file linking variables to modules


#administration
rm(list=ls())
setwd("~/GitHub/TNO-Eco-Mod/documentation/modules")
#set the library where R packages are stored
.libPaths("~/Dropbox/rdir2/library_win")

#read in packages needed to generate Sankey plot
library(rCharts)
library(rjson)
library(igraph)

#creating vector of modules
modules = c("Production","Demand","Trade","Closure")

for (i in modules) {
#reading in the data mapping variables and modules
    df = read.csv("Variablesandmodules.csv", sep = ";", header = TRUE, dec = ",")
    colnames(df) = c("module","source","target","value")
    df = df[df$module == i ,]
#create new data.frame where add same module
    df2 = aggregate(value~module+source,df,sum)
    df2[,3] = df2[,3] + 1
#create new data.frame adding reverse flow
    df3 = as.data.frame(cbind(as.character(df2[,2])
       ,as.character(df2[,1])
       ,df2[,3]
    ))
    df3[,3] = 1
    df3[,2] = paste(df3[,2],"(origin)",sep="")
#join the three data.frames
    df = df[,-1]
    names(df2)=names(df)
    names(df3)=names(df)
    df3[,3] = as.numeric(df3[,3])
    df = rbind(df3,df,df2)
    df = df[df$value != 0,]
#Generate plot
    sankeyPlot = rCharts$new()
    sankeyPlot$setLib('http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey')
    sankeyPlot$set(
        data = df,
        nodeWidth = 10,
        nodePadding = 5,
        layout = 32,
        width = 1200,
        height = 800
    )
    print(sankeyPlot)
    sankeyPlot$save(paste(i,'.html',sep=''),cdn=TRUE)
}
