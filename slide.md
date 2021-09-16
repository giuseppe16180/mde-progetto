---
title:  Highlight sonoro in bubble plot animati
subtitle: Progetto Multisensory Data Exploration 
numbersections: true
author: 
- Cristina Zappata
- Giuseppe Marino
date: 17 Settembre 2021
output: pdf_document
fontsize: 11pt
autoEqnLabels: False.
aspectratio: 32
theme: Rochester
colortheme: "seagull"
fonttheme: "serif"
top-level-division: part
\linestrech: 2
md_extensions: +grid_tables
header-includes: |
    \usepackage{amssymb, amsmath, tikz-cd}
---

# Introduzione

La **visualizzazione** è fondamentale per presentare dati: permette di comunicare relazioni **complesse** in modo **semplice**. 

\vspace{-2pt}

**Hans Rosling** fu un pioniere della data visualization, sono famosi i suoi **bubble plot animati**.

\vspace{12pt}


## **Bubble plot animati**

I dati sono rappresentati da punti:

\vspace{4pt}

+ dimensione e colore sono variabili,
+ sono disposti su un piano cartesiano,
+ evolvono nel tempo. 

\vspace{6pt}

Essi rappresentano le variabili di un'osservazione.

# Bubble plot animati

I bubble plot animati sono quindi delle rappresentazioni che:

\vspace{-6pt}

+ comunicano le **informazioni espresse nei dati**,
+ contribuiscono ad una **visione di insieme**.
  
\vspace{8pt}

***Problema***: può risultare **difficile** seguire **un singolo punto** nel suo percorso sul piano, soprattutto se ci sono dei punti dal colore simile.

***Soluzione***: bisogna introdurre un **highlight** di qualche tipo.

***Nostra proposta***: impiego del suono per evidenziare un punto, facendo uso di **sonification**. Dobbiamo verificare se questa è una proposta valida.

# Modo di operare

1. Realizzazione in Processing di un bubble plot animato.

2. Individuazione e sviluppo di tecniche di highlight sonoro.

3. Svolgimento di esperimenti con dei soggetti e raccolta dati.

4. Valutazione delle performance nel task di individuazione di un punto specifico in base a:
\vspace{-6pt}
   - sonification,
   - taglia dei punti,
   - colore dei punti.


# Rappresentazione visuale


::: columns

:::: column
\vspace{8pt}
![una scena](res/scena.png)
::::

:::: column

\vspace{4pt}

+ Una scena consiste in una **simulazione** di punti.

\vspace{4pt}

+ Il **moto** dei punti è casuale, ma plausibile.

\vspace{4pt}

+ La **dimensione** di un punto è random dentro un intervallo.

\vspace{4pt}

+ Ad un punto corrisponde uno specifico colore e viceversa, i colori sono ricavati dalla **Viridis**.
::::

:::


# Il colore dei punti

Scegliamo la Viridis perché è una mappa di colore **robusta**, **uniforme** e **popolare**. Il numero dei punti è 27, da questo ne consegue che:
\vspace{-4pt}

+ la **distinzione** dei punti dal colore simile **non è immediata**;
+ si introduce una certa **confusione** tra i colori;
+ la discriminazione dell'obiettivo con il solo colore resta possibile.

\vspace{12pt}

## **Punto target**
Si tratta del punto da ricercare e cliccare, estratto in maniera random ad ogni scena.

# Sonification della velocità del target

- Il **suono** è generato a partire da un accordo il cui **pitch** sale al crescere della **velocità** del target.
 
- Ad un punto **fermo** corrisponde un accordo di **Do maggiore**, con fondamentale a 32.7 Hz. 

- Ad una **bassa velocità** corrisponde un suono **poco brillante**, ad **un'alta velocità** corrisponde un suono **più brillante**. 

\vspace{8pt}

## **Variante della sonification**

\vspace{1pt}

Esattamente come prima per quanto riguarda la **velocità**, ma introduce un **bounce** in caso di **variazioni drastiche** della traiettoria del punto.

# Esperimenti

Abbiamo eseguito diverse sessioni di esperimenti in circostanze ambientali confrontabili. Hanno preso parte agli esperimenti 21 partecipanti:

- 8 femmine e 13 maschi, 

- un'età mediana di 23 anni (range 13-34),

- non è stato fornito alcun compenso per la partecipazione.


\vspace{12pt}

## **Hardware utilizzato**

I nostri due computer portatili, entrambi con un monitor full hd da 14 pollici. Come dispositivo di puntamento un mouse esterno. Per la riproduzione sonora gli altoparlanti integrati nei portatili.


# Esperimenti

