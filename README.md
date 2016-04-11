# 

Le patch pure data colorDetect.pd détermine la position du robot cleaner en fonction d'une pastille couleur peinte sur lui.
On récupère ses coordonnées X Y dans l'espace et on les envoie via osc dans le sketch processing parti.pde.

Dans le sketch parti.pde on récupére le X et le Y et on le compare aux coordonnées des étoiles.

Lorsque que les deux corresponent on réduit la luminosité de l'étoile jusqu'à son exctinction.

On procède comme ça par zone d'étoiles en se déplaçant dans ces zones.
