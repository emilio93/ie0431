%% Identification
%% The class identifies itself and the LaTeX version needed
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ucrEieTarea}[2018/01/2017 Tareas de Escuela de Ing Electrica]


%% Preliminary declarations
\LoadClass[spanish]{article}

\RequirePackage{url}

\RequirePackage{cite}
\RequirePackage{tikz}

\RequirePackage{color}
\RequirePackage{float}

\RequirePackage{empheq}
\RequirePackage{xcolor}

\RequirePackage{amsmath}
\RequirePackage{apacite}
\RequirePackage{gensymb}
\RequirePackage{siunitx}

\RequirePackage{amsfonts}
\RequirePackage{booktabs}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage{hyperref}
\RequirePackage{mdframed}
\RequirePackage{multirow}
\RequirePackage{pdfpages}
\RequirePackage{pgfplots}
\RequirePackage{setspace}
\RequirePackage{textcomp}


\RequirePackage{mathtools}
\RequirePackage{tikzscale}

\RequirePackage{circuitikz}
\RequirePackage{subcaption}

\RequirePackage[T1]{fontenc}
\RequirePackage[spanish]{babel}
\RequirePackage[utf8]{inputenc}

%%This parts handles the options passed to the class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax


\pgfplotsset{compat=1.15}
\usetikzlibrary{babel}
\usetikzlibrary{shapes, arrows}
\tikzset{>=latex} 


\geometry
  {
    a4paper,
    left=25.4mm,
    right=25.4mm,
    top=25.4mm,
    bottom=25.4mm,
    heightrounded,
  }


\newcounter{ejercicioc}[section]
\newenvironment{ejercicio}
{
    \par
    \refstepcounter{ejercicioc}\par\medskip
    \noindent\textbf{\large Ejercicio~\theejercicioc} \rmfamily
    \\\par
}
{
}

\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\normalfont\Large\bfseries}
                                  }
                                
\newcommand{\portadaminima}[7]{
  \noindent{\bfseries #1}\par
  \noindent{\bfseries #2}\par
  \noindent{\bfseries #3}\par
  \noindent{\bfseries #4}\par
  \noindent{\bfseries #5}\par
  \noindent{\bfseries #6}
  \begin{center}
    {\bfseries\large #7}
  \end{center}
}                             