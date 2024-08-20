const body = document.querySelector('body');
let reward = 0;

window.addEventListener('message', (event) => {
    let data = event.data;
    if(data.type === "ui" && data.scriptName === GetParentResourceName()) {
        reward = 0;
        body.style.display = "initial";
        document.getElementById('ticket').style.backgroundImage = "url('../images/"+data.ticket.image+"')";
        document.getElementById('rewardText').innerText = getRandomReward(data.ticket.reward)+"$";
    }
})

function sendLuaMessage()
{
    resetTicket();

    fetch(`https://${GetParentResourceName()}/js:givereward`, {
        method: 'POST',
        body: JSON.stringify({
            money: reward
        })
    });
}

function randomNumb(min, max)
{
    return Math.floor(min + Math.random() * (max - min)); // random number between config.min and config.max
}

function getRandomReward(ticketReward)
{
    reward = randomNumb(ticketReward.min, ticketReward.max);

    let loop = false
    do {
        loop = false;
        for(i=0;i<ticketReward.exceptedValues.length;i++) {
            if (reward == ticketReward.exceptedValues[i]) {
                loop = true;
                reward = randomNumb(ticketReward.min, ticketReward.max); 
            }
        }
    } while(loop);
    return reward;
}
