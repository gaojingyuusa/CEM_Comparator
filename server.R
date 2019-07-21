# set up the server file for CEM country selection tool

library(shiny)
library(plotly)
# major server function
shinyServer(function(input, output, session){
  source("CEM_reactive.R", local=T)
  
  ## Output in customization pane
  output$country <- renderText({
    country()
  })
  
  output$country.txt <- renderText({
    country()
  })
  
  output$period <- renderText({
    period()
  })
  
  # Region value box
  output$country.region <- renderText({
    country.region()
  })
   # for the information panel in sidebar only
   output$country.region.txt <- renderText({
     country.region.txt()
   })
  # Income value box
  output$country.income <- renderText({
    paste("Income Group:",country.income())
  })
  # Landlocked 
  output$country.land <- renderText({
    country.landlocked()
  })
  # small state 
  output$country.small <- renderText({
    country.small()
  })
  # Landlocked 
  output$country.fcs <- renderText({
    country.fcs()
  })
  
  # Structural break
  output$break_data <- renderTable({
    break_data()
  })
  
  output$break_point <- renderTable({
    break_point()
  })
  
  output$break_plot <-renderPlotly({
    break_data()
    k <- ggplot(break_data(),aes(break_data()[,2],break_data()[,3])) + 
      geom_line(size=1,color="#002244") + labs(title = "Structural Break: GDP Growth", x = "Year") + #theme_minimal() + #x_time() + 
      scale_y_continuous("") + theme(legend.position="none") + theme(panel.background = element_rect(fill='white'))+ geom_vline(xintercept = break_point()[[1]],color="#009FDA")
    ggplotly(k) %>% layout(yaxis=list(titlefont=list(size=8)),xaxis=list(titlefont=list(size=8)),height=200) 
  })

# Structural data table
  output$struc_table <- renderTable({
    struc_data()
  })
    # Match indicator and weight
  output$str_matchind <- renderTable({
    struc_match()
  })
    # Structural rank 
  output$struc_rank <- renderTable({
    struc_ranking()
  })
    # Structural result: full list
  output$struc_result <- renderTable(
    struc_result()
  )
    # Structural result: data of the full list
  output$struc_result_data <- renderTable(
    struc_result_data()
  )
    # Average for target country
  output$ind1 <- renderText(
    ind1()
  )
  output$ind2 <- renderText(
    ind2()
  )
  output$ind3 <- renderText(
    ind3()
  )
  output$ind4 <- renderText(
    ind4()
  )
  output$ind5 <- renderText(
    ind5()
  )
  output$ind6 <- renderText(
    ind6()
  )

# Aspirational data table
  # Aspirational indicator table
  output$aspr_data <- renderTable(
    aspr_data()
  )
  
  # Aspirational indicator ranking
  output$aspr_rank <- renderTable(
    aspr_rank()
  )
  
  # Aspirational indicaotr of target
   # Mean
  output$aspr_target_mean <- renderText(
    aspr_target_mean()
  )
   # Rank
  output$aspr_target_rank <- renderText(
    aspr_target_rank()
  )
  
   # Max
  output$aspr_target_max <- renderText(
    aspr_target_max()
  )
   # Dynamic default value in lower bound of rank and value
    observe({
    updateNumericInput(session, "RANK_L",
                      value=aspr_target_rank()
          )})
    
    observe({
      updateNumericInput(session, "VALUE_L",
                         value=aspr_target_mean()
      )})
    
    observe({
      updateNumericInput(session, "VALUE_U",
                         value=aspr_target_max(),
                         max=aspr_target_max()
      )})
    
    # Aspirational within rank list of countries
    output$aspr_within_rank <- renderTable(
      aspr_within_rank()
    )
    
    # Aspsrational within value list of countries
    output$aspr_within_value <- renderTable(
      aspr_within_value()
    )
    
    # Result list of countries
    output$aspr_result <- renderTable(
      aspr_result()
    )
    
    # Aspirational data table of the result
    output$aspr_result_data <- renderTable(
      aspr_result_data()
    )
  
})