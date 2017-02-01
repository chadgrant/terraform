'use strict'

const EC2_INSTANCE_LAUNCH_ERROR = {
  "EventSource": "aws:sns",
  "EventVersion": "1.0",
  "EventSubscriptionArn": "arn:aws:sns:us-east-1:670597124105:stg-api-autoscale-life:3f5b53ad-3e65-45f1-82d9-cab0760423ef",
  "Sns": {
      "Type": "Notification",
      "MessageId": "aeaa9355-b657-567e-b741-dc05a83dae38",
      "TopicArn": "arn:aws:sns:us-east-1:670597124105:stg-api-autoscale-life",
      "Subject": "Auto Scaling: termination for group \"stg-api-artists-4g9ng\"",
      "Message": "{\"Progress\":100,\"AccountId\":\"670597124105\",\"Description\":\"Launching a new EC2 instance: i-00cbf3b05ff7ed335.  Status Reason: Instance failed to complete user's Lifecycle Action: Lifecycle Action with token b5315916-5bb8-4dda-8aaa-9da7aed5f654 was abandoned: Lifecycle Action Completed with ABANDON Result\",\"RequestId\":\"806370f7-44da-4ffa-af17-e12878fbc189\",\"EndTime\":\"2017-01-20T03:11:22.000Z\",\"AutoScalingGroupARN\":\"arn:aws:autoscaling:us-east-1:670597124105:autoScalingGroup:f227c72d-c512-4e5b-b283-269b61a94fa9:autoScalingGroupName/stg-api-admin-l87em\",\"ActivityId\":\"806370f7-44da-4ffa-af17-e12878fbc189\",\"StartTime\":\"2017-01-20T03:09:36.668Z\",\"Service\":\"AWS Auto Scaling\",\"Time\":\"2017-01-20T03:11:23.096Z\",\"EC2InstanceId\":\"i-00cbf3b05ff7ed335\",\"StatusCode\":\"Cancelled\",\"StatusMessage\":\"Instance failed to complete user's Lifecycle Action: Lifecycle Action with token b5315916-5bb8-4dda-8aaa-9da7aed5f654 was abandoned: Lifecycle Action Completed with ABANDON Result\",\"Details\":{\"Subnet ID\":\"subnet-df4dd6a9\",\"Availability Zone\":\"us-east-1a\"},\"AutoScalingGroupName\":\"stg-api-admin-l87em\",\"Cause\":\"At 2017-01-20T03:09:16Z a user request update of AutoScalingGroup constraints to min: 1, max: 4, desired: 1 changing the desired capacity from 0 to 1.  At 2017-01-20T03:09:34Z an instance was started in response to a difference between desired and actual capacity, increasing the capacity from 0 to 1.\",\"Event\":\"autoscaling:EC2_INSTANCE_LAUNCH_ERROR\"}",
      "Timestamp": "2016-03-01T22:48:10.198Z",
      "SignatureVersion": "1",
      "Signature": "eKrutDItG0hd8/iRDg7JSfG1Y2qK/7d/t5e3pfTk19JyoLa6DG+HZHmaxxgNTgI30kIYezGDkLtw78EWx0wDnThsu0+qWMWk3iqu+bAiyUeQwZ2Edwy4RyDiWHYrujCP2Uc4En0h05rMxDaGLexVD9dYWEuG1RohNMDfzkWn0r4zbxIiJbp18215WQUDwlv0iA7TydWCRAaIICec9eG60+LNBd+fABwMINj/7oznP3ndP239t+Cyt/cZNTJlbbe7x6TPLEOtQtZnWC8Fc9xs8owJdAwLr0RA6zNSGm5aH9ziJ1AjsAgqK+MP95SwsZ5RO1Cyti69yV0pZvM1SsFJ3w==",
      "SigningCertUrl": "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem",
      "UnsubscribeUrl": "https://sns.us-east-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-east-1:670597124105:stg-api-autoscale-life:3f5b53ad-3e65-45f1-82d9-cab0760423ef",
      "MessageAttributes": {}
    }
  };

