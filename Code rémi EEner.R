#Session -> Set working directory

# Packages
library(readxl)
library(ggplot2)
library(dplyr)
library(mFilter)

# Chargement
df <- read_excel("donnees.xlsx", skip = 1)
colnames(df) <- c("date", "conso_MW")
df$date <- as.Date(df$date)

#Conso annuelle de 2023
annee_2023 <- df[format(df$date, "%Y") == "2023", ]
conso_2023 <- sum(annee_2023$conso_MW * 24 / 1e6)
cat("Consommation 2023 :", round(conso_2023, 1), "TWh (sur", nrow(annee_2023), "jours)\n")
# Conversion MW -> TWh/jour (puissance * 24h / 1 000 000)
df$conso_TWh <- df$conso_MW * 24 / 1e6

# Graphique principal : série complète
ggplot(df, aes(x = date, y = conso_TWh)) +
  geom_line(color = "#3266ad", linewidth = 0.3) +
  labs(title = "Consommation quotidienne d'électricité en France",
       subtitle = "Consommation journalière corrigée (TWh/jour) — 2014-2024",
       x = NULL, y = "TWh/jour") +
  theme_minimal()

# Zoom hiver
zoom <- df %>% filter(date >= "2023-01-09", date <= "2023-01-22")

ggplot(zoom, aes(x = date, y = conso_TWh)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  labs(title = "Zoom sur 2 semaines (janvier 2023)",
       subtitle = "Creux le week-end, pics en semaine",
       x = NULL, y = "TWh/jour") +
  theme_minimal()

# Zoom été
zoom_ete <- df[df$date >= "2023-07-03" & df$date <= "2023-07-16", ]

ggplot(zoom_ete, aes(x = date, y = conso_TWh)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  labs(title = "Zoom sur 2 semaines (juillet 2023)",
       subtitle = "Même cycle hebdomadaire, mais à un niveau bien plus bas",
       x = NULL, y = "TWh/jour") +
  theme_minimal()

# Indice de prix de l'électricité ménages France (OCDE/AIE, base 100 = 2020)
trimestres <- seq(as.Date("2014-01-01"), as.Date("2025-10-01"), by = "quarter")
prix <- c(80.36, 80.36, 82.36, 82.36,
          85.70, 85.70, 86.43, 86.43,
          86.63, 86.63, 88.07, 88.07,
          86.83, 86.83, 89.44, 89.44,
          89.60, 89.60, 92.37, 92.37,
          90.27, 90.27, 98.19, 98.19,
          98.29, 98.29, 101.71, 101.71,
          100.58, 100.58, 104.26, 104.33,
          108.43, 108.43, 112.01, 112.01,
          118.22, 118.22, 133.44, 133.44,
          145.85, 145.85, 150.95, 150.95,
          137.78, 137.78, 138.23, 138.23)

plot(trimestres, prix, type = "l", col = "red", lwd = 2,
     xlab = "", ylab = "Indice de prix (base 100 = 2020)",
     main = "Prix de l'électricité pour les ménages en France (OCDE/AIE)",
     xaxt = "n")
axis.Date(1, at = seq(as.Date("2014-01-01"), as.Date("2026-01-01"), by = "year"), format = "%Y")
abline(h = 100, lty = 3, col = "grey50")
text(as.Date("2019-01-01"), 103, "Base 100 = 2020", col = "grey50", cex = 0.8)

# Conversion en TWh/an pour le filtre HP
df$conso_TWh_an <- df$conso_MW * 24 * 365 / 1e6

# Filtre HP (en TWh/an)
conso_ts <- ts(df$conso_TWh_an, frequency = 365)
hp <- hpfilter(conso_ts, freq = 129600)
df$tendance <- as.numeric(hp$trend)

plot(df$date, df$conso_TWh_an, type = "l", col = "grey70",
     xlab = "", ylab = "TWh/an", main = "Filtre de Hodrick-Prescott")
lines(df$date, df$tendance, col = "purple", lwd = 2)

# Extrapolation jusqu'en 2030 (en TWh/an)
df$t <- as.numeric(df$date - min(df$date))
reg <- lm(tendance ~ t, data = df)

date_2030 <- as.numeric(as.Date("2030-12-31") - min(df$date))
prev_2030 <- predict(reg, newdata = data.frame(t = date_2030))

cat("Tendance en 2030 :", round(prev_2030, 1), "TWh/an\n")

# Graphique avec extrapolation jusqu'en 2030
dates_fut <- seq(max(df$date) + 1, as.Date("2030-12-31"), by = "day")
t_fut <- as.numeric(dates_fut - min(df$date))
prev_fut <- predict(reg, newdata = data.frame(t = t_fut))

plot(df$date, df$tendance, type = "l", col = "purple", lwd = 2,
     xlim = c(min(df$date), as.Date("2030-12-31")),
     ylim = c(300, 660),
     xlab = "", ylab = "TWh/an",
     main = "Extrapolation de la tendance HP jusqu'en 2030")
lines(dates_fut, prev_fut, col = "red", lwd = 2, lty = 2)
abline(v = max(df$date), lty = 3, col = "grey50")
legend("topright", legend = c("Tendance HP", "Extrapolation"),
       col = c("purple", "red"), lwd = 2, lty = c(1, 2))