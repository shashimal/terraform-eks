import express from "express";

const app = express();
const PORT = 3002;

// Sample data - Replace with your own data source or database connection
const orders = [
    { id: 1, customer_id: 1, price: 2500 },
    { id: 2, customer_id: 2, price: 300 }
];

// Endpoint to retrieve all users
app.get('/orders', (req, res) => {
    res.json(orders);
});

// Endpoint to retrieve a specific user by ID
app.get('/orders/customer/:id', (req, res) => {
    const { id } = req.params;
    const user = orders.find(o => o.customer_id === parseInt(id));

    if (user) {
        res.json(user);
    } else {
        res.status(404).json({ message: 'User not found' });
    }
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is listening on port ${PORT}`);
});
