# MEDIA - Social Media Clone

A full-stack social media application built with React.js, Node.js, Express.js, MongoDB, and Socket.io. This platform allows users to connect, share posts, chat in real-time, and manage their profiles.

## 🌟 Features

### 🔐 Authentication & Authorization
- User registration and login with JWT authentication
- Password encryption using bcrypt
- Secure route protection
- Session management with Redux

### 👤 User Profiles
- Complete profile management system
- Profile and cover photo uploads
- Editable user information (bio, location, work, relationship status)
- Follower/Following system
- Profile statistics (followers, following, posts count)

### 📝 Posts & Content
- Create, share, and view posts
- Image upload for posts
- Like/unlike functionality
- Post interaction tracking
- Timeline feed with all posts
- User-specific post filtering

### 💬 Real-time Chat System
- One-on-one messaging
- Real-time message delivery using Socket.io
- Online/offline user status
- Message history
- Emoji support in messages
- File sharing capabilities

### 🔍 Social Features
- User discovery and search
- Follow/Unfollow users
- Trending topics
- Activity feed
- User suggestions

## 🛠️ Tech Stack

### Frontend
- **React.js** - User interface framework
- **Redux** - State management
- **React Router** - Navigation and routing
- **Axios** - HTTP client for API calls
- **Socket.io-client** - Real-time communication
- **Mantine UI** - Component library
- **React Icons** - Icon components
- **Timeago.js** - Time formatting

### Backend
- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **MongoDB** - NoSQL database
- **Mongoose** - MongoDB object modeling
- **JWT** - Authentication tokens
- **Bcrypt** - Password hashing
- **Multer** - File upload handling
- **Socket.io** - Real-time communication
- **CORS** - Cross-origin resource sharing

## 📁 Project Structure

```
SocialMedia/
├── client/                    # React frontend
│   ├── src/
│   │   ├── components/        # Reusable UI components
│   │   ├── pages/            # Page components
│   │   ├── actions/          # Redux actions
│   │   ├── reducers/         # Redux reducers
│   │   ├── api/              # API request functions
│   │   ├── store/            # Redux store configuration
│   │   └── Data/             # Static data files
│   ├── public/               # Public assets
│   ├── Dockerfile            # Client Docker configuration
│   ├── nginx.conf            # Nginx configuration
│   └── .dockerignore         # Docker ignore file
├── server/                   # Express backend
│   ├── controllers/          # Route controllers
│   ├── models/               # Database models
│   ├── routes/               # API routes
│   ├── middleware/           # Custom middleware
│   ├── public/               # Uploaded files
│   ├── Dockerfile            # Server Docker configuration
│   └── .dockerignore         # Docker ignore file
├── socket/                   # Socket.io server
│   ├── Dockerfile            # Socket Docker configuration
│   └── .dockerignore         # Docker ignore file
├── k8s/                      # Kubernetes configurations
│   ├── namespace.yaml        # Kubernetes namespace
│   ├── secrets.yaml          # Secret configurations
│   ├── configmap.yaml        # ConfigMap
│   ├── persistent-volumes.yaml # Storage configurations
│   ├── mongodb.yaml          # MongoDB deployment
│   ├── server.yaml           # Server deployment
│   ├── socket.yaml           # Socket deployment
│   ├── client.yaml           # Client deployment
│   ├── ingress.yaml          # Ingress configuration
│   └── hpa.yaml              # Horizontal Pod Autoscaler
├── docker-compose.yml        # Docker Compose configuration
├── mongo-init.js            # MongoDB initialization script
├── deploy.sh               # Kubernetes deployment script
├── cleanup.sh              # Kubernetes cleanup script
└── README.md               # Project documentation
```