Ogni **partecipante** ha svolto **13 tentativi** per ciascun **livello** di sonification (39 in totale),  ciascuno in una **scena diversa**.

***Task***: individuare il **target** della scena corrente, cliccando sul **punto corrispondente** non appena fossero stati **abbastanza certi** di averlo trovato.

\vspace{6pt}

## **Sonification**

\vspace{3pt}

Le scene differiscono per il livello di sonification, che può essere:

\vspace{3pt}

- nessuna sonification (\textbf{n}), \vspace{3pt}
- sonification della velocità (\textbf{s}), \vspace{3pt}
- sonification della velocità e bounce (\textbf{b}). \vspace{3pt}

# Problematiche


::: columns
:::: column
## **Effetti d'ordine**

\vspace{4pt}

***Problema***: serve una strategia per compensare gli effetti d'ordine. 

\vspace{4pt}

***Soluzione***: il livello di sonification presentato in ogni scena è casuale. 
\vspace{4pt}

::::
:::: column
## **Learning**

\vspace{4pt}

***Problema***: è molto probabile che i partecipanti facciano sensibilmente peggio nei primi tentativi.

\vspace{4pt}

***Soluzione***: i partecipanti effettuano una sessione di allenamento preliminare: i primi 9 tentativi vengono esclusi dalla raccolta dei dati (3 prove per ogni livello di sonification).
\vspace{4pt}
::::
:::


# Esperimenti

Svolgiamo gli esperimenti al fine di rilevare:
\vspace{-5pt}

- i possibili vantaggi della **sonificazione**, \vspace{2pt}
- i possibili effetti dovuti alla **mappa di colore**, \vspace{2pt}
- i possibili effetti dovuti alla **dimensione dei punti**.

\vspace{2pt}

Per fare ciò, per ogni ogni risposta raccogliamo: 
\vspace{-5pt}

+ livello di sonificazione, \vspace{2pt}
+ errore e tempo di risposta, \vspace{2pt}
+ taglia e colore dei punti (target e selezionato). 

\vspace{4pt}

\small

## **Misura di errore**

Come **errore** consideriamo la **distanza** in step tra l'**obiettivo** e il **punto selezionato**, nella legenda. 


# Sonification

::: columns
\vspace{4pt}
:::: column
\small
\vspace{16pt}
Per ciascun partecipante ricaviamo il **tempo medio** e **l'errore medio** sui 10 tentativi misurati per ogni livello di sonificazione. 

\vspace{4pt}

Ricorrendo ai **box plot** si nota che **esistono delle differenze** tra le medie, ma non sappiamo se **significative**. 
::::

:::: column
\vspace{12pt}
![](res/sonification_effect.pdf) 
::::

:::

\small

| Sonification | tempi medi, CI 95%   | errori medi, CI 95% |
| :----------: | -------------------- | ------------------- |
|    **n**     | 9.07 [7.61, 10.54]   | 0.93 [0.69, 1.17]   |
|    **s**     | 15.45 [10.70, 20.21] | 0.48  [0.28, 0.67]  |
|    **b**     | 15.88 [11.28, 20.48] | 0.61 [0.41, 0.81]   |


# Risultati per il tempo

**Ipotesi nulla** nessuna differenza significativa tra le medie.

*Verifica*: test ANOVA a misure ripetute sul fattore sonification. 

*Esito*: otteniamo un p-value = 0.02, **rigettiamo l'ipotesi nulla**.

Dai confronti post hoc (t-test corretto con Bonferroni) abbiamo:

+ differenza **significativa** tra **b** e **n** con un p-value = 0.0016,
+ differenza **significativa** tra **s** e **n** con un p-value = 0.0045,
+ non è possibile rigettare l'ipotesi tra **s** e **b** (p-value = 1.0).

# Risultati per gli errori

**Ipotesi nulla** nessuna differenza significativa tra le medie.

*Verifica*: test ANOVA a misure ripetute sul fattore sonification. 

*Esito*: otteniamo un p-value = 0.008, **rigettiamo l'ipotesi nulla**.

Dai confronti post hoc (t-test corretto con Bonferroni) abbiamo:

+ differenza **significativa** tra **b** e **n** con un p-value = 0.043,
+ differenza **significativa** tra **s** e **n** con un p-value = 0.0015,
+ non è possibile rigettare l'ipotesi tra **s** e **b** (p-value = 0.2197).

# Considerazioni

Le **scene con la sonificazione** necessitano di **più tempo**. I partecipanti usano la sonificazione per **raffinare** la loro risposta, essa ha **aumentato l'accuratezza** ma non ha abbattuto del tutto gli errori. 

