$ontext

This program is used to estimate energy consumption of energy intensive industries according data in provincial energy
balance tables and data in national data for energy intensive industries.

After this estimation, we can have the whole energy balance tables for each province.

$offtext

$if not set egyprod   $set egyprod COAL
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx\egygdx\'
$setlocal inputfolder2 '%projectfolder%\data\gdx\'

set     e       energy product  /
         coal    Coal,
         fg      Fuel gas,
         oil     Crude oil,
         roil    Refined oil,
         ng      Natural gas,
         eleh    Electricity & heat,
         othe    Other energy/;
set     alli    all accounts/
         AGR,
         COAL,
         OIL,
         MM,
         NM,
         FBT,
         TXT,
         CLO,
         LOG,
         PAP,
         ROIL,
         CHE,
         NMP,
         MSP,
         MP,
         GSM,
         TME,
         EME,
         CCE,
         IM,
         AC,
         WAS,
         ELEH,
         FG,
         WT,
         CON,
         TR,
         WRHR,
         OTH,
         FU,
         DX,
         X,
         DRC,
         RC,
         INV        /;
set     indi    egy-intensive sectors    /
         1       COAL,
         2       OIL,
         3       MM,
         4       NM,
         5       FBT,
         6       TXT,
         7       CLO,
         8       LOG,
         9       PAP,
         10      ROIL,
         11      CHE,
         12      NMP,
         13      MSP,
         14      MP,
         15      GSM,
         16      TME,
         17      EME,
         18      CCE,
         19      IM,
         20      AC,
         21      WAS,
         22      ELEH,
         23      FG,
         24      WT    /;
set     i       accounts /
         PROD    Production,
         DX      Domestic outflow,
         X       Export,
         DRC     Domestic inflow,
         RC      Import,
         COALT   Coal converted from other energy product,
         FGT     Fuel gas converted from other energy product,
         OILT    Crude oil converted from other energy product,
         ROILT   Refined oil converted from other energy product,
         NGT     Natural gas converted from other energy productconverted from other energy product,
         ELEHT   Electricity & heat converted from other energy product,
         OTHET   Other energy converted from other energy product,
         AGR     Agriculture,
         IND     Industry,
         CON     Construction,
         TR      Transportation,
         WRHR    Wholesale & retail & hotel & restraurant,
         OTH     Other service industry,
         FU      Final use,
         INV     Inventory change/;
*SAM table
set     sami   SAM rows and colums indices /
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
*Final energy balance table
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

alias (sami,samj);
alias (indi,indj);
set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
parameter coal(r,indi)           coal cons by intensive ind
parameter fg(r,indi)           fg cons by intensive ind
parameter oil(r,indi)           oil cons by intensive ind
parameter roil(r,indi)           roil cons by intensive ind
parameter ng(r,indi)           ng cons by intensive ind
parameter eleh(r,indi)           eleh cons by intensive ind
parameter othe(r,indi)           othe cons by intensive ind


parameter ind(indi,e)           egy cons of egy by intensive ind
parameter egyadjusted(r,i)                egy cons of egy product by province

parameter sam2(r,sami,samj)
parameter samind(r,indi,indj)
parameter samindtot(r,indi)

parameters egyind(r,indi) egy benchmark cons of egy intensive industries
parameters ebt(r,ebti)   final energy balance table
parameters oilngratio(r)

$if exist %inputfolder%\balance\%egyprod%_balance.gdx       $goto readdata
$log "Error -- cannot find %egyprod%'
$call pause 'Program will now abort.

$label readdata
$gdxin '%inputfolder%\balance\%egyprod%_balance.gdx'
$load egyadjusted
display egyadjusted
$gdxin '%inputfolder%\ind.gdx'
$load ind
display ind
$gdxin '%inputfolder2%\aggregation.gdx'
$load sam2
display sam2
$gdxin '%inputfolder%\oilgasratio.gdx'
$load oilngratio
display oilngratio
*sam data from sam2 is transferred to samind
loop(r,
loop(sami$((ord(sami) ge 32) and (ord(sami) le 55)),
loop(samj$((ord(samj) ge 2) and (ord(samj) le 25)),
loop(indi$(ord(indi)=ord(sami)-31),
loop(indj$(ord(indj)=ord(samj)-1),
samind(r,indi,indj)=sam2(r,sami,samj);
);
);
);
);
);
display samind


