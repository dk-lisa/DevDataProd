# install.packages("shiny")
library(shiny)

shinyUI(fluidPage(
  titlePanel("Explore and Forecast the Harmonised unemployment rates (%) Males vs Females"),
  strong(p("Using http://datamarket.com datasets,", 
           a("see here.", 
             href="https://datamarket.com/en/data/set/19rf/#!ds=19rf!prs=2:prt=4.3.1:pru=f&display=line&s=6ri&e=bsf&title=Harmonised+unemployment+rates+(%25)+-+monthly+data"
           ))),
  strong(p("The code can be checked on github,", 
           a("see here.", 
             href="https://github.com/dk-lisa/devdataprod"
           ))),
  sidebarLayout(
    sidebarPanel(
      strong("In this form, you can choose the country (or group) for which the time series will be used and compared."),
      h4("Choose the Geopolitical entity and the prediction period (in months)"),
      htmlOutput("selectEntity"),
      sliderInput("period", min = 1, max=12, label="Predicted Months", value=1),
      hr(),
      h4("Please change the following parameters to adjust the Males time series"),
      sliderInput("malesDiff", min = 0, max=20, label="Males Diff (stationary)", value=0),
      sliderInput("malesP", min = 0, max=20, label="Males P", value=0),
      sliderInput("malesQ", min = 0, max=20, label="Males Q", value=0),
      hr(),
      h4("Please change the following parameters to adjust the Females time series"),
      sliderInput("femalesDiff", min = 0, max=20, label="Females Diff (stationary)", value=0),
      sliderInput("femalesP", min = 0, max=20, label="Females P", value=0),
      sliderInput("femalesQ", min = 0, max=20, label="Females Q", value=0)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3("First, let's glance at the time series about Males and Females' unemployment"),
      fluidRow(
        column(width = 6, h2("Males")),
        column(width = 6, h2("Females"))
      ),
      hr(),
      fluidRow(
        column(width = 6, plotOutput("males")),
        column(width = 6, plotOutput("females"))
      ),
      hr(),
      h3("Holt-Winters exponential smoothing to make short-term forecasts"),
      fluidRow(
        column(width = 6, plotOutput("males.fut")),
        column(width = 6, plotOutput("females.fut"))
      ),
      hr(),
      h3("Differenciated time series (tune until stationary is reached)"),
      fluidRow(
        column(width = 6, plotOutput("males.diff")),
        column(width = 6, plotOutput("females.diff"))
      ),
      hr(),
      h3("Autoregressive Integrated Moving Average (ARIMA)"),
      h4("Here is the result using R's auto-arima"),
      fluidRow(
        column(width = 6, plotOutput("males.auto.arima")),
        column(width = 6, plotOutput("females.auto.arima"))
      ),
      h4("Here are the ACF and partial ACF to help you tuning P and Q"),
      fluidRow(
        column(width = 6, plotOutput("males.ACF")),
        column(width = 6, plotOutput("females.ACF"))
      ),
      fluidRow(
        column(width = 6, plotOutput("males.PACF")),
        column(width = 6, plotOutput("females.PACF"))
      ),
      h4("Here is the plot of the prediction using the parameters"),
      fluidRow(
        column(width = 6, plotOutput("males.ArimaPred")),
        column(width = 6, plotOutput("females.ArimaPred"))
      )
    )
  )
))