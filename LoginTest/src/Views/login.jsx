import { Link, useNavigate} from "react-router-dom"
import { auth, provider } from "../firebase";
import { signInWithPopup } from "firebase/auth";


export default function  LoginPage(){
    
    const navigate = new useNavigate();

    const login = async () => {
    try {
      const result = await signInWithPopup(auth, provider);
      console.log("User:", result.user);
      alert("Signed in as: " + result.user.email);

      navigate("/todo");

    } catch (err) {
      console.error(err);
    }
    };

    return(
        <div className="flex flex-col gap-2">
            <h1>Login Pog</h1>
            <button 
            onClick={login}
            className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
            >
            Sign In with Google
            </button>
        </div>
    )
}