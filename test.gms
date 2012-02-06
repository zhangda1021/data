Sets   n     states   / a, b, c /
       m     industries / aa, bb /

Parameter  c1(n)     state cons    / a   40, b  60, c 80   /
           c2(m)     industry cons /aa 60, bb 120/

Table  output(n,m) output value of each industry in each state

         aa      bb
a        100     600
b        200     800
c        300     1000

Display c1,c2,output;


positive variables x(n,m)  cons
variables          j     obj
variables          avg(m)


Equations  criterion criterion definition
           average average
           state   state equation
           industry  industry equation ;

average(m)..
avg(m)=e=sum(n,x(n,m)/output(n,m))/card(n);

criterion..
j=e=sum(m,sum(n,sqr(x(n,m)-avg(m))));

state(n)..
c1(n) =e= sum(m,x(n,m));

industry(m)..
c2(m) =e= sum(n,x(n,m));


Model gua /all/;

Solve gua minimizing j using qcp;

Display x.l;
