# install.packages("shiny")
# install.packages("forecast")
library(shiny)
library(forecast)

shinyServer(function(input, output)  {
  # subset for the requested geopolitical entity
  dm.19rf.be <- reactive(subset(dm.19rf, Entities == input$entity))
  
  dm.19rf.be.raw <- reactive(subset(dm.19rf.be(), Seasonal.adjustment == "Not seasonally adjusted data"))
  dm.19rf.be.adj <- reactive(subset(dm.19rf.be(), Seasonal.adjustment != "Not seasonally adjusted data"))
  
  # Males: subset the data and convert to ts
  dm.19rf.be.raw.ts.males <- reactive(ts(subset(dm.19rf.be.raw(), Indicator=="Males", select=Value), frequency=12, start = c(1983,1)))
  dm.19rf.be.adj.ts.males <- reactive(ts(subset(dm.19rf.be.adj(), Indicator=="Males", select=Value), frequency=12, start = c(1983,1)))
  
  # Females: subset the data and convert to ts
  dm.19rf.be.raw.ts.females <- reactive(ts(subset(dm.19rf.be.raw(), Indicator=="Females", select=Value), frequency=12, start = c(1983,1)))
  dm.19rf.be.adj.ts.females <- reactive(ts(subset(dm.19rf.be.adj(), Indicator=="Females", select=Value), frequency=12, start = c(1983,1)))

  # Geopolitical entity
  output$selectEntity <- renderUI({ 
    selectInput("entity", "Select the entity", levels(entities))
  })
  
  # MALES  
  # decompose the ts and plot it
  output$males       <- renderPlot(plot(decompose(dm.19rf.be.raw.ts.males())))
  # basic prediction using HoltWinters
  output$males.fut   <- renderPlot({
    per <- input$period
    males.forecast     <- HoltWinters(dm.19rf.be.raw.ts.males())
    males.forecast.fut <- forecast.HoltWinters(males.forecast, h=per)
    plot.forecast(males.forecast.fut)
  })  
  # prediction using auto.arima
  output$males.auto.arima <- renderPlot({
    per <- input$period
    plot(forecast(auto.arima(dm.19rf.be.raw.ts.males()), h=per))
  })
  # run the number of diff requested on the ts
  dm.19rf.be.raw.ts.males.diff <- reactive({
    malesDiff <- input$malesDiff
    if (malesDiff == 0)
      dm.19rf.be.raw.ts.males()
    else
      diff(dm.19rf.be.raw.ts.males(), differences=malesDiff)
  })
  # plot the diff ts
  output$males.diff   <- renderPlot({
    plot.ts(dm.19rf.be.raw.ts.males.diff())
  })
  # compute and plot ACF
  output$males.ACF <- renderPlot({
    a <- acf(dm.19rf.be.raw.ts.males.diff(), lag.max=20, plot=F)
    a$lag <- a$lag * 12 #convert to months lags
    plot(a)
  })
  # compute and plot partial ACF
  output$males.PACF <- renderPlot({
    a <- pacf(dm.19rf.be.raw.ts.males.diff(), lag.max=20, plot=F)
    a$lag <- a$lag * 12 #convert to months lags
    plot(a)
  })
  # run arima and plot the prediction
  output$males.ArimaPred <- renderPlot({
    per <- input$period
    p <- input$malesP
    d <- input$malesDiff
    q <- input$malesQ
    males.arima <- arima(dm.19rf.be.raw.ts.males(), order=c(p,d,q))
    plot.forecast(forecast.Arima(males.arima, h=per))
  })
  
  # FEMALES
  # the steps are equivalent to the Males' ones
  output$females <- renderPlot(plot(decompose(dm.19rf.be.raw.ts.females())))
  output$females.fut   <- renderPlot({
    per <- input$period
    females.forecast     <- HoltWinters(dm.19rf.be.raw.ts.females())
    females.forecast.fut <- forecast.HoltWinters(females.forecast, h=per)
    plot.forecast(females.forecast.fut)
  })
  output$females.auto.arima <- renderPlot({
    per <- input$period
    plot(forecast(auto.arima(dm.19rf.be.raw.ts.females()), h=per))
  })
  dm.19rf.be.raw.ts.females.diff <- reactive({
    femalesDiff <- input$femalesDiff
    if (femalesDiff == 0)
      dm.19rf.be.raw.ts.females()
    else
      diff(dm.19rf.be.raw.ts.females(), differences=femalesDiff)
  })
  output$females.diff   <- renderPlot({
    plot.ts(dm.19rf.be.raw.ts.females.diff())
  })  
  output$females.ACF <- renderPlot({
    a <- acf(dm.19rf.be.raw.ts.females.diff(), lag.max=20, plot=F)
    a$lag <- a$lag * 12 #convert to months lags
    plot(a)
  })
  output$females.PACF <- renderPlot({
    a <- pacf(dm.19rf.be.raw.ts.females.diff(), lag.max=20, plot=F)
    a$lag <- a$lag * 12 #convert to months lags
    plot(a)
  })
  output$females.ArimaPred <- renderPlot({
    per <- input$period
    p <- input$femalesP
    d <- input$femalesDiff
    q <- input$femalesQ
    females.arima <- arima(dm.19rf.be.raw.ts.females(), order=c(p,d,q))
    plot.forecast(forecast.Arima(females.arima, h=per))
  })
})