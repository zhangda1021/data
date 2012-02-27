
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\energydata\'
$setlocal outputfolder '%projectfolder%\data\gdx\egygdx'

$call gdxxrw i=%inputfolder%\egycons_ind.xls o=%outputfolder%\IND.gdx par=ind rng="IND!A1:G25" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_ind.xls o=%outputfolder%\PROV.gdx par=indprov rng="INDPROV!A1:H31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\COAL.gdx par=prov  rng="COAL!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\FG.gdx par=prov  rng="FG!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\OIL.gdx par=prov  rng="OIL!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\ROIL.gdx par=prov  rng="ROIL!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\NG.gdx par=prov  rng="NG!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\ELEH.gdx par=prov  rng="ELEH!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xls o=%outputfolder%\OTHE.gdx par=prov  rng="OTHE!A1:u31" rdim=1 cdim=1
$call gdxmerge i=%outputfolder%\*.gdx o=%outputfolder%\egydata.gdx

