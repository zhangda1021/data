if not exist listings\nul mkdir listings
:call gams readrawdata  o=listings\readrawdata.lst 
:call gams allsam o=listings\allsam.lst gdx=data\gdx\allsam
:call gams aggregation o=listings\aggregation.lst gdx=data\gdx\aggregation
:call gams readegydata  o=listings\readegydata.lst 
:call gams readegybench o=listings\readegybench.lst 
:del data\gdx\egygdx\balance\*.gdx
:call egybalance COAL FG OIL ROIL NG ELEH OTHE 
:call gams oilgasratio o=listings\oilgasratio.lst gdx=data\gdx\egygdx\oilgasratio
:del data\gdx\egygdx\estimation\*.gdx
:call egyestimation COAL FG OIL ROIL NG ELEH OTHE
:call gams ebtmerge  o=listings\ebtmerge.lst
call gams finalbalancing o=listings\finalbalancing.lst gdx=data\gdx\finalsam

pause