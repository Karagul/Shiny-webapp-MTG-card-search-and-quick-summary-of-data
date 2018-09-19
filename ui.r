#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # Application title + mezera br()
  titlePanel("MTG - Standard format"), br(), 
  
  # Tab panel se záložkami
  tabsetPanel(
    tabPanel("Přehled", br(),
             p(strong("Počet karet v rámci jedné barvy: ")),
             fluidRow(
                column(width = 1,
                       htmlOutput("NMana")),
                column(width = 1, 
                       htmlOutput("ZelenaMana")),
                column(width = 1,
                       htmlOutput("ModraMana")),
                column(width = 1, 
                       htmlOutput("BilaMana")),
                column(width = 1,
                       htmlOutput("CernaMana")),
                column(width = 1,
                       htmlOutput("CervenaMana"))
                # Vypisuje to co je napsané v server.r pod id Zprava
             ),
             fluidRow(
               column(width = 1,
                      textOutput("NPocetKaret")),
               column(width = 1,
                      textOutput("ZelenaPocetKaret")),
               column(width = 1,
                      textOutput("ModraPocetKaret")),
               column(width = 1,
                      textOutput("BilaPocetKaret")),
               column(width = 1,
                      textOutput("CernaPocetKaret")),
               column(width = 1,
                      textOutput("CervenaPocetKaret"))
             ),
             br(), p(strong("Více barevné:")),
             fluidRow(
               column(width = 1,
                      htmlOutput("ViceBarevne1"), htmlOutput("ViceBarevne1_2"), htmlOutput("ViceBarevne1_3")),
               column(width = 1,
                      htmlOutput("ViceBarevne2"), htmlOutput("ViceBarevne2_2")),
               column(width = 1, 
                      htmlOutput("ViceBarevne3"), htmlOutput("ViceBarevne3_2")),
               column(width = 1,
                      htmlOutput("ViceBarevne4"), htmlOutput("ViceBarevne4_2")),
               column(width = 1,
                      htmlOutput("ViceBarevne5"), htmlOutput("ViceBarevne5_2")),
               column(width = 1,
                      htmlOutput("ViceBarevne6"), htmlOutput("ViceBarevne6_2")),
               column(width = 1,
                      htmlOutput("ViceBarevne7"), htmlOutput("ViceBarevne7_2")),
               column(width = 1,
                      htmlOutput("ViceBarevne8"), htmlOutput("ViceBarevne8_2")),
               column(width = 1,
                      htmlOutput("ViceBarevne9"), htmlOutput("ViceBarevne9_2")),
               column(width = 1,
                      htmlOutput("ViceBarevne10"), htmlOutput("ViceBarevne10_2")),
               column(width = 1,
                      htmlOutput("ViceBarevne11"), htmlOutput("ViceBarevne11_2"), htmlOutput("ViceBarevne11_3")),
               column(width = 1,
                      htmlOutput("ViceBarevne12"), htmlOutput("ViceBarevne12_2"))
             ), 
             fluidRow(
               column(width = 1,
                      textOutput("VBManaPocet1")),
               column(width = 1,
                      textOutput("VBManaPocet2")),
               column(width = 1,
                      textOutput("VBManaPocet3")),
               column(width = 1,
                      textOutput("VBManaPocet4")),
               column(width = 1,
                      textOutput("VBManaPocet5")),
               column(width = 1,
                      textOutput("VBManaPocet6")),
               column(width = 1,
                      textOutput("VBManaPocet7")),
               column(width = 1,
                      textOutput("VBManaPocet8")),
               column(width = 1,
                      textOutput("VBManaPocet9")),
               column(width = 1,
                      textOutput("VBManaPocet10")),
               column(width = 1,
                      textOutput("VBManaPocet11")),
               column(width = 1,
                      textOutput("VBManaPocet12"))
             )
    ),
    tabPanel("Můžu hrát svoji kartu?", br(),
      p(strong("Edice, které můžete hrát:")),
      textOutput("Edice"), br(),
      textInput("nazevKarty", "Název vaší karty: ", value = "Abandoned Sarcophagus"), submitButton("Odeslat"), br(), br(),
      p(strong("Obrázek celé karty:")),
      htmlOutput("ObrazekKarta"), br(),
      p(strong("Oracle text (pravidla karty):")),
      textOutput("OracleText"), br(),
      p(strong("Barva:")),
      fluidRow(
        column(width = 1, 
          htmlOutput("KartaBarva")) 
      ), br(),
      p(strong("Cena:")),
      textOutput("KartaCena"), br(),
      p(strong("Typ:")),
      textOutput("KartaTyp"), br()
    )
  )

  
))
