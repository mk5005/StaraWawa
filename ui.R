shinyUI(
    dashboardPage(
        dashboardHeader(title = 'StaraWawa'),
        
        
        dashboardSidebar(
            sidebarMenu(id = "tabs",
                menuItem("Start", tabName = "start_tab", icon = icon("map-marker")),
                menuItem("Filtry", tabName = "filter_tab", icon = icon("filter")),
                menuItem("Wybór", tabName = "tile_choice_tab", icon = icon("th")),
                menuItem("Mapa", tabName = "map_route_tab", icon = icon("globe"))
            )
        ),
        
        dashboardBody(
            tabItems(
                tabItem(tabName = "start_tab",
                        tags$script('
                            $(document).ready(function () {
                                navigator.geolocation.getCurrentPosition(onSuccess, onError);
                                
                                function onError (err) {
                                Shiny.onInputChange("geolocation", false);
                                }
                                
                                function onSuccess (position) {
                                setTimeout(function () {
                                var coords = position.coords;
                                console.log(coords.latitude + ", " + coords.longitude);
                                Shiny.onInputChange("geolocation", true);
                                Shiny.onInputChange("lat", coords.latitude);
                                Shiny.onInputChange("long", coords.longitude);
                                }, 1100)
                                }
                                });'
                        ),
                        # fluidRow(
                        #     box(
                        #         verbatimTextOutput("lat"),
                        #         verbatimTextOutput("long")
                        #     ),
                        #     
                        #     box(
                        #         title = "Controls",
                        #         sliderInput("slider", "Number of observations:", 1, 100, 50)
                        #     )
                        # ),
                        box(
                            textInput('start.text', label = 'Podaj miejsce startu'),
                            h6('Możesz zostawić to pole puste, wtedy jako miejsce staru wybrany zostanie jeden z odwiedzanych obiektów'),
                            br(),
                            checkboxInput('use.my.location.check', label = 'Użyj mojej lokalizacji'),
                            checkboxInput('finish.where.start.check', label = 'Powrót do miejsca startu'),
                            checkboxInput('set.end.check', label = 'Ustaw koniec trasy'),
                            uiOutput('end.text'),
                            actionButton('go.to.selection.button', label = 'Przejdź do filtrów')
                            
                        )
                ),
                
                tabItem(tabName = "filter_tab",
                        box(
                             lapply(1:length(categories.list), function(category) {
                                 checkboxInput(paste0(categories.list[category], '.check'), label = names(categories.list[category]), value = TRUE)
                             }),
                             actionButton('pick.objects.button', label = 'Przejdź do wyboru obiektów')
                             
                             
                        )
                        
                       
                ),
                
                tabItem(tabName = "tile_choice_tab",
                        
                        box(
                            DT::dataTableOutput('heritage.selected.df'),
                            actionButton('optimize.button', label = 'Zaproponuj trasę')
                            
                        )

                ),
                
                tabItem(tabName = "map_route_tab",
                        leafletOutput("mapa"),
                        br(),
                        tableOutput('output.table')
                )
            )
        )
        
    )
)