$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data'
set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;

file frun /readrawdata.gms/;
put frun;
loop(r,
put '$call gdxxrw i=%inputfolder%\chinaIO.xls o=%inputfolder%\'r.tl'.gdx par=rawdata rng="'r.tl'!C8:BI57" rdim=1 cdim=1'///;
);


