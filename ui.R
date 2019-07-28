# ui.R
#Loading libraries
### If any error loading orinstalling packages,uncomment and  run install package comment in top of GTFS_Feeds_Manipulation.R script
if (!require(shiny)) install.packages('shiny')
library(shiny)
if (!require(shinythemes)) install.packages('shinythemes')
library(shinythemes)
if (!require(shinyWidgets)) install.packages('shinyWidgets')
library(shinyWidgets)
if (!require(dplyr)) install.packages('dplyr')
library(dplyr)
if (!require(ggplot2)) install.packages('ggplot2')
library(ggplot2)
if (!require(plotly)) install.packages('plotly')
library(plotly)
if (!require(highcharter)) install.packages('highcharter')
library(highcharter)
if (!require(leaflet)) install.packages('leaflet')
library(leaflet)
if (!require(ggthemes)) install.packages('ggthemes')
library(ggthemes)
if (!require(datasets)) install.packages('datasets')
library(datasets)


#Adding description doc
source("ui_doc.R")


shinyUI(fluidPage(theme = "style.css",
                   
  
  navbarPage("",theme = shinythemes::shinytheme("flatly"),position = "static-top",
             
    #main page         
    tabPanel("Overview",
                    mainPanel(
                      frontpage(),width = 12
                    )),
    #second tab of navigation bar
           tabPanel("Frequency Analysis",
                    titlePanel("A Study On Melbourne Metropolitian Tram Network"),
                    div(class = "intro-divider1"),
                     sidebarLayout(
                      sidebarPanel(
                        style = "position:fixed;width:inherit;",
                        width = 3,
                        prettyRadioButtons(inputId = "TimePeriod", label = "Time Period:",
                                     choices = c("AM PEAK", "PM PEAK"),
                                     inline = TRUE,shape = 'curve',outline = TRUE, thick=TRUE,
                                     animation = "pulse", status = "info"),
                        hr(),
                        pickerInput(inputId = 'DayType', label = 'Day Type', choices = c("Weekday", "Saturday","Sunday")),
                        hr(),
                        helpText("Note: Hover through the lines for brief route description"),
                        hr(),
                        helpText("Note: Hover through the routes on map, click the  highlighted route for brief description.")
                        
                        ),
                      mainPanel(
                        frequencyp(),
                        div(class="siding",br(),
                        h4(htmlOutput("fcaption")),
                        hr(),
                        plotlyOutput("frequenyPlot"),
                        hr(),
                        h4(htmlOutput("fmcaption")),
                        hr(),
                        leafletOutput("freqencyMap"),
                        br(),
                        hr())
                      )
                    )
           ),
    #Thrid tab of navigation bar
              tabPanel("Average Load Analysis",
                       titlePanel("A Study On Melbourne Metropolitian Tram Network"),
                       div(class = "intro-divider1"),
                       sidebarLayout(
                         sidebarPanel(
                           width = 3,
                           br(),
                           style = "position:fixed;width:inherit;",
                           prettyRadioButtons(inputId = "TimeP", label = "Time Period:",
                                              choices = c("AM PEAK"="AM PEAK", "PM PEAK"="PM PEAK"),
                                              shape = 'curve',
                                              animation = "pulse"),
                           hr(),              
                           helpText("Note: Hover through the bars for brief description."),
                           hr(),
                           helpText("Note: Hover through the routes on map, click the  highlighted route for brief description.")
                           
                         ),
                         mainPanel(
                           loadp(),
                           div(class="siding",br(),
                           h4(htmlOutput("caption")),
                           hr(),
                           plotlyOutput("loadPlot"),
                           hr(),
                           h4(htmlOutput("lmcaption")),
                           hr(),
                           leafletOutput("loadMap"),
                           br(),
                           hr())
                           
                           
                         )
                       )
              ),
    #fourth tab of navigaton bar
            tabPanel("Summary",
                     titlePanel("A Study On Melbourne Metropolitian Tram Network"),
                     div(class = "intro-divider1"),
                     sidebarLayout(
                       sidebarPanel(
                         width = 2,
                         br(),
                         style = "position:fixed;width:inherit;",
                         prettyRadioButtons(inputId = "TimePer", label = "Time Period:",
                                            choices = c("AM PEAK" = "AM PEAK", "PM PEAK" = "PM PEAK"),
                                            shape = 'curve',
                                            animation = "pulse",status = "warning"),
                         
                       hr(),
                       helpText("Note: Hover through the lines for brief description.")
                     ),
                       mainPanel(
                         
                         sump(),
                         div(class="siding",
                         h4(htmlOutput("scaption")),
                         hr(),
                         highchartOutput("finalPlot"))
                       )
                     )
                     
            ),
    #final tab of navigation bar
            tabPanel("Credits",
                     titlePanel("A Study On Melbourne Metropolitian Tram Network"),
                     div(class = "intro-divider1"),
                     mainPanel(
                       credits()
                     )
            )
           
    )
))