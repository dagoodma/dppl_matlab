function disableLegendEntry(hObj)
% DISABLELEGENDENTRY Turns off legend entry icon for the object.

hAnnotation = get(hObj,'Annotation');
hLegend = get(hAnnotation,'LegendInformation');
set(hLegend,'IconDisplayStyle','off');

end % function