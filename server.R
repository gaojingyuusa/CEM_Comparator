# set up the server file for CEM country selection tool

library(shiny)

# major server function
shinyServer(function(input, output){
  source("CEM_reactive.R", local=T)
  
  ## Output in customization pane
  # Region value box
  output$country.region <- renderText({
    country.region()
  })
  # Income value box
  output$country.income <- renderText({
    country.income()
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
  
  
})