# set up the server file for CEM country selection tool

library(shiny)

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
  
})