library(markdown)
library(shiny)
library(ggplot2)
library(readxl)
library(ggcorrplot)
library(tidyverse)
library(plotly)
library(highcharter)
library(shinydashboard)



calculate_mean_by_cycle <- function(data, variable) {
  result <- as.data.frame(by(data[[variable]], list(data$cycle), mean))
  return(result)
}

# Importation des données de la situation initiale

setwd("C:/Users/Youness/Desktop/R project/stage/ammandine/second/clean")
biotech <- read_excel("biotech_parameters.xlsx", col_names = FALSE )
colnames(biotech) <- c("parameters", "value")
dataa <- filter(biotech, parameters %in% c('proba_mating_success_winter', 
                                           'proba_mating_success_summer',
                                           'proba_mating_success_autumn'))



time_min <- filter(biotech, parameters == 'time_to_sale_min')
time_max <- filter(biotech, parameters == 'time_to_sale_max')


a <- 1 - dataa$value[1] - dataa$value[2]- dataa$value[3]
spring <- tibble(parameters = 'proba_mating_success_spring', value = a)

dataa <- rbind(dataa, spring)




data2 <- filter(biotech, parameters %in% c('nb_female', 
                                           'nb_young',
                                           'nb_male', 'nb_birth'))

setwd("C:/Users/Youness/Desktop/R project/stage/shiny/inraeshiny")


Outputs_requirements <- read_excel("Outputs_requirements_cleaned.xlsx", col_names = TRUE )
Feed_Available <- read_excel("Feed_Available_cleaned.xlsx", col_names = TRUE )

Forage_ingest <- calculate_mean_by_cycle(Outputs_requirements,  "Forage ingested")
Grain_ingest <- calculate_mean_by_cycle(Outputs_requirements,  "Grain ingested")
Grassland_ingest <- calculate_mean_by_cycle(Outputs_requirements,  "Grassland ingested") 
Rangeland_ingest <- calculate_mean_by_cycle(Outputs_requirements,  "Rangeland ingested") 
cycle <- calculate_mean_by_cycle(Outputs_requirements,  "cycle") 


Forage_available <- calculate_mean_by_cycle(Feed_Available,  "Forage_available") 
Grain_available <- calculate_mean_by_cycle(Feed_Available,  "Grain_Available") 
Grassland_available <- calculate_mean_by_cycle(Feed_Available,  "Grasslands_Available") 
Rangeland_available <- calculate_mean_by_cycle(Feed_Available,  "Rangelands_Available") 

data <- cbind(Forage_ingest, Grain_ingest, Grassland_ingest, Rangeland_ingest,
              Forage_available, Grain_available, Grassland_available, Rangeland_available, cycle )

colnames(data) <- c(
  "Forage_ingest",
  "Grain_ingest",
  "Grassland_ingest",
  "Rangeland_ingest",
  "Forage_available",
  "Grain_available",
  "Grassland_available",
  "Rangeland_available",
  "cycle"
)

a <- c("Forage_available", "Grain_available", "Grassland_available", "Rangeland_available",
       "Rangeland_ingest", "Grassland_ingest", "Grain_ingest", "Forage_ingest", "cycle"  )



# Importation des données du scénario sous changement climatique


setwd("C:/Users/Youness/Desktop/R project/stage/ammandine/scénario/DEED_ADAPT_OVH_CC/includes/clean")
biotech_cc <- read_excel("biotech_parameters.xlsx")
colnames(biotech_cc) <- c("parameters", "value")
dataa_cc <- filter(biotech_cc, parameters %in% c('proba_mating_success_winter', 
                                              'proba_mating_success_summer',
                                              'proba_mating_success_autumn'))
time_min_cc <- filter(biotech_cc, parameters == 'time_to_sale_min')
time_max_cc<- filter(biotech_cc, parameters == 'time_to_sale_max')


a_cc <- 1 - dataa_cc$value[1] - dataa_cc$value[2]- dataa_cc$value[3]
spring_cc <- tibble(parameters = 'proba_mating_success_spring', value = a)

dataa_cc <- rbind(dataa_cc, spring_cc)


data2_cc <- filter(biotech_cc, parameters %in% c('nb_female', 
                                           'nb_young',
                                           'nb_male', 'nb_birth'))

setwd("C:/Users/Youness/Desktop/R project/stage/ammandine/scénario/DEED_ADAPT_OVH_CC/models/clean")

Outputs_requirements_cc <- read_excel("Outputs_requirements.xlsx", col_names = TRUE )
Feed_Available_cc <- read_excel("Feed_Available.xlsx", col_names = TRUE )



Forage_ingest_cc <- calculate_mean_by_cycle(Outputs_requirements_cc,  "Forage ingested")
Grain_ingest_cc <- calculate_mean_by_cycle(Outputs_requirements_cc,  "Grain ingested")
Grassland_ingest_cc <- calculate_mean_by_cycle(Outputs_requirements_cc,  "Grassland ingested") 
Rangeland_ingest_cc <- calculate_mean_by_cycle(Outputs_requirements_cc,  "Rangeland ingested") 
cycle_cc <- calculate_mean_by_cycle(Outputs_requirements_cc,  "cycle") 


Forage_available_cc <- calculate_mean_by_cycle(Feed_Available_cc,  "Forage_available") 
Grain_available_cc <- calculate_mean_by_cycle(Feed_Available_cc,  "Grain_Available") 
Grassland_available_cc <- calculate_mean_by_cycle(Feed_Available_cc,  "Grasslands_Available") 
Rangeland_available_cc <- calculate_mean_by_cycle(Feed_Available_cc,  "Rangelands_Available") 

data_cc <- cbind(Forage_ingest_cc, Grain_ingest_cc, Grassland_ingest_cc, Rangeland_ingest_cc,
              Forage_available_cc, Grain_available_cc, Grassland_available_cc, Rangeland_available_cc, cycle_cc )

colnames(data_cc) <- c(
  "Forage_ingest",
  "Grain_ingest",
  "Grassland_ingest",
  "Rangeland_ingest",
  "Forage_available",
  "Grain_available",
  "Grassland_available",
  "Rangeland_available",
  "cycle"
)











description <- function() {
  div(p("Mediterranean livestock farming systems have specific characteristics, such as heterogeneity of animals, diversity in land use and mobility that make them particularly sensitive to climatic hazards. Combining resilient herds and an efficient use of various feed resources is central to develop adapted livestock farming systems to climate change. This study aims at evaluating the multi-level implications of adaptation levers that can be mobilized by Mediterranean small ruminant farmers. An approach, which combined a participatory design of adaptation strategies and a simulation of these strategies on four Mediterranean French and Spanish farm types, was used. The farm types differ in their level of herd intensification and in their feeding practices. For the four contrasting situations, groups of experts were mobilized to design: (i) the projected impact of climate change on vegetation and (ii) several adaptation strategies. The results showed that adaptation levers to climate change were different between farm types and flock management (sedentary or transhumant). However, the impacts of climate change on these farms, and in particular on fodder and pastoral resources, guide them to common adaptation levers. We therefore tested the effects of three levers: (i) increasing the part of pastoral area, (ii) shifting the grazing periods, and (iii) decreasing the number of lambings or the age at first mating to better match with resources availability. The assessment of the effect of certain adaptation levers on livestock systems are based on their forage autonomy, grazing rate and the number of days when needs are not covered. The implementation of the levers showed that they allowed the impacts of climate change to be mitigated, but they did not allow a return to an initial situation with needs covered all year round and a high autonomy and grazing rate."))
  
}



accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}











