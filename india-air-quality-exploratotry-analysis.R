<<<<<<< HEAD
library(ggplot2)
library(dplyr)
library(tidyr)
library(highcharter)
library(lubridate)
library(xts)
library(reshape2)
air <-read.csv("/data1.csv")
glimpse(air)
air$date <-as.Date(air$date,'%Y-%m-%d')
summary(air)
table(air$type)
air$type[air$type=="Sensitive Areas"] <-"Sensitive Area"
air$type[air$type %in% c("Industrial","Industrial Areas")] <-"Industrial Area"
air$type[air$type %in% c("Residential")] <-"Residential and others"

by_state_wise <-air%>%group_by(state)%>%summarise(Avg_So2=mean(so2,na.rm=TRUE),Avg_No2=mean(no2,na.rm=TRUE),Avg_Rspm=mean(rspm,na.rm=TRUE),Avg_Spm= mean(spm,na.rm=TRUE))


ggplot(by_state_wise,aes(x=state,y=Avg_No2,fill=Avg_No2)) +
  geom_bar(stat="identity") +
  theme(axis.text.x =element_text(angle=45)) +
  ggtitle("Average Nitrous DiOxide Content-State Wise") +
  xlab(label="State") +
  ylab(label="Average NO2 Content") +
  labs(caption="Source :Ministry of Environment and Forests and Central Pollution Control Board of India")



ggplot(by_state_wise,aes(x=state,y=Avg_Rspm,fill=Avg_Rspm)) +
  geom_bar(stat="identity") +
  theme(axis.text.x =element_text(angle=45)) +
  ggtitle("Average Respirable Suspended Particulate Matter(RSPM) Content-State Wise") +
  xlab(label="State") +
  ylab(label="Average RSPM Content") +
  labs(caption="Source :Ministry of Environment and Forests and Central Pollution Control Board of India")




ggplot(by_state_wise,aes(x=state,y=Avg_Spm,fill=Avg_Spm)) +
  geom_bar(stat="identity") +
  theme(axis.text.x =element_text(angle=45)) +
  ggtitle("Average Suspended Particulate Matter(SPM) Content-State Wise") +
  xlab(label="State") +
  ylab(label="Average SPM Content") +
  labs(caption="Source :Ministry of Environment and Forests and Central Pollution Control Board of India")


colnames(by_state_wise)

##Key takeaways
#1.Delhi ranked highest in RSPM(Respirable Suspended Particulate Matter) and SPM(Suspended Particulate Matter), followed by Uttar Pradesh.
#2.Meghalaya and Mizoram are least polluted w.r.t RSPM and SPM.
#3.Uttarakhand() and Uttaranchal has highest Sulphur Content
#4.WestBengal and Delhi ranks 1st and 2nd in Nitrous Oxide Content



#Lets investigate more on Delhi Trend w.r.t pollution
air$date <-as.POSIXct(air$date)
air$year <-year(air$date)
Delhi <-air%>%filter(state=="Delhi")%>%group_by(year,type)%>%summarise(Avg_So2=mean(so2,na.rm=TRUE),
                                                                  Avg_No2=mean(no2,na.rm=TRUE),
                                                                  Avg_Rspm=mean(rspm,na.rm=TRUE),
                                                                  Avg_Spm =mean(spm,na.rm=TRUE))
ggplot(Delhi,aes(x=year,y=Avg_So2)) +
  geom_line(size=1,color="darkred") +
  geom_point()+
  facet_wrap(~type) +
  ggtitle("Delhi SO2 Content-Year Wise")+
  xlab("Year") +
  ylab("Average SO2")

ggplot(Delhi,aes(x=year,y=Avg_No2)) +
  geom_line(size=1,color="darkred") +
  geom_point()+
  facet_wrap(~type) +
  ggtitle("Delhi NO2 Content-Year Wise")+
  xlab("Year") +
  ylab("Average NO2")

ggplot(Delhi,aes(x=year,y=Avg_Rspm)) +
  geom_line(size=1,color="darkred") +
  geom_point()+
  facet_wrap(~type) +
  ggtitle("Delhi RSPM Content-Year Wise")+
  xlab("Year") +
  ylab("Average RSPM")

ggplot(Delhi,aes(x=year,y=Avg_Spm)) +
  geom_line(size=1,color="darkred") +
  geom_point()+
  facet_wrap(~type) +
  ggtitle("Delhi SPM Content-Year Wise")+
  xlab("Year") +
  ylab("Average SPM")

