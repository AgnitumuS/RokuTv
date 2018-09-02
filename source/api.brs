
Function CallApi( apiurl as string, params as Integer ) as Object
  'BaseUrl = "http://alliant.icreondemoserver.com/api/"   
  BaseUrl = "http://cms.xivetv.com/api/" 
  ApiRequest = CreateObject("roUrlTransfer")
  
  REM SETTING API URL
  apiRequestUrl  = BaseUrl+apiurl+"/"+params.tostr()
  'print apiRequestUrl
  ApiRequest.SetURL(apiRequestUrl)
    
  REM SETTING Authorization HEADER FOR URL
  ApiRequest.AddHeader("Authorization","eyJhdXRoa2V5IjoiMTIzNDU2Nzg5IiwidXNlcklkIjoiIiwicGFzc3dvcmQiOiIiLCJhdXRoVG9rZW4iOiIifQ")
  
  REM RESPONSE FROM API REQUEST
  response = ParseJson(ApiRequest.GetToString())
  'print response
  return response
  
End Function 

Function CallApiForSearching( apiurl as string ) as Object
  'BaseUrl = "http://alliant.icreondemoserver.com/api/"
  BaseUrl = "http://cms.xivetv.com/api/"   
  ApiRequest = CreateObject("roUrlTransfer")
  
  REM SETTING API URL
  apiRequestUrl  = BaseUrl+apiurl
  ApiRequest.SetURL(apiRequestUrl)
  'print "API URL"
  'print apiRequestUrl
  REM SETTING Authorization HEADER FOR URL
  ApiRequest.AddHeader("Authorization","eyJhdXRoa2V5IjoiMTIzNDU2Nzg5IiwidXNlcklkIjoiIiwicGFzc3dvcmQiOiIiLCJhdXRoVG9rZW4iOiIifQ")
  
  REM RESPONSE FROM API REQUEST
  response = ParseJson(ApiRequest.GetToString())
  'print "RESPONSE"
  'print response
  return response
End Function 