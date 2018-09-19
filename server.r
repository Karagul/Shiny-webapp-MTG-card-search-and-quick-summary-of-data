#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


vypisManaPocet <- function(nazevZnak, tabulka) {
  return(paste0(tabulka$Pocet[which(is.element(tabulka$Barvy, nazevZnak))]))
}

vypisManaPocetVIceBarevne <- function(tabulka, typ) {
  viceBarevneBarvy <- tabulka$Barvy[which(!(is.element(tabulka$Barvy, "R") | is.element(tabulka$Barvy, "G") | is.element(tabulka$Barvy, "W") | is.element(tabulka$Barvy, "U") | is.element(tabulka$Barvy, "B") | is.element(tabulka$Barvy, "N")))]
  viceBarevnePocet <- tabulka$Pocet[which(is.element(tabulka$Barvy, viceBarevneBarvy))]
  return(paste0(viceBarevnePocet[typ]))
}

vypisEdice <- function(edice) {
  i = 1
  vypis <- paste(' ')
  while (i <= length(edice$edice)) {
    if (i == length(edice$edice)) {
      vypis <-paste0(vypis, toString(edice$edice[i]))
      break
    }
    vypis <-paste0(vypis, toString(edice$edice[i]), ", ")
    i = i + 1
  }
  return(vypis)  
}

vypisKartu <- function(nazev, tabulkaKaret, typ) {
  nazev <- toString(nazev)
  nazev <- tolower(trimws(nazev))
  nazev <- gsub("\\s", "", nazev)
  i <- agrep(nazev,tolower(gsub("\\s", "", tabulkaKaret$jmenaKaret)))[1]
  if (typ == 1) {
    karta <- tabulkaKaret$obrazkyKaret[i]
  } else if (typ == 2) {
    karta <- tabulkaKaret$oracleText[i]
  } else if (typ == 3) {
    karta <- tabulkaKaret$kartaBarva[i]
    if (nchar(as.character(karta)) > 1) {
      return(zkontrolujViceBarevne(karta))
    }
    karta <-  zkontrolujBarvu(karta)
  } else if (typ == 4) {
    karta <- tabulkaKaret$kartaCena[i]
  } else if (typ == 5) {
    karta <- tabulkaKaret$kartaTyp[i]
  }
  return(as.character(karta))
}

zkontrolujBarvu <- function(barva) {
  if (as.character(barva) == "0") {
    barva <- "N"
  } 
  if (barva == "R") {
    nazev <- "red_mana.png"
  } else if (barva == "U") {
    nazev <- "blue_mana.png"
  } else if (barva == "B") {
    nazev <- "black_mana.png"
  } else if (barva == "W") {
    nazev <- "white_mana.png"
  } else if (barva == "G") {
    nazev <- "green_mana.png"
  } else if (barva == "N") {
    nazev <- "C.svg"
  } 
  return(nazev)
}

