source("C:/Users/Youness/Desktop/R project/stage/shiny/test/About.R")

ui <- dashboardPage(
   #includeCSS("C:/Users/Youness/Desktop/R project/stage/shiny/test/custom.css"),
  dashboardHeader(title = "Projet Adapt-Herd",
                  titleWidth = 250
                  
                  ),
  dashboardSidebar(
    width = 280, 
    sidebarMenu(
      menuItem("About", tabName = "about", icon = icon("info-circle")),
      menuItem("Etude de cas 1",  icon = tags$i(class = "fa-solid fa-building-wheat"),
               menuSubItem("Situation Initiale", tabName = "subitem1i"),
               menuSubItem("Situation sous changement climatique", tabName = "subitem1"),
               menuSubItem("Stratégie d'adaptation 1", tabName = "subitem11"),
               menuSubItem("Stratégie d'adaptation 2", tabName = "subitem12"),
               menuSubItem("Stratégie d'adaptation 3", tabName = "subitem13")
      ),
      menuItem("Etude de cas 2", icon = tags$i(class = "fa-solid fa-building-wheat"),
               menuSubItem("Situation Initiale", tabName = "subitem2i"),
               menuSubItem("Situation sous changement climatique", tabName = "subitem2"),
               menuSubItem("Stratégie d'adaptation 1", tabName = "subitem21"),
               menuSubItem("Stratégie d'adaptation 2", tabName = "subitem22"),
               menuSubItem("Stratégie d'adaptation 3", tabName = "subitem23")
      ),
      menuItem("Etude de cas 3", icon = tags$i(class = "fa-solid fa-building-wheat"),
               menuSubItem("Situation Initiale", tabName = "subitem3i"),
               menuSubItem("Situation sous changement climatique", tabName = "subitem3"),
               menuSubItem("Stratégie d'adaptation 1", tabName = "subitem31"),
               menuSubItem("Stratégie d'adaptation 2", tabName = "subitem32"),
               menuSubItem("Stratégie d'adaptation 3", tabName = "subitem33")
      )
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML('#parentre{margin-right: 450px;
  margin-left: 10px;}'))
    ),
    tags$head(
      tags$style(HTML('#parsortie{text-align: center}'))
    ),
    tags$head(
      tags$style(HTML('#indperf{margin-right: 100px;
  margin-left: 400px}'))
    ),
    tags$script(src = "https://kit.fontawesome.com/3a3a5f75cd.js"),
    tags$head(
      tags$link(
        rel = "stylesheet",
        href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
      )
    ),
    includeCSS("C:/Users/Youness/Desktop/R project/stage/shiny/test/custom.css"),
    
    tabItems(
      tabItem("about", 
              h2("Interface et visualisation de données de simulation : application aux stratégies d’adaptation des systèmes d’élevage aux changements climatiques",style="text-align:center"),
              imageOutput("home_img"),
              # includeHTML("C:/Users/Youness/Desktop/R project/stage/shiny/test/R/www/index.html"),
              box(width=12,height="80px",
                  p(style="font-size:20px",strong("L'objectif"),"de cette application est de développer des prototypes de visualisations permettant de rendre compte des résultats obtenus des simulations 
et facilitant la comparaison entre eux. "),
              ),
      ),
              
              
              
      tabItem("subitem1i",
              useShinyjs(),  # Include shinyjs
              div(
                id = "tab",
                bsButton("parentre", 
                         label = "Paramètres d'entrées", 
                         icon = icon("user"), 
                         style = "success"),
                bsButton("parsortie", 
                         label = "Paramètres de sortie", 
                         icon = icon("spinner", class = "spinner-box"), 
                         style = "success"),
                bsButton("indperf", 
                         label = "Indicateur de performance", 
                         icon = icon("flask", class = "flask-box"), 
                         style = "success")
                
              ),
              shinyjs::hidden(
                div(
                  id = "par_entree",
                  h3("Paramètres d'entrées", align = "center"),
                  br(),
                  fluidRow(
                    # A static infoBox
                    infoBoxOutput("NewOrder"),
                    # Dynamic infoBoxes
                    infoBoxOutput("progressBox"),
                    infoBoxOutput("approvalBox")
                  ),
                  
                  fluidRow(
                    box(
                      title = "Pie Chart",
                      status = "primary",
                      withSpinner(plotlyOutput("piechart", height = 240)),
                      height = 300
                    ),
                    tabBox(
                      height = 300,
                      tabPanel("View 1",
                               withSpinner(plotlyOutput("donutchart", height = 230))
                      ),
                      tabPanel("View 2",
                               withSpinner(highchartOutput("pie2", height = 230))
                      )
                    )
                  ),
                  fluidRow(
                    box(
                      title = " Effectif des animaux par catégorie ",
                      status = "primary",
                      
                      #height = 3,
                      
                      fluidRow(
                        column(6, radioButtons("item_choice", label = NULL, inline = TRUE, choices = c("rectangle", "parliment", "circle"))),
                        column(6, sliderInput("item_rows", NULL, min = 0, max = 5, value = 0, step = 1, ticks = FALSE))
                      ),
                      withSpinner(highchartOutput("animated", height = 240)),
                      height = 450
                    ),
                    box(
                      title = "Répartition des surfaces par type de ressources et par type d'usage",
                      status = "primary",
                      withSpinner(highchartOutput("ressource_surface"))
                    )
                  ),
                  fluidRow(
                    box(title = "Besoin en fonction des stades physiologiques ",
                        status = "primary",
                        withSpinner(highchartOutput("stade_physio")))
                  )
                  
                )
              ),
              shinyjs::hidden(
                div(
                  id = "par_sortie",
                  h3("Paramètres de sortie", align = "center"),
                  br(),
                  fluidRow(
                    box(
                      title = " violin chart ",
                      status = "primary",
                      
                      #height  = 3,
                      withSpinner(plotlyOutput("violinchart", height = 400 ))),

                    box(
                      title = "Ressources que les animaux doivent consommer",
                      status = "primary",
                      withSpinner(highchartOutput('plot')),
                      dropdown(
                        awesomeRadio(
                          inputId = "radio",
                          label = "Choix de la période", 
                          
                          choices = list("Par mois" = 1, "Par saison" = 2, "Par quinzine" = 3, "Toute l'année" = 4), 
                          selected = 1,
                          
                          status = "warning",
                        ),
                        style = "unite", icon = icon("gear"),
                        status = "danger", width = "200px",
                        animate = animateOptions(
                          enter = animations$fading_entrances$fadeInLeftBig,
                          exit = animations$fading_exits$fadeOutRightBig
                        ),
                        up = TRUE
                      )
                    )
                  ),
                  fluidRow(
                    box(title = "Ressources en parcours consommées par les animaux",
                        status = "primary",
                        withSpinner(highchartOutput("rangeland_consome"))
                        ),
                    box(title = "Ressources en parcours consommées par les animaux",
                        status = "primary",
                        withSpinner(highchartOutput("ressour_consom"))
                        )
                  )
                
              )),
              shinyjs::hidden(
                div(
                  id = "indi_perfor",
                  h3("Indicateur de performance", align = "center"),
                  plotlyOutput("gauge"),
                  br(),
                  tags$head(tags$script(HTML(js))),
                  fluidRow(
                    tagAppendAttributes(
                      valueBox("", subtitle = "Grain consommé par chage femelle",
                               icon = tags$i(class = "fa-solid fa-wheat-awn-circle-exclamation"),
                               color = "light-blue"
                      ),
                      id = "grain_ingest"
                    ),
                    tagAppendAttributes(
                      valueBox("", subtitle = "Forrage consommé par chage  femelle",
                               icon = tags$i(class = "fa-solid fa-wheat-awn"),
                               color = "light-blue"
                      ),
                      id = "forage_ingest"
                    ),
                    tagAppendAttributes(
                      valueBox("", subtitle = "Taux de paturage",
                               icon = tags$i(class = "fa-solid fa-seedling"),
                               color = "light-blue"
                      ),
                      id = "taux"
                    )
                  )
                )
              )
              
              ),
      tabItem("subitem1",
              h3("Paramètres d'entrées", align = "center"),
              br(),
              fluidRow(
                # A static infoBox
                infoBoxOutput("NewOrder_cc"),
                # Dynamic infoBoxes
                infoBoxOutput("progressBox_cc"),
                infoBoxOutput("approvalBox_cc")
              ),
              
              fluidRow(
                box(
                  title = "Pie Chart",
                  status = "primary",
                  plotlyOutput("piechart_cc", height = 240),
                  height = 300
                ),
                tabBox(
                  height = 300,
                  tabPanel("View 1",
                           plotlyOutput("donutchart_cc", height = 230)
                  ),
                  tabPanel("View 2",
                           highchartOutput("pie2_cc", height = 230)
                  )
                ),
                h3("Paramètres de sortie", align = "center"),
                br(),
                fluidRow(
                  box(
                    title = " violin chart ",
                    status = "primary",
                    
                    #height  = 3,
                    plotlyOutput("violinchart_cc", height = 240 )
                  ),
                  
                  box(
                    title = " Dessin animé ",
                    status = "primary",
                    
                    #height = 3,
                    
                    fluidRow(
                      column(6, radioButtons("item_choice_cc", label = NULL, inline = TRUE, choices = c("rectangle", "parliment", "circle"))),
                      column(6, sliderInput("item_rows_cc", NULL, min = 0, max = 5, value = 0, step = 1, ticks = FALSE))
                    ),
                    highchartOutput("animated_cc", height = 240)
                  )
                  
                  
                )
                
                
              ),
              h3("Indicateur de performance", align = "center"),
              plotlyOutput("gauge_cc")
              
              ),
      tabItem("subitem11", 
              descriptionn()
              ),
      tabItem("subitem12",
              descriptionn()
              ),
      tabItem("subitem13", 
              descriptionn()
              ),
      tabItem("subitem2", 
              descriptionn()
              ),
      tabItem("subitem21", 
              descriptionn()
              ),
      tabItem("subitem22", 
              descriptionn()
              ),
      tabItem("subitem23",
              descriptionn()
              ),
      tabItem("subitem3",
              descriptionn()
              ),
      tabItem("subitem31", 
              descriptionn()
              ),
      tabItem("subitem32", 
              descriptionn()
              ),
      tabItem("subitem33", 
              descriptionn()
              )
    )
  )
)

