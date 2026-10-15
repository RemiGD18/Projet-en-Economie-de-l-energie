# Consommation d'électricité en France : tendances, extrapolation et objectifs de la PPE-3

Dossier d'économie de l'énergie Master 1 EEET, Université Paris-Saclay, 2025-2026.
Projet réalisé avec Lorena Girodet et Aurélien Weng.

## Objectif
Analyser l'évolution de la consommation d'électricité en France sur 2014-2024, projeter sa tendance jusqu'en 2030 et la confronter aux objectifs de la 3e Programmation pluriannuelle de l'énergie (PPE-3). Selon les consignes du professeur Frédéric Lantz.

## Données
- Consommation quotidienne corrigée d'électricité, France métropolitaine (ODRÉ / RTE)
- Indice des prix de l'électricité pour les ménages (OCDE/AIE, trimestriel 2014-2025)
- Bilan énergétique de la France (SDES)

## Méthode
- Analyse graphique : saisonnalité, cycle hebdomadaire, effet des prix
- Filtre de Hodrick-Prescott (λ = 129 600) pour extraire la tendance de fond
- Extrapolation linéaire de la tendance jusqu'en 2030
- Chiffrage des leviers d'électrification de la PPE-3 (pompes à chaleur, chauffe-eau thermodynamiques, véhicules électriques)

## Principaux résultats
- Baisse structurelle de la consommation depuis 2014, accentuée par la hausse des prix après 2022
- Tendance extrapolée à environ 410 TWh en 2030, soit environ 164 TWh pour les ménages, contre environ 204 TWh dans le scénario de la PPE-3
- Écart d'environ 40 TWh, dont 31 TWh (environ 75 %) peuvent être couverts par les leviers chiffrés, à condition d'un rythme de déploiement bien supérieur au rythme actuel

## Contenu du dépôt
- `[nom_du_fichier].pdf` : dossier complet
- `[nom_du_fichier].R` : script R (traitement des données, graphiques, filtre HP et extrapolation)

## Outils
R (`ggplot2`, `mFilter`)
