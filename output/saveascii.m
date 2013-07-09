function varargout = saveascii(X,File,varargin)
%SAVEASCII   Save column matrix with given format, delimiter or precision.
%
%   Syntax:
%                    saveascii(X,File)            % Saves with default.
%                    saveascii(X,File,OPTIONS)    % Saves with options
%        FormatStr = saveascii(X,File,...);       % ... also returns format
%    [Y,FormatStr] = saveascii(X,File,...);       % ... also matrix string. 
%                    saveascii(X)                 % Displays.
%                    saveascii(X,[],...)          % Displays with options.
%                Y = saveascii(X,[],...);         % Returns matrix string.
%    [Y,FormatStr] = saveascii(X,[],...);         % ... also format string.
%
%   Input:
%    X       - Numeric (real, double, integer), logical or string 2D matrix
%              to be saved. 
%    File    - String or identifier specifying the output file. Default:
%              empty (displays in the Command Window). Optional input.
%    OPTIONS - List of optional arguments for the format and open file
%              permission (see below for description). The input is
%              user-friendly.
%
%   Output (all optional):
%    Y         - The matrix X converted to a string in the specified
%                format. 
%    FormatStr - String vector containing the format string of the saved
%                matrix.
%
%   Description:
%    This program saves a numeric or string matrix in an ascii file with an
%    specific format and delimiter for each (or every) column, given 
%    optionaly by the user in a friendly way.
% 
%    The matrix can be append to an existing file or written on a
%    previously opened file (identifier input, see FOPEN for details). In
%    this latter case the file won't be closed. Uses the function FPRINTF
%    to print.
%
%    It has the special feature to save a numeric matrix by specifying the
%    precision (positive integers) for each (or every) column. The program
%    calculates by itself the column width for the floating point
%    specifier, avoiding the user to specify the whole string format (see
%    SPRINTF for details). Gives and special treatment to NaN, Inf or -Inf
%    elements.
%
%    If no output file is given (or there is an output argument), the
%    program works like a matrix converter from numeric to string, in 
%    the way already mentioned (distinguishing between columns), likely
%    NUM2STR function. The result can be reverted by the STR2NUM function.
%    Similarly, the saved numeric data on the ascii file can be loaded
%    using:
%                      X = load(File); 
%    
%   Format OPTIONS:
%    This program creates by itself the format string from the defaults
%    (which can be easily modified) or the user specifications given as
%    optional arguments. This OPTIONS can be written in any order,
%    separated by commas or by cells. They are as follows (Ncol is the
%    number of columns of the matrix X):
%
%    - Permission: One string specifying the open permission of the file
%           (see FOPEN for details). For example, ['a'] to append the
%           matrix to the file.
%
%               Default: ['w']  (i.e., creates or OVERWRITES the file).
%
%           Note: By default the file is open with the text mode
%           permission (i.e., ['w'] is changed to ['wt']) which affects
%           only to Windows users. Use 'wb' for binary mode (see FOPEN for
%           details). This option is ignored if a file identifier is given.
%
%    - Precision: One or Ncol integers values or one vector with Ncol
%           integers specifying the precision (number of decimals) for each
%           (or every) column to be used along with the floating point
%           specifier: 'f'. For example, [0] if you need to save integers.  
%
%               Default: this option is not used by default.
%
%           Note: It works faster if only one is given. This option is 
%           ignored if a format string is given.
%
%    - Beginner: One string with the '<' char at the beginning (which will
%           be ignored), specifying the characters to be written at the
%           beginning of every row. For example, use ['<%% '] to comment
%           all the rows. 
%
%               Default: ['<']  (i.e., none).
%
%           Note: Use ['<f<...'] to force beginning with '<...' ('<f' will
%           be ignored).
%
%    - Ending: One string with the '>' char at the beginning (which will
%           be ignored), specifying the characters to be written at the
%           ending of every row and also the newline format. For example,
%           ['>\r'] for use the newline for Mac OS. 
%
%               Default: ['>\n']  (i.e., newline for Linux OS).
%
%           Note: This default ending seems to work with Windows OS, which
%           uses '\r\n' as newline. If any of this 3 newlines endings is
%           ommited (['> .'] for example) the newline for the current OS
%           will be used (use the COMPUTER function). Use ['>f>...'] to
%           force ending with '>...' ('>f' will be ignored).
%
%    - Format: One or Ncol strings with the '%' char in the beginning,
%           specifying the format string to be use for every or each
%           column. For example, if Ncol=3:  ['%4.1e']  or ['%4.1e',
%           '%8.4f', '%5.2g']  or  ['%4.1e\t%8.4f, %5.2g'] (whole) can
%           work.
%
%               Default: ['% 8.7e']  - for a numeric matrix (same as SAVE),
%                        ['%c']      - for a string  matrix.
%
%           Note: It works faster if only one is given. Can be a cell
%           array.  
%
%    - Delimiter: One or N-1 strings that do not fill the requirements of
%           the former options, specifying the delimiters to be used
%           between the columns. For example, [',\t'] comma plus tab.
%
%               Default: [' ']  - for a numeric matrix (single space),
%                        ['']   - for a string  matrix (none).
%
%           Note: It works faster if only one is given. To be able to use
%           the '%', 'a', 'w', '<' and '>' chars as delimiters, write them
%           twice: '%%%...', 'aa...', etc. The first char will be ignored.
%           This option is ignored if a full format string is given. It can
%           be a cell array.
%
%   Examples:
%      >> x = [     1          2  -1234.5678  12345.6789 
%                 6e7       6e-5        6e-6        -6e3  
%                .008  -987.3456     0.00045          pi  ];
%
%
%      >> saveascii(x)
%      Result: (same as ugly as SAVE function)
%       1.0000000e+000  2.0000000e+000 -1.2345678e+003  1.2345679e+004
%       6.0000000e+007  6.0000000e-005  6.0000000e-006 -6.0000000e+003
%       8.0000000e-003 -9.8734560e+002  4.5000000e-004  3.1415927e+000
%
%
%      >> [y,f] = saveascii( x, [], [4 3 2 0], {' : ' '\t' ',   '}, '<c ')
%         Result: (more friendly than DLMWRITE)
%      y =
%      c        1.0000 :    2.000	-1234.57,   12346
%      c 60000000.0000 :    0.000	    0.00,   -6000
%      c        0.0080 : -987.346	    0.00,       3
%
%      f =
%      c %13.4f : %8.3f\t%8.2f,   %5.0f\n
%
%
%      >> saveascii(['Size(x) = [' saveascii(size(x),[],3,', ') '];'])
%         Result: (as input string matrix to save another one)
%      Size(x) = [3.000, 4.000];
%
%
%      >> saveascii('% SAVEASCII DEMO:','sa_demo.txt')
%      >> saveascii(x,'sa_demo.txt','%013.4f','%8.3f','%8.2f','%05.0f','a')
%         Result: (see the append with edit('sa_demo.txt'))
%      % SAVEASCII DEMO:
%      00000001.0000    2.000 -1234.57 12346
%      60000000.0000    0.000     0.00 -6000
%      00000000.0080 -987.346     0.00 00003
%         
%
%   See also SAVE, FPRINTF, SPRINTF, DLMWRITE, CSVWRITE, FOPEN, STR2DOUBLE,
%   STR2NUM, NUM2STR

