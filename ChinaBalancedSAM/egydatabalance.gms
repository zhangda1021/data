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

$if not set egyprod   $set egyprod COAL
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
         WRHR    Wholesale & retail & hotel & restraurant,
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
parameter columnsum(i)
parameter benchvalue(i)

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

loop(i,
columnsum(i)=sum(r, %egyprod%(r,i)););
display columnsum

loop(i$ ((ord(i)<>2) and (ord(i)<>4)),
benchvalue(i)= %egyprod%_bench(i,"value");
);
display benchvalue

variables       x(r,i)  adjusted value
variable        j       obj function

Equations criterion_coal criterion definition
         criterion_fg
         criterion_oil
          criterion_roil
          criterion_ng
          criterion_eleh
          criterion_othe
*           bench   benchmark egy
           balance_coal  input output balance
           balance_fg
           balance_oil
           balance_roil
           balance_ng
           balance_eleh
           balance_othe
           trade   domestic trade balance
           sign    negative only for t and inv;


criterion_coal$(sameas('%egyprod%','COAL'))..
j=e=sum((r,i)$(%egyprod%(r,i)<>0),sqr(x(r,i)/%egyprod%(r,i)-1))+10000*sum(i$((ord(i)<>2) and (ord(i)<>4)and (abs(benchvalue(i))>0.01)),sqr(sum(r,x(r,i))/benchvalue(i) - 1));
*j=e=sum((r,i)$%egyprod%(r,i),x(r,i)*(log(x(r,i)/%egyprod%(r,i))-1));
*j=e=sum((r,i),sqr(x(r,i)-%egyprod%(r,i))/100000);

criterion_fg$(sameas('%egyprod%','FG'))..
j=e=sum((r,i)$(%egyprod%(r,i)<>0),sqr(x(r,i)/%egyprod%(r,i)-1))+6*sum(i$((ord(i)<>2) and (ord(i)<>4)and (abs(benchvalue(i))>0.01)),sqr(sum(r,x(r,i))/benchvalue(i) - 1));

criterion_oil$(sameas('%egyprod%','OIL'))..
j=e=sum((r,i)$(%egyprod%(r,i)<>0),sqr(x(r,i)/%egyprod%(r,i)-1))+100*sum(i$((ord(i)<>2) and (ord(i)<>4)and (abs(benchvalue(i))>0.01)),sqr(sum(r,x(r,i))/benchvalue(i) - 1));

criterion_roil$(sameas('%egyprod%','ROIL'))..
j=e=sum((r,i)$(%egyprod%(r,i)<>0),sqr(x(r,i)/%egyprod%(r,i)-1))+1000*sum(i$((ord(i)<>2) and (ord(i)<>4)and (abs(benchvalue(i))>0.01)),sqr(sum(r,x(r,i))/benchvalue(i) - 1));

criterion_ng$(sameas('%egyprod%','NG'))..
j=e=sum((r,i)$(%egyprod%(r,i)<>0),sqr(x(r,i)/%egyprod%(r,i)-1))+100*sum(i$((ord(i)<>2) and (ord(i)<>4)and (abs(benchvalue(i))>0.01)),sqr(sum(r,x(r,i))/benchvalue(i) - 1));

criterion_eleh$(sameas('%egyprod%','ELEH'))..
j=e=sum((r,i)$(%egyprod%(r,i)<>0),sqr(x(r,i)/%egyprod%(r,i)-1))+1000*sum(i$((ord(i)<>2) and (ord(i)<>4)and (abs(benchvalue(i))>0.01)),sqr(sum(r,x(r,i))/benchvalue(i) - 1));

criterion_othe$(sameas('%egyprod%','OTHE'))..
j=e=sum((r,i)$(%egyprod%(r,i)<>0),sqr(x(r,i)/%egyprod%(r,i)-1))+6*sum(i$((ord(i)<>2) and (ord(i)<>4)and (abs(benchvalue(i))>0.01)),sqr(sum(r,x(r,i))/benchvalue(i) - 1));

*No bench for dx and drc
*bench(i)$((ord(i)<>2) and (ord(i)<>4))..
*sum(r,x(r,i)) =e= benchvalue(i);
*coal
balance_coal(r)$(sameas('%egyprod%','COAL'))..
2*(x(r,"PROD")+x(r,"RC")+x(r,"DRC")+x(r,"COALT"))=e=sum(i,x(r,i));

*fg
balance_fg(r)$(sameas('%egyprod%','FG'))..
2*(x(r,"PROD")+x(r,"RC")+x(r,"DRC")+x(r,"FGT"))=e=sum(i,x(r,i));
*oil
balance_oil(r)$(sameas('%egyprod%','OIL'))..
2*(x(r,"PROD")+x(r,"RC")+x(r,"DRC")+x(r,"OILT"))=e=sum(i,x(r,i));
*roil
balance_roil(r)$(sameas('%egyprod%','ROIL'))..
2*(x(r,"PROD")+x(r,"RC")+x(r,"DRC")+x(r,"ROILT"))=e=sum(i,x(r,i));
*ng
balance_ng(r)$(sameas('%egyprod%','NG'))..
2*(x(r,"PROD")+x(r,"RC")+x(r,"DRC")+x(r,"NGT"))=e=sum(i,x(r,i));
*eleh
balance_eleh(r)$(sameas('%egyprod%','ELEH'))..
2*(x(r,"PROD")+x(r,"RC")+x(r,"DRC")+x(r,"ELEHT"))=e=sum(i,x(r,i));
*othe
balance_othe(r)$(sameas('%egyprod%','OTHE'))..
2*(x(r,"PROD")+x(r,"RC")+x(r,"DRC")+x(r,"OTHET"))=e=sum(i,x(r,i));

trade..
sum(r,x(r,"DX"))=e=sum(r,x(r,"DRC"));


sign(r,i)$((ord(i)<>6) and (ord(i)<>7) and (ord(i)<>8) and (ord(i)<>9) and (ord(i)<>10) and (ord(i)<>11) and (ord(i)<>12))..
x(r,i)=g=0;

Model gua /all/;
x.l(r,i)= %egyprod%(r,i);
x.l(r,i)$((ord(i)<>2) and (ord(i)<>4) and (abs(columnsum(i))>0.01))= %egyprod%(r,i)/columnsum(i)*benchvalue(i);
Display x.l;
x.fx(r,i)$(abs(x.l(r,i))<0.0001) = 0;
*x.up(r,i)=max(%egyprod%(r,i)*5,%egyprod%(r,i)/5);
*x.lo(r,i)=min(%egyprod%(r,i)*5,%egyprod%(r,i)/5);

gua.iterlim=1000;
Solve gua minimizing j using nlp;