loop(r,
loop(indi,
samindtot(r,indi)=sum(indj,samind(r,indi,indj));
);
);

loop(r,
loop(indi,
egyind(r,indi)$(sameas('%egyprod%','COAL'))= egyadjusted(r,"IND")*samind(r,"1",indi)/samindtot(r,"1");
););
loop(r,
loop(indi,
egyind(r,indi)$(sameas('%egyprod%','OIL'))= egyadjusted(r,"IND")*samind(r,"2",indi)/samindtot(r,"2");
););
loop(r,
loop(indi,
egyind(r,indi)$(sameas('%egyprod%','NG'))= egyadjusted(r,"IND")*samind(r,"2",indi)/samindtot(r,"2");
););
loop(r,
loop(indi,
egyind(r,indi)$(sameas('%egyprod%','ROIL'))= egyadjusted(r,"IND")*samind(r,"10",indi)/samindtot(r,"10");
););
loop(r,
loop(indi,
egyind(r,indi)$(sameas('%egyprod%','FG'))= egyadjusted(r,"IND")*samind(r,"23",indi)/samindtot(r,"23");
););
loop(r,
loop(indi,
egyind(r,indi)$(sameas('%egyprod%','ELEH'))= egyadjusted(r,"IND")*samind(r,"22",indi)/samindtot(r,"22");
););
loop(r,
loop(indi,
egyind(r,indi)$(sameas('%egyprod%','OTHE'))= egyadjusted(r,"IND")*samind(r,"22",indi)/samindtot(r,"22");
););


positive variables egyindi(r,indi) estimated egy cons of egy intensive industries
*positive variables p(r,indi) price of estimated egy
variables j      obj function
*variables pavg(r)


Equations criterion_row
          criterion_column
*          criterion_pcoal
*          criterion_poil
*          criterion_png
*          criterion_proil
*          criterion_pfg
*          criterion_peleh
*          criterion_pothe
*          paverage
          obj
;

criterion_row(indi)$(not sameas('%egyprod%','OTHE'))..
sum(r,egyindi(r,indi))=e=ind(indi,'%egyprod%');
criterion_column(r)..
sum(indi,egyindi(r,indi))=e=egyadjusted(r,"IND");

$ontext
criterion_pcoal(r,indi)$(sameas('%egyprod%','COAL'))..
p(r,indi)*egyindi(r,indi)=e=samind(r,"2",indi);
*Here we assume that the ratios of oil and gas consumption are identical for energy intensive industries
criterion_poil(r,indi)$(sameas('%egyprod%','OIL'))..
p(r,indi)*egyindi(r,indi)=e=samind(r,"3",indi);
criterion_png(r,indi)$(sameas('%egyprod%','NG'))..
p(r,indi)*egyindi(r,indi)=e=samind(r,"3",indi);
criterion_proil(r,indi)$(sameas('%egyprod%','ROIL'))..
p(r,indi)*egyindi(r,indi)=e=samind(r,"10",indi);
criterion_pfg(r,indi)$(sameas('%egyprod%','FG'))..
p(r,indi)*egyindi(r,indi)=e=samind(r,"23",indi);
*Here we assume that the ratios of electricity & heat and other energy consumption are identical for energy intensive industries
criterion_peleh(r,indi)$(sameas('%egyprod%','ELEH'))..
p(r,indi)*egyindi(r,indi)=e=samind(r,"22",indi);
criterion_pothe(r,indi)$(sameas('%egyprod%','OTHE'))..
p(r,indi)*egyindi(r,indi)=e=samind(r,"22",indi);
paverage(r)..
pavg(r)=e=sum(indi$(egyindi(r,indi)<>0),p(r,indi))/card(indi);
$offtext

obj..
j=e=sum(r,sum(indi,sqr(egyindi(r,indi)-egyind(r,indi))/100));


Model gua /all/;
loop(r,
loop(indi,
samindtot(r,indi)=sum(indj,samind(r,indi,indj));
);
);

