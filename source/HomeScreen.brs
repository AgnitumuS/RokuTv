REM Create HomeScreen
Function HomeScreenItems() 
    homeScreenItemsList = CreateObject("roAssociativeArray")
    videoId = 0
    CollectionList = getCollectons(videoId)
    
    homeScreenItemsList.collectionList = getCollectionsList(CollectionList.responseData)
        
    'Selecting the First Id
    posterAndSeries = CollectionDetails(CollectionList.responseData[0].collectionId)
    
    homeScreenItemsList.seriesList = posterAndSeries.series
    
    homeScreenItemsList.videoList = posterAndSeries.episode
    
    return homeScreenItemsList
End Function


REM FUNCTION To Get Collection List or Collection Details
Function getCollectons(id as integer) as Object
   apiResult = CallApi("collection", id) 
   return apiresult      
End Function


REM Function to get all videos of a specific series
Function getAllVideosOfSpecificSeries(seriesId as integer) as Object
     'print  "Series called"
   apiResult = CallApi("series", seriesId)
   return apiresult      
End Function


REM Function to get the details of a specific video using video Id
Function getVideo(videoId as integer) as Object
   apiResult = CallApi("video", videoId) 
   return apiresult      
End Function



REM Function to get the details of a specific video using video Id
Function geFilteredtVideoAccordingToSearchKeyword(searchKeyword as String) as Object
   apiResult = CallApiForSearching("search/"+searchKeyword) 
   return apiresult      
End Function

REM Function to Get Individual Item from Collection List
function getCollectionsList(group as Object) as Object
      collectionList = CreateObject("roArray", 4, true)
      for each g in group 
        collections = createPosterforCollection(g)
        collectionList.push(collections)
      End for
      return collectionList  
End Function 



REM Function to get Collection detials
Function CollectionDetails(id as integer) as Object
     Poster  = CreateObject("roAssociativeArray")
     'Poster.series = CreateObject("roArray", 1, true)
     'Poster.episode = CreateObject("roArray", 1, true)
     
     REM API Call for  getting Collection Details
     detail = getCollectons(id)
	 'print "Called from 2"
     seriesEpisode = getAllVideosOfSpecificSeries(detail.responseData.seriesList[0].seriesId)   
     
     series = SeriesPoster(detail.responseData.seriesList)
    ' print seriesEpisode.responseData.episodeList.count()
     
     if seriesEpisode.responseData.episodeList.count() =0 then
     else 
     episode = VideoPosters(seriesEpisode.responseData.episodeList)
     end if
     'print seriesEpisode;  
     poster.series = series
     poster.episode = episode  
     return poster 
End Function


function SeriesPoster(list as Object) as Object
    series = CreateObject("roArray", 1, true)
    for each l in list 
        series.Push(createPosterforSeries(l))
    End for
    return series  
End Function


function VideoPosters(list as Object) as Object
    episode = CreateObject("roArray", 1, true)
    for each l in list 
		 l.watchList = "NO"
        episode.Push(createPosterforVideo(l))
    End for
    return episode  
End Function

