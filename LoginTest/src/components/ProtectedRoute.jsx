import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export default function ProtectedRoute({ children })
{
    const { user, loading } = useAuth();
    
    console.log("Auth state:", { user, loading });
    
    if(loading) {
        return(
            <div className="flex Justify-center items-center h-screen">
                Loading...
            </div>
        );
    }

    if(! user){
        return <Navigate to="/" replace/>;
    }
    
    return children;
}