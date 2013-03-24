

$(function() {
    
    $("#inp_text").keypress(function(ev) { 
        $("#message").text("");

        if ((ev.which && ev.which === 13) || (ev.keyCode && ev.keyCode === 13)) {
            var txt = $(this).val();
            try {
                var val = arithmeticsR.parse(txt);
                $("#resultString").text(val.toRepeatString());
                if ("" + val.denominator() != "1") {
                    $("#resultRational").text(val.toString());
                } else {
                    $("#resultRational").text("");
                }
            } catch (ex) {
                $("#message").text(ex);
            }       
        }
    });

});