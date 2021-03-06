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
parameter sam3(r,i,j)           SAM v3.0 ready for rebalancing
parameter ebt(e,r,ebti)         EBT
parameter ebt2(i,r,ebti)        EBT for OPT
parameter pricerange(i,prange)  Price range of energy products
parameter oilngratio(r)         Oil and gas ratio of (PROD+DRC+RC-X-DX)
parameter poilng
$gdxin '%inputfolder1%/sam3.gdx'
$load sam3
$load ebt2
$load pricerange

loop(i,
loop(r,
loop(ebti,
ebt2(i,r,ebti)=ebt2(i,r,ebti)/1000;
);););


*$ontext
positive variables finalsam (r,i,j)
positive variables rowsum(r,i)
positive variables columnsum(r,i)
positive variables domesticinsum(i)
positive variables domesticoutsum(i)
positive variables p(i,r,ebti)
variable jj

Equations
        rsum
        csum
        sumbalance

       price_dx
       price_x
       price_drc
       price_rc
       price_inv
       price_fu
       price_prod
       price_sectors

       pricelb

       priceub
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

*dx
price_dx(i,r,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30) and sameas(r,'%prov%'))..
(p(i,r,"1")*ebt2(i,r,"1")-finalsam(r,j,"70"))*finalsam(r,j,"70")=e=0;
*x
price_x(i,r,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30) and sameas(r,'%prov%'))..
(p(i,r,"2")*ebt2(i,r,"2")-finalsam(r,j,"71"))*finalsam(r,j,"71")=e=0;
*drc
price_drc(i,r,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30) and sameas(r,'%prov%'))..
(p(i,r,"3")*ebt2(i,r,"3")-finalsam(r,"70",j))*finalsam(r,"70",j)=e=0;
*rc
price_rc(i,r,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30) and sameas(r,'%prov%'))..
(p(i,r,"4")*ebt2(i,r,"4")-finalsam(r,"71",j))*finalsam(r,"71",j)=e=0;
*fu
price_fu(i,r,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30) and sameas(r,'%prov%'))..
(p(i,r,"35")*ebt2(i,r,"35")-(finalsam(r,j,"63")+finalsam(r,j,"65")))*(finalsam(r,j,"63")+finalsam(r,j,"65"))=e=0;
*inv
price_inv(i,r,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30) and sameas(r,'%prov%'))..
(p(i,r,"36")*ebt2(i,r,"36")-finalsam(r,j,"73"))*finalsam(r,j,"73")=e=0;
*prod
price_prod(i,r,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30) and sameas(r,'%prov%'))..
(p(i,r,"37")*ebt2(i,r,"37")-finalsam(r,i,j))*finalsam(r,i,j)=e=0;

*$ontext
*sectors
price_sectors(i,r,j,ebti,ii)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30) and ((ord(ebti)>=5) and (ord(ebti)<=34)) and (ord(ii)=ord(ebti)-4) and sameas(r,'%prov%'))..
(p(i,r,ebti)*ebt2(i,r,ebti)-finalsam(r,j,ii))*finalsam(r,j,ii)=e=0;
*$offtext

*lb
pricelb(i,r,ebti)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and ((ord(ebti)>=1) and (ord(ebti)<=37)) and sameas(r,'%prov%'))..
(p(i,r,ebti)-pricerange(i,"lb")/10000000)=g=0;
*ub
priceub(i,r,ebti)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and ((ord(ebti)>=1) and (ord(ebti)<=37)) and sameas(r,'%prov%'))..
(p(i,r,ebti)-pricerange(i,"ub")/10)=l=0;

obj..
jj=e=sum(r$(sameas(r,'%prov%')),sum(i,sum(j,sqr(finalsam(r,i,j)-sam3(r,i,j)))));

Model gua /all/;
loop(r$(sameas(r,'%prov%')),
loop(i,
loop(j,
finalsam.l(r,i,j)=sam3(r,i,j);
);););
loop(i,
loop(r$(sameas(r,'%prov%')),
loop(ebti,
if(sameas(i,"2"),
p.l("2",r,ebti)=500/100;
);
if(sameas(i,"3"),
p.l("3",r,ebti)=3000/100;
);
if(sameas(i,"11"),
p.l("11",r,ebti)=3000/100;
);
if(sameas(i,"23"),
p.l("23",r,ebti)=1000/100;
);
if(sameas(i,"24"),
p.l("24",r,ebti)=5000/100;
);
if(sameas(i,"30"),
p.l("30",r,ebti)=1000/100;
);
);););
*If quantity is not zero, value is not zero
loop(r$(sameas(r,'%prov%')),
loop(i$((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)),
loop(j$(ord(j)=ord(i)+30),
if(ebt2(i,r,"1")>0,
finalsam.l(r,j,"70")=p.l(i,r,"1")*ebt2(i,r,"1")/100;
);
if(ebt2(i,r,"2")>0,
finalsam.l(r,j,"71")=p.l(i,r,"2")*ebt2(i,r,"2")/100;
);
if(ebt2(i,r,"3")>0,
finalsam.l(r,"70",j)=p.l(i,r,"3")*ebt2(i,r,"3")/100;
);
if(ebt2(i,r,"4")>0,
finalsam.l(r,"71",j)=p.l(i,r,"4")*ebt2(i,r,"4")/100;
);
if(ebt2(i,r,"35")>0,
finalsam.l(r,j,"63")=p.l(i,r,"35")*ebt2(i,r,"35")/2/100;
finalsam.l(r,j,"65")=p.l(i,r,"35")*ebt2(i,r,"35")/2/100;
);
if(ebt2(i,r,"36")>0,
finalsam.l(r,j,"73")=p.l(i,r,"36")*ebt2(i,r,"36")/100;
);
if(ebt2(i,r,"37")>0,
finalsam.l(r,i,j)=p.l(i,r,"37")*ebt2(i,r,"37")/100;
);

loop(ebti$((ord(ebti)>=5) and (ord(ebti)<=34)),
loop(ii$(ord(ii)=ord(ebti)-4),
if(ebt2(i,r,ebti)>0,
finalsam.l(r,j,ii)=p.l(i,r,ebti)*ebt2(i,r,ebti)/100;
);
);
);
);););
*Fix sparcity
loop(r$(sameas(r,'%prov%')),
loop(i,
loop(j,
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
negval4(i,j) = yes$(sam3(r,i,j) < 0);
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


