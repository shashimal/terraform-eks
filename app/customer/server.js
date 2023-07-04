import express, {raw} from "express";
import axios from "axios";
import AWS from "aws-sdk";

const app = express();
const PORT = 3000;

const s3 = new AWS.S3();
const sqs = new AWS.SQS();


// Sample data - Replace with your own data source or database connection
const customers = [
    { id: 1, name: 'John Doe' },
    { id: 2, name: 'Jane Smith' },
    { id: 3, name: 'Bob Johnson' }
];

// Endpoint to retrieve all customers
app.get('/customers', (req, res) => {
    res.json(customers);
});

// Endpoint to retrieve a specific user by ID
app.get('/customers/:id', (req, res) => {
    const { id } = req.params;
    const customer = customers.find(u => u.id === parseInt(id));

    if (customer) {
        res.json(customer);
    } else {
        res.status(404).json({ message: 'User not found' });
    }
});

app.get('/customers/orders/:id', async (req, res)=> {
    const { id } = req.params;
    const customerOrders = await axios.get("http://order:3002/orders/customer/"+id);
    const data = customerOrders.data;
    res.json(data);
})

//Simple APIs to test service account
app.get('/reads3', async (req, res) => {
    s3.listBuckets((err, data) => {
        if (err) {
            console.error('Error:', err);
            res.status(500).send('Error retrieving bucket list');
        } else {
            const bucketNames = data.Buckets.map((bucket) => bucket.Name);
            res.json(bucketNames);
        }
    });
});

app.post('/sqs', (req, res) => {
    const message  = "test message";

    const params = {
        QueueUrl: 'https://sqs.ap-southeast-1.amazonaws.com/793209430381/test-eks', // Replace with your SQS queue URL
        MessageBody: JSON.stringify(message),
    };

    sqs.sendMessage(params, (err, data) => {
        if (err) {
            console.error('Error:', err);
            res.status(500).send('Error pushing data to SQS');
        } else {
            res.send('Data pushed to SQS successfully');
        }
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is listening on port ${PORT}`);
});
