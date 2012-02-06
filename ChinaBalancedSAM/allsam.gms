$ontext

        Production activities   A (42)
        Commodities             C (42)
        Primary Factors         F (2)
        Enterprises             E (1)
        Private households      H (1)
        Government              G (1)
        Types of taxes          T (3)
        Rest of country         EX(1)
        Rest of world           X (1)
        Investment-savings      I (1)

Here is a "MAP" of the SAM with the names of the submatrices which
contain data.  All cells with no labels are empty:


           A       C        F      E       H       G       T        DX      X      I
        --------------------------------------------------------------------------------
A       |       |   ac  |       |       |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
C       |   ca  |       |       |       |   ch  |   gd  |       |   der |   er  |  cs   |
        --------------------------------------------------------------------------------
F       |   fa  |       |       |       |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
E       |       |       |   ef  |       |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
H       |       |       |   hf  |   he  |       |       |       |   dhr |   hr  |       |
        --------------------------------------------------------------------------------
G       |       |       |   gf  |       |       |       |   tr  |       |       |       |
        --------------------------------------------------------------------------------
T       |   ta  |   tc  |       |   te  |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
DX      |       |  drc  |  drf  |       |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
X       |       |   rc  |   rf  |       |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
I       |       |       |   dp  |       |  psv  |   gsv |       |       |       |       |
        --------------------------------------------------------------------------------
$offtext

$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx'

*SAM table
set     i   SAM rows and colums indices   /1*95/;
alias (i,j);
set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
parameter sam(r,i,j)

*raw data
set     ri   raw data rows indices   /1*49/;
set     rj   raw data columns indices /1*58/;
parameter rawdata(r,ri,rj)  Base year  data

$gdxin '%inputfolder%\merged.gdx'
$load rawdata
display rawdata



parameter imptax;
*set      c       commodities     /1*42/;
parameter totrc(r),toter(r);
parameter totdrc(r),totder(r);
parameter sumrc,sumer,sumdrc,sumder,ch;
parameter lkratio        Labor capital ratio in each province to determine the value of drf and rf ;
parameter efgf;
parameter psvgsv;
set     negval(r,i,j)     Flag for negative elements;
set     empty(r,i,*)      Flag for empty rows and columns;
parameter       chksam(r,i,*)       Consistency check of social accounts;
parameter       flag                Check if the capital is not zero;
flag = 0 ;


sumrc=0;
sumer=0;
sumdrc=0;
sumder=0;ch=0;
imptax=0.02;
efgf=0.8;
psvgsv=0.8;
loop(r,
totrc(r)=0;
toter(r)=0;
totdrc(r)=0;
totder(r)=0;
);



loop(r,
flag=flag+1;
if( rawdata(r,"46","43")+rawdata(r,"47","43")=0, display flag;);

lkratio=rawdata(r,"44","43")/(rawdata(r,"46","43")+rawdata(r,"47","43"));
* ACCOUNT A
* input ca
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(j$((ord(j) ge 1) and (ord(j) le 42)),
loop(ri$(ord(ri)=ord(i)-42),
loop(rj$(ord(rj)=ord(j)),
sam(r,i,j)=rawdata(r,ri,rj);
);
);
);
);

*input fa(labor)
loop(j$((ord(j) ge 1) and (ord(j) le 42)),
loop(rj$(ord(rj)=ord(j)),
sam(r,"85",j)=rawdata(r,"44",rj);
);
);
*input fa(kap)
loop(j$((ord(j) ge 1) and (ord(j) le 42)),
loop(rj$(ord(rj)=ord(j)),
sam(r,"86",j)=rawdata(r,"47",rj)+rawdata(r,"46",rj);
);
);
*input ta
loop(j$((ord(j) ge 1) and (ord(j) le 42)),
loop(rj$(ord(rj)=ord(j)),
sam(r,"90",j)=rawdata(r,"45",rj);
);
);
* input ac
loop(i$((ord(i) ge 1) and (ord(i) le 42)),
loop(j$(ord(j)=ord(i)+42),
loop(rj$(ord(rj)=ord(i)),
sam(r,i,j)=rawdata(r,"49",rj);
);
);
);


