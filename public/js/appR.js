

$(function() {

    function show_val() {
        $("#message").text("");
        
        var txt = $("#inp_text").val();
        var base = $("#base").val();
        try {
            var val = arithmeticsR.parse(txt);
            $("#resultString").text(val.toRepeatStringN(base, false));
            if ("" + val.denominator() != "1") {
                $("#resultRational").text(val.toStringN(base, false));
            } else {
                $("#resultRational").text("");
            }
        } catch (ex) {
            $("#message").text(ex);
        }
    };
    
    $("#inp_text").keypress(function(ev) { 
        if ((ev.which && ev.which === 13) || (ev.keyCode && ev.keyCode === 13)) {
            show_val();
        }
    });

    $("#base").keypress(function(ev) { 
        if ((ev.which && ev.which === 13) || (ev.keyCode && ev.keyCode === 13)) {
            show_val();
        }
    });

});