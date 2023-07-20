library(markdown)
library(shiny)
library(ggplot2)
library(readxl)
library(ggcorrplot)
library(tidyverse)
library(plotly)
library(highcharter)
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(shinycssloaders)
library(shinyWidgets)



calculate_mean_by_cycle <- function(data, variable) {
  result <- as.data.frame(by(data[[variable]], list(data$cycle), mean))
  return(result)
}

# Importation des données de la situation initiale

setwd("C:/Users/Youness/Desktop/R project/stage/amandine/second/clean")
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

setwd("C:/Users/Youness/Desktop/R project/stage/amandine/scénario/DEED_ADAPT_OVH_CC/includes/clean")

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

setwd("C:/Users/Youness/Desktop/R project/stage/amandine/scénario/DEED_ADAPT_OVH_CC/models/clean")
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











descriptionn <- function() {
  box(width=12,height="80px",
      p(style="font-size:20px",strong("L'objectif"),"de cette application est de développer des prototypes de visualisations permettant de rendre compte des résultats obtenus des simulations 
et facilitant la comparaison entre eux. "),
  )

}



accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}




js <- "
Shiny.addCustomMessageHandler('anim',
 function(x){

    var $box = $('#' + x.id + ' div.small-box');
    var value = x.value;

    var $icon = $box.find('i.fa');

    var $s = $box.find('div.inner h3');
    var o = {value: 0};
    $.Animation( o, {
        value: value
      }, {
        duration: 3000
      }).progress(function(e) {
          $s.text((e.tweens[0].now).toFixed(0));
    });

  }
);"

# other parameters 
# to use icons : <script src="https://kit.fontawesome.com/3a3a5f75cd.js" crossorigin="anonymous"></script>
setwd("C:/Users/Youness/Desktop/R project/stage/shiny/inraeshiny")

dates <- seq(as.Date("2020-01-01"), as.Date("2020-12-31"), by = "day")
dates_formattees <- format(dates, "%d %b")
Date <- data.frame(Date = dates_formattees)
Outputs_requirements <- read_excel("Outputs_requirements_cleaned.xlsx", col_names = TRUE )

Herd_Requirement_mean <- as.data.frame(by(Outputs_requirements$'Herd Requirement', list(Outputs_requirements$cycle), mean)) 
Herd_Requirement_min<- as.data.frame(by(Outputs_requirements$'Herd Requirement', list(Outputs_requirements$cycle), min)) 
Herd_Requirement_max <- as.data.frame(by(Outputs_requirements$'Herd Requirement', list(Outputs_requirements$cycle), max)) 
data_radio <- cbind(dd = a <- seq(1, 366, by =1 ) , Date , Herd_Requirement_mean, Herd_Requirement_min, Herd_Requirement_max )
colnames(data_radio) <- c("dd" , "Date", "mean", "min", "max")

Rangeland_ingested_mean <- as.data.frame(by(Outputs_requirements$'Rangeland ingested', list(Outputs_requirements$cycle), mean))
Rangeland_ingested_min <- as.data.frame(by(Outputs_requirements$'Rangeland ingested', list(Outputs_requirements$cycle), min))
Rangeland_ingested_max <- as.data.frame(by(Outputs_requirements$'Rangeland ingested', list(Outputs_requirements$cycle), max))
data2_radio <- cbind(dd = a <- seq(1, 366, by =1 ) , Date , Rangeland_ingested_mean, Rangeland_ingested_min, Rangeland_ingested_max )
colnames(data2_radio) <- c("dd" , "Date", "mean", "min", "max")

Forage_ingested_mean <- as.data.frame(by(Outputs_requirements$'Forage ingested', list(Outputs_requirements$cycle), mean))
Grassland_ingested_mean <- as.data.frame(by(Outputs_requirements$'Grassland ingested', list(Outputs_requirements$cycle), mean))

