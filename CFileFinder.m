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