/////VARIABLES/////
let canvas = null;
let ctx = null;
let pourcent = 0;

/////INITIALIZATION/////
scratch();
//TEXT
setRewardText();

/////FUNCTIONS/////
function resetTicket()
{
    pourcent = 0;
    document.querySelector('body').style.display = "none";
    document.getElementById('ticket').style.backgroundColor = "rgba(0,0,0,.3)";
    document.getElementById('rewardText').innerText = "";
    ctx.globalCompositeOperation = 'source-over';
    ctx.clearRect(0,0, canvas.width, canvas.height);
    ctx.fillStyle = "gray";
    ctx.fillRect(0, 0, canvas.width, canvas.height);
}

function setRewardText()
{
    const rewardText = document.createElement('h2');
    rewardText.setAttribute('id', 'rewardText');
    rewardText.style.fontSize = "100px";
    rewardText.style.color = "white";
    rewardText.style.textShadow = "15px 10px 15px black";
    rewardText.style.textAlign = "center";
    rewardText.style.width = "250px";
    rewardText.style.position = "absolute";
    rewardText.style.margin = "430px 200px";
    rewardText.style.zIndex = "1";
    document.getElementById('ticket').appendChild(rewardText);
}

function scratch()
{
    let isClicked = false

    const audio = document.querySelector('#audio');
    audio.src = "scratch.mp3";

    canvas = document.createElement('canvas');
    canvas.setAttribute('id', 'canvas');
    canvas.style.width = "448px";
    canvas.style.height = "240px";
    canvas.style.borderRadius = "50px";
    canvas.style.position = "absolute";
    canvas.style.margin = "23em 6em"
    canvas.style.zIndex = "2";
    canvas.style.cursor = "url('coin.png'), auto";

    ctx = canvas.getContext('2d');
    ctx.fillStyle = "gray";
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    canvas.addEventListener('pointerdown', (event) => { if(pourcent < 150) isClicked = true; })
    canvas.addEventListener('pointerup', (event) => { if(pourcent < 150) isClicked = false; })
    canvas.addEventListener('mousemove', (event) => {
        if(isClicked) {
            if(pourcent < 150) { // time to stop
                const coords = getCursorPosition(event);
                const x = coords.x, y = coords.y;

                let width = canvas.width, height = canvas.height;
                if(!(x > width - 1 || x <= 0 || y > height - 1 || y <= 0)) // check canvas size for optimization and bugs
                {
                    audio.play()
                    drawPixel(x, y, 15);
                    pourcent++
                }else{
                    isClicked = false;
                    return
                }
            }else{
                isClicked = false;
                sendLuaMessage()
            }
        }
    })

    document.getElementById('ticket').appendChild(canvas);
}

function getCursorPosition(event)
{
    var rect = canvas.getBoundingClientRect(), // abs. size of element
    scaleX = canvas.width / rect.width,    // relationship bitmap vs. element for x
    scaleY = canvas.height / rect.height;  // relationship bitmap vs. element for y

    return {
        x: (event.clientX - rect.left) * scaleX,   // scale mouse coordinates after they have
        y: (event.clientY - rect.top) * scaleY     // been adjusted to be relative to element
    }
}

function drawPixel(coordX, coordY, radius)
{
    ctx.beginPath();
    ctx.globalCompositeOperation = 'destination-out';
    ctx.arc(coordX, coordY, radius, 0, Math.PI*2, true);
    ctx.fill();
    ctx.closePath();
}
