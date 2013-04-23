% MATLAB-UTILS Toolbox by David Weiss
% Version 2013a 23-04-2013
%
% Sub-toolboxes 
%   +bb              - Helpful functions for dealing with bounding boxes
%
% Plotting
%   aggregate_curve  - Utility for averaging multiple plots together in a rigorous fashion
%   blueredyellow    - High contrast colormap that prints to grayscale correctly
%   colormapRGB      - Generate a simple linearly interpolated colormap.
%   propval          - Create a structure combining property-value pairs with default values.
%   get_unique_style - Get a unique LineSpec from a set of style combinations.
%
% Utility Classes
%   CFileCache       - Manage caching and retrieval of various precomputations
%   CFileFinder      - Maps tab-completion of struct fields to a filesystem.
%   CFuncEditor      - Edit Matlab package files with tab completion.
%   CNetworkCache    - Cache arbitrary files/dirs from one path to a local scratch path.
%   CTimeleft        - Progress bar / ETA computation time utility.
%
% Utility Functions
%   bundle           - Bundles a bunch of workspace variables/expressions into a structure.
%   cols             - Shortcut to size(X,2)
%   count            - Shortcut to sum(x(:)~=0)
%   dispf            - Like calling disp(sprintf(X)), or fprintf('...\n')
%   doif             - Implementation of ternary (conditional) operator
%   exclude          - Strip elements from indices
%   fadd             - Add numeric value to a structure field (or create if nonexistent)
%   getpropval       - Parse in-line property-value pairs
%   loadvar          - Load the contents of a .MAT file directly into a returned variable
%   plotmany         - Easy to use plot many lines with unique styles.
%   rget             - Recursively concatenate fields from a structure array.
%   rows             - Shortcut to size(X,1)
%   savemkdir        - Verbosely save variables to file, creating path if necessary.
%   scatterim        - Create a scatter-plot image for high volume plots.
%   sec2timestr      - Convert a time measurement from seconds into a human readable string.
%   sfigure          - Create figure window (minus annoying focus-theft).
%   size2            - Return specific size dimensions of input
%   split            - Split string into cell array based on delimiter
%   strclean         - Clean underscores/quotes from a string
%   strjoin          - Joins several strings by a separator.
%   sublin           - Shortcut to X(i)
%   trymkdir         - Try to create a directory on a given path.
%   unixf            - A shortcut to unix(sprintf(...))
%   vec              - Shortcut to x(:)
%   whos2            - Improved 'whos' function
