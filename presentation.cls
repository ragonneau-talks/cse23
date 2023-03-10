%% presentation.tex
%% Copyright 2023 Tom M. Ragonneau
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{presentation}[2023/01/26 Beamer document class of Tom M. Ragonneau]

\RequirePackage{ifthen}
\newboolean{nogiturl}
\setboolean{nogiturl}{false}
\DeclareOption{nogiturl}{\setboolean{nogiturl}{true}}
\newboolean{nolicense}
\setboolean{nolicense}{false}
\DeclareOption{nolicense}{\setboolean{nolicense}{true}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass[10pt,xcolor=dvipsnames]{beamer}

\RequirePackage[T1]{fontenc}
\RequirePackage[english]{babel}
\RequirePackage{csquotes}
\RequirePackage{ifdraft}

% Manage frame numbering in appendices
\RequirePackage{appendixnumberbeamer}

% Extra tools for LaTeX
\RequirePackage{etoolbox}

% Load theme
\usetheme{metropolis}
\metroset{
    titleformat=smallcaps,
    numbering=fraction,
    progressbar=frametitle,
    block=fill,
}

% Fonts
\setsansfont{FiraSans}[
    Path=fonts/fira-sans/,
    Extension=.otf,
    UprightFont=*-Light,
    BoldFont=*-Regular,
    ItalicFont=*-LightItalic,
    BoldItalicFont=*-Italic,
]
\setmonofont{FiraMono}[
    Path=fonts/fira-mono/,
    Extension=.otf,
    UprightFont=*-Regular,
    BoldFont=*-Bold,
]

% Reduce margins
\setbeamersize{
    text margin left=0.75\beamer@leftmargin,
    text margin right=0.75\beamer@rightmargin,
}

% Patch `Overfull \vbox (... too high)' in title page
\RequirePackage{tikz}
\usetikzlibrary{positioning}
\def\titlepage{\usebeamertemplate{title page}}
\setbeamertemplate{title graphic}{
    \begin{tikzpicture}[overlay,remember picture]
        \node[below left=2em and \beamer@rightmargin of current page.north east] {\inserttitlegraphic};
    \end{tikzpicture}
}

% Patch `Token not allowed in a PDF string (Unicode)' in appendix
\pdfstringdefDisableCommands{\def\translate#1{#1}}

% Change theme colors
\definecolor{VeniceBlue}{HTML}{2F5675}
\definecolor{Caramel}{HTML}{C68E17}
\definecolor{FernGreen}{HTML}{4F7942}
\setbeamercolor{normal text}{fg=VeniceBlue!70!black,bg=black!2}
\setbeamercolor{alerted text}{fg=Caramel}
\setbeamercolor{example text}{fg=FernGreen!95!black}

% Change theme templates
\setbeamertemplate{section in toc}[sections numbered]

% Font for mathematics
\usefonttheme{professionalfonts}

% Font for standout frames
\setbeamerfont{standout}{size=\normalsize}

% Customize blocks, alert blocks, and example blocks
\renewcommand{\metropolis@block}[1]{
    \par\vskip\medskipamount%
    \setlength{\parskip}{0pt}
    \ifdefempty{\insertblocktitle}{}{
        \ifbeamercolorempty[bg]{block title#1}{%
            \begin{beamercolorbox}[rightskip=0pt plus 4em]{block title#1}}{%
        \ifbeamercolorempty[bg]{block title}{%
            \begin{beamercolorbox}[rightskip=0pt plus 4em]{block title#1}%
        }{%
            \begin{beamercolorbox}[
                sep=\dimexpr\metropolis@blocksep-\metropolis@blockadjust\relax,
                leftskip=\metropolis@blockadjust,
                rightskip=\dimexpr\metropolis@blockadjust plus 4em\relax,
            ]{block title#1}%
        }}%
            \usebeamerfont*{block title#1}%
            \metropolis@strut%
            \insertblocktitle%
            \metropolis@strut%
        \end{beamercolorbox}%
        \nointerlineskip%
    }%
    \ifbeamercolorempty[bg]{block body#1}{%
        \begin{beamercolorbox}[vmode]{block body#1}}{
    \ifbeamercolorempty[bg]{block body}{%
        \begin{beamercolorbox}[vmode]{block body#1}%
    }{%
        \begin{beamercolorbox}[sep=\metropolis@blocksep, vmode]{block body#1}%
        \vspace{-\metropolis@parskip}
    }}%
        \usebeamerfont{block body#1}%
        \setlength{\parskip}{\metropolis@parskip}%
}

% Bibliography
\RequirePackage[
    style=ext-authoryear-comp,
    articlein=false,
    sorting=nyt,
    sortcites=false,
    maxcitenames=3,
]{biblatex}
\DefineBibliographyStrings{english}{
    bathesis={B\adddot A\adddotspace thesis},
    mathesis={M\adddot A\adddotspace thesis},
    phdthesis={Ph\adddot D\adddotspace thesis},
}
\setbeamertemplate{bibliography item}[triangle]
\DeclareNameAlias{author}{family-given}
\setlength\bibitemsep{\itemsep}

% Path relative to the main .tex file
\graphicspath{{./images/}}

% Support for license
\RequirePackage[
    type={CC},
    modifier={by-sa},
    version={4.0},
    hyperxmp=false,
]{doclicense}
\apptocmd{\doclicenseLongName}{license}{}{}

% Support for mathematics
\RequirePackage{maths}

% QR codes
\ifdraft{\PassOptionsToPackage{draft}{qrcode}}{}
\usepackage[nolinks]{qrcode}
\qrset{level=Q,version=3}  % Up to 47 alphanumeric characters

% Make QR codes clickable (the document is compiled with XeLaTeX)
\setlength{\XeTeXLinkMargin}{1pt}
\let\old@qrcode\qrcode\relax
\def\qrcode#1{\href{#1}{\XeTeXLinkBox{\old@qrcode{#1}}}}

% The following sets
%  - \giturl to the complete url of the git repository
%  - \giturlshort to the short url of the git repository
% It assumes that
%  - the current project is a (well-formed) git repository, and
%  - the command `git' is installed and accessible.
\RequirePackage{trimspaces}
\newread\giturlstream
\openin\giturlstream=|"./build_tools/giturl.sh"
\read\giturlstream to \giturl
\closein\giturlstream
\trim@spaces@in\giturl
\def\setgiturlshort#1://#2/\relax{\def\giturlshort{#2}}
\expandafter\setgiturlshort\giturl\relax

% Add a license frame at the end of the presentation
\ifthenelse{\boolean{nolicense}}{}{
    \AtEndDocument{
        \begin{frame}[standout]

            This work is licensed under a \doclicenseLongNameRef.
            \begin{center}
                \upshape\doclicenseImage[imagewidth=0.3\textwidth]
            \end{center}

            \bigskip

            \ifthenelse{\boolean{nogiturl}}{}{
                The source code of this presentation is available at
                \begin{center}
                    \normalfont\href{\giturl}{\texttt{\giturlshort}}.
                \end{center}
            }

            It is based on the metropolis Beamer theme, available at
            \begin{center}
                \normalfont\href{https://github.com/matze/mtheme/}{\texttt{github.com/matze/mtheme}}.
            \end{center}
        \end{frame}
    }
}
