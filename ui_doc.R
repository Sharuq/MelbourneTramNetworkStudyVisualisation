#Description for front page
frontpage = function() div(class = "frontp",
                        div(class = "front-banner",
                            div(class = "imgcon"),
                            div(class = "hcon", h1("A Study On Melbourne Metropolitian Tram Network"))
                            
                            ),
                        div(class="side",tags$figcaption("Image Courtesy: https://2017.festival.melbourne/events/melbourne-art-trams/#.WxQfTkiFOUk")),
                        
                        div(class="new",
                        tags$p(class = "intro", "Trams are considered as one of the major form of public transport in Melbourne. Trams comes the second most used transportation network in terms of ridership after the railway network. Melbourne tram network is the largest urban tramway network in the world."),
                        div(class = "intro-divider"),
                        tags$p(class = "intro1","The aim of the project is to perform narrative  visualisation on service level evaluation study on Melbourne metropolitan tram network. Public Transport Victoria (PTV) Officials can utilize  these visualisation to  make desisons for optimization different tram routes."),
                        tags$p(class = "intro1"," Service level evaluations of trams evaluates the service by examining the design, layout and schedules of the transit. These evaluations are essential to ensure customer demands are met effectively and efficiently. This is achieved by performing some prescriptive and descriptive data analytics on the data based on the frequency of trips and average load on each route.Genearal Transit Feed Specification (GTFS) feeds and Passenger load survey data of May 2017 is used for frequency and load analyisis."),
                        tags$p(class = "intro2"," Click on different navigation bar options for more details on analysis...")
                        
                        
))
#Description for second page
frequencyp = function() div(class = "frontp",
                        tags$p(class="sub","Frequency of trips per route are more during Weekdays, then Saturday and Sunday respectively."),
                        br(),
                        tags$p(class="sub1","It can be observed Route 19 (North Coburg - Flinders Street Station (City)) have the most frequency in all day types and during all time periods.Route 35 (City Circle) have the least frequency in all day types and during all time periods. ")
                        
)
#Description for thrid page
loadp = function() div(class = "frontp",
                        tags$p(class="sub","Average load per route during AM and PM Peak are shown similar trend."),
                        br(),
                        tags$p(class="sub1","During AM Peak, route 59(Airport West - Flinders Street Station (City)) has a maximum average load, whereas on PM Peak route 11 (West Preston - Victoria Harbour Docklands) stands out. Route 30 (St Vincents Plaza - Etihad Stadium Docklands) have the minimum average load on both periods.")
                        
)
#Description for fourth page
sump = function() div(class = "frontp",
                       tags$p(class="sub","Data analysis on the GTFS feeds and passenger load survey data opened a new channel of service level evaluations.."),
                       br(),
                       tags$p(class="sub1","It can be observed that route 11(West Preston - Victoria Harbour Docklands), route 96 (St Kilda Beach - East Brunswick) and route 59 (Airport West - Flinders Street Station (City)) have comparatively more average load and less freqency compared to other routes.")
                       
)
#Description for final page
credits = function() div(class = "frontp",
                        tags$p(class = "intro", "Author: Mohammed Sharuq Kunnappulli"),
                        tags$p(class = "intro", "Assignment: Visualisation Project"),
                        hr(),
                        tags$p(class="intro1","Tools & Libraries Used: RStudio with Shiny, Leaflet, Highcharter, Ploty libraries, and Python for Wrangling"),
                        tags$p(class="intro1","Data Sources: May 2017 GTFS feeds  and  May 2017 Passenger Load Survey report data ")
                        
)