*ACCOUNT C
*input tc
loop(j$((ord(j) ge 43) and (ord(j) le 84)),
loop(ri$(ord(ri)=ord(j)-42),
sam(r,"91",j)=rawdata(r,ri,"55")/1.02*0.02;
);
);
*input rc
loop(j$((ord(j) ge 43) and (ord(j) le 84)),
loop(ri$(ord(ri)=ord(j)-42),
sam(r,"94",j)=rawdata(r,ri,"55")/1.02;
totrc(r)=totrc(r)+sam(r,"94",j);
);
);
*display totrc;
*input drc
loop(j$((ord(j) ge 43) and (ord(j) le 84)),
loop(ri$(ord(ri)=ord(j)-42),
*sam(r,"93",j)=rawdata(r,ri,"56")*0.971461278391528;
sam(r,"93",j)=rawdata(r,ri,"56");
totdrc(r)=totdrc(r)+sam(r,"93",j);
);
);
*display totdrc;
*input ch
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
* Household consumption= original household consumption - domestic inflow discrepancy
*sam(r,i,"88")=rawdata(r,ri,"46")-rawdata(r,ri,"56")*(1-0.971461278391528);
sam(r,i,"88")=rawdata(r,ri,"46");
ch= ch+ sam(r,i,"88");
);
);

*input gd
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
sam(r,i,"89")=rawdata(r,ri,"47");
);
);
*input der
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
sam(r,i,"93")=rawdata(r,ri,"53")+rawdata(r,ri,"57");
totder(r)=totder(r)+rawdata(r,ri,"53")+rawdata(r,ri,"57");
);
);
*display totder;
*input er
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
sam(r,i,"94")=rawdata(r,ri,"52");
toter(r)=toter(r)+rawdata(r,ri,"52");
);
);
*display toter;
*input cs
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
sam(r,i,"95")=rawdata(r,ri,"51");
);
);


*ACCOUNT F,H
*input drf,dhr
if
((totder(r)>totdrc(r)),
sam(r,"93","85")=(totder(r)-totdrc(r))/(1+lkratio)*lkratio;
sam(r,"93","86")=(totder(r)-totdrc(r))/(1+lkratio);
else
sam(r,"88","93")=totdrc(r)-totder(r);
);

*input rf,hr
if
((toter(r)>totrc(r)),
sam(r,"94","85")=(toter(r)-totrc(r))/(1+lkratio)*lkratio;
sam(r,"94","86")=(toter(r)-totrc(r))/(1+lkratio);
else
sam(r,"88","94")=totrc(r)-toter(r);
);


*ACCOUNT F
*input dp
sam(r,"95","86")=rawdata(r,"46","43");
*input hf                    hf(labor)= total labor - drf(labor)- rf(labor)
sam(r,"88","85")=rawdata(r,"44","43")-sam(r,"93","85")- sam(r,"94","85");
*input ef,gf                 ef + gf = total capital input from rawdata - drf(capital)-rf(capital)
sam(r,"87","86")=(rawdata(r,"46","43")+ rawdata(r,"47","43")-  sam(r,"93","86")-sam(r,"94","86")-sam(r,"95","86"))*efgf;
sam(r,"89","86")=(rawdata(r,"46","43")+ rawdata(r,"47","43")-  sam(r,"93","86")-sam(r,"94","86")-sam(r,"95","86"))*(1-efgf);

*ACCOUNT I
*input psv,gsv     cs-dp
sam(r,"95","88")=(sum(i$((ord(i) ge 43) and (ord(i) le 84)),sam(r,i,"95"))-sam(r,"95","86"))*psvgsv;
sam(r,"95","89")=(sum(i$((ord(i) ge 43) and (ord(i) le 84)),sam(r,i,"95"))-sam(r,"95","86"))*(1-psvgsv);

*ACCOUNT H
*input he = ch + psv - hf(labor) - dhr - hr  (household consumption + household saving - labor income from production - labor income from export)
sam(r,"88","87")= ch + sam(r,"95","88")- sam(r,"88","85")- sam(r,"88","93")-sam(r,"88","94");

*ACCOUNT T
*input te = ef - he
sam(r,"92","87")=sam(r,"87","86")-sam(r,"88","87");
*input tr
sam(r,"89","90")=rawdata(r,"45","43");
sam(r,"89","91")=sum(j$((ord(j) ge 43) and (ord(j) le 84)),sam(r,"91",j));
sam(r,"89","92")=sam(r,"92","87");


negval(r,i,j) = yes$(sam(r,i,j) < 0);

empty(r,i,"row") = 1$(sum(j, sam(r,i,j)) = 0);
empty(r,j,"col") = 1$(sum(i, sam(r,i,j)) = 0);

chksam(r,i,"before") = sum(j, sam(r,i,j)-sam(r,j,i));
chksam(r,i,"scale") = sum(j, sam(r,j,i));
chksam(r,i,"%dev")$sum(j, sam(r,i,j)) = 100 * sum(j, sam(r,i,j)-sam(r,j,i)) / sum(j, sam(r,i,j));

);

*display sam;
display negval;
display empty;
display chksam;


loop(r,
sumrc=sumrc+ totrc(r);
sumer=sumer+ toter(r);
sumdrc=sumdrc+ totdrc(r);
sumder=sumder+ totder(r);
);

display  sumrc,sumer,sumdrc,sumder;
