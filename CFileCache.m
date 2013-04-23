classdef CFileCache < handle
    
    properties (Hidden = true)
        data_root
        funcmap
        namefield = 'name';
        funclist = {};
    end
    
    methods 
        function f = CFileCache(dir, namefield)
            f.data_root = dir;
            f.funcmap = java.util.HashMap();
            f.funclist = {};
            if nargin>1
                f.namefield = namefield;
            end
            
            if ~exist(f.data_root, 'dir')
                error('directory ''%s'' does not exist', f.data_root);
            end
        end
        
        function register(f, name, func)
            f.funcmap.put(f.getName(name), numel(f.funclist)+1);
            f.funclist{end+1} = func;
        end        
        
        function [name] = getName(f, name)
            if isstruct(name)
                name = name.(f.namefield);
            end
        end
        
        function [list] = registered(f) 
            it = f.funcmap.keySet().iterator();
            list = {};
            while it.hasNext() == 1
                list{end+1} = char(it.next());
            end
        end
        
        function [filename subdir] = getFilename(f, name, target)
            name = f.getName(name);
            [~,cname,~] = fileparts(name); % strip original filename
            %%
%             tic
            hashcode = mod(sum(double(name).*[1:cols(name)])*11, 676);
            subdir = char(97 + [floor(hashcode/26) hashcode-26*floor(hashcode/26)]);
%             toc
%             tic
%             uuid = char(java.util.UUID.nameUUIDFromBytes(double(name)));
%             subdir = uuid(1:2); %end-2:end); %uuid.toString();
%             %subdir = subdir(1:2);
%             toc
            %%
            filename = fullfile(f.data_root, [subdir '/' cname '-' target '.mat']);
        end     
        
        function set(f, name, target, data)
            filename = f.getFilename(name, target);
            fprintf('caching to: ''%s''\n', filename);

            savedir = fileparts(filename);
            if ~exist(savedir, 'dir')
                mkdir(savedir);
            end
            if isstruct(data) && numel(data) == 1
                save(filename, '-struct', 'data');
            else
                save(filename, 'data');
            end
        end
            
        function data = get(f, name, target, varargin)
            filename = f.getFilename(name, target);
            
            if exist(filename,'file')
                %fprintf('cache exists, loading from: ''%s''\n', filename);
                data = loadvar(filename);
            else
                idx = f.funcmap.get(target);
                if isempty(idx)
                    error('no function registered for ''%s''', target);
                end
                func = f.funclist{idx};
                data = func(f, name, varargin{:});     
                f.set(name, target, data);
                data = loadvar(filename);
            end
        end
        
        function clear(f, name, target)
            filename =f.getFilename(name, target);
            fprintf('clearing ''%s''\n', filename);
            if exist(filename,'file')
                delete(filename);
            end
        end
        
                
            
    end
    methods (Hidden = true)
        
    end
    
end
        