## 🚀 Installation & Setup

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (local or cloud instance)
- npm or yarn package manager

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/social-media-clone.git
cd social-media-clone/SocialMedia
```

### 2. Setup Backend Server
```bash
cd server
npm install
```

Create a `.env` file in the server directory:
```env
MONGODB_CONNECTION=your_mongodb_connection_string
JWTKEY=your_jwt_secret_key
PORT=5000
```

Start the server:
```bash
npm start
```

### 3. Setup Socket Server
```bash
cd socket
npm install
npm start
```

### 4. Setup Frontend Client
```bash
cd client
npm install
```

Create a `.env` file in the client directory:
```env
REACT_APP_PUBLIC_FOLDER=http://localhost:5000/images/
```

Start the React application:
```bash
npm start
```

## 🐳 Docker Deployment

### Using Docker Compose (Recommended for Local Development)

1. **Make sure Docker and Docker Compose are installed**

2. **Clone and navigate to the project**
```bash
git clone https://github.com/AbdulWahab938/SocialMedia.git
cd SocialMedia
```

3. **Build and run with Docker Compose**
```bash
docker-compose up --build
```

4. **Access the application**
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- Socket.io: http://localhost:8800
- MongoDB: localhost:27017

5. **Stop the application**
```bash
docker-compose down
```

### Manual Docker Build

Build individual services:

```bash
# Build client
docker build -t socialmedia-client:latest ./client

# Build server  
docker build -t socialmedia-server:latest ./server

# Build socket server
docker build -t socialmedia-socket:latest ./socket
```

## ☸️ Kubernetes Deployment

### Prerequisites
- Kubernetes cluster (minikube, Docker Desktop, or cloud provider)
- kubectl configured
- Docker installed

### Quick Deployment

1. **Run the automated deployment script**
```bash
./deploy.sh
```

2. **Add to your hosts file**
```bash
echo "127.0.0.1 socialmedia.local" | sudo tee -a /etc/hosts
```

3. **Access the application**
- Frontend: http://socialmedia.local

### Manual Kubernetes Deployment

1. **Build Docker images**
```bash
docker build -t socialmedia-client:latest ./client
docker build -t socialmedia-server:latest ./server  
docker build -t socialmedia-socket:latest ./socket
```

2. **Deploy to Kubernetes**
```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Apply configurations
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/persistent-volumes.yaml

# Deploy services
kubectl apply -f k8s/mongodb.yaml
kubectl apply -f k8s/server.yaml
kubectl apply -f k8s/socket.yaml
kubectl apply -f k8s/client.yaml

# Setup ingress and autoscaling
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml
```

3. **Check deployment status**
```bash
kubectl get pods -n socialmedia
kubectl get services -n socialmedia
```

4. **Clean up (when needed)**
```bash
./cleanup.sh
```

### Kubernetes Features

- **High Availability**: Multiple replicas for server and client
- **Auto-scaling**: HPA based on CPU and memory usage
- **Persistent Storage**: MongoDB data and uploaded files persist
- **Load Balancing**: Traffic distributed across replicas
- **Health Checks**: Liveness and readiness probes
- **Resource Management**: CPU and memory limits/requests
- **Ingress**: Single entry point with path-based routing

### Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React Client  │    │  Express Server │    │  Socket.io      │
│   (Port 80)     │◄──►│   (Port 5000)   │◄──►│   (Port 8800)   │
│   2 replicas    │    │   2 replicas    │    │   1 replica     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       
         └───────────────────────┼───────────────────────┘
                                 │
                        ┌─────────────────┐
                        │    MongoDB      │
                        │   (Port 27017)  │
                        │   1 replica     │
                        └─────────────────┘
```

## 🌐 API Endpoints

### Authentication Routes
- `POST /auth/register` - Register new user
- `POST /auth/login` - User login

### User Routes
- `GET /user/:id` - Get user by ID
- `PUT /user/:id` - Update user profile
- `PUT /user/:id/follow` - Follow/Unfollow user
- `GET /user/:id/followers` - Get user followers

### Post Routes
- `GET /posts` - Get all posts
- `GET /posts/:id` - Get post by ID
- `POST /posts` - Create new post
- `PUT /posts/:id` - Update post
- `DELETE /posts/:id` - Delete post
- `PUT /posts/:id/like` - Like/Unlike post

