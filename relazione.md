---
title: "Sonificazione dei pallini :)"
subtitle: Progetto Multisensory and Data Exploration \vspace{0.5cm}
author: 
- Cristina Zappata
- Giuseppe Marino
date: 17 Settembre 2021 \vspace{1cm}
header-includes: |
  \setlength{\columnsep}{1cm}
classoption: twocolumn
documentclass: article
geometry: margin=1.5cm
output: pdf_document
fontsize: 12pt
toc: false
autoEqnLabels: true
numbersections: true
---


# Introduzione

La visualizzazione è un aspetto fondamentale quando si vogliono presentare ad un pubblico dei dati al fine di comunicare delle relazioni complesse in modo semplice. Hans Rosling fu un pioniere della data visualization, nelle sue presentazioni era solito usare delle rappresentazioni animate per mostrare l'andamento della qualità della vita, nei Paesi del mondo, nel tempo. Nel fare ciò era solito utilizzare degli bubble plot animati. 

In uno bubble plot si visualizza una collezione di dati utilizzando un piano cartesiano, in questo vengono collocati dei punti, per ciascuno di essi, la posizione sull'asse orizzontale è determinata da una variabile, e la posizione sull'asse verticale è determinata da un'altra. Si possono rappresentare altre variabili impiegando altre dimensioni, come il colore o la taglia dei punti. Per rappresentare le variabili in funzione del tempo risulta pratico impiegare degli bubble plot animati, dove frame dopo frame si mostra la progressione dei dati al variare del tempo.

Queste visualizzazioni sono intrinsecamente molto efficaci comunicare le informazioni espresse nei dati, anche se sono pensate per contribuire ad una visione di insieme, infatti può risultare difficile seguire un singolo punto nel suo spostarsi nello spazio, a meno di non introdurre un highlight di qualche tipo. 

In questo progetto abbiamo investigato i possibili vantaggi provenienti dall'impiego del suono per evidenziare un punto nel plot. Abbiamo ipotizzato che la sonificazione possa aiutare ad individuare e seguire un punto di riferimento nella rappresentazione visuale.

# Metodo

Per trattare questa ipotesi abbiamo realizzato una simulazione di un bubble plot animato, con la possibilità di riprodurre un highlight sonoro, in Processing. I dettagli implementativi verranno discussi in seguito. Le scene realizzate con questa simulazione sono state impiegate per svolgere degli esperimenti con dei soggetti, al fine di valutare gli effetti della sonification.

## Rappresentazione visuale

Per ciascuna scena simulata sono stati generati dei punti che si muovono all'interno di un'area quadrata. La dimensione di un punto è generata in modo casuale all'interno di un intervallo di valori, mentre il colore è ricavato dalla dalla mappa di colore Viridis. Ogni punto ha un colore unico preso tra i campioni della mappa di colore, ricavati selezionando dei valori ad intervalli equamente distanti. 

![Esempio di una scena](res/scena.png)

La scelta della scala Viridis è stata dettata principalmente dalle sue caratteristiche: robustezza, uniformità e popolarità. Il numero dei punti, e di conseguenza dei campioni, è stato scelto in modo da rendere non immediata l'individuazione dei punti nel plot. Infatti abbiamo impiegato un numero di campioni superiore a quello che normalmente consente una distinzione chiara anche su dei glifi piccoli, così facendo abbiamo coinvolto un numero di livelli sufficiente ad introdurre una certa confusione tra i colori, pur permettendo la discriminazione dell'obiettivo confrontando i soli colori. Dopo un certo numero di prove preliminari abbiamo individuato in 22 punti un buon compromesso.

Per simulare quanto accade nei bubble plot, abbiamo affiancato all'area quadrata una leggenda. In questa è resa nota la corrispondenza per ogni punto tra la sua etichetta ed il suo colore. Le etichette consistono di semplici numeri incrementali che partono da zero, mentre i colori corrispondono alla sequenza dei campioni ricavati dalla mappa di colore.

Per ogni scena è estratto in maniera random un punto che funge da target, ovvero il punto sul quale vorremmo che sia rivolta l'attenzione. Esso è reso noto tramite un'istruzione posta sotto la leggenda.

## Sonification

Trattandosi di un bubble plot animato, la scelta sulla proprietà da sonificare è ricaduta sulla la velocità del target: il suono è generato a partire da un accordo (ad un punto fermo corrisponde un accordo di Do maggiore, con fondamentale a 32.7 Hz), dove il pitch sale al crescere della velocità del target. Per una data velocità ricaviamo un offset, che è usato come coefficiente da moltiplicare alle frequenze di base dell'accordo, la mappatura è fatta in modo da spaziare all'interno di un'ottava, questa scelta è stata fatta in seguito a delle prove preliminari, cercando una buona rappresentatività del suono. 

