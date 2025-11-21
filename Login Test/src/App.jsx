import { auth, provider } from "./firebase";
import { signInWithPopup } from "firebase/auth";

function App() {
  const login = async () => {
    try {
      const result = await signInWithPopup(auth, provider);
      console.log("User:", result.user);
      alert("Signed in as: " + result.user.email);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div style={{ padding: "40px" }}>
      <button onClick={login}>
        Sign In with Google
      </button>
    </div>
  );
}

export default App;
