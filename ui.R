# Twitter Journalism Curation App - User Interface Code:

library(shiny)
library(twitteR)

dt <- read.csv("journalList.csv")

shinyUI(pageWithSidebar(
  headerPanel(h1("Twitter Journalism Curation App - ContextBase", style="color:lightgreen")),
  sidebarPanel(
    tags$head(tags$link(rel="stylesheet", type="text/css", href="bootstrap.css")),
    tags$style(type="text/css", ".shiny-output-error {visibility: hidden;}",
               ".shiny-output-error:before {visibility: hidden;}"),
    p("This application outputs all the journalism curation tweets from
  the Twitter user account inputted:"),
    # select twitter journalism account
    selectInput("Account", label=h5("Select Twitter Account"), 
                choices=as.matrix(dt)),
    textInput("Username", "Twitter User Name to Search:", ""),
    submitButton("Find Journalism Tweets")
    ),
  mainPanel(
      h2('User Information', style="color:lightgreen"),
      textOutput('text1'),
      textOutput('text2'),
      h2('List of Journalism Curation Tweets', style="color:lightgreen"),
      uiOutput("text3"),
      uiOutput("text4"),
      helpText(HTML("User Interface Source Code: <a href=\"https://github.com/johnakwei/Coursera/blob/Coursera/Developing_Data_Products/ui.R\" target=\"_blank\">ui.R</a>"))
    )
  ))