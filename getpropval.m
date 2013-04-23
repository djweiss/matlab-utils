function [val x] = getpropval(x, property, default)
% Parse in-line property-value pairs
%
% Usage:
%
% [VALUE VARARGIN] = GETPROPVAL(VARARGIN, PROPERTY, DEFAULT)
%
% GETPROPVAL is for obtaining property-value pairs from a VARARGIN
% cell array without requiring the strict PROPVAL format. This
% looks for the first instance of PROPERTY, and, if found, takes
% the next argument in VARARGIN as VALUE, strips them both, and
% then returns the remaining VARARGIN. If PROPERTY is not found,
% then VALUE is equal to DEFAULT.

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


if nargin==2
  default = [];
end

val = default;

if ~iscell(x)
  x = {x};
end

for i = 1:numel(x)
  
  if ischar(x{i})
    if strcmp(x{i}, property)
      val = x{i+1};
      
      x = x([1:(i-1) (i+2):end]);
      
      return;
    end
  end
  
end

