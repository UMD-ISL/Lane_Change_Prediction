function mse= MSE( X, Y )
%MSE

  [x,y] = size(X);
  mse = 0;

  for i=1:x
    for j=1:y
      mse = double(mse) + double(power((X(i,j)-Y(i,j)),2));
    end
  end

  mse = mse / (x*y);
end