State_Year_Wise <-air%>%group_by(state,year) %>%summarise(So2=mean(so2,na.rm=TRUE),
                                               No2=mean(no2,na.rm=TRUE),
                                               Rspm=mean(rspm,na.rm=TRUE),
                                               spm=mean(spm,na.rm=TRUE))
State_Year_Wise.long <-melt(State_Year_Wise,id=c("year","state"),measure=c("So2","No2","Rspm","spm"))
State_Year_Wise.long

ggplot(State_Year_Wise.long,aes(x=year,y=value,color=variable)) +
  geom_bar(stat="identity",position="dodge") +
  facet_wrap(~state)


ggplot(State_Year_Wise,aes(x=year,y=So2)) +
  geom_bar(stat="identity",position="dodge") +
  facet_wrap(~state)


State_Year_Wise.long %>%
  filter(variable=="So2") %>%
  ggplot(aes(x=year,y=state,fill=value)) +
  geom_tile(color="white") +
  scale_fill_gradient(low="white",high="steelblue") +
  theme(legend.position = "right") +
  labs(title="Heat Map for Average SO2 Content")

State_Year_Wise.long %>%
  filter(variable=="No2") %>%
  ggplot(aes(x=year,y=state,fill=value)) +
  geom_tile(color="white") +
  scale_fill_gradient(low="white",high="steelblue") +
  theme(legend.position = "right") +
  labs(title="Heat Map for Average Nitrous Oxide Content")


State_Year_Wise.long %>%
  filter(variable=="Rspm") %>%
  ggplot(aes(x=year,y=state,fill=value)) +
  geom_tile(color="white") +
  scale_fill_gradient(low="white",high="steelblue") +
  theme(legend.position = "right") +
  labs(title="Heat Map for Average RSPM Content")

#Delhi leads the Average RSPM(Respirable Suspended Particulate Matter) ,along with UP and Punjab espcially after 2010


State_Year_Wise.long %>%
  filter(variable=="spm") %>%
  ggplot(aes(x=year,y=state,fill=value)) +
  geom_tile(color="white") +
  scale_fill_gradient(low="white",high="steelblue") +
  theme(legend.position = "right") +
  labs(title="Heat Map for Average SPM(Suspended Particulate Matter) Content")
  
  #Analysis to be completed...
 
=======
library(ggplot2)
library(dplyr)
library(tidyr)
library(highcharter)
library(lubridate)
library(xts)
library(reshape2)
air <-read.csv("E:/IDA/data1.csv")
glimpse(air)
air$date <-as.Date(air$date,'%Y-%m-%d')
summary(air)
table(air$type)
air$type[air$type=="Sensitive Areas"] <-"Sensitive Area"
air$type[air$type %in% c("Industrial","Industrial Areas")] <-"Industrial Area"
air$type[air$type %in% c("Residential")] <-"Residential and others"

by_state_wise <-air%>%group_by(state)%>%summarise(Avg_So2=mean(so2,na.rm=TRUE),Avg_No2=mean(no2,na.rm=TRUE),Avg_Rspm=mean(rspm,na.rm=TRUE),Avg_Spm= mean(spm,na.rm=TRUE))


ggplot(by_state_wise,aes(x=state,y=Avg_No2,fill=Avg_No2)) +
  geom_bar(stat="identity") +
  theme(axis.text.x =element_text(angle=45)) +
  ggtitle("Average Nitrous DiOxide Content-State Wise") +
  xlab(label="State") +
  ylab(label="Average NO2 Content") +
  labs(caption="Source :Ministry of Environment and Forests and Central Pollution Control Board of India")



ggplot(by_state_wise,aes(x=state,y=Avg_Rspm,fill=Avg_Rspm)) +
  geom_bar(stat="identity") +
  theme(axis.text.x =element_text(angle=45)) +
  ggtitle("Average Respirable Suspended Particulate Matter(RSPM) Content-State Wise") +
  xlab(label="State") +
  ylab(label="Average RSPM Content") +
  labs(caption="Source :Ministry of Environment and Forests and Central Pollution Control Board of India")




ggplot(by_state_wise,aes(x=state,y=Avg_Spm,fill=Avg_Spm)) +
  geom_bar(stat="identity") +
  theme(axis.text.x =element_text(angle=45)) +
  ggtitle("Average Suspended Particulate Matter(SPM) Content-State Wise") +
  xlab(label="State") +
  ylab(label="Average SPM Content") +
  labs(caption="Source :Ministry of Environment and Forests and Central Pollution Control Board of India")


colnames(by_state_wise)

