if not exist listings\nul mkdir listings
:call gams readrawdata  o=listings\readrawdata.lst 
:call gams allsam o=listings\allsam.lst gdx=data\gdx\allsam
:call gams aggregation o=listings\aggregation.lst gdx=data\gdx\aggregation
:call gams readegydata  o=listings\readegydata.lst 

call egybalance COAL FG OIL ROIL NG ELEH OTHE 

pause