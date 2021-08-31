---
title: "Progetto Multisensory and Data Exploration"
subtitle: "Sonificazione dei pallini :)"
classoption: twocolumn
documentclass: article
author: 
- Cristina Zappata
- Giuseppe Marino
date: 17 Settembre 2021
geometry: margin=2.1cm
output: pdf_document
fontsize: 12pt
toc: false
autoEqnLabels: true
---

# Introduzione

La visualizzazione è un aspetto fondamentale quando si vogliono presentare ad un pubblico dei dati al fine di comunicare delle relazioni complesse in modo semplice. Hans Rosling fu un pioniere della data visualization, nelle sue presentazioni era solito usare delle rappresentazioni animate per mostrare l'andamento della qualità della vita, nei Paesi del mondo, nel tempo. Nel fare ciò era solito utilizzare degli bubble plot animati. 

In uno bubble plot si visualizza una collezione di dati utilizzando un piano cartesiano, in questo vengono collocati dei punti, per ciascuno di essi, la posizione sull'asse orizzontale è determinata da una variabile, e la posizione sull'asse verticale è determinata da un'altra. Si possono rappresentare altre variabili impiegando altre dimensioni, come il colore o la taglia dei punti. Per rappresentare le variabili in funzione del tempo risulta pratico impiegare degli bubble plot animati, dove frame dopo frame si mostra la progressione dei dati al variare del tempo.

Queste visualizzazioni sono intrinsecamente molto efficaci comunicare le informazioni espresse nei dati, anche se sono pensate per contribuire ad una visione di insieme, infatti può risultare difficile seguire un singolo punto nel suo spostarsi nello spazio, a meno di non introdurre un highlight di qualche tipo. In questo progetto abbiamo investigato i possibili vantaggi provenienti dall'impiego del suono per evidenziare un punto nel plot.

Abbiamo realizzato una visualizzazione sintetica di uno bubble plot animato, i dettagli verranno discussi successivamente. Abbiamo svolto degli esperimenti con dei soggetti, al fine di valutare gli effetti del highlight sonoro da noi realizzato.





# Setup sperimentale

La visualizzazione sintetica è stata realizzata usando Processing. La scena consiste di 22 punti di dimensione variabile che si muovono all'interno di uno spazio quadrato, i punti differiscono tra di loro anche in base al colore, infatti abbiamo campionato dei valori equamente distanti dalla mappa di colore Viridis. Ad ogni punto corrisponde un distinto colore della colormap, però il numero di punti, e di conseguenza di campioni, è stato scelto in modo da rendere non immediata l'individuazione dei punti nel plot. 

Al plot è associata una leggenda, in questa è resa nota la corrispondenza tra le etichette e il colore dei punti. Questo proprio per simulare quanto accade negli bubble plot. Le etichette sono dei semplici numeri. La leggenda consiste di colori associati a numeri, entrambi incrementali. 

Ad un singolo partecipante viene chiesto di eseguire una serie di tentativi, ogni tentativo consiste in una scena diversa, e il task è quello di individuare il punto nel plot corrispondente ad un valore della leggenda, il partecipante è informato del punto da ricercare grazie ad un ad un messaggio. 

Una volta individuato il punto target, viene chiesto ai partecipanti di cliccarlo con mouse. Le diverse scene possono differire per il livello di sonification, infatti una scena può presentare o meno l'highlight sonoro del target. 

Abbiamo deciso in un primo momento di effettuare la sonificazione del modulo della velocità con cui si muove il terget. Il suono è generato a partire da un accordo, dove il pitch è mappato sulla velocità del target. Ad un punto fermo corrisponde un accordo di Do maggiore, con fondamentale a 32.7 Hz, all'aumentare della velocità sale il pitch. Per una velocità ricaviamo un offset, questo è usato infine come coefficiente da moltiplicare alle frequenze di base dell'accordo dell'accordo. La mappatura è fatta in modo da spaziare all'interno di un'ottava, questa scelta è stata fatta empiricamente, cercando un compromesso tra rappresentatività del suono e fastidio. 

Il suono è realizzato impiegando degli oscillatori sinusoidali, ai quali abbiamo aggiunto un leggero pink noise di fondo per garantire una gamma di frequenze abbastanza vasta, questo ci è abbastanza utile per apprezzare le variazioni in brillantezza del suono. Infatti il suono prodotto è filtrato con un filtro passa basso, la cui frequenza di taglio è ricavata sempre dalla velocità del target: ad una bassa velocità corrisponde un suono grave e poco brillante, ad un'alta velocità corrisponde un suono più brillante. Questa sintesi sonora prende spunto da quanto fatto da Niklas Rönnberg [1].

La sonification così descritta costituisce un livello del fattore sonification, partendo da questa ne abbiamo realizzata un'altra che chiamiamo *bump*, in questo caso la velocità è sonificata esattamente come prima, ma viene riprodotto un leggero suono di "bump" in caso di variazioni drastiche della traiettoria del punto.

