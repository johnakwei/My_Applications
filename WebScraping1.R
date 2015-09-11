library(rvest)

# Multiple Web Scraping blogs
https://rstudio-pubs-static.s3.amazonaws.com/73547_efa9faf0166648c0809dcfa5690819ad.html

# Wikipedia information
# First, grab the page source
html("http://en.wikipedia.org/wiki/Table_(information)") %>%
  # then extract the first node with class of wikitable
  html_node(".wikitable") %>% 
  # then convert the HTML table into a data frame
  html_table()

# SEC information
html("http://www.sec.gov/litigation/suspensions.shtml") %>%
  html_nodes("p+ table a") %>% head

# ISU Statistics Faculty information
html("http://www.stat.iastate.edu/people/faculty/") %>%
  html_nodes("#content a") %>% html_attr(name="href") -> hrefs
head(hrefs)

# Instacart information
html("http://www.instacart.com") %>%
  # then convert the HTML table into a data frame
  html_table()

# Access to Domain
library(RSelenium)
startServer()
remDr <- remoteDriver(browserName="chrome")
remDr$open()
for (i in hrefs) {
  Sys.sleep(2)
  remDr$navigate(i) # at this point, you could remDr$getPageSource()
}

# XML information
# devtools::install_github("cpsievert/XML2R")
library(XML2R)
obs <- XML2Obs("http://bit.ly/mario-xml")
table(names(obs))

library(magrittr)
XML2Obs("http://gd2.mlb.com/components/game/mlb/year_2011/month_04/day_04/gid_2011_04_04_minmlb_nyamlb_1/players.xml") %>% 
  add_key(parent = "game", recycle = "venue") %>% 
  add_key(parent = "game", recycle = "date") %>%
  collapse_obs -> tabs
tabs[["game//team//player"]][1:5, c("first", "last", "venue", "date")]

library(jsonlite)
mario <- fromJSON("http://bit.ly/mario-json")
str(mario) # nested data.frames?!?

vehicles <- mapply(function(x, y) cbind(x, driver = y), 
                   mario$vehicles, mario$driver, SIMPLIFY = FALSE)
rbind.pages(vehicles)
mario[!grepl("vehicle", names(mario))]

# BBC Web Scraping
#In code
bbcScraper <- function(url){
  SOURCE <-  getURL(url,encoding="UTF-8")
  PARSED <- htmlParse(SOURCE)
  title=xpathSApply(PARSED, "//h1[@class='story-header']",xmlValue)
  date=as.character(xpathSApply(PARSED, "//meta[@name='OriginalPublicationDate']/@content"))
  if (is.null(date))    date <- NA
  if (is.null(title))    title <- NA
  return(c(title,date))
}


require(RCurl)
require(XML)
urls <- c("http://www.bbc.co.uk/news/uk-england-york-north-yorkshire-26413963")
results=NULL
for (url in urls){
  newEntry <- bbcScraper(url)
  results <- rbind(results, newEntry)
}
data.frame(results) #ignore the warning

