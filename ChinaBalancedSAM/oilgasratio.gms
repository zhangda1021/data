$ontext
This program is used to get the ratio of crude oil ang gas consumption for each province.

$offtext

$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx\egygdx\balance'

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
set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
parameter egyadjusted(r,i)                egy cons of egy product by province

$gdxin '%inputfolder%\oil_balance.gdx'
$load egyadjusted
parameter oil(r)
loop(r,
oil(r)=0;
);
loop(r,
loop(i$((sameas(i,'PROD')) OR (sameas(i,'DRC')) OR (sameas(i,'RC'))),
oil(r)=oil(r)+egyadjusted(r,i);
);
loop(i$((sameas(i,'DX')) OR (sameas(i,'X'))),
oil(r)=oil(r)-egyadjusted(r,i);
);
);
display oil


variables x(r,i)
$gdxin '%inputfolder%\ng_balance.gdx'
$load x
parameter ng(r)
loop(r,
ng(r)=0;
);
loop(r,
loop(i$((sameas(i,'PROD')) OR (sameas(i,'DRC')) OR (sameas(i,'RC'))),
ng(r)=ng(r)+x.l(r,i);
);
loop(i$((sameas(i,'DX')) OR (sameas(i,'X'))),
ng(r)=ng(r)-x.l(r,i);
);
);
display ng

parameter oilngratio(r)
loop(r,
oilngratio(r)=oil(r)/(oil(r)+ng(r));
);
