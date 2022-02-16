const AWS = require('aws-sdk');

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {

    console.log('Handler triggered -> CloudWatch')

    let body;
    let statusCode = '200';
    const headers = {
        'Content-Type': 'application/json',
    };

    const eventBody = JSON.parse(event.body)

    try {
        await dynamo.put({ TableName: 'tasks', Item: eventBody }).promise();
        body = {
            message: 'The task has been created successfully'
        }
    } catch (err) {
        statusCode = '400';
        body = err.message;
    } finally {
        body = JSON.stringify(body);
    }

    return {
        statusCode,
        body,
        headers,
    };
};
