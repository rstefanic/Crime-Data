%%
%% MATLAB program to analyze 3 years of UIC crime data.
%%
%% Robert Stefanic
%% University of Illinois, Chicago
%% CS109, Fall 2015
%% Homework 21
%%

function AnalyzeCrimesAtUIC(file1, file2, file3)

%% column vector of months: note the use of ; not ,

months = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul'; ...
        'Aug';'Sep';'Oct';'Nov';'Dec'];
 
%% load data 
a = load(file1);
b = load(file2);
c = load(file3);

hold on;

%% label the graphs, label, and set the limits on the x-axis
title('Crimes on UIC East Campus');
xlabel('Months');
ylabel('# of Crimes');

xlim([1 12]);           % we want 12 values on the X-axis
set(gca, 'XTickLabel', months); %% display months instead of 1 ... 12

plot(a);
plot(b);
plot(c);

%% label the legend
legend(file1, file2, file3);

hold off; %% figure complete

%% x is down, y is up, z is same
x = 0;
y = 0;
z = 0;

for i=[1:12]

    %% output all the months and data
    fprintf('%s: ', months(i, 1:3)); %% print i'th month, all 3
    
    if c(i) < b(i) && c(i) < a(i)
        fprintf('-\n')
        x = x + 1;
    elseif c(i) > b(i) && c(i) > a(i) && b(i) > a(i)
        fprintf('+\n')
        y = y + 1;
    else
        fprintf('#\n')
        z = z + 1;
    end
    
end

%% output the overall results
fprintf('\nOverall? ')
if x > y && x > z
    fprintf('Mostly down')
elseif y > x && y > z
    fprintf('Mostly up')
elseif z > x && z > y
    fprintf('Mostly the same')
end
fprintf('\nUp: %i', y);
fprintf('\nDown: %i', x);
fprintf('\nSame: %i\n', z);


end