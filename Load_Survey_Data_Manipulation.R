#For passenger survey data manipulation
#Loading packages
if (!require(dplyr)) install.packages('dplyr')
library(dplyr)

#Reading wrangled survey load data
survey_data<-read.csv("wrangled_load_survey_data.csv")

#Adding colum period based on the rolling hour
survey_data<-transform(survey_data,Period = ifelse(survey_data$Rolling.Hour=="16:01-17:00" 
                                     | survey_data$Rolling.Hour=='16:31-17:30'
                                     | survey_data$Rolling.Hour=='17:01-18:00' 
                                     | survey_data$Rolling.Hour=='17:31-18:30'
                                     | survey_data$Rolling.Hour=='18:01-19:00',"PM PEAK", "AM PEAK"))

#finding an aggeregated survey results based periods and routes
final_survey_data=aggregate(list(Average_load=survey_data$Average.Load.2017,Average_maximum_capacity=survey_data$Average.Maximum.Capacity.2017), by=list(survey_data$Route_short_name,survey_data$Period),FUN=mean)         

#chainging column names
colnames(final_survey_data)[1]<-"route_short_name"
colnames(final_survey_data)[2]<-"Period"
final_survey_data$route_short_name<-as.character(final_survey_data$route_short_name)

#Extracting AM and PM peak data with route descriptions
AMfinal_survey_data<-filter(final_survey_data,final_survey_data$Period=="AM PEAK")
AMfinal_survey_data<-AMfinal_survey_data%>% inner_join(routes_tram,by ="route_short_name")
PMfinal_survey_data<-filter(final_survey_data,final_survey_data$Period=="PM PEAK")
PMfinal_survey_data<-PMfinal_survey_data%>% inner_join(routes_tram,by ="route_short_name")

