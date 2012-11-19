function [clean] = strclean(s)
% STRCLEAN

   clean = strrep(s, '_', ' ');
   clean = strrep(s, '"', ' ');

   