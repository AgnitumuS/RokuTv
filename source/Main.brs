Sub Main()
        'removeAuthSetting()        
        m. isSubscribed = getAuthSetting()
        homeScreen()
End Sub


function homeScreen( busydialog = invalid)
    'print "HOmeScreen"
   SetTheme()
 REM Creating Home Screen
   LoadLiveRail()
   
   checkUserSubscription()
   
   HomeScreenList = HomeScreenItems()
   searchSubscribeSignin = getSearchSubscribeSigninCat()
   gridScreen = setScreenType()
   gridScreen.Show()
   
   'BUSY DIALOG BOX
  
   noOfItemList = ["", "Collections", "Series", "Videos"]
   
   gridScreen.SetupLists(noOfItemList.Count())
   gridScreen.SetListNames(noOfItemList)
    'gridScreen.SetDisplayMode(0, False)
   gridScreen.SetDescriptionVisible(true)
   
   gridScreen.SetBreadcrumbText("", "Home")
   gridScreen.SetLoadingPoster("pkg:/locale/default/images/HomeLogoHD.jpg", "pkg:/locale/default/images/HomeLogoSD.jpg")
   gridScreen.SetContentList(0, searchSubscribeSignin)
   gridScreen.SetContentList(1, HomeScreenList.collectionList)
   gridScreen.SetContentList(2, HomeScreenList.seriesList)
   if HomeScreenList.videoList.Count() = 0 then
      '  print "No VIdeo on HOme screen" 
   else
        gridScreen.SetContentList(3, HomeScreenList.videoList) 
   end if 
  
   gridScreen.SetFocusedListItem(1, 0)
   
    If type(busydialog)<>"Invalid" 
         busydialog.close() 
    end if
   
   while true
         msg = wait(0, gridScreen.GetMessagePort())
         
         if type(msg) = "roGridScreenEvent" then
             if msg.isScreenClosed() then
                return -1
             else if msg.isListItemFocused()
                  if (msg.GetIndex()=1)
                     'collectionId = HomeScreenList.collectionList[msg.GetData()].collectionId
                     'list = CollectionDetails(collectionId)
                     'HomeScreenList.seriesList = list.series
                     'gridScreen.SetContentList(2, HomeScreenList.seriesList)
                     'if list.episode.Count() = 0 then
                        'noOfItemList.pop()
                     'end if
                     'TC gridScreen.SetContentList(3, list.episode)
                  else if (msg.GetIndex()=2)
                     'seriesId = HomeScreenList.seriesList[msg.GetData()].seriesId     
                     'videolist = getAllVideos(seriesId)
                     ' HomeScreenList.videoList = videolist
                     'print videolist
                     'gridScreen.SetContentList(3, videolist)
                  end if
             else if msg.isListItemSelected() then
                
                 if (msg.GetIndex()=0)
                         searchSubscribeSignin[msg.GetData()].process()
                     if (msg.GetData()=1)
                                              
                     end if
                     if (msg.GetData()=2)
                        
                     end if
                 end if
                 if (msg.GetIndex()=1)
                     'Updating Series List
                     collectionId = HomeScreenList.collectionList[msg.GetData()].collectionId
                     list = CollectionDetails(collectionId)
                     HomeScreenList.seriesList = list.series
                     gridScreen.SetContentList(2, HomeScreenList.seriesList)
                     'Updating Video Listing
                     if HomeScreenList.seriesList.count() = 0 then
                     else
                             seriesId = HomeScreenList.seriesList[0].seriesId               
                             videolist = getAllVideos(seriesId)
                       end if       
                     if videolist.count() = 0 then
                        '    print "no videos"
                     else
                           HomeScreenList.videoList = videolist
                           gridScreen.SetContentList(3,  HomeScreenList.videoList)                      
                           gridScreen.SetFocusedListItem(2, 0)
                     end if 
                     
                 end if
                 if (msg.GetIndex()=2)
                     'Updating Video Listing
                     if HomeScreenList.seriesList.count() = 0 then
                     else
                         seriesId = HomeScreenList.seriesList[msg.GetData()].seriesId     
                         videolist = getAllVideos(seriesId)
                          HomeScreenList.videoList = videolist
                         gridScreen.SetContentList(3,  HomeScreenList.videoList)
                         gridScreen.SetFocusedListItem(3, 0)
                   end if
                end if  
                 if (msg.GetIndex()=3)                        
                      videoDetailArray = HomeScreenList.videoList[msg.GetData()]
                      HomeScreenList.videoList[msg.GetData()].process(videoDetailArray)
                      gridScreen.close()
                 end if
             endif
         endif             
     end while   
     
end function

Function setScreenType()
   port = CreateObject("roMessagePort")
   gridScreen = CreateObject("roGridScreen")
   gridScreen.SetMessagePort(port)  
   gridScreen.SetGridStyle("two-row-flat-landscape-custom")
   
   return gridScreen
End Function