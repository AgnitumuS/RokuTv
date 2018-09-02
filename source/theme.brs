Function SetTheme()
    app = CreateObject("roAppManager") 
    'Set Theme Attributes
    theme = {
       ThemeType : "generic-dark"
       GridScreenOverhangSliceHD : "pkg:/locale/default/images/Overhang_Background_HD.png"
       GridScreenOverhangSliceSD : "pkg:/locale/default/images/Overhang_Background_SD.png"
       GridScreenOverhangHeightHD : "120"
       GridScreenOverhangHeightSD : "85"
       
       OverhangSliceHD : "pkg:/locale/default/images/Overhang_Background_HD.png"
       OverhangSliceSD : "pkg:/locale/default/images/Overhang_Background_SD.png"
       
       GridScreenFocusBorderHD : "pkg:/locale/default/images/BordrerHD.png"
       GridScreenFocusBorderSD : "pkg:/locale/default/images/BordrerSD.png"
       GridScreenBorderOffsetHD : "(0, 0)"
       GridScreenBorderOffsetSD : "(0, 0)"
       
       BreadcrumbDelimiter : "#ffffff"
       BreadcrumbTextLeft : "#ffffff"
       BreadcrumbTextRight : "#ffffff"
       
       CounterSeparator : "#ffffff"
       CounterTextLeft : "#ffffff"
       CounterTextRight : "#ffffff" 
       
       BackgroundColor  :  "#312e30"
       SpringboardTitleText : "#ffffff" 
       'ButtonMenuNormalText : "#ffffff" 
       'ButtonHighlightColor : "#ffffff"
       'ButtonMenuHighlightText : "#ffffff"
       'ButtonMenuNormalOverlayText : "#ffffff"
        ButtonNormalColor : "#000000"
       
       DialogTitleText : "#0033CC"
       DialogBodyText : "#000000"
       'ButtonMenuNormalText : "#000000"
    }
    app.SetTheme(theme)

End Function