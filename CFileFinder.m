classdef CFileFinder

    properties (Hidden = true)
      dir 
      onlydir
      root 
   end
   
   methods (Hidden = true)
       function names = get_names(f) 
           files = dir(f.dir);
           names = {};
           for i = 1:numel(files)
               if isempty(strfind(files(i).name, '.'))
                   if ~f.onlydir | (f.onlydir & files(i).isdir)
                        names{end+1} = [files(i).name];
                   end
              end
           end
       end
       function fs = fieldnames(f)
            fs = get_names(f);
       end
       
       function disp(f)
           fprintf('CFileFinder finding these files in ''%s'':\n', f.root);
           disp(strvcat(get_names(f)));
       end
       
       function cd(f)
           cd(f.root);
       end
   end
   
   methods 
       function f = CFileFinder(dir, onlydir)
           if nargin < 1
               dir = pwd;
           end
           f.dir = dir;
           if nargin < 2
               onlydir = true;
           end
           f.onlydir = onlydir;
           if exist(dir, 'dir')
               f.root = dir;
           else
               f.root = fileparts(dir);
           end
       end                
       
       function B = subsref(f, S)
           if S.type == '.'
               B = fullfile(f.root, S.subs);
           end
       end             
   end
    
    
end

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
