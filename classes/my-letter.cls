% ---
% description: A custom letter class.
% author: [N.N.]()
% ---

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{my-letter}[
    2021-06-01 v0.0-dev A custom letter class.%
]

% ---

% kvoptions for keyval options
\RequirePackage{kvoptions}

\SetupKeyvalOptions{%
    family={my},%
    prefix={my@},%
}

\DeclareStringOption[standard]{alignment}

\DeclareStringOption[vlack]{mainaccentcolor}

\DeclareStringOption[gray]{otheraccentcolor}

\DeclareStringOption[gray]{linkcolor}

\DeclareStringOption[white]{layercolor}

\DeclareStringOption[english]{mainlanguage}

\DeclareStringOption[225pt]{refvpos}

\DeclareStringOption[92pt]{toaddrheight}

% Draws some auxiliary lines
\DeclareBoolOption[false]{visualize}

\DeclareBoolOption[false]{verbosedate}

\DeclareBoolOption[false]{verboseplace}

\DeclareBoolOption[false]{personallogo}

\DeclareBoolOption[false]{counterresetbyletter}

\ProcessKeyvalOptions*

\LoadClass[%
    fontsize={11pt},%
    parskip={half},%
]{scrartcl}

% scrletter is KOMA's letter package (not class)
\RequirePackage{scrletter}

% Principally, one could also load the class ~scrlttr2~
% but then no toc functionality would be available

% ---

% Passing the option ~mainlanguage~ to ~babel~
\PassOptionsToPackage{%
    main={\my@mainlanguage},%
    ngerman,%
    english,%
}{babel}

% babel for multiple language support
\RequirePackage{babel}

% According to Mr Kohm, the babel default value
% for the ngerman ~enclname~ is wrong.
\renewcaptionname{ngerman}{\enclname}{Anlage}

% ---

% xpatch since there is always something to patch
\RequirePackage{xpatch}

% ---

% \RequirePackage[T1]{fontenc}
% One should use a monospaced sans-serif font for letters
\RequirePackage[sfdefault]{biolinum}
% Option 'sfdefault' only if the base font
% of the document is to be sans serif

% % The author's favorite serif font
% \RequirePackage{fouriernc}

\RequirePackage[%
    protrusion={false},%
    expansion={true},%
    final,%
]{microtype}

% ---

% TODO: Remove this dependency
% my-xcolor for xcolor and a few named colors
\RequirePackage{my-xcolor}

% Sets the colors
\definecolor{mainaccentcolor}{named}{\my@mainaccentcolor}
\definecolor{layercolor}{named}{\my@layercolor}
\definecolor{otheraccentcolor}{named}{\my@otheraccentcolor}
\definecolor{linkcolor}{named}{\my@linkcolor}

% ---

% TODO: Remove this dependency
% my-enumitem for creating custom lists
\RequirePackage{my-enumitem}

% ---

% Some manipulation tools for komavars.
% Introduces also some new of them and
% gives them a default value.
\RequirePackage{_ml-komavars.cfg}

% kantlipsum for testing
\RequirePackage{kantlipsum}

% % fixme with some basic settings;
% % must be loaded before ~imakeidx~
% % due to a ~\index~ clinch
% \RequirePackage{my-fixme}

% geometry for defining a custom page layout
% (possibly incompatible with DIN 5008)
\RequirePackage{geometry}

% pdfpages for including pdf documents
\RequirePackage{pdfpages}

% phonenumbers for ... phonenumbers
\RequirePackage{phonenumbers}
\setphonenumbers{%
    foreign,%
    foreign-area-code-sep={space},%
}

\def\telref#1{\href{tel:#1}{\phonenumber{#1}}}

% % Can create invoice tables
% \RequirePackage{my-invoice-table}

% % Always required in some sense
% \RequirePackage{my-macros-text}

% ---

% hyperref
\RequirePackage[%
    linktoc={all},%
    colorlinks={true},%
    linkcolor={linkcolor},%
    citecolor={linkcolor},%
    urlcolor={linkcolor},%
    anchorcolor={linkcolor},%
    pdfstartview={Fit},%
    pdftoolbar={false},% Acrobat Reader toolbar
    pdfmenubar={true},% Acrobat Reader menubar
    pdfpagemode={UseOutlines},%
    pdfcreator={pdfLaTeX},%
    pdfpagelayout={OneColumn},%
    pdfpagelabels={true},%
    % pageanchor={false},%
    bookmarksnumbered={false},% numbering for bookmarks
    bookmarksopen={true},%
]{hyperref}

