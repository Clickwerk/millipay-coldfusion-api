<cfscript>
    /** 
    *  API for millipay.ch
    *  ===================
    *  by clickwerk.ch
    --------------------------------------------
    This example handles the request and the response
     */

    // config:
    sharedKey = ""; // your shared key of millipay
    baselink = "http://demo-mybutton.millipay.ch/b6dd089a519fc9b41078b532b0df1256/payment/start"; // baseurl millipay

    // create millipay-helper-object
    millipayHelper = new Millipay(sharedKey=sharedKey,baselink=baselink);

    // generate link
    if(!StructKeyExists(URL, "MP.MAC")){

        // set all config-params in a linkedHashMap because of the ordering
        // e.g. param-documentation of millipay

        millipay = CreateObject("java","java.util.LinkedHashMap").init();
        millipay["DC.TITLE"] = "Titel";
        millipay["MP.PRICE"] = "5.00";
        millipay["MP.VALIDITY"] = "60";
        millipay["DC.IDENTIFIER"] = ""; //
        millipay["MP.VENDORID"] = "";
        millipay["MP.PRODUCTURL"] = "";     
        millipay["MP.PRICE"] = "5";
        millipay["MP.STATUSURL"] = ""; // callback url*/
        // and up to 8 custom parameter

        // output link
        writeOutput("<a href='" & millipayHelper.generate(millipay) & "'>Millipay Link</a>");
     
    /* ################# RESPONSE ################### 
     must be in the file defined in the link of MP.STATUSURL*/
    } else {
        // validate response by url-params and mp.mac
        if(millipayHelper.validate(CGI.QUERY_STRING)){
            switch(url.statuscode){
                case 200:
                    writeOutput("do something after payment was successfull");
                    break;
                case 204:
                    writeOutput("user aborted");
                    break;
                case 400: 
                    writeOutput("bad request");
                    break;
            }
        } else {
            writeOutput("fake response");
        }
    }
</cfscript>
