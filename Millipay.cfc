/** 
*  API for millipay.ch
*  ===================
*  by clickwerk.ch
*/ 
component accessors="true" { 
    public any function init(required string sharedKey, required String baselink){
        variables.sharedKey = arguments.sharedKey;
        variables.baselink = arguments.baselink;
        return this;
    }

    /** 
    * @hint "Generate millipay-link by params defined as a LinkedHashMap" 
    */ 
    public string function generate(required struct params){
        var linkparams = "";
        var valString = "";
        var val = "";

        // using java-encoder because URLEncodedFormat() does it different
        var urlEncoder = CreateObject("java","java.net.URLEncoder");

        for(key IN arguments.params) {
            if(!len(linkparams)){
                linkparams &= "?";
            } else {
                linkparams &= "&";
            }
            val =  urlEncoder.encode(arguments.params[key],"utf-8");
            linkparams &= key & "=" & val;
            valString &= arguments.params[key];
        }
        valString &= variables.sharedKey;
        // default md5-hash of coldfusion is uppercase
        var md5string = lCase(Hash(valString, "MD5","utf-8"));

        linkparams &= "&MP.MAC" & "=" & lCase(md5string);

        return variables.baselink & linkparams;
    }

    /** 
    * @hint "Validate URL-String with parameters using" 
    */ 
    public boolean function validate(required string queryString){    
        var valString = "";
        var expression = "";
        var md5expression = "";

        var urlDecoder = CreateObject("java","java.net.URLDecoder");
        for (i = 1; i lte ListLen(arguments.queryString,'&'); i++) {
            expression = ListGetAt(arguments.queryString, i,'&');
            var keyval = expression.split("=");
            if(keyval[1] != "MP.MAC"){
                valString &= keyval[2];
               
            } else {
                 md5expression = keyval[2];
            }
        }
        valString &= variables.sharedKey;
        var md5string = lCase(Hash(valString, "MD5","utf-8"));

        return len(md5expression) and md5expression == md5string;
    }
}
