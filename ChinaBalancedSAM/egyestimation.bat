:start


title	Estimating energy data for %1 -- job started at %time%

call gams egyintestimation --egyprod=%1 o=listings\%1_estimation.lst gdx=data\gdx\egygdx\estimation\%1_estimation
:next

shift

if not "%1"=="" goto start


:end
