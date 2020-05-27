@x
\let\lheader\rheader
@y
% Set duplex printing:
% hook into \shipout to add \special to first page. If we just use \special here, it
% will be omitted because "real" first page is discarded in cwebmaX.tex
\let\oldshipout\shipout
\def\shipout{\global\let\shipout\oldshipout\afterassignment\myboat\setbox255=}
\def\myboat{\aftergroup\myship}
\def\myship{\setbox255=\vbox{\special{header=config.duplong}\unvbox255}\shipout\box255}

\def\contentspagenumber{-1} % the value is calculated as "1-<quantity of pages in TOC,
                            % rounded up to the nearest even number>"
% NOTE: if the number of pages in contents will be more than one, set \contentspagenumber
% in .w-file analogous to above rule, but without rounding
% (must be before \let\lheader\rheader, so that it will be overriden in change file, otherwise
% it must be included to @@x-@@y part of change-file);
% "0" is the default value, so we do not set it explicitly if there is only one page in contents
\hoffset=12.29mm % purely empirical - change if needed
\pageshift=210mm \advance\pageshift by-6.5in \advance\pageshift by-\hoffset
@z
