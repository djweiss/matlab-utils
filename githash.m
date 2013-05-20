function hash = githash(target)

filename = tempname;
unix(sprintf('git log --format="%%H" -1 %s > %s', target, filename));
fid = fopen(filename,'r');
hash = fgetl(fid);
fclose(fid);
delete(filename);


