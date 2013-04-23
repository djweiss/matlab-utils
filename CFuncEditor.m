classdef CFuncEditor

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