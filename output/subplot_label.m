function [] = subplot_label(h , x, y, l)
%h=axes handle
%x=normalized distance from left
%y=normalized distance from bottom
%l=text
text(x,y,l,'Units', 'Normalized', 'VerticalAlignment', 'Top','Parent', h)