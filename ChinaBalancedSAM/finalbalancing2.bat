:start


title	Balancing energy data for %1 -- job started at %time%

call gams finalbalancing2 --prov=%1 o=listings\%1_balance.lst gdx=data\gdx\finalbalancing2\%1
:next

:pause
shift

if not "%1"=="" goto start


:end


