%%
%% Analysis of yearly crime around UIC East Campus
%%
%% Robert Stefanic
%% U. of Illinois, Chicago
%% CS109, Fall 2015
%% Homework 23
%%

function AnalyzeCrimesByYear(filename)
  fprintf('** Yearly Crime around UIC East Campus **\n');
  fprintf('\n');
  
  data = load(filename);
  firstYear = min(data(:, 1));  %% what is the first year for this dataset?
  lastYear  = max(data(:, 1));  %% what is the last year for this dataset?
  
  
fprintf('Years for this dataset: %d..%d\n\n', firstYear, lastYear);
 
  operation = menu('Please select an operation:', ...
      'Plot Yearly totals', ...
      'Plot totals vs. arrests', ...
      'Plot totals vs. specific crime');
  
 %%fprintf('Available operations:\n');
 %%fprintf('  1. Plot yearly totals\n');
 %%fprintf('  2. Plot totals vs. arrests\n');
 %%fprintf('  3. Plot totals vs. specific cime\n');

 %%fprintf('\n');

 %%operation = input('Please enter operation >> ');
 
 if operation == 1
      PlotYearlyTotals(data, firstYear, lastYear);
  elseif operation == 2
      PlotTotalsVsArrests(data, firstYear, lastYear);
  elseif operation == 3
      %% value = input('**Enter IUCR crime code: ', 'S');
      inputPrompt = {'Plesae enter IUCR crime code:'};
      inputTitle = 'Crime Code to Analyze';
      inputLines = 1;
      inputDef= {'810'};
      input = inputdlg(inputPrompt, inputTitle, inputLines, inputDef);
      value = input{1,1};
      code = str2num(value);
      [Primary, Secondary] = IUCRtoDescription(code, firstYear, lastYear, ...
           data);
  else
      fprintf('**Error, unknown operation\n');
  end
  
  fprintf('\n');
end


function PlotYearlyTotals(data, firstYear, lastYear)

i = 1;

for year=[firstYear:lastYear]
    
LI = data(:, 1) == year; %% serach column 1 for matching years

X(i) = year;
Y(i) = sum(LI);

fprintf('%d: %i crimes\n', year, Y(i))

i = i + 1;
end


plot(X, Y, 'b-+');
title('Crimes on UIC East Campus');
legend('Total crimes per year');


end


function PlotTotalsVsArrests(data, firstYear, lastYear)

i = 1;

for year=[firstYear:lastYear]
    
L1 = data(:, 1) == year;                %% serach column 1 for matching years
L2 = data(:, 1) == year & data(:, 4);   %% search column 1 and 4 for arrests
X(i) = year;                            %% X axis
Y(i) = sum(L1);                         %% Y axis for crimes
Y1(i) = sum(L2);                        %% Y axis for arrests

percentage = (Y1(i) / Y(i)) * 100;
fprintf('%d: %3.1f%% arrests\n', year, percentage)

i = i + 1;

end

hold on;

plot(X, Y, 'b-+');                     %% plot crimes
plot(X, Y1, 'r-*');                    %% plot arrests
title('Crimes on UIC East Campus');
legend('Total crimes per year', 'Arrests that year');

hold off;
end

function [primary, secondary] = IUCRtoDescription(IUCRcode, firstYear, ...
    lastYear, data)

  codes = dataset('file', 'iucr-codes.txt', 'delimiter', ',') ;

  crime = codes( codes.IUCR==IUCRcode, : ) ;

  [rows, cols] = size(crime) ;
  
  if rows == 0
    %% not found
    primary = 'unknown' ;
    secondary = 'unknown' ;
  else
    %% result of search has 1 row, so grab data we need from 1st row:
    primary = crime{1, 2} ;    %% 2nd column is primary description:
    secondary = crime{1, 3} ;  %% 3rd column is secondary description:
  end
  
  i = 1;
  
  fprintf('**Crime: %s: %s\n', primary, secondary);
  code = IUCRcode;
  
for year=[firstYear:lastYear]
    
L1 = data(:, 1) == year;                %% serach column 1 for matching years
L2 = data(:, 1) == year & data(:, 2) == code; %% search column 1 and 4 for arrests
X(i) = year;                            %% X axis
Y(i) = sum(L1);                         %% Y axis for crimes
Y1(i) = sum(L2);                        %% Y axis for arrests

percentage = (Y1(i) / Y(i)) * 100;
fprintf('%d: %i of this crime (%3.1f%%)\n', year, Y1(i), percentage)

i = i + 1;

end

hold on;

plot(X, Y, 'b-+');                     %% plot crimes
plot(X, Y1, 'r-*');                    %% plot specific crime
s = [primary, ': ', secondary];
title('Crimes on UIC East Campus');
legend('Total crimes per year', s);

hold off;


  
end
