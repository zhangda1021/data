
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\energydata\'
$setlocal outputfolder '%projectfolder%\data\gdx\egygdx'

$call gdxxrw i=%inputfolder%\pricemargin.xls o=%outputfolder%\pricemargin.gdx par=pricemargin rng="sheet1!A2:m32" rdim=1 cdim=1
