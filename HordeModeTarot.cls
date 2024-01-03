\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{HordeModeTarot}[2024/02/01 Poorhammer Horde Mode Tarot deck v0.83]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ProcessOptions\relax

\LoadClass[8pt]{extarticle} % base class and defaults

%packages and global configrations

\usepackage{etoolbox} 
\usepackage{array}
\usepackage{enumitem}
\usepackage{hyperref} % required by kramdown
\usepackage{listings} % required by kramdown

\setlist{nolistsep}

\setlength{\parindent}{0pt}
\setlength\itemsep{1pt}

\pagestyle{empty} % no header or footers. We take care of them ourselves

\raggedright % no hyphenation

\makeatletter
\let\@minipagerestore=\raggedright % text in minipages left aligned
\makeatother


% margins
\usepackage[
	top=3mm,
	bottom=4mm,
	left=5mm,
	right=5mm,
	%showframe
]{geometry}


%font settings
\usepackage[T1]{fontenc} % font encoding for international characters
\usepackage[utf8]{inputenc} % inputting international characters

\usepackage[
	semibold, % semibold instead of bold
	oldstyle, % oldstyle figures, i.e. numbers that descend below the baseline
]{ebgaramond} % font choice

\usepackage{microtype} % better typography

\newcommand{\printCardTrimmingLines}{
	\usepackage[
		width=80mm, height=130mm, % 5mm margins to each side
		cam, % options: cross, cam, axes, frame
		noinfo, % Don't display default page information at the top added by this package
		center,
	]{crop}
}

\newcommand{\setTarotCardGeometry}{
	\geometry{
		paperwidth=70mm, paperheight=120mm, %Tarot
	}
}

% Setting trimming lines for rules leaflet trimming
\newcommand{\printRulesTrimmingLines}{
	\usepackage[
		width=290mm, height=130mm, % 5mm margins to each side
		cam, % options: cross, cam, axes, frame
		noinfo, % Don't display default page information at the top added by this package
		center,
	]{crop}
}

\newcommand{\setTarotRulesGeometry}{
	\geometry{
		paperwidth=280mm, paperheight=120mm, %Tarot
	}
}

% output card type
\newcommand{\outputCardType}[1]{
	\strut
	\hfill
	\textbf{\textsc{#1}}
}

% output one line card title
\newcommand{\outputCardTitleOneLine}[1]{
	\hrule
	\vspace{16pt}
	\fontsize{25}{22}
	\selectfont
	\MakeUppercase{#1}\\
	%\par
	\vspace{16pt}
	\hrule
}


% output two line card title
\newcommand{\outputCardTitleTwoLine}[2]{
	\hrule
	\vspace{10pt}
	\fontsize{17}{17}
	\selectfont
	\MakeUppercase{#1}\\
	\fontsize{20}{18}
	\selectfont
	\MakeUppercase{#2}\\
	%\par
	\vspace{10pt}
	\hrule
}

% output the effect of the card
\newcommand{\outputCardEffectBig}[1]{
	\vspace{14pt}
	\setlength{\parskip}{9pt}
	\fontsize{14pt}{14pt}
	\selectfont
	{#1}
	\setlength{\parskip}{0pt}
	\vfill
}

\newcommand{\outputCardEffectSmall}[1]{
	\vspace{10pt}
	\setlength{\parskip}{8pt}
	\fontsize{11pt}{11pt}
	\selectfont
	{#1}
	\setlength{\parskip}{0pt}
	\vfill
}

% output flavor text
\newcommand{\outputFlavorText}[1]{
	\vspace{3pt}
	\begin{flushright}
	{\fontsize{8pt}{8pt}\selectfont\textit{#1}}
	\end{flushright}
}

\newcommand{\outputEffectEnd}{
	\hrule % construct a line to separate the headers from the card content
	\vspace{10pt}
}

%output bottom boilerplate
\newcommand{\outputVersionBoilerplate}[1]{
	\strut
	\hrule
	\vspace{5pt}
	\fontsize{8pt}{8pt}
	\selectfont
	\textbf{\textsc{The Poorhammer Podcast}}\\
	\textbf{\textsc{Horde Mode {#1}}}% Game version 
}

\newcommand{\outputSecondaryObjectiveResults}[2]{
	\minipage[t] {0.45\textwidth}
	\vspace{0pt} %hack because latex...
	\fontsize{12pt}{14pt}\selectfont
	\begin{center}
	\textbf{Success}
	\end{center}
	\endminipage
	\hfill
	\minipage[t] {0.45\textwidth}
	\vspace{0pt} %hack because latex...
	\fontsize{12pt}{14pt}\selectfont
	\begin{center}
	\textbf{Failure}
	\end{center}
	\endminipage

	\vspace{3pt}
	\minipage[t] {0.45\textwidth}
	\vspace{0pt} %hack because latex...
	\fontsize{10pt}{11pt}\selectfont
	{#1} 
	\endminipage
	\hfill
	\minipage[t] {0.45\textwidth}
	\vspace{0pt} %hack because latex...
	\fontsize{10pt}{11pt}\selectfont
	{#2} 
	\endminipage

}

\newcommand{\outputSecretObjectiveBoilerplate}{
	\vspace{-5pt}
	\fontsize{8pt}{8pt}\selectfont
	\begin{itemize}[leftmargin=3mm]
		\item Complete your \textbf{Secret Objective} to win the game at the end of \textbf{Battle Round 5}
		\item You can't show your object to other players
		\item You can tell other players what your object is (and lie about it)
		\item You win the game individually by completing your objective, regardless if you survive
	\end{itemize}
	\vspace{-5pt}
}

\newcommand{\outputReinforcementPurchaseTitle}[2]{
	\vspace{6pt}
	\fontsize{12pt}{8pt}\selectfont
	\textbf{#1}
	\hfill
	{#2} RP
	\fontsize{10pt}{10pt}\selectfont
	\par
}

\newcommand{\outputUsingSpawnTableBoilerplate}{
	\section*{Using the Horde Spawn Table}
	\begin{itemize}[leftmargin=*]
		\item Unmodified 2 is always "No Spawn"
		\item Rounds 3 and 4 +1 to Horde Spawn rolls.
		\item Round 5 +2 to Horde Spawn rolls.
		\item You may instead choose to spawn 2 units from the tier below the rolled tier instead.  This can help find valid units to spawn and help give a horde feel in late game.
		\item If there are units missing in this table you wish to play with, the general layout is: 3-4 = 75~ points or less, 5-6 80-170 points, 7-9 175-295 points, 10+ 300+ points.
		\item The term "(full)" is any valid unit on the spawning table for that transport to carry.  Decide what to fill it with at your discretion.  10 Terminators with a Leader in a Land Raider is the same entry as 5 Intercessors without a leader.
	\end{itemize}
}