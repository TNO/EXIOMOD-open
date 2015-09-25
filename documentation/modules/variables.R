rm(list=ls())
.libPaths("~/Dropbox/rdir2/library_win")
setwd("~/GitHub/TNO-Eco-Mod/documentation/modules")

library(rCharts)
library(rjson)
library(igraph)

#creating vector of variables
variables = c("Production","Demand","Trade","Closure")

for (i in seq_along(variables))
{
#reading in the data mapping variables and modules
df = read.csv("Variablesandmodules.csv", sep = ";", header = TRUE, dec = ",")
colnames(df) = c("module","source","target","value")
df = df[df$module == variables[i] ,]
#add same module
df2 = aggregate(value~module+source,df,sum)
df2[,3] = df2[,3] + 1
#add reverse flow
df3 = as.data.frame(cbind(as.character(df2[,2])
   ,as.character(df2[,1])
   ,df2[,3]
    ))
df3[,3] = 1
#replace name in df2 with (origin)
df3[,2] = paste(df3[,2],"(origin)",sep="")
#join the three dfs
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
sankeyPlot$save(paste(variables[i],'.html',sep=''),cdn=TRUE)
}
