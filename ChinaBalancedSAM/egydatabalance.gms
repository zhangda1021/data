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
$title  Read a single state file

$if not set egyprod   $set egyprod coal
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
set     i       accounts /
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
parameter coal(r,i)           coal ebt
parameter fg(r,i)           fg ebt
parameter oil(r,i)           oil ebt
parameter roil(r,i)           roil ebt
parameter ng(r,i)           ng ebt
parameter eleh(r,i)           eleh ebt
parameter othe(r,i)           othe ebt
parameter ind(*,indi,e)           egy cons of egy by intensive ind
parameter indprov(*,r,e)       egy cons of egy product by province

$if exist %inputfolder%\%egyprod%.gdx       $goto readdata
$log "Error -- cannot find %egyprod%'
$call pause 'Program will now abort.

$label readdata
$gdxin '%inputfolder%\%egyprod%.gdx'
$load %egyprod%
display %egyprod%

$ontext
set     negval2(r,i,j)     Flag for negative elements;
set     empty2(r,i,*)      Flag for empty rows and columns;
parameter       chksam2(r,i,*)       Consistency check of social accounts;

positive variables x(r,i) adjusted values 
variables j	objective value

equations 

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


