function in = inf2nan(in)

if iscell(in)
    for k=1:length(in)
        curIn = in{k};
        curIn(curIn==inf) = NaN;
        curIn(curIn==-inf) = NaN;
        in{k} = curIn;
    end
else
    in(in==inf) = NaN;
    in(in==-inf) = NaN;
end

end