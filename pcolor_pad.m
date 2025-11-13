function padded_data = pcolor_pad(data)
% Adds one extra row and column for full pcolor display
[nRows, nCols] = size(data);
padded_data = zeros(nRows+1, nCols+1);
padded_data(1:nRows, 1:nCols) = data;
padded_data(end, 1:nCols) = data(end,:);
padded_data(1:nRows, end) = data(:,end);
padded_data(end,end) = data(end,end);
end
