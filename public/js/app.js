
$(function() {

    function show_val() {
        $("#message").text("");        

        var txt = $("#inp_text").val();
        var base = $("#base").val();
        try {                
            $("#result").text(arithmetics.parse(txt).toString(base));
        } catch (ex) {
            $("#message").text(ex);
        }       
    }
    
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