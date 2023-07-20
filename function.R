# Partie indicateur de performance, ressources
# Pour calculer la quantité de Grain consommé 
data_grain <- sum(data$Grain_ingest)
setwd("C:/Users/Youness/Desktop/R project/stage/amandine")
requirement_herd <- read_excel("Herd_Requirements_cleaned.xlsx", col_names = TRUE )
female <- calculate_mean_by_cycle(requirement_herd,  "Herd size Female")
colnames(female) <- c("herd_size_female")
female_sum <- sum(female$herd_size_female)
female_sum2 <- round(female_sum/366)
grain_ingest_par_fememlle <- data_grain/female_sum2

# Pour calculer la quantité de forrage consommé 
data_forrage <- sum(data$Forage_ingest)
forage_ingest_par_fememlle <- data_forrage/female_sum2

#Calcul du taux de paturage 
data_grass <- sum(data$Grassland_ingest)
data_rangela <- sum(data$Rangeland_ingest )
quantite_ms <- data_grass + data_rangela
quantite_ms_totale <- quantite_ms + data_forrage

taux_paturage <- quantite_ms/quantite_ms_totale

