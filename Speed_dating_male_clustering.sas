/*
 * Data Blitz : "Are men looking for similar dating partner ?"
 * Analysis of Speed Dating Dataset - Male
 * By Aarushi Mishra, ID number 16, aarushi5@illinois.edu
 */

*----------------------------------------------Reading and manipulating the data---------------------------------;

* reading in original dataset;
proc import
datafile='/home/aarushi50/My Programs/Data Blitz/speeddating100ptwavesMen.csv'
dbms=CSV out=speed_date_men replace;
getnames=YES;
run;

proc print data=speed_date_men (obs=20);
run;

* creating dataset by eliminating uwanted columns;
data signup_men_dup;
set speed_date_men;
if id = '' then delete;													 * remove observations whose id is blank;
total_score = attr1_1 + sinc1_1 + intel1_1 + fun1_1 + amb1_1 + shar1_1;  * add a column to check if given scores added up to 100;
drop iid idg condtn -- exphappy dec--match_es;
run;

proc print data=signup_men_dup(obs = 100);
run;

* sorting the data and eliminating observations with same Id;
proc sort data =signup_men_dup nodupkey out=signup_men;
by id;
run;

proc print data=signup_men;
run;


*-----------------------------------------------Analysis------------------------------------------------------------;

* proc cuslter used to determine the number of clusters ti be used;
proc cluster data=signup_men method=centroid ccc pseudo outtree=men1 plots=all ;
var attr1_1 -- shar1_1 ;
copy id attr1_1 sinc1_1 intel1_1 fun1_1 amb1_1 shar1_1;
run;

* clustering the observations into 4 clusters, CCC & pseudo-F maximum at 4 and pseudo-T squared minimum at 4 ;
proc tree data=men1 n=4 out=mencluster;
copy id attr1_1 sinc1_1 intel1_1 fun1_1 amb1_1 shar1_1;
id id;
run;

proc sort data=mencluster;
by cluster;
run;

* print clustered frequencies;
proc freq data= mencluster;
tables cluster*id;
run;

* cluster menas summary;
proc means data =mencluster;
class cluster;
var attr1_1 sinc1_1 intel1_1 fun1_1 amb1_1 shar1_1;
run;

*----------------------------------------------------END-------------------------------------------------------------------------;

/* 
 * Results:
 * There are 4 clusters. Yes, most of the men are looking for similar dating partners!
 * while most of the subjects are looking for a combination of attributes, few of them have rated few attributes to be absolutely
 * more desirable over the others
 * Patterns:
 * cluster 1: men looking for combinatin of attributes but most desired one is attractiveness and least is ambitious
 * cluster 2: men do not desire for sincererity and sharing at all, attractivness is highly rated!!
 * cluster 3 : 1 person who wants partner to be attractive and fun loving only
 * cluster 4: 1 person who desires for only good looks
 * General conclusions:
 * * Attractiveness is the highest rated attribute that men are looking for followed by intelligence
 * 
 */