Molti partecipanti ribadiscono l'efficacia della sonificazione, **credendo di commettere molti errori** nelle scene senza highlight.

Alla luce dei dati sperimentali, anche in assenza di sonificazione i partecipanti **fanno abbastanza bene** in termini di accuratezza.

# Considerazioni

Ci aspettavamo che il bounce di **b** richiamasse l'attenzione sul punto obiettivo portando a **miglioramenti in accuratezza** con **tempi migliori** rispetto a **s**.

I dati **non consentono di dimostrare** questo effetto (o comunque **non è vantaggioso** come da noi sperato).

Inoltre, alcuni partecipanti trovano il bounce **controproducente**, vengono **distratti** dai rimbalzi.

\vspace{6pt}

***Conclusioni***: **b** non è da preferire ad **s**.

# Dimensione

*La taglia dei cerchi impatta nella capacità di discriminare i colori?*

+ Suddivisione dei punti in **small**, **medium** e **big**. 
+ Ricaviamo i **tempi** e gli **errori** medi di ciascun partecipante in funzione di ciò.
+ **Non possiamo rigettare l'ipotesi nulla** di nessuna differenza tra le medie (tempi p-value = 0.736, errori p-value = 0.325.)

+ I dati sperimentali sembrano non mostrare differenze di medie significative.

*In caso di errore è più frequente la predilezione di punti grandi su punti piccoli o viceversa?* 

# Dimensione


::: columns

:::: column
\vspace{-3pt}
![](res/size_effect.pdf)
\small
Plot di minimo, massimo, media e deviazione standard per le distribuzioni di tempo ed errore medi rispetto alle tre classi di dimensioni.
::::

:::: column
![](res/size_preference.pdf)
\small
Percentuali di preferenza di taglia in caso di errore per ogni partecipante, disposti in ordine crescente di preferenza per taglia più grande.
::::

:::



# Dimensione 

Su un totale di 263 errori:

\vspace{-4pt}

+ 142 volte è stato prediletto un punto **più grande**,
+ 109 volte è stato prediletto un punto **più piccolo**, 
+ nei restanti errori la taglia era **uguale**.

Si nota la **tendenza** a selezionare dei punti **più grandi**, tuttavia **non sappiamo** se questa sia **significativa**. 

Sarebbe il caso di realizzare un **esperimento specifico**.


# Colore

*Esiste qualche effetto in funzione del colore dei punti?*

I partecipanti, spesso, ammettono di trovare una **maggiore difficoltà** nel distinguere i punti **blu** o **verdi**. 

::: columns

:::: column
\vspace{8pt}
![Matrice di confusione](res/color_confusion.pdf){width=85%}
::::

:::: column
\vspace{16pt}
![Tempi in sec. per colore](res/time_color.pdf)
::::

:::

# Considerazioni

La **maggiore difficoltà percepita** si può quantificare in termini di accuratezza e tempo di esecuzione. Assumiamo che ai più difficili da distinguere corrisponda:

\vspace{-4pt}

+ un maggior **grado di confusione**,
+ un maggior **tempo medio di individuazione**. 

\vspace{8pt}

Nelle regioni corrispondenti ai **blu** e ai **verdi** troviamo dei **tempi maggiori** ed un **grado di confusione** generalmente **maggiore**. 

Non è il caso di giungere a delle conclusioni, per fare ciò sarebbe il caso di fare un **esperimento specifico**.

# Conclusioni


+ La sonificazione **è valida** per realizzare un **highlight** nei bubble plot animati, dato che porta ad un effettivo **miglioramento nell'accuratezza**. 

+ Rappresentare l'highlight mediante dei **canali visuali** resta una strategia da preferire.

+ Pensiamo che in **contesti particolari**, la sonification potrebbe risultare **interessante**.

\vspace{8pt}

\small

## **Esempio**

Nelle **analisi collaborative** ogni partecipante potrebbe mettere in evidenza un suo punto di interesse mantenendo la scena inalterata ai suoi collaboratori.

# Fonti

[1] Davide Rocchesso - Materiale didattico del corso Multisensory and Data Exploration - A.A. 20/21

[2] Niklas Rönnberg - "Musical sonification supports visual discrimination of color intensity", Behaviour & Information Technology (2019) 38:10, 1028-1037

[3] Niklas Rönnberg - "Sonification supports perception of brightness contrast", Journal on Multimodal User Interfaces (2019) 13:373–381

