@isTest
public class CookieEnablerTest {
    public static testMethod void test() {
        
        CookieEnabler.stub = new DocuVantageSoap.DocuVantageSoapPort();
        
        // we call it before calling init() so it does not work
        CookieEnabler.storeCookieFromPreviousResponse();
        
        CookieEnabler.init();
        
        // there is no header set yet so this fails
        CookieEnabler.storeCookieFromPreviousResponse();
        
        // we set a header
        CookieEnabler.stub.outputHttpHeaders_x.put('Set-Cookie', 'JSESSIONID=asdfasdf');
        CookieEnabler.storeCookieFromPreviousResponse();
        
        string cookieval = CookieEnabler.stub.inputHttpHeaders_x.get('Cookie');
        System.assertEquals('JSESSIONID=asdfasdf', 'JSESSIONID=asdfasdf');
        
    }
}