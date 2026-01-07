% ------------------------------------------------------------------------
% Name: Drake Hughes
% Section: 15
% Submission Date: 12/8/2024
%
% File Description: Will give fishing locations along with weights of fish
% caught there. Locations can also be added. 
%
%
% Citation:
%
%
% CORE TECHNIQUES:
%
% <SM:ROP:HUGHES> 53
% <SM:BOP:HUGHES> 53
% <SM:IF:HUGHES> 63
% <SM:SWITCH:HUGHES> _
% <SM:FOR:HUGHES> 72
% <SM:WHILE:HUGHES> 53
% <SM:BUILT_IN_FUNCTIONS:HUGHES> 73, 127
% <SM:PDF:HUGHES> 80
% <SM:PDF_PARAM:HUGHES> 80
% <SM:PDF_RETURN:HUGHES> 80
% <SM:READ:HUGHES> 58
% <SM:WRITE:HUGHES> 188
%
% SPECIFIC TECHNIQUES:
%
% <SM:STRING:HUGHES> 161
% <SM:REF:HUGHES> _
% <SM:SLICE:HUGHES> 118
% <SM:AUG:HUGHES> 181
% <SM:DIM:HUGHES> 74
% <SM:SORT:HUGHES> 89
% <SM:SEARCH:HUGHES> _
% <SM:FILTER:HUGHES> 72
% <SM:VIEW:HUGHES> 107
% <SM:PLOT:HUGHES> 136

%
% -------------------------------------------------------------------------



clc
clear
close all

fprintf('Welcome! This program will help you find spots to fish.\n')

option = input('If you would like to view fishing spots please enter 1. If you would like to add a fishing spot please enter 2: ');
while isempty(option) || option ~= 1 && option ~= 2   % <SM:ROP:HUGHES>  % <SM:BOP:HUGHES>  % <SM:WHILE:HUGHES>
    option = input('Error. Please only enter a 1 to view fishing spots or a 2 to add a fishing spot.');
end

% Import data
fishingSpotsNames = char(readcell('fishingSpotsNames.xlsx')); % <SM:READ:HUGHES> 

fishingSpotsWeights = readmatrix('fishingSpotsWeights.xlsx');


if option == 1 % <SM:IF:HUGHES> _

   WeightOfCaughtFishFiltered = fishingSpotsWeights';

   minFishWeight = input('\nLocations will only show if a fish above a certain weight in lbs has been caught there (ex: 1).\nWhat would you like the minimum weight to be (enter a 0 to see all locations. Must be positive and less than 20): ');
   while isempty(minFishWeight) || minFishWeight < 0 || minFishWeight > 20     
        minFishWeight = input('Error. Please enter a number between 0 and 20: ');
   end
    % filters out locations where largest fish caught is less than input
   for i=size(WeightOfCaughtFishFiltered, 1):-1:1 % <SM:FOR:HUGHES> % <SM:FILTER:HUGHES>
        if max(WeightOfCaughtFishFiltered(i, :)) < minFishWeight  % <SM:BUILT_IN_FUNCTIONS:HUGHES>
           WeightOfCaughtFishFiltered(i, :) = [];  % <SM:DIM:HUGHES>
           fishingSpotsNames(i, :) = [];
        end
   end

   askToBeSorted = input('Would you like to sort locations based on the biggest fish? (1 for yes, 0 for no): ');
   askToBeSorted = binaryInputErrorCheck(askToBeSorted, sprintf('Error. Please only enter a 1 or 0: ')); % <SM:PDF:HUGHES> <SM:PDF_PARAM:HUGHES> <SM:PDF_RETURN:HUGHES> 
   if askToBeSorted == 1 % Sorts locations based on biggest catch
        sortedByWeight = [];
        sortedNames = [];
        maxFishPerLocation = [];
        for i=1:size(WeightOfCaughtFishFiltered, 1)
            maxFishPerLocation = [maxFishPerLocation; max(WeightOfCaughtFishFiltered(i, :))]; % Array containing only the largest caught per location
        end
        numberOfIterations = size(WeightOfCaughtFishFiltered, 1); 
        for i=1:numberOfIterations % <SM:SORT:HUGHES>
            [value, location] = max(maxFishPerLocation);
            sortedByWeight = [sortedByWeight; WeightOfCaughtFishFiltered(location, :)];
            sortedNames = [sortedNames; fishingSpotsNames(location, :)];
            WeightOfCaughtFishFiltered(location, :) = [];
            maxFishPerLocation(location, :) = [];
            fishingSpotsNames(location, :) = [];
        end
        WeightOfCaughtFishFiltered = sortedByWeight;
        fishingSpotsNames = sortedNames;
   end

   if size(fishingSpotsNames, 1) == 1
        Names =  {fishingSpotsNames};  % This is done to prevent an error if there is only one spot left to display
   else 
        Names = fishingSpotsNames;
   end
   table = table(Names, WeightOfCaughtFishFiltered); % Display table
   disp(table) % <SM:VIEW:HUGHES>

   if ~isempty(WeightOfCaughtFishFiltered)

       specificLocationToView = input(sprintf('\nWould you like to see more information about a specific location? \n\tIf so, please input the spot number it is on the table (ex: 1 for %s) or 0 for none: ', fishingSpotsNames(1, :)));
       while isempty(specificLocationToView) || specificLocationToView < 0 || specificLocationToView > size(WeightOfCaughtFishFiltered, 1) || mod(specificLocationToView, 1)     
            specificLocationToView = input('Error. Please enter a whole number that is no greater than the number of locations listed: ');
       end
        
       if specificLocationToView ~= 0
    
            currentLocation = WeightOfCaughtFishFiltered(specificLocationToView, :); % <SM:SLICE:HUGHES
            for i=length(currentLocation):-1:1
                if currentLocation(i) == 0 % Removes all 0s that were added to make array dimensions match ealier
                    currentLocation(i) = [];
                end
            end
        
            fprintf(sprintf('\n%s:\n', fishingSpotsNames(specificLocationToView, :)))
            fprintf('\tThe largest fish caught here was %0.2f lbs\n', max(currentLocation))
            fprintf('\tThe smallest fish caught here was %0.2f lbs\n', min(currentLocation)) % <SM:BUILT_IN_FUNCTIONS:HUGHES>
        
            plotOption = input('Would you like to see a plot of all the fish caught here? (0 for no, 1 for yes): ');
            while isempty(option) || option ~= 0 && option ~= 1    
                plotOption = input('Error. Please only enter a 1 or 0: ');
            end
            
            if plotOption == 1
                catchNumber = 1:size(currentLocation, 2);
                plot(catchNumber, currentLocation, 'cx--') % <SM:PLOT:HUGHES> 
                title('Catches at ', fishingSpotsNames(specificLocationToView, :)) 
                xlabel('Catch Number')
                ylabel('Weight (lbs)')
            end
       end

   else
        fprintf('No locations matched your criteria\n')
   end

