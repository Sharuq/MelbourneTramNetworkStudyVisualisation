# server.R

#Loading libraries

library(shiny)
library(shinythemes)
library(shinyWidgets)
library(dplyr)
library(ggplot2)
library(plotly)
library(highcharter)
library(leaflet)
library(ggthemes)
library(datasets)

weekdayAM<-read.csv("weekdayAM.csv")
sundayAM<-read.csv("sundayAM.csv")
saturdayAM<-read.csv("saturdayAM.csv")
weekdayPM<-read.csv("weekdayPM.csv")
sundayPM<-read.csv("sundayPM.csv")
saturdayPM<-read.csv("saturdayPM.csv")
AMfinal_survey_data<-read.csv("AMfinal_survey_data.csv")
PMfinal_survey_data<-read.csv("PMfinal_survey_data.csv")
routes_shapes<-read.csv("routes_shapes.csv")

shinyServer(function(input, output) {
  
  #Function to frequency per route with selected criteria
  frequencyPlotting <- function(data){
    
    theme_set(theme_wsj())
    
    k=ggplot(data,aes(x = route_short_name,y = frequency , group=1, text=   paste("Route Long Name: ", route_long_name))) +
      geom_line(color="tomato3")+
      geom_point()+
      xlab("Route short name") + ylab("Frequency")+
      theme(axis.text.x = element_text(angle=90, vjust=0.5,face ="bold",colour = "black"), 
            axis.text.y = element_text(vjust=0.5,face ="bold",colour = "black"), 
            axis.title.x = element_text(face ="bold",colour = "black"),
            axis.title.y = element_text(face ="bold",colour = "black"))
    
    #intractive visualisation for hovering
    gg<-ggplotly(k,tooltip = c("x", "y","text"))
    gg$elementId <- NULL
    gg
    
  }
  
  #Function to average load per route with selected criteria
  loadPlotting <- function(data) {
    
    theme_set(theme_wsj())
    
    p<- ggplot(data) +
      geom_bar(aes(x = route_short_name, y = Average_load,text = paste("Route Long Name: ", route_long_name)), 
               stat="identity", position = "dodge", width = 0.7,fill='tomato3') +
      xlab("Route Short Name") + ylab("Average Load %")+
      theme(axis.text.x = element_text(angle=90, vjust=0.5,face ="bold",colour = "black"), 
            axis.text.y = element_text(vjust=0.5,face ="bold",colour = "black"), 
            axis.title.x = element_text(face ="bold",colour = "black"),
            axis.title.y = element_text(face ="bold",colour = "black"))
    
    #intractive visualisation for hovering
    gg<-ggplotly(p,tooltip = c("x", "y","text"))
    gg$elementId <- NULL
    gg
    
  }
  #Function for Highchart dual axis summarized plotting
  combinedPlotting<-function(data){
    
    thm=hc_theme_ffx()
    
    h = highchart() %>% 
      hc_yAxis_multiples(
        list(lineWidth = 3, lineColor="#ec0030", title=list(text="Frequency")),
        list(lineWidth = 3, lineColor='#400024', title=list(text="Average load %"))
      ) %>% 
      hc_add_series(data = data$frequency, color='#ec0030', type = "line",name='Frequency') %>%
      hc_add_series(data = data$Average_load, color="#400024", type = "line", yAxis = 1,name='Average_load') %>% 
      hc_xAxis(categories = data$route_short_name, title = list(text = "Route short name")) %>% hc_add_theme(thm)
    
    h
  }
  
  #Funtion for plotting frequency of routes with selected criteria on leaflet with color palette
  frequencyLeafletPlotting <- function(data) {
    
    
    
    pal <- colorNumeric(palette = "Reds",domain = data$frequency)
    
    
    m=leaflet(data) %>%
      setView(lat = -37.81862 , lng = 144.95199, zoom=12) %>%
      addProviderTiles(providers$OpenStreetMap.BlackAndWhite, group="Dark")
    for(i in unique(data$route_short_name)){
      m=m%>%
        addPolylines(data=data[data$route_short_name==i,],lat=~shape_pt_lat,lng=~shape_pt_lon, group=~shape_id, color = ~pal(frequency), weight = 3, opacity = 1,
                     popup =  ~paste("Route short name: ", route_short_name, "<br>",
                                     "Route long name: ", route_long_name, "<br>",
                                     "Frequency: ", frequency),
                     label =  ~route_short_name,
                     highlightOptions = highlightOptions(
                       color='#00ff00', weight = 3,
                       opacity = 1, fillOpacity = 1,
                       bringToFront = TRUE, sendToBack = TRUE))
      
    }
    m=m%>%addLegend(
      "topright",pal = pal, values = ~frequency, opacity = 1)
    m
    
  }
  #Funtion for plotting average load of routes with selected criteria on leaflet with color palette
   loadLeafletPlotting <- function(data) {
   
        pal <- colorNumeric(
        palette = "Oranges",
        domain = data$Average_load
      )
      
      m=leaflet(data) %>%
        setView(lat = -37.81862 , lng = 144.95199, zoom=12) %>%
        addProviderTiles(providers$OpenStreetMap.BlackAndWhite, group="Dark")
      for(i in unique(data$route_short_name)){
      m = m%>%
          addPolylines(data=data[data$route_short_name==i,],lat=~shape_pt_lat,lng=~shape_pt_lon, group=~shape_id,color = ~pal(Average_load), weight = 3, opacity = 1,
                       popup =  ~paste("Route short name: ", route_short_name, "<br>",
                                       "Route long name: ", route_long_name, "<br>",
                                       "Average Load: ", Average_load),
                       label =  ~route_short_name,
                       highlightOptions = highlightOptions(
                         color='#00ff00', weight = 3,
                         opacity = 1, fillOpacity = 1,
                         bringToFront = TRUE, sendToBack = TRUE))
        
      }
      m = m%>%addLegend(
        "topright",pal = pal, values = ~Average_load, opacity = 1)
      m
      
    }

  #To print captions accordingly to the input
   
output$caption <- renderText({
  if(input$TimeP == "AM PEAK"){
    return(paste("Chart view of average load per route during ", "<span style=\"color: #2E86AB;font-weight: bold;\">" ,input$TimeP ,"</span>", "period "))
    
  }else{
    return(paste("Chart view of average load per route during ", "<span style=\"color: #C3423F;font-weight: bold;\">" ,input$TimeP ,"</span>", "period "))
  }
  })
output$lmcaption <- renderText({
  if(input$TimeP == "AM PEAK"){
    return(paste("Map view of average load per route during ", "<span style=\"color: #2E86AB;font-weight: bold;\">" ,input$TimeP ,"</span>", "period "))
    
  }else{
    return(paste("Map view of average load per route during ", "<span style=\"color: #C3423F;font-weight: bold;\">" ,input$TimeP ,"</span>", "period "))
  }
})
output$fcaption <- renderText({
  if(input$TimePeriod == "AM PEAK"){
    return(paste("Chart view of frequency per route during ", "<span style=\"color: #2E86AB;font-weight: bold;\">" ,input$TimePeriod ,"</span>", "period ","<span style=\"color: #2E86AB;font-weight: bold;\">" ,input$DayType ,"</span>"))
    
  }else{
    return(paste("Chart view of frequency per route during ", "<span style=\"color: #C3423F;font-weight: bold;\">" ,input$TimePeriod ,"</span>", "period ","<span style=\"color: #2E86AB;font-weight: bold;\">" ,input$DayType ,"</span>"))
  }
  })

output$fmcaption <- renderText({
  if(input$TimePeriod == "AM PEAK"){
    return(paste("Map view of frequency per route during ", "<span style=\"color: #2E86AB;font-weight: bold;\">" ,input$TimePeriod ,"</span>", "period ","<span style=\"color: #2E86AB;font-weight: bold;\">" ,input$DayType ,"</span>"))
    
  }else{
    return(paste("Map view of frequency per route during ", "<span style=\"color: #C3423F;font-weight: bold;\">" ,input$TimePeriod ,"</span>", "period ","<span style=\"color: #2E86AB;font-weight: bold;\">" ,input$DayType ,"</span>"))
  }
})
output$scaption <- renderText({
  if(input$TimePer == "AM PEAK"){
    return(paste("Combined dual axis view of routes during ", "<span style=\"color: #2E86AB;font-weight: bold;\">" ,input$TimePer ,"</span>", "period "))
    
  }else{
    return(paste("Combined dual axis view of routes during ", "<span style=\"color: #C3423F;font-weight: bold;\">" ,input$TimePer ,"</span>", "period "))
  }
  })  

#To plot average load on selected criteria
output$loadPlot <- renderPlotly({ 
    
  if (input$TimeP == "AM PEAK") 
    {loadPlotting(AMfinal_survey_data)}
  else 
  {loadPlotting(PMfinal_survey_data)}
  
})

#To plot frequency per route on selected criteria
output$frequenyPlot <- renderPlotly({ 
  
  if (input$TimePeriod == "PM PEAK") 
    
   { 
    if(input$DayType=="Weekday")
    {
      frequencyPlotting(weekdayPM)
    }
    else if(input$DayType=="Sunday")
    {
      frequencyPlotting(sundayPM)
    }
    else if(input$DayType=="Saturday")
    {
      frequencyPlotting(saturdayPM)
    }
    
  }
  
  else
    
  {
    if(input$DayType=="Weekday")
    {
      
      frequencyPlotting(weekdayAM)
    }
    else if(input$DayType=="Sunday")
    {
      
      frequencyPlotting(sundayAM)
    }
    else if(input$DayType=="Saturday")
    {
    
      frequencyPlotting(saturdayAM)
    } 
    
  }
  
})

#To plot frequency as color palette on leaflet
output$freqencyMap <- renderLeaflet({
  
  if (input$TimePeriod == "AM PEAK") {
   
       if(input$DayType=="Weekday")
        {
         frequency_paths <- routes_shapes %>% left_join(weekdayAM, by = c("route_short_name" = "route_short_name", "route_long_name" = "route_long_name"))
         
        }
        else if(input$DayType=="Sunday")
        {
          frequency_paths <- routes_shapes %>% left_join(sundayAM, by = c("route_short_name" = "route_short_name", "route_long_name" = "route_long_name"))
          
        }
        else
        {
          frequency_paths <- routes_shapes %>% left_join(saturdayAM, by = c("route_short_name" = "route_short_name", "route_long_name" = "route_long_name"))
          
        }
    
    
    frequencyLeafletPlotting(frequency_paths)
  }
  
  else {
        if(input$DayType=="Weekday")
        {
        frequency_paths <- routes_shapes %>% left_join(weekdayPM, by = c("route_short_name" = "route_short_name", "route_long_name" = "route_long_name"))
        
        }
        else if(input$DayType=="Sunday")
        {
          frequency_paths <- routes_shapes %>% left_join(sundayPM, by = c("route_short_name" = "route_short_name", "route_long_name" = "route_long_name"))
          
        }
        else
        {
          frequency_paths <- routes_shapes %>% left_join(saturdayPM, by = c("route_short_name" = "route_short_name", "route_long_name" = "route_long_name"))
          
        }
    
    
    frequencyLeafletPlotting(frequency_paths)
  }
})

#To plot average as color palette in leaflet
output$loadMap <- renderLeaflet({
  if (input$TimeP == "AM PEAK") {
    AMload_paths<- routes_shapes %>% left_join(AMfinal_survey_data, by =c("route_short_name" = "route_short_name", "route_long_name" = "route_long_name"))
    loadLeafletPlotting(AMload_paths)
  }
  else {
    PMload_paths<- routes_shapes %>% left_join(PMfinal_survey_data, by = c("route_short_name" = "route_short_name", "route_long_name" = "route_long_name"))
    loadLeafletPlotting(PMload_paths)
  }
})
  
#To plot summarised view on both averageload and frequency
output$finalPlot <-renderHighchart({
  
  if (input$TimePer == "AM PEAK")
  {
    AMcombined<-weekdayAM %>% inner_join(AMfinal_survey_data, by = "route_short_name")
    combinedPlotting(AMcombined)
    
  }
  else
  {
    PMcombined<-weekdayAM %>% inner_join(PMfinal_survey_data, by = "route_short_name")
    combinedPlotting(PMcombined)
  }
})
})