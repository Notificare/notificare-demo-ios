notificare-demo-ios
=========
Demo for APNs, Websockets, Tags, Location Services and OAuth2 features of Notificare

##Setup

1. Open app.xcodeproj and expand Supporting Files and click on ```app-Info.plist```. Change the ```Bundle display name``` and ```Bundle Identifier``` according to your needs (Bundle Identifier must match the App ID created in the developer portal). 
2. In ```Configuration.plist``` under Supporting Files you will have to insert your app specific data. You can optionally provide your Testflight SDK key, an URL for general purpose, navigation items and a host in case you intend to connect to make HTTP requests.
3. Define some colour, fonts or any other definitions in ```Definitions.h```
4. Expand Libs and ```notificare-push-lib-x.x.x``` and click in ```Notificare.plist```, change the API keys accordingly. Get them in your https://dashboard.notifica.re under **Settings > App Keys**.
5. Create certificates for APNS in Apple’s Developer Portal and upload the to Notificare as explained in: https://notificare.atlassian.net/wiki/display/notificare/1.+Set+up+APNS
6. Build Project (Make sure your signing certificates and mobile provision profiles are selected in both your your target and project in Xcode)
7. Start sending rich push messages, using geo-targeting, geo-fences and/or iBeacons.
8. Authentication will only work if you subscribe for the OAuth2 Service in https://dashboard.notifica.re under **Settings > Services**
