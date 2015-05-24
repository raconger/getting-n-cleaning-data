# Question 1

if(!file.exists("./data")){dir.create("./data")};
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv";
download.file(fileUrl,destfile="./data/data.csv",method="curl");
data <- read.csv("./data/data.csv");
head(data);

# Create a logical vector that identifies the households on greater than 10 acres 
# who sold more than $10,000 worth of agriculture products. 
# Assign that logical vector to the variable agricultureLogical. 
# Apply the which() function like this to identify the rows of 
# the data frame where the logical vector is TRUE. which(agricultureLogical) 
# What are the first 3 values that result?

data$agricultureLogical <- ((data$ACR == 3) & (data$AGS == 6));
which(data$agricultureLogical)

# Question 2

library(jpeg)
if(!file.exists("./data")){dir.create("./data")};
imgURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(imgURL,destfile="./data/image.jpeg",method="curl");

# read it also in native format
img.n <- readJPEG("./data/image.jpeg", TRUE)
head(img.n, n=3)

library(Hmisc)
img.n$zipGroups = cut2(img.n,g=10)
table(img.n$zipGroups)

# Question 3

GDPurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
EDUurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(GDPurl,destfile="./data/gdpdata.csv",method="curl");
gdpdata <- read.csv("./data/gdpdata.csv");
head(gdpdata, n=3);
download.file(EDUurl,destfile="./data/edudata.csv",method="curl");
edudata <- read.csv("./data/edudata.csv");
head(edudata, n=3);

# ranking was a filter type so it needed to be converted to numeric
gdpdata$rank <- as.numeric(as.character(gdpdata$Gross.domestic.product.2012))
# NAs created during conversion, this can filter out any unranked data
gdpfilt <- gdpdata[(gdpdata$rank >= 1) & (!is.na(gdpdata$rank)),]

mergedata <- merge(gdpfilt, edudata, by.x="X", by.y="CountryCode", all=FALSE)
head(mergedata, n=3)
attach(mergedata)
sortdata <- mergedata[order(-rank),]
detach(mergedata)
head(sortdata)
summary(sortdata$rank)
head(sortdata, n=13)
head(sortdata$rank, n=13)
head(sortdata$Short.Name, n=13)


mean(sortdata$rank)
mean(sortdata[sortdata$Income.Group == "High income: OECD",]$rank)
mean(sortdata[sortdata$Income.Group == "High income: nonOECD",]$rank)

sortdata$rankGroups <- cut2(sortdata$rank,g=5)
library(reshape2)
gdpdata <- dcast(sortdata, rankGroups ~ Income.Group)
gdpdata
