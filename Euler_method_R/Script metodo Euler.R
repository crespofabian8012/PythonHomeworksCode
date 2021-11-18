f1=function(x) sin(x*sin((180/pi)*x)
f2=function(x,y) X^2+y^2


diffhaciaAdelante=function(fun, x,h){
  
  return(fun(x+h)-fun(h))
}
diffhaciaAtras=function(fun, x,h){
  
  return(fun(x)-fun(x-h))
}
diffCentrada=function(fun, x,h){
  
  return(fun(x+h/2)-fun(x-h/2))
}
derhaciaAdelante=function(fun, x,h){
  
  return(diffhaciaAdelante(fun=fun,x=x,h=h)/h)
}
derhaciaAtras=function(fun, x,h){
  
  return(diffhaciaAtras(fun=fun,x=x,h=h)/h)
}
derCentrada=function(fun, x,h){
  
  return(diffCentrada(fun=fun,x=x,h=h)/h)
}

h=0.1^(1:5)
x=1.5
der1=(f1(x+h)-f1(x))/h
der1
der2=(f1(x)-f1(x-h))/h
der2
der3=(f1(x+h/2)-f1(x-h/2))/h
der3
metodoEuler=function(fun,y0,x0,xf, n){
  h=(xf-x0)/n
  xarray=seq(from=x0,to=xf, by=h)
  yarray=rep(0,length(xarray)-1)
  yarray[1]=y0
  for (i in 2:n-1){
    yarray[i+1]=yarray[i]+fun(x=xarray[i],y=yarray[i])*h
  }
  return(yarray)
}

f2=function(x,y) x^2+y^2
x0=0
y0=1
xf=1.5
n=15
valoresy=metodoEuler(fun=f2,y0=y0,x0=x0,xf=xf, n=n)
valoresy

