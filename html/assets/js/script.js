var timeleft;
var timer;
var message;

function fancyTimeFormat(duration) {
    const hrs = ~~(duration / 3600);
    const mins = ~~((duration % 3600) / 60);
    const secs = ~~duration % 60;
    let ret = "";
    if (hrs > 0) {
        ret += "<span style='color:red'>" + hrs + "</span> hours" + (mins < 10 ? "<span style='color:red'>0</span>" : "");
    }
    if (mins > 0) {
        ret += "<span style='color:red'>" + mins + "</span> mins " + (secs < 10 ? "<span style='color:red'>0</span>" : "");
    }
    ret += "<span style='color:red'>" + secs + "</span> secs";
    return ret;
}

function StopTimer() {
    clearInterval(timer);
}

function StartTimer() {
    timer = setInterval(function () {
        timeleft = timeleft - 1;
        document.getElementById("count").innerHTML = "<span style='color:white'>" + message + "</span> " + fancyTimeFormat(timeleft);
        if (timeleft <= 0) { clearInterval(timer); } 
    }, 1000);
}

window.addEventListener('message', function (event) {
    if (event.data.open) {
        message = event.data.message;
        timeleft = event.data.secs;
        StartTimer();
    }
});