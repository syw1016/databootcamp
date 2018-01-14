# Dependencies
import tweepy
import json
import numpy as np
import pandas as pd
# Import and Initialize Sentiment Analyzer
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
analyzer = SentimentIntensityAnalyzer()

import re

emoji_pattern = re.compile(
  u"(\ud83d[\ude00-\ude4f])|"  # emoticons
  u"(\ud83c[\udf00-\uffff])|"  # symbols & pictographs (1 of 2)
  u"(\ud83d[\u0000-\uddff])|"  # symbols & pictographs (2 of 2)
  u"(\ud83d[\ude80-\udeff])|"  # transport & map symbols
  u"(\ud83c[\udde0-\uddff])"  # flags (iOS)
  "+", flags=re.UNICODE)

# Twitter API Keys
consumer_key = "Ed4RNulN1lp7AbOooHa9STCoU"
consumer_secret = "P7cUJlmJZq0VaCY0Jg7COliwQqzK0qYEyUF9Y0idx4ujb3ZlW5"
access_token = "839621358724198402-dzdOsx2WWHrSuBwyNUiqSEnTivHozAZ"
access_token_secret = "dCZ80uNRbFDjxdU2EckmNiSckdoATach6Q8zb7YYYE5ER"

# Setup Tweepy API Authentication
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth, parser=tweepy.parsers.JSONParser())

# Target User Accounts
target_media = ("@BBC", "@CBS", "@CNN", "@FoxNews", "@nytimes")
target_media = ["@BBC"]

# Loop through each user
for media in target_media:

  # Variables for holding sentiments
  compound_list = []
  positive_list = []
  negative_list = []
  neutral_list = []
  tweet_source_list = []
  tweet_text_list = []
  tweet_date_list = []
  
  # Loop through 10 pages of tweets (total 200 tweets)
  for x in range(10):

    # Get all tweets from home feed
    public_tweets = api.user_timeline(media, page=x)

    # Loop through all tweets
    for tweet in public_tweets:
      # print(json.dumps(tweet, sort_keys=True, indent=4, separators=(',', ': ')))
      tweet_text = emoji_pattern.sub('', tweet["text"])
      print(tweet_text)
      # Run Vader Analysis on each tweet
      compound = analyzer.polarity_scores(tweet_text)["compound"]
      pos = analyzer.polarity_scores(tweet_text)["pos"]
      neu = analyzer.polarity_scores(tweet_text)["neu"]
      neg = analyzer.polarity_scores(tweet_text)["neg"]

      # Add each value to the appropriate array
      tweet_source_list.append(media)
      tweet_text_list.append(tweet_text)
      tweet_date_list.append(tweet["created_at"])
      compound_list.append(compound)
      positive_list.append(pos)
      negative_list.append(neg)
      neutral_list.append(neu)

  # Print the Averages
  df = pd.DataFrame({
      "Source": tweet_source_list,
      "Text": tweet_text_list
  })

  df.to_csv("tweet.csv")

  print("")
  print("User: %s" % media)
  print("Compound: %s" % np.mean(positive_list))
  print("Positive: %s" % np.mean(positive_list))
  print("Neutral: %s" % np.mean(neutral_list))
  print("Negative: %s" % np.mean(negative_list))
