function tabs(spinner_label) {
    $(function() {
        $('#tabs').tabs({ cache: true, spinner: spinner_label });
    });
}

function collectText(elements) {
    var points = [];
    $(elements).each(function(n, element) {
        points.push([n, $(element).text()]);
    });
    return points;
}

function collectInt(elements) {
    var points = [];
    $(elements).each(function(n, element) {
        points.push([n, parseInt($(element).text())]);
    });
    return points;
}

function reverse(points) {
    $.each(points, function(n, point) {
        points[n] = [point[1], point[0]];
    });
    return points;
}