Il suono è sintetizzato impiegando degli oscillatori sinusoidali, il segnale risultante è filtrato con un filtro passa basso, la cui frequenza di taglio è ricavata sempre dalla velocità del target: ad una bassa velocità corrisponde un suono poco brillante, ad un'alta velocità corrisponde un suono più brillante. Agli oscillatori abbiamo aggiunto un leggero pink noise di fondo per garantire una gamma di frequenze abbastanza vasta, per apprezzare bene le variazioni in brillantezza del suono. Questa sintesi sonora prende spunto da quanto fatto da Niklas Rönnberg [1].

Abbiamo anche realizzato una variazione di questa sonificazione, che funziona esattamente come prima per quanto riguarda la velocità, ma che introduce un leggero suono di "bump" in caso di variazioni drastiche della traiettoria del punto.

## Movimento

Il moto di ciascun punto è casuale, ma strutturato in modo che in un intervallo di tempo circoscritto ricalchi un movimento plausibile per un elemento in un bubble plot animato. I punti sono trattenuti all'interno del box, in caso di avvicinamento e contatto con i bordi la traiettoria è deviata per mantenere i punti entro i limiti. A queste variazioni di direzione non corrisponde un bump in quanto si tratta di variazioni artificiali che non si presentano nei bubble plot, la loro sonificazione potrebbe risultare fuorviante.


## Esperimenti

La sonification così descritta costituisce un livello del fattore sonification, partendo

Quindi, i livelli della variabile highlight sonoro sono:

+ nessuna sonification (n), 
+ sonification della velocità (s),
+ sonification della velocità e dei cambi di direzione drastici (b). 

Ogni partecipante esegue lo stesso numero di tentativi per ciascun livello, anche se il loro ordine è casuale. Quest'aspetto è fondamentale per compensare gli effetti d'ordine. Inoltre bisogna considerare l'apprendimento, infatti è molto probabile che i partecipanti facciano sensibilmente peggio nei primi tentativi, per circoscrivere gli effetti del learning i partecipanti effettuano una sessione di allenamento preliminare, concretamente i primi XX tentativi comprendono uno stesso numero di trial per ciascuna modalità, sempre somministrati in ordine random, ma vengono esclusi dalla raccolta dei dati.






## Partecipanti 

Anim proident aute incididunt nulla cupidatat excepteur deserunt tempor amet consequat voluptate laborum. Ea irure dolore occaecat magna amet reprehenderit veniam aliqua ipsum cillum id Lorem pariatur. Excepteur in deserunt est quis veniam qui sint ea fugiat ad voluptate. Aliqua exercitation nulla et reprehenderit. Consectetur sunt quis id elit non incididunt culpa amet reprehenderit id officia nisi dolor duis. Ipsum duis dolor eiusmod ut sit minim minim. Occaecat reprehenderit sint et ex ipsum enim cillum ea irure.

## Setup

Ad un singolo partecipante viene chiesto di eseguire una serie di tentativi, ogni tentativo consiste in una scena diversa, e il task è quello di individuare il punto nel plot corrispondente ad un valore della leggenda, il partecipante è informato del punto da ricercare grazie ad un ad un messaggio. 

Una volta individuato il punto target, viene chiesto ai partecipanti di cliccarlo con mouse. Le diverse scene possono differire per il livello di sonification, infatti una scena può presentare o meno l'highlight sonoro del target. 

# Risultati 

Reprehenderit minim amet esse commodo tempor et aliquip et sit. Veniam nostrud dolore sint cillum eiusmod exercitation consequat mollit culpa velit occaecat laborum qui. Proident elit ea veniam tempor elit minim anim non dolor eiusmod excepteur dolore adipisicing. Velit consectetur deserunt nulla dolor do consectetur irure incididunt commodo aliqua esse cillum. Laborum qui aliqua pariatur dolor et minim id cillum incididunt aliquip.

# Considerazioni

Duis exercitation nostrud tempor nisi magna consectetur anim. Pariatur fugiat voluptate consectetur ea eu dolor excepteur. Voluptate tempor aliquip reprehenderit non minim laborum Lorem ad est irure qui consequat esse. Velit aliquip exercitation amet ex. Officia veniam ullamco labore quis culpa adipisicing minim in veniam magna ullamco no.

# Fonti 