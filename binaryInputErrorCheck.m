function [inputedValue] = binaryInputErrorCheck(inputedValue,errorMessage)
% [input] = binaryInputErrorCheck(input,errorMessage)
%   
% This function will error check for inputs 1 or 0

   while isempty(inputedValue) || inputedValue ~= 0 && inputedValue ~= 1    
       inputedValue = input(errorMessage);
   end

end