$ontext

        Production activities   A (30)
        Commodities             C (30)
        Primary Factors         F (2)
        Households              H (1)
        Central Government      G1(1)
        Provincial Government   G2(1)
        Types of taxes          T (4)
        Rest of country         DX(1)
        Rest of world           X (1)
        Investment-savings      I (2)

Here is a "MAP" of the SAM with the names of the submatrices which
contain data.  All cells with no labels are empty:



           A       C        F       H      G1      G2       T       DX      X      I1      I2
        ----------------------------------------------------------------------------------------
A       |       |   ac  |       |       |       |       |   sa  |       |       |       |       |
        ----------------------------------------------------------------------------------------
C       |   ca  |       |       |   ch  |       |  g2d  |       |   der |   er  |  cs1  |  cs2  |
        ----------------------------------------------------------------------------------------
F       |   fa  |       |       |       |       |       |       |       |       |       |       |
        ----------------------------------------------------------------------------------------
H       |       |       |   hf  |       |       |  hg2  |       |   dhr |   hr  |       |       |
        ----------------------------------------------------------------------------------------
G1      |       |       |       |       |       |  g1g2 |       |       |       |  cg1s |       |
        ----------------------------------------------------------------------------------------
G2      |       |       |       |       | g2g1  |       |   tr  |       |       |       |       |
        ----------------------------------------------------------------------------------------
T       |   ta  |       |       |       |       |       |       |       |       |       |       |
        ----------------------------------------------------------------------------------------
DX      |       |  drc  |       |  drh  |       |       |       |       |       |       |       |
        ----------------------------------------------------------------------------------------
X       |       |   rc  |       |   rh  |       |       |       |       |       |       |       |
        ----------------------------------------------------------------------------------------
I1      |       |       |   dp  |  psv1 | g1sv  |       |       |       |       |       |       |
        ----------------------------------------------------------------------------------------
I2      |       |   ic  |       |  psv2 |       |       |       |       |       |       |       |
        ----------------------------------------------------------------------------------------

$offtext
$if not set prov   $set prov BEJ
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder1 '%projectfolder%/data/gdx'

*SAM table
set     oldi   SAM rows and colums indices   /
        1*30    Industries,
        31*60   Commodities,
        61      Labor,
        62      Capital,
        63      Household,
        64      Central Government,
        65      Local Government,
        66      Production tax,
        67      Commodity tax,
        68      Factor tax,
        69      Income tax,
        70      Domestic trade,
        71      Foreign trade,
        72      Investment,
        73      Inventory/;
set      i       SAM with trade margin/
         1*74/;
alias (oldi,oldj);
alias (i,j,ii);
*Energy balance table
set ebti /
         1       DX,
         2       X,
         3       DRC,
         4       RC,
         5       AGR,
         6       COAL,
         7       OIL,
         8       MM,
         9       NM,
         10      FBT,
         11      TXT,
         12      CLO,
         13      LOG,
         14      PAP,
         15      ROIL,
         16      CHE,
         17      NMP,
         18      MSP,
         19      MP,
         20      GSM,
         21      TME,
         22      EME,
         23      CCE,
         24      IM,
         25      AC,
         26      WAS,
         27      ELEH,
         28      FG,
         29      WT,
         30      CON,
         31      TR,
         32      WRHR,
         33      OTH,
         34      NG,
         35      FU,
         36      INV,
         37      PROD
/;
set      e       energy product  /
         coal    Coal,
         fg      Fuel gas,
         oil     Crude oil,
         roil    Refined oil,
         ng      Natural gas,
         eleh    Electricity & heat,
         othe    Other energy/;
set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
set      pmg     /1*60/;
alias    (pmg,pmg2);
parameter sam3(r,oldi,oldj)           SAM v3.0 ready for rebalancing
parameter ebt2(oldi,r,ebti)           EBT v2.0 for OPT
parameter poilng
parameter p(i)
parameter pricemargin(r,pmg)
$gdxin '%inputfolder1%/sam3.gdx'
$load sam3
$load ebt2
$load pricemargin
parameter sam31(r,i,j)           SAM v3.1 ready for rebalancing
parameter ebt21(i,r,ebti)           EBT v2.1 for OPT
*SAM v3.1
loop(r,
loop(i$(ord(i)<=73),
loop(j$(ord(j)<=73),
loop(oldi$(ord(oldi)=ord(i)),
loop(oldj$(ord(oldj)=ord(j)),
sam31(r,i,j)=sam3(r,oldi,oldj);
););););
);
loop(r,
loop(i$(ord(i)=74),
loop(j,
sam31(r,i,j)=0;
sam31(r,j,i)=0;
););
);
*EBT v2.1
loop(r,
loop(ebti,
loop(i$(ord(i)<=73),
loop(oldi$(ord(oldi)=ord(i)),
ebt21(i,r,ebti)=ebt2(oldi,r,ebti)/1000;
););););



