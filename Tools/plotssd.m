[x_222, avg_x_222, y_222, avg_y_222]=avglmudata(data,'LMU_222',5,'b',1)
fpd('solarleistung','dauer',weather_data,0.08,'r',1,1)
fpd('solarleistung','dauer',weather_data,0.08,'r',0,3)
set(gca,'XLim',[735613,735626]);
set(gca,'XTick',[735613:735626]);
set(gca,'XTickLabel',datestr([735613:1:735626]));
% xstem = plotsolar('15-Jan-2014','24-Jan-2014');
% xdate = xdatecalc(xstem);
% stem(xdate,weather_data.solarleistung.dauer.org_val,'k','MarkerEdgeColor','k',...
%                 'MarkerFaceColor',[1 1 0],...
%                 'MarkerSize',10), datetick('x',0,'keepticks');
           							
l = legend('LMU kumulierte Sonnenscheindauer Auflösung 5 Min.','HWK Messwerte mittlere Sonnenscheindauer Auflösung 6h ohne Sonnenauf- und -untergangsadaption','HWK Interpolation mittlere Sonnenscheindauer Auflösung 5 Min. mit Sonnenauf- und -untergangsadaption','HWK Messwerte mittlere Globalstrahlung Auflösung 6h mit Sonnenauf- und -untergangsadaption')
set(l,'FontSize',14)
set(gcf,'position',get(0,'screensize'));
set(get(gca,'Title'),'String','Sonnenscheindauer 15.01.-26.01.2014')
set(get(gca,'Title'),'FontSize',14)
set(get(gca,'YLabel'),'String','h')
set(get(gca,'YLabel'),'FontSize',14)
set(get(gca,'XLabel'),'String','Datum')
set(get(gca,'XLabel'),'FontSize',14)
datum = {'15.01.2014','16.01.2014','17.01.2014','18.01.2014','19.01.2014','20.01.2014','21.01.2014','22.01.2014','23.01.2014','24.01.2014','25.01.2014'};
text1 = 'Abweichung (HKW-Wert - LMU-Wert) in Std.';
text2 = arrayfun(@(col) sprintf(' %s = % 2.2f h', datum{col}, abserr(col)), 1:size(abserr,2),'Unif', false)';
text = {text1 text2{:}};
annotation('textbox',...
[0.5 0.7 0.1 0.1],...
'String',{text{:}},...
'FontSize',14,...
'FontName','Arial',...
'LineStyle','-',...
'EdgeColor',[0 0 0],...
'LineWidth',2,...
'BackgroundColor',[0.9  0.9 0.9],...
'Color',[0 0 0]);
xticklabel_rotate([],45,[],'Fontsize',14)
set(gca,'FontSize',14);