data3_radio <- cbind(Date, Rangeland_ingested_mean, Forage_ingested_mean, Grassland_ingested_mean)
colnames(data3_radio) <- c("Date", "Rangeland_ingested", "Forage_ingested", "Grassland_ingested")
data3_radio <- gather(data3_radio, key="year", value="points", 2:4)
setwd("C:/Users/Youness/Desktop/R project/stage/amandine/second/clean")
biotech <- read_excel("biotech_parameters.xlsx", col_names = FALSE )

colnames(biotech) <- c("parameters", "value")
effectifanimaux <- filter(biotech, parameters %in% c('nb_female', 
                                                     'nb_young',
                                                     'nb_male'))

stadephysio <- filter(biotech, parameters %in% c('lamb_require', 
                                                 'fattening_require',
                                                 'lamb_ewe_s1_require',
                                                 'lamb_ewe_s2_require',
                                                 'empty_require',
                                                 'end_gest_require',
                                                 'beg_lact_require',
                                                 'male_require'
))

plot_management <- read_excel("plot_management.xlsx", col_names = TRUE )
plot_management[is.na(plot_management)] = 0
a <- select(plot_management, taille, id_mod_expl_comp)
plot_man <- as.data.frame(by(a$taille, list(a$id_mod_expl_comp), sum))
plot_man <- cbind(rownames(plot_man), plot_man)
colnames(plot_man ) <- c("Surface", "taille")


# Fonctions utiles pour la répartition des graphes : 
quinzine <- function(data){
  satap <-as.data.frame(data$mean) 
  colnames(satap)=c("mean")
  values <- as.data.frame(c(sum(satap[1:15,]),sum(satap[16:31,]) , sum(satap[32:45,]), sum(satap[46:60,]),
                            sum(satap[61:75,]), sum(satap[76:91,]), sum(satap[92:106,]), sum(satap[107:121,]), 
                            sum(satap[122:136,]), sum(satap[137:152,]), sum(satap[153:167,]), sum(satap[168:182,]),
                            sum(satap[183:197,]),sum(satap[198:213,]),sum(satap[214:228,]),sum(satap[229:244,]),
                            sum(satap[245:259,]),sum(satap[260:274,]),sum(satap[275:289,]),sum(satap[290:305,]),
                            sum(satap[306:320,]),sum(satap[321:335,]),sum(satap[336:350,]),sum(satap[351:366,])))    
  mois <- as.data.frame(c("j1", "j2", "f1", "f2", "ms1", "ms2", "av1", "av2", "ma1", "ma2", "ju1", "ju2", "jl1", "jl2", "ao1", "ao2", 
                          "s1", "s2", "o1", "o2", "n1", "n2", "d1", "d2") )
  donnee <- cbind(mois, values)
  colnames(donnee) <- c("Date", "mean")
  return(donnee)
}

mois <- function(data){
  satap <-as.data.frame(data$mean) 
  colnames(satap)=c("mean")
  values <- as.data.frame(c(sum(satap[1:31,]), sum(satap[32:60,]), 
                            sum(satap[61:91,]), sum(satap[92:121,]), 
                            sum(satap[122:152,]), sum(satap[153:182,]), 
                            sum(satap[183:213,]),sum(satap[214:244,]),
                            sum(satap[245:274,]),sum(satap[275:305,]),
                            sum(satap[306:335,]),sum(satap[336:366,])))    
  mois <- as.data.frame(c("janvier", "février", "mars", "avril", "mai", "juin", "juillet", "aout", "septembre", "octobre", "novembre", "décembre"))
  donnee <- cbind(mois, values)
  colnames(donnee) <- c("Date", "mean")
  return(donnee)
}

saison <- function(data) {
  satap <-as.data.frame(data$mean) 
  colnames(satap)=c("mean")
  values <-  as.data.frame(c(sum(satap[c(1:60,336:366),]), 
                             sum(satap[c(61:152),]),
                             sum(satap[c(153:244),]),
                             sum(satap[c(245:335),]))
  )
  saison <- c("Hiver", "Printemps", "Ete", "Automne")
  donnee <- cbind(saison, values)
  colnames(donnee) <- c("Date", "mean")
  return(donnee)
}


