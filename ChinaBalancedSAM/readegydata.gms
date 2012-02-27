
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\energydata\'
$setlocal outputfolder '%projectfolder%\data\gdx\egygdx'

$call gdxxrw i=%inputfolder%\egycons_ind.xlsm o=%outputfolder%\ind.gdx par=ind  rng="ind!A1:G25" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_ind.xlsm o=%outputfolder%\prov.gdx par=ind  rng="prov!A1:H31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xlsm o=%outputfolder%\coal.gdx par=prov  rng="coal!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xlsm o=%outputfolder%\fg.gdx par=prov  rng="fg!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xlsm o=%outputfolder%\oil.gdx par=prov  rng="oil!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xlsm o=%outputfolder%\roil.gdx par=prov  rng="roil!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xlsm o=%outputfolder%\ng.gdx par=prov  rng="ng!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xlsm o=%outputfolder%\eleh.gdx par=prov  rng="eleh!A1:u31" rdim=1 cdim=1
$call gdxxrw i=%inputfolder%\egycons_prov.xlsm o=%outputfolder%\othe.gdx par=prov  rng="othe!A1:u31" rdim=1 cdim=1
$call gdxmerge i=%outputfolder%\*.gdx o=%outputfolder%\egydata.gdx