zkontrolujViceBarevne <- function(barvy) {
  barvy <- gsub("[\"c(),harter]", "", barvy)
  barvy <- gsub("\\s", "", barvy)
  i = 1
  seznamBarev = list()
  while (i <= nchar(barvy)) {
    barva <- substr(barvy, i, i)
    seznamBarev <- c(seznamBarev, zkontrolujBarvu(as.character(barva)))
    i = i + 1
  }
  return(seznamBarev)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  tabulka <- read.csv("tab.csv")
  nazvyEdic <- read.csv(file = "edice.csv")
  tabulkaKaret <- read.csv(file = "jmena_karet.csv")
  output$NMana <- renderUI(
    img(src = "C.svg", alt = "nonColor_mana", width = "50%")
  )
  output$ZelenaMana <- renderUI(
    img(src = "green_mana.png", alt = "green_mana", width = "50%")
  )
  output$ModraMana <- renderUI(
    img(src = "blue_mana.png", alt = "blue_mana", width = "50%")
  )
  output$BilaMana <- renderUI(
    img(src = "white_mana.png", alt = "white_mana", width = "50%")
  )
  output$CernaMana <- renderUI(
    img(src = "black_mana.png", alt = "black_mana", width = "50%")
  )
  output$CervenaMana <- renderUI(
    img(src = "red_mana.png", alt = "cervena_mana", width = "50%")
  )
  
  # rendruje text a posíla to ui.r pod id Zprava
  output$NPocetKaret <- renderText(
    return(vypisManaPocet("N", tabulka))
  )
  output$ZelenaPocetKaret <- renderText(
    return(vypisManaPocet("G", tabulka))
  )
  output$ModraPocetKaret <- renderText(
    return(vypisManaPocet("U", tabulka))
  )
  output$BilaPocetKaret <- renderText(
    return(vypisManaPocet("W", tabulka))
  )
  output$CernaPocetKaret <- renderText(
    return(vypisManaPocet("B", tabulka))
  )
  output$CervenaPocetKaret <- renderText(
    return(vypisManaPocet("R", tabulka))
  )
  
  # Green, Red, White
  output$ViceBarevne1 <- renderUI (
    img(src = "green_mana.png", alt = "black_mana", width = "50%")
  )
  output$ViceBarevne1_2 <- renderUI (
    img(src = "red_mana.png", alt = "red_mana", width = "50%")
  )
  output$ViceBarevne1_3 <- renderUI (
    img(src = "white_mana.png", alt = "blue_mana", width = "50%")
  )
  
  # Green, White
  output$ViceBarevne2 <- renderUI (
    img(src = "green_mana.png", alt = "green_mana", width = "50%")
  )
  output$ViceBarevne2_2 <- renderUI (
    img(src = "white_mana.png", alt = "white_mana", width = "50%")
  )
  
  # Black, Red
  output$ViceBarevne3 <- renderUI (
    img(src = "black_mana.png", alt = "red_mana", width = "50%")
  )
  output$ViceBarevne3_2 <- renderUI (
    img(src = "red_mana.png", alt = "black_mana", width = "50%")
  )
  
  # Blue, White
  output$ViceBarevne4 <- renderUI (
    img(src = "blue_mana.png", alt = "blue_mana", width = "50%")
  )
  output$ViceBarevne4_2 <- renderUI (
    img(src = "white_mana.png", alt = "white_mana", width = "50%")
  )
  
  # Green, Blue
  output$ViceBarevne5 <- renderUI (
    img(src = "green_mana.png", alt = "green_mana", width = "50%")
  )
  output$ViceBarevne5_2 <- renderUI (
    img(src = "blue_mana.png", alt = "blue_mana", width = "50%")
  )
  
  # Red, Blue
  output$ViceBarevne6 <- renderUI (
    img(src = "red_mana.png", alt = "red_mana", width = "50%")
  )
  output$ViceBarevne6_2 <- renderUI (
    img(src = "blue_mana.png", alt = "blue_mana", width = "50%")
  )
  
  # Black, Green
  output$ViceBarevne7 <- renderUI (
    img(src = "black_mana.png", alt = "black_mana", width = "50%")
  )
  output$ViceBarevne7_2 <- renderUI (
    img(src = "green_mana.png", alt = "green_mana", width = "50%")
  )
  
  # Black, White
  output$ViceBarevne8 <- renderUI (
    img(src = "black_mana.png", alt = "black_mana", width = "50%")
  )
  output$ViceBarevne8_2 <- renderUI (
    img(src = "white_mana.png", alt = "white_mana", width = "50%")
  )
  
  # Black, Blue
  output$ViceBarevne9 <- renderUI (
    img(src = "black_mana.png", alt = "black_mana", width = "50%")
  )
  output$ViceBarevne9_2 <- renderUI (
    img(src = "blue_mana.png", alt = "blue_mana", width = "50%")
  )
  
  # Red, White
  output$ViceBarevne10 <- renderUI (
    img(src = "red_mana.png", alt = "red_mana", width = "50%")
  )
  output$ViceBarevne10_2 <- renderUI (
    img(src = "white_mana.png", alt = "white_mana", width = "50%")
  )
  
  
  output$ViceBarevne11 <- renderUI (
    img(src = "black_mana.png", alt = "black_mana", width = "50%")
  )
  output$ViceBarevne11_2 <- renderUI (
    img(src = "red_mana.png", alt = "red_mana", width = "50%")
  )
  output$ViceBarevne11_3 <- renderUI (
    img(src = "white_mana.png", alt = "white_mana", width = "50%")
  )
  
  # Green, Red
  output$ViceBarevne12 <- renderUI (
    img(src = "green_mana.png", alt = "green_mana", width = "50%")
  )
  output$ViceBarevne12_2 <- renderUI (
    img(src = "red_mana.png", alt = "red_mana", width = "50%")
  )
  
  output$VBManaPocet1 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 1))
  )
  output$VBManaPocet2 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 2))
  )
  output$VBManaPocet3 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 3))
  )
  output$VBManaPocet4 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 4))
  )
  output$VBManaPocet5 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 5))
  )
  output$VBManaPocet6 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 6))
  )
  output$VBManaPocet7 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 7))
  )
  output$VBManaPocet8 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 8))
  )
  output$VBManaPocet9 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 9))
  )
  output$VBManaPocet10 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 10))
  )
  output$VBManaPocet11 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 11))
  )
  output$VBManaPocet12 <- renderText (
    return(vypisManaPocetVIceBarevne(tabulka, 12))
  )
  
  
  # Záložka, která řekne jestli můžeš hrát kartu
  output$Edice <- renderText (
    return(vypisEdice(nazvyEdic))
  )
  output$ObrazekKarta <- renderUI (
    return(img(src = vypisKartu(input$nazevKarty, tabulkaKaret, 1), width = "15%"))
  )
  output$OracleText <- renderText (
    return(vypisKartu(input$nazevKarty, tabulkaKaret, 2))
  )
  output$KartaBarva <- renderUI (
    HTML(paste0("<div>", paste(paste0("<img src = '", vypisKartu(input$nazevKarty, tabulkaKaret, 3), "' width='20%'/>"), collapse = " "), "</div>" ))
  )
  output$KartaCena <- renderText (
    return(vypisKartu(input$nazevKarty, tabulkaKaret, 4))
  )
  output$KartaTyp <- renderText (
    return(vypisKartu(input$nazevKarty, tabulkaKaret, 5))
  )
})

