function charts_earlier() {
    $('#offset').val(parseInt($('#offset').val()) + parseInt($('#limit').val()));
    $('#chart_form').trigger("submit");
}

function charts_later() {
    $('#offset').val(parseInt($('#offset').val()) - parseInt($('#limit').val()));
    if($('#offset').val() < 1) {
        $('#offset').val(1);
    }
    $('#chart_form').trigger("submit");
}

function charts_previous() {
    $('#page').val(parseInt($('#page').val()) - 1);
    if($('#page').val() < 1) {
        $('#page').val(1);
    }
    $('#chart_form').trigger("submit");
}

function charts_next() {
    $('#page').val(parseInt($('#page').value) + 1);
    $('#chart_form').trigger("submit");
}

function save_image() { 
  with(window.open('', charts_to_image_title).document) {
    write('<html><head><title>' + charts_to_image_title + '<\/title><\/head><body><img src="data:image/png;base64,' + $$('#' + charts_to_image_id)[0].get_img_binary() + '" /><\/body><\/html>')
  }
}