%   Copyright 2004-2008 Carlos Adrian Vargas Aguilera
%   $Revision: 4.0.3 $  $Date: 2008/05/05 10:30:00 $

%   Written by
%   M.S. Carlos Adrian Vargas Aguilera
%   Physical Oceanography PhD candidate
%   CICESE 
%   Mexico, 2004-2006-2007-2008
%   nubeobscura@hotmail.com
%
%   Download from:
%   http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objec
%   tType=author&objectId=1093874

%   2004 - v1 Matrix format (only 3 lines!).
%   2006 - v2 Distinguish columns.
%   2007 - v3 Decimals for floating-point, 'wt', output, string input.
%   2008 - v4 Cleaner and rewritten code (cells), new help, reduced running
%             time, fixed minor bugs, reduced memory usage, accounts for
%             not finite numbers and NaN's, change default delimiter to
%             single space instead of tab, change beginner char '@' to '<',
%             added ending option, optionaly format string output.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Errors checking
% Checks for errors in the first two arguments.

% No inputs?:
Nnargin = nargin;
Nnargout = nargout;
if Nnargin<1
 error('SAVEASCII:NotEnoughInput',...
  'Not enough input arguments.')
end
% Many outputs?
if ~ismember(Nnargout,[0 1 2])
 error('SAVEASCII:IncorrectOutputNumber',...
  'Incorrect number of output arguments. Must be 0, 1 or 2.')
