function watchListScreen()
    SetTheme()
    gridScreen = setScreenType()
    gridScreen.Show()
    noOfItemList = ["Watch List"]
    gridScreen.SetupLists(noOfItemList.Count())    
    gridScreen.SetListNames(noOfItemList)
    watchListContentList  = getWatchList()
    videoList =  watchListContentList.responseData.videos
    if videoList.Count() = 0
        showErrorDialog("No Item in  List", "There are no items in the watch later list.") 
        dialog  =  showBusyMethod(gridScreen)
        'gridScreen.close()
        homeScreen(dialog)   
    end if 
    
    watchListContent = createPoster(videoList)  
    gridScreen.SetContentList(0, watchListContent)
   gridScreen.SetBreadcrumbText("", "Watch List")
   gridScreen.SetFocusedListItem(0, 0)
   gridScreen.SetDescriptionVisible(true)   
   

   while true
         msg = wait(0, gridScreen.GetMessagePort())
         if type(msg) = "roGridScreenEvent" then
             if msg.isScreenClosed() then
                   return  -1  
             else if msg.isListItemFocused() then
             
              else if msg.isListItemSelected() then
                       videoDetailArray = watchListContent[msg.GetData()]
                      watchListContent[msg.GetData()].process(videoDetailArray)
             end if
         end if     
    end while         
end function


Function CreatePoster(list as dynamic) as dynamic
      collectionList = CreateObject("roArray", 4, true)
      for each g in list
            g.watchList = "YES"     
            collections = createPosterforVideo(g)
            collectionList.push(collections)
      end for
      return collectionList 
end Function


Function getWatchList() as dynamic
    watchListItem = CreateObject("roAssociativeArray")
     user = getUserDetails()     
    list =  CallApi("watchlater", user.userId.toInt())
    return list 
End Function