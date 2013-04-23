classdef CFuncEditor
% Edit Matlab package files with tab completion.
%
% Usage: 
%
%  % put in your startup.m:
%  pedit = CFuncEditor(src_root_dirs);
% 
%  % then you can use  with tab completion to existing functions:
%  pedit.mypackage.func1 
%  % ^^ opens editor to [src_root_dirs '/+mypackage/func1.m']

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

   properties (Hidden = true)
      root 
   end
   
   methods (Hidden = true)
       function names = get_names(f) 
           files = dir(f.root);
           names = {};
           for i = 1:numel(files)
               if ~isempty(strfind(files(i).name, '+'))
                   names{end+1} = [files(i).name(2:end)];
               end
           end
       end
       function fs = fieldnames(f)
            fs = get_names(f);
       end
       
       function disp(f)
           fprintf('Searching packages in ''%s'': %s\n', f.root, strjoin(',',get_names(f)));
       end
       
       function cd(f)
           cd(f.root);
       end
   end
   
   methods 
       function f = CFuncEditor(dir)
           if exist(dir, 'dir')
               f.root = dir;
           else
               f.root = fileparts(dir);
           end
       end                
       
       function [varargout] = subsref(f, S)
           if numel(S) == 1
               if S.type == '.'
                   packdir = fullfile(f.root, ['+' S.subs]);
                   if exist(packdir, 'dir')
                       varargout{1} = CFileFinder(fullfile(packdir, '*.m'), 0);
                   end
               end
           else
               %B = CFileFinder(fullfile(f.root, ['+' S(1).subs]), 0);
               %B = B.(S(2).subs);
               B = fullfile(f.root, ['+' S(1).subs], [S(2).subs '.m']);
               if nargout == 0
                   edit(B);
               else
                   varargout{1} = B;
               end
           end
           
       end             
   end
   
end