end
% No matrix?:
if (ndims(X) > 2)
 error('SAVEASCII:InvalidInputSize','Input matrix must be 2 dimensional.')
end
% No output file?:
fid = [];
if Nnargin<2
 File = [];
elseif ischar(File)
 if strcmp(File,'')
  File = [];
 end
elseif ~isempty(File)
 if isnatural(File) && (File>2) % File identifier.
  fid = File;
 else
  error('SAVEASCII:InvalidInputType', ...
   'Input file name must be a string, a valid file identifier or empty.')
 end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defaults
% Sets the default format string and permission open mode. Modify them as
% needed.

% For the string optional input:
Str.permission = 'w';     % OVERWRITES!!!!!!
Str.textmode   = 't';     % 't': text, 'b': binary. Former for WINDOWS OS.
Str.beginner   = '<';     % Empty.
Str.ending     = '>\n';   % NEWLINE for UNIX (works for WINDOWS too!).
if ischar(X)              % String matrix input.
 Str.fmtstrcol = {'%c'};  % Format string for each (every) column.
 Str.delimiter = {''};    % If just text, nothing between chars.
else                      % Numeric (real) or logical matrix input.
 Str.fmtstrcol = {'% 8.7e'}; % Ugly, but MATLAB seems to like it, do you?
 Str.delimiter = {' '};   % Single space. Try '\t' (tab).
end
% For the numeric optional input: 
Num.precision      = [];  % Not used by default.
Num.width          = [];  % Not used by default.
Num.specifier      = 'f'; % Floating-point.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
% Sets the constant parameters.

[Nrow,Ncol] = size(X);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reads the numeric options
% Creates the format string for each (or every) column if the precision is
% given.

