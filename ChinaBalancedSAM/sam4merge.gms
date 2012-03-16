
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx\finalbalancing2'
$call gdxmerge i=%inputfolder%\*.gdx o=%inputfolder%\sam4.gdx
