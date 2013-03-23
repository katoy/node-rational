
$(function() {

    $("#inp_text").keypress(function(ev) { 
        $("#message").text("");
        
        if ((ev.which && ev.which === 13) || (ev.keyCode && ev.keyCode === 13)) {
            var txt = $(this).val();
            try {                
                $("#result").text(arithmetics.parse(txt));
            } catch (ex) {
                $("#message").text(ex);
            }       
        }
    });

});