:start


title	Balancing energy data for %1 -- job started at %time%

call gams finalbalancing --prov=%1 o=listings\%1_balance.lst gdx=data\gdx\finalbalancing\%1
:next

shift

if not "%1"=="" goto start


:end