### Chat Routes
- `POST /chat` - Create new chat
- `GET /chat/:userId` - Get user chats
- `GET /chat/find/:firstId/:secondId` - Find chat between users

### Message Routes
- `POST /message` - Send message
- `GET /message/:chatId` - Get chat messages

### Upload Routes
- `POST /upload` - Upload images

## 🔧 Configuration

### Database Schema

#### User Model
```javascript
{
  username: String (required),
  password: String (required),
  firstname: String (required),
  lastname: String (required),
  isAdmin: Boolean,
  profilePicture: String,
  coverPicture: String,
  about: String,
  livesIn: String,
  worksAt: String,
  relationship: String,
  country: String,
  followers: Array,
  following: Array
}
```

#### Post Model
```javascript
{
  userId: String (required),
  desc: String (required),
  likes: Array,
  image: String,
  createdAt: Date
}
```

#### Chat Model
```javascript
{
  members: Array
}
```

#### Message Model
```javascript
{
  chatId: String,
  senderId: String,
  text: String
}
```

## 🎨 UI Components

### Main Components
- **ProfileCard** - User profile display
- **PostShare** - Create new posts
- **Posts** - Display posts feed
- **ChatBox** - Real-time messaging interface
- **FollowersCard** - Show followers/following
- **InfoCard** - User information display
- **LogoSearch** - Search functionality
- **TrendCard** - Trending topics

### Pages
- **Home** - Main timeline and feed
- **Profile** - User profile management
- **Auth** - Login/Register forms
- **Chat** - Messaging interface

## 🔐 Security Features

- JWT token-based authentication
- Password hashing with bcrypt
- Protected routes and middleware
- CORS configuration
- Input validation and sanitization
- Secure file upload handling

## 📱 Responsive Design

The application is fully responsive and works on:
- Desktop computers
- Tablets
- Mobile devices

## 🚦 Getting Started

1. **Register/Login**: Create an account or login with existing credentials
2. **Setup Profile**: Add profile picture, cover photo, and personal information
3. **Connect**: Find and follow other users
4. **Share**: Create and share posts with images
5. **Chat**: Start conversations with other users
6. **Interact**: Like posts and engage with the community

## ⚙️ Environment Configuration

### Development Environment

1. **Copy environment templates**
```bash
cp server/.env.example server/.env
cp client/.env.example client/.env
```

2. **Update server/.env with your values**
```env
NODE_ENV=development
PORT=5000
MONGODB_CONNECTION=mongodb://localhost:27017/socialmedia
JWTKEY=your_super_secret_jwt_key_here
```

3. **Update client/.env with your values**
```env
REACT_APP_PUBLIC_FOLDER=http://localhost:5000/images/
REACT_APP_API_URL=http://localhost:5000
REACT_APP_SOCKET_URL=http://localhost:8800
```

### Production Environment

For production deployment, ensure you:

1. **Change default passwords** in `k8s/secrets.yaml`
2. **Use strong JWT secret** 
3. **Configure proper domain names** in ingress
4. **Set up SSL certificates**
5. **Configure monitoring and logging**
6. **Set resource limits** appropriately
7. **Use managed MongoDB** (MongoDB Atlas, etc.)

### Security Considerations

- Never commit `.env` files to version control
- Use Kubernetes secrets for sensitive data
- Enable MongoDB authentication in production
- Use HTTPS in production
- Implement rate limiting
- Regular security updates for dependencies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- React.js community for excellent documentation
- MongoDB for the robust database solution
- Socket.io for real-time communication capabilities
- All open-source contributors who made this project possible

## 📧 Contact

For any questions or suggestions, please feel free to reach out:

- GitHub: [@AbdulWahab938](https://github.com/AbdulWahab938)
- Project Link: [https://github.com/AbdulWahab938/SocialMedia](https://github.com/AbdulWahab938/SocialMedia)

---

**Note**: This is a learning project and should not be used in production without additional security measures and optimizations.
