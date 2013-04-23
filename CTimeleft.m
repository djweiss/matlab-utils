classdef CTimeleft < handle
% Progress bar / ETA computation time utility.
%
% Usage: (simple demo case)
%
%  t = CTimeleft(n);
%  for i = 1:n
%     t.timeleft(i);  % display progress bar 
%     foo(i);
%  end
%
% Advanced usage:
%
%  t = CTimeleft(n, 'nobar') % force no progress bar, just text
%  t = CTimeleft(n, 'bar') % force progress bar
%  t = CTimeleft(n, k) % update interval k in iters (bar) or seconds (nobar)

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

    properties 
        t0
        charsToDelete = [];
        done
        total
        prefix = '';
        interval = 1;
        last_update        
        bar
    end
    
    methods
        function t = CTimeleft(varargin) %
            if ischar(varargin{1})
                t.prefix = [varargin{1} ' '];
                varargin = varargin(2:end);
            end
            
            if isequal(varargin{end}, 'bar')
                t.bar = true;
                varargin = varargin(1:end-1);
            elseif isequal(varargin{end}, 'nobar')
                t.bar = false;
                varargin = varargin(1:end-1);
            else
                t.bar = usejava('desktop');
            end
                
            t.done = 0;
            t.total = varargin{1};
            
            if numel(varargin) > 1 
                t.interval = varargin{2};
            elseif t.bar
                t.interval = ceil(t.total*t.interval/100);
            else
                t.interval = 2;
            end
        end
        
        function [remaining status_string] = timeleft(t)
            if t.done == 0
                t.t0 = tic;
                t.last_update = t.t0;
            end
                              
            t.done = t.done + 1;
            
            elapsed = toc(t.t0);
            elapsed_since_update = toc(t.last_update);
            
            if t.done == 1 || t.done == t.total || nargout > 0 || ...
                    (t.bar && mod(t.done,t.interval)==0) || ...
                    (~t.bar && elapsed_since_update > t.interval)

                % compute statistics
                t.last_update = tic;
                avgtime = elapsed./(t.done-1);
                remaining = (t.total-t.done+1)*avgtime;
                
                if avgtime < 1
                    ratestr = sprintf('- %.2f iter/s', 1./avgtime);
                else
                    ratestr = sprintf('- %.2f s/iter', avgtime);
                end
                
                if t.done == 1
                    remaining = -1;
                    ratestr = [];
                end
                
                timesofarstr  = sec2timestr(elapsed);
                timeleftstr = sec2timestr(remaining);
                
                %my beloved progress bar
                pbarw = 30;
                pbar = repmat('.',1,pbarw);
                pbarind = 1 + round(t.done/t.total*(pbarw));
                pbar(1:pbarind-1) = '=';
                if pbarind < pbarw
                    pbar(pbarind) = '>';
                else
                        0;
                    
                end
                
                pbar = ['[',pbar,'] '];
                
                % whether or not to put a progress bar
                if ~t.bar
                    pbar = '';
                end
                
                status_string = sprintf('%s%s%03d/%03d - %03d%%%% - %s|%s %s ',t.prefix,pbar,t.done,t.total,...
                    floor(t.done/t.total*100),timesofarstr,timeleftstr, ratestr);
                
                if t.bar
                    delstr = [];
                    if ~isempty(t.charsToDelete)
                        delstr = repmat('\b',1,t.charsToDelete-1);
                    end
                    
                    if nargout == 0
                        fprintf([delstr status_string]);
                    end
                else
                    if nargout == 0
                        fprintf([status_string '\n']);
                    end
                end
                    
                t.charsToDelete = numel(status_string);
                drawnow update;
            end
            
            if t.done == t.total && nargout == 0 
                fprintf('\n');
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

