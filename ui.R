source("C:/Users/Youness/Desktop/R project/stage/shiny/test/About.R")

ui <- dashboardPage(
   #includeCSS("C:/Users/Youness/Desktop/R project/stage/shiny/test/custom.css"),
  dashboardHeader(title = "INRAE Shiny",
                  titleWidth = 150
                  
                  ),
  dashboardSidebar(
    width = 280, 
    sidebarMenu(
      menuItem("About", tabName = "about", icon = icon("info-circle")),
      menuItem("Etude de cas 1", icon = icon("info-circle"),
               menuSubItem("Situation Initiale", tabName = "subitem1i"),
               menuSubItem("Situation sous changement climatique", tabName = "subitem1"),
               menuSubItem("Stratégie d'adaptation 1", tabName = "subitem11"),
               menuSubItem("Stratégie d'adaptation 2", tabName = "subitem12"),
               menuSubItem("Stratégie d'adaptation 3", tabName = "subitem13")
      ),
      menuItem("Etude de cas 2", icon = icon("info-circle"),
               menuSubItem("Situation Initiale", tabName = "subitem2i"),
               menuSubItem("Situation sous changement climatique", tabName = "subitem2"),
               menuSubItem("Stratégie d'adaptation 1", tabName = "subitem21"),
               menuSubItem("Stratégie d'adaptation 2", tabName = "subitem22"),
               menuSubItem("Stratégie d'adaptation 3", tabName = "subitem23")
      ),
      menuItem("Etude de cas 3", icon = icon("info-circle"),
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
      tags$link(
        rel = "stylesheet",
        href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
      )
    ),
    includeCSS("C:/Users/Youness/Desktop/R project/stage/shiny/test/custom.css"),
    
    tabItems(
      tabItem("about", 
              #includeHTML("C:/Users/Youness/Desktop/R project/stage/shiny/test/R/www/index.html")
              description()
              ),
      tabItem("subitem1i",
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
                  plotlyOutput("piechart", height = 240),
                  height = 300
                ),
                tabBox(
                  height = 300,
                  tabPanel("View 1",
                           plotlyOutput("donutchart", height = 230)
                  ),
                  tabPanel("View 2",
                           highchartOutput("pie2", height = 230)
                  )
                ),
                h3("Paramètres de sortie", align = "center"),
                br(),
                fluidRow(
                  box(
                    title = " violin chart ",
                    status = "primary",
                  
                    #height  = 3,
                    plotlyOutput("violinchart", height = 240 )
                  ),
                  
                  box(
                    title = " Dessin animé ",
                    status = "primary",
                   
                    #height = 3,
                    
                    fluidRow(
                      column(6, radioButtons("item_choice", label = NULL, inline = TRUE, choices = c("rectangle", "parliment", "circle"))),
                      column(6, sliderInput("item_rows", NULL, min = 0, max = 5, value = 0, step = 1, ticks = FALSE))
                    ),
                    highchartOutput("animated", height = 240)
                  )
                  
                  
                )
                
                
              ),
              h3("Indicateur de performance", align = "center"),
              plotlyOutput("gauge")
              
              
              
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

