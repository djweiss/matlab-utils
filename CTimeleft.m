classdef CTimeleft < handle

    properties 
        t0
        charsToDelete = [];
        done
        total
        interval = 1;
    end
    
    methods
        function t = CTimeleft(total, interval)
            
            t.done = 0;
            t.total = total;
            if nargin>1
                t.interval = interval;
            else
                t.interval = ceil(total*t.interval/100);
            end
        end
        
        function [remaining status_string] = timeleft(t)
            if t.done == 0
                t.t0 = tic;
            end
                              
            t.done = t.done + 1;
            
            elapsed = toc(t.t0);
            
            if t.done == 1 || mod(t.done,t.interval)==0 || t.done == t.total || nargout > 0

                % compute statistics
                avgtime = elapsed./t.done;
                remaining = (t.total-t.done)*avgtime;
                
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
                pbar = ['[',pbar,']'];
                
                
                status_string = sprintf('%s %03d/%03d - %03d%%%% - %s|%s %s ',pbar,t.done,t.total,...
                    floor(t.done/t.total*100),timesofarstr,timeleftstr, ratestr);
                
                delstr = [];
                if ~isempty(t.charsToDelete)
                    delstr = repmat('\b',1,t.charsToDelete-1);
                end
           
                if nargout == 0
                    fprintf([delstr status_string]);
                end
                
                t.charsToDelete = numel(status_string);
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

