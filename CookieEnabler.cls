public class CookieEnabler {

    /** Change the class here so it points to the one you need cookie support for */
    public static DocuVantageSoap.DocuVantageSoapPort stub;
    /** This will contain the name of the cookie after storeCookieFromPreviousResponse() is called */
    public static string cookieName;
    /** This will contain the value of the cookie after storeCookieFromPreviousResponse() is called */
    public static string cookieValue;
    
    /** This sets outputHttpHeaders_x to a new map which then makes it store response headers */
    public static void init() {
        if (stub.outputHttpHeaders_x == null) {
            stub.outputHttpHeaders_x = new Map<String, String>();
        }
    }
    
    /** Call this after the first request. It then extracts the Set-Cookie header and stores a Cookie header 
     * that will be used for subsequent requests
     * Issues:
     * There could be multiple Set-Cookie headers returned but it seems the apex WebServiceCallout 
        code only keeps one. Nothing we can do about that. Most of the time there is only one cookie returned. */
  public static void storeCookieFromPreviousResponse() {
        if (stub.outputHttpHeaders_x == null) { 
            //throw new Exception('Add this before first SOAP method call: stub.outputHttpHeaders_x = new <String, String> Map();');
            System.debug('Add this before first SOAP method call: stub.outputHttpHeaders_x = new <String, String> Map();'); 
            return;
        }
        if (stub.inputHttpHeaders_x == null) { stub.inputHttpHeaders_x = new Map<String,String>();}
        string setCookieHeader = stub.outputHttpHeaders_x.get('Set-Cookie');
        System.debug('setCookieHeader='+setCookieHeader);
        if (string.isEmpty(setCookieHeader)) { 
            System.debug('There was no Set-Cookie header'); 
            return; 
        }
        string[] parts = setCookieHeader.split(';');
        if (parts == null || parts.size() == 0) { return; }
        string nameValueString = parts[0];
        if (String.isEmpty(nameValueString)) { System.debug('First part before ; is blank'); return; }
        System.debug(nameValueString);
        string[] nameValueArray = nameValueString.split('=');
        if (nameValueArray == null || nameValueArray.size()!=2) { System.debug('Expecting name=value, got '+nameValueString); return; }
        string name = nameValueArray[0];
        string value = nameValueArray[1];
        if (name == null || value == null) { return; }
        name = name.trim();
        value = value.trim();
        stub.inputHttpHeaders_x.put('Cookie', ''+name+'='+value);
        cookieName = name;
        cookieValue = value;
        System.debug('success');
    }
}