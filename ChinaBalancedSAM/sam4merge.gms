
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data\gdx\finalbalancing'
$call gdxmerge i=%inputfolder%\*.gdx o=%inputfolder%\sam4.gdx