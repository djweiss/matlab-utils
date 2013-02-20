classdef CFileFinder

    properties (Hidden = true)
      dir 
      onlydir
      root 
      lookup      
   end
   
   methods (Hidden = true)
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
   
       function lookup = get_names(f)
           files = dir(f.dir); 
           lookup = struct;
           for i = 1:numel(files)
               try
                   if files(i).isdir
                       if isequal(files(i).name, '.')==1 || isequal(files(i).name, '..')==1
                           continue;
                       end
                       lookup.(files(i).name) = [files(i).name];
                   elseif ~f.onlydir
                       [~, name, ext] = fileparts(files(i).name);
                       lookup.(name) = [name ext];
                   end
               catch
               end
           end
       end
       function fs = fieldnames(f)
            fs = fieldnames(get_names(f));
       end
       
       function disp(f)
           fprintf('CFileFinder finding these files in ''%s'':\n', f.root);
           disp(strvcat(fieldnames(get_names(f))));
       end
       
       function cd(f)
           cd(f.root);
       end
             
       function B = subsref(f, S)
           if S.type == '.'
               lookup = get_names(f);
               B = fullfile(f.root, lookup.(S.subs));
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
