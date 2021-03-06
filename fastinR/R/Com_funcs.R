#' Condition number of the source matrix as a function of a variable index
#' 
#' @param mat a compositional vector or dataframe of row-wise compositions
#' @param vars A vector of indices specifying the order in which to add columns (fatty acids)
#' @return A \code{l=length(vars)} vector with condition numbers of \code{mat[vars[1:i]]} for \code{i=1:l}
#' @export
kappas <- function(mat,vars){
  ks <- vector(,length(vars))
  for (i in 1:length(vars)){
    ks[i] <- kappa(mat[,vars[1:i]],exact=T)
  }
  return(ks)
}

#' Closure function for compositions
#' 
#' Implements the sum-to-unit closure for vectors and dataframes (by row). 
#' 
#' @param x a compositional vector or dataframe of row-wise compositions
#' @return A vector who's elements sum to one, or dataframe with rows summing to one
#' @export
clo <- function(x){
  
  if (is.null(dim(x))){xc <- x/sum(x)} else {xc <- t(apply(x,1,function(y){y/sum(y)}))}
  return(xc)
}

#' Additive log ratio (alr) transformation for compositions
#' 
#' Implements the alr transformation for vectors and dataframes
#' @param x a compositional vector or dataframe of row-wise compositions
#' @return an alr transformed vector or dataframe
#' @export 
alr <- function(x){
  x<-clo(x)
  if (is.null(dim(x))){xc <- log(x[1:(length(x)-1)]/x[length(x)])} else {xc <- t(apply(x,1,function(y){log(y[1:(length(y)-1)]/y[length(y)])}))}
  return(xc)
}

#' Centered log ratio (clr) transformation for compositions
#' 
#' Implements the clr transformation for vectors and dataframes
#' @param x a compositional vector or dataframe of row-wise compositions
#' @return an clr transformed vector or dataframe
#' @export 
clr <- function(x){
  x<-clo(x)
  if (is.null(dim(x))){xc <- log(x)-mean(log(x))} else { t(apply(x,1,function(y){log(y)-mean(log(y))}))}
}

#' Cosine distance of elements in a row wise composition matrix
#' 
#' @param mat A dataframe of row-wise compositions
#' @return A distance matrix
#' @export 
adist <- function(mat){
  
  mat <- t(mat)
  dims <- dim(mat)
  dists <- matrix(,dims[2],dims[2])
  for (i in 1:(dims[2]-1)){
    for (j in (i+1):dims[2]){
      dists[j,i] <- 1-(t(mat[,i]) %*% mat[,j])/(sqrt(t(mat[,i]) %*% mat[,i])*sqrt(t(mat[,j]) %*% mat[,j]))
    }}
  dista <- as.dist(dists)
  return(dista)
}

#' Aitchison distance  of elements in a row wise composition matrix
#' @param mat A dataframe of row-wise compositions
#' @return A distance matrix
#' @export 
cdist <- function (mat) {
  dims <- dim(mat)
  dists <- matrix(, dims[1], dims[1])
  for (i in 1:(dims[1] - 1)) {
    for (j in (i + 1):dims[1]) {
      dists[j, i] <- robCompositions::aDist(matrix(mat[i,], nrow = 1),
                                            matrix(mat[j,], nrow=1))
    }
  }
  dista <- as.dist(dists)
  return(dista)
}

#' Ilr basis calucaltion
#' @param D Dimension of the composition
#' @return The base for isometric transform
#' @export 
ilr_base <- function(D) {
  ilrb=matrix(0,D-1,D)
  for(i in 1:(D-1)){
    for (j in 1:(D-i+1)){
      ilrb[i,j] <- ifelse(i<=(D-j),sqrt(1/((D-i)*(D-i+1))),-sqrt((D-i)/(D-i+1)))
    }
  }
  
  return(ilrb)
}

#' Geometric mean of a vector or columns of a dataframe
#' 
#' @param x A vector or dataframe of row-wise compositions
#' @return The geometric mean of a vector or columnwise geometric means for a dataframe
#' @export
gmean <- function(x) if (is.null(dim(x))) {exp(mean(log(x)))} else { t(apply(x,1,function(y){exp(mean(log(x)))}))}