*$ontext
positive variables finalsam (r,i,j)
positive variables rowsum(r,i)
positive variables columnsum(r,i)
variable jj

Equations
        rsum
        csum
        sumbalance

        obj
;

*rsum(r,i)..
rsum(r,i)$(sameas(r,'%prov%'))..
sum(j,finalsam(r,i,j))=e=rowsum(r,i);

*csum(r,i)..
csum(r,i)$(sameas(r,'%prov%'))..
sum(j,finalsam(r,j,i))=e=columnsum(r,i);

*sumbalance(r,i)..
sumbalance(r,i)$(sameas(r,'%prov%'))..
rowsum(r,i)=e=columnsum(r,i);

obj..
jj=e=sum(r$(sameas(r,'%prov%')),sum(i,sum(j,sqr(finalsam(r,i,j)-sam31(r,i,j)))))+10000*sum(r$(sameas(r,'%prov%')),sum(i$((ord(i)=32) or (ord(i)=33) or (ord(i)=41) or (ord(i)=53) or (ord(i)=54) or (ord(i)=60) or (ord(i)=70) or (ord(i)=71)),sum(j$((ord(j)=2) or (ord(j)=3) or (ord(j)=11) or (ord(j)=23) or (ord(j)=24) or (ord(j)=30) or (ord(j)=70) or (ord(j)=71)),sqr(finalsam(r,i,j)-sam31(r,i,j)))));

Model gua /all/;
*ratio of hh and gov's cons
parameter sam31csum(r,i)
loop(r,
loop(i,
sam31csum(r,i)=0;
););
loop(r$(sameas(r,'%prov%')),
loop(i,
loop(j$((ord(j)>=31) and (ord(j)<=60)),
sam31csum(r,i)=sam31csum(r,i)+sam31(r,j,i);
);
);
);

loop(r$(sameas(r,'%prov%')),
loop(i,
loop(j,
finalsam.l(r,i,j)=sam31(r,i,j);
);););

*If quantity is not zero, value is not zero
*Assuming trade margin is distributed equally between exporter and importer
loop(r$(sameas(r,'%prov%')),
loop(i$((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)),
loop(j$(ord(j)=ord(i)+30),
loop(pmg$(ord(pmg)=ord(i)),
loop(pmg2$(ord(pmg2)=ord(i)*2),
sam31(r,j,"70")=pricemargin(r,pmg)*ebt21(i,r,"1");
sam31(r,"74",i)=sam31(r,"74",i)+pricemargin(r,pmg2)*ebt21(i,r,"1");
finalsam.fx(r,j,"70")=sam31(r,j,"70");

sam31(r,j,"71")=pricemargin(r,pmg)*ebt21(i,r,"2");
sam31(r,"74",i)=sam31(r,"74",i)+pricemargin(r,pmg2)*ebt21(i,r,"2");
finalsam.fx(r,j,"71")=sam31(r,j,"71");

sam31(r,"70",j)=pricemargin(r,pmg)*ebt21(i,r,"3");
sam31(r,"74",i)=sam31(r,"74",i)+pricemargin(r,pmg2)*ebt21(i,r,"3");
finalsam.fx(r,"70",j)=sam31(r,"70",j);

sam31(r,"71",j)=pricemargin(r,pmg)*ebt21(i,r,"4");
sam31(r,"74",i)=sam31(r,"74",i)+pricemargin(r,pmg2)*ebt21(i,r,"4");
finalsam.fx(r,"71",j)=sam31(r,"71",j);

if((sam31(r,j,"63")+sam31(r,j,"65"))>0,
sam31(r,j,"63")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"35")/(sam31(r,j,"63")+sam31(r,j,"65"))*sam31(r,j,"63");
sam31(r,j,"65")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"35")-sam31(r,j,"63");
else
sam31(r,j,"63")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"35")/(sam31csum(r,"63")+sam31csum(r,"65"))*sam31csum(r,"63");
sam31(r,j,"65")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"35")/(sam31csum(r,"63")+sam31csum(r,"65"))*sam31csum(r,"65");
);

sam31(r,j,"73")=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"36");

