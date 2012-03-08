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
parameter ebt2(i,r,ebti)        EBT for OPT
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
*ebt2
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


poilng=3;

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
sam3(r,"3","33")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=sam3(r,"3","33")*poilng*ebt("OIL",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
sam3(r,"30","60")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=sam3(r,"3","33")*ebt("NG",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
);
* DRC calibration
loop(r,
sam3(r,"70","33")$(poilng*ebt("OIL",r,"3")+ebt("NG",r,"3")>0)=sam3(r,"70","33")*poilng*ebt("OIL",r,"3")/(poilng*ebt("OIL",r,"3")+ebt("NG",r,"3"));
sam3(r,"70","60")$(poilng*ebt("OIL",r,"3")+ebt("NG",r,"3")>0)=sam3(r,"70","33")*ebt("NG",r,"3")/(poilng*ebt("OIL",r,"3")+ebt("NG",r,"3"));
);
* RC calibration
loop(r,
sam3(r,"71","33")$(poilng*ebt("OIL",r,"4")+ebt("NG",r,"4")>0)=sam3(r,"71","33")*poilng*ebt("OIL",r,"4")/(poilng*ebt("OIL",r,"4")+ebt("NG",r,"4"));
sam3(r,"71","60")$(poilng*ebt("OIL",r,"4")+ebt("NG",r,"4")>0)=sam3(r,"71","33")*ebt("NG",r,"4")/(poilng*ebt("OIL",r,"4")+ebt("NG",r,"4"));
);
* DX calibration
loop(r,
sam3(r,"33","70")$(poilng*ebt("OIL",r,"1")+ebt("NG",r,"1")>0)=sam3(r,"33","70")*poilng*ebt("OIL",r,"1")/(poilng*ebt("OIL",r,"1")+ebt("NG",r,"1"));
sam3(r,"60","70")$(poilng*ebt("OIL",r,"1")+ebt("NG",r,"1")>0)=sam3(r,"33","70")*ebt("NG",r,"1")/(poilng*ebt("OIL",r,"1")+ebt("NG",r,"1"));
);
* X calibration
loop(r,
sam3(r,"33","71")$(poilng*ebt("OIL",r,"2")+ebt("NG",r,"2")>0)=sam3(r,"33","71")*poilng*ebt("OIL",r,"2")/(poilng*ebt("OIL",r,"2")+ebt("NG",r,"2"));
sam3(r,"60","71")$(poilng*ebt("OIL",r,"2")+ebt("NG",r,"2")>0)=sam3(r,"33","71")*ebt("NG",r,"2")/(poilng*ebt("OIL",r,"2")+ebt("NG",r,"2"));
);
* INV calibration

loop(r,
if(sam3(r,"73","33")>0,
sam3(r,"73","33")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")>0)=sam3(r,"73","33")*poilng*ebt("OIL",r,"36")/(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36"));
sam3(r,"73","60")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")>0)=sam3(r,"73","33")*ebt("NG",r,"36")/(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36"));
else
sam3(r,"33","73")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")>0)=sam3(r,"33","73")*poilng*ebt("OIL",r,"36")/(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36"));
sam3(r,"60","73")$(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36")>0)=sam3(r,"33","73")*ebt("NG",r,"36")/(poilng*ebt("OIL",r,"36")+ebt("NG",r,"36"));
);
);
* Capital formation calibration
loop(r,
sam3(r,"33","72")=sam3(r,"33","72")*poilng*oilngratio(r);
sam3(r,"60","72")=sam3(r,"33","72")*(1-poilng*oilngratio(r));
);
* HH and GOV calibration
loop(r,
sam3(r,"33","63")$(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35")>0)=sam3(r,"33","63")*poilng*ebt("OIL",r,"35")/(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35"));
sam3(r,"60","63")$(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35")>0)=sam3(r,"33","63")*ebt("NG",r,"35")/(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35"));
);
loop(r,
sam3(r,"33","65")$(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35")>0)=sam3(r,"33","65")*poilng*ebt("OIL",r,"35")/(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35"));
sam3(r,"60","65")$(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35")>0)=sam3(r,"33","65")*ebt("NG",r,"35")/(poilng*ebt("OIL",r,"35")+ebt("NG",r,"35"));
);
* Other sectors calibration
loop(r,
loop(j$((ord(j)>=1) and (ord(j)<=30)),
loop(ebti$(ord(ebti)=ord(j)+4),
sam3(r,"33",j)$(poilng*ebt("OIL",r,ebti)+ebt("NG",r,ebti)>0)=sam3(r,"33",j)*poilng*ebt("OIL",r,ebti)/(poilng*ebt("OIL",r,ebti)+ebt("NG",r,ebti));
sam3(r,"60",j)$(poilng*ebt("OIL",r,ebti)+ebt("NG",r,ebti)>0)=sam3(r,"33",j)*ebt("NG",r,ebti)/(poilng*ebt("OIL",r,ebti)+ebt("NG",r,ebti));
);
);
);
*COLUMN calibration
loop(r,
loop(i$((ord(i)>=31) and (ord(i)<=60)),
sam3(r,i,"33")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=sam3(r,i,"33")*poilng*ebt("OIL",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
sam3(r,i,"60")$(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37")>0)=sam3(r,i,"60")*ebt("NG",r,"37")/(poilng*ebt("OIL",r,"37")+ebt("NG",r,"37"));
);
);


*Calculation of sum of previous values
parameter allsamsum1,allsamsum2,changeofoutput;
allsamsum1=0;
allsamsum2=0;
loop(r,
loop(i,
loop(j,
sam2(r,i,j)=sam2(r,i,j)/100000;
allsamsum1=allsamsum1+sam2(r,i,j);
);
);
);
*Filter of small values
parameter incsparcity;
incsparcity=0;
loop(r,
loop(i,
loop(j,
if(sam2(r,i,j)<0.01,
sam2(r,i,j)=0;
);
allsamsum2=allsamsum2+sam2(r,i,j);
incsparcity=incsparcity+1;
);
);
);
changeofoutput=(allsamsum1-allsamsum2)/allsamsum1*100/2;
display changeofoutput
display incsparcity;
set     negval3(r,i,j)     Flag for negative elements;
set     empty3(r,i,*)      Flag for empty rows and columns;
parameter       chksam3(r,i,*)       Consistency check of social accounts;
*chksam
loop(r,
negval3(r,i,j) = yes$(sam3(r,i,j) < 0);

empty3(r,i,"row") = 1$(sum(j, sam3(r,i,j)) = 0);
empty3(r,j,"col") = 1$(sum(i, sam3(r,i,j)) = 0);

chksam3(r,i,"before") = sum(j, sam3(r,i,j)-sam3(r,j,i));
chksam3(r,i,"scale") = sum(j, sam3(r,j,i));
chksam3(r,i,"%dev")$sum(j, sam3(r,i,j)) = 100 * sum(j, sam3(r,i,j)-sam3(r,j,i)) / sum(j, sam3(r,i,j));

);



positive variables finalsam (r,i,j)
positive variables rowsum(r,i)
positive variables columnsum(r,i)
positive variables domesticinsum(i)
positive variables domesticoutsum(i)
positive variables p(r,i,j)
variable jj

Equations
        rsum
        csum
        sumbalance
        drcsum
        dxsum
        tradebalance
*       price_prod
*       price_dx
*       price_x
*       price_drc
*       price_rc
*       price_inv
*       price_fu
*       price_sectors

*        pricelb_prod
*       pricelb_dx
*       pricelb_x
*       pricelb_drc
*       pricelb_rc
*       pricelb_inv
*       pricelb_fu
*       pricelb_sectors

*        priceub_prod
*       priceub_dx
*       priceub_x
*       priceub_drc
*       priceub_rc
*       priceub_inv
*       priceub_fu
*       priceub_sectors
        obj
;



rsum(r,i)..
sum(j,finalsam(r,i,j))=e=rowsum(r,i);

csum(r,i)..
sum(j,finalsam(r,j,i))=e=columnsum(r,i);

sumbalance(r,i)..
rowsum(r,i)=e=columnsum(r,i);

drcsum(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticinsum(i)=e=sum(r,finalsam(r,"70",i));

dxsum(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticoutsum(i)=e=sum(r,finalsam(r,i,"70"));

tradebalance(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticinsum(i)=e=domesticoutsum(i);


$ontext
price_prod(r,i,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30))..
p(r,i,j)*ebt2(i,r,"37")=e=finalsam(r,i,j);
pricelb_prod(r,i,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30))..
p(r,i,j)=g=pricerange(i,"lb");
priceub_prod(r,i,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30))..
p(r,i,j)=l=pricerange(i,"ub");
$offtext


obj..
jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam3(r,i,j)))))/100000000000000;


Model gua /all/;
loop(r,
loop(i,
loop(j,
finalsam.l(r,i,j)=sam3(r,i,j);
);););
loop(r,
loop(i$((ord(i)<>32) and (ord(i)<>33) and (ord(i)<>41) and (ord(i)<>53) and (ord(i)<>54) and (ord(i)<>60)),
loop(j$((ord(j)<>32) and (ord(j)<>33) and (ord(j)<>41) and (ord(j)<>53) and (ord(j)<>54) and (ord(j)<>60)),
if (sam3(r,i,j)=0,
finalsam.fx(r,i,j)=0;
);
);
);
);
gua.iterlim=100000;
Solve gua minimizing jj using nlp;
display finalsam.l;
display rowsum.l;
display columnsum.l;
display domesticinsum.l;
display domesticoutsum.l;