const EC2_INSTANCE_TERMINATE = {
    "EventSource": "aws:sns",
    "EventVersion": "1.0",
    "EventSubscriptionArn": "arn:aws:sns:us-east-1:670597124105:stg-api-autoscale-life:3f5b53ad-3e65-45f1-82d9-cab0760423ef",
    "Sns": {
        "Type": "Notification",
        "MessageId": "aeaa9355-b657-567e-b741-dc05a83dae38",
        "TopicArn": "arn:aws:sns:us-east-1:670597124105:stg-api-autoscale-life",
        "Subject": "Auto Scaling: termination for group \"stg-api-artists-4g9ng\"",
        "Message": "{\"StatusCode\":\"InProgress\",\"Service\":\"AWS Auto Scaling\",\"AutoScalingGroupName\":\"stg-api-artists-4g9ng\",\"Description\":\"Terminating EC2 instance: i-c50caa41\",\"ActivityId\":\"32d4cc5c-83de-4c55-b2b6-41724991ab1e\",\"Event\":\"autoscaling:EC2_INSTANCE_TERMINATE\",\"Details\":{\"Availability Zone\":\"us-east-1a\",\"Subnet ID\":\"subnet-e0893a96\"},\"AutoScalingGroupARN\":\"arn:aws:autoscaling:us-east-1:670597124105:autoScalingGroup:0c9bf425-0164-4081-9ce6-babffac01559:autoScalingGroupName/stg-api-artists-4g9ng\",\"Progress\":50,\"Time\":\"2016-03-01T22:48:10.140Z\",\"AccountId\":\"670597124105\",\"RequestId\":\"32d4cc5c-83de-4c55-b2b6-41724991ab1e\",\"StatusMessage\":\"\",\"EndTime\":\"2016-03-01T22:48:10.140Z\",\"EC2InstanceId\":\"i-c50caa41\",\"StartTime\":\"2016-03-01T22:45:20.942Z\",\"Cause\":\"At 2016-03-01T22:45:20Z an instance was taken out of service in response to a ELB system health check failure.\"}",
        "Timestamp": "2016-03-01T22:48:10.198Z",
        "SignatureVersion": "1",
        "Signature": "eKrutDItG0hd8/iRDg7JSfG1Y2qK/7d/t5e3pfTk19JyoLa6DG+HZHmaxxgNTgI30kIYezGDkLtw78EWx0wDnThsu0+qWMWk3iqu+bAiyUeQwZ2Edwy4RyDiWHYrujCP2Uc4En0h05rMxDaGLexVD9dYWEuG1RohNMDfzkWn0r4zbxIiJbp18215WQUDwlv0iA7TydWCRAaIICec9eG60+LNBd+fABwMINj/7oznP3ndP239t+Cyt/cZNTJlbbe7x6TPLEOtQtZnWC8Fc9xs8owJdAwLr0RA6zNSGm5aH9ziJ1AjsAgqK+MP95SwsZ5RO1Cyti69yV0pZvM1SsFJ3w==",
        "SigningCertUrl": "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem",
        "UnsubscribeUrl": "https://sns.us-east-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-east-1:670597124105:stg-api-autoscale-life:3f5b53ad-3e65-45f1-82d9-cab0760423ef",
        "MessageAttributes": {}
    }
};

const EC2_INSTANCE_LAUNCH = {
    "EventSource": "aws:sns",
    "EventVersion": "1.0",
    "EventSubscriptionArn": "arn:aws:sns:us-east-1:670597124105:stg-api-autoscale-life:3f5b53ad-3e65-45f1-82d9-cab0760423ef",
    "Sns": {
        "Type": "Notification",
        "MessageId": "e71f6aea-3c78-5ad0-adcb-25ba1d335522",
        "TopicArn": "arn:aws:sns:us-east-1:670597124105:stg-api-autoscale-life",
        "Subject": "Auto Scaling: launch for group \"stg-api-artists-4g9ng\"",
        "Message": "{\"StatusCode\":\"InProgress\",\"Service\":\"AWS Auto Scaling\",\"AutoScalingGroupName\":\"stg-api-artists-4g9ng\",\"Description\":\"Launching a new EC2 instance: i-3f7dd0bb\",\"ActivityId\":\"d6bc4526-abfd-4e9a-8c23-8418af26a572\",\"Event\":\"autoscaling:EC2_INSTANCE_LAUNCH\",\"Details\":{\"Availability Zone\":\"us-east-1a\",\"Subnet ID\":\"subnet-e0893a96\"},\"AutoScalingGroupARN\":\"arn:aws:autoscaling:us-east-1:670597124105:autoScalingGroup:0c9bf425-0164-4081-9ce6-babffac01559:autoScalingGroupName/stg-api-artists-4g9ng\",\"Progress\":50,\"Time\":\"2016-03-01T23:00:27.282Z\",\"AccountId\":\"670597124105\",\"RequestId\":\"d6bc4526-abfd-4e9a-8c23-8418af26a572\",\"StatusMessage\":\"\",\"EndTime\":\"2016-03-01T23:00:27.282Z\",\"EC2InstanceId\":\"i-3f7dd0bb\",\"StartTime\":\"2016-03-01T22:45:53.535Z\",\"Cause\":\"At 2016-03-01T22:45:51Z an instance was started in response to a difference between desired and actual capacity, increasing the capacity from 1 to 2.\"}",
        "Timestamp": "2016-03-01T23:00:27.343Z",
        "SignatureVersion": "1",
        "Signature": "Ws2zKw0KwjkCDD7rTB1Cq0KSet2lmCRd5BN5KztIyAPc2drwgDooE9wjL/JtkSE0lxBp9W+vii03ZUMwszihcEw+sbIBA/twgxZhfJk/qk18czO4R20jpsr6+eF4D08NPUsqqT+xBTaYy+qksMdGF8K127IhfAjXe3pVGgai3FLCqFelyWSqJotAYj4em+IOxCWb7QLTan2sgnW7IC2yrtfZHd2KXIJnnDZfFoazPrSTBCuINpyY5a3Z/Q6w8mm39S+2fb2QUQvYI5XbO6lWj6wgXta3Cemq/IT4Vk8w3XBlr3EYPir/jblZ0Z5OkCe1pGxl4XphEM+c6P6gaffeeg==",
        "SigningCertUrl": "https://sns.us-east-1.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem",
        "UnsubscribeUrl": "https://sns.us-east-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-east-1:670597124105:stg-api-autoscale-life:3f5b53ad-3e65-45f1-82d9-cab0760423ef",
        "MessageAttributes": {}
    }
};

exports.TEST_RECORDS = {
    "Records": [EC2_INSTANCE_LAUNCH, EC2_INSTANCE_TERMINATE, EC2_INSTANCE_LAUNCH_ERROR]
};
