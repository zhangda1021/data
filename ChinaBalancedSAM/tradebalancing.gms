$ontext

        Production activities   A (30) (1-30)
        Commodities             C (30) (31-60)
        Primary Factors         F (2)  (61-62: 61:labor, 62: capital)
        Households              H (1)  (63)
        Central Government      G1(1)  (64)
        Provincial Government   G2(1)  (65)
        Types of taxes          T (4)  (66-69: 66: production tax, 67: commodity tax, 68: factor tax, 69: income tax)
        Rest of country         DX(1)  (70: domestic inflow and outflow)
        Rest of world           X (1)  (71: import and export)
        Investment-savings      I (2)  (72:Capital formation, 73: Inventory change)
        Trade margin            M (1)  (74)

Here is a "MAP" of the SAM with the names of the submatrices which
contain data.  All cells with no labels are empty:



           A       C        F       H      G1      G2       T       DX      X      I1      I2      M
        ------------------------------------------------------------------------------------------------
A       |       |   ac  |       |       |       |       |   sa  |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
C       |   ca  |       |       |   ch  |       |  g2d  |       |   der |   er  |  cs1  |  cs2  |  trn  |
        ------------------------------------------------------------------------------------------------
F       |   fa  |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
H       |       |       |   hf  |       |       |  hg2  |       |   dhr |   hr  |       |       |       |
        ------------------------------------------------------------------------------------------------
G1      |       |       |       |       |       |  g1g2 |       |       |       |  cg1s |       |       |
        ------------------------------------------------------------------------------------------------
G2      |       |       |       |       | g2g1  |       |   tr  |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
T       |   ta  |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
DX      |       |  drc  |       |  drh  |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
X       |       |   rc  |       |   rh  |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
I1      |       |       |   dp  |  psv1 | g1sv  |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
I2      |       |   ic  |       |  psv2 |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
M       |       |   mrg |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
$offtext
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder1 '%projectfolder%/data/gdx/finalbalancing2'
$setlocal inputfolder2 '%projectfolder%/data/gdx'
*SAM table
set     i_   SAM rows and colums indices   /
        1*30    Industries,
        31*60   Commodities,
        61      Labor,
        62      Capital,
        63      Household,
        64      Central Government,
        65      Local Government,
        66      Production tax,
        67      Commodity tax,
        68      Factor tax,
        69      Income tax,
        70      Domestic trade,
        71      Foreign trade,
        72      Investment,
        73      Inventory,
        74      Trade margin/;
alias (i_,j_);
set      r China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;

parameter sam4_(r,i_,j_)           SAM v4.0 ready for rebalancing

$gdxin '%inputfolder1%/sam4.gdx'
$load sam4_=sam4

*----------------------------------------------------------------------------------
*        SECTOR AGGREGATION TO ACHIEVE THE CONSISTENCY WITH GTAP
*----------------------------------------------------------------------------------
set     i   SAM rows and colums indices   /
        1*26    Industries,
        27*52   Commodities,
        53      Labor,
        54      Capital,
        55      Household,
        56      Central Government,
        57      Local Government,
        58      Production tax,
        59      Commodity tax,
        60      Factor tax,
        61      Income tax,
        62      Domestic trade,
        63      Foreign trade,
        64      Investment,
        65      Inventory,
        66      Trade margin/;
alias (i,j);
set	mapi(i_,i)/
	1.1
	2.2
	3.3
	4.5
	5.5
	6.6
	7.7
	8.8
	9.9
	10.10
	11.11
	12.12
	13.13
	14.14
	15.15
	16.16
	17.17
	18.16
	19.18
	20.16
	21.19
	22.19
	23.20
	24.21
	25.22
	26.23
	27.24
	28.25
	29.26
	30.4
	31.27
	32.28
	33.29
	34.31
	35.31
	36.32
	37.33
	38.34
	39.35
	40.36
	41.37
	42.38
	43.39
	44.40
	45.41
	46.42
	47.43
	48.42
	49.44
	50.42
	51.45
	52.45
	53.46
	54.47
	55.48
	56.49
	57.50
	58.51
	59.52
	60.30
	61.53
	62.54
	63.55
	64.56
	65.57
	66.58
	67.59
	68.60
	69.61
	70.62
	71.63
	72.64
	73.65
	74.66
/;
set	mapj(j_,j)/
	1.1
	2.2
	3.3
	4.5
	5.5
	6.6
	7.7
	8.8
	9.9
	10.10
	11.11
	12.12
	13.13
	14.14
	15.15
	16.16
	17.17
	18.16
	19.18
	20.16
	21.19
	22.19
	23.20
	24.21
	25.22
	26.23
	27.24
	28.25
	29.26
	30.4
	31.27
	32.28
	33.29
	34.31
	35.31
	36.32
	37.33
	38.34
	39.35
	40.36
	41.37
	42.38
	43.39
	44.40
	45.41
	46.42
	47.43
	48.42
	49.44
	50.42
	51.45
	52.45
	53.46
	54.47
	55.48
	56.49
	57.50
	58.51
	59.52
	60.30
	61.53
	62.54
	63.55
	64.56
	65.57
	66.58
	67.59
	68.60
	69.61
	70.62
	71.63
	72.64
	73.65
	74.66
/;
parameter sam4(r,i,j) AGGREGATED SAM DATA;
sam4(r,i,j)=sum(mapi(i_,i),sum(mapj(j_,j),sam4_(r,i_,j_)));
display sam4;

*-------------------------------------------------------------------
*       Read GTAP data:
*-------------------------------------------------------------------
set
        s   Inter-national regions (GTAP)   /
