'
'    LoadLiveRail.brs
'    LiveRail Brightscript Examples
'
'    Copyright (c) 2014 LiveRail. All rights reserved.
'

Sub LoadLiveRail()

    g = GetGlobalAA()
    
    if (g.LiveRailAdManager = invalid)

        loader = CreateObject("roUrlTransfer")
        loader.SetUrl("http://cdn-static.liverail.com/roku/LiveRailAdManager-1.0.brs")
        response = loader.GetToString()
        loaderResult = Eval(response)
        if (loaderResult = invalid or type(loaderResult) <> "Integer" or loaderResult <> &hFC)
            'print "Unable to load LiveRailAdManager"
            return
        end if
        'print "Loaded LiveRailAdManager: " g.LiveRailAdManager

    end if

    g.LiveRailLogLevel% = 3

End Sub
