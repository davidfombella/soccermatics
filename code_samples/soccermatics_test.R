# if (!require("devtools")) install.packages("devtools")

# library(dplyr)
# devtools::install_github("jogall/soccermatics")

library(dplyr)
library(soccermatics)
#library(magrittr)


# 1. Shotmap 2 teams

statsbomb %>%
  soccerShotmap(theme = "dark")
  

# 2. Shotmap of one team/player

statsbomb %>%
  filter(player.name == "Antoine Griezmann") %>%
  soccerShotmap(theme = "grey",
                title = "Antoine Griezmann", 
				 subtitle = "vs Argentina, World Cup 2018")

# 3. Average player position using TRACAB-style x,y-location data:		

tromso_extra %>% 
  soccerPositionMap(label = "number", 
  labelCol="white",nodeSize=8, arrow="r",theme="grass",
  title = "Tromsø IL (vs. Strømsgodset, 3rd Nov 2013)", 
  subtitle = "Average player position (1' - 16')")		

  

 # 4. Passmap
 statsbomb %>%
  filter(team.name == "Argentina") %>%
  soccerPassmap(fill="lightblue", arrow="r",theme = "light", title = "Argentina (vs France, 3'th June 2018)")
 
 
 
 # fin novedades
 

# france argentina worldcup

# Shotmaps (showing xG)

statsbomb %>%
  filter(team.name == "France") %>%
  soccerShotmap(theme = "dark")

  

#Argentina

statsbomb %>%
  filter(team.name == "Argentina") %>%
  soccerShotmap(theme = "grass", colGoal = "yellow", colMiss = "blue", legend = T)
  
  
 
 # Heatmaps
 
# Passing heatmap with approx 10x10m bins:

statsbomb %>%
  filter(type.name == "Pass" & team.name == "France") %>% 
  soccerHeatmap(x = "location.x", y = "location.y",title = "France (vs Argentina, 30th June 2016)", subtitle = "Passing heatmap")
  
  
  


# Defensive pressure heatmap with approx 5x5m bins:

statsbomb %>%
  filter(type.name == "Pressure" & team.name == "France") %>% 
  soccerHeatmap(x = "location.x", y = "location.y", xBins = 21, yBins = 14,
                title = "France (vs Argentina, 30th June 2016)", 
                subtitle = "Defensive pressure heatmap")

				
				
				
				
				
# Player position heatmaps also possible using TRACAB-style x,y-location data.
# Average position

# Average pass position:


statsbomb %>% 
  filter(type.name == "Pass" & team.name == "France" & minute < 43) %>% 
  soccerPositionMap(id = "player.name", x = "location.x", y = "location.y", 
                    fill1 = "blue", 
                    arrow = "r", 
                    title = "France (vs Argentina, 30th June 2016)", 
                    subtitle = "Average pass position (1' - 42')")



# lengthPitch <-105
# widthPitch <-68	
lengthPitch <-120
widthPitch <-80
				
#Average pass position (both teams):
statsbomb %>% 
  filter(type.name == "Pass" & minute < 43) %>% 
  mutate(location.x = if_else(team.name == "Argentina", lengthPitch - location.x, location.x),
         location.y = if_else(team.name == "Argentina", widthPitch - location.y, location.y)) %>% 
  soccerPositionMap(id = "player.name", team = "team.name", x = "location.x", y = "location.y", 
                    fill1 = "blue", fill2 = "white", col1 = "black", col2 = "black",
                    title = "France vs. Argentina (30th June 2016)", 
                    subtitle = "Average pass position (1' - 42')")		



# PLAYER POSITION
# Average player position using TRACAB-style x,y-location data:

# Error col team

tromso_extra[1:11,] %>% 
  soccerPositionMap(title = "Tromsø IL (vs. Strømsgodset, 3rd Nov 2013)", subtitle = "Average player position (1' - 16')")




#Custom plots

#Inbuilt functions for many of these will be added soon.

#Locations of multiple events:

d2 <- statsbomb %>% 
  filter(type.name %in% c("Pressure", "Interception", "Block", "Dispossessed", "Ball Recovery") & team.name == "France")

soccerPitch(arrow = "r", 
            title = "France (vs Argentina, 30th June 2016)", 
            subtitle = "Defensive actions") +
  geom_point(data = d2, aes(x = location.x, y = location.y, col = type.name), size = 3, alpha = 0.5)

  
# Start and end locations of passes:

d3 <- statsbomb %>% 
  filter(type.name == "Pass" & team.name == "France") %>% 
  mutate(pass.outcome = as.factor(if_else(is.na(pass.outcome.name), 1, 0)))

soccerPitch(arrow = "r",
            title = "France (vs Argentina, 30th June 2016)", 
            subtitle = "Pass map") +
  geom_segment(data = d3, aes(x = location.x, xend = pass.end_location.x, y = location.y, yend = pass.end_location.y, col = pass.outcome), alpha = 0.75) +
  geom_point(data = d3, aes(x = location.x, y = location.y, col = pass.outcome), alpha = 0.5) +
  guides(colour = FALSE)


 #Player paths

#Path of a single player:
  
  
subset(tromso, id == 8)[1:1800,] %>%
  soccerPath(col = "red",  arrow = "r",
             title = "Tromsø IL (vs. Strømsgodset, 3rd Nov 2013)",
             subtitle = "Player #8 path (1' - 3')")
			 
			 
			 
			 
			 
#multiple
tromso %>%
  dplyr::group_by(id) %>%
  dplyr::slice(1:1200) %>%
  soccerPath(id = "id", arrow = "r", 
             title = "Tromsø IL (vs. Strømsgodset, 3rd Nov 2013)", 
             subtitle = "Player paths (1')")
