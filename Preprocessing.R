#URL of dataset: https://github.com/eddwebster/football_analytics/tree/master/data/fbref/raw/outfield
 
# This script is used to clean the data from fbref_outfield_player_stats_combined_latest.csv
data = read.csv("fbref_outfield_player_stats_combined_latest.csv",
                header = TRUE, na.strings=c(""," ","NA"),
                check.names = FALSE)
# Extract different seasons
d17 = data[data$Season == '2017-2018',]
d18 = data[data$Season == '2018-2019',]
d19 = data[data$Season == '2019-2020',]
d20 = data[data$Season == '2020-2021',]
d21 = data[data$Season == '2021-2022',]

# For each season, keep players who are not in the next season
# This is to avoid duplicated players and,
# to keep the last version of the player in the dataset
d20 = d20[!(d20$Player %in% d21$Player), ]
d21 = rbind(d21 , d20)
rm(d20)

d19 = d19[!(d19$Player %in% d21$Player), ]
d21 = rbind(d21 , d19)
rm(d19)

d18 = d18[!(d18$Player %in% d21$Player), ]
d21 = rbind(d21 , d18)
rm(d18)

d17 = d17[!(d17$Player %in% d21$Player), ]
d21 = rbind(d21 , d17)
rm(d17)
# remove row which was like header
d21 = d21[d21$Starts != 'Starts',]

# Evaluate missing values
sum(is.na(d21))
c = colSums(is.na(d21))
c[colSums(is.na(d21)) > 0]

# remove 11 players who has many missing values
miss= d21[is.na(d21$onxGA),]
d21 = d21[!(d21$Player %in% miss$Player), ]
rm(miss)

data = d21
rm(d21, c)

c = colSums(is.na(data))
c[colSums(is.na(data)) > 0]

# remove 10 players with missing OG
miss= data[is.na(data$OG),]
data = data[!(data$Player %in% miss$Player), ]

c = colSums(is.na(data))
c[colSums(is.na(data)) > 0]

# remove 50 players with missing Cmp%
miss= data[is.na(data$`Cmp%`),]
data = data[!(data$Player %in% miss$Player), ]

c = colSums(is.na(data))
c[colSums(is.na(data)) > 0]

# remove 16 players with missing Rec%
miss= data[is.na(data$`Rec%`),]
data = data[!(data$Player %in% miss$Player), ]


c = colSums(is.na(data))
c[colSums(is.na(data)) > 0]

# 10 + 11 + 50 + 16 = 87 players removed in total

# remove 17 columns with many missing values(min = 104)
data = data[ , colSums(is.na(data)) == 0]
sum(is.na(data))
rm(miss, c)

data = data[,-c(33, 145:147)]


# remove duplicated columns 
r = c("Gls.1", "Ast.1", "G-PK.1", "xG.1", "xA.1",
      "npxG.1", "npxG+xA.1", "Att.1", "Cmp.2", "Att.2",
      "Cmp.3", "Att.3", "Out.1", "PassLive.1", "PassDead.1",
      "Drib.1", "Sh.1", "Fld.1", "Def.1", "Tkl.1", "Def 3rd.1", "Mid 3rd.1",
      "Att 3rd.1")
data = data[ , -which(names(data) %in% r)]
rm(r)
# 17 + 3 + 23 = 43 columns removed in total
write.csv(data, 'data_aggregated.csv', row.names = FALSE)
