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
         1       PROD,
         2       DX,
         3       X,
         4       DRC,
         5       RC,
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
         36      INV
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
positive variables p(r,indi) price of estimated egy
variables j      obj function
variables pavg(r)


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

criterion_row(indi)..
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

if((sameas('%egyprod%','COAL')),
loop(r,
loop(ebi,

if ((ord(ebi)=1),
loop(i$((sameas(i,'PROD')) or (sameas(i,'COALT'))),
ebt(r,"1")=ebt(r,"1")+egyadjusted(r,i);
););
if ((ord(ebi)=2),
loop(i$((sameas(i,'DX'))),
ebt(r,"2")=egyadjusted(r,i);
););
if ((ord(ebi)=3),
loop(i$((sameas(i,'X'))),
ebt(r,"3")=egyadjusted(r,i);
););
if ((ord(ebi)=4),
loop(i$((sameas(i,'DRC'))),
ebt(r,"4")=egyadjusted(r,i);
););
if ((ord(ebi)=5),
loop(i$((sameas(i,'RC')) ),
ebt(r,"5")=egyadjusted(r,i);
););
if (((ord(ebi)=6)  or (ord(ebi)=8) or (ord(ebi)=9) or (ord(ebi)=10) or (ord(ebi)=11) or (ord(ebi)=12) or (ord(ebi)=13) or (ord(ebi)=14) or (ord(ebi)=16) or (ord(ebi)=17) or or (ord(ebi)=18) or (ord(ebi)=19) or (ord(ebi)=20) or (ord(ebi)=21) or (ord(ebi)=22) or (ord(ebi)=23) or (ord(ebi)=24) or (ord(ebi)=25) or (ord(ebi)=26) or (ord(ebi)=29)),
loop(indi$(ord(indi)=ord(ebi)-5),
ebt(r,ebi)=egyindi(r,indi).l;
););
if ((ord(ebi)=7),
loop(i$((sameas(i,'OILT'))),
loop(indi$(ord(indi)=ord(ebi)-5),
ebt(r,"7")=egyadjusted(r,i)+egyindi(r,indi).l;
);););
if ((ord(ebi)=10),
loop(i$((sameas(i,'ROILT'))),
loop(indi$(ord(indi)=ord(ebi)-5),
ebt(r,"15")=egyadjusted(r,i)+egyindi(r,indi).l;
);););
if ((ord(ebi)=27),
loop(i$((sameas(i,'ELEHT'))),
loop(indi$(ord(indi)=ord(ebi)-5),
ebt(r,"27")=egyadjusted(r,i)+egyindi(r,indi).l;
);););
if ((ord(ebi)=28),
loop(i$((sameas(i,'FGT'))),
loop(indi$(ord(indi)=ord(ebi)-5),
ebt(r,"28")=egyadjusted(r,i)+egyindi(r,indi).l;
);););

););
);

