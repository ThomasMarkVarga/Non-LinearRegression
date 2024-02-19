function result = convertToBase(index, base,numDigits)
    result = zeros(1, numDigits);
    for i = numDigits:-1:1
        result(numDigits - i + 1) = floor(index / base^(i-1));
        index = mod(index, base^(i-1));
    end
end

