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

$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx'

*SAM table
set     i   SAM rows and colums indices   /1*97/;
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
parameter ch(r),g2d(r),hflabor(r),hfcap(r),dp(r),ta(r),sa(r);
*cs/(cs+ch+gd)
parameter csratio(i),chratio(i),gdratio(i);
parameter ratio1(i),ratio2(i),ratio3(i);
parameter sumrc,sumer,sumdrc,sumder;
parameter psv2;
*ch/(ch+gd)
parameter chgdratio;
set     negval(r,i,j)     Flag for negative elements;
set     empty(r,i,*)      Flag for empty rows and columns;
parameter       chksam(r,i,*)       Consistency check of social accounts;
parameter       flag                ;


flag = 0 ;
sumrc=0;
sumer=0;
sumdrc=0;
sumder=0;
psv2=0

loop(r,
totrc(r)=0;
toter(r)=0;
totdrc(r)=0;
totder(r)=0;
ch(r)=0;
g2d(r)=0;
hflabor(r)=0;
hfcap(r)=0;
dp(r)=0;
ta(r)=0;
sa(r)=0;
psv2=0;
);



loop(r,

loop(i,
csratio(i)=0;
chratio(i)=0;
gdratio(i)=0;
ratio1(i)=0;
ratio2(i)=0;
ratio3(i)=0;
psv2=0;
);
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
if (rawdata(r,"47",rj)+rawdata(r,"46",rj) ge 0,
sam(r,"86",j)=rawdata(r,"47",rj)+rawdata(r,"46",rj);
dp(r)=dp(r)+rawdata(r,"46",rj);
hfcap(r)=hfcap(r)+rawdata(r,"47",rj);
else
sam(r,"86",j)=0;
);
);
);
*input fa(labor)
loop(j$((ord(j) ge 1) and (ord(j) le 42)),
loop(rj$(ord(rj)=ord(j)),
if (rawdata(r,"47",rj)+rawdata(r,"46",rj) ge 0,
sam(r,"85",j)=rawdata(r,"44",rj);
else
sam(r,"85",j)=rawdata(r,"44",rj)+(rawdata(r,"47",rj)+rawdata(r,"46",rj))/(rawdata(r,"44",rj)+rawdata(r,"45",rj))*rawdata(r,"44",rj);
);
hflabor(r)=hflabor(r)+sam(r,"85",j);
);
);
*input ta,sa
loop(j$((ord(j) ge 1) and (ord(j) le 42)),
loop(rj$(ord(rj)=ord(j)),
if (rawdata(r,"47",rj)+rawdata(r,"46",rj) ge 0,
sam(r,"90",j)=rawdata(r,"45",rj);
else
sam(r,"90",j)=rawdata(r,"45",rj)+(rawdata(r,"47",rj)+rawdata(r,"46",rj))/(rawdata(r,"44",rj)+rawdata(r,"45",rj))*rawdata(r,"45",rj);
);
if (sam(r,"90",j) le 0,
sam(r,j,"90")=-sam(r,"90",j);
sam(r,"90",j)=0;
);
ta(r)=ta(r)+sam(r,"90",j);
sa(r)=sa(r)+sam(r,j,"90");
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

*input rc  - fix rc at this stage
loop(j$((ord(j) ge 43) and (ord(j) le 84)),
loop(ri$(ord(ri)=ord(j)-42),
sam(r,"95",j)=rawdata(r,ri,"55");
totrc(r)=totrc(r)+sam(r,"95",j);
);
);

*input er  - fix er at this stage
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
sam(r,i,"95")=rawdata(r,ri,"52");
toter(r)=toter(r)+sam(r,i,"95");
);
);

*input cs1,cs2,ic,
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
sam(r,i,"96")=rawdata(r,ri,"49");

if (rawdata(r,ri,"50") ge 0,
sam(r,i,"97")=rawdata(r,ri,"50");
else
sam(r,"97",i)=0-rawdata(r,ri,"50"););
psv2=psv2+rawdata(r,ri,"50");
);
);

