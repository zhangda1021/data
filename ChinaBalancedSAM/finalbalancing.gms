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




*$ontext
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
*        tradebalance
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


*rsum(r,i)..
rsum(r,i)$(sameas(r,'%prov%'))..
sum(j,finalsam(r,i,j))=e=rowsum(r,i);

*csum(r,i)..
csum(r,i)$(sameas(r,'%prov%'))..
sum(j,finalsam(r,j,i))=e=columnsum(r,i);

*sumbalance(r,i)..
sumbalance(r,i)$(sameas(r,'%prov%'))..
rowsum(r,i)=e=columnsum(r,i);

drcsum(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticinsum(i)=e=sum(r,finalsam(r,"70",i));

dxsum(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticoutsum(i)=e=sum(r,finalsam(r,i,"70"));

*tradebalance(i)$((ord(i)>=31) and (ord(i)<=60))..
*domesticinsum(i)=e=domesticoutsum(i);


$ONTEXT
price_prod(r,i,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30))..
p(r,i,j)*ebt2(i,r,"37")=e=finalsam(r,i,j);
pricelb_prod(r,i,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30))..
p(r,i,j)=g=pricerange(i,"lb");
priceub_prod(r,i,j)$(((ord(i)=2) or (ord(i)=3) or (ord(i)=11) or (ord(i)=23) or (ord(i)=24) or (ord(i)=30)) and (ord(j)=ord(i)+30))..
p(r,i,j)=l=pricerange(i,"ub");
$OFFTEXT


obj..
*jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam3(r,i,j)))));
jj=e=sum(r$(sameas(r,'%prov%')),sum(i,sum(j,sqr(finalsam(r,i,j)-sam3(r,i,j)))));

Model gua /all/;
loop(r,
loop(i,
loop(j,
finalsam.l(r,i,j)=sam3(r,i,j);
);););
loop(r,
loop(i,
loop(j,
if (sam3(r,i,j)=0,
finalsam.fx(r,i,j)=0;
);
);
);
);
gua.iterlim=100000;
Solve gua minimizing jj using nlp;
display finalsam.l;

*$offtext
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

