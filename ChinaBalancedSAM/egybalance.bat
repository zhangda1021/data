:start


title	Balancing energy data for %1 -- job started at %time%

call gams egydatabalance --egyprod=%1 o=listings\%1_balance.lst gdx=data\gdx\egygdx\balance\%1_balance
:next

shift

if not "%1"=="" goto start


:end