[4] Hans Rosling - TED Talk [(link)](https://www.ted.com/talks/hans_rosling_the_best_stats_you_ve_ever_seen/up-next?language=it)







<!--

## Problema affrontato

::: {.block}
### Traccia
\small
Creare un sistema di raccomandazione basato su **Collaborative Filtering** per il suggerimento di **appunti on-line**. Vanno utilizzate opportunamente le librerie di **Spark**. 
\normalsize
:::

+ *Obiettivo*: realizzare un sistema di **raccomandazione**. 

+ Si individuano gli **users** e gli **items**
  
+ *Soluzione*: proporre agli users degli items **compatibili** con i loro interessi:
  
  \vspace{-6pt}
  
  - users $\to$ utenti del servizio di appunti on-line
  
  \vspace{-6pt}
  
  - items $\to$ i documenti di appunti

## Problema affrontato

+ In un **contesto fisico** i prodotti visualizzabili sono **solo i più popolari**. 

![La long-tail](imgs/Schermata%20da%202021-06-21%2011-44-43.png){width=35%}

\vspace{-6pt}

+ In un **contesto online** si hanno **molti più prodotti**
  
  \vspace{-6pt}

  - anche i prodotti **meno popolari** devono essere proposti
  
  \vspace{-6pt}

  - i sistemi di raccomandazione diventano **essenziali**.


## Possibili approcci

**Content Based**

+ **Categorizzare** gli utenti e gli appunti in **maniera esplicita**
  
  - Utente $\to$ categorie di interesse
  
  - Appunti $\to$ cetegoria di appartenenza. 

\vspace{6pt}

+ Ottenere le raccomandazioni facendo **matching** tra gli interessi degli utenti e le categorie di appunti.
  
\vspace{6pt}

*Problema*: non sempre questa categorizzazione si riesce a fare **efficacemente** (soprattutto per gli users).

## Soluzione alternativa

Sfruttare il **rating** che gli utenti attribuiscono **esplicitamente** ai prodotti.

+ *Problema*: i ratings espliciti non sempre sono disponibili.

+ *Soluzione*: raccogliere delle valutazioni in modo **implicito**, per esempio osservando:
  
  \vspace{-6pt}
  
  - il numero dei download
  
  \vspace{-6pt}
  
  - i tempi di consultazione
  
  \vspace{-6pt}
  
  - commenti agli appunti... 

Pesando opportunamente questi parametri $\to$ **Rating implicito**


## Approccio basato sul rating

Sia $R$ una matrice che metta in relazione gli **utenti** con gli **appunti**:

+ Una riga $\to$ ratings di un utente ai vari items

+ Una colonna $\to$ ratings dei vari utenti ad un item

\vspace{6pt}

![Esempio di matrice](imgs/Schermata%20da%202021-06-21%2012-20-40.png){width=55%}

\vspace{-6pt}

*Idea*: cercare tra i gruppi di righe più simili i suggerimenti. 

*Nota*: La matrice $R$ risulta essere molto sparsa!

## Metodo basato sul vicinato

Metodo con la ricerca dei **nearest neighbours**

+ individua le righe vicine secondo una metrica di distanza
  
+ colma un'entrata osservando i valori nelle righe vicine

\vspace{8pt}

Problema (quasi) risolto: 

+ il rating predetto si considera come un suggerimento

+ agli utenti si suggeriscono degli items con un punteggio alto in un grande numero di righe simili.

## Sistema di raccomandazione

*In generale* un sistema di raccomandazione 
  
- parte da una matrice **sparsa**

- prova a renderla **densa**

\vspace{12pt}

I metodi **content based** e **nearest neighbours** funzionano...

ma non si comportano bene quando si ha **elevata sparsità** di dati!

(Necessitano prima di tante interazioni con il sistema)

## I filtri collaborativi

*Osservazione*: la matrice $R$ può essere "semplificata"
  
  - non **tutti gli users** sono interessati a **tutti gli items**
  
  - si fa **clustering** su users e items.

\vspace{8pt}

Adesso si parla di:

\vspace{-6pt}

+ **interessi di gruppi di utenti** $\to$ **gruppi di prodotti**

\vspace{8pt}

*Idea*: fattorizzare la matrice $R$ per ottenere due matrici di **dimensione minore**.

## I filtri collaborativi

Nell'ambito dei filtri collaborativi

+ Si parla di *features*, ossia i **fattori latenti**

+ Si sfruttano delle dimensioni che rappresentano bene il problema... **senza sapere a priori sapere quali siano**.

In questo spazio si **collocano** sia gli **users** che gli **items** rispetto ai **valori ricavati** per le features

*Conslusione*: i suggerimenti per un utente sono ricavati osservando i prodotti che **ricadono più vicini** ad esso.

## I filtri collaborativi

*Nello specifico*: $R \approx U \times P$

+ $U$: users $\to$ features individuate
  
+ $P$: items $\to$ features individuate.

\vspace{6pt}

Il **prodotto** tra queste matrici restituisce una **approssimazione più densa** della matrice di partenza.

*Nota*: abbiamo trovato i suggerimenti!

*In pratica*: il metodo di scomposizione opera minimizzando l'errore tra le coppie user-item dell'approssimazione e della matrice originale. Si può fare con il gradiente o gli **alternating least squared (ALS)**.

## Alternating Least Squared

L'algoritmo ALS:

+ parte da $U$ e $P$ random;

+ fissa una matrice e regola l'altra per minimizzare l'errore;

+ ripete fissando l'altra matrice;

+ continua finché non ottiene una buona approssimazione.

\vspace{6pt}

Tiene conto del **comportamento** degli altri utenti, ma in un modo **diverso** rispetto agli altri metodi!

## Il Dataset

+ *Richiesta*: sistema per il **suggerimento di appunti on-line**.

+ *Problema*: non ho trovato un **dataset specifico**. 

+ *Soluzione*: generarne uno? Difficile ottenere **relazioni valide**. 
  
+ *Workaround*: ho usato un dataset con **feedback** dati da degli utenti a dei **libri** (impliciti ed espliciti).
  
\vspace{8pt}

+ Speriamo che le categorie dei libri ricalchino abbastanza bene quelle degli appunti!

## Il Dataset

**Book-Crossing Dataset**, tre files CSV:

+ lista utenti anonimizzati
+ lista dei libri contraddistinti da ISBN
+ lista rantings tra utenti e libri

+ feedback espliciti: rating numerico da 1 a 10
+ feedback impliciti: rating a 0

## Il software

**Spark**, con **MLlib**, fornisce una implementazione di **ALS**:

+ carico il dataset in un dataframe

+ alleno un modello su di esso

+ applico la trasformazione del modello sul dataset

I **migliori suggerimenti** per un user sono gli items in ordine decrescente rispetto al **rating previsto** (intendo una predizione come una misura di quanto un user potrebbe gradire un contenuto).

## Il software

**ALS** in Spark ha una variante per i feedback **espliciti** ed una per quelli **impliciti**...

+ Potrei sfruttare tutte le entry del dataset? Per i feedback impliciti ho solo una "manifestazione di interesse".

+ Ho trattato i due tipi di feedback separatamente.

\vspace{6pt}

Prima di allenare il modello ALS ho **separato il dataset** in un **training set** ed in un **testing set**.

Determinare **quanto bene** si comporta il modello su dei dati che non hanno contribuito al suo allenamento permette di farne del **tuning**.

## Il software

```scala
val als = new ALS()
  .setMaxIter(15)
  .setRegParam(0.1)
  .setUserCol("userId")
  .setItemCol("bookId")
  .setRatingCol("rating")
  .setRank(15)
  .setNonnegative(true)
  .setColdStartStrategy("drop")

val model = als.fit(trainingSet)
val exPredictions = model.transform(testingSet)
```

## Il software

La metrica che ho utilizzato per valutare l'errore è lo **scarto quadratico medio** tra le **predizioni** ed i **valori veri**.

+ Scarto quadratico medio troppo alto? 

+ Cambio i parametri al fine di minimizzarlo.

\vspace{8pt}

Strategie più accurate? **Cross-validation**, **Train-Validation Split**.

+ *Problema*: servirebbe un cluster di workers migliore di quello fatto con il mio solo portatile.
 
## I risultati

Con la configurazione precedentemente indicata:

\vspace{12pt}

| Feedback  | RMSE                        | %VP,VN |
| --------- | --------------------------- | -----: |
| implicito | $\approx 2.45$ (scala 1-10) |    66% |
| esplicito | $\approx 0.17$ (scala 0-1)  |    97% |

## Perché usare Spark?

+ **Spark** $\to$ **architettura distribuita**!

+ Sfruttando solamente il semplice **parallelismo** dato dall'architettura multicore della mia macchina **si notano i vantaggi**.
  
Semplici esperimenti indicativi con una versione ridotta del dataset:

+ 1 worker $\to$ 6:36 minuti

+ 2 workers $\to$ 4:24 minuti

+ 4 workers $\to$ 2:47 minuti

## Esempio output

\small

Naturalmente i suggerimenti sono ricavati per ciascun utente, qui di seguito un esempio di output contenente i suggerimenti per degli utenti specifici, al fine di illustrare la natura dei risultati. 

![Libri consigliati per un utente](imgs/Screenshot%20from%202021-06-20%2017-22-26.png)

-->