sam31(r,i,j)=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,"37");
*finalsam.fx(r,i,j)=sam31(r,i,j);

loop(ebti$((ord(ebti)>=5) and (ord(ebti)<=34)),
loop(ii$(ord(ii)=ord(ebti)-4),
sam31(r,j,ii)=(pricemargin(r,pmg)+2*pricemargin(r,pmg2))*ebt21(i,r,ebti);
*finalsam.fx(r,j,ii)=sam3(r,j,ii);
);
);
););
);
*end of j
finalsam.fx(r,"74",i)=sam31(r,"74",i);
*Balance trade margin
sam31(r,"57","74")=sam31(r,"57","74")+sam31(r,"74",i);
*end of i
);
finalsam.fx(r,"57","74")= sam31(r,"57","74");
*Adjust transportation production
sam31(r,"27","57")=sam31(r,"27","57")+sam31(r,"57","74");
);




*Fix sparcity
loop(r$(sameas(r,'%prov%')),
*loop(i$(not ((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30) or (ord(i)=70) or (ord(i)=71))),
*loop(j$(not ((ord(j)=2) or (ord(j)=3) or (ord(j)=11) or (ord(j)=23) or (ord(j)=24) or (ord(j)=30) or (ord(j)=70) or (ord(j)=71))),
loop(i$(not ((ord(i)=70) or (ord(i)=71))),
loop(j$(not (((ord(j)=33) and (ord(i)>=31) and (ord(i)<=60)) or ((ord(j)=60) and (ord(i)>=31) and (ord(i)<=60)) or (ord(j)=70) or (ord(j)=71))),
if (finalsam.l(r,i,j)=0,
finalsam.fx(r,i,j)=0;
);
);
);
);
gua.iterlim=100000;
Solve gua minimizing jj using nlp;
display finalsam.l;

*chksam
set     negval4(i,j)     Flag for negative elements;
set     empty4(i,*)      Flag for empty rows and columns;
parameter       chksam4(i,*)       Consistency check of social accounts;
parameter totoutput2;
totoutput2=0;
loop(r$(sameas('%prov%',r)),
loop(i$((ord(i)>=31) and (ord(i)<=60)),
totoutput2=totoutput2+sum(j,finalsam.l(r,i,j));
);
);
loop(r$(sameas('%prov%',r)),
negval4(i,j) = yes$(finalsam.l(r,i,j) < 0);
empty4(i,"row") = 1$(sum(j, finalsam.l(r,i,j)) = 0);
empty4(j,"col") = 1$(sum(i, finalsam.l(r,i,j)) = 0);
chksam4(i,"before") = sum(j, finalsam.l(r,i,j)-finalsam.l(r,j,i));
chksam4(i,"scale") = sum(j, finalsam.l(r,j,i));
chksam4(i,"%dev")$sum(j, finalsam.l(r,i,j)) = 100 * sum(j, finalsam.l(r,i,j)-finalsam.l(r,j,i)) / sum(j, finalsam.l(r,i,j));
);
parameter sam4(i,j);
loop(r$(sameas('%prov%',r)),
loop(i,
loop(j,
sam4(i,j)= finalsam.l(r,i,j);
);
);
);
*Energy related data
parameter egyvalue2(i,r,ebti);
loop(r,
loop(i$((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)),
loop(j$(ord(j)=ord(i)+30),
egyvalue2(i,r,"1")=sam4(j,"70");
egyvalue2(i,r,"2")=sam4(j,"71");
egyvalue2(i,r,"3")=sam4("70",j);
egyvalue2(i,r,"4")=sam4("71",j);
loop(ebti$((ord(ebti)>=5) and (ord(ebti)<=34)),
loop(ii$(ord(ii)=ord(ebti)-4),
egyvalue2(i,r,ebti)=sam4(j,ii);
);
);
egyvalue2(i,r,"35")=sam4(j,"63")+sam4(j,"65");
egyvalue2(i,r,"36")=sam4(j,"73");
egyvalue2(i,r,"37")=sam4(i,j);
);););
display egyvalue2;