##Key takeaways
#1.Delhi ranked highest in RSPM(Respirable Suspended Particulate Matter) and SPM(Suspended Particulate Matter), followed by Uttar Pradesh.
#2.Meghalaya and Mizoram are least polluted w.r.t RSPM and SPM.
#3.Uttarakhand() and Uttaranchal has highest Sulphur Content
#4.WestBengal and Delhi ranks 1st and 2nd in Nitrous Oxide Content



#Lets investigate more on Delhi Trend w.r.t pollution
air$date <-as.POSIXct(air$date)
air$year <-year(air$date)
Delhi <-air%>%filter(state=="Delhi")%>%group_by(year,type)%>%summarise(Avg_So2=mean(so2,na.rm=TRUE),
                                                                  Avg_No2=mean(no2,na.rm=TRUE),
                                                                  Avg_Rspm=mean(rspm,na.rm=TRUE),
                                                                  Avg_Spm =mean(spm,na.rm=TRUE))
ggplot(Delhi,aes(x=year,y=Avg_So2)) +
  geom_line(size=1,color="darkred") +
  geom_point()+
  facet_wrap(~type) +
  ggtitle("Delhi SO2 Content-Year Wise")+
  xlab("Year") +
  ylab("Average SO2")

ggplot(Delhi,aes(x=year,y=Avg_No2)) +
  geom_line(size=1,color="darkred") +
  geom_point()+
  facet_wrap(~type) +
  ggtitle("Delhi NO2 Content-Year Wise")+
  xlab("Year") +
  ylab("Average NO2")

ggplot(Delhi,aes(x=year,y=Avg_Rspm)) +
  geom_line(size=1,color="darkred") +
  geom_point()+
  facet_wrap(~type) +
  ggtitle("Delhi RSPM Content-Year Wise")+
  xlab("Year") +
  ylab("Average RSPM")

ggplot(Delhi,aes(x=year,y=Avg_Spm)) +
  geom_line(size=1,color="darkred") +
  geom_point()+
  facet_wrap(~type) +
  ggtitle("Delhi SPM Content-Year Wise")+
  xlab("Year") +
  ylab("Average SPM")

State_Year_Wise <-air%>%group_by(state,year) %>%summarise(So2=mean(so2,na.rm=TRUE),
                                               No2=mean(no2,na.rm=TRUE),
                                               Rspm=mean(rspm,na.rm=TRUE),
                                               spm=mean(spm,na.rm=TRUE))
State_Year_Wise.long <-melt(State_Year_Wise,id=c("year","state"),measure=c("So2","No2","Rspm","spm"))
State_Year_Wise.long

ggplot(State_Year_Wise.long,aes(x=year,y=value,color=variable)) +
  geom_bar(stat="identity",position="dodge") +
  facet_wrap(~state)


ggplot(State_Year_Wise,aes(x=year,y=So2)) +
  geom_bar(stat="identity",position="dodge") +
  facet_wrap(~state)


State_Year_Wise.long %>%
  filter(variable=="So2") %>%
  ggplot(aes(x=year,y=state,fill=value)) +
  geom_tile(color="white") +
  scale_fill_gradient(low="white",high="steelblue") +
  theme(legend.position = "right") +
  labs(title="Heat Map for Average SO2 Content")

State_Year_Wise.long %>%
  filter(variable=="No2") %>%
  ggplot(aes(x=year,y=state,fill=value)) +
  geom_tile(color="white") +
  scale_fill_gradient(low="white",high="steelblue") +
  theme(legend.position = "right") +
  labs(title="Heat Map for Average Nitrous Oxide Content")


State_Year_Wise.long %>%
  filter(variable=="Rspm") %>%
  ggplot(aes(x=year,y=state,fill=value)) +
  geom_tile(color="white") +
  scale_fill_gradient(low="white",high="steelblue") +
  theme(legend.position = "right") +
  labs(title="Heat Map for Average RSPM Content")

#Delhi leads the Average RSPM(Respirable Suspended Particulate Matter) ,along with UP and Punjab espcially after 2010


State_Year_Wise.long %>%
  filter(variable=="spm") %>%
  ggplot(aes(x=year,y=state,fill=value)) +
  geom_tile(color="white") +
  scale_fill_gradient(low="white",high="steelblue") +
  theme(legend.position = "right") +
  labs(title="Heat Map for Average SPM(Suspended Particulate Matter) Content")
  
  #Analysis to be completed...
 
>>>>>>> 2475cc0827fee1e2874bd72c9b2d508b04a79155