AUS,NZL,XOC,CHN,HKG,JPN,KOR,TWN,XEA,KHM,IDN,LAO,MMR,MYS,PHL,SGP,THA,VNM,XSE,BGD,IND,PAK,LKA,XSA,CAN,USA,MEX,XNA,ARG,BOL,BRA,CHL,COL,ECU,PRY,PER,URY,VEN,XSM,CRI,GTM,NIC,PAN,XCA,XCB,AUT,BEL,CYP,CZE,DNK,EST,FIN,FRA,DEU,GRC,HUN,IRL,ITA,LVA,LTU,LUX,MLT,NLD,POL,PRT,SVK,SVN,ESP,SWE,GBR,CHE,NOR,XEF,ALB,BGR,BLR,HRV,ROU,RUS,UKR,XEE,XER,KAZ,KGZ,XSU,ARM,AZE,GEO,IRN,TUR,XWS,EGY,MAR,TUN,XNF,NGA,SEN,XWF,XCF,XAC,ETH,MDG,MWI,MUS,MOZ,TZA,UGA,ZMB,ZWE,XEC,BWA,ZAF,XSC
        /;
alias(s,ss);
set
        i__     /
        pdr,
        wht,
        gro,
        v_f,
        osd,
        pfb,
        ocr,
        ctl,
        oap,
        rmk,
        wol,
        frs,
        fsh,
        coa,
        oil,
        gas,
        omn,
        cmt,
        omt,
        vol,
        mil,
        pcr,
        sgr,
        ofd,
        b_t,
        tex,
        wap,
        lea,
        lum,
        ppp,
        p_c,
        crp,
        nmm,
        i_s,
        nfm,
        fmp,
        mvh,
        otn,
        ele,
        ome,
        omf,
        ely,
        gdt,
        wtr,
        cns,
        trd,
        otp,
        wtp,
        atp,
        cmn,
        ofi,
        isr,
        obs,
        ros,
        osg,
        dwe
        /;
parameter       vxmd_(i__,s,ss) Trade - bilateral exports at market prices
$gdxin '%inputfolder2%/gsd_001.gdx'
$load vxmd_=vxmd
$gdxin
set
	mapii(i__,i) /
	pdr.1
	wht.1
	gro.1
	v_f.1
	osd.1
	pfb.1
	ocr.1
	ctl.1
	oap.1
	rmk.1
	wol.1
	frs.1
	fsh.1
	coa.2
	oil.3
	gas.4
	omn.5
	cmt.1
	omt.1
	vol.1
	mil.1
	pcr.1
	sgr.1
	ofd.6
	b_t.6
	tex.7
	wap.8
	lea.8
	lum.9
	ppp.10
	p_c.11
	crp.12
	nmm.13
	i_s.14
	nfm.14
	fmp.15
	mvh.17
	otn.17
	ele.18
	ome.16
	omf.19
	ely.20
	gdt.21
	wtr.22
	cns.24
	trd.24
	otp.25
	wtp.25
	atp.25
	cmn.26
	ofi.26
	isr.26
	obs.26
	ros.26
	osg.26
	dwe.26	
        /;

parameter
       vxmd(i,s,ss) Trade - bilateral exports at market prices;
vxmd(i,s,ss)=sum(mapii(i__,i),vxmd_(i__,s,ss));
display vxmd;
$exit


*----------------------------------------------------------------------------------
*        FINAL BALANCING
*----------------------------------------------------------------------------------
positive variables finalsam (r,i,j)
positive variables rowsum(r,i)
positive variables columnsum(r,i)
positive variables domesticinsum(i)
positive variables domesticoutsum(i)
variable jj

Equations
        rsum
        csum
        sumbalance
        drcsum
        dxsum
        tradebalance
        obj
;

rsum(r,i)..
sum(j,finalsam(r,i,j))=e=rowsum(r,i);

csum(r,i)..
sum(j,finalsam(r,j,i))=e=columnsum(r,i);

sumbalance(r,i)..
rowsum(r,i)=e=columnsum(r,i);

drcsum(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticinsum(i)=e=sum(r,finalsam(r,"70",i));

dxsum(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticoutsum(i)=e=sum(r,finalsam(r,i,"70"));

tradebalance(i)$((ord(i)>=31) and (ord(i)<=60))..
domesticinsum(i)=e=domesticoutsum(i);

obj..
*jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam4(r,i,j)))));
jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam4(r,i,j)))))+10000*sum(r,sum(i$((ord(i)=32) or (ord(i)=33) or (ord(i)=41) or (ord(i)=53) or (ord(i)=54) or (ord(i)=60) or (ord(i)=70) or (ord(i)=71)),sum(j$((ord(j)=2) or (ord(j)=3) or (ord(j)=11) or (ord(j)=23) or (ord(j)=24) or (ord(j)=30) or (ord(j)=70) or (ord(j)=71)),sqr(finalsam(r,i,j)-sam4(r,i,j)))));

Model gua /all/;
loop(r,
loop(i,
loop(j,
finalsam.l(r,i,j)=sam4(r,i,j);
);););
loop(r,
loop(i,
loop(j,
if (sam4(r,i,j)=0,
finalsam.fx(r,i,j)=0;
);
);
);
);
gua.iterlim=100000;
gua.reslim=100000000000;
Solve gua minimizing jj using nlp;
display finalsam.l;


set     negval5(i,j)     Flag for negative elements;
set     empty5(i,*)      Flag for empty rows and columns;
parameter       chkfinalsam(i,*)       Consistency check of social accounts;
parameter totoutput3(r);
loop(r,
totoutput3(r)=0;
);
loop(r,
loop(i$((ord(i)>=31) and (ord(i)<=60)),
totoutput3(r)=totoutput3(r)+sum(j,finalsam.l(r,i,j));
);
);

parameter sam5(r,i,j);
loop(r,
loop(i,
loop(j,
sam5(r,i,j)= finalsam.l(r,i,j);
);
);
);

