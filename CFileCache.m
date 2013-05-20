classdef CFileCache < handle
% Manage caching and retrieval of various precomputations
%
% Usage:
%
%   (simple usage demo case)
% 
%   cache = CFileCache('/tmp/mywork');
%   cache.register('data1', @runDataFunction1);
%   cache.register('data2', @runDataFunction2);
%  
%   % will run computation this time
%   data1 = cache.get('file1', 'data1'); 
%   % will load from cache this time
%   data1 = cache.get('file1', 'data1'); 
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

    properties (Hidden = true)
        funcmap
        namefield = 'name';
        funclist = {};
    end
    
    properties 
        data_root
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
                unixf('mkdir -p %s', f.data_root); %%error('directory ''%s'' does not exist', f.data_root);
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

            hashcode = mod(sum(double(name).*[1:cols(name)])*11, 676);
            subdir = char(97 + [floor(hashcode/26) hashcode-26*floor(hashcode/26)]);

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
        