if isnumeric(X) || islogical(X)
 % Warns about complex values:
 if ~isreal(X)
  X = real(X);
  warning('Saveacii:ComplexInput',...
  'The imaginary part of the input is ignored.')
 end
 % Search for precision (numeric) input:
 [Num.precision,varargin] = read_precision(Num.precision,varargin,Ncol);
 % If any, then generates the format string for each (or every) column:
 if ~isempty(Num.precision) % By default it is not used.
  % Creates a short matrix x3 to get the width and helps to save memory. It
  % has only 3 rows: 
  % 1. Maximum of X columns (ignoring Inf's)
  % 2. Flags if columns of X has: NaN->1;  Inf->1;  -Inf->-1;  otherwise->0
  % 3. Minimum of X columns (ignoring -Inf's)
  iinf = ~isfinite(X);           %  1's if NaN, Inf or -Inf, 0 otherwise.
  iinfn = find(iinf);            %  To get the -Inf indexes:
  iinfn(isnan(X(iinfn)) ) = [];  % ... deletes the NaN's  % bug fixed mar08
  iinfn(      X(iinfn)>0) = [];  % ... deletes the Inf's
  iinf = double(iinf);           % Turns them to double values
  iinf(iinfn) = -1;              % Put -Inf flags as -1.
  x3 = [maxinf(X,[],1); any(iinf,1)-2*any(iinf<0,1); mininf(X,[],1)];
  % Creates the format string from Num options. You can output the Num for
  % any verification.
  Str.fmtstrcol = ...  [Str.fmtstrcol,Num] = ...
   precision2fmtstrcol(Num,x3,Ncol);
  clear x3
 end
end
clear Num


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reads the string options
% Reads the permission, beginner, delimiters and format strings inputs.
% Sets the permission to be text open mode, which affects only to Windows
% users.

Str = read_stroptions(Str,varargin,Ncol);
Permission = Str.permission;
clear varargin


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generates the format string
% Creates the format string from the optional/default options.

FormatStr = create_formatstring(Str,Ncol);
if isempty(X) % Deletes the format
 FormatStr = '';
end
clear Str Ncol


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Saves ascii file
% Saves the matrix to the ascii file using FPRINTF.

if ~isempty(File)
 if ~isempty(fid)
  fprintf(fid,FormatStr, X.');
 else
  fid = fopen(File,Permission);
  if ~(fid>2)
   error('SAVEASCII:InvalidInputType', ...
   'Input file name must be a string, a valid file identifier or empty.')
  end
  fprintf(fid,FormatStr, X.');
  fclose(fid);
 end
 clear fid Permission
 if Nnargout==1
  varargout{1} = FormatStr;
  return
 end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output or displays the result
% Displays the result matrix string on the Command Window or as an output
% argument using SPRINTF and DISP.

if Nnargout                         % Output string matrix:
 X = sprintf(FormatStr,X.');
 Ncol2 = numel(X)/Nrow;
 if isnatural(Ncol2) % Reshapes it into a string matrix.
  X = reshape(X,Ncol2,Nrow);
  X = X(1:end-1,:)';
 elseif ~isempty(X)
  warning('SAVEASCII:MatrixNotSquare',...
   'The output string is a vector because the matrix is not squared.')
  % NOTE: SAVEASCII tries to convert the output from SPRINTF, which is a
  %       vector string, to a matrix string but fails, probably due to an
  %       incorrect format row.
 end
 varargout{1} = X;
 if Nnargout==2
  varargout{2} = FormatStr;
 end
 clear X Nrow Ncol2 FormatStr
elseif isempty(File)                % Display string matrix:
 X = sprintf(FormatStr,X.');
 Ncol2 = numel(X)/Nrow;
 if isnatural(Ncol2) % Reshapes it into a string matrix.
  X = reshape(X,Ncol2,Nrow);
  X = X(1:end-1,:)';
 elseif ~isempty(X)
  warning('SAVEASCII:MatrixNotSquare',...
   'The output string is a vector because the matrix is not squared.')
  % NOTE: SAVEASCII tries to convert the output from SPRINTF, which is a
  %       vector string, to a matrix string but fails, probably due to an
  %       incorrect format row.
 end
 disp(X)
 clear X Nrow Ncol2 File
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfunctions
% Subfunctions for the SAVEASCII program.

function [precision,opt] = read_precision(precision,opt,Ncol) 
% Extract precision from options in a vector array.

Nopt = length(opt); % Number of options:
if Nopt>0 
 % Get numerical input:
 isnum = false(1,Nopt);
 for k = 1:Nopt
  isnum(k) = isnumeric(opt{k});
 end
 Noptnum = length(isnum(isnum));
 if Noptnum>0
  % Carefull, precision must be a row vector
  precision = [opt{isnum}]; precision = precision(:).';
  % Note: if only one decimal is specified, all the columns will have the
  % same format.
  if ~ismember(length(precision),[1 Ncol])
   error('SAVEASCII:InvalidPrecision',...
    'Length of precision must be 0, 1 or Ncol.')
  end
  % Erase numerical options:
  opt(isnum) = [];
 end
end


function [fmtstrcol,Num] = precision2fmtstrcol(Num,x3,Ncol)
% Calculates the width for each column and creates the format string for
% each column with that width, precision and delimiter.

% Reduce the size of x3 if a single precision is given.
if length(Num.precision)==1
 x3 = [max(x3(1,:)); any(x3(2,:),2)-2*any(x3(2,:)<0,2); min(x3(3,:))];
end
Num.width = calculate_width(Num.precision,x3([1 3],:));
% Check at least 3 digits when NaN's or INF's:
isbad = logical(x3(2,:));
isbad(isbad) = (Num.width(isbad)<=3);
Num.width(isbad) = 3 + any(x3(2,isbad)<0,1);
% Converst from numeric format to format string:
fmtstrcol = pws2fmtstrcol(Num,Ncol);


function width = calculate_width(precision,x)
% Calculates the maximum number of digits for each (or every) column of x.

M = get_order(x);
M(M<0) = 0;                       % M=0 if 0<x<1
M = M+1;                          % Adds the first digit.
M = M+(x<0);                      % Adds the negative character.
% Get the maximum number of characters in each column:
width = max(M,[],1);              % Max of digits to the right of the dot.
% Adds the precision and the dot characters:
width = width + (precision+1).*(precision>0);
% If NaN, InF or -Inf sets at least 3, 3 or 4 digits respectively.
isbad = any(~isfinite(x),1);
isbad(isbad) = (width(isbad)<=3) | ~isfinite(width(isbad));
width(isbad) = 3 + any(x(:,isbad)<0,1);


function fmtstrcol = pws2fmtstrcol(Num,Ncol)
% Creates the format string for each (or every) column from precision,
% width and specifier. 

% Make sure input is an integer:
 if any(~isnatural(Num.precision(:))) || any(Num.precision<0)
  error('SAVEASCII:InvalidPrecision',...
   'Precision must be positive integers.')
 end
 % Added to reduce running time by reducing the usage of INT2STR. Feb 2008
 [w,w,iw] = unique(Num.width);
 [p,p,ip] = unique(Num.precision);
 Nw = length(w);
 Np = length(p);
 Sw = cell(1,Nw);
 Sp = cell(1,Np);
 for k = 1:Nw
  Sw{k} = int2str(Num.width(w(k)));
 end
 for k = 1:Np
  Sp{k} = int2str(Num.precision(p(k)));
 end
 % Writes the format strings:
 fmtstrcol{1} = ['%' Sw{iw(1)} '.' Sp{ip(1)} Num.specifier];
 if Nw*Np~=1
  for k = 2:Ncol
   fmtstrcol{k} = [ '%' Sw{iw(k)} '.' Sp{ip(k)} Num.specifier];
  end
 end 
 
 
function Str = read_stroptions(Str,opt,Ncol)
% Gets the string's options. Reading first the Permission, beginner and
% formats. The final options are considered as delimiters.

Nopt = length(opt);
if Nopt>0
 if ~iscellstr(opt)
  % Check for any cell string input and turns it in strings inputs:
  k = 1;
  while k<=Nopt
   if iscellstr(opt{k})
    nk1 = length(opt{k})-1;
    opt = [opt(1:k-1) opt{k} opt(k+1:Nopt)];
    Nopt = Nopt + nk1;
    k = k + nk1;
   elseif isnumeric(opt{k})     % fixed bug mar. 2008
    opt(k) = [];
    k = k-1;
    Nopt = Nopt-1;
   end
   k = k+1;
  end
  if ~iscellstr(opt)
   error('SAVEASCII:InvalidStrOptionsType',...
    'Optional arguments must be strings or positive integers.')
  end
 end
 Sopt = char(opt);
 % Indexes on the options:
 d  = true(1,Nopt);                       % Delimiters cell element.
 p  = strmatch('a',Sopt);   d(p)  = 0;    % Permission cell element.
 p2 = strmatch('w',Sopt);                 if p2, p=p2; end,
                            d(p2) = 0;
 b  = strmatch('<',Sopt);   d(b)  = 0;    % Beginner cell element.
 e  = strmatch('>',Sopt);   d(e)  = 0;    % Ending cell element.
 f  = strmatch('%',Sopt);   d(f)  = 0;    % Formats cell element.
 % Permission -> String:
 if ~isempty(p) 
  [Str.permission,opt(p),mbad] = get_permission(Str.permission,opt(p)); 
  d(p(mbad)) = 1; % Sends bad to delimiters.
 end
 % Beginner   -> string:
 if ~isempty(b)
  [Str.beginner,opt(b),bbad]   = get_beginner(Str.beginner,opt(b)); 
  d(b(bbad)) = 1; % Sends bad to delimiters.
 end
 % Ending     -> string:
 if ~isempty(e)
  [Str.ending,opt(e),ebad]   = get_ending(Str.ending,opt(e)); 
  d(e(ebad)) = 1; % Sends bad to delimiters.
 end
  % Formats   -> cell:
 if ~isempty(f)
  [Str.fmtstrcol,opt(f),fbad]  = get_fmtstrcol(Str.fmtstrcol,opt(f),Ncol);
  d(f(fbad)) = 1; % Sends bad to delimiters.
 end
 % Delimiters -> cell:
 if any(d)
  Str.delimiter                = get_delimiter(Str.delimiter,opt(d),Ncol); 
 end 
end
% Fix Permission: (Windows OS)
if (length(Str.permission)==1 || ...
  (length(Str.permission)==2 && strcmp(Str.permission(2),'+'))) && ... 
  (strcmp(Str.textmode,'t') || strcmp(Str.textmode,'b'))
  Str.permission = [Str.permission Str.textmode];
end
% Fix Beginner:
if ~isempty(Str.beginner)
 Str.beginner(1) = [];
 if length(Str.beginner)>1 && strcmpi(Str.beginner(1:2),'f<')
  Str.beginner(1) = [];
 end
end
% Fix Ending: (NEWLINE for current OS obtained from COMPUTER function).
if ~isempty(Str.ending)
 Str.ending(1) = [];
 if length(Str.ending)>1 && strcmpi(Str.ending(1:2),'f>')
  Str.ending(1) = [];
 end
end
if isempty(Str.ending) || length(Str.ending)<2 || ...
  ~(strcmp(Str.ending(end-1:end),'\n') || ...
    strcmp(Str.ending(end-1:end),'\r'))
 if     ispc         % PC's
  Str.ending = [Str.ending '\r\n'];
 elseif isunix       % UNIX's and LINUX's
  Str.ending = [Str.ending '\n'];     
 else  %ismac        % MAC's
  Str.ending = [Str.ending '\r'];     
 end
end

 
function FormatStr = create_formatstring(Str,Ncol)
% Generates the whole format string from the options or defaults.

FormatStr = [];
Nf = length(Str.fmtstrcol);
% a) Super format:
if Nf==1 
 Nf = numel(strfind(Str.fmtstrcol{1},'%')); 
 if Nf==Ncol 
  FormatStr = Str.fmtstrcol{1};
 elseif Nf~=1       % Error in the full format string option.
  error('SAVEASCII:InvalidStrOptionsSize',...
   'Number of format strings must be 0, 1 or Ncol.')
 end
end
% b) Piecewise format:
if isempty(FormatStr)
 FormatStr = Str.fmtstrcol{1};
 Nd = length(Str.delimiter);
 if Nd==1           % Single delimiter?
  if Nf==1          %  + single format?
   FormatStr = [FormatStr repmat([Str.delimiter{1} Str.fmtstrcol{1}],1,Ncol-1)];
  else              %  + Ncol formats? 
   for k = 2:Ncol
    FormatStr = [FormatStr Str.delimiter{1} Str.fmtstrcol{k}];
   end
  end
 elseif Nd==Ncol-1  % Ncol-1 delimiters?
  if Nf==1          %   + single format?
   for k = 2:Ncol
    FormatStr = [FormatStr Str.delimiter{k-1} Str.fmtstrcol{1}];
   end
  else              %   + Ncol formats?
   for k = 2:Ncol
    FormatStr = [FormatStr Str.delimiter{k-1} Str.fmtstrcol{k}];
   end
  end
 else               %   No delimiters (all failed)
  if Nf==1          %   + single format?
   FormatStr = repmat(FormatStr,1,Ncol);
  else              %   + Ncol formats?
   for k = 2:Ncol
    FormatStr = [FormatStr Str.fmtstrcol{k}];
   end
  end
 end
end
% Add beginner and ending:
FormatStr = [Str.beginner FormatStr Str.ending];

 
function [permission,opt,mbad] = get_permission(permission,opt)
% Gets open permission. If the input has two 'a's or two 'w's at the
% beginning, the first letter will be cleared and the rest considered as a
% delimiter. Permission is a STRING. It is forced to open in text mode:
% 'at' and 'wt', which affects only to Windows users. 

Np = length(opt);
mbad = false(1,Np);
for k = 1:Np % Sends to delimiters the ones has double 'a's or 'w's.
 if (length(opt{k})>1) && (strcmpi(opt{k}(2),'w') || strcmpi(opt{k}(2),'a'))
  mbad(k) = 1;
  opt{k}(1) = [];   % Deletes first letter, i.e., 'ww...'='w...', etc.
 else               
  p = k;
 end
end
Np = Np-length(mbad(mbad));
if ~ismember(Np,[0 1]) 
 error('SAVEASCII:InvalidStrOptionsSize',...
  'Number of permissions must be 0 or 1.')
elseif Np
 permission = opt{p}; % String
 % Force permission second char to be one of '+', 't' or 'b':
 if (length(permission)>1) && ~(strcmp(permission(2),'+') ...
   || strcmpi(permission(2),'t') || strcmpi(permission(2),'b'))
  error('SAVEASCII:InvalidPermission',...
       ['Open permission mode second char must be one of ' ...
        '''+'', ''t'' or ''b'''])
  % NOTE: If you want 'w...' or 'a...' to be a delimiter, write twice the
  %       first letter, which will be ignored. 
 end
end


function [beginner,opt,bbad] = get_beginner(beginner,opt)
% Gets the beginner, if any.

Nb = length(opt);
bbad = false(1,Nb);
for k = 1:Nb % Sends to delimiters the ones with double '<'s.
 if length(opt{k})>1 && strcmp(opt{k}(2),'<')
  bbad(k) = 1;
  opt{k}(1) = [];   % Deletes first letters, i.e., '<<...'='<...', etc.
 else
  b = k;
 end
end
Nb = Nb-length(bbad(bbad));
if ~ismember(Nb,[0 1]) 
 error('SAVEASCII:InvalidStrOptionsSize',...
  'Number of beginners must be 0 or 1.')
elseif Nb
 beginner = opt{b};
end


function [ending,opt,ebad] = get_ending(ending,opt)
% Gets the ending, if any.

Ne = length(opt);
ebad = false(1,Ne);
for k = 1:Ne % Sends to delimiters the ones with double '>'s.
 if length(opt{k})>1 && strcmp(opt{k}(2),'>')
  ebad(k) = 1;
  opt{k}(1) = [];   % Deletes first letters, i.e., '>>...'='>...', etc.
 else
  e = k;
 end
end
Ne = Ne-length(ebad(ebad));
if ~ismember(Ne,[0 1]) 
 error('SAVEASCII:InvalidStrOptionsSize',...
  'Number of endings must be 0 or 1.')
elseif Ne
 ending = opt{e};
end


function [fmtstrcol,opt,fbad] = get_fmtstrcol(fmtstrcol,opt,Ncol)
% Gets format strings for each (or every) column, if any.

Nf = length(opt);
fbad = false(1,Nf); f = fbad;
for k = 1:Nf % Sends to delimiters the ones with double '%%'s.
 if length(opt{k})>1 && strcmp(opt{k}(2),'%')
  fbad(k) = 1;
  opt{k}(1) = [];   % Deletes first letter, i.e., '%%...'='%...', etc.
 else
  f(k) = 1;
 end
end
Nf = length(f(f)); % Nf = Nf-length(fbad(fbad)); 
if ~ismember(Nf,[0 1 Ncol]) 
 error('SAVEASCII:InvalidStrOptionsSize',...
  'Number of format strings must be 0, 1 or Ncol.')
elseif Nf
 fmtstrcol = opt(f); 
end


function delimiter = get_delimiter(delimiter,opt,Ncol)
% Gets delimiters between columns, if any.

Nd = length(opt);
if ~ismember(Nd,[0 1 Ncol-1])
 error('SAVEASCII:InvalidStrOptionsSize',...
  'Number of delimiters must be 0, 1 or Ncol-1.')
elseif Nd
 delimiter = opt; 
end


function y = maxinf(x,varargin)
%MAXINF   Largest component ignoring INF's as posible.
%
%    Y = MAXINF(X) is equivalent to MAX but ignoring INF's. If there is no
%    finite elements, then the INF or -INF value is returned; NaN's are
%    return if all the elements are NaN's.

y = max(x,varargin{:});
iinf = isinf(y);
if any(iinf)
 xinf = y(iinf);
 x(~isfinite(x)) = NaN;
 y = max(x,varargin{:});
 inan = isnan(y(iinf));
 if any(inan)
  y(iinf(inan)) = xinf(inan);
 end
end


function y = mininf(x,varargin)
%MININF   Smallest component ignoring -INF's as posible.
%
%    Y = MININF(X) is equivalent to MIN but ignoring -INF's. If there is no
%    finite elements, then the INF or -INF value is returned; NaN's are
%    return if all the elements are NaN's.

y = min(x,varargin{:});
iinf = isinf(y);
if any(iinf)
 xinf = y(iinf);
 x(~isfinite(x)) = NaN;
 y = min(x,varargin{:});
 inan = isnan(y(iinf));
 if any(inan)
  y(iinf(inan)) = xinf(inan);
 end
end


function M = get_order(x)
% Gets the order of magnitud in 10 base, i.e., in scientific notation:
%   M = get_order(y)   =>   y = X.XXXXXX x 10^M

if isinteger(x) % Allows integer input: uint8, etc. 
 x = double(x); % bug fixed Mar 08
end
temp = warning('off','MATLAB:log:logOfZero');
M = floor(log10(abs(x)));       % In cientific notation x = Str.XXX x 10^M.
M(x==0) = 0; % M=0 if x=0. (Bug fixed 10/jan/2008) (bug fixed 05/may/2008)
warning(temp.state,'MATLAB:log:logOfZero')


function yes = isnatural(n)
%ISNATURAL   Checks if an array has natural numbers.
%   Y = ISNATURAL(X) returns an array of the same size as X with ones in
%   the elements of X that are natural numbers (...-2,-1,0,1,2,...), and 
%   zeros where not.

%   Written by
%   M.S. Carlos Adrián Vargas Aguilera
%   Physical Oceanography PhD candidate
%   CICESE 
%   Mexico, November 2006
% 
%   nubeobscura@hotmail.com

yes = (n==floor(n)).*(isreal(n)).*isfinite(n);  % bug fixed Mar 2008


% Carlos Adrian Vargas Aguilera. nubeobscura@hotmail.com