egyindi.l(r,indi)$(sameas('%egyprod%','COAL'))= egyadjusted(r,"IND")*samind(r,"1",indi)/samindtot(r,"1");
egyindi.l(r,indi)$(sameas('%egyprod%','OIL'))= egyadjusted(r,"IND")*samind(r,"2",indi)/samindtot(r,"2");
egyindi.l(r,indi)$(sameas('%egyprod%','NG'))= egyadjusted(r,"IND")*samind(r,"2",indi)/samindtot(r,"2");
egyindi.l(r,indi)$(sameas('%egyprod%','ROIL'))= egyadjusted(r,"IND")*samind(r,"10",indi)/samindtot(r,"10");
egyindi.l(r,indi)$(sameas('%egyprod%','FG'))= egyadjusted(r,"IND")*samind(r,"23",indi)/samindtot(r,"23");
egyindi.l(r,indi)$(sameas('%egyprod%','ELEH'))= egyadjusted(r,"IND")*samind(r,"22",indi)/samindtot(r,"22");
egyindi.l(r,indi)$(sameas('%egyprod%','OTHE'))= egyadjusted(r,"IND")*samind(r,"22",indi)/samindtot(r,"22");


Display egyindi.l;
egyindi.fx(r,indi)$(sameas('%egyprod%','COAL') and abs(samind(r,"1",indi))<0.0001) = 0;
egyindi.fx(r,indi)$(sameas('%egyprod%','OIL') and abs(samind(r,"2",indi))<0.0001) = 0;
egyindi.fx(r,indi)$(sameas('%egyprod%','NG') and abs(samind(r,"2",indi))<0.0001) = 0;
egyindi.fx(r,indi)$(sameas('%egyprod%','ROIL') and abs(samind(r,"10",indi))<0.0001) = 0;
egyindi.fx(r,indi)$(sameas('%egyprod%','FG') and abs(samind(r,"23",indi))<0.0001) = 0;
egyindi.fx(r,indi)$(sameas('%egyprod%','ELEH') and abs(samind(r,"22",indi))<0.0001) = 0;
egyindi.fx(r,indi)$(sameas('%egyprod%','OTHE') and abs(samind(r,"22",indi))<0.0001) = 0;

