tic
[X,Z] = simulate( 1000, 0, 500, 10, 2, 15 );
[h,g] = variogram( X, Z, 50, 20 );
view(X, Z, h, g);
toc