object TPersHolder
  P.Name = 'GAMS'
  P.SyntaxBlocks = <
    item
      Name = 'Default'
      ID = 0
      FIText = 0
      FIIntNum = 1
      FIFloatNum = 2
      FIHexNum = 3
      FIDirective = 4
      FISymbol = 13
      FIIdentifier = 11
      UseSymbols = True
      UseComments = True
      UseSingleLineComments = True
      UseMultiLineComments = True
      UseFullLineComments = True
      UseStrings = True
      UseSingleLineStrings = True
      UseNumbers = True
      UsePrefixedNumbers = True
      UseIdentifiers = True
      UsePrefixedSuffixedIdentifiers = True
      UseKeywords = True
      BlockDelimiters = <>
      SingleLineCommentDelimiters = <
        item
          FontID = 5
          LeftDelimiter = '//'
        end>
      MultiLineCommentDelimiters = <
        item
          FontID = 14
          LeftDelimiter = '$ONTEXT'
          RightDelimiter = '$offtext'
        end
        item
          FontID = 26
          LeftDelimiter = '$ONECHO'
          RightDelimiter = '$OFFECHO'
        end>
      FullLineCommentDelimiters = <
        item
          FontID = 15
          LeftDelimiter = '*'
        end>
      SingleLineStringDelimiters = <
        item
          FontID = 7
          LeftDelimiter = #39
          RightDelimiter = #39
        end
        item
          FontID = 8
          LeftDelimiter = '"'
          RightDelimiter = '"'
        end>
      NumPrefixes = <
        item
          LeftDelimiter = '#'
        end>
      IdentPrefixesSuffixes = <
        item
          LeftDelimiter = '.'
          RightDelimiter = '.'
        end>
      KeywordSets = <
        item
          FontID = 9
          Name = 'statements'
          Keywords = 
            'ABORT,ABS,ACRONYM,ACRONYMS,ALIAS,ALL,AND,ASSIGN,AUXILIARY,BATINC' +
            'LUDE,BETA,BETAREG,BINARY,BINOMIAL,CALL,CARD,COMMENT,DIAG,DISPLAY' +
            ',DOLLAR,ECHO,ECHON,ELSE,ELSEIF,EOLCOM,EPS,EQ,EQUATION,EQUATIONS,' +
            'ERROR,EXECUTE_LOAD,EXECUTE_UNLOAD,EXIT,FILE,FILES,FOR,FREE,GAMMA' +
            ',GAMMAREG,GDXIN,GE,GOTO,GT,HIDDEN,IF,IFI,INCLUDE,INF,INLINECOM,i' +
            'nlinecom,INTEGER,KILL,LABEL,LE,LIBINCLUDE,LINES,LOAD,LOGBETA,LOG' +
            'GAMMA,LOOP,LT,MAXCOL,MAXIMIZING,MINCOL,MINIMIZING,MODEL,MODELS,N' +
            'A,NE,NEGATIVE,NO,NOT,OFFDIGIT,OFFDOLLAR,OFFEMPTY,OFFEOLCOM,OFFIN' +
            'LINE,OFFLISTING,OFFLISTING,OFFMARGIN,OFFMULTI,OFFSYMLIST,OFFSYMX' +
            'REF,OFFTEXT,OFFUPPER,OFFWARNING,ONDIGIT,ONDOLLAR,ONEMPTY,ONEOLCO' +
            'M,ONGLOBAL,ONINLINE,ONLISTING,ONLISTING,ONMARGIN,ONMULTI,ONSYMLI' +
            'ST,ONSYMXREF,ONTEXT,ONUPPER,ONWARNING,OPTION,OPTIONS,OR,ORD,PARA' +
            'METER,PARAMETERS,PHANTOM,POSITIVE,PROD,PUTPAGE,PUTTL,REPEAT,REPO' +
            'RT,SAMEAS,SCALAR,SCALARS,SECTORS,SEMICONT,SEMIINT,SET,SETARGS,SE' +
            'TGLOBAL,SETS,SMAX,SMIN,SOLVE,SOS1,SOS2,SQR,SQRT,STITLE,SUM,SYSIN' +
            'CLUDE,SYSTEM,TABLE,THEN,TITLE,TITLE,UNTIL,USING,VARIABLE,VARIABL' +
            'ES,VERID,WHILE,XOR,YES,SETLOCAL,SETENV,ONRECURSE,OFFRECURSE,EXIS' +
            'T,IFTHEN,IFTHENI,ENDIF,MACRO,UNLOAD,GDXOUT,EXECUTE,TERMINATE,EXI' +
            'STS,EVAL,IFE,IFTHENE,EVALGLOBAL,EVALLOCAL,SYSENV,DEFINED'
        end
        item
          FontID = 16
          Name = 'GAMSsets'
          Keywords = 'GAMS,Scenario,M,N'
        end
        item
          FontID = 17
          Name = 'GAMSparameters'
          Keywords = 'C1,C2,OUTPUT'
        end
        item
          FontID = 18
          Name = 'GAMSvariables'
          Keywords = 'AVG,J,X'
        end
        item
          FontID = 19
          Name = 'GAMSEquations'
          Keywords = 'AVERAGE,CRITERION,INDUSTRY,STATE'
        end
        item
          FontID = 20
          Name = 'GAMSModels'
          Keywords = 'GUA'
        end
        item
          FontID = 21
          Name = 'GAMSElements'
          Keywords = 'fx,l,level,lo,m,marginal,prior,scale,up,aa,bb,a,b,c'
        end
        item
          FontID = 22
          Name = 'comments'
        end
        item
          FontID = 23
          Name = 'GAMSfiles'
        end
        item
          FontID = 24
          Name = 'GAMSglobals'
        end>
    end>
  P.FontTable = <
    item
      FontID = 0
      GlobalAttrID = 'Whitespace'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 1
      GlobalAttrID = 'Integer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 55552
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 3
      GlobalAttrID = 'Integer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
    end
    item
      FontID = 7
      GlobalAttrID = 'String'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 8
      GlobalAttrID = 'String'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 9
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 14
      GlobalAttrID = 'Comment'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      UseDefBack = False
    end
    item
      FontID = 15
      GlobalAttrID = 'Comment'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = [fsItalic]
    end
    item
      FontID = 11
      GlobalAttrID = 'Whitespace'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 17
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 18
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 19
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7405568
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 21
      GlobalAttrID = 'String'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 5
      GlobalAttrID = 'Comment'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7405568
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8421631
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 26
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
    end
    item
      FontID = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2763519
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      BackColor = clSilver
      UseDefBack = False
    end
    item
      FontID = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      BackColor = clSilver
      UseDefBack = False
    end
    item
      FontID = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      BackColor = clSilver
      UseDefBack = False
    end>
  P.SyntaxVersion = 3
end
