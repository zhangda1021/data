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
$setlocal inputfolder1 '%projectfolder%/data/gdx'
$setlocal inputfolder2 '%projectfolder%/data/gdx/egygdx/estimation'
$setlocal inputfolder3 '%projectfolder%/data/gdx/egygdx'

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
set      prange/
         LB,
         UB/;
parameter sam2(r,i,j)           SAM v2.0
parameter sam3(r,i,j)           SAM v3.0 ready for rebalancing
parameter ebt(e,r,ebti)         EBT
parameter pricerange(i,prange)  Price range of energy products
parameter oilngratio(r)         Oil and gas ratio of (PROD+DRC+RC-X-DX)
parameter poilng
$gdxin '%inputfolder1%/aggregation.gdx'
$load sam2
display sam2
$gdxin '%inputfolder2%/merged.gdx'
$load ebt
display ebt
$gdxin '%inputfolder3%/oilgasratio.gdx'
$load oilngratio
display oilngratio
$gdxin '%inputfolder3%/pricerange.gdx'
$load pricerange
display pricerange

parameter poilng;
*price: oil/ng
poilng=3;
*oilgas
parameter temp;
*"Rough" split of crude oil and gas in sam3
loop(r,
loop(i,
loop(j,
sam3(r,i,j)=sam2(r,i,j);
);
);
);

* Production calibration
loop(r,
temp=sam3(r,"3","33");
sam3(r,"3","33")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=temp*poilng*ebt("OIL",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
sam3(r,"30","60")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=temp*ebt("NG",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
);
*sa
loop(r,
temp=sam3(r,"3","66");
sam3(r,"3","66")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=temp*poilng*ebt("OIL",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
sam3(r,"30","66")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=temp*ebt("NG",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
);
* DRC calibration
loop(r,
temp=sam3(r,"70","33");
sam3(r,"70","33")$(poilng*ebt("OIL",r,"3")+ebt("NG",r,"3")>0)=temp*poilng*ebt("OIL",r,"3")/(poilng*ebt("OIL",r,"3")+ebt("NG",r,"3"));
sam3(r,"70","60")$(poilng*ebt("OIL",r,"3")+ebt("NG",r,"3")>0)=temp*ebt("NG",r,"3")/(poilng*ebt("OIL",r,"3")+ebt("NG",r,"3"));
);
* RC calibration
loop(r,
temp=sam3(r,"71","33");
sam3(r,"71","33")$(poilng*ebt("OIL",r,"4")+ebt("NG",r,"4")>0)=temp*poilng*ebt("OIL",r,"4")/(poilng*ebt("OIL",r,"4")+ebt("NG",r,"4"));
sam3(r,"71","60")$(poilng*ebt("OIL",r,"4")+ebt("NG",r,"4")>0)=temp*ebt("NG",r,"4")/(poilng*ebt("OIL",r,"4")+ebt("NG",r,"4"));
);
* DX calibration
loop(r,
temp=sam3(r,"33","70");
sam3(r,"33","70")$(poilng*ebt("OIL",r,"1")+ebt("NG",r,"1")>0)=temp*poilng*ebt("OIL",r,"1")/(poilng*ebt("OIL",r,"1")+ebt("NG",r,"1"));
sam3(r,"60","70")$(poilng*ebt("OIL",r,"1")+ebt("NG",r,"1")>0)=temp*ebt("NG",r,"1")/(poilng*ebt("OIL",r,"1")+ebt("NG",r,"1"));
);
* X calibration
loop(r,
temp=sam3(r,"33","71");
sam3(r,"33","71")$(poilng*ebt("OIL",r,"2")+ebt("NG",r,"2")>0)=temp*poilng*ebt("OIL",r,"2")/(poilng*ebt("OIL",r,"2")+ebt("NG",r,"2"));
sam3(r,"60","71")$(poilng*ebt("OIL",r,"2")+ebt("NG",r,"2")>0)=temp*ebt("NG",r,"2")/(poilng*ebt("OIL",r,"2")+ebt("NG",r,"2"));
);
* INV calibration
loop(r,
if(sam3(r,"73","33")>0,
temp=sam3(r,"73","33");
sam3(r,"73","33")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")>0)=temp*poilng*ebt("OIL",r,"36")/(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36"));
sam3(r,"73","60")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")>0)=temp*ebt("NG",r,"36")/(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36"));
else
temp=sam3(r,"33","73");
sam3(r,"33","73")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")>0)=temp*poilng*ebt("OIL",r,"36")/(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36"));
*Oil in Guizhou
sam3(r,"33","73")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")=0)=0;
sam3(r,"60","73")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")>0)=temp*ebt("NG",r,"36")/(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36"));
sam3(r,"60","73")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")>0)=0;
);
);
* Capital formation calibration
loop(r,
temp=sam3(r,"33","72");
sam3(r,"33","72")=temp*poilng*oilngratio(r);
sam3(r,"60","72")=temp*(1-poilng*oilngratio(r));
);
* HH and GOV calibration
loop(r,
temp=sam3(r,"33","63");
sam3(r,"33","63")$(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35")>0)=temp*poilng*ebt("OIL",r,"35")/(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35"));
sam3(r,"60","63")$(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35")>0)=temp*ebt("NG",r,"35")/(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35"));
);

