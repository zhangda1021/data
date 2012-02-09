if not exist listings\nul mkdir listings
call gams readrawdata  o=listings\readrawdata.lst 
call gams allsam o=listings\allsam.lst gdx=data\gdx\allsam
pause