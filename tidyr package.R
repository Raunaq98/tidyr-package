URL1 <- "https://raw.githubusercontent.com/rstudio/EDAWR/master/data-raw/pollution.csv"
URL2 <- "https://raw.githubusercontent.com/rstudio/EDAWR/master/data-raw/storms.csv"
URL3 <- "https://raw.githubusercontent.com/rstudio/EDAWR/master/data-raw/cases.csv"

directory<- getwd()

destfile1<- paste0(directory,"/pollution.csv")
destfile2<- paste0(directory,"/storms.csv")
destfile3<- paste0(directory,"/cases.csv")

download.file(URL1,destfile1,method="curl")
download.file(URL2,destfile2,method="curl")
download.file(URL3,destfile3,method="curl")

pollution <- read.csv(paste0(directory,"/pollution.csv"),header = TRUE, as.is = TRUE)
storms <- read.csv(paste0(directory,"/storms.csv"),header = TRUE, as.is = TRUE)
cases <- read.csv(paste0(directory,"/cases.csv"),header = TRUE, as.is = TRUE)

library(tidyr)

print(storms)
#    storm     wind  pressure       date
#1 Alberto     110     1007     2000-08-03
#2    Alex      45     1009     1998-07-27
#3 Allison      65     1005     1995-06-03
#4     Ana      40     1013     1997-06-30
#5  Arlene      50     1010     1999-06-11
#6  Arthur      45     1010     1996-06-17

##### the stroms data is tidy because eac h column contains a different variable
# that has corresponding values in rows

print(cases)
#   country  X2011  X2012  X2013
#1      FR   7000   6900    7000
#2      DE   5800   6000    6200
#3      US  15000  14000   13000

#### the columns 2011, 2012 and 2013 are same variables and hence should be in a single column
# the values of each country and year are spread across different rows, these should be in a single column as well

gather(cases,year, count, 2:4)   # 2:4 because we want to keep column 1
#   country  year   count
#1      FR   X2011  7000
#2      DE   X2011  5800
#3      US   X2011 15000
#4      FR   X2012  6900
#5      DE   X2012  6000
#6      US   X2012 14000
#7      FR   X2013  7000
#8      DE   X2013  6200
#9      US   X2013 13000


print(pollution)
#       city   size    amount
#1 New York   large     23
#2 New York   small     14
#3   London   large     22
#4   London   small     16
#5  Beijing   large    121
#6  Beijing   small     56

# the pollution dataset has sets of large and small sizes spread
# we can change this using spread()

spread(pollution,size, amount)
#       city  large  small
# 1  Beijing   121    56
# 2   London    22    16
# 3 New York    23    14


############### unite and separate

# we now want to extract day month and year from storms data

separate(storms,date, c("year","month","date"), sep="-")
#   storm  wind   pressure year  month date
#1 Alberto  110     1007   2000    08   03
#2    Alex   45     1009   1998    07   27
#3 Allison   65     1005   1995    06   03
#4     Ana   40     1013   1997    06   30
#5  Arlene   50     1010   1999    06   11
#6  Arthur   45     1010   1996    06   17

temp<- separate(storms,date, c("year","month","date"), sep="-")
unite(temp,"date",day,month,year,sep="~")
#    storm  wind  pressure       date
#1 Alberto  110     1007     2000~08~03
#2    Alex   45     1009     1998~07~27
#3 Allison   65     1005     1995~06~03
#4     Ana   40     1013     1997~06~30
#5  Arlene   50     1010     1999~06~11
#6  Arthur   45     1010     1996~06~17


library(dplyr)
pollution %>% group_by(city)
# A tibble: 6 x 3
# Groups:   city [3]
#     city     size  amount
#     <chr>    <chr>  <int>
#  1 New York large     23
#  2 New York small     14
#  3 London   large     22
#  4 London   small     16
#  5 Beijing  large    121
#  6 Beijing  small     56

pollution %>% group_by(city) %>% summarise(mean=mean(amount),sum=sum(amount), count=n())
# A tibble: 3 x 4
#     city      mean   sum count
#     <chr>    <dbl> <int> <int>
#  1 Beijing   88.5   177     2
#  2 London    19      38     2
#  3 New York  18.5    37     2

pollution %>% ungroup()  # always ungroup after analysis
