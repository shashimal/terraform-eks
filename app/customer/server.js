import express, {raw} from "express";
import axios from "axios";

const app = express();
const PORT = 3000;

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

// Start the server
app.listen(PORT, () => {
    console.log(`Server is listening on port ${PORT}`);
});
