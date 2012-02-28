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
parameter coal_bench(i,*)
parameter fg_bench(i,*)
parameter oil_bench(i,*)
parameter roil_bench(i,*)
parameter ng_bench(i,*)
parameter eleh_bench(i,*)
parameter othe_bench(i,*)
parameter ind(*,indi,e)           egy cons of egy by intensive ind
parameter indprov(*,r,e)       egy cons of egy product by province

$if exist %inputfolder%\%egyprod%.gdx       $goto readdata
$log "Error -- cannot find %egyprod%'
$call pause 'Program will now abort.

$label readdata
$gdxin '%inputfolder%\%egyprod%.gdx'
$load %egyprod%
display %egyprod%
$gdxin '%inputfolder%\%egyprod%_bench.gdx'
$load %egyprod%_bench
display %egyprod%_bench

variables	x(r,i)	adjusted value
variable	j	obj function

Equations  criterion criterion definition
           bench   benchmark egy 
           balance  input output balance
	   trade   domestic trade balance;


criterion..
j=e=sum(r,sum(i,sqr(x(r,i)-%egyprod%(r,i))));

*No bench for dx and drc
bench(i)$((ord(i)<>2) and (ord(i)<>4))..
sum(r,x(r,i)) =e= %egyprod%_bench(i,"value");

*coal
balance(r)$(sameas('%egyprod%','COAL'))..
2*(x(r,"PROD")+x(r,"RC")+x(r,"DRC")+x(r,"COALT")-x(r,"X")-x(r,"DX"))=e=sum(i,x(r,i));

*fg...

trade..
sum(r,x(r,"DX"))=e=sum(r,x(r,"DRC"));

Model gua /all/;

Solve gua minimizing j using qcp;

Display x.l;


