#For GTFS feeds manipulation
####If any error occurs due to version dependencies,please reinstall the specfic library by uncomment and running specific line####
#install.packages('shiny')
#install.packages('shinythemes')
#install.packages('shinyWidgets')
#install.packages('dplyr')
#install.packages('ggplot2')
#install.packages('plotly')
#install.packages('highcharter')
#install.packages('leaflet')
#install.packages('leaflet.extras')
#install.packages('ggthemes')
#install.packages('ggfortify')
#install.packages('datasets')
#install.packages('markdown')


#Loading libraries
if (!require(dplyr)) install.packages('dplyr')
library(dplyr)

#reading data from GTFS feeds
agency = read.csv("agency.txt",stringsAsFactors = FALSE)
shapes = read.csv("shapes.txt",stringsAsFactors = FALSE)
routes = read.csv("routes.txt",stringsAsFactors = FALSE)
stops = read.csv("stops.txt",stringsAsFactors = FALSE)
trips = read.csv("trips.txt",stringsAsFactors = FALSE)
stoptimes = read.csv("stop_times.txt",stringsAsFactors = FALSE)
calendar = read.csv("calendar.txt",stringsAsFactors = FALSE)

#renaming few column names
colnames(agency)
colnames(shapes)
colnames(shapes)[1]<-"shape_id"
colnames(trips)
colnames(stops)
colnames(stops)[1]<-"stop_id"
colnames(routes)
colnames(stoptimes)
colnames(stoptimes)[1]<-"trip_id"
colnames(calendar)

#Joining each feed files using inner join
joined_set <- stoptimes %>% 
  inner_join(stops, by = "stop_id") %>%
  inner_join(trips, by = "trip_id") %>%
  inner_join(routes, by = "route_id") %>%
  inner_join(agency, by = "agency_id")


#Filtering the joined set for trams(agency id: 3)
joined_set<-filter(joined_set,joined_set$agency_id=="3")

#manipulation for arrival time
hour_part <- function(x) as.numeric(sub(":.*", "", x)) 
#Adding column Period(AM PEAK/PM PEAK)
final_set<-transform(joined_set,period=ifelse(hour_part(joined_set$arrival_time)>=7 & hour_part(joined_set$arrival_time)<= 10,"AM PEAK",ifelse(hour_part(joined_set$arrival_time)>=16 & hour_part(joined_set$arrival_time)<= 19,"PM PEAK","Other Periods")))
#getting routes details of trams from whole routes file
routes_tram <- routes %>% filter(grepl("^3",route_id))

#filtering calendar file for tram service days and assign day type             
calendar_set<- calendar %>% filter(grepl("^3",service_id))
sat_service_id<- calendar_set[calendar_set$saturday=="1","service_id"]
sun_service_id<- calendar_set[calendar_set$sunday=="1","service_id"]

#subsetting final set based on service day and stop sequence as 1 for starting stop
weekday=subset(final_set,final_set$service_id=="3_T0+a5" & final_set$stop_sequence=="1")
saturday=subset(final_set,final_set$service_id==sat_service_id & final_set$stop_sequence=="1")
sunday=subset(final_set,final_set$service_id==sun_service_id & final_set$stop_sequence=="1")



#subsetting service day datasets to period based frequency by grouping and summarised count finding
weekdayAM = subset(weekday,weekday$period=="AM PEAK") %>% group_by(route_short_name,route_long_name) %>% summarize(count=n())
weekdayPM = subset(weekday,weekday$period=="PM PEAK") %>% group_by(route_short_name,route_long_name) %>% summarize(count=n())
saturdayAM = subset(saturday,saturday$period=="AM PEAK") %>% group_by(route_short_name,route_long_name) %>% summarize(count=n())
saturdayPM = subset(saturday,saturday$period=="PM PEAK") %>% group_by(route_short_name,route_long_name) %>% summarize(count=n())
sundayAM = subset(sunday,sunday$period=="AM PEAK") %>% group_by(route_short_name,route_long_name) %>% summarize(count=n())
sundayPM = subset(sunday,sunday$period=="PM PEAK") %>% group_by(route_short_name,route_long_name) %>% summarize(count=n())

#changing column names
colnames(weekdayAM)[3]<-"frequency"
colnames(weekdayPM)[3]<-"frequency"
colnames(saturdayAM)[3]<-"frequency"
colnames(saturdayPM)[3]<-"frequency"
colnames(sundayAM)[3]<-"frequency"
colnames(sundayPM)[3]<-"frequency"


#filtering trams shape detials
shapes_tram <-shapes %>% filter(grepl("^3",shape_id))

#finding unique shape details in the final joined set
unique_shapes=distinct(final_set, final_set$shape_id, final_set$route_short_name,final_set$route_long_name)

colnames(unique_shapes)[1]<-"shape_id"
colnames(unique_shapes)[2]<-"route_short_name"
colnames(unique_shapes)[3]<-"route_long_name"


#tram shape details grouped and summarised for count of location points,shape_id highest count found from below code used to assign for subetting
#grouped_shapeId = shapes_tram %>% group_by(shape_id) %>% summarize(count=n())
#subseting tram shapes details by utilizing summarised count found
shapes_tram <- subset(shapes_tram , shape_id=="3-1-mjp-1.1.H" | shape_id=="3-109-mjp-1.2.H"
                       | shape_id=="3-11-mjp-1.1.H" | shape_id=="3-12-mjp-1.2.H"
                       | shape_id=="3-16-mjp-1.2.H" | shape_id=="3-19-mjp-1.3.R"
                       | shape_id=="3-3-mjp-1.8.R" | shape_id=="3-30-mjp-1.3.R"
                       | shape_id=="3-35-mjp-1.2.R" | shape_id=="3-48-mjp-1.2.R"
                       | shape_id=="3-5-mjp-1.1.H" | shape_id=="3-57-mjp-1.1.H"
                       | shape_id=="3-58-mjp-1.6.R" | shape_id=="3-59-mjp-1.5.R"
                       | shape_id=="3-6-mjp-1.5.R" | shape_id=="3-64-mjp-1.3.R"
                       | shape_id=="3-67-mjp-1.2.H" | shape_id=="3-70-mjp-1.2.H"
                       | shape_id=="3-72-mjp-1.2.H" | shape_id=="3-75-mjp-1.2.H"
                       | shape_id=="3-78-mjp-1.1.H" | shape_id=="3-82-mjp-1.2.R"
                       | shape_id=="3-86-mjp-1.3.R" | shape_id=="3-96-mjp-1.5.R" )


#final combined routes and shapes details for ploting particular routes 
routes_shapes <- unique_shapes %>% inner_join(shapes_tram, by = "shape_id")  



