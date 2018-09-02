'
'    LiveRailAdManagerController.brs
'    LiveRail Brightscript Examples
'
'    Copyright (c) 2014 LiveRail. All rights reserved.
'

function LiveRailAdManagerController() as object

    adManagerController = {

        ' LiveRailAdManager instance
        adManager: m.LiveRailAdManager()

        ' roImageCanvas component, used for ad video and user interaction
        canvas: CreateObject("roImageCanvas")

        ' Properties returned from showAd
        impressionCount: 0
        backButtonPressed: false

        showAd: function (initParameters as object) as object

            ' Configure and show canvas component
            m.canvas.SetLayer(1, {color: "#00000000", CompositionMode: "Source"})
            m.canvas.Show()

            ' Add required properties to initParameters object
            initParameters.messagePort = m.canvas.GetMessagePort()
            initParameters.destinationRect = m.canvas.GetCanvasRect()

            ' Subscribe to standard LiveRailAdManager events
            m.subscribeEvents()

            ' Trigger ad initialization
            m.adManager.initAd(initParameters)

            ' Ad has completed, return result object
            return {
                impressionCount: m.impressionCount
                backButtonPressed: m.backButtonPressed
            }

        end function


        subscribeEvents: function () as void
            m.adManager.subscribe(m.onAdLoaded, "AdLoaded", m)
            m.adManager.subscribe(m.onAdImpression, "AdImpression", m)
            m.adManager.subscribe(m.onAdStopped, "AdStopped", m)
            m.adManager.subscribe(m.onAdError, "AdError", m)
            m.adManager.subscribe(m.onRoEvent, "RoEvent", m)
        end function


        unsubscribeEvents: function () as void
            m.adManager.unsubscribe(m.onAdLoaded, "AdLoaded")
            m.adManager.unsubscribe(m.onAdImpression, "AdImpression")
            m.adManager.unsubscribe(m.onAdStopped, "AdStopped")
            m.adManager.unsubscribe(m.onAdError, "AdError")
            m.adManager.unsubscribe(m.onRoEvent, "RoEvent")
        end function


        onAdLoaded: function (infoObject as object, scope as object) as void
            ''print "Received AdLoaded"
            scope.adManager.startAd()
        end function


        onAdImpression: function (infoObject as object, scope as object) as void
            ''print "Received AdImpression"
            scope.impressionCount = scope.impressionCount + 1
        end function


        onAdStopped: function (infoObject as object, scope as object) as void
            ''print "Received AdStopped"
            scope.onAdComplete()
        end function


        onAdError: function (infoObject as object, scope as object) as void
            ''print "Received AdError"
            scope.onAdComplete()
        end function


        onAdComplete: function ()

            m.unsubscribeEvents()

            if (m.canvas <> invalid)
                m.canvas.Clear()
                m.canvas.Close()
            end if

        end function

        onRoEvent: function (infoObject as object, scope as object) as void

            if (infoObject.message <> invalid)

                msg = infoObject.message
                ''print "RoEvent message received: " msg
                
                ' Allow back navigation
                if type(msg) = "roImageCanvasEvent" AND msg.isRemoteKeyPressed() AND msg.GetIndex() = 0
                    ''print "User pressed back button, calling stopAd()"
                    scope.backButtonPressed = true
                    scope.adManager.stopAd()
                end if

            end if

        end function
    }

    ' Configure a messagePort for the canvas component
    adManagerController.canvas.SetMessagePort(CreateObject("roMessagePort"))

    ' Return the LiveRailAdManagerController instance
    return adManagerController

end function