* Other sectors calibration
loop(r,
loop(j$((ord(j)>=1) and (ord(j)<=30)),
loop(ebti$(ord(ebti)=ord(j)+4),
temp=sam3(r,"33",j);
sam3(r,"33",j)$(poilng*ebt("OIL",r,ebti)+ebt("NG",r,ebti)>0)=temp*poilng*ebt("OIL",r,ebti)/(poilng*ebt("OIL",r,ebti)+ebt("NG",r,ebti));
sam3(r,"60",j)$(poilng*ebt("OIL",r,ebti)+ebt("NG",r,ebti)>0)=temp*ebt("NG",r,ebti)/(poilng*ebt("OIL",r,ebti)+ebt("NG",r,ebti));
);
);
);
*COLUMN calibration
*intinput
loop(r,
loop(i$(((ord(i)>=31) and (ord(i)<=60)) and (ord(i)<>33) and (ord(i)<>60)),
temp= sam3(r,i,"3");
sam3(r,i,"30")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=temp*poilng*ebt("OIL",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
sam3(r,i,"3")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=temp*ebt("NG",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
);
);
*othinput
loop(r,
loop(i$((ord(i)>=61) and (ord(i)<=69)),
temp=sam3(r,i,"3");
sam3(r,i,"30")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"))=temp*poilng*ebt("OIL",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
sam3(r,i,"3")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"))=temp*poilng*ebt("OIL",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
);
);



****Filter
*Calculation of sum of previous values
parameter allsamsum1,allsamsum2,changeofoutput;
allsamsum1=0;
allsamsum2=0;
loop(r,
loop(i,
loop(j,
sam3(r,i,j)=sam3(r,i,j)/100000;
allsamsum1=allsamsum1+sam3(r,i,j);
);
);
);
****
*Filter 1: Diminish sectors which take smaller than 0.5% of the total out
parameter sumcolumn(r,i),sumrow(r,i);
loop(r,
loop(i,
sumcolumn(r,i)=0;
sumrow(r,i)=0;
););
loop(r,
loop(i,
sumcolumn(r,i)=sum(j,sumcolumn(r,i)+sam3(r,j,i));
);
);
loop(r,
loop(i,
sumrow(r,i)=sum(j,sumrow(r,i)+sam3(r,i,j));
);
);
display sumcolumn,sumrow;

parameter totoutput(r);
parameter smallsector(r,i);
loop(r,
totoutput(r)=0;
);
loop(r,
loop(i$((ord(i)>=31) and (ord(i)<=60)),
totoutput(r)=totoutput(r)+sumcolumn(r,i);
););
loop(r,
loop(i$((ord(i)>=31) and (ord(i)<=60) and (sumcolumn(r,i)/totoutput(r)<0.005) and not(((ord(i)=32) or (ord(i)=33) or (ord(i)=41) or (ord(i)=53) or (ord(i)=54) or (ord(i)=60)))),
loop(ii$((ord(ii)=ord(i)) or (ord(ii)=ord(i)-30)),
loop(j,
sam3(r,ii,j)=0;
sam3(r,j,ii)=0;
);
);
smallsector(r,i)=1;
););
loop(r,
totoutput(r)=0;
);

*sam after filter1
parameter tempsam(r,i,j);
loop(r,
loop(i,
loop(j,
tempsam(r,i,j)=sam3(r,i,j);
);
);
);
****Filter 2: Diminishing all the input which is smaller than 1% of total output
loop(r,
loop(i,
sumcolumn(r,i)=0;
sumrow(r,i)=0;
););
loop(r,
loop(i,
sumcolumn(r,i)=sum(j,sumcolumn(r,i)+sam3(r,j,i));
);
);
loop(r,
loop(i,
sumrow(r,i)=sum(j,sumrow(r,i)+sam3(r,i,j));
);
);
loop(r,
loop(i$((ord(i)>=31) and (ord(i)<=60)),
totoutput(r)=totoutput(r)+sumcolumn(r,i);
););
parameter incsparcity;
incsparcity=0;

loop(r,
loop(i,
*loop(j$((ord(j)>=1) and (ord(j)<=30) and not(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)))),
loop(j$((ord(j)>=1) and (ord(j)<=30)),
if(((sam3(r,i,j)<0.01*sumcolumn(r,j)) AND (sam3(r,i,j)<>0)),
sam3(r,i,j)=0;
incsparcity=incsparcity+1;
);
allsamsum2=allsamsum2+sam3(r,i,j);
);
);
);
parameter totoutput2(r);
loop(r,
totoutput2(r)=0;
);
loop(r,
loop(i$((ord(i)>=31) and (ord(i)<=60)),
totoutput2(r)=totoutput2(r)+sum(j,sam3(r,i,j));
););
parameter totchange(r);
loop(r,
loop(i$((ord(i)>=31) and (ord(i)<=60)),
totchange(r)=(totoutput(r)-totoutput2(r))/totoutput(r);
););

changeofoutput=(allsamsum1-allsamsum2)/allsamsum1*100/2;
display changeofoutput
display incsparcity;

*Original energy related data
parameter egyvalue(i,r,ebti);
loop(r,
loop(i$((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)),
loop(j$(ord(j)=ord(i)+30),
egyvalue(i,r,"1")=sam3(r,j,"70");
egyvalue(i,r,"2")=sam3(r,j,"71");
egyvalue(i,r,"3")=sam3(r,"70",j);
egyvalue(i,r,"4")=sam3(r,"71",j);
loop(ebti$((ord(ebti)>=5) and (ord(ebti)<=34)),
loop(ii$(ord(ii)=ord(ebti)-4),
egyvalue(i,r,ebti)=sam3(r,j,ii);
);
);
egyvalue(i,r,"35")=sam3(r,j,"63")+sam3(r,j,"65");
egyvalue(i,r,"36")=sam3(r,j,"73");
egyvalue(i,r,"37")=sam3(r,i,j);
);););
display egyvalue;

*chksam
set     negval3(r,i,j)     Flag for negative elements;
set     empty3(r,i,*)      Flag for empty rows and columns;
parameter       chksam3(r,i,*)       Consistency check of social accounts;
loop(r,
negval3(r,i,j) = yes$(sam3(r,i,j) < 0);

empty3(r,i,"row") = 1$(sum(j, sam3(r,i,j)) = 0);
empty3(r,j,"col") = 1$(sum(i, sam3(r,i,j)) = 0);

chksam3(r,i,"before") = sum(j, sam3(r,i,j)-sam3(r,j,i));
chksam3(r,i,"scale") = sum(j, sam3(r,j,i));
chksam3(r,i,"%dev")$sum(j, sam3(r,i,j)) = 100 * sum(j, sam3(r,i,j)-sam3(r,j,i)) / sum(j, sam3(r,i,j));
);

*Adjustment of energy data
parameter ebt2(i,r,ebti)
parameter isumebt(i,r)
loop(i,
loop(r,
isumebt(i,r)=0;
););
loop(r,
loop(ebti,
loop(e,
if(sameas(e,"coal"),
ebt2("2",r,ebti)=ebt(e,r,ebti);
);
if(sameas(e,"fg"),
ebt2("3",r,ebti)=ebt(e,r,ebti);
);
if(sameas(e,"oil"),
ebt2("11",r,ebti)=ebt(e,r,ebti);
);
if(sameas(e,"roil"),
ebt2("23",r,ebti)=ebt(e,r,ebti);
);
if(sameas(e,"ng"),
ebt2("24",r,ebti)=ebt(e,r,ebti);
);
if(sameas(e,"eleh"),
ebt2("30",r,ebti)=ebt(e,r,ebti);
);
);
);
);
loop(i,
loop(r,
loop(ebti,
isumebt(i,r)=isumebt(i,r)+ebt2(i,r,ebti);
);););
loop(i,
loop(r,
loop(ebti,
if (ebt2(i,r,ebti)<0.01*isumebt(i,r),
ebt2(i,r,ebti)=0;
);
);
););