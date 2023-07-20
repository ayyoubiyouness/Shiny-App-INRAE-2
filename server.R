setwd("C:/Users/Youness/Desktop/R project/stage/shiny/test/www")
server <- function(input, output, session) {
  
  output$ressour_consom <- renderHighchart({
    Sys.sleep(1.5)
    hc <- data3_radio %>% 
      hchart(
        'column', hcaes(x = 'Date', y = 'points', group = 'year'),
        stacking = "normal"
      ) %>%
      hc_colors(c("#0073C2FF", "#EFC000FF", "red"))%>%
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = "custom-file-name"
      )
    
    hc
    
    
  })
  
  output$rangeland_consome <- renderHighchart({
    Sys.sleep(1.5)
    h1 <- highchart() %>% 
      hc_xAxis(categories = data2_radio$Date) %>% 
      hc_add_series(name = "Rangeland_ingested_mean", 
                    data = data2_radio$mean) %>% 
      hc_add_series(name = "Rangeland_ingested_min",
                    data = data2_radio$min) %>%
      hc_add_series(name = "Rangeland_ingested_max",
                    data = data2_radio$max)%>%
      hc_title(
        text = "Ressources consommées par les animaux",
        margin = 50,
        # align = "centre",
        style = list(color = "#22A884", useHTML = TRUE)
      )%>%
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = "custom-file-name"
      )
    
    
    
    # Afficher le graphique
    h1
    
  })
  
  
  output$stade_physio <- renderHighchart({
    Sys.sleep(1.5)
    hc <- stadephysio %>%
      hchart(
        'bar', hcaes(x = parameters, y = value),
        color = "lightgray", borderColor = "black"
      )%>%
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = "custom-file-name"
      )
    hc
   
  })
  
  output$ressource_surface <- renderHighchart({
    Sys.sleep(1.5)
    hc <- plot_man %>% 
      hchart(
        'column', hcaes(x = Surface, y = taille, color = Surface)
      )  %>%
      hc_title(
        text = "Par type de ressource et par type d'usage ",
        margin = 50,
        # align = "centre",
        style = list(color = "#22A884", useHTML = TRUE)
      )%>%
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = "custom-file-name"
      )
    
    hc
  })
  
  bins <- reactive({
    input$radio
    if (input$radio == 1) {
      dataa <- mois(data_radio)
    } else if ((input$radio == 2)) {
      dataa <- saison(data_radio)
    } else if ((input$radio == 3)) {
      dataa <- quinzine(data_radio)
    } else {
      dataa <- data_radio
    }
    
  })
  output$plot <- renderHighchart({
    Sys.sleep(1.5)
    h1 <- highchart() %>% 
      hc_xAxis(categories = bins()$Date) %>% 
      hc_add_series(name = "Herd_Requirement_mean", 
                    data = bins()$mean) %>%
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = "custom-file-name"
      )
    
    # Afficher le graphique
    h1
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste("dataset-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(bins(), file)
    })
  output$downloadPlot <- downloadHandler(
    filename = function() { 
      paste("dataset-", Sys.Date(), ".png", sep='')
    },
    content = function(file) {
      png(file)
      print(h1)
      dev.off()
    })
  
  
  observeEvent(input$indperf, {
    for(i in 1:30){
      session$sendCustomMessage("anim", list(id = "grain_ingest", value = grain_ingest_par_fememlle))
      session$sendCustomMessage("anim", list(id = "taux", value = taux_paturage))
      session$sendCustomMessage("anim", list(id = "forage_ingest", value = forage_ingest_par_fememlle))
    }
  })
  
  
  shinyjs::onclick("parentre",
                   shinyjs::toggle(id = "par_entree", anim = TRUE))
  shinyjs::onclick("parsortie",
                   shinyjs::toggle(id = "par_sortie", anim = TRUE))
  shinyjs::onclick("indperf",
                   shinyjs::toggle(id = "indi_perfor", anim = TRUE))
  
  
  output$home_img <- renderImage({
    
    list(src = "imgaccueil.jpg",
         width = "100%",
         height = 330)
    
  }, deleteFile = F)
  # Le serveur de la situation initiale
  output$approvalBox <- renderInfoBox({
    a2 <-  filter(biotech, parameters == "rate_morta_young")
    infoBox(
      "Taux de mortalité des jeunes", a2$value , " Il s’agit du pourcentage d’animaux jeunes,
généralement des animaux âgés de moins d’un an, qui meurent dans le troupeau sur une période
donnée", 
      icon = icon("star"),
      color = "yellow"
    )
  })
  
  output$progressBox <- renderInfoBox({
    a1 <-  filter(biotech, parameters == "rate_morta_ad")
    infoBox(
      "Taux de mortalité adulte", a1$value , " Il s’agit du pourcentage d’animaux adultes qui
meurent dans le troupeau sur une période donnée", 
      icon = icon("heart"),
      color = "purple"
    )
  })
  
  output$NewOrder <- renderInfoBox({
    a3 <-  filter(biotech, parameters == "renewal_rate")
    infoBox(
      "Taux de renouvellement", a3$value , " Il s’agit du pourcentage d’animaux renouvelés dans le
troupeau sur une période donnée", 
      icon = icon("plus"),
      color = "red"
    )
  })
  
  output$animated <- renderHighchart ({
    Sys.sleep(1.5)
    hchart(
      data2,
      "item", 
      hcaes(name = parameters, y = value),
      name = "Nombre ",
      id = "serieid"
    )%>%
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = "custom-file-name"
      )
  })
  
  observeEvent(input$item_rows, {
    
    highchartProxy("animated") %>% 
      hcpxy_update_series(
        id = "serieid",
        rows = input$item_rows
      )
    
  })
  
  observeEvent(input$item_choice, {
    
    hcpxy <- highchartProxy("animated")
    
    if(input$item_choice == "parliment") {
      hcpxy %>%
        hcpxy_update_series(
          id = "serieid",
          center = list('50%', '88%'),
          size = '170%',
          startAngle = -100,
          endAngle = 100
        )
    } else if (input$item_choice == "rectangle") {
      hcpxy %>%
        hcpxy_update_series(
          id = "serieid",
          startAngle = NULL,
          endAngle = NULL
        )
    } else if (input$item_choice == "circle") {
      hcpxy %>%
        hcpxy_update_series(
          id = "serieid",
          center = list('50%', '50%'),
          size = '100%',
          startAngle = 0,
          endAngle = 360
        )
    }
    
  })
  
  
  
  
  
  output$piechart <- renderPlotly({
    Sys.sleep(1.5)
    fig <- plot_ly(dataa, labels = ~parameters, values = ~value, type = 'pie')
    fig <- fig %>% layout(title = 'Représentation des probabilités ',
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    fig
    
  })
  output$donutchart <- renderPlotly({
    Sys.sleep(1.5)
    data3 <- filter(biotech, parameters %in% c('time_first_MB', 'TimetoRenouv', 'time_to_sale_min', 'time_to_sale_max',
                                               'to_portee_2', 'to_portee_3', 'to_portee_4'))
    
    
    fig <- data3 %>% plot_ly(labels = ~parameters, values = ~value)
    fig <- fig %>% add_pie(hole = 0.6)
    fig <- fig %>% layout(title = "Donut charts",  showlegend = F,
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          showlegend = FALSE )
    
    fig
  })
  
  
  output$violinchart <- renderPlotly({
    data1 <- cbind(Forage_ingest, Grain_ingest, Grassland_ingest, Rangeland_ingest )
    
    
    colnames(data1) <- c(
      "Forage_ingest",
      "Grain_ingest",
      "Grassland_ingest",
      "Rangeland_ingest"
    )
    
    data1 <- data1 %>%
      mutate(across(everything(), as.numeric))
    
    
    
    
    data <- tibble(data1)
    data_grass <- select(data,Grassland_ingest   )
    data_grass <- gather( data_grass, key = "type", value = 'valeur')
    data_grain <- select(data,Grain_ingest )
    data_grain <- gather(data_grain , key = "type", value = 'valeur')
    
    
    df <- rbind(data_grass, data_grain)
    fig <- df %>%
      plot_ly(
        x = ~type,
        y = ~valeur,
        split = ~type,
        type = 'violin',
        box = list(
          visible = T
        ),
        meanline = list(
          visible = T
        )
      ) 
    
    fig <- fig %>%
      layout(
        xaxis = list(
          title = "type"
        ),
        yaxis = list(
          title = "valeur",
          zeroline = F
        )
      )
    
    fig
  })
  
  
  output$gauge <- renderPlotly({
    fig <- plot_ly(
      domain = list(x = c(0, 1), y = c(0, 1)),
      value = 10,
      title = list(text = "Visualisation de l'état d'avancement"),
      type = "indicator",
      mode = "gauge+number+delta",
      delta = list(reference = 12),
      gauge = list(
        axis = list(range = c(time_min$value, time_max$value)),
        bar = list(color = "black"),
        steps = list(
          list(range = c(time_min$value, 6), color = "red"),
          list(range = c(6, 8), color = "cyan"),
          list(range = c(8, time_max$value), color = "green")
        ),
        threshold = list(
          line = list(color = "blue", width = 4),
          thickness = 0.75,
          value = 10.9
        )
      )
    )
    
    # Ajouter des annotations pour les définitions
    fig <- fig %>% layout(
      annotations = list(
        list(
          text = "Phase 1",
          x = 0.5,
          y = 0.6,
          showarrow = FALSE,
          font = list(color = "red")
        ),
        list(
          text = "Phase 2",
          x = 0.5,
          y = 0.5,
          showarrow = FALSE,
          font = list(color = "cyan")
        ),
        list(
          text = "Phase 3",
          x = 0.5,
          y = 0.4,
          showarrow = FALSE,
          font = list(color = "green")
        )
      )
    )
    
    fig <- fig %>% layout(
      # title = "Représentation de l'indicateur",
      margin = list(l = 20, r = 30)
    )
    
    fig
    
    
  })
  output$pie2 <- renderHighchart ({
    Sys.sleep(1.5)
    hc <- dataa %>%
      hchart(
        "pie", hcaes(x = parameters, y = value),
        name = "Probabilité"
      )%>%
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = "custom-file-name"
      )
    
    hc
  })
  
  
  # Le serveur de la situation sous changement climatique
  output$approvalBox_cc <- renderInfoBox({
    a2_cc <-  filter(biotech_cc, parameters == "rate_morta_young")
    infoBox(
      "Taux de mortalité des jeunes", a2_cc$value , " Il s’agit du pourcentage d’animaux jeunes,
généralement des animaux âgés de moins d’un an, qui meurent dans le troupeau sur une période
donnée", 
      icon = icon("star"),
      color = "yellow"
    )
  })
  
  output$progressBox_cc <- renderInfoBox({
    a1_cc <-  filter(biotech_cc, parameters == "rate_morta_ad")
    infoBox(
      "Taux de mortalité adulte", a1_cc$value , " Il s’agit du pourcentage d’animaux adultes qui
meurent dans le troupeau sur une période donnée", 
      icon = icon("heart"),
      color = "purple"
    )
  })
  
  output$NewOrder_cc <- renderInfoBox({
    a3_cc <-  filter(biotech_cc, parameters == "renewal_rate")
    infoBox(
      "Taux de renouvellement", a3_cc$value , " Il s’agit du pourcentage d’animaux renouvelés dans le
troupeau sur une période donnée", 
      icon = icon("plus"),
      color = "red"
    )
  })
  
  output$animated_cc <- renderHighchart ({
    hchart(
      data2_cc,
      "item", 
      hcaes(name = parameters, y = value),
      name = "Nombre ",
      id = "serieid"
    )%>%
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = "custom-file-name"
      )
  })
  
  
  observeEvent(input$item_rows_cc, {
    
    highchartProxy("animated") %>% 
      hcpxy_update_series(
        id = "serieid",
        rows = input$item_rows_cc
      )
    
  })
  
  
  observeEvent(input$item_choice_cc, {
    
    hcpxy <- highchartProxy("animated_cc")
    
    if(input$item_choice_cc == "parliment") {
      hcpxy %>%
        hcpxy_update_series(
          id = "serieid",
          center = list('50%', '88%'),
          size = '170%',
          startAngle = -100,
          endAngle = 100
        )
    } else if (input$item_choice_cc == "rectangle") {
      hcpxy %>%
        hcpxy_update_series(
          id = "serieid",
          startAngle = NULL,
          endAngle = NULL
        )
    } else if (input$item_choice_cc == "circle") {
      hcpxy %>%
        hcpxy_update_series(
          id = "serieid",
          center = list('50%', '50%'),
          size = '100%',
          startAngle = 0,
          endAngle = 360
        )
    }
    
  })
  
  output$piechart_cc <- renderPlotly({
    fig <- plot_ly(dataa_cc, labels = ~parameters, values = ~value, type = 'pie')
    fig <- fig %>% layout(title = 'Représentation des probabilités ',
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    fig
    
  })
  
  
  output$donutchart_cc <- renderPlotly({
    data3_cc <- filter(biotech_cc, parameters %in% c('time_first_MB', 'TimetoRenouv', 'time_to_sale_min', 'time_to_sale_max',
                                               'to_portee_2', 'to_portee_3', 'to_portee_4'))
    
    
    fig <- data3_cc %>% plot_ly(labels = ~parameters, values = ~value)
    fig <- fig %>% add_pie(hole = 0.6)
    fig <- fig %>% layout(title = "Donut charts",  showlegend = F,
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          showlegend = FALSE )
    
    fig
  })
  
  output$violinchart_cc <- renderPlotly({
    data1_cc <- cbind(Forage_ingest_cc, Grain_ingest_cc, Grassland_ingest_cc, Rangeland_ingest_cc )
    
    
    colnames(data1_cc) <- c(
      "Forage_ingest",
      "Grain_ingest",
      "Grassland_ingest",
      "Rangeland_ingest"
    )
    
    data1_cc <- data1_cc %>%
      mutate(across(everything(), as.numeric))
    
    
    
    
    data_cc <- tibble(data1_cc)
    data_grass_cc <- select(data_cc,Grassland_ingest_cc   )
    data_grass_cc <- gather( data_grass_cc, key = "type", value = 'valeur')
    data_grain_cc <- select(data_cc,Grain_ingest_cc )
    data_grain_cc <- gather(data_grain_cc , key = "type", value = 'valeur')
    
    
    df <- rbind(data_grass_cc, data_grain_cc)
    fig <- df %>%
      plot_ly(
        x = ~type,
        y = ~valeur,
        split = ~type,
        type = 'violin',
        box = list(
          visible = T
        ),
        meanline = list(
          visible = T
        )
      ) 
    
    fig <- fig %>%
      layout(
        xaxis = list(
          title = "type"
        ),
        yaxis = list(
          title = "valeur",
          zeroline = F
        )
      )
    
    fig
  })
  
  output$gauge_cc <- renderPlotly({
    fig <- plot_ly(
      domain = list(x = c(0, 1), y = c(0, 1)),
      value = 10,
      title = list(text = "Visualisation de l'état d'avancement"),
      type = "indicator",
      mode = "gauge+number+delta",
      delta = list(reference = 12),
      gauge = list(
        axis = list(range = c(time_min_cc$value, time_max_cc$value)),
        bar = list(color = "black"),
        steps = list(
          list(range = c(time_min_cc$value, 6), color = "red"),
          list(range = c(6, 8), color = "cyan"),
          list(range = c(8, time_max_cc$value), color = "green")
        ),
        threshold = list(
          line = list(color = "blue", width = 4),
          thickness = 0.75,
          value = 10.9
        )
      )
    )
    
    # Ajouter des annotations pour les définitions
    fig <- fig %>% layout(
      annotations = list(
        list(
          text = "Phase 1",
          x = 0.5,
          y = 0.6,
          showarrow = FALSE,
          font = list(color = "red")
        ),
        list(
          text = "Phase 2",
          x = 0.5,
          y = 0.5,
          showarrow = FALSE,
          font = list(color = "cyan")
        ),
        list(
          text = "Phase 3",
          x = 0.5,
          y = 0.4,
          showarrow = FALSE,
          font = list(color = "green")
        )
      )
    )
    
    fig <- fig %>% layout(
      # title = "Représentation de l'indicateur",
      margin = list(l = 20, r = 30)
    )
    
    fig
    
    
  })
  
  output$pie2_cc <- renderHighchart ({
    hc <- dataa_cc %>%
      hchart(
        "pie", hcaes(x = parameters, y = value),
        name = "Probabilité"
      )%>%
      hc_exporting(
        enabled = TRUE, # always enabled
        filename = "custom-file-name"
      )
    
    hc
  })
  
  
  
  
  
  
  
  
  
  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  selectedData <- reactive({
    data[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  
  
  randomVals <- eventReactive(input$go, {
    r <- cor(data)
    round(r, 2)
  })
  
  output$correlation <- renderPlot({
    ggcorrplot(randomVals(), lab = TRUE)
  })
  
  
  
  output$summary <- renderPrint({
    summary(data)
  })  
  
  output$table <- DT::renderDataTable({
    DT::datatable(data)
  })
}

shinyApp(ui = ui, server = server)
  