Il moto di ciascun punto è casuale, ma impostato in modo che in un intervallo di tempo circoscritto ricalchi un movimento plausibile per un elemento in uno bubble plot animato. I punti sono trattenuti all'interno del box, in caso di avvicinamento e contatto con i bordi la traiettoria è deviata per mantenere i punti entro i limiti. A queste variazioni di direzione non corrisponde un bump in quanto si tratta di variazioni artificiali che non si presentano negli bubbleplot, la loro sonificazione potrebbe risultare fuorviante.

La scelta della scala Viridis è stata dettata principalmente dalla sua robustezza e popolarità, discretizzata su un numero di livelli superiore a quello che normalmente consente una distinzione chiara anche su dei glifi piccoli. Abbiamo determinato il numero dei punti  rappresentati con dei test pilota, in modo tale da coinvolgere un numero di livelli sufficiente ad introdurre una certa confusione tra i colori, pur permettendo la discriminazione dell'obiettivo confrontando i soli colori.

Quindi, i livelli della variabile highlight sonoro sono:
+ nessuna sonification (n), 
+ sonification della velocità (s),
+ sonification della velocità e dei cambi di direzione drastici (b). 

Ogni partecipante esegue lo stesso numero di tentativi per ciascun livello, anche se il loro ordine è casuale. Quest'aspetto è fondamentale per compensare gli effetti d'ordine. Inoltre bisogna considerare l'apprendimento, infatti è molto probabile che i partecipanti facciano sensibilmente peggio nei primi tentativi, per circoscrivere gli effetti del learning i partecipanti effettuano una sessione di allenamento preliminare, concretamente i primi XX tentativi comprendono uno stesso numero di trial per ciascuna modalità, sempre somministrati in ordine random, ma vengono esclusi dalla raccolta dei dati.




# Metodologia 

Amet labore ea consectetur labore enim commodo. Consequat exercitation adipisicing ut nisi cillum minim ad est qui amet labore. Officia irure cillum eiusmod Lorem aliqua incididunt amet. Ut elit ipsum excepteur non dolor sint laborum dolore excepteur proident ipsum incididunt cupidatat duis. Cupidatat proident veniam proident ex officia in do cillum minim. Qui amet esse culpa excepteur occaecat deserunt esse consequat tempor cupidatat eu.

## Rappresentazione visuale
Commodo veniam sunt aliqua quis dolor et elit culpa pariatur quis. Irure ea exercitation do deserunt ullamco duis exercitation magna ea reprehenderit. Irure est minim id amet ex do ad sint culpa esse cupidatat. Nostrud proident magna ullamco enim ad quis laboris. Anim tempor nisi et reprehenderit cupidatat.

## Sonification

Magna in pariatur incididunt aliquip consequat aute incididunt. Do minim magna minim excepteur. Id aliqua est sint nisi amet adipisicing ullamco sit occaecat Lorem sint dolor minim voluptate.

## Partecipanti 

Anim proident aute incididunt nulla cupidatat excepteur deserunt tempor amet consequat voluptate laborum. Ea irure dolore occaecat magna amet reprehenderit veniam aliqua ipsum cillum id Lorem pariatur. Excepteur in deserunt est quis veniam qui sint ea fugiat ad voluptate. Aliqua exercitation nulla et reprehenderit. Consectetur sunt quis id elit non incididunt culpa amet reprehenderit id officia nisi dolor duis. Ipsum duis dolor eiusmod ut sit minim minim. Occaecat reprehenderit sint et ex ipsum enim cillum ea irure.

## Setup

Laboris ex sint fugiat exercitation reprehenderit reprehenderit sunt dolor. Amet laborum pariatur aliqua sit non excepteur veniam elit. Pariatur elit ex duis aliqua commodo magna eu qui in qui ullamco.

# Risultati 

Reprehenderit minim amet esse commodo tempor et aliquip et sit. Veniam nostrud dolore sint cillum eiusmod exercitation consequat mollit culpa velit occaecat laborum qui. Proident elit ea veniam tempor elit minim anim non dolor eiusmod excepteur dolore adipisicing. Velit consectetur deserunt nulla dolor do consectetur irure incididunt commodo aliqua esse cillum. Laborum qui aliqua pariatur dolor et minim id cillum incididunt aliquip.

# Considerazioni

Duis exercitation nostrud tempor nisi magna consectetur anim. Pariatur fugiat voluptate consectetur ea eu dolor excepteur. Voluptate tempor aliquip reprehenderit non minim laborum Lorem ad est irure qui consequat esse. Velit aliquip exercitation amet ex. Officia veniam ullamco labore quis culpa adipisicing minim in veniam magna ullamco no.

# Fonti 