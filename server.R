shinyServer(function(input, output, session) {
    
    
    # Map -----------------------------------------------------------------------------
    # points <- eventReactive(input$recalc, {
    #     cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    # }, ignoreNULL = FALSE)
    
    
    # ---------------------------------------------------------------------------------
    
    # Start location ------------------------------------------------------------------
    start.lat <- reactive({
        if (input$use.my.location.check) {
            input$lat
        } else if (input$start.text != "") {
            geocodeAdddress(input$start.text)[2]
        } else {
            NULL
        }

    })
    
    start.long <- reactive({
        if (input$use.my.location.check) {
            input$long
        } else if (input$start.text != "") {
            geocodeAdddress(input$start.text)[1]
        } else {
            NULL
        }
        
    })
    #observe({ print(start.long()) })
    end.lat <- reactive({
        if (input$finish.where.start.check) {
            input$lat
        } else if (input$set.end.check) {
            geocodeAdddress(input$end.text)[2]
        } else {
            NULL
        }
    })
    
    end.long <- reactive({
        if (input$finish.where.start.check) {
            input$long
        } else if (input$set.end.check) {
            geocodeAdddress(input$end.text)[1]
        } else {
            NULL
        }
    })

    
    # output$lat <- renderPrint({
    #     end.lat()
    # })
    # output$long <- renderPrint({
    #     end.long()
    # })
    # ---------------------------------------------------------------------------------
    
    # Route end input -----------------------------------------------------------------
    output$end.text <- renderUI({
        if (input$set.end.check) {
            textInput('end.text', label = 'Podaj miejsce końca trasy')
        } 
    })
    # ---------------------------------------------------------------------------------
    
    # Go to selection button ----------------------------------------------------------
    observeEvent(input$go.to.selection.button, {
        change.tab <- switch(input$tabs,
                         "start_tab" = "filter_tab"
        )
        updateTabItems(session, "tabs", change.tab)
    })
    # ---------------------------------------------------------------------------------
    
    # Pick objects button -------------------------------------------------------------
    observeEvent(input$pick.objects.button, {
        change.tab <- switch(input$tabs,
                             "filter_tab" = "tile_choice_tab"
        )
        updateTabItems(session, "tabs", change.tab)
    })
    # ---------------------------------------------------------------------------------
    
    # Select objects ------------------------------------------------------------------

    output$heritage.selected.df <- DT::renderDataTable({

        list.working <- rep(FALSE, nrow(heritage.short.df))
        # lapply(1:length(categories.list), function(category) {
        #     if (input[[paste0(categories.list[category], '.check')]] == TRUE) {
        #         list.working[heritage.short.df[, categories.list[category]]] <- TRUE
        #     }
        # })

        if (input$budynek_gospodarczy.check == TRUE) {
            list.working[heritage.short.df$budynek_gospodarczy] <- TRUE
        }
        if (input$cmentarny.check == TRUE) {
            list.working[heritage.short.df$cmentarny] <- TRUE
        }
        if (input$dworski_palacowy_zamek.check == TRUE) {
            list.working[heritage.short.df$dworski_palacowy_zamek] <- TRUE
        }
        if (input$inny.check == TRUE) {
            list.working[heritage.short.df$inny] <- TRUE
        }
        if (input$katolicki.check == TRUE) {
            list.working[heritage.short.df$katolicki] <- TRUE
        }
        if (input$mieszkalny.check == TRUE) {
            list.working[heritage.short.df$mieszkalny] <- TRUE
        }
        if (input$militarny.check == TRUE) {
            list.working[heritage.short.df$militarny] <- TRUE
        }
        if (input$muzulmanski.check == TRUE) {
            list.working[heritage.short.df$muzulmanski] <- TRUE
        }
        if (input$park_ogrod.check == TRUE) {
            list.working[heritage.short.df$park_ogrod] <- TRUE
        }
        if (input$prawoslawny.check == TRUE) {
            list.working[heritage.short.df$prawoslawny] <- TRUE
        }
        if (input$protestancki.check == TRUE) {
            list.working[heritage.short.df$protestancki] <- TRUE
        }
        if (input$przemyslowy_poprzemyslowy.check == TRUE) {
            list.working[heritage.short.df$przemyslowy_poprzemyslowy] <- TRUE
        }
        if (input$sakralny.check == TRUE) {
            list.working[heritage.short.df$sakralny] <- TRUE
        }
        if (input$sportowy_kulturalny_edukacyjny.check == TRUE) {
            list.working[heritage.short.df$sportowy_kulturalny_edukacyjny] <- TRUE
        }
        if (input$uzytecznosci_publicznej.check == TRUE) {
            list.working[heritage.short.df$uzytecznosci_publicznej] <- TRUE
        }
        if (input$zydowski.check == TRUE) {
            list.working[heritage.short.df$zydowski] <- TRUE
        }
        selected.df.raw <<- data.frame(id = heritage.short.df$id[list.working], longitude = heritage.short.df$longitude[list.working], latitude = heritage.short.df$latitude[list.working])
        # DT::datatable(data.frame(Obiekt = heritage.short.df$active_link[list.working]), 
        #           filter = 'top', rownames = FALSE , 
        #           options = list(paging = FALSE, serverSide = FALSE, 
        #                          language = list(info = '(wyświetlono wiersze od  _START_ do _END_ z _MAX_)', search = 'Znajdź', infoFiltered = '')))
        data.frame(Obiekt = heritage.short.df$active_link[list.working])
    }, server = FALSE, escape = FALSE)
    
    selected.df <<- reactive({
        selected.rows <- input$heritage.selected.df_rows_selected
        selected.df.raw[selected.rows, ]
    })
    
    # ---------------------------------------------------------------------------------
    
    # Optimize ------------------------------------------------------------------------
    observeEvent(input$optimize.button, {
        route.df <- RouteOptimizer(selected.df = isolate(selected.df()), start.lon = isolate(start.long()), start.lat = isolate(start.lat()), end.lon = NULL, end.lat = NULL, distances.df = distances.df[, -5])
        
        change.tab <- switch(input$tabs,
                             "tile_choice_tab" = "map_route_tab"
        )
        
        updateTabItems(session, "tabs", change.tab)
        route.plus.df <- data.frame(id = route.df$id, name = NA, order = route.df$order, longitude = NA, latitude = NA, link_wikipedia = NA)
        for (row in 1:nrow(route.df)) {
            if (route.df$id[row] == "-001") {
                route.plus.df$name[row] <- 'Punkt startowy'
                route.plus.df$longitude[row] <- isolate(start.long()) 
                route.plus.df$latitude[row] <- isolate(start.lat()) 
                route.plus.df$link_wikipedia[row] <- ""
                
                distances.df <<- rbind(distances.df, c('-001', route.df$id[row + 1], 0, 0, route.df$path[row]))
                
            } else if (route.df$id[row] == "-007") {
                route.plus.df$name[row] <- 'Punkt docelowy'
                route.plus.df$longitude[row] <- isolate(end.long()) 
                route.plus.df$latitude[row] <- isolate(end.lat()) 
                route.plus.df$link_wikipedia[row] <- ""    
                distances.df <<- rbind(distances.df, c(route.df$id[row - 1], '-007', 0, 0, route.df$path[row]))
            } else {
                row.selection <- which(heritage.short.df$id == route.df$id[row])
                
                route.plus.df$name[row] <- heritage.short.df$name[row.selection]
                route.plus.df$longitude[row] <- heritage.short.df$longitude[row.selection]
                route.plus.df$latitude[row] <- heritage.short.df$latitude[row.selection]
                route.plus.df$link_wikipedia[row] <- heritage.short.df$link[row.selection]    
            }
            
        }
        
        route.plus.df <<- route.plus.df
        output$output.table <- renderTable({
            table.for.output <- route.plus.df[order(route.plus.df$order), ]
            table.for.output <- table.for.output[, c('order','name')]
            table.for.output$order <- as.integer(table.for.output$order)
            colnames(table.for.output) <- c('Lp', 'Nazwa obiektu')
            table.for.output
        })
        output$mapa <- renderLeaflet({
            createMap(distances.df, route.plus.df, vet.df = vet_final)
        }) 
        
    })
    # ---------------------------------------------------------------------------------
    
    # output$x4 = renderPrint({
    #     route.df
    # })
    
    # output$object1 <- renderInfoBox({
    #     infoBox(
    #         "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
    #         color = "purple"
    #     )
    # })
    
    # heritage.selected.df$id <- heritage.short.df$id
    # heritage.selected.df <- reactive({
    #     heritage.selected.df <- data.frame(id = heritage.short.df$id)
    #     heritage.selected.df[selected, ]    
    # })

    # lapply(selected, function(object.id) {
    #     output[[paste0('object.', object.id, '.tile')]] <-  renderInfoBox({
    #             infoBox(
    #                 "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
    #                 color = "purple"
    #             )
    #         })
    # })
})



