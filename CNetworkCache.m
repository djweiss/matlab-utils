classdef CNetworkCache 
    
    properties (Hidden = true)
        data_root
        stream
        seed
    end
    
    methods
        function f = CNetworkCache(dir, seed)
            f.data_root = dir;
            if ~exist(dir, 'dir')
                mkdir(dir);
            end
            if nargin==1
                
                fid = fopen('/dev/urandom','r');
                f.seed = sum(floor([fread(fid, 5)'/255*5]).*10.^[1:5]);
                fclose(fid);
            end
            
            f.stream = RandStream('mt19937ar', 'Seed', f.seed);
        end
        
        function r = waitrandom(f, max_sec)
            r = rand(f.stream, 1)*max_sec;
            pause(r);
        end
        
        function cachepath = get(f, filepath)
            f.waitrandom(0.1);
            
            if ~exist(filepath, 'dir') && ~exist(filepath, 'file')
                error('path ''%s'' does not exist', filepath);
            end
            [path name ext] = fileparts(filepath);
            cachepath = fullfile(f.data_root, [name ext]);
            
            cachelock  = fullfile(f.data_root, [name '.cached']);
            cachingfile = fullfile(f.data_root, [name '.caching']);
            
            total_delay = 0;
            while exist(cachingfile, 'file') && total_delay < 120
                fprintf('waiting for cache...\n');
                total_delay = total_delay + f.waitrandom(5);
            end
            if exist(cachingfile, 'file')
                error('timeout in waiting for cache! removing lock...');
                delete(cachingfile);
                cachepath = f.get(filepath);
            end
            
            % check for already cached or updated version of file/dir
            already_cached = exist(cachelock, 'file');
            if already_cached && exist(cachepath, 'dir')
                subfiles = dir(path); subfiles2 = dir(f.data_root);
                file = subfiles(find(arrayfun(@(x)isequal(x.name, name), subfiles)));
                file2 = subfiles2(find(arrayfun(@(x)isequal(x.name, name), subfiles2)));
                if ~isequal(file.date, file2.date)
                    already_cached = false;
                    fprintf('cache is out of date: %s vs. %s\n', file.date, file2.date);
                end
            elseif already_cached && exist(cachepath, 'file')
                file = dir(filepath); file2 = dir(cachepath);
                if ~isequal(file.date, file2.date)
                    already_cached = false;
                    fprintf('cache is out of date: %s vs. %s\n', file.date, file2.date);
                end
            else
                already_cached = false;
            end
            
            if already_cached
                fprintf('loading from cache: %s\n', cachepath);
            else
                fprintf('creating new cache: %s...\n', cachepath);
                f.waitrandom(5);
                
                if exist(cachingfile, 'file')
                    fprintf('abort! someone else caching...\n');
                    cachepath = f.get(filepath);
                else
                    tic;
                    unix(sprintf('rm -rf %s', cachepath));
                    unix(sprintf('rm -f %s', cachelock));
                    unix(sprintf('touch %s', cachingfile));
                    unix(sprintf('cp -raf %s %s', filepath, cachepath));
%                     if exist(filepath,'dir')
%                         unix(sprintf('rsync -atE %s/ %s/', filepath, cachepath));
%                     else
%                         unix(sprintf('rsync -atE %s %s', filepath, cachepath));
%                     end
                    unix(sprintf('touch %s', cachelock));
                    delete(cachingfile);
                    toc;
                end
                
            end
                
        end
        
        function clear(f, filepath)
            [path name ext] = fileparts(filepath);
            cachepath = fullfile(f.data_root, [name ext]);
            unix(sprintf('rm -rf %s', cachepath));
        end

    end

end

