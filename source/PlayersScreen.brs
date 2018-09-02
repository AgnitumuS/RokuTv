Function videoCdnId( cdnId as string )  as string 
  feedUrl = "http://cdn-api.ooyala.com/v2/syndications/c520e489566c43179a641ea2fafe1d1a/feed?pcode=Q2b3YxOsGMabzRW-sHwRjfpyd4dd"
  'UrlString  = "http://player.ooyala.com/player/ipad/"
  'UrlExt = ".m3u8"
  UrlString = "http://content.jwplatform.com/videos/"
  UrlExt = ".mp4"
  'videoUrl  = GetMediaUrlForCdnId(cdnId, feedUrl)
  videoUrl  = urlString+cdnId+urlExt 
   
  return videoUrl
End Function  