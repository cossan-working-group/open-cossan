function postprocessing
!rm accmax.dat

Xresp1 = Response('Sname', 'acc2_mass', ...
    'Sfieldformat', ['%f','%*s','%f','%f','%f','%*d','\n','%*s','%f','%f','%f','%*d'], ...
    'Clookoutfor',{'POINT ID =       99998'}, ...
    'Ncolnum',1, ...
    'Nrownum',1,...
    'Nrepeat',inf);

Xte=TableExtractor('Srelativepath','./', ...
    'Sfile','box_transient.pch', ...
    'Xresponse', Xresp1);

Tout = extract(Xte);
Vacc = sqrt(Tout.acc2_mass.Mdata(1,:).^2+Tout.acc2_mass.Mdata(2,:).^2+Tout.acc2_mass.Mdata(3,:).^2);
accmax = max(Vacc);

f1=fopen('accmax.dat','w');
fprintf(f1,'%s\n','MAX ACC')
fprintf(f1,'%e',accmax);
fclose(f1);
