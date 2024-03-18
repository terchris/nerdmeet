const { app } = require('@azure/functions');

app.http('DayOfWeekFunction', {
    methods: ['GET'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);
        
        // Array of day names
        const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        
        // Getting the current day of the week
        const currentDay = days[new Date().getDay()];

        // Returning the day of the week
        return { body: `Today is: ${currentDay}` };
    }
});


/* initial code
const { app } = require('@azure/functions');

app.http('DayOfWeekFunction', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);

        const name = request.query.get('name') || await request.text() || 'world';

        return { body: `Hello, ${name}!` };
    }
});
*/