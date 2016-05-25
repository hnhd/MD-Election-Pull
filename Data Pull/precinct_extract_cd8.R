# load packages
library(RCurl)
library(XML)
library(stringr)
library(plyr)

# load preliminary data
county_precinct_names <- read.csv('MD Precinct-County List - CD8.csv', stringsAsFactors = FALSE)
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
                 rep(NA, length(county_value)),
                 rep(NA, length(county_value)),
                 rep(NA, length(county_value)),
                 stringsAsFactors = FALSE)

# grab data from the internet
for (i in 1:length(county_value)) {
  weburl[i] <- sprintf("https://www.electionwareresults.com/webResults/pollplace-%s-%s-Publish.html", county_value[i], precinct_value[i])
  table <- subset(ldply(readHTMLTable(getURL(weburl[i])), rbind), Party == 'Democratic')
  df[i, 3] <- ifelse(length(table$Votes[table$Candidate == "David Anderson"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "David Anderson"]))))
  df[i, 4] <- ifelse(length(table$Votes[table$Candidate == "Kumar Barve"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Kumar Barve"]))))
  df[i, 5] <- ifelse(length(table$Votes[table$Candidate == "Dan Bolling"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Dan Bolling"]))))
  df[i, 6] <- ifelse(length(table$Votes[table$Candidate == "Ana Gutierrez"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Ana Gutierrez"]))))
  df[i, 7] <- ifelse(length(table$Votes[table$Candidate == "William Jawando"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "William Jawando"]))))
  df[i, 8] <- ifelse(length(table$Votes[table$Candidate == "Kathleen Matthews"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Kathleen Matthews"]))))
  df[i, 9] <- ifelse(length(table$Votes[table$Candidate == "Jamie Raskin"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Jamie Raskin"]))))
  df[i, 10] <- ifelse(length(table$Votes[table$Candidate == "Joel Rubin"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "Joel Rubin"]))))
  df[i, 11] <- ifelse(length(table$Votes[table$Candidate == "David Trone"]) == 0, NA, as.numeric(levels(droplevels(table$Votes[table$Candidate == "David Trone"]))))
}

table

# rename the columns
colnames(df) <- c("County ID", "Precinct", "David Anderson", "Kumar Barve", "Dan Bolling", "Ana Gutierrez", "William Jawando", "Kathleen Matthews", "Jamie Raskin", "Joel Rubin", "David Trone")

# export csv
write.csv(df, "cd8.csv")
