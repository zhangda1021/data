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

$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder1 '%projectfolder%\data\gdx'
$setlocal inputfolder2 '%projectfolder%\data\gdx\egygdx\estimation'
$setlocal inputfolder3 '%projectfolder%\data\gdx\egygdx'

*SAM table
set     i   SAM rows and colums indices   /
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
alias (i,j);
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
set	 e       energy product  /
         coal    Coal,
         fg      Fuel gas,
         oil     Crude oil,
         roil    Refined oil,
         ng      Natural gas,
         eleh    Electricity & heat,
         othe    Other energy/;
set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
set	 prange/
	 LB,
	 UB/;
parameter sam2(r,i,j)           SAM v2.0
parameter ebt(e,r,ebti)		EBT
parameter pricerange(e,prange)  Price range of energy products
$gdxin '%inputfolder1%\aggregation.gdx'
$load sam2
display sam2
$gdxin '%inputfolder2%\merged.gdx'
$load ebt
display ebt
$gdxin '%inputfolder3%\pricerange.gdx'
$load pricerange
display pricerange


$ontext
set     negval2(r,i,j)     Flag for negative elements;
set     empty2(r,i,*)      Flag for empty rows and columns;
parameter       chksam2(r,i,*)       Consistency check of social accounts;



*SAM2
loop(r,

loop(nj$(ord(nj) le 27),
loop(j$(ord(j)=ord(nj)),
loop(ni,
loop(i$(ord(i)=ord(ni)),
sam2(r,i,j)=sam15(r,ni,nj);
);
);
);
);

loop(ni,
loop(i$(ord(i)=ord(ni)),
sam2(r,i,"28")=sam15(r,ni,"30")+sam15(r,ni,"31");
);
);


*AGGREGATION OF OTH PRODUCTION(other service industry)
loop(nj$(((ord(nj) ge 31) and (ord(nj) le 42)) or (ord(nj) = 28) or (ord(nj) = 29)),
loop(ni,
loop(i$(ord(i)=ord(ni)),
sam2(r,i,"29")=sam2(r,i,"29")+sam15(r,ni,nj);
);
);
);

loop(nj$((ord(nj) ge 43) and (ord(nj) le 69)),
loop(j$(ord(j)=ord(nj)-12),
loop(ni,
loop(i$(ord(i)=ord(ni)),
sam2(r,i,j)=sam15(r,ni,nj);
);
);
);
);


loop(ni,
loop(i$(ord(i)=ord(ni)),
sam2(r,i,"58")=sam15(r,ni,"72")+sam15(r,ni,"73");
);
);

*AGGREGATION OF OTH COMMODITIES(other service industry)
loop(nj$(((ord(nj) ge 74) and (ord(nj) le 84)) or (ord(nj) = 70) or (ord(nj) = 71)),
loop(ni,
loop(i$(ord(i)=ord(ni)),
sam2(r,i,"59")=sam2(r,i,"59")+sam15(r,ni,nj);
);
);
);

loop(nj$((ord(nj) ge 85) and (ord(nj) le 97)),
loop(j$(ord(j)=ord(nj)-24),
loop(ni,
loop(i$(ord(i)=ord(ni)),
sam2(r,i,j)=sam15(r,ni,nj);
);
);
);
);
*end of loop r
);


loop(r,
negval2(r,i,j) = yes$(sam2(r,i,j) < 0);

empty2(r,i,"row") = 1$(sum(j, sam2(r,i,j)) = 0);
empty2(r,j,"col") = 1$(sum(i, sam2(r,i,j)) = 0);

chksam2(r,i,"before") = sum(j, sam2(r,i,j)-sam2(r,j,i));
chksam2(r,i,"scale") = sum(j, sam2(r,j,i));
chksam2(r,i,"%dev")$sum(j, sam2(r,i,j)) = 100 * sum(j, sam2(r,i,j)-sam2(r,j,i)) / sum(j, sam2(r,i,j));

);
$offtext


