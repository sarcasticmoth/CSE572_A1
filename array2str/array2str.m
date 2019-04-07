function y = array2str(x, col_sep, row_sep, sep_noncell)
% Converts a (possibly cell, nested) array to string representation
%
% Optional inputs col_sep and row_sep specify separators for the cell arrays.
% They can be arbitrary strings (but they should be chosen as per Matlab rules
% so that the output string evaluates to the input). Optional flag sep_noncell
% can be used to force those separators with non-cell arrays too, instead of
% the separators produced by mat2str (space and semicolon)

% Default values
if nargin<4
    sep_noncell = false;
end
if nargin<3
    row_sep = '; ';
end
if nargin<2
    col_sep = ' ';
end

x = {x}; % this is to initiallize processing
y = {[]}; % [] indicates content unknown yet: we need to go on
done = false;
while ~done
    done = true; % tentatively
    for n = 1:numel(y);
        if isempty(y{n}) % we need to go deeper
            done = false;
            if ~iscell(x{1}) % we've reached ground
                s = mat2str(x{1}); % final content
                if sep_noncell % replace mat2str's separators if required
                    s = regexprep(s,'(?<=^[^'']*(''[^'']*'')*[^'']*) ', col_sep);
                    s = regexprep(s,'(?<=^[^'']*(''[^'']*'')*[^'']*);', row_sep);
                end
                y{n} = s; % put final content...
                x(1) = []; % ...and remove from x
            else % advance one level
                str = ['{' repmat([{[]}, col_sep], 1, numel(x{1})) '}'];
                ind_sep = find(cellfun(@(t) isequal(t, col_sep), str));
                if ~isempty(ind_sep)
                    str(ind_sep(end)) = []; % remove last column separator
                    ind_sep(end) = [];
                end
                step_sep = size(x{1}, 2);
                str(ind_sep(step_sep:step_sep:end)) = {row_sep};
                y = [y(1:n-1) str y(n+1:end)]; % mark for further processing...
                x = [reshape(x{1}.', 1, []) x(2:end)]; % ...and unbox x{1},
                    % transposed and linearized
            end
        end
    end
end
y = [y{:}]; % concatenate all strings