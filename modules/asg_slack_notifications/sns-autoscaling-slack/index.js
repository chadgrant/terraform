'use strict'
var util = require('util');
var https = require('https');

const EVENTS = {
  "autoscaling:EC2_INSTANCE_TERMINATE" : {
    color: "warning",
    text:"Instance Terminated",
    thumb_url: "http://shmector.com/_ph/12/379607462.png"
  },
  "autoscaling:EC2_INSTANCE_LAUNCH_ERROR" : {
    color: "warning",
    text:"Instance Launch Error",
    thumb_url: "http://previews.123rf.com/images/ratoca/ratoca1109/ratoca110900102/10584698-Notice-of-existence-of-error-Stock-Vector-error-warning.jpg"
  },
  "autoscaling:EC2_INSTANCE_TERMINATE_ERROR" : {
    color: "warning",
    text:"Instance Termination Error",
    thumb_url: "http://previews.123rf.com/images/ratoca/ratoca1109/ratoca110900102/10584698-Notice-of-existence-of-error-Stock-Vector-error-warning.jpg"
  },
  "autoscaling:EC2_INSTANCE_LAUNCH" : {
    color: "good",
    text: "Instance Launched",
    thumb_url: "http://images.all-free-download.com/images/graphiclarge/green_globe_up_arrow_560.jpg"
  }
};

exports.handler = function(sns_event, context, done) {
  let q = [];

  for(let i=0; i < sns_event.Records.length; i++) {
    let notification = JSON.parse(sns_event.Records[i].Sns.Message);
    let ev = EVENTS[notification.Event];
    let msg;

    if (ev) {
      let subject = process.env.environment_short_name.toUpperCase() + " - " + process.env.service.toUpperCase() + " - " + ev.text;
      msg = message(process.env.notification_slack_channel, "Auto Scaling", subject, ev.color, ev.thumb_url);
      msg.attachments.push(attachment(ev.color, ev.thumb_url, notification.EC2InstanceId, notification.Cause));
    }
    else {
      msg = message(process.env.notification_slack_channel_debug, "Auto Scaling", "STG Autoscaling event", "good", "");
      msg.attachments.push({ text : event.Records[i].Sns.Message });
    }
    q.push( send(msg) );
  }

  return Promise.all(q)
         .catch((err) => console.log(err))
         .then(function(){ done(); });
}

function message(channel, username, subject, color, thumb_url) {
  return {
      channel:  channel,
      username: username,
      text: subject,
      icon_url: "https://codurance.com/assets/img/custom/blog/aws-lambda.png",
      color: color,
      thumb_url: thumb_url,
      attachments : []
  };
}

function attachment(color, thumb, instanceId, cause) {
  return {
    color: color,
    thumb_url: thumb,
    fields : [
      { title: "Instance Id", value: instanceId, short:true},
      { title: "Cause", value: cause, short:false }
    ]
  }
}

function send(msg) {
  return new Promise((resolve, reject) => {
    let options = {
      port: 443,
      method: 'POST',
      hostname: 'hooks.slack.com',
      path: '/services/' + process.env.notification_slack_hook
    };
    let request = https.request(options, (response) => {
      if (response.statusCode < 200 || response.statusCode > 299) {
         reject(new Error('Failed to post data, status code: ' + response.statusCode));
       }
      response.on('data', resolve);
      response.on('end', resolve);
      response.on('error', reject);
    });
    request.on('error', reject);
    request.write(util.format("%j", msg));
    request.end();
  });
}
