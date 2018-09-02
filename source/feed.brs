Function RokuFeed(RokuFeedURL as String)  as  Object
    
  'feedUrl = "http://cdn-api.ooyala.com/syndication/roku?id=cf0ed5e9-98ca-45a8-b71e-7a1f1d14819b"
  'UNIVERSAL FED
  'feedUrl = "http://cdn-api.ooyala.com/v2/syndications/c520e489566c43179a641ea2fafe1d1a/feed?pcode=Q2b3YxOsGMabzRW-sHwRjfpyd4dd"
  
  feedUrl = RokuFeedURL
 
  searchRequest = CreateObject("roUrlTransfer")
  feed = CreateObject("roXMLElement")
  searchrequest.SetURL(feedUrl)
  xml = searchrequest.GetToString()
  feed.Parse(xml)

  return feed  
End Function

Function GetMediaUrlForCdnId(cdnId as String, feedUrl as String) as string
     
 feed = RokuFeed(feedUrl)
 
 nextPage = ""
  
  for each channel in feed.GetChildNodes()
       for each item in Channel.GetChildNodes()
          
           if item.GetName() = "next_page"
            nextPage = item.GetText() 
           end if
            
           if item.GetName() = "item" then
             for each node in item.GetChildNodes()
                if node.GetName() = "guid"
                    if node.GetText() = cdnId
                       return getMediaUrlforNode(item)
                    end if 
                end if 
             end for 
           end if 
       end for
  end for
  
 if nextPage = ""
   return ""
 else   
  return  GetMediaUrlForCdnId(cdnId, nextPage)
 end  if  
End Function 


Function getMediaUrlforNode(item as Object) as string     
     videoUrl = ""  
       for each node in item.GetChildNodes()
                if node.GetName() = "media:content"
                    videoUrl = node@url 
                   'for each media in node.GetChildNodes()
                    'print media.GetName()
                     'videourl = media@url
                   'end for
                end if 
             end for
        return videoUrl     
End Function  