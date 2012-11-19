function [ history ] = bundle(varargin) 
% Bundles a bunch of workspace variables/expressions into a structure.
%
% Usage:
%      
%     To bundle a workspace variable, call bundle with that
%     variable as an argument.  For example:
%
%     b = bundle(foo, bar)
% 
%     will create a structure b with fields 'foo' and 'bar' and
%     with their respective workspace values.
%
%     To bundle a workspace expression (that doesn't have a
%     variable name), you must pass in a fieldname for that
%     expression as the next argument.  For example:
%
%     b = bundle(log(x), 'log', 5, 'five')
%
%     will create a structure with field 'log' with a value of
%     log(x) (whatever 'x' was in the workspace) and a field 'five'
%     with value 5.
%
%     You can also mix and match variables and expressions, regardless
%     of the type, as much as you like.  For example:
%     
%     b = bundle(datetime(true), 'timestamp', x, y, @sin, 'sin')
%
%     will create a structure b with field 'timestamp' set to the
%     current date and time with seconds, fields 'x' and 'y' set to
%     their values in the workspace, and a field 'sin' with a
%     function handle to the Matlab sin function.
%
% Exceptions: *** VERY IMPORTANT ***
%
%     bundle will intelligently parse evaluations of structure
%     fields when working in interactive mode ONLY. So calling
%
%     b = bundle(s.field)
%
%     in interactive mode will result in structure b with field
%     'field' that has value of the workspace structure 's.field'.
%     
%     HOWEVER, WITHIN AN .M FILE, THE BEHAVIOR OF 'BUNDLE' WITH
%     STRUCTURE EVALUATIONS AS ARGUMENTS IS UNDEFINED.  From practical
%     experiment, sometimes the above expression will sometimes give
%     an error, and sometimes not give an error in your .m file
%     function. If you want to guarantee stability of your code, NEVER
%     pass in a structure field as an argument to bundle in an .m
%     file.  Instead, either pass in the entire structure or assign
%     the fields to variables first (if you only want a few of the
%     structure fields), like so:
%
%     b = bundle(s);  % results in field 's' of b with value s
%
%     field = s.field;
%     b = bundle(field); % results in field 'field' of b with value s.field
%
%     It is unknown why Matlab behaves inconsistently when in an
%     .m file at this time, or if it is consistent in an .m file
%     script but not an .m file function.
%

% ======================================================================
% Copyright (c) 2012 David Weiss
% 
% Permission is hereby granted, free of charge, to any person obtaining
% a copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to
% permit persons to whom the Software is furnished to do so, subject to
% the following conditions:
% 
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
% LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
% OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
% WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% ======================================================================



history = [];

field = [];
for n = 1:numel(varargin)

  % if no inputname given, check the next input to see if its a string
  if isempty(inputname(n)) & isempty(field)
    field = varargin{n};
  else % if there was an inputname or a field already set, add it
       % to history

    if ~isempty(field) % if there's a field set, use the current
                       % input as fieldname
      if isstr(varargin{n})
        history = setfield(history, varargin{n}, field);                  
        field = [];
      else
        error(['If an expression is given as an input, the next input ' ...
               'must be a string with the desired fieldname.']);
      end    
    else % otherwise use the current input's name as fieldname
      
      % check if this is a reference to a structure
      fieldname = inputname(n);
      dots = strfind(fieldname, '.');
      if ~isempty(dots)
        fieldname = fieldname((dots(end)+1):end);
      end
      
      history = setfield(history, fieldname, varargin{n});      
    end
    
  end    

end

if ~isempty(field)
  warning('The last input was not bundled due to no name being given.');
end


