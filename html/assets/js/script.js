var timeleft;
var timer;
var message;
var restartBy;

function fancyTimeFormat(duration) {
    const hrs = ~~(duration / 3600);
    const mins = ~~((duration % 3600) / 60);
    const secs = ~~duration % 60;
    let ret = "";
    if (hrs > 0) {
        ret += "<span style='color:yellow'>" + hrs + "</span> hours" + (mins < 10 ? "<span style='color:yellow'>0</span>" : "");
    }
    if (mins > 0) {
        ret += "<span style='color:yellow'>" + mins + "</span> mins " + (secs < 10 ? "<span style='color:yellow'>0</span>" : "");
    }
    ret += "<span style='color:yellow'>" + secs + "</span> secs";
    return ret;
}

function StopTimer() {
    clearInterval(timer);
}

function StartTimer() {
    timer = setInterval(function () {
        timeleft = timeleft - 1;
        document.getElementById("reason").innerHTML = restartBy
        document.getElementById("count").innerHTML = "<span style='color:white'>" + message + "</span> " + fancyTimeFormat(timeleft);
        if (timeleft <= 0) { clearInterval(timer); } 
    }, 1000);

    if (timer) {
        $(".container").css("display", "block");
    }
}

window.addEventListener('message', function (event) {
    if (event.data.open) {
        restartBy = event.data.restartBy;
        message = event.data.message;
        timeleft = event.data.secs;
        StartTimer();
    }
});
