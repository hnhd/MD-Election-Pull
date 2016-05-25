# load packages
library(RCurl)
library(XML)
library(stringr)
library(plyr)

# load preliminary data
county_precinct_names <- read.csv('MD Precinct-County List - CD4.csv', stringsAsFactors = FALSE)
county_value <- as.numeric(county_precinct_names$county)
precinct_value <- as.numeric(county_precinct_names$precinct)
weburl <- character(0)
df <- data.frame(county_value,
                 precinct_value,
                 rep(NA, length(county_value)),
                 rep(NA, length(county_value)),
                 rep(NA, length(county_value)),
                 rep(NA, length(county_value)),
                 rep(NA, length(county_value)),
                 rep(NA, length(county_value)),
                 stringsAsFactors = FALSE)

# grab data from the internet
for (i in 1:length(county_value)) {
  weburl[i] <- sprintf("https://www.electionwareresults.com/webResults/pollplace-%s-%s-Publish.html", county_value[i], precinct_value[i])
  table <- subset(ldply(readHTMLTable(getURL(weburl[i])), rbind), Party == 'Democratic')
  df[i, 3] <- ifelse(length(table$Votes[table$Candidate == "Anthony Brown"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Anthony Brown"]))))
  df[i, 4] <- ifelse(length(table$Votes[table$Candidate == "Warren Christopher"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Warren Christopher"]))))
  df[i, 5] <- ifelse(length(table$Votes[table$Candidate == "Matthew Fogg"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Matthew Fogg"]))))
  df[i, 6] <- ifelse(length(table$Votes[table$Candidate == "Glenn Ivey"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Glenn Ivey"]))))
  df[i, 7] <- ifelse(length(table$Votes[table$Candidate == "Joseline Pena-Melnyk"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Joseline Pena-Melnyk"]))))
  df[i, 8] <- ifelse(length(table$Votes[table$Candidate == "Terence Strait"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Terence Strait"]))))
}

# rename the columns
colnames(df) <- c("County ID", "Precinct", "Anthony Brown", "Warren Christopher", "Matthew Fogg", "Glenn Ivey", "Joseline Pena-Melnyk", "Terence Strait")

# export csv
write.csv(df, "cd4.csv")
