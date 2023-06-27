import express from "express";

const app = express();
const PORT = 3000;

// Sample data - Replace with your own data source or database connection
const users = [
    { id: 1, name: 'John Doe' },
    { id: 2, name: 'Jane Smith' },
    { id: 3, name: 'Bob Johnson' }
];

// Endpoint to retrieve all users
app.get('/customers', (req, res) => {
    res.json(users);
});

// Endpoint to retrieve a specific user by ID
app.get('/customers/:id', (req, res) => {
    const { id } = req.params;
    const user = users.find(u => u.id === parseInt(id));

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