*input psv2
sam(r,"97","87")=psv2;

*input der, ch and g2d
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
*if (rawdata(r,ri,"50") ge 0,
sam(r,i,"94")=rawdata(r,ri,"53");
sam(r,i,"87")=rawdata(r,ri,"46");
sam(r,i,"89")=rawdata(r,ri,"47");
$ontext
else
if (rawdata(r,ri,"50")+rawdata(r,ri,"46")+rawdata(r,ri,"47") ge 0,
chgdratio$(rawdata(r,ri,"46")+rawdata(r,ri,"47"))=rawdata(r,ri,"46")/(rawdata(r,ri,"46")+rawdata(r,ri,"47"));
sam(r,i,"94")=rawdata(r,ri,"53");
sam(r,i,"87")=rawdata(r,ri,"46")+rawdata(r,ri,"50")*chgdratio;
sam(r,i,"89")=rawdata(r,ri,"47")+rawdata(r,ri,"50")*(1-chgdratio);
else
* This generates lots of negative value of domestic export because of negative inventory increase
sam(r,i,"94")=rawdata(r,ri,"53")+rawdata(r,ri,"50");
sam(r,i,"87")=rawdata(r,ri,"46");
sam(r,i,"89")=rawdata(r,ri,"47");
);
);
$offtext
totder(r)=totder(r)+sam(r,i,"94");
);
);


