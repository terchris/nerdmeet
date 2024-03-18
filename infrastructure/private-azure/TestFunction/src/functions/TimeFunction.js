const { app } = require('@azure/functions');

app.http('TimeFunction', {
    methods: ['GET'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);
        
        // Creating a new Date object and formatting the time string
        const currentTime = new Date().toLocaleTimeString();

        // Returning the current time
        return { body: `The current time is: ${currentTime}` };
    }
});

/* initial code
const { app } = require('@azure/functions');

app.http('TimeFunction', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);

        const name = request.query.get('name') || await request.text() || 'world';

        return { body: `Hello, ${name}!` };
    }
});
*/