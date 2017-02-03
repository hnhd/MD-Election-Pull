# load packages
library(RCurl)
library(XML)
library(stringr)
library(plyr)

# load preliminary data
county_precinct_names <- read.csv('MD Precinct-County List - Sen.csv', stringsAsFactors = FALSE) # load in precinct/county IDs
county_value <- as.numeric(county_precinct_names$county) # convert to numeric
precinct_value <- as.numeric(county_precinct_names$precinct)# convert to numeric
weburl <- character(0) # create weburl vector
df <- data.frame(county_value, # create empty data frame
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
                 rep(NA, length(county_value)),
                 stringsAsFactors = FALSE)
  
# grab data from the internet
for (i in 1:length(county_value)) {
  weburl[i] <- sprintf("https://www.electionwareresults.com/webResults/pollplace-%s-%s-Publish.html", county_value[i], precinct_value[i])
  if(nrow(ldply(readHTMLTable(getURL(weburl[i])), rbind)) == 0) { next } else { # skips blank/empty pages
    table <- subset(ldply(readHTMLTable(getURL(weburl[i])), rbind), Party == 'Democratic')
    df[i, 3] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Freddie Dickson"])))
    df[i, 4] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Donna Edwards"])))
    df[i, 5] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Ralph Jaffe"])))
    df[i, 6] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Theresa Scaldaferri" | table$Candidate == "Theresa C. Scaldaferri"])))
    df[i, 7] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Charles Smith"])))
    df[i, 8] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Violet Staley"])))
    df[i, 9] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Blaine Taylor"])))
    df[i, 10] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Ed Tinus"])))
    df[i, 11] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Chris Van Hollen"])))
    df[i, 12] <- as.numeric(levels(droplevels(table$Votes[table$Candidate == "Lih Young"])))
  }
}

# rename the columns
colnames(df) <- c("County ID", "Precinct", "Freddie Dickson", "Donna Edwards", "Ralph Jaffe", "Theresa Scaldaferri", "Charles Smith", "Violet Staley", "Blaine Taylor", "Ed Tinus", "Chris Van Hollen", "Lih Young")

# export csv
write.csv(df, "statewide-sen-1.csv")
