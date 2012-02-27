$ontext

        Production activities   A (30)
        Commodities             C (30)
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
set     i   SAM rows and colums indices   /
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
alias (i,j);
alias (i,ni);
set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
parameter sam2(r,i,j)           SAM v2.0

*raw data
set     ri   oldsam rows indices   /1*97/;
set     rj   oldsam columns indices /1*97/;
alias (rj,nj);
parameter sam(r,ri,rj)          SAM v1.0
parameter sam15(r,ni,nj)        SAM V1.5


$gdxin '%inputfolder%\allsam.gdx'
$load sam
display sam


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

loop(ri$((ord(ri) ge 85) and (ord(ri) le 97)),
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

loop(nj$((ord(nj) ge 85) and (ord(nj) le 97)),
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



