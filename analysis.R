# installing packages
install.packages(c("ggplot2", "readr"))

# loading libraries
library(ggplot2)
library(readr)

setwd("./CSProjects/DSProjects/spotify-music-analysis")

###########
# LOADING AND INSPECTING DATA
###########

spotify_data = read_csv("./data/spotify_data clean.csv")
head(spotify_data)
str(spotify_data)

###########
# DATA CLEANING
###########

# checking for missing values
missing_data = colSums(is.na(spotify_data))
missing_data
# removing missing values
spotify_data_clean = na.omit(spotify_data)
# recheck data structure
str(spotify_data_clean)

###########
# EXPLORATORY DATA ANALYSIS (EDA)
###########
# TRACK POPULARITY
summary(spotify_data_clean$track_popularity)
# track popularity distribution: before zero removal
ggplot(spotify_data_clean, aes(x = track_popularity)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Track Popularity Distribution (Before Zero Removal)", 
       x = "Popularity",
       y = "Frequency")
# boxplot for outlier check
boxplot(spotify_data_clean$track_popularity, main = "Track Popularity Boxplot")
# normality check: before zero removal
qqnorm(spotify_data_clean$track_popularity)
qqline(spotify_data_clean$track_popularity, col="red")

# REMOVING ZEROS
spotify_data_clean = spotify_data_clean[spotify_data_clean$track_popularity != 0, ]

# track popularity distribution: after zero removal
ggplot(spotify_data_clean, aes(x = track_popularity)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Track Popularity Distribution (After Zero Removal)", 
       x = "Popularity",
       y = "Frequency")
# normality check: after zero removal
qqnorm(spotify_data_clean$track_popularity)
qqline(spotify_data_clean$track_popularity, col = "red")

# updated summary
summary(spotify_data_clean$track_popularity)
# clearly still skewed left but less compared to before zero removal

#######################################################

# EXPLICITNESS
ggplot(spotify_data_clean, aes(x = explicit)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Distribution of Explicit Tracks", 
       x = "Explicit", y = "Count")

#######################################################

# ARTIST POPULARITY
# summary statistics and distribution: before outlier removal
summary(spotify_data_clean$artist_popularity)
ggplot(spotify_data_clean, aes(x = artist_popularity)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Artist Popularity Distribution Before Outlier Removal", 
       x = "Popularity", y = "Frequency")
# boxplot: before outlier removal
boxplot(spotify_data_clean$artist_popularity, 
        main = "Artist Popularity Boxplot")
# normality check: before outlier removal
qqnorm(spotify_data_clean$artist_popularity)
qqline(spotify_data_clean$artist_popularity, col="red")

# REMOVING OUTLIERS WITH 1.5IQR RULE
Q1 = quantile(spotify_data_clean$artist_popularity, 0.25)
Q3 = quantile(spotify_data_clean$artist_popularity, 0.75)
IQR = Q3 - Q1
lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR
# removal
spotify_data_clean = spotify_data_clean[
  spotify_data_clean$artist_popularity >= lower_bound &
    spotify_data_clean$artist_popularity <= upper_bound, ]
# boxplot: after outlier removal using 1.5IQR
# NOTE: plotting uses diff rule (not 1.5IQR is used)
# so potential outliers are still shown
boxplot(spotify_data_clean$artist_popularity, 
        main = "Artist Popularity (After 1.5IQR)")
# distribution: after outlier removal
ggplot(spotify_data_clean, aes(x = artist_popularity)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Artist Popularity Distribution", 
       x = "Popularity", y = "Frequency")
# normality check: after outlier removal
qqnorm(spotify_data_clean$artist_popularity)
qqline(spotify_data_clean$artist_popularity, col="red")

#######################################################

# ARTIST GENRES
track_ids = c()
artist_genres = c()
# loops each row in spotify_data_clean
for (i in 1:nrow(spotify_data_clean)) {
  # split genre string into individual genres via comma
  genres = strsplit(spotify_data_clean$artist_genres[i], ",")[[1]]
  
  # only considers genres that are real genres
  # COMMENT OUT FOR ORIGINAL BAR PLOT THAT INCLUDES N/A
  genres = genres[genres != "N/A" & genres != ""]
  
  # repeat track_id for each genre
  # allows for each row of data frame to represent one (track, genre) pair
  track_ids = c(track_ids, rep(spotify_data_clean$track_id[i], length(genres)))
  # add genres to the artist_genres vector
  artist_genres = c(artist_genres, genres)
}
# new data frame with track_ids and artist_genres
spotify_data_df = data.frame(track_id = track_ids, 
                                artist_genres = artist_genres)
# count the occurrences of each genre
genre_counts = table(spotify_data_df$artist_genres)
# top 10 most frequent/common genres
top_genres = sort(genre_counts, decreasing = TRUE)[1:10]
top_genres
# bar plot for the top 10 genres
ggplot(data.frame(artist_genres = names(top_genres), 
                  count = as.vector(top_genres)), 
       aes(x = reorder(artist_genres, count), y = count)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Top 10 Artist Genres", x = "Genre", y = "Count")

#######################################################

# ALBUM TYPE
ggplot(spotify_data_clean, aes(x = album_type)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Count of Tracks by Album Type", 
       x = "Album Type", y = "Count")

#############
# RESEARCH QUESTIONS
#############

# Do tracks with higher artist popularity tend to have higher track popularity?
# USE correlation or linear regression
# correlation between artist popularity and track popularity
cor_result = cor(spotify_data_clean$artist_popularity, 
                  spotify_data_clean$track_popularity)
cor_result

# scatterplot
ggplot(spotify_data_clean, aes(x = artist_popularity, y = track_popularity)) + 
  geom_point(alpha = 0.5, color = "blue") + 
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(title = "Relationship between Artist Popularity and Track Popularity", 
       x = "Artist Popularity", y = "Track Popularity")

# linear regression model
lm_model = lm(track_popularity ~ artist_popularity, data = spotify_data_clean)
summary(lm_model)

# Is there a significant difference in track popularity between explicit
# and non-explicit tracks?
# USE two-sample t-test to compare the means of track popularity.
t_test_result = t.test(track_popularity ~ explicit, data = spotify_data_clean)
t_test_result

# Do tracks from albums tend to be more popular than singles?
# USE ANOVA
# excludes compilation type
spotify_data_clean_filtered = spotify_data_clean[spotify_data_clean$album_type != "compilation", ]
aov_result = aov(track_popularity ~ album_type,
                 data = spotify_data_clean_filtered)
summary(aov_result)
TukeyHSD(aov_result)
# boxplot
ggplot(spotify_data_clean, 
       aes(x = album_type, y = track_popularity, fill = album_type)) + 
  geom_boxplot() +
  labs(title = "Track Popularity by Album Type", 
       x = "Album Type", y = "Track Popularity") +
  scale_fill_manual(values = c("skyblue", "lightgreen","red"))
