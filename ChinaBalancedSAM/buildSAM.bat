if not exist listings\nul mkdir listings
:call gams readrawdata  o=listings\readrawdata.lst 
:call gams allsam o=listings\allsam.lst gdx=data\gdx\allsam
:call gams aggregation o=listings\aggregation.lst gdx=data\gdx\aggregation
:call gams aggregation o=listings\aggregation.lst gdx=data\gdx\aggregation
:call gams readegydata  o=listings\readegydata.lst 
:call gams readegybench o=listings\readegybench.lst 
:del data\gdx\egygdx\balance\*.gdx
:call egybalance COAL FG OIL ROIL NG ELEH OTHE 
:call gams oilgasratio o=listings\oilgasratio.lst gdx=data\gdx\egygdx\oilgasratio
:del data\gdx\egygdx\estimation\*.gdx
:call egyestimation COAL FG OIL ROIL NG ELEH OTHE
:call gams ebtmerge  o=listings\ebtmerge.lst
:call gams readpricerange o=listings\readpricerange.lst
:call gams oilgassplit o=listings\oilgassplit.lst gdx=data\gdx\sam3
:call finalbalancing2 BEJ TAJ HEB SHX NMG LIA JIL HLJ SHH JSU ZHJ ANH FUJ JXI SHD HEN HUB HUN GUD GXI HAI CHQ SIC GZH YUN SHA GAN NXA QIH XIN
call finalbalancing2 BEJ 
:call gams sam4merge o=listings\ebt4merge.lst 
:call gams tradebalancing o=listings\tradebalancing.lst gdx=data\gdx\sam5 
pause