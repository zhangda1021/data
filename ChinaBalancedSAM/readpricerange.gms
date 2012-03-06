
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\energydata\'
$setlocal outputfolder '%projectfolder%\data\gdx\egygdx'

$call gdxxrw i=%inputfolder%\pricerange.xls o=%outputfolder%\pricerange.gdx par=pricerange rng="sheet1!A1:C7" rdim=1 cdim=1
