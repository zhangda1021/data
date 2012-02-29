$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\energydata\'
$setlocal outputfolder '%projectfolder%\data\gdx\egygdx'
$call gdxxrw i=%inputfolder%\coal_bench.xls o=%outputfolder%\coal_bench.gdx par=coal_bench  rng="sheet1!a1:b19" rdim=1 cdim=1 
$call gdxxrw i=%inputfolder%\fg_bench.xls o=%outputfolder%\fg_bench.gdx par=fg_bench  rng="sheet1!a1:b19" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\oil_bench.xls o=%outputfolder%\oil_bench.gdx par=oil_bench  rng="sheet1!A1:b19" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\roil_bench.xls o=%outputfolder%\roil_bench.gdx par=roil_bench  rng="sheet1!A1:b19" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\ng_bench.xls o=%outputfolder%\ng_bench.gdx par=ng_bench  rng="sheet1!A1:b19" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\eleh_bench.xls o=%outputfolder%\eleh_bench.gdx par=eleh_bench  rng="sheet1!A1:b19" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\othe_bench.xls o=%outputfolder%\othe_bench.gdx par=othe_bench  rng="sheet1!A1:b19" rdim=1 cdim=1