% A setter for pdfmetadata, also compatible
% with atomic komavars. Found at:
% [[https://tex.stackexchange.com/questions/458679][Fill pdfinfo metadata with \usekomavar{} not working]]
\newcommand\setpdfinfo[2]{%
    \hypersetup{pdfinfo={#1={#2}}}
}

% Sets pdf metadata
\AtBeginDocument{
    \usekomavar[\setpdfinfo{Title}]{subject}
    \usekomavar[\setpdfinfo{Author}]{fromname}
    \usekomavar[\setpdfinfo{Subject}]{description}
    \usekomavar[\setpdfinfo{Keywords}]{keywords}
    % \setpdfinfo{CreationDate}{D:20201114140000} % not yet implemented
    % \setpdfinfo{ModDate}{D:20171114140000} % not yet implemented
}

% Makes all page anchors to be displayed in full page mode,
% i.e. the zoom level is changed to make the whole page fit on the screen.
% Originally found at:
% [[https://tex.stackexchange.com/questions/19412][Linking a text to a page (by page number)]]
\let\old@Hy@EveryPageAnchor\Hy@EveryPageAnchor
\def\Hy@EveryPageAnchor{%
    \begingroup
    \hypersetup{pdfview=Fit}%
    \old@Hy@EveryPageAnchor
    \endgroup
}

% bookmark
\RequirePackage{bookmark}

% ---

% Furthermore, ~scrlayer-scrpage~ is required ...
% but not before geometry's alignment settings are finished!

% The "standard" odd margin value
\newlength{\StandOM}
\setlength{\StandOM}{89.62709pt}

% The "standard" toaddrhpos value
\newlength{\toaddrhpos}
\setlength{\toaddrhpos}{56.9055pt}

% Toggle that will detect if an alignment version was specified
% (and if putting a default option must be done).
\newif\ifmy@alignment@specified
\my@alignment@specifiedfalse

% Usual "indentation" of text body.
\ifnum\pdfstrcmp{\my@alignment}{standard}=0%
    \geometry{%
        inner={\StandOM},%
        outer={\StandOM},%
        top={1.9\toaddrhpos},%
        bottom={1.9\toaddrhpos},%
    }
    \my@alignment@specifiedtrue
\else\fi

% Aligns body to head.
\ifnum\pdfstrcmp{\my@alignment}{bodytohead}=0%
    \geometry{%
        % includehead,%
        % includefoot,%
        inner={\toaddrhpos},%
        outer={\toaddrhpos},%
        top={1.9\toaddrhpos},%
        bottom={1.9\toaddrhpos},%
    }
    \my@alignment@specifiedtrue
\else\fi

% Aligns head to body (in hard conflict with DIN 5008!).
\ifnum\pdfstrcmp{\my@alignment}{headtobody}=0%
    \geometry{%
        inner={\StandOM},%
        outer={\StandOM},%
        top={1.414\StandOM},%
        bottom={1.414\StandOM},%
    }
    \setplength{toaddrhpos}{\dimexpr\oddsidemargin+1in}
    \my@alignment@specifiedtrue
\else\fi

% If no (valid) alignment option is specified,
% set a default variant.
\ifmy@alignment@specified\else
    \geometry{%
        inner={\StandOM},%
        outer={\StandOM},%
        top={1.9\toaddrhpos},%
        bottom=1.9\toaddrhpos %
    }
\fi

% ---

% scrlayer-scrpage for taking header
% and footer design at one's own
\RequirePackage{scrlayer-scrpage}

% lastpage for knowing the total account of pages
% (accessibel via ~\pageref{LastPage}~)
\RequirePackage{lastpage}

% All pages may share the same pagestyle option
\pagestyle{scrheadings}
\xpatchcmd{\opening}{\thispagestyle{empty}}{}{}{}
% The next patch is only necessary
% for ~scrletter.sty~ but not for ~scrlttr2.cls~
\xpatchcmd{\letter}{\pagestyle{\letterpagestyle}}{}{}{}

% Footer's left
\ifoot*{\usekomavar{date}}

% Footer's middle
\cfoot*{\thepage{}\,{\ensuremath{|}}\,\letterlastpage}

% Footer's right
\ofoot*{\usekomavar{place}}

% Central header
\chead*{
% Box in box in order to avoid a
% ~\headheight to low~ warning
\raisebox{0pt}[0pt][0pt]{%
\parbox[b][2.5cm][t]{\linewidth}{
\centering%
{\KOMAoption{fontsize}{20pt}\bfseries\scshape%
{\color{mainaccentcolor}\usekomavar{fromgivenname}}~%
{\color{otheraccentcolor}\usekomavar{fromlastname}}%
}\\[0.25cm]
\hypersetup{urlcolor=otheraccentcolor}
\usekomavar{fromstreet}, \usekomavar{fromzip}\\
\usekomavar[\edef\KOMAfromemail]{fromemail}%
\href{mailto:\KOMAfromemail}{\KOMAfromemail}\\
\usekomavar[\edef\KOMAfrommobilephone]{frommobilephone}%
\telref{\KOMAfrommobilephone}%
}
}
}

% Calibrates head- and footheigth
\setlength{\footheight}{22pt}
\setlength{\headheight}{44pt}

% Do not print the scrlttr2 default first page header
% Information will be printed by vanilla header
\KOMAoption{firsthead}{false}
\KOMAoption{nexthead}{}
\KOMAoption{headwidth}{\useplength{firstheadwidth}}

% Do not print the scrlttr2 default first page header
\KOMAoption{firstfoot}{false}
\KOMAoption{nextfood}{}
\KOMAoption{footwidth}{\useplength{firstheadwidth}}

\KOMAoption{headwidth}{\useplength{firstheadwidth}}
\KOMAoption{footwidth}{\useplength{firstheadwidth}}

\addtokomafont{pagehead}{\normalfont}
\addtokomafont{pagefoot}{\footnotesize\normalfont\scshape}

% ---

% Activates auxiliary rules when wished.
\ifmy@visualize%
    \LoadLetterOption{visualize}
    \showfields{%
        address,%
        location,%
        refline,%
    }
\else\fi%

% ---

% With ~scrletter~, the command
% \addtokomafont{subject}{\normalfont\bfseries\scshape\large}
% is ignored and one has to add
\addtokomafont{lettersubject}{\normalfont\bfseries\scshape\large}

% ---

% Minor adaptions when there is no pagecounter
% reset by letter environments
\ifmy@counterresetbyletter\relax\else
    \xpatchcmd{\letter}{\setcounter{page}{\@ne}}{}{}{}
    \xpatchcmd{\letter}{\setcounter{footnote}{0}}{}{}{}
    \cfoot*{\thepage{}\,{\ensuremath{|}}\,\pageref*{LastPage}}
\fi

% ---

% Some letter fine tuning

% Never put a refline (ugly)!
\removereffields

% Aligns signatures to the left
\renewcommand*{\raggedsignature}{\raggedright}

% Font settings
\addtokomafont{backaddress}{\normalfont\slshape}
\addtokomafont{foldmark}{\color{mainaccentcolor}}
\addtokomafont{title}{\normalfont\bfseries}
\addtokomafont{subject}{\normalfont\bfseries\scshape\large}
\addtokomafont{pageheadfoot}{\color{otheraccentcolor}}

% Further settings
\KOMAoption{addrfield}{topaligned}
% \KOMAoption{backaddress}{plain}
\KOMAoption{backaddress}{false}
\KOMAoption{foldmarks}{h, p}
%\KOMAoption{fromalign}{center}
%\KOMAoption{fromemail}{true}
%\KOMAoption{fromlogo}{false}
%\KOMAoption{frommobilephone}{false}
%\KOMAoption{fromphone}{false}
%\KOMAoption{fromrule}{afteraddress}
%\KOMAoption{fromurl}{false}
%\KOMAoption{locfield}{wide}
%\KOMAoption{numericaldate}{true}
%\KOMAoption{priority}{false}
\KOMAoption{subject}{beforeopening, left}
\KOMAoption{refline}{nodate}

% Some scrlttr2 pseudolengths
% A graphic illustrating all pseudolengths
% of a letter can be found at:
% [[https://tex.stackexchange.com/questions/109797][How to remove space between back address and address in scrlttr2?]]
\setplength{locwidth}{\useplength{toaddrwidth}}
\setplength{refvpos}{\my@refvpos}
\setplength{sigindent}{0cm}
% \setplength{sigbeforevskip}{1cm}
% \setplength{backaddrheight}{11pt}
\setplength{toaddrheight}{\my@toaddrheight}
\setplength{subjectbeforevskip}{11pt}
\setplength{subjectaftervskip}{16.5pt}

% ---

% my-bg-layer for the background layer
\RequirePackage{my-bg-layer}
\mybglayersetup{%
    yshiftathead={15pt},%
    yshiftatfoot={-30pt},%
    borderlinewidthathead={0pt},%
    borderlinewidthatfoot={0pt},%
    clipradiusatedges={0pt},%
    borderlinewidthatboundary={0pt},%
    layerfillcolor={layercolor},%
    layerdrawcolor={mainaccentcolor},%
}

% ---

% Prints address of sender in the locfield

\def\print@refs{%
    \Ifkomavarempty{yourref}%
    {\Ifkomavarempty{myref}{}{\usekomavar{myref}}}%
    {\Ifkomavarempty{myref}{\usekomavar{yourref}}{\usekomavar{myref}\\\usekomavar{yourref}}}%
}

\setkomavar{location}{%
    \raggedleft%
    % How to accomplish this without guessing
    % and adapting the height any time
    \vskip 0.6\useplength{backaddrheight}
    \usekomavar{date} \\
    \usekomavar{place} \\
    \print@refs
}

% ---

% Adds pdf documents as attachments

\newcommand*{\Includepdf}[2]{%
    \DisableLayer%
    \includepdf[%
        % landscape,%
        pagecommand={%
                \thispagestyle{empty}%
            },%
        delta={0 0},%
        frame={false},%
        picturecommand={},%
        link={true},%
        nup={1x1},%
        pages={-},%
        linkname={#1},%
    ]{#2} %
}

\newcommand*{\SHIPOUTpdfAttachments}{}

\newcommand*{\ADDpdfAttachment}[3]{%
    \g@addto@macro\SHIPOUTpdfAttachments{%
        \phantomsection{}
        \bookmark[dest={#1.1}]{#2}
        \addcontentsline{toc}{section}{#2}
        \Includepdf{#1}{#3}
    }%
}

\xpretocmd{\enddocument}{\SHIPOUTpdfAttachments}{}{}

% ---
