$ontext


Here is a "MAP" of the EBT (coal, fuelgas, oil, refined oil, natural gas, electricity and heat, other energy)



           PROD    DX       X      DRC     RC     COAL     FG     OIL      ROIL     NG     ELEH    OTHE

        ------------------------------------------------------------------------------------------------
BEJ     |       |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
...
        ------------------------------------------------------------------------------------------------
XIN     |       |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------

           AGR     IND     CON     TR     WRHR    OTH      FU       INV
        ------------------------------------------------------------------------------------------------
BEJ     |       |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
...
        ------------------------------------------------------------------------------------------------
XIN     |       |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------

We need rebalance EBT in order to:
a) All the data is consitent with the national EBT (0401.xls)
b) SUM(DX)=SUM(DRC)

After the rebalancing work, we can estimate detailed industry energy consumption of each province.

$offtext

$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx\egygdx'

*SAM table
set     e       energy product  /
         coal    Coal,
         fg      Fuel gas,
         oil     Crude oil,
         roil    Refined oil,
         ng      Natural gas,
         eleh    Electricity & heat,
         othe    Other energy/;
set     indi    egy-intensive sectors    /
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
         WT/;
set     i       sectors /
         PROD    Production,
         DX      Domestic outflow,
         X       Export,
         DRC     Domestic inflow,
         RC      Import,
         COALT   Coal converted from other energy product,
         FGT     Fuel gas converted from other energy product,
         OILT   Crude oil converted from other energy product,
         ROILT   Refined oil converted from other energy product,
         NGT     Natural gas converted from other energy productconverted from other energy product,
         ELEHT   Electricity & heat converted from other energy product,
         OTHET   Other energy converted from other energy product,
         AGR     Agriculture,
         IND     Industry,
         CON     Construction,
         TR      Transportation,
         WRHR    Wholesale & retail, hotel & restraurant,
         OTH     Other service industry,
         FU      Final use,
         INV     Inventory change/;

set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
parameter prov(e,r,i)           prov ebt
parameter ind(*,indi,e)           egy cons of egy by intensive ind
parameter indprov(*,r,e)       egy cons of egy product by province

$gdxin '%inputfolder%\egydata.gdx'
$load prov
display prov
$gdxin '%inputfolder%\egydata.gdx'
$load ind
display ind
$gdxin '%inputfolder%\egydata.gdx'
$load indprov
display indprov

$ontext
set     negval2(r,i,j)     Flag for negative elements;
set     empty2(r,i,*)      Flag for empty rows and columns;
parameter       chksam2(r,i,*)       Consistency check of social accounts;

*SAM15
loop(r,

loop(ri$((ord(ri) le 27)),
loop(ni$(ord(ni)=ord(ri)),
loop(rj,
loop(nj$(ord(nj)=ord(rj)),
sam15(r,ni,nj)=sam(r,ri,rj);
);
);
);
);

loop(rj,
loop(nj$(ord(nj)=ord(rj)),
sam15(r,"28",nj)=sam(r,"30",rj);
);
);


*AGGREGATION OF OTH PRODUCTION(other service industry)
loop(ri$(((ord(ri) ge 31) and (ord(ri) le 42)) or (ord(ri) = 28) or (ord(ri) = 29)),
loop(rj,
loop(nj$(ord(nj)=ord(rj)),
sam15(r,"29",nj)=sam15(r,"29",nj)+sam(r,ri,rj);
);
);
);

loop(ri$((ord(ri) ge 43) and (ord(ri) le 69)),
loop(ni$(ord(ni)=ord(ri)-12),
loop(rj,
loop(nj$(ord(nj)=ord(rj)),
sam15(r,ni,nj)=sam(r,ri,rj);
);
);
);
);


loop(rj,
loop(nj$(ord(nj)=ord(rj)),
sam15(r,"58",nj)=sam(r,"72",rj);
);
);

*AGGREGATION OF OTH COMMODITIES(other service industry)
loop(ri$(((ord(ri) ge 73) and (ord(ri) le 84)) or (ord(ri) = 70) or (ord(ri) = 71)),
loop(rj,
loop(nj$(ord(nj)=ord(rj)),
sam15(r,"59",nj)=sam15(r,"59",nj)+sam(r,ri,rj);
);
);
);

loop(ri$((ord(ri) ge 85) and (ord(ri) le 96)),
loop(ni$(ord(ni)=ord(ri)-24),
loop(rj,
loop(nj$(ord(nj)=ord(rj)),
sam15(r,ni,nj)=sam(r,ri,rj);
);
);
);
);
*end of loop r
);




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
sam2(r,i,"28")=sam15(r,ni,"30");
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
sam2(r,i,"58")=sam15(r,ni,"72");
);
);

*AGGREGATION OF OTH COMMODITIES(other service industry)
loop(nj$(((ord(nj) ge 73) and (ord(nj) le 84)) or (ord(nj) = 70) or (ord(nj) = 71)),
loop(ni,
loop(i$(ord(i)=ord(ni)),
sam2(r,i,"59")=sam2(r,i,"59")+sam15(r,ni,nj);
);
);
);

loop(nj$((ord(nj) ge 85) and (ord(nj) le 96)),
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


