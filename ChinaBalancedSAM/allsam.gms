$ontext

        Production activities   A (42)
        Commodities             C (42)
        Primary Factors         F (2)
        Households              H (1)
        Central Government      G1(1)
        Provincial Government   G2(1)
        Types of taxes          T (4)
        Rest of country         EX(1)
        Rest of world           X (1)
        Investment-savings      I (1)

Here is a "MAP" of the SAM with the names of the submatrices which
contain data.  All cells with no labels are empty:


           A       C        F       H      G1      G2       T       DX      X      I
        --------------------------------------------------------------------------------
A       |       |   ac  |       |       |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
C       |   ca  |       |       |   ch  |       |  g2d  |       |   der |   er  |  cs   |
        --------------------------------------------------------------------------------
F       |   fa  |       |       |       |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
H       |       |       |   hf  |       |       |  hg2  |       |       |       |       |
        --------------------------------------------------------------------------------
G1      |       |       |       |       |       |  g1g2 |       |   dhr |   hr  |       |
        --------------------------------------------------------------------------------
G2      |       |       |       |       | g2g1  |       |   tr  |       |       |       |
        --------------------------------------------------------------------------------
T       |   ta  |       |       |       |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
DX      |       |  drc  |       |  drh  |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
X       |       |   rc  |       |   rh  |       |       |       |       |       |       |
        --------------------------------------------------------------------------------
I       |       |       |   dp  |  psv  |  g1sv |       |       |       |       |       |
        --------------------------------------------------------------------------------
$offtext

$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx'

*SAM table
set     i   SAM rows and colums indices   /1*96/;
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


parameter totrc(r),toter(r);
parameter totdrc(r),totder(r);
*cs/(cs+ch+gd)
parameter csratio(r);
parameter sumrc,sumer,sumdrc,sumder;
*ch/(ch+gd)
parameter chratio;
set     negval(r,i,j)     Flag for negative elements;
set     empty(r,i,*)      Flag for empty rows and columns;
parameter       chksam(r,i,*)       Consistency check of social accounts;
parameter       flag                ;


flag = 0 ;
sumrc=0;
sumer=0;
sumdrc=0;
sumder=0;ch=0;
psvgsv=0.8;
loop(r,
totrc(r)=0;
toter(r)=0;
totdrc(r)=0;
totder(r)=0;
);


loop(r,
*flag=flag+1;
*if( rawdata(r,"46","43")+rawdata(r,"47","43")=0, display flag;);

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
*input fa(kap)
loop(j$((ord(j) ge 1) and (ord(j) le 42)),
loop(rj$(ord(rj)=ord(j)),
if (rawdata(r,"47",rj)+rawdata(r,"46",rj) ge 0, sam(r,"86",j)=rawdata(r,"47",rj)+rawdata(r,"46",rj););
if (rawdata(r,"47",rj)+rawdata(r,"46",rj) le 0, sam(r,"86",j)=0;);
);
);
*input fa(labor)
loop(j$((ord(j) ge 1) and (ord(j) le 42)),
loop(rj$(ord(rj)=ord(j)),
if (rawdata(r,"47",rj)+rawdata(r,"46",rj) ge 0, sam(r,"85",j)=rawdata(r,"44",rj););
if (rawdata(r,"47",rj)+rawdata(r,"46",rj) le 0, sam(r,"85",j)=rawdata(r,"44",rj)+rawdata(r,"47",rj)+rawdata(r,"46",rj););
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
*loop(j$((ord(j) ge 43) and (ord(j) le 84)),
*loop(ri$(ord(ri)=ord(j)-42),
*sam(r,"91",j)=rawdata(r,ri,"55")/1.02*0.02;
*);
*);

*input drc
loop(j$((ord(j) ge 43) and (ord(j) le 84)),
loop(ri$(ord(ri)=ord(j)-42),
sam(r,"94",j)=rawdata(r,ri,"56");
totdrc(r)=totdrc(r)+sam(r,"94",j);
);
);

*input rc
loop(j$((ord(j) ge 43) and (ord(j) le 84)),
loop(ri$(ord(ri)=ord(j)-42),
sam(r,"95",j)=rawdata(r,ri,"55");
totrc(r)=totrc(r)+sam(r,"95",j);
);
);

*input der
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
sam(r,i,"94")=rawdata(r,ri,"53");
totder(r)=totder(r)+rawdata(r,ri,"53");
);
);

*input er
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
sam(r,i,"95")=rawdata(r,ri,"52");
toter(r)=toter(r)+rawdata(r,ri,"52");
);
);

*input cs
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
if (rawdata(r,ri,"50") ge 0,
sam(r,i,"96")=rawdata(r,ri,"49")+ rawdata(r,ri,"50");
else sam(r,i,"96")=rawdata(r,ri,"49"););
);
);

*input ch and g2d
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
chratio=rawdata(r,ri,"46")/(rawdata(r,ri,"46")+rawdata(r,ri,"47"));
if (rawdata(r,ri,"50") ge 0,
sam(r,i,"87")=rawdata(r,ri,"46");
sam(r,i,"89")=rawdata(r,ri,"47");
else
sam(r,i,"87")=rawdata(r,ri,"46")+rawdata(r,ri,"50")*chratio;
sam(r,i,"89")=rawdata(r,ri,"47")+rawdata(r,ri,"50")*(1-chratio););
);
);


*Compute csratio
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
csratio(ri)=sam(r,i,"96")/(sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"87"));
);
);

*Adjust cs

*Adjust ch and g2d

*if (rawdata(r,ri,"49")+ rawdata(r,ri,"50")+rawdata(r,ri,"57") ge 0,



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