*Compute ratios and process errors
loop(i$((ord(i) ge 43) and (ord(i) le 84)),
loop(ri$(ord(ri)=ord(i)-42),
if ((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))=0,
sam(r,i,"87")=0;
sam(r,i,"89")=0;
sam(r,i,"96")=0;
else

csratio(i)=sam(r,i,"96")/(sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"));
gdratio(i)=sam(r,i,"89")/(sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"));
chratio(i)=sam(r,i,"87")/(sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"));

if (((chratio(i) ge gdratio(i)) and (gdratio(i) ge csratio(i))),
ratio1(i)=chratio(i);
ratio2(i)=gdratio(i);
ratio3(i)=csratio(i);
if ((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio3(i)+rawdata(r,ri,"57")*ratio3(i) ge 0,
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")*chratio(i);
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")*gdratio(i);
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")*csratio(i);
else if((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio2(i)+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i) ge 0,
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio1(i);
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i);
else
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57");
);
);

else

if (((chratio(i) ge csratio(i)) and (csratio(i) ge gdratio(i))),
ratio1(i)=chratio(i);
ratio2(i)=csratio(i);
ratio3(i)=gdratio(i);
if ((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio3(i)+rawdata(r,ri,"57")*ratio3(i) ge 0,
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")*chratio(i);
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")*gdratio(i);
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")*csratio(i);
else if((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio2(i)+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i) ge 0,
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio1(i);
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i);
else
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57");
);
);
*$goto next

else


if (((gdratio(i) ge chratio(i)) and (chratio(i) ge csratio(i))),
ratio1(i)=gdratio(i);
ratio2(i)=chratio(i);
ratio3(i)=csratio(i);
if ((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio3(i)+rawdata(r,ri,"57")*ratio3(i) ge 0,
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")*chratio(i);
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")*gdratio(i);
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")*csratio(i);
else if((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio2(i)+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i) ge 0,
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio1(i);
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i);
else
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57");
);
);
*$goto next

else

if (((gdratio(i) ge csratio(i)) and (csratio(i) ge chratio(i))),
ratio1(i)=gdratio(i);
ratio2(i)=csratio(i);
ratio3(i)=chratio(i);
if ((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio3(i)+rawdata(r,ri,"57")*ratio3(i) ge 0,
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")*chratio(i);
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")*gdratio(i);
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")*csratio(i);
else if((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio2(i)+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i) ge 0,
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio1(i);
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i);
else
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57");
);
);
*$goto next
else

if (((csratio(i) ge gdratio(i)) and (gdratio(i) ge chratio(i))),
ratio1(i)=csratio(i);
ratio2(i)=gdratio(i);
ratio3(i)=chratio(i);
if ((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio3(i)+rawdata(r,ri,"57")*ratio3(i) ge 0,
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")*chratio(i);
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")*gdratio(i);
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")*csratio(i);
else if((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio2(i)+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i) ge 0,
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio1(i);
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i);
else
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57");
);
);
*$goto next
else

if (((csratio(i) ge chratio(i)) and (chratio(i) ge gdratio(i))),
ratio1(i)=csratio(i);
ratio2(i)=chratio(i);
ratio3(i)=gdratio(i);
if ((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio3(i)+rawdata(r,ri,"57")*ratio3(i) ge 0,
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")*chratio(i);
sam(r,i,"89")=sam(r,i,"89")+rawdata(r,ri,"57")*gdratio(i);
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")*csratio(i);
else if((sam(r,i,"96")+sam(r,i,"87")+sam(r,i,"89"))*ratio2(i)+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i) ge 0,
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio1(i);
sam(r,i,"87")=sam(r,i,"87")+rawdata(r,ri,"57")/(ratio1(i)+ratio2(i))*ratio2(i);
else
sam(r,i,"96")=sam(r,i,"96")+rawdata(r,ri,"57");
);
);
*$goto next
);
);
);
);
);
);
);
$label next
ch(r)=ch(r)+sam(r,i,"87");
g2d(r)=g2d(r)+sam(r,i,"89");
);
);


*ACCOUNT F
*input dp
sam(r,"96","86")=dp(r);

*input hf(labor)
sam(r,"87","85")=hflabor(r);

*input hf(capital)
sam(r,"87","86")=hfcap(r);


*ACCOUNT H
*input drh,dhr
if
((totder(r)>totdrc(r)),
sam(r,"94","87")=totder(r)-totdrc(r);
else
sam(r,"87","94")=totdrc(r)-totder(r);
);

*input rf,hr
if
((toter(r)>totrc(r)),
sam(r,"95","87")= toter(r)-totrc(r);
else
sam(r,"87","95")= totrc(r)-toter(r);
);

*input psv1,hg2
if (sam(r,"87","85")+sam(r,"87","86")+sam(r,"87","94")+sam(r,"87","95")-sam(r,"94","87")-sam(r,"95","87")-sam(r,"97","87")-ch(r) ge 0,
sam(r,"96","87")=sam(r,"87","85")+sam(r,"87","86")+sam(r,"87","94")+sam(r,"87","95")-sam(r,"94","87")-sam(r,"95","87")-sam(r,"97","87")-ch(r);
else
sam(r,"87","89")=-sam(r,"87","85")-sam(r,"87","86")-sam(r,"87","94")-sam(r,"87","95")+sam(r,"94","87")+sam(r,"95","87")+sam(r,"97","87")+ch(r);
);


*ACCOUNT T
*input tr
sam(r,"89","90")=ta(r)-sa(r);


*ACCOUNT G2
*input g1g2,g2g1
if (sam(r,"89","90")-g2d(r)-sam(r,"87","89") ge 0,
sam(r,"88","89")=sam(r,"89","90")-g2d(r)-sam(r,"87","89");
else
sam(r,"89","88")=g2d(r)+sam(r,"87","89")-sam(r,"89","90");
);


*ACCOUNT G1
*input cg1s,g1sv
sam(r,"88","96")=sam(r,"89","88");
sam(r,"96","88")=sam(r,"88","89");

*end of loop r
);


loop(r,
negval(r,i,j) = yes$(sam(r,i,j) < 0);

empty(r,i,"row") = 1$(sum(j, sam(r,i,j)) = 0);
empty(r,j,"col") = 1$(sum(i, sam(r,i,j)) = 0);

chksam(r,i,"before") = sum(j, sam(r,i,j)-sam(r,j,i));
chksam(r,i,"scale1") = sum(j, sam(r,j,i));
chksam(r,i,"scale2") = sum(j, sam(r,i,j));
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
