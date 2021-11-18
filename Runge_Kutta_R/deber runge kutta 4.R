RungeKutta4=function(fun,y0,x0,xf,h){
  xarray=seq(from=x0,to=xf, by=h)
  yarray=rep(0,length(xarray)-1)
  yarray[1]=y0
  x=x0
  for (i in 2:length(xarray)-1){
    k1=fun(x=xarray[i],y=yarray[i])
    k2=fun(x=xarray[i]+h/2,y=yarray[i]+h*k1/2)
    k3=fun(x=xarray[i]+h/2,y=yarray[i]+h*k2/2)
    k4=fun(x=xarray[i]+h,y=yarray[i]+h*k3)
    yarray[i+1]=yarray[i]+(h/6)*(k1+2*k2+2*k3+k4)
  }
  return(yarray)
}
RungeKutta4v1=function(fun,w,t0,h, Rt, K, P, maxiter=10000){
  #w=c(u0,z0)
  tactual=t0
  uactual=w[1]
  zactual=w[2]
  posRadiales=c()
  posRadiales=c(posRadiales,sqrt(xactual^2+yactual^2))
  posTiempos= c()
  posTiempos= c(posTiempos,t0)
  i=0
  while((1/uactual)> Rt) & (i < maxiter) ){
    tactual=tactual+h
    wactual=c(uactual,zactual)
    k1=fun(w=wactual,K=K, P=P)
    k2=fun(w=c(uactual+h*k1/2,zactual+h*k1/2), K=K, P=P)
    k3=fun(w=c(uactual+h*k2/2,zactual+h*k2/2), K=K, P=P)
    k4=fun(w=c(uactual+h*k3/2,zactual+h*k3/2), K=K, P=P)
    yactual=yactual+(h/6)*(k1+2*k2+2*k3+k4)
    xactual=xactual+(h/6)*(k1+2*k2+2*k3+k4)
    vxactual=vxactual+(h/6)*(k1+2*k2+2*k3+k4)
    vyactual=vyactual+(h/6)*(k1+2*k2+2*k3+k4)
    posRadiales=c(posRadiales,sqrt(xactual^2+yactual^2))
    posTiempos= c(posTiempos,tactual)
    i=i+1
  }
  return(c(i,tactual,xactual, yactual))
}
RungeKutta4v2=function(fun,w,t0,h, Rt, G, M, maxiter=1200){
  #w=c(x0,y0,vx0, vy0)
  tactual=t0
  yactual=w[2]
  xactual=w[1]
  vxactual=w[3]
  vyactual=w[4]
  print(sqrt(xactual^2+yactual^2))
  posRadiales=c()
  posRadiales=c(posRadiales,sqrt(xactual^2+yactual^2))
  posTiempos= c()
  posTiempos= c(posTiempos,t0)
  i=0
  while( (sqrt(xactual^2+yactual^2)> Rt) & (i < maxiter) ){
    tactual=tactual+h
    wactual=c(xactual,yactual, vxactual,vyactual)
    print(wactual)
    k1=fun(w=wactual,G=G, M=M)
    #print("k1")
    #print(k1)
    k2=fun(w=c(xactual+h*k1[1]/2,yactual+h*k1[2]/2,vxactual+h*k1[3]/2, vyactual+h*k1[4]/2), G=G, M=M)
    #print("k2")
    #print(k2)
    k3=fun(w=c(xactual+h*k2[1]/2,yactual+h*k2[2]/2,vxactual+h*k2[3]/2, vyactual+h*k2[4]/2), G=G, M=M)
    #print("k3")
    #print(k3)
    k4=fun(w=c(xactual+h*k3[1],yactual+h*k3[2],vxactual+h*k3[3], vyactual+h*k3[4]), G=G, M=M)
    #print("k4")
    #print(k4)
    yactual=wactual[2]+(h/6)*(k1[2]+2*k2[2]+2*k3[2]+k4[2])
    xactual=wactual[1]+(h/6)*(k1[1]+2*k2[1]+2*k3[1]+k4[1])
    vxactual=wactual[3]+(h/6)*(k1[3]+2*k2[3]+2*k3[3]+k4[3])
    vyactual=wactual[4]+(h/6)*(k1[4]+2*k2[4]+2*k3[4]+k4[4])
    wactual=c(xactual,yactual, vxactual,vyactual)
    
    posRadiales=c(posRadiales,sqrt(xactual^2+yactual^2))
    print("radio")
    print(sqrt(wactual[1]^2+wactual[2]^2))
    posTiempos= c(posTiempos,tactual)
    i=i+1
  }
  return(c(i,tactual,xactual, yactual))
}


G=6.67384*10^(-11)
M=5.9722*10^24
R=6371*10^3
pivalue=3.141592653589793
vtangencial0=6700
h0=772*10^3
P=1/((R+h0)*vtangencial0)^2
K=G*M
A=(1/(R+h0))-K*P
A
K*P
(1/R*A)-(P*K/A)

theta=acos((1/R*abs(A))-(P*K/abs(A)))
theta
# velocidad trayectoria circular a distancia R+h0 7469.728 m/s
sqrt(G*M/(R+h0))
# velocidad trayectoria circular a distancia R 
sqrt(G*M/(R))
# Radio de la trayectoria cicular 
1/P*K

f1=function(w, P, K) {

  return(c(w[1],-w[2]+P*K))
}


f2=function(w, G, M){
   return(c(w[3], w[4], -G*M*w[1]/((w[1]^2+w[2]^2)^(3/2)), -G*M*w[2]/((w[1]^2+w[2]^2)^(3/2))))

}
results2=RungeKutta4v2(fun=f2,w=c(0,R+h0, -vtangencial0,0),t0=0, h=1., Rt=R, G=G, M=M)
#results1=RungeKutta4v1(fun=f1,w=c(1/(R+h0), 0),t0=0, h=1., Rt=R, K=G*M, P=P)