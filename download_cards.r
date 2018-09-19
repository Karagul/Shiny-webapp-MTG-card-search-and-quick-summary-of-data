library(jsonlite)
library(dplyr)
library(ggplot2)
library(stringr)

# https://api.scryfall.com/cards/search?q=c:bw - c:bw najdi karty černé a bílé 


# Hledám všechny karty, které jde hrát ve formátu standard
# url pro hledání karet
url <- "https://api.scryfall.com/cards/search?as=&order=&q=f%3Astandard"

dataMTG <- fromJSON(url, flatten = TRUE)
typeof(dataMTG)

# Uložím si so proměnné True nebo False, ta mi říka jestli je v dataMTG$next_page odkaz na další dávku dat
zastav <- dataMTG$has_more
typeof(zastav)
zastav

# vypíšu si tabulku první dávky a jména sloupců 
tabulka <- dataMTG[["data"]]
names(tabulka)

# Uložím je do sbírky
dataSbirka <- dataMTG


# Pokud zastavit je pravda načti novou dávku z nové strany
while (zastav == T) {
  dataMTG <- fromJSON(dataMTG$next_page, flatten = TRUE)
  zastav <- dataMTG$has_more
  dataSbirka <- c(dataSbirka, dataMTG)
  davka <- dataMTG[["data"]]
  tabulka <- bind_rows(tabulka, davka)
# V dokumentaci mají myslím napsáno, ať dotazy posíláme po nějakém čase.
  Sys.sleep(0.05)
}

# Kolik potřebuju peněz, abych si koupil všechny karty
paste0("Aby sis koupil/a všechny karty potřebuješ asi: ", sum(as.numeric(tabulka$eur), na.rm = T) * 21, " Kč")
paste0("Nejdražší karta je: ", select(filter(tabulka, tabulka$eur == max(as.numeric(tabulka$eur), na.rm = T)), one_of("name"))," a stojí asi: ", max(as.numeric(tabulka$eur), na.rm = T) * 21, " Kč")
# Sety, které jsou povolené ve formátu standard
paste0("Sety, které můžete hrát: ", unique(tabulka$set_name))


# Všechny možné kombinace barev, které jsou ve formátu standard
paletaBarev <- unique(tabulka$color_identity)
paletaBarev[5]
length(paletaBarev[[5]])
paletaBarev[[5]][3]
# Bezbarevných počet
bezBarvyPocet <- as.numeric(count(filter(tabulka, tabulka$color_identity == as.character(paletaBarev[2]))))

# počet karet s určitými barvami
i = 1
barvy = 1
while (i <= 19) {
    Pocet <- as.numeric(count(filter(tabulka, tabulka$color_identity == as.character(paletaBarev[i] ))))
    barvy[i] <- Pocet
    i = i + 1
}
i
barvy <- barvy[1:18]

# Zapsání do tabulky
Pocet <- barvy
Barvy <-  as.character(paletaBarev)
tabulkaBarev <- data_frame(Barvy, Pocet)
tabulkaBarev$Barvy[1] <- "N"
write.csv(tabulkaBarev, file = "tab.csv", row.names = FALSE)
tab <- read.csv("tab.csv")
idViceBarev <- tab$Barvy[which(!(is.element(tab$Barvy, "R") | is.element(tab$Barvy, "G") | is.element(tab$Barvy, "W") | is.element(tab$Barvy, "U") | is.element(tab$Barvy, "B") | is.element(tab$Barvy, "N")))]
length(idViceBarev)
idViceBarev

# Seznam karet
jmenaKaret <- tabulka$name
obrazkyKaret <-tabulka$image_uris.normal
oracleText <- tabulka$oracle_text
kartaBarva <- as.character(tabulka$color_identity)
kartaCena <- tabulka$mana_cost
kartaTyp <- tabulka$type_line
jmenaKaret <- data_frame(jmenaKaret, obrazkyKaret, oracleText, kartaBarva, kartaCena, kartaTyp)
write.csv(jmenaKaret, file = "jmena_karet.csv", row.names = FALSE)

# Seznam edicí
edice <- unique(tabulka$set_name)
edice <- data_frame(edice)
write.csv(edice, file = "edice.csv", row.names = FALSE)
jmena <- read.csv(file = "jmena_karet.csv")
obrazek <- jmena$kartaBarva[1]
barva <- gsub("[\"c(),harter]", "", obrazek)
barva <- gsub("\\s", "", barva)
barva
nchar(barva)
barva <- substr(barva, 1, 1)
barva
