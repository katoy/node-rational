

$(function() {

    function show_val() {
        $("#message").text("");
        
        var txt = $("#inp_text").val();
        var base = $("#base").val();
        var show_base = (base !== "10");
        try {
            var val = arithmeticsR.parse(txt);
            $("#resultString").text(val.toRepeatStringN(base, show_base));
            if ("" + val.denominator() != "1") {
                $("#resultRational").text(val.toStringN(base, show_base));
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