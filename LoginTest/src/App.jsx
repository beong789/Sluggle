import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter, createBrowserRouter, RouterProvider } from 'react-router-dom';
import LoginPage from './Views/login.jsx'
import TodoPage from './Views/todo.jsx'
import ErrorPage from "./Views/errorNotFound.jsx";
import TaskPage from "./Views/taskpage.jsx";
import ProtectedRoute from './components/ProtectedRoute.jsx';
import { AuthProvider } from './context/AuthContext';

const router = createBrowserRouter([
    {
      path: '/',
      element: <LoginPage/>,
      errorElement: <ErrorPage/>
    },
    {
      path: '/todo',
      element: (
        <ProtectedRoute>
          <TodoPage/>
        </ProtectedRoute>
      ),
      children: [
        {
          path: ':pageId',
          element: (
            <TaskPage/>
        )},
      ]
    },
  ]);

function App() {
  return (
    <AuthProvider>
      <RouterProvider router={router}/>
    </AuthProvider>
  );
}

export default App;