elseif option == 2

    isCorrect = 0;
    while isCorrect == 0
        locationName = input('What is the location name? ', 's');
        while isempty(locationName) || isnan(str2double(locationName)) == 0
            locationName = input('Error. What is the location name? ', 's');
        end
        numberOfFishCaughtHere = input('Have any fish been caught here? \nEnter a 0 if none have been caught. If some have, enter how many have been caught: ');
        while isempty(numberOfFishCaughtHere) || numberOfFishCaughtHere < 0 || numberOfFishCaughtHere > 10 || mod(numberOfFishCaughtHere, 1)   
            numberOfFishCaughtHere = input('Error. Please enter a positive whole number (cannot exceed 10): ');
        end
        fishCaughtHere = [];
        for i=1:numberOfFishCaughtHere
            textOutput = sprintf('What was the weight of fish #%d (lbs)? ', i); % <SM:STRING:HUGHES> 
            weight = input(textOutput);
            while isempty(weight) || weight < 0 || weight > 20     
                weight = input('Error. Please enter a number between 0 and 20: ');
           end
            fishCaughtHere = [fishCaughtHere; weight];
        end
    
        fprintf('Please confirm that the following infomation is correct: \n')
        fprintf(sprintf('\tLocation name: %s\n', locationName))
        for i=1:size(fishCaughtHere, 1)
            fprintf('\tFish #%d: %0.2f lbs\n', i, fishCaughtHere(i, :))
        end
        isCorrect = input('Is this correct? (1 for yes, 0 to reenter data): ');
        binaryInputErrorCheck(isCorrect, sprintf('Error. Must be 0 or 1: '))
    end

    
    % Following lines ensure that dimensions match
    while size(fishingSpotsWeights, 1) > size(fishCaughtHere, 1)
        fishCaughtHere = [fishCaughtHere; 0]; % <SM:AUG:HUGHES>
    end
    while size(fishingSpotsWeights, 1) < length(fishCaughtHere)
        fishingSpotsWeights = [fishingSpotsWeights; zeros(1, size(fishingSpotsWeights, 2))];
    end

    weightsCellToWrite = [fishingSpotsWeights, fishCaughtHere]; % Combines previous data with newly entered data
    writecell({fishingSpotsNames, locationName}, 'fishingSpotsNames.xlsx'); % <SM:WRITE:HUGHES> 
    writecell(num2cell(weightsCellToWrite), 'fishingSpotsWeights.xlsx');


end