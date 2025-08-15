// MongoDB initialization script
db = db.getSiblingDB('socialmedia');

// Create collections
db.createCollection('users');
db.createCollection('posts');
db.createCollection('chats');
db.createCollection('messages');

// Create indexes for better performance
db.users.createIndex({ "username": 1 }, { unique: true });
db.users.createIndex({ "email": 1 }, { unique: true, sparse: true });
db.posts.createIndex({ "userId": 1 });
db.posts.createIndex({ "createdAt": -1 });
db.chats.createIndex({ "members": 1 });
db.messages.createIndex({ "chatId": 1 });
db.messages.createIndex({ "createdAt": -1 });

print('Database initialized successfully');
