## Análisis de componentes principales

states =row.names(USArrests )
states

## Las columnas de la base de datos
names(USArrests )

## la funcion apply nos permite aplicar diferentes funciones

apply(USArrests , 2, mean)
apply(USArrests , 2, var)

## Componentes principales con la funcion prcomp()
##scale = TRUE, Para tener variables on desviacion estandar de 1

pr.out =prcomp (USArrests , scale =TRUE)

names(pr.out )
# las medias antes de escalarlas
pr.out$center

# despues de escalarlas
pr.out$scale

# nos da los loadings por componente principal 
pr.out$rotation

dim(pr.out$x )

# scale =0 nos asegura que las flechas esten escaladas para que representen 
# los loadings , otros valores nos pueden biplots diferentes con 
# diferentes interpretaciones

biplot (pr.out , scale =0)

## con esto hacemos algunos cambios
pr.out$rotation=-pr.out$rotation
pr.out$x=-pr.out$x

biplot (pr.out , scale =0)

## tambien podemos tener la desviación estandar de cada componente

pr.out$sdev

pr.var =pr.out$sdev ^2
pr.var

## para computar la PVE
pve=pr.var/sum(pr.var )
pve


plot(pve, xlab=" Principal Component", ylab=" Proportion of
Variance Explained", ylim=c(0,1) ,type="b")

plot(cumsum (pve ), xlab=" Principal Component ", ylab ="
Cumulative Proportion of Variance Explained ", ylim=c(0,1) ,
     type="b")


### Clustering K means

set.seed (2)
x=matrix (rnorm (50*2) , ncol =2)
x[1:25 ,1]=x[1:25 ,1]+3
x[1:25 ,2]=x[1:25 ,2] -4

## hacemos el cluster con K=2
km.out =kmeans (x,2, nstart =20)
km.out$cluster


plot(x, col =(km.out$cluster +1) , main="K-Means Clustering
Results with K=2", xlab ="", ylab="", pch =20, cex =2)

set.seed (4)
km.out =kmeans (x,3, nstart =20)
km.out

set.seed (3)
km.out =kmeans (x,3, nstart =1)
km.out$tot .withinss
km.out =kmeans (x,3, nstart =20)
km.out$tot .withinss

## Hierarchical Clustering

hc.complete =hclust(dist(x), method ="complete")

hc.average =hclust(dist(x), method ="average")
hc.single =hclust(dist(x), method ="single")

par(mfrow =c(1,3))
plot(hc.complete ,main =" Complete Linkage ", xlab="", sub ="",
       cex =.9)
plot(hc.average , main =" Average Linkage ", xlab="", sub ="",
       cex =.9)
plot(hc.single , main=" Single Linkage ", xlab="", sub ="",
       cex =.9)

cutree (hc.complete , 2)
cutree (hc.average , 2)
cutree (hc.single , 2)

cutree (hc.single , 4)

# para escalar las variables antes de hacer el hierarchical clustring

xsc=scale (x)
plot(hclust (dist(xsc), method ="complete"), main =" Hierarchical
Clustering with Scaled Features ")

x=matrix (rnorm (30*3) , ncol =3)

dd=as.dist(1- cor(t(x)))
plot(hclust (dd, method ="complete"), main=" Complete Linkage
with Correlation -Based Distance ", xlab="", sub ="")