gua.iterlim=1000;
Solve gua minimizing j using nlp;
loop(r,
loop(ebti,
ebt(r,ebti)=0;
););
*ebt_coal
if((sameas('%egyprod%','COAL')),
loop(r,
loop(ebti,
if ((ord(ebti)=37),
loop(i$((sameas(i,'PROD')) or (sameas(i,'COALT'))),
ebt(r,"37")=ebt(r,"37")+egyadjusted(r,i);
););
if ((ord(ebti)=1),
loop(i$((sameas(i,'DX'))),
ebt(r,"1")=egyadjusted(r,i);
););
if ((ord(ebti)=2),
loop(i$((sameas(i,'X'))),
ebt(r,"2")=egyadjusted(r,i);
););
if ((ord(ebti)=3),
loop(i$((sameas(i,'DRC'))),
ebt(r,"3")=egyadjusted(r,i);
););
if ((ord(ebti)=4),
loop(i$((sameas(i,'RC')) ),
ebt(r,"4")=egyadjusted(r,i);
););
if ((ord(ebti)=5),
loop(i$((sameas(i,'AGR')) ),
ebt(r,"5")=egyadjusted(r,i);
););
if (((ord(ebti)=6)  or (ord(ebti)=8) or (ord(ebti)=9) or (ord(ebti)=10) or (ord(ebti)=11) or (ord(ebti)=12) or (ord(ebti)=13) or (ord(ebti)=14) or (ord(ebti)=16) or (ord(ebti)=17) or  (ord(ebti)=18) or (ord(ebti)=19) or (ord(ebti)=20) or (ord(ebti)=21) or (ord(ebti)=22) or (ord(ebti)=23) or (ord(ebti)=24) or (ord(ebti)=25) or (ord(ebti)=26) or (ord(ebti)=29)),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,ebti)=egyindi.l(r,indi);
););
if ((ord(ebti)=7),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"7")=egyindi.l(r,indi)*oilngratio(r);
););
if ((ord(ebti)=15),
loop(i$((sameas(i,'ROILT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"15")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=27),
loop(i$((sameas(i,'ELEHT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"27")=egyadjusted(r,i)+egyindi.l(r,indi);););

);
if ((ord(ebti)=28),
loop(i$((sameas(i,'FGT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"28")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=30),
loop(i$((sameas(i,'CON')) ),
ebt(r,"30")=egyadjusted(r,i);
););
if ((ord(ebti)=31),
loop(i$((sameas(i,'TR')) ),
ebt(r,"31")=egyadjusted(r,i);
););
if ((ord(ebti)=32),
loop(i$((sameas(i,'WRHR')) ),
ebt(r,"32")=egyadjusted(r,i);
););
if ((ord(ebti)=33),
loop(i$((sameas(i,'OTH')) ),
ebt(r,"33")=egyadjusted(r,i);
););
if ((ord(ebti)=34),
loop(indi$(ord(indi)=ord(ebti)-32),
ebt(r,"34")=egyindi.l(r,indi)*(1-oilngratio(r));
););
if ((ord(ebti)=35),
loop(i$((sameas(i,'FU')) ),
ebt(r,"35")=egyadjusted(r,i);
););
if ((ord(ebti)=36),
loop(i$((sameas(i,'INV')) ),
ebt(r,"36")=egyadjusted(r,i);
););
););
);

*ebt_fg
if((sameas('%egyprod%','FG')),
loop(r,
loop(ebti,
*Production of fuel gas (if consumption in refined oil transformation sector is negative, we add the absolute value to production)
if ((ord(ebti)=37),
loop(i$((sameas(i,'PROD')) or (sameas(i,'FGT'))),
ebt(r,"37")=ebt(r,"37")+egyadjusted(r,i);
);
loop(i$(sameas(i,'ROILT')),
ebt(r,"37")=ebt(r,"37")-egyadjusted(r,i)$(egyadjusted(r,i)<0);
);
);
if ((ord(ebti)=1),
loop(i$((sameas(i,'DX'))),
ebt(r,"1")=egyadjusted(r,i);
););
if ((ord(ebti)=2),
loop(i$((sameas(i,'X'))),
ebt(r,"2")=egyadjusted(r,i);
););
if ((ord(ebti)=3),
loop(i$((sameas(i,'DRC'))),
ebt(r,"3")=egyadjusted(r,i);
););
if ((ord(ebti)=4),
loop(i$((sameas(i,'RC')) ),
ebt(r,"4")=egyadjusted(r,i);
););
if ((ord(ebti)=5),
loop(i$((sameas(i,'AGR')) ),
ebt(r,"5")=egyadjusted(r,i);
););
if ((ord(ebti)=6),
loop(i$((sameas(i,'COALT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"6")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if (((ord(ebti)=8) or (ord(ebti)=9) or (ord(ebti)=10) or (ord(ebti)=11) or (ord(ebti)=12) or (ord(ebti)=13) or (ord(ebti)=14) or (ord(ebti)=16) or (ord(ebti)=17) or  (ord(ebti)=18) or (ord(ebti)=19) or (ord(ebti)=20) or (ord(ebti)=21) or (ord(ebti)=22) or (ord(ebti)=23) or (ord(ebti)=24) or (ord(ebti)=25) or (ord(ebti)=26) or (ord(ebti)=29)),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,ebti)=egyindi.l(r,indi);
););
if ((ord(ebti)=7),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"7")=egyindi.l(r,indi)*oilngratio(r);
););
*set the negative value to zero
if ((ord(ebti)=15),
loop(i$((sameas(i,'ROILT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"15")=egyadjusted(r,i)$(egyadjusted(r,i)>=0)+egyindi.l(r,indi);
);
););

if ((ord(ebti)=27),
loop(i$((sameas(i,'ELEHT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"27")=egyadjusted(r,i)+egyindi.l(r,indi);););
);
if ((ord(ebti)=28),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"28")=egyindi.l(r,indi);
););
if ((ord(ebti)=30),
loop(i$((sameas(i,'CON')) ),
ebt(r,"30")=egyadjusted(r,i);
););
if ((ord(ebti)=31),
loop(i$((sameas(i,'TR')) ),
ebt(r,"31")=egyadjusted(r,i);
););
if ((ord(ebti)=32),
loop(i$((sameas(i,'WRHR')) ),
ebt(r,"32")=egyadjusted(r,i);
););
if ((ord(ebti)=33),
loop(i$((sameas(i,'OTH')) ),
ebt(r,"33")=egyadjusted(r,i);
););
if ((ord(ebti)=34),
loop(indi$(ord(indi)=ord(ebti)-32),
ebt(r,"34")=egyindi.l(r,indi)*(1-oilngratio(r));
););
if ((ord(ebti)=35),
loop(i$((sameas(i,'FU')) ),
ebt(r,"35")=egyadjusted(r,i);
););
if ((ord(ebti)=36),
loop(i$((sameas(i,'INV')) ),
ebt(r,"36")=egyadjusted(r,i);
););
););
);

*ebt_oil
if((sameas('%egyprod%','OIL')),
loop(r,
loop(ebti,
if ((ord(ebti)=37),
loop(i$((sameas(i,'PROD')) or (sameas(i,'OILT'))),
ebt(r,"37")=ebt(r,"37")+egyadjusted(r,i);
););
if ((ord(ebti)=1),
loop(i$((sameas(i,'DX'))),
ebt(r,"1")=egyadjusted(r,i);
););
if ((ord(ebti)=2),
loop(i$((sameas(i,'X'))),
ebt(r,"2")=egyadjusted(r,i);
););
if ((ord(ebti)=3),
loop(i$((sameas(i,'DRC'))),
ebt(r,"3")=egyadjusted(r,i);
););
if ((ord(ebti)=4),
loop(i$((sameas(i,'RC')) ),
ebt(r,"4")=egyadjusted(r,i);
););
if ((ord(ebti)=5),
loop(i$((sameas(i,'AGR')) ),
ebt(r,"5")=egyadjusted(r,i);
););
if ((ord(ebti)=6),
loop(i$((sameas(i,'COALT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"6")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if (((ord(ebti)=8) or (ord(ebti)=9) or (ord(ebti)=10) or (ord(ebti)=11) or (ord(ebti)=12) or (ord(ebti)=13) or (ord(ebti)=14) or (ord(ebti)=16) or (ord(ebti)=17) or  (ord(ebti)=18) or (ord(ebti)=19) or (ord(ebti)=20) or (ord(ebti)=21) or (ord(ebti)=22) or (ord(ebti)=23) or (ord(ebti)=24) or (ord(ebti)=25) or (ord(ebti)=26) or (ord(ebti)=29)),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,ebti)=egyindi.l(r,indi);
););
if ((ord(ebti)=7),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"7")=egyindi.l(r,indi)*oilngratio(r);
););
if ((ord(ebti)=15),
loop(i$((sameas(i,'ROILT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"15")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=27),
loop(i$((sameas(i,'ELEHT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"27")=egyadjusted(r,i)+egyindi.l(r,indi);););
);
if ((ord(ebti)=28),
loop(i$((sameas(i,'FGT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"28")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=30),
loop(i$((sameas(i,'CON')) ),
ebt(r,"30")=egyadjusted(r,i);
););
if ((ord(ebti)=31),
loop(i$((sameas(i,'TR')) ),
ebt(r,"31")=egyadjusted(r,i);
););
if ((ord(ebti)=32),
loop(i$((sameas(i,'WRHR')) ),
ebt(r,"32")=egyadjusted(r,i);
););
if ((ord(ebti)=33),
loop(i$((sameas(i,'OTH')) ),
ebt(r,"33")=egyadjusted(r,i);
););
if ((ord(ebti)=34),
loop(indi$(ord(indi)=ord(ebti)-32),
ebt(r,"34")=egyindi.l(r,indi)*(1-oilngratio(r));
););
if ((ord(ebti)=35),
loop(i$((sameas(i,'FU')) ),
ebt(r,"35")=egyadjusted(r,i);
););
if ((ord(ebti)=36),
loop(i$((sameas(i,'INV')) ),
ebt(r,"36")=egyadjusted(r,i);
););
););
);

*ebt_roil
if((sameas('%egyprod%','ROIL')),
loop(r,
loop(ebti,
*If the consumption of roil in fgt sector is negative, we add the abs value to roil production
if ((ord(ebti)=37),
loop(i$((sameas(i,'PROD')) or (sameas(i,'ROILT'))),
ebt(r,"37")=ebt(r,"37")+egyadjusted(r,i);
);
loop(i$((sameas(i,'FGT'))),
ebt(r,"37")=ebt(r,"37")-egyadjusted(r,i)$(egyadjusted(r,i)<0);
);
);
if ((ord(ebti)=1),
loop(i$((sameas(i,'DX'))),
ebt(r,"1")=egyadjusted(r,i);
););
if ((ord(ebti)=2),
loop(i$((sameas(i,'X'))),
ebt(r,"2")=egyadjusted(r,i);
););
if ((ord(ebti)=3),
loop(i$((sameas(i,'DRC'))),
ebt(r,"3")=egyadjusted(r,i);
););
if ((ord(ebti)=4),
loop(i$((sameas(i,'RC')) ),
ebt(r,"4")=egyadjusted(r,i);
););
if ((ord(ebti)=5),
loop(i$((sameas(i,'AGR')) ),
ebt(r,"5")=egyadjusted(r,i);
););
if ((ord(ebti)=6),
loop(i$((sameas(i,'COALT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"6")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if (((ord(ebti)=8) or (ord(ebti)=9) or (ord(ebti)=10) or (ord(ebti)=11) or (ord(ebti)=12) or (ord(ebti)=13) or (ord(ebti)=14) or (ord(ebti)=16) or (ord(ebti)=17) or  (ord(ebti)=18) or (ord(ebti)=19) or (ord(ebti)=20) or (ord(ebti)=21) or (ord(ebti)=22) or (ord(ebti)=23) or (ord(ebti)=24) or (ord(ebti)=25) or (ord(ebti)=26) or (ord(ebti)=29)),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,ebti)=egyindi.l(r,indi);
););
if ((ord(ebti)=7),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"7")=egyindi.l(r,indi)*oilngratio(r);
););
if ((ord(ebti)=15),

loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"15")=egyindi.l(r,indi);
););
if ((ord(ebti)=27),
loop(i$((sameas(i,'ELEHT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"27")=egyadjusted(r,i)+egyindi.l(r,indi);););
);
*We exclude the production in FGT from the calculation of roil consumption in FG sector
if ((ord(ebti)=28),
loop(i$((sameas(i,'FGT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"28")=egyadjusted(r,i)$(egyadjusted(r,i)>=0)+egyindi.l(r,indi);
);););
if ((ord(ebti)=30),
loop(i$((sameas(i,'CON')) ),
ebt(r,"30")=egyadjusted(r,i);
););
if ((ord(ebti)=31),
loop(i$((sameas(i,'TR')) ),
ebt(r,"31")=egyadjusted(r,i);
););
if ((ord(ebti)=32),
loop(i$((sameas(i,'WRHR')) ),
ebt(r,"32")=egyadjusted(r,i);
););
if ((ord(ebti)=33),
loop(i$((sameas(i,'OTH')) ),
ebt(r,"33")=egyadjusted(r,i);
););
if ((ord(ebti)=34),
loop(indi$(ord(indi)=ord(ebti)-32),
ebt(r,"34")=egyindi.l(r,indi)*(1-oilngratio(r));
););
if ((ord(ebti)=35),
loop(i$((sameas(i,'FU')) ),
ebt(r,"35")=egyadjusted(r,i);
););
if ((ord(ebti)=36),
loop(i$((sameas(i,'INV')) ),
ebt(r,"36")=egyadjusted(r,i);
););
););
);

*ebt_ng
if((sameas('%egyprod%','NG')),
loop(r,
loop(ebti,
if ((ord(ebti)=37),
loop(i$((sameas(i,'PROD')) or (sameas(i,'NGT'))),
ebt(r,"37")=ebt(r,"37")+egyadjusted(r,i);
););
if ((ord(ebti)=1),
loop(i$((sameas(i,'DX'))),
ebt(r,"1")=egyadjusted(r,i);
););
if ((ord(ebti)=2),
loop(i$((sameas(i,'X'))),
ebt(r,"2")=egyadjusted(r,i);
););
if ((ord(ebti)=3),
loop(i$((sameas(i,'DRC'))),
ebt(r,"3")=egyadjusted(r,i);
););
if ((ord(ebti)=4),
loop(i$((sameas(i,'RC')) ),
ebt(r,"4")=egyadjusted(r,i);
););
if ((ord(ebti)=5),
loop(i$((sameas(i,'AGR')) ),
ebt(r,"5")=egyadjusted(r,i);
););
if ((ord(ebti)=6),
loop(i$((sameas(i,'COALT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"6")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if (((ord(ebti)=8) or (ord(ebti)=9) or (ord(ebti)=10) or (ord(ebti)=11) or (ord(ebti)=12) or (ord(ebti)=13) or (ord(ebti)=14) or (ord(ebti)=16) or (ord(ebti)=17) or  (ord(ebti)=18) or (ord(ebti)=19) or (ord(ebti)=20) or (ord(ebti)=21) or (ord(ebti)=22) or (ord(ebti)=23) or (ord(ebti)=24) or (ord(ebti)=25) or (ord(ebti)=26) or (ord(ebti)=29)),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,ebti)=egyindi.l(r,indi);
););
if ((ord(ebti)=7),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"7")=egyindi.l(r,indi)*oilngratio(r);
););
if ((ord(ebti)=15),
loop(i$((sameas(i,'ROILT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"15")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=27),
loop(i$((sameas(i,'ELEHT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"27")=egyadjusted(r,i)+egyindi.l(r,indi);););
);
if ((ord(ebti)=28),
loop(i$((sameas(i,'FGT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"28")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=30),
loop(i$((sameas(i,'CON')) ),
ebt(r,"30")=egyadjusted(r,i);
););
if ((ord(ebti)=31),
loop(i$((sameas(i,'TR')) ),
ebt(r,"31")=egyadjusted(r,i);
););
if ((ord(ebti)=32),
loop(i$((sameas(i,'WRHR')) ),
ebt(r,"32")=egyadjusted(r,i);
););
if ((ord(ebti)=33),
loop(i$((sameas(i,'OTH')) ),
ebt(r,"33")=egyadjusted(r,i);
););
if ((ord(ebti)=34),
loop(indi$(ord(indi)=ord(ebti)-32),
ebt(r,"34")=egyindi.l(r,indi)*(1-oilngratio(r));
););
if ((ord(ebti)=35),
loop(i$((sameas(i,'FU')) ),
ebt(r,"35")=egyadjusted(r,i);
););
if ((ord(ebti)=36),
loop(i$((sameas(i,'INV')) ),
ebt(r,"36")=egyadjusted(r,i);
););
););
);

*ebt_eleh
if((sameas('%egyprod%','ELEH')),
loop(r,
loop(ebti,
if ((ord(ebti)=37),
loop(i$((sameas(i,'PROD')) or (sameas(i,'ELEHT'))),
ebt(r,"37")=ebt(r,"37")+egyadjusted(r,i);
););
if ((ord(ebti)=1),
loop(i$((sameas(i,'DX'))),
ebt(r,"1")=egyadjusted(r,i);
););
if ((ord(ebti)=2),
loop(i$((sameas(i,'X'))),
ebt(r,"2")=egyadjusted(r,i);
););
if ((ord(ebti)=3),
loop(i$((sameas(i,'DRC'))),
ebt(r,"3")=egyadjusted(r,i);
););
if ((ord(ebti)=4),
loop(i$((sameas(i,'RC')) ),
ebt(r,"4")=egyadjusted(r,i);
););
if ((ord(ebti)=5),
loop(i$((sameas(i,'AGR')) ),
ebt(r,"5")=egyadjusted(r,i);
););
if ((ord(ebti)=6),
loop(i$((sameas(i,'COALT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"6")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if (((ord(ebti)=8) or (ord(ebti)=9) or (ord(ebti)=10) or (ord(ebti)=11) or (ord(ebti)=12) or (ord(ebti)=13) or (ord(ebti)=14) or (ord(ebti)=16) or (ord(ebti)=17) or  (ord(ebti)=18) or (ord(ebti)=19) or (ord(ebti)=20) or (ord(ebti)=21) or (ord(ebti)=22) or (ord(ebti)=23) or (ord(ebti)=24) or (ord(ebti)=25) or (ord(ebti)=26) or (ord(ebti)=29)),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,ebti)=egyindi.l(r,indi);
););
if ((ord(ebti)=7),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"7")=egyindi.l(r,indi)*oilngratio(r);
););
if ((ord(ebti)=15),
loop(i$((sameas(i,'ROILT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"15")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=27),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"27")=egyindi.l(r,indi););
);
if ((ord(ebti)=28),
loop(i$((sameas(i,'FGT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"28")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=30),
loop(i$((sameas(i,'CON')) ),
ebt(r,"30")=egyadjusted(r,i);
););
if ((ord(ebti)=31),
loop(i$((sameas(i,'TR')) ),
ebt(r,"31")=egyadjusted(r,i);
););
if ((ord(ebti)=32),
loop(i$((sameas(i,'WRHR')) ),
ebt(r,"32")=egyadjusted(r,i);
););
if ((ord(ebti)=33),
loop(i$((sameas(i,'OTH')) ),
ebt(r,"33")=egyadjusted(r,i);
););
if ((ord(ebti)=34),
loop(indi$(ord(indi)=ord(ebti)-32),
ebt(r,"34")=egyindi.l(r,indi)*(1-oilngratio(r));
););
if ((ord(ebti)=35),
loop(i$((sameas(i,'FU')) ),
ebt(r,"35")=egyadjusted(r,i);
););
if ((ord(ebti)=36),
loop(i$((sameas(i,'INV')) ),
ebt(r,"36")=egyadjusted(r,i);
););
););
);

*ebt_othe
if((sameas('%egyprod%','OTHE')),
loop(r,
loop(ebti,
if ((ord(ebti)=37),
loop(i$((sameas(i,'PROD')) or (sameas(i,'OTHET'))),
ebt(r,"37")=ebt(r,"37")+egyadjusted(r,i);
););
if ((ord(ebti)=1),
loop(i$((sameas(i,'DX'))),
ebt(r,"1")=egyadjusted(r,i);
););
if ((ord(ebti)=2),
loop(i$((sameas(i,'X'))),
ebt(r,"2")=egyadjusted(r,i);
););
if ((ord(ebti)=3),
loop(i$((sameas(i,'DRC'))),
ebt(r,"3")=egyadjusted(r,i);
););
if ((ord(ebti)=4),
loop(i$((sameas(i,'RC')) ),
ebt(r,"4")=egyadjusted(r,i);
););
if ((ord(ebti)=5),
loop(i$((sameas(i,'AGR')) ),
ebt(r,"5")=egyadjusted(r,i);
););
if ((ord(ebti)=6),
loop(i$((sameas(i,'COALT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"6")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if (((ord(ebti)=8) or (ord(ebti)=9) or (ord(ebti)=10) or (ord(ebti)=11) or (ord(ebti)=12) or (ord(ebti)=13) or (ord(ebti)=14) or (ord(ebti)=16) or (ord(ebti)=17) or  (ord(ebti)=18) or (ord(ebti)=19) or (ord(ebti)=20) or (ord(ebti)=21) or (ord(ebti)=22) or (ord(ebti)=23) or (ord(ebti)=24) or (ord(ebti)=25) or (ord(ebti)=26) or (ord(ebti)=29)),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,ebti)=egyindi.l(r,indi);
););
if ((ord(ebti)=7),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"7")=egyindi.l(r,indi)*oilngratio(r);
););
if ((ord(ebti)=15),
loop(i$((sameas(i,'ROILT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"15")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=27),
loop(i$((sameas(i,'ELEHT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"27")=egyadjusted(r,i)+egyindi.l(r,indi);););
);
if ((ord(ebti)=28),
loop(i$((sameas(i,'FGT'))),
loop(indi$(ord(indi)=ord(ebti)-5),
ebt(r,"28")=egyadjusted(r,i)+egyindi.l(r,indi);
);););
if ((ord(ebti)=30),
loop(i$((sameas(i,'CON')) ),
ebt(r,"30")=egyadjusted(r,i);
););
if ((ord(ebti)=31),
loop(i$((sameas(i,'TR')) ),
ebt(r,"31")=egyadjusted(r,i);
););
if ((ord(ebti)=32),
loop(i$((sameas(i,'WRHR')) ),
ebt(r,"32")=egyadjusted(r,i);
););
if ((ord(ebti)=33),
loop(i$((sameas(i,'OTH')) ),
ebt(r,"33")=egyadjusted(r,i);
););
if ((ord(ebti)=34),
loop(indi$(ord(indi)=ord(ebti)-32),
ebt(r,"34")=egyindi.l(r,indi)*(1-oilngratio(r));
););
if ((ord(ebti)=35),
loop(i$((sameas(i,'FU')) ),
ebt(r,"35")=egyadjusted(r,i);
););
if ((ord(ebti)=36),
loop(i$((sameas(i,'INV')) ),
ebt(r,"36")=egyadjusted(r,i);
););
););
);
