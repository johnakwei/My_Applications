# Twitter Journalism Curation App - Server Code:

library(shiny)
library(UsingR)
library(twitteR)
library(dplyr)
library(stringr)
library(devtools)
require(twitteR)

# Authenticate with Twitter application
library(twitteR)
api_key <- "kHKPGpLcPtp1Gdoi1Hvd7TeyC"
api_secret <- "wK43Hr9w6TpZRPWGZxBc6pF1AFLfFsauJqgajX5RfrPLP2JCpv"
access_token <- "11265142-D1H3VV0ktAzWSKT6dXsI9LpXq46chrFMZSZ2J0DOn"
access_token_secret <- "Zbwtux2UWrQpCljsZuJnw9fROV2O3ghWmm5YFhsuY8LIX"
options(httr_oauth_cache=T)
setup_twitter_oauth(api_key, api_secret, access_token=NULL, access_secret=NULL)
# setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

shinyServer(
  function(input, output) {
    # get and print Twitter user information    
    output$text1 <- renderText({
      user <- getUser(input$Account)
      userInfo <- c(input$Account, user$created, user$statusesCount, user$followersCount)
    })
    output$text2 <- renderText({
      user <- getUser(input$Username)
      userInfo <- c(input$Username, user$created, user$statusesCount, user$followersCount)
    })
    
    # Find and print user's curation tweets
    output$text3 <- renderUI({
      # download user's timeline
      TLDF <- twListToDF(userTimeline(input$Account, n=10))
      
      # search user's timeline for curation links
      JournalismCuration <- str_extract_all(as.character(TLDF), 'http://t.co/[[:alnum:]]+|https://t.co/[[:alnum:]]+')
      
      fluidRow(column(12, align="center"),
      p(actionButton("FirstTweet", label=JournalismCuration[1])),
      p(actionButton("SecondTweet", label=JournalismCuration[2]))
      )
    })
    
    # Find and print user's curation tweets
    output$text4 <- renderUI({
      # download user's timeline
      TLDF <- twListToDF(userTimeline(input$Username, n=1))
      
      # search user's timeline for curation links
      JournalismCuration <- str_extract_all(as.character(TLDF), 'http://t.co/[[:alnum:]]+|https://t.co/[[:alnum:]]+')
      
      # output user's journalism curation tweets
      JournalismButton <- head(JournalismCuration[1:2])
      
      fluidRow(column(12, align="center"),
               actionButton("FirstTweet", label=JournalismButton),
               actionButton("SecondTweet", label=JournalismButton